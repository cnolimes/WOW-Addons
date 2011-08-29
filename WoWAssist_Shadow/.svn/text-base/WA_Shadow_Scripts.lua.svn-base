function WA_Shadow_Frame_OnLoad()

	--================= Register Events =======================
	WA_Shadow_Frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	WA_Shadow_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	WA_Shadow_Frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	WA_Shadow_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	--================= Global Variables ===================
	WA_Shadow_Enabled 		= false			-- Enables OnUpdate code execution
	WA_Shadow_Class 			= "Priest"
	WA_Shadow_ShowDataTimeFactor 	= 0.150	-- Time prior to a GCD finish when the color box will be shown

	WA_Shadow_Toggle_Do_1 		= true
	WA_Shadow_Toggle_Do_2 		= true
	WA_Shadow_Toggle_Do_3		= true

	--================= Ability To Key Mappings ===================
	MindBlast = 0.1
	MindFlay = 0.2
	VampiricTouch = 0.3
	ShadowWordPain = 0.4
	DevouringPlague = 0.5
	ShadowWordDeath = 0.6
	MindSpike = 0.7
	MindSear = 0.8
	ShadowFiend = 0.9
	ArchAngel = 1.0
	--================= Extra Function Mappings ===================
	Delay20 = 0.0
	Delay100 = 0.01
	Delay300 = 0.02
	Delay500 = 0.03
	Delay700 = 0.04	
	Delay900 = 0.05
	
	--================== Initialize Variables =====================
	MindBlastFinish = GetTime()
	ShadowWordDeathFinish = GetTime()
	ShadowFiendFinish = GetTime()
	ArchAngelFinish = GetTime()
	VampiricTouchFinish = GetTime()
end



function WA_Shadow_Frame_OnEvent(self, event, ...)

	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...
	if (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED") then
		_, _, _, _, WA_Shadow_PointsSpent, _, _, _ = GetTalentTabInfo(3)	-- Check that enough points are spent in the right tree

		if (UnitClass("player") ~= WA_Shadow_Class or WA_Shadow_PointsSpent < 31) then
			WA_Shadow_Frame:Hide()
			WA_Shadow_Enabled = false
		else
			print("is a Shadow Priest")
			--================= Ability Toggles Config ===================
			WA_Shadow_Frame:Show()
			_, _, ShadowfiendIcon, _, _, _, _, _, _ = GetSpellInfo("Shadowfiend")
			_, _, ArchangelIcon, _, _, _, _, _, _ = GetSpellInfo("Archangel")
			_, _, ShockwaveIcon, _, _, _, _, _, _ = GetSpellInfo("Mind Blast")
			WA_Shadow_ToggleIcon_1:SetTexture(ShadowfiendIcon)	
			WA_Shadow_ToggleIcon_2:SetTexture(ArchangelIcon)
			WA_Shadow_ToggleIcon_3:SetTexture(nil)

			WA_Shadow_Enabled = true
			WA_Shadow_T1:SetText("Shadow")
		end
	end
	--if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
	--	if (arg4 == "Mynn" and arg2 == "SPELL_PERIODIC_DAMAGE") then
	--		print(arg2, " at ", arg1)
	--	end
	--end
end


function WA_Shadow_Frame_OnUpdate()

	if (WA_Shadow_Enabled == true) then
		Mana = UnitPower("player")	
		MaxMana = UnitManaMax("player")
		ManaPercent = Mana / MaxMana
		-- ============================== GCD ================================
		GCDStart, GCDDuration, _ = GetSpellCooldown("Vampiric Touch")
		if (GCDStart ~= 0) then
			
			GCDTimeLeft = GCDStart + GCDDuration - GetTime()
		else
			GCDTimeLeft = 0
		end
		-- ============================ Mind Blast =============================
		-- Outputs:
		-- MindBlastCD
		--------------------------------------
		MindBlastStart, MindBlastDuration , _ = GetSpellCooldown("Mind Blast")
		if (MindBlastStart ~= 0) then
			if (MindBlastDuration > 1.5) then
				MindBlastFinish = MindBlastStart + MindBlastDuration
			end	
		end
		MindBlastCD = MindBlastFinish - GetTime()
		if (MindBlastCD < 0) then
			MindBlastCD = 0
		end

		-- ============================ Shadow Fiend =============================
		-- Outputs:
		-- ShadowFiendCD
		--------------------------------------
		ShadowFiendStart, ShadowFiendDuration , _ = GetSpellCooldown("Shadowfiend")
		if (ShadowFiendStart ~= 0) then
			if (ShadowFiendDuration > 1.5) then
				ShadowFiendFinish = ShadowFiendStart + ShadowFiendDuration
			end	
		end
		ShadowFiendCD = ShadowFiendFinish - GetTime()
		if (ShadowFiendCD < 0) then
			ShadowFiendCD = 0
		end

		-- ============================ ArchAngel =============================
		-- Outputs:
		-- ArchAngelCD
		--------------------------------------
		ArchAngelStart, ArchAngelDuration , _ = GetSpellCooldown("Archangel")
		if (ArchAngelStart ~= 0) then
			if (ArchAngelDuration > 1.5) then
				ArchAngelFinish = ArchAngelStart + ArchAngelDuration
			end	
		end
		ArchAngelCD = ArchAngelFinish - GetTime()
		if (ArchAngelCD < 0) then
			ArchAngelCD = 0
		end

		-- ============================ Mind Flay  ==============================
		-- Outputs:
		--MindFlayCD
		--------------------------------------
		--SpellName, _, _, _, MindFlayStartTime, MindFlayEndTime, _, _ = UnitChannelInfo("player")
		--if (SpellName == "Mind Flay") then
		--	MindFlayCD = (MindFlayEndTime / 1000) - GetTime()
		--else
		--	MindFlayCD = 0
		--end

		MindFlayName, _, _, _, _, MindFlayDuration, MindFlayExpirationTime, UnitCaster, _ = UnitDebuff("target", "Mind Flay")
		if (MindFlayName ~= nil and UnitCaster == "player") then
			MindFlayCD = MindFlayExpirationTime - GetTime()
		else
			MindFlayCD = 0
		end
		-- ============================ Vampiric Touch =============================
		-- Outputs:
		-- VampiricTouchCD
		-- VampiricTouchDelay
		--------------------------------------
		VampiricTouchName, _, _, _, _, VampiricTouchDuration, VampiricTouchExpirationTime, UnitCaster, _ = UnitDebuff("target", "Vampiric Touch")
		if (VampiricTouchName ~= nil and UnitCaster == "player") then
			_, _, _, _, _, _, VampiricTouchCastTime, _, _ = GetSpellInfo("Vampiric Touch")
			VampiricTouchCD = (VampiricTouchExpirationTime - GetTime()) - (VampiricTouchCastTime/1000)
			if (VampiricTouchCD < 0) then
				VampiricTouchCD = 0
			end
		else
			VampiricTouchCD = 0
		end
		VampiricTouchSpellName, _, _, _, _, VampiricTouchEndTime, _, _, _ = UnitCastingInfo("player")
		if (VampiricTouchSpellName ~= nil) then
			VampiricTouchFinish = (VampiricTouchEndTime / 1000) + 0.3
		end
		VampiricTouchDelay = VampiricTouchFinish - GetTime()
		if (VampiricTouchDelay < 0) then
			VampiricTouchDelay = 0
		end
		-- ============================ Shadow Word Pain ============================
		-- Outputs:
		-- ShadowWordPainCD 	
		--------------------------------------
		ShadowWordPainName, _, _, _, _, ShadowWordPainDuration, ShadowWordPainExpirationTime, UnitCaster, _ = UnitDebuff("target", "Shadow Word: Pain")
		if (ShadowWordPainName ~= nil and UnitCaster == "player") then
			ShadowWordPainCD = ShadowWordPainExpirationTime - GetTime()
		else
			ShadowWordPainCD = 0
		end

		-- ============================ Devouring Plague ===========================
		-- Outputs:
		-- DevouringPlagueCD
		--------------------------------------
		DevouringPlagueName, _, _, _, _, DevouringPlagueDuration, DevouringPlagueExpirationTime, UnitCaster, _ = UnitDebuff("target", "Devouring Plague")
		if (DevouringPlagueName ~= nil and UnitCaster == "player") then
			DevouringPlagueCD = DevouringPlagueExpirationTime - GetTime()
		else
			DevouringPlagueCD = 0
		end
		-- ============================ Shadow Word Death ================================
		-- Outputs:
		-- ShadowWordDeathCD
		--------------------------------------
		ShadowWordDeathStart, ShadowWordDeathDuration , _ = GetSpellCooldown("Shadow Word: Death")
		if (ShadowWordDeathStart ~= 0) then
			if (ShadowWordDeathDuration > 1.5) then
				ShadowWordDeathFinish = ShadowWordDeathStart + ShadowWordDeathDuration
			end	
		end
		ShadowWordDeathCD = ShadowWordDeathFinish - GetTime()
		if (ShadowWordDeathCD < 0) then
			ShadowWordDeathCD = 0
		end
		-- ============================ Mind Spike============================
		-- Outputs:
		-- MindSpikeCD
		--------------------------------------
		SpellName, _, _, _, MindSpikeStartTime, MindSpikeEndTime, _, _ = UnitChannelInfo("player")
		if (SpellName == "Mind Spike") then
			MindSpikeCD = (MindSpikeEndTime / 1000) - GetTime()
		else
			MindSpikeCD = 0
		end

		-- ============================ Mind Sear ============================
		-- Outputs:
		-- MindSearCD
		--------------------------------------
		SpellName, _, _, _, MindSearStartTime, MindSearEndTime, _, _ = UnitChannelInfo("player")
		if (SpellName == "Mind Sear") then
			MindSearCD = (MindSearEndTime / 1000) - GetTime()
		else
			MindSearCD = 0
		end

		-- ============================ Dark Evangelism ============================
		-- Outputs:
		-- DarkEvangelismCount
		--------------------------------------

		DarkEvangelismName, _, _,DarkEvangelismCount, _, _, DarkEvangelismExpirationTime, _, _, _, _ = UnitBuff("player", "Dark Evangelism") 
		if (DarkEvangelismName == nil) then
			DarkEvangelismCount = 0
		end

		-- ============================ Mind Melt ============================
		-- Outputs:
		-- MindMeltCount
		--------------------------------------

		MindMeltName, _, _,MindMeltCount, _, _, MindMeltExpirationTime, _, _, _, _ = UnitBuff("player", "Mind Melt") 
		if (MindMeltName == nil) then
			MindMeltCount = 0
		end
		-- ============================ Shadow Orb ============================
		-- Outputs:
		-- ShadowOrbCount
		--------------------------------------

		ShadowOrbName, _, _,ShadowOrbCount, _, _, ShadowOrbExpirationTime, _, _, _, _ = UnitBuff("player", "Shadow Orb") 
		if (ShadowOrbName == nil) then
			ShadowOrbCount = 0
		end

		-- ============================ Empowered Shadow ============================
		-- Outputs:
		-- EmpoweredShadowTimeLeft
		--------------------------------------

		EmpoweredShadowName, _, _,_, _, _, EmpoweredShadowExpirationTime, _, _, _, _ = UnitBuff("player", "Empowered Shadow") 
		if (EmpoweredShadowName ~= nil) then
			EmpoweredShadowTimeLeft = EmpoweredShadowExpirationTime - GetTime()
		else
			EmpoweredShadowTimeLeft = 0
		end

		--====================================================================
		--============================== LOGIC TREE ===========================
		--====================================================================

		-- SW:P -> Shadowfiend -> VT -> DP -> MF (until Orb) -> MB -> MF until DoT refresh -> Dark Archangel -> MF -> MF -> Mind Blast (once you have an Orb)
		-- After re-upping Dark Evangelism post Dark Archangel, it's simple spell priority:
		-- VT > SW:P* > DP > MB(1+ Orbs) > (SW:D)** > MF
		-- Shadowfiend on every cooldown
		-- Dark Archangel when DoTs are ticking away (2+ ticks remaining, to make sure you have time to refresh DE)
		-- *Should never be relevant, really, but just so it's clear
		-- **If you cast Shadow Word: Death on cooldown below a certain threshold of mana (I prefer 80%), you will stay pretty well topped off through most of the fight.
		
		
		-- =============== Single Target Boss Logic ==================
		if (MindFlayCD > 0) then		-- Check if channeling mind flay
			if (MindFlayCD > 0.300) then
				Spell1 = Delay300
			elseif (MindFlayCD > 0.100) then
				Spell1 = Delay100
			else
				Spell1 = Delay20
			end
		elseif (GCDTimeLeft > WA_Shadow_ShowDataTimeFactor) then							-- NOT inside spam window
			if ((GCDTimeLeft - WA_Shadow_ShowDataTimeFactor) > 0.300) then						-- Check Longer Delay
				Spell1 = Delay300
			elseif ((GCDTimeLeft - WA_Shadow_ShowDataTimeFactor) > 0.100) then						-- Check Medium Delay
				Spell1 = Delay100
			else
				Spell1 = Delay20									-- Else Short Delay
			end
		elseif (ShadowWordPainCD  == 0) then
			Spell1 = ShadowWordPain
		elseif (ShadowFiendCD == 0 and WA_Shadow_Toggle_Do_1 == true) then
			Spell1 = ShadowFiend
		elseif (VampiricTouchCD == 0 and VampiricTouchDelay == 0) then
			Spell1 = VampiricTouch
		elseif (DevouringPlagueCD == 0) then
			Spell1 = DevouringPlague
		elseif (ShadowOrbCount > 0 and MindBlastCD == 0) then 
			Spell1 = MindBlast
		elseif (ArchAngelCD == 0 and WA_Shadow_Toggle_Do_2  == true and DarkEvangelismCount == 5) then
			Spell1 = ArchAngel
		elseif (ManaPercent < 0.80 and ShadowWordDeathCD == 0) then
			Spell1 = ShadowWordDeath
		else
			Spell1 = MindFlay
		end

		-- =============== AOE  Logic ==================
		if (MindFlayCD > 0) then		-- Check if channeling mind flay
			if (MindFlayCD > 0.300) then
				Spell2 = Delay300
			elseif (MindFlayCD > 0.100) then
				Spell2 = Delay100
			else
				Spell2 = Delay20
			end
		elseif (GCDTimeLeft > WA_Shadow_ShowDataTimeFactor) then							-- NOT inside spam window
			if ((GCDTimeLeft - WA_Shadow_ShowDataTimeFactor) > 0.300) then						-- Check Longer Delay
				Spell2 = Delay300
			elseif ((GCDTimeLeft - WA_Shadow_ShowDataTimeFactor) > 0.100) then						-- Check Medium Delay
				Spell2 = Delay100
			else
				Spell2 = Delay20									-- Else Short Delay
			end
		elseif (ManaPercent < 0.80 and ShadowWordDeathCD == 0) then
			Spell2 = ShadowWordDeath
		elseif (ShadowFiendCD == 0 and WA_Shadow_Toggle_Do_1 == true) then
			Spell2 = ShadowFiend
		elseif (DevouringPlagueCD == 0) then
			Spell2 = DevouringPlague		
		elseif (ShadowWordPainCD  == 0) then
			Spell2 = ShadowWordPain
		elseif (VampiricTouchCD == 0 and VampiricTouchDelay == 0) then
			Spell2 = VampiricTouch
		else
			Spell2 = MindFlay
		end

		-- =============== Weak Add  Logic ==================
		if (MindFlayCD > 0) then		-- Check if channeling mind flay
			if (MindFlayCD > 0.300) then
				Spell3 = Delay300
			elseif (MindFlayCD > 0.100) then
				Spell3 = Delay100
			else
				Spell3 = Delay20
			end
		elseif (GCDTimeLeft > WA_Shadow_ShowDataTimeFactor) then							-- NOT inside spam window
			if ((GCDTimeLeft - WA_Shadow_ShowDataTimeFactor) > 0.300) then						-- Check Longer Delay
				Spell3 = Delay300
			elseif ((GCDTimeLeft - WA_Shadow_ShowDataTimeFactor) > 0.100) then						-- Check Medium Delay
				Spell3 = Delay100
			else
				Spell3 = Delay20									-- Else Short Delay
			end
		elseif (ManaPercent < 0.80 and ShadowWordDeathCD == 0) then
			Spell3 = ShadowWordDeath
		elseif (MindMeltCount == 2 and MindBlastCD == 0) then
			Spell3 = MindBlast
		elseif (MindMeltCount < 2) then
			Spell3 = MindSpike
		else		
			Spell3 = MindFlay
		end

		--WA_Shadow_T1:SetText(DarkEvangelismCount)
		WA_Shadow_Data:SetVertexColor(Spell1,Spell2,Spell3)
		
	end -- WA_Shadow Code
end -- End OnUpdate 



function WA_Shadow_ToggleFrame_1_OnClick()
	if (WA_Shadow_Toggle_Do_1 == true) then
		WA_Shadow_Toggle_Do_1 = false
		WA_Shadow_ToggleIcon_1:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Shadow_ToggleIcon_1:SetVertexColor(1, 1,1, 1)
		WA_Shadow_Toggle_Do_1 = true
	end
end

function WA_Shadow_ToggleFrame_2_OnClick()
	if (WA_Shadow_Toggle_Do_2 == true) then
		WA_Shadow_Toggle_Do_2 = false
		WA_Shadow_ToggleIcon_2:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Shadow_ToggleIcon_2:SetVertexColor(1, 1,1, 1)
		WA_Shadow_Toggle_Do_2 = true
	end
end

function WA_Shadow_ToggleFrame_3_OnClick()
	if (WA_Shadow_Toggle_Do_3 == true) then
		WA_Shadow_Toggle_Do_3 = false
		WA_Shadow_ToggleIcon_3:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Shadow_ToggleIcon_3:SetVertexColor(1, 1,1, 1)
		WA_Shadow_Toggle_Do_3 = true
	end
end  