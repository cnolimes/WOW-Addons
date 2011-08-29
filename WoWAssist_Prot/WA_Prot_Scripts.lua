function WA_Prot_Frame_OnLoad()

	--================= Register Events =======================
	WA_Prot_Frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	WA_Prot_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	WA_Prot_Frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	WA_Prot_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	--================= Global Variables ===================
	WA_Prot_Enabled 				= false			-- Enables OnUpdate code execution
	WA_Prot_Class 					= "Warrior"
	WA_Prot_ShowDataTimeFactor 		= 0.180	-- Time prior to a GCD finish when the color box will be shown
	WA_Prot_MinimumThreatForDebuffs 	= 000000
	WA_Prot_GCD_Duration			= 1.5
	WA_Prot_HeroicStrikeRage		= 75
	WA_Prot_CleaveRage				= 75
	WA_Prot_InnerRageThreshold		= 85
	WA_Prot_Toggle_Do_1 			= true
	WA_Prot_Toggle_Do_2 			= true
	WA_Prot_Toggle_Do_3				= true

	--================= Ability To Key Mappings ===================
	ShieldSlam = 0.1
	Revenge = 0.2
	Devastate = 0.3
	Shockwave = 0.4
	ThunderClap = 0.5
	Rend = 0.6
	DemoShout = 0.7
	CommandingShout = 0.8
	HeroicStrike = 0.9
	Cleave = 1.0
	InnerRage = .95

	--================= Extra Function Mappings ===================
	Delay20 = 0.0
	Delay100 = 0.01
	Delay300 = 0.02
	Delay500 = 0.03
	Delay700 = 0.04	
	Delay900 = 0.05
	
	--================== Initialize Variables =====================
	ShieldSlamFinish = GetTime()
	RevengeFinish = GetTime()
	ThunderClapFinish = GetTime()
	ShockwaveFinish = GetTime()
	HeroicStrikeFinish = GetTime()
	CleaveFinish = GetTime()
	CommandingShoutFinish = GetTime()
end



function WA_Prot_Frame_OnEvent(self, event, ...)

	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...
	--print(event)
	if (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED") then
		_, _, _, _, WA_Prot_PointsSpent, _, _, _ = GetTalentTabInfo(3)	-- Check that enough points are spent in the right tree

		if (UnitClass("player") ~= WA_Prot_Class or WA_Prot_PointsSpent < 31) then
			WA_Prot_Frame:Hide()
			WA_Prot_Enabled = false
		else
			--================= Ability Toggles Config ===================
			WA_Prot_Frame:Show()
			_, _, InnerRageIcon, _, _, _, _, _, _ = GetSpellInfo("Inner Rage")
			_, _, ShockwaveIcon, _, _, _, _, _, _ = GetSpellInfo("Shockwave")
			_, _, BattleShoutIcon, _, _, _, _, _, _ = GetSpellInfo("Battle Shout")
			WA_Prot_ToggleIcon_1:SetTexture( InnerRageIcon)	
			WA_Prot_ToggleIcon_2:SetTexture(ShockwaveIcon)
			WA_Prot_ToggleIcon_3:SetTexture(BattleShoutIcon)

			WA_Prot_Enabled = true
		end
	end
	--if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
	--	if (arg4 == "Kaubell" and arg2 == "SPELL_CAST_SUCCESS") then
	--		print(arg10, " at ", arg1)
	--	end
	--end
end


function WA_Prot_Frame_OnUpdate()

	if (WA_Prot_Enabled == true) then
		Rage = UnitPower("player")	
		_, _, _, _, Threat = UnitDetailedThreatSituation("player", "target")
		if (Threat == nil) then
			Threat = 0
		end
		-- ============================== GCD ================================
		GCDStart, GCDDuration, _ = GetSpellCooldown("Devastate")
		if (GCDStart ~= 0) then
			
			GCDTimeLeft = GCDStart + GCDDuration - GetTime()
		else
			GCDTimeLeft = 0
		end

		-- ============================ Shield Slam =============================
		-- Outputs:
		-- ShieldSlamCD 	
		--------------------------------------
		ShieldSlamStart, ShieldSlamDuration, _ = GetSpellCooldown("Shield Slam")
		if (ShieldSlamStart ~= 0) then
			if (ShieldSlamDuration > WA_Prot_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				ShieldSlamFinish = ShieldSlamStart + ShieldSlamDuration
				ShieldSlamCD = ShieldSlamFinish - GetTime()
			else
				if (ShieldSlamFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (ShieldSlamFinish - (ShieldSlamStart + ShieldSlamDuration) - WA_Prot_ShowDataTimeFactor > 0) then
						ShieldSlamCD = 0
					else
						ShieldSlamCD = ShieldSlamFinish - GetTime()
					end
				else
					ShieldSlamCD = 0
				end
			end
			
		else
			ShieldSlamCD = 0
		end
		_, _, _, ShieldSlamCost, _, _, _, _, _ = GetSpellInfo("Shield Slam")
		if (Rage < ShieldSlamCost) then
			ShieldSlamCD = 30
		end

		if (ShieldSlamCD < WA_Prot_ShowDataTimeFactor) then
			ShieldSlamCD = 0
		end
		-- ============================ Revenge  ==============================
		-- Outputs:
		-- RevengeCD 	(0 if ready, 30 if not enough rage or unusable, 0 to 5 if on cooldown)
		--------------------------------------
		RevengeUsable, nomana = IsUsableSpell("Revenge")
		if (RevengeUsable ~= nil) then
			RevengeStart, RevengeDuration, _ = GetSpellCooldown("Revenge")
			if (RevengeStart ~= 0) then
				if (RevengeDuration > WA_Prot_GCD_Duration) then			-- Calc CD based on a non GCD duration 
					RevengeFinish = RevengeStart + RevengeDuration
					RevengeCD = RevengeFinish - GetTime()
				else
					if (RevengeFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
						if (RevengeFinish - (RevengeStart + RevengeDuration) - WA_Prot_ShowDataTimeFactor > 0) then
							RevengeCD = 0
						else
							RevengeCD = RevengeFinish - GetTime()
						end
					else
						RevengeCD = 0
					end
				end
			
			else
				RevengeCD = 0
			end
			_, _, _, RevengeCost, _, _, _, _, _ = GetSpellInfo("Revenge")
			if (Rage < RevengeCost) then
				RevengeCD = 30
			end
		else
			RevengeCD = 30
		end
		-- ============================ Devastate =============================
		-- Outputs:
		-- CanDevastate 	(true/false)
		--------------------------------------
		_, _, _, DevastateCost, _, _, _, _, _ = GetSpellInfo("Devastate")
		if (Rage < DevastateCost) then
			CanDevastate = false
		else
			CanDevastate = true
		end
		-- ============================ Shockwave ============================
		-- Outputs:
		-- ShockwaveCD 	(0 if ready, 30 if not enough rage, 0 to 17 if on cooldown)
		--------------------------------------
		ShockwaveStart, ShockwaveDuration , _ = GetSpellCooldown("Shockwave")
		if (ShockwaveStart ~= 0) then
			if (ShockwaveDuration > WA_Prot_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				ShockwaveFinish = ShockwaveStart + ShockwaveDuration
				ShockwaveCD = ShockwaveFinish - GetTime()
			else
				if (ShockwaveFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (ShockwaveFinish - (ShockwaveStart + ShockwaveDuration) - WA_Prot_ShowDataTimeFactor > 0) then
						ShockwaveCD = 0
					else
						ShockwaveCD = ShockwaveFinish - GetTime()
					end
				else
					ShockwaveCD = 0
				end
			end
			
		else
			ShockwaveCD = 0
		end

		_, _, _, ShockwaveCost, _, _, _, _, _ = GetSpellInfo("Shockwave")
		if (Rage < ShockwaveCost) then
			ShockwaveCD = 30
		end
		-- ============================ ThunderClap ===========================
		-- Outputs:
		-- ThunderClapCD 	
		--------------------------------------
		ThunderClapStart, ThunderClapDuration , _ = GetSpellCooldown("Thunder Clap")
		if (ThunderClapStart ~= 0) then
			if (ThunderClapDuration > WA_Prot_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				ThunderClapFinish = ThunderClapStart + ThunderClapDuration
				ThunderClapCD = ThunderClapFinish - GetTime()
			else
				if (ThunderClapFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (ThunderClapFinish - (ThunderClapStart + ThunderClapDuration) - WA_Prot_ShowDataTimeFactor > 0) then
						ThunderClapCD = 0
					else
						ThunderClapCD = ThunderClapFinish - GetTime()
					end
				else
					ThunderClapCD = 0
				end
			end
			
		else
			ThunderClapCD = 0
		end
		_, _, _, ThunderClapCost, _, _, _, _, _ = GetSpellInfo("Thunder Clap")
		if (Rage < ThunderClapCost) then
			ThunderClapCD = 30
		end
		-- Check for Redundant Debuffs
		ThunderClapName, _, _, _, _, ThunderClapDuration, ThunderClapExpirationTime, UnitCaster, _ = UnitDebuff("target", "Thunder Clap")
		if (ThunderClapName ~= nil) then
			ThunderClapTimeLeft = ThunderClapExpirationTime - GetTime()
		else
			ThunderClapTimeLeft = 0
		end
		IcyTouchName, _, _, _, _, _, _, _, _ = UnitDebuff("target", "Frost Fever")
		if (IcyTouchName ~= nil) then
			AttackSpeedSlowIsPresent = true
		else
			AttackSpeedSlowIsPresent = false
		end
		-- ============================ Rend ================================
		-- Outputs:
		-- RendCD
		--------------------------------------
		RendName, _, _, _, _, RendDuration, RendExpirationTime, UnitCaster, _ = UnitDebuff("target", "Rend")
		if (RendName ~= nil) then
			if (UnitCaster == "player") then
				RendCD = RendExpirationTime - GetTime()
			else
				RendCD = 0
			end
		else
			RendCD = 0	
		end		
		_, _, _, RendCost, _, _, _, _, _ = GetSpellInfo("Rend")
		if (Rage < RendCost) then
			RendCD = 30
		end
		-- ============================ DemoShout ============================
		-- Outputs:
		-- DemoShoutCD
		--------------------------------------
		DemoShoutName, _, _, _, _, DemoShoutDuration, DemoShoutExpirationTime, UnitCaster, _ = UnitDebuff("target", "Demoralizing Shout")
		if (DemoShoutName ~= nil) then
			DemoShoutCD = DemoShoutExpirationTime - GetTime()
		else
			DemoShoutCD = 0
		end		
		_, _, _, DemoShoutCost, _, _, _, _, _ = GetSpellInfo("Demoralizing Shout")
		if (Rage < DemoShoutCost) then
			DemoShoutCD = 30
		end
		-- ============================ Sunder Armor ============================
		-- Outputs:
		-- SunderArmorCount
		-- SunderArmorTimeLeft (0 if not up, 0 to 45 if up)
		--------------------------------------
		SunderArmorName, _, _, SunderArmorCount, _, SunderArmorDuration, SunderArmorExpirationTime, UnitCaster, _ = UnitDebuff("target", "Sunder Armor")
		if (SunderArmorName ~= nil) then
			SunderArmorTimeLeft = SunderArmorExpirationTime - GetTime()
		else
			SunderArmorCount = 0
			SunderArmorTimeLeft = 0
		end



		-- ============================ CommandingShout =======================
		-- Outputs:
		-- CanCommandingShout	(true/false)
		-- CommandingShoutCD	(0 if not up, 0 to 45 if up)
		-- CommandingShoutTimeLeft
		--------------------------------------
		CommandingShoutName, _, _, _, _, _, CommandingShoutExpirationTime, _, _, _, _ = UnitBuff("player", "Commanding Shout") 
		if (CommandingShoutName == nil) then
			CanCommandingShout = true
			CommandingShoutTimeLeft = 0
		else
			CommandingShoutTimeLeft = CommandingShoutExpirationTime - GetTime()
			CanCommandingShout = false		
		end
		CommandingShoutStart, CommandingShoutDuration , _ = GetSpellCooldown("Commanding Shout")
		if (CommandingShoutStart ~= 0) then
			if (CommandingShoutDuration > 1.5) then
				CommandingShoutFinish = CommandingShoutStart + CommandingShoutDuration
			end
		end
		CommandingShoutCD = CommandingShoutFinish - GetTime()
		if (CommandingShoutCD < 0) then
			CommandingShoutCD = 0
		end

		-- ============================ InnerRage =======================
		-- Outputs:
		-- InnerRageCD
		--------------------------------------
		InnerRageName, _, _, _, _, _, InnerRageExpirationTime, _, _, _, _ = UnitBuff("player", "Inner Rage") 
		if (InnerRageName == nil) then
			InnerRageCD = 0
		else
			InnerRageCD = InnerRageExpirationTime - GetTime()
		end

		-- ============================ HeroicStrike ===========================
		-- Outputs:
		-- HeroicStrikeCD
		--------------------------------------
		HeroicStrikeStart, HeroicStrikeDuration , _ = GetSpellCooldown("Heroic Strike")
		if (HeroicStrikeStart == 0) then
			HeroicStrikeCD = 0
		else
			HeroicStrikeCD = HeroicStrikeStart + HeroicStrikeDuration - GetTime()
		end
		-- ============================ Cleave ===============================
		-- Outputs:
		-- CleaveCD
		--------------------------------------
		CleaveStart, CleaveDuration , _ = GetSpellCooldown("Heroic Strike")
		if (CleaveStart == 0) then
			CleaveCD = 0
		else
			CleaveCD = CleaveStart + CleaveDuration - GetTime()
		end

		--====================================================================
		--============================== LOGIC TREE ===========================
		--====================================================================
		-- http://elitistjerks.com/f81/t110315-cataclysm_protection_warrior/

		-- =============== Single Target Logic ==================
		-- Shield Slam > Revenge > Rend > Devastate
		-- Note: A single Rend application is only worth using on a 30%-bleed debuffed single target if it ticks at least four times. 
		-- Unbuffed, it must tick all six times. Never refresh an existing Rend -- always wait for it to run its full duration or else you
		--  lose the initial application tick. Whenever possible, immediately follow up a Shield Slam with either a Revenge or Devastate. 
		-- The Sword and Board talent is most effective when it procs the first GCD after a Shield Slam is used. If it fails to proc, use 
		-- the remaining 2 GCDs to refresh debuffs/buffs as needed.Applying three Sunder Armor stacks should typically be a high
		--  priority, as should be applying damage-reducing debuffs such as Demoralizing Shout and Thunder Clap. The exact order 
		-- and urgency of applying debuffs isn't set in stone, and it's up to you to prioritize personal threat, group DPS, and reducing 
		-- incoming damage depending on the circumstances.
		
		if (GCDTimeLeft > WA_Prot_ShowDataTimeFactor) then							-- NOT inside spam window
			if (InnerRageCD == 0 and Rage >= WA_Prot_InnerRageThreshold and WA_Prot_Toggle_Do_1 == true ) then		-- Check Inner rage
				Spell1 = InnerRage
			elseif (HeroicStrikeCD == 0 and Rage > WA_Prot_HeroicStrikeRage) then					-- Check Heroic Strike
				Spell1 = HeroicStrike
			elseif ((GCDTimeLeft - WA_Prot_ShowDataTimeFactor) > .300) then						-- Check Longer Delay
				Spell1 = Delay300
			elseif ((GCDTimeLeft - WA_Prot_ShowDataTimeFactor) > .100) then						-- Check Medium Delay
				Spell1 = Delay100
			else
				Spell1 = Delay20									-- Else Short Delay
			end
		else											-- Inside spam window
			if (ShieldSlamCD == 0) then									-- Check for Shield Slam
				Spell1 = ShieldSlam
			elseif (SunderArmorCount < 3 or SunderArmorTimeLeft < 5) then						-- Stack Sunder Up
				Spell1 = Devastate
			elseif (ShieldSlamCD > 4.3) then									-- In GCD after SS, use Rev or Dev
				if (RevengeCD == 0) then
					Spell1 = Revenge									-- Revenge if up
				else
					Spell1 = Devastate									-- else do Devastate
				end
			elseif ((ThunderClapTimeLeft < 5 or AttackSpeedSlowIsPresent == false) and ThunderClapCD == 0) then		-- Check ThunderClap 
				Spell1 =  ThunderClap
			elseif (DemoShoutCD  <= 5) then									-- Check DemoShout 
				Spell1 = DemoShout
			elseif (CommandingShoutTimeLeft < 5 and CommandingShoutCD == 0 and WA_Prot_Toggle_Do_3 == true) then 		-- Check CommandingShout 
				Spell1 = CommandingShout
			elseif (ShockwaveCD == 0 and WA_Prot_Toggle_Do_2 == true) then
				Spell1 = Shockwave
			elseif (RevengeCD == 0) then									-- Check Revenge
				Spell1 = Revenge
			else
				Spell1 = Devastate									-- Else Do Devastate
			end
		end
		-- =============== Multi Target Logic===================
		-- Rend > Thunder Clap > Shockwave > Revenge
		-- This is assuming you have Blood and Thunder talent. Using T. Clap like clockwork will help your threat somewhat, 
		-- especially by adding Thunderstruck charges for the next Shockwave, but the most important step is to keep Rend 
		-- rolling on all your targets. It makes a dramatic difference in your sustained threat versus not having the talent. Remaining 
		-- GCDs should be occupied prioritizing Revenge and then single-target abilities.	
		
		if (GCDTimeLeft > WA_Prot_ShowDataTimeFactor) then							-- NOT inside spam window
			if (CleaveCD == 0 and Rage > WA_Prot_CleaveRage) then						-- Check Cleave
				Spell2 = Cleave
			elseif (InnerRageCD == 0 and Rage >= WA_Prot_InnerRageThreshold and WA_Prot_Toggle_Do_1 == true ) then		-- Check Inner rage
				Spell2 = InnerRage
			elseif ((GCDTimeLeft - WA_Prot_ShowDataTimeFactor) > .300) then						-- Check Longer Delay
				Spell2 = Delay300
			elseif ((GCDTimeLeft - WA_Prot_ShowDataTimeFactor) > .100) then						-- Check Medium Delay
				Spell2 = Delay100
			else
				Spell2 = Delay20									-- Else Short Delay
			end
		else
			if (RendCD ==0) then
				Spell2 = Rend
			elseif (ThunderClapCD == 0) then
				Spell2 = ThunderClap
			elseif (ShockwaveCD == 0 and WA_Prot_Toggle_Do_2 == true) then
				Spell2 = Shockwave
			elseif (RevengeCD == 0) then
				Spell2 = Revenge
			elseif (ShieldSlamCD == 0) then
				Spell2 = ShieldSlam
			elseif (DemoShoutCD  <= 5) then					-- Check DemoShout
				Spell2 = DemoShout
			else
				Spell2 = Devastate
			end
		end
			
		--WA_Prot_T1:SetText(ShieldSlamCD )				
		
		WA_Prot_Data:SetVertexColor(Spell1,Spell2,Spell3)
		
	end -- WA_Prot Code
end -- End OnUpdate 



function WA_Prot_ToggleFrame_1_OnClick()
	isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")
	if (WA_Prot_Toggle_Do_1 == true) then
		WA_Prot_Toggle_Do_1 = false
		WA_Prot_ToggleIcon_1:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Prot_ToggleIcon_1:SetVertexColor(1, 1,1, 1)
		WA_Prot_Toggle_Do_1 = true
	end
end

function WA_Prot_ToggleFrame_2_OnClick()
	if (WA_Prot_Toggle_Do_2 == true) then
		WA_Prot_Toggle_Do_2 = false
		WA_Prot_ToggleIcon_2:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Prot_ToggleIcon_2:SetVertexColor(1, 1,1, 1)
		WA_Prot_Toggle_Do_2 = true
	end
end

function WA_Prot_ToggleFrame_3_OnClick()
	if (WA_Prot_Toggle_Do_3 == true) then
		WA_Prot_Toggle_Do_3 = false
		WA_Prot_ToggleIcon_3:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Prot_ToggleIcon_3:SetVertexColor(1, 1,1, 1)
		WA_Prot_Toggle_Do_3 = true
	end
end  