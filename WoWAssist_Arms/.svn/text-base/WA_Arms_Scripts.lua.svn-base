function WA_Arms_Frame_OnLoad()

	--================= Register Events =======================
	WA_Arms_Frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	WA_Arms_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	WA_Arms_Frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	WA_Arms_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	--================= Global Variables ===================
	WA_Arms_Enabled 					= false			-- Enables OnUpdate code execution
	WA_Arms_Class 						= "Warrior"
	WA_Arms_ShowDataTimeFactor 			= 0.150	-- Time prior to a GCD finish when the color box will be shown
	WA_Arms_MinimumThreatForDebuffs 	= 000000
	WA_Arms_HeroicStrikeRage			= 75
	WA_Arms_CleaveRage					= 75
	WA_Arms_Toggle_Do_1 				= true
	WA_Arms_Toggle_Do_2 				= true
	WA_Arms_Toggle_Do_3					= true
	WA_Arms_GCD_Duration				= 1.5
	
	--================= Ability To Key Mappings ===================
	WA_Arms_MortalStrike = 0.1
	WA_Arms_ColossusSmash = 0.2
	WA_Arms_Rend = 0.3
	WA_Arms_OverPower = 0.4
	WA_Arms_Slam = 0.5
	WA_Arms_HeroicStrike = 0.6
	WA_Arms_Cleave = 0.7
	WA_Arms_BattleShout = 0.8
	WA_Arms_CommandingShout = 0.9
	WA_Arms_VictoryRush = 1.0
	WA_Arms_ThunderClap = .95

	--================= Extra Function Mappings ===================
	Delay20 = 0.0
	Delay100 = 0.01
	Delay300 = 0.02
	Delay500 = 0.03
	Delay700 = 0.04	
	Delay900 = 0.05
	
	--================== Initialize Variables =====================
	MortalStrikeFinish = GetTime()
	ColossusSmashFinish = GetTime()
	HeroicStrikeFinish = GetTime()
	CleaveFinish = GetTime()
	CommandingShoutFinish = GetTime()
	BattleShoutFinish = GetTime()
	OverPowerFinish = GetTime()
	ThunderClapFinish = GetTime()

end



function WA_Arms_Frame_OnEvent(self, event, ...)

	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...
	--print(event)
	if (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED") then
		_, _, _, _, WA_Arms_PointsSpent, _, _, _ = GetTalentTabInfo(1)	-- Check that enough points are spent in the right tree

		if (UnitClass("player") ~= WA_Arms_Class or WA_Arms_PointsSpent < 31) then
			WA_Arms_Frame:Hide()
			WA_Arms_Enabled = false
		else
			--================= Ability Toggles Config ===================
			WA_Arms_Frame:Show()
			_, _, DefensiveStanceIcon, _, _, _, _, _, _ = GetSpellInfo("Defensive Stance")
			_, _, ShockwaveIcon, _, _, _, _, _, _ = GetSpellInfo("Shockwave")
			_, _, ShockwaveIcon, _, _, _, _, _, _ = GetSpellInfo("Shockwave")
			WA_Arms_ToggleIcon_1:SetTexture(nil)	
			WA_Arms_ToggleIcon_2:SetTexture(nil)
			WA_Arms_ToggleIcon_3:SetTexture(nil)

			WA_Arms_Enabled = true
			WA_Arms_T1:SetText("Arms")	


		end
	end
	--if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
	--	if (arg4 == "Kaubell" and arg2 == "SPELL_CAST_SUCCESS") then
	--		print(arg10, " at ", arg1)
	--	end
	--end
end


function WA_Arms_Frame_OnUpdate()

	if (WA_Arms_Enabled == true) then
		Rage = UnitPower("player")	

		-- ============================== GCD ================================
		GCDStart, GCDDuration, _ = GetSpellCooldown("Rend")
		if (GCDStart ~= 0) then
			
			GCDTimeLeft = GCDStart + GCDDuration - GetTime()
		else
			GCDTimeLeft = 0
		end
		-- ============================ Mortal Strike =============================
		-- Outputs:
		-- MortalStrikeCD 	
		--------------------------------------
		MortalStrikeStart, MortalStrikeDuration, _ = GetSpellCooldown("Mortal Strike")
		if (MortalStrikeStart ~= 0) then
			if (MortalStrikeDuration > WA_Arms_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				MortalStrikeFinish = MortalStrikeStart + MortalStrikeDuration
				MortalStrikeCD = MortalStrikeFinish - GetTime()
			else
				if (MortalStrikeFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (MortalStrikeFinish - (MortalStrikeStart + MortalStrikeDuration) - WA_Arms_ShowDataTimeFactor > 0) then
						MortalStrikeCD = 0
					else
						MortalStrikeCD = MortalStrikeFinish - GetTime()
					end
				else
					MortalStrikeCD = 0
				end
			end
			
		else
			MortalStrikeCD = 0
		end
		_, _, _, MortalStrikeCost, _, _, _, _, _ = GetSpellInfo("Mortal Strike")
		if (Rage < MortalStrikeCost) then
			MortalStrikeCD = 30
		end

		-- ============================ ThunderClap ===========================
		-- Outputs:
		-- ThunderClapCD 	(0 if ready, 30 if not enough rage, 0 to 6 if on cooldown)
		-- ThunderClapTimeLeft (0 if not up, 0 to 30 if up)
		--------------------------------------
		ThunderClapStart, ThunderClapDuration , _ = GetSpellCooldown("Thunder Clap")
		if (ThunderClapStart ~= 0) then
			if (ThunderClapDuration > 1.5) then
				ThunderClapFinish = ThunderClapStart + ThunderClapDuration
			end			
		end
		ThunderClapCD = ThunderClapFinish - GetTime()
		if (ThunderClapCD < 0) then
			ThunderClapCD = 0
		end
		_, _, _, ThunderClapCost, _, _, _, _, _ = GetSpellInfo("Thunder Clap")
		if (Rage < ThunderClapCost) then
			ThunderClapCD = 30
		end
		ThunderClapName, _, _, _, _, ThunderClapDuration, ThunderClapExpirationTime, UnitCaster, _ = UnitDebuff("target", "Thunder Clap")
		if (ThunderClapName ~= nil) then
			ThunderClapTimeLeft = ThunderClapExpirationTime - GetTime()
		else
			ThunderClapTimeLeft = 0
		end
		-- ============================ Colossus Smash  ==============================
		-- Outputs:
		-- ColossusSmashCD 
		-- ColossusSmashDebuffCD 
		--------------------------------------

		ColossusSmashStart, ColossusSmashDuration, _ = GetSpellCooldown("Colossus Smash")
		if (ColossusSmashStart ~= 0) then
			if (ColossusSmashDuration > WA_Arms_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				ColossusSmashFinish = ColossusSmashStart + ColossusSmashDuration
				ColossusSmashCD = ColossusSmashFinish - GetTime()
			else
				if (ColossusSmashFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (ColossusSmashFinish - (ColossusSmashStart + ColossusSmashDuration) - WA_Arms_ShowDataTimeFactor > 0) then
						ColossusSmashCD = 0
					else
						ColossusSmashCD = ColossusSmashFinish - GetTime()
					end
				else
					ColossusSmashCD = 0
				end
			end
			
		else
			ColossusSmashCD = 0
		end

		_, _, _, ColossusSmashCost, _, _, _, _, _ = GetSpellInfo("Colossus Smash")
		if (Rage < ColossusSmashCost) then
			ColossusSmashCD = 30
		end

		ColossusSmashDebuffName, _, _, _, _, ColossusSmashDebuffDuration, ExpirationTime, UnitCaster, _ = UnitDebuff("target", "Colossus Smash")
		if (ColossusSmashDebuffName ~= nil) then
			ColossusSmashDebuffCD = 30
		else
			ColossusSmashDebuffCD = 0
		end		


		-- ============================ OverPower  ==============================
		-- Outputs:
		-- OverPowerCD 
		--------------------------------------
		OverPowerUsable, nomana = IsUsableSpell("Overpower")
		if (OverPowerUsable ~= nil) then
			OverPowerCD = 0
			_, _, _, OverPowerCost, _, _, _, _, _ = GetSpellInfo("Overpower")
			if (Rage < OverPowerCost) then
				OverPowerCD = 30
			end
		else
			OverPowerCD = 30
		end

		-- ============================ Rend ================================
		-- Outputs:
		-- CanRend	(true/false)
		--------------------------------------
		RendName, _, _, _, _, RendDuration, ExpirationTime, UnitCaster, _ = UnitDebuff("target", "Rend")
		if (RendName ~= nil) then
			if (UnitCaster == "player") then
				CanRend = false
			else
				CanRend = true
			end
		else
			CanRend = true	
		end		
		_, _, _, RendCost, _, _, _, _, _ = GetSpellInfo("Rend")
		if (Rage < RendCost) then
			CanRend = false
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
		-- ============================ Battle Shout =======================
		-- Outputs:
		-- CanBattleShout	(true/false)
		-- BattleShoutCD	(0 if not up, 0 to 45 if up)
		-- BattleShoutTimeLeft
		--------------------------------------
		BattleShoutName, _, _, _, _, _, BattleShoutExpirationTime, _, _, _, _ = UnitBuff("player", "Battle Shout") 
		if (BattleShoutName == nil) then
			CanBattleShout = true
			BattleShoutTimeLeft = 0
		else
			BattleShoutTimeLeft = BattleShoutExpirationTime - GetTime()
			CanBattleShout = false		
		end
		BattleShoutStart, BattleShoutDuration , _ = GetSpellCooldown("Battle Shout")
		if (BattleShoutStart ~= 0) then
			if (BattleShoutDuration > 1.5) then
				BattleShoutFinish = BattleShoutStart + BattleShoutDuration
			end
		end
		BattleShoutCD = BattleShoutFinish - GetTime()
		if (BattleShoutCD < 0) then
			BattleShoutCD = 0
		end

		--====================================================================
		--============================== LOGIC TREE ===========================
		--====================================================================
		--WA_Arms_T1:SetText(WA_Arms_ShowDataTimeFactor)	

		-- =============== Single Target Logic ==================
		if (GCDTimeLeft > WA_Arms_ShowDataTimeFactor) then							-- NOT inside spam window
			if (HeroicStrikeCD == 0 and Rage > WA_Arms_HeroicStrikeRage) then					-- Check Heroic Strike
				Spell1 = WA_Arms_HeroicStrike
				
			elseif ((GCDTimeLeft - WA_Arms_ShowDataTimeFactor) > .300) then						-- Check Longer Delay
				Spell1 = Delay300
			elseif ((GCDTimeLeft - WA_Arms_ShowDataTimeFactor) > .100) then						-- Check Medium Delay
				Spell1 = Delay100
			else
				Spell1 = Delay20									-- Else Short Delay
			end
		else											-- Inside spam window
			if (CanRend == true) then
				Spell1 = WA_Arms_Rend
			elseif (ColossusSmashCD == 0 and MortalStrikeCD <= WA_Arms_GCD_Duration and ColossusSmashDebuffCD == 0) then
				Spell1 = WA_Arms_ColossusSmash
			elseif (MortalStrikeCD == 0) then
				Spell1 =  WA_Arms_MortalStrike
			elseif (OverPowerCD == 0) then
				Spell1 =  WA_Arms_OverPower
			elseif (CanBattleShout == true) then
				Spell1 = WA_Arms_BattleShout	
			else
				if (Rage > 40) then
					Spell1 = WA_Arms_Slam
				end

			end
		end
		-- =============== Multi Target Logic===================
		
		if (GCDTimeLeft > WA_Arms_ShowDataTimeFactor) then							-- NOT inside spam window
			if (HeroicStrikeCD == 0 and Rage > WA_Arms_HeroicStrikeRage) then					-- Check Heroic Strike
				--Spell2 = WA_Arms_Cleave
				Spell2 = WA_Arms_HeroicStrike
				
			elseif ((GCDTimeLeft - WA_Arms_ShowDataTimeFactor) > .300) then						-- Check Longer Delay
				Spell2 = Delay300
			elseif ((GCDTimeLeft - WA_Arms_ShowDataTimeFactor) > .100) then						-- Check Medium Delay
				Spell2 = Delay100
			else
				Spell2 = Delay20									-- Else Short Delay
			end
		else											-- Inside spam window
			if (CanRend == true) then
				Spell2 = WA_Arms_Rend
			elseif (ThunderClapCD == 0) then
				Spell2 = WA_Arms_ThunderClap
			elseif (ColossusSmashCD == 0 and MortalStrikeCD <= WA_Arms_GCD_Duration and ColossusSmashDebuffCD == 0) then
				Spell2 = WA_Arms_ColossusSmash
			elseif (MortalStrikeCD == 0) then
				Spell2 =  WA_Arms_MortalStrike
			elseif (OverPowerCD == 0) then
				Spell2 =  WA_Arms_OverPower
			elseif (CanBattleShout == true) then
				Spell2 = WA_Arms_BattleShout	
			else
				if (Rage > 40) then
					Spell2 = WA_Arms_Slam
				end

			end
		end
			

		--WA_Arms_T1:SetText(ColossusSmashCD)
		--WA_Arms_T1:SetText(ColossusSmashDebuffCD)
		--WA_Arms_T1:SetText(ColossusSmashDuration)
		WA_Arms_Data:SetVertexColor(Spell1,Spell2,Spell3)
		
	end -- WA_Arms Code
end -- End OnUpdate 



function WA_Arms_ToggleFrame_1_OnClick()
	if (WA_Arms_Toggle_Do_1 == true) then
		WA_Arms_Toggle_Do_1 = false
		WA_Arms_ToggleIcon_1:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Arms_ToggleIcon_1:SetVertexColor(1, 1,1, 1)
		WA_Arms_Toggle_Do_1 = true
	end
end

function WA_Arms_ToggleFrame_2_OnClick()
	if (WA_Arms_Toggle_Do_2 == true) then
		WA_Arms_Toggle_Do_2 = false
		WA_Arms_ToggleIcon_2:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Arms_ToggleIcon_2:SetVertexColor(1, 1,1, 1)
		WA_Arms_Toggle_Do_2 = true
	end
end

function WA_Arms_ToggleFrame_3_OnClick()
	if (WA_Arms_Toggle_Do_3 == true) then
		WA_Arms_Toggle_Do_3 = false
		WA_Arms_ToggleIcon_3:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Arms_ToggleIcon_3:SetVertexColor(1, 1,1, 1)
		WA_Arms_Toggle_Do_3 = true
	end
end  