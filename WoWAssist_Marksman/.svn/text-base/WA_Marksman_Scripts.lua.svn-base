function WA_Marksman_Frame_OnLoad()

	--================= Register Events =======================
	WA_Marksman_Frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	WA_Marksman_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	WA_Marksman_Frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	WA_Marksman_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	--================= Global Variables ===================
	WA_Marksman_Enabled 			= false			-- Enables OnUpdate code execution
	WA_Marksman_Class 			= "Hunter"
	WA_Marksman_ShowDataTimeFactor 	= 0.150	-- Time prior to a GCD finish when the color box will be shown
	WA_Marksman_FocusPoolValue		= 80
	WA_Marksman_Toggle_Do_1 		= true
	WA_Marksman_Toggle_Do_2 		= true
	WA_Marksman_Toggle_Do_3		= true

	--================= Ability To Key Mappings ===================
	WA_Marksman_SerpentSting = 0.1
	WA_Marksman_ChimeraShot = 0.2
	WA_Marksman_AimedShot= 0.3
	WA_Marksman_SteadyShot= 0.4
	WA_Marksman_ArcaneShot = 0.5
	WA_Marksman_KillShot = 0.6
	WA_Marksman_MultiShot = 0.7
	WA_Marksman_RapidFire = 0.8
	WA_Marksman_9 = 0.9
	WA_Marksman_10 = 1.0

	--================= Extra Function Mappings ===================
	Delay20 = 0.0
	Delay100 = 0.01
	Delay300 = 0.02
	Delay500 = 0.03
	Delay700 = 0.04	
	Delay900 = 0.05
	
	--================== Initialize Variables =====================
	ChimeraShotFinish = GetTime()
	AimedShotFinish = GetTime()

	KillShotFinish = GetTime()
end



function WA_Marksman_Frame_OnEvent(self, event, ...)

	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...
	if (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED") then
		_, _, _, _, WA_Marksman_PointsSpent, _, _, _ = GetTalentTabInfo(2)	-- Check that enough points are spent in the right tree

		if (UnitClass("player") ~= WA_Marksman_Class or WA_Marksman_PointsSpent < 31) then
			WA_Marksman_Frame:Hide()
			WA_Marksman_Enabled = false
		else
			--================= Ability Toggles Config ===================
			WA_Marksman_Frame:Show()
			_, _, SerpentStingIcon, _, _, _, _, _, _ = GetSpellInfo("Serpent Sting")
			_, _, BlackArrowIcon, _, _, _, _, _, _ = GetSpellInfo("Arcane Shot")
			_, _, KillShotIcon, _, _, _, _, _, _ = GetSpellInfo("Kill Shot")
			WA_Marksman_ToggleIcon_1:SetTexture(SerpentStingIcon)	
			WA_Marksman_ToggleIcon_2:SetTexture(nil)
			WA_Marksman_ToggleIcon_3:SetTexture(nil)

			WA_Marksman_Enabled = true
			WA_Marksman_T1:SetText("Marks")	


		end
	end

end


function WA_Marksman_Frame_OnUpdate()

	if (WA_Marksman_Enabled == true) then
		Focus = UnitPower("player")	
		Health = UnitHealth("target")
		HealthMax = UnitHealthMax("target")
		HealthPercent = (Health / HealthMax) * 100

		-- ============================== GCD ================================
		GCDStart, GCDDuration, _ = GetSpellCooldown("Arcane Shot")
		if (GCDStart ~= 0) then
			
			GCDTimeLeft = GCDStart + GCDDuration - GetTime()
		else
			GCDTimeLeft = 0
		end



		-- ============================ MultiShot =============================
		-- Outputs:
		-- MultiShotCD
		--------------------------------------
		_, _, _, MultiShotCost, _, _, _, _, _ = GetSpellInfo("Multi-Shot")
		if (Focus < MultiShotCost) then
			MultiShotCD = 30
		else
			MultiShotCD = 0
		end

		-- ============================ Serpent Sting ========================
		-- Outputs:
		-- SerpentStingCD 	
		--------------------------------------
		SerpentStingName, _, _, _, _, SerpentStingDuration, SerpentStingExpirationTime, UnitCaster, _ = UnitDebuff("target", "Serpent Sting")
		if (SerpentStingName ~= nil and UnitCaster == "player") then
			SerpentStingCD = SerpentStingExpirationTime - GetTime()
		else
			SerpentStingCD = 0
		end	
		_, _, _, SerpentStingCost, _, _, _, _, _ = GetSpellInfo("Serpent Sting")
		if (Focus < SerpentStingCost) then
			SerpentStingCD = 30
		end

		-- =========================== Arcane Shot ===========================
		-- Outputs:
		-- ArcaneShotCD 	
		--------------------------------------
		_, _, _, ArcaneShotCost, _, _, _, _, _ = GetSpellInfo("Arcane Shot")
		if (Focus < ArcaneShotCost) then
			ArcaneShotCD = 30
		else
			ArcaneShotCD = 0
		end

		-- =========================== Kill Shot ===========================
		-- Outputs:
		-- KillShotCD	
		--------------------------------------
		KillShotStart, KillShotDuration , _ = GetSpellCooldown("Kill Shot")
		if (KillShotStart ~= 0) then
			if (KillShotDuration > 1) then
				KillShotFinish = KillShotStart + KillShotDuration
			end	
		end
		KillShotCD = KillShotFinish - GetTime()
		if (KillShotCD < 0) then
			KillShotCD = 0
		end
		if (HealthPercent >= 20) then
			KillShotCD = 30
		end
		

		-- =========================== Chimera Shot ===========================
		-- Outputs:
		-- ChimeraShotCD	
		--------------------------------------
		ChimeraShotStart, ChimeraShotDuration , _ = GetSpellCooldown("Chimera Shot")
		if (ChimeraShotStart ~= 0) then
			if (ChimeraShotDuration > 1) then
				ChimeraShotFinish = ChimeraShotStart + ChimeraShotDuration
			end	
		end
		ChimeraShotCD = ChimeraShotFinish - GetTime()
		if (ChimeraShotCD < 0) then
			ChimeraShotCD = 0
		end
		
		_, _, _, ChimeraShotCost, _, _, _, _, _ = GetSpellInfo("Chimera Shot")
		if (Focus < ChimeraShotCost) then
			ChimeraShotCD = 30
		end

		-- =========================== Aimed Shot ===========================
		-- Outputs:
		-- AimedShotCD	
		--------------------------------------
		AimedShotStart, AimedShotDuration , _ = GetSpellCooldown("Aimed Shot")
		if (AimedShotStart ~= 0) then
			if (AimedShotDuration > 1) then
				AimedShotFinish = AimedShotStart + AimedShotDuration
			end	
		end
		AimedShotCD = AimedShotFinish - GetTime()
		if (AimedShotCD < 0) then
			AimedShotCD = 0
		end

		_, _, _, AimedShotCost, _, _, _, _, _ = GetSpellInfo("Aimed Shot")
		if (Focus < AimedShotCost) then
			AimedShotCD = 30
		end

		-- ============================ Casting  ==============================
		-- Outputs:
		--CastingCD
		--------------------------------------
		CastingSpell, _, _, _, CastingStartTime, CastingEndTime, _, _, _ = UnitCastingInfo("player")
		if (CastingStartTime ~= nil and (CastingSpell == "Steady Shot" or CastingSpell == "Aimed Shot")) then
			CastingCD = (CastingEndTime/1000) - GetTime()
		else
			CastingCD = 0
		end
		
		-- ============================ Improved Steady Shot  ==============================
		-- Outputs:
		--ImprovedSteadyShotCD
		--------------------------------------
		ImprovedSteadyShotName, _, _, ImprovedSteadyShotCount, _, ImprovedSteadyShotDuration, ImprovedSteadyShotExpirationTime, _, _,  _, _ = UnitBuff("player", "Improved Steady Shot")
		if (ImprovedSteadyShotName ~= nil) then
			ImprovedSteadyShotCD =ImprovedSteadyShotExpirationTime - GetTime()
		else
			ImprovedSteadyShotCD = 0
		end

		-- ============================ Fire!  ==============================
		-- Outputs:
		--FireCD
		--------------------------------------
		FireName, _, _, FireCount, _, FireDuration, FireExpirationTime, _, _,  _, _ = UnitBuff("player", "Fire!")
		if (FireName ~= nil) then
			FireCD =FireExpirationTime - GetTime()
		else
			FireCD = 0
		end

		--====================================================================
		--============================== LOGIC TREE ===========================
		--====================================================================


		--The MM priority currently has a few high-level driving principals. These are
		-- Apply SrS at the start of all fights on targets that will live longer than 12s
		-- Use CS during the whole fight
		-- Use CS in time to extend SrS during the CA phase
		-- Use CS off CD outside the CA phase
		-- Use AI as your focus dump during the CA phase and when under large dynamic haste effects
		-- Use AS as your focus dump at all other times
		-- Use MMM AI procs as soon as they occur but not in the middle of an SS pair needed to maintain ISS uptime
		-- Use SS as your filler shot to regen focus, to maintain ISS uptime, and gain MMM AI procs
		-- Each CS cycle should contain at least 2 SS pairs to maintain ISS uptime

		--The general MM shot/ability priority is as follows for single targets:
		--1) Shortly before combat starts apply HM to the target
		--2) Shortly before combat starts cast MD on the target’s tank
		--3) SrS (only if the target will live longer than 12s)
		--4) CS if new target that is not marked to apply MfD or to refresh SrS
		--5) AI MMM proc
		--6) SS pair if no ISS buff
		--7) AI hardcast
		--8) KS
		--9) RF
		--10) Readiness (RD)
		--11) SS pair (if less than 3 to 4s on the ISS buff)
		--12) KC (if have a RiF proc or pet is on the target and target is out of LoS)
		--13) SS

		

		-- =============== Single Target Logic ==================
		if (CastingCD > WA_Marksman_ShowDataTimeFactor) then			-- Check if casting Cobra Shot
			if (CastingCD > 0.300) then
				Spell1 = Delay300
			elseif (CastingCD > 0.100) then
				Spell1 = Delay100
			else
				Spell1 = Delay20
			end

		elseif (GCDTimeLeft > WA_Marksman_ShowDataTimeFactor) then			-- NOT inside spam window
			if ((GCDTimeLeft - WA_Marksman_ShowDataTimeFactor) > .300) then			-- Check Longer Delay
				Spell1 = Delay300
			elseif ((GCDTimeLeft - WA_Marksman_ShowDataTimeFactor) > .100) then		-- Check Medium Delay
				Spell1 = Delay100
			else
				Spell1 = Delay20						-- Else Short Delay
			end
		else								-- Inside spam window
			if (SerpentStingCD == 0 and WA_Marksman_Toggle_Do_1 == true) then
				Spell1 = WA_Marksman_SerpentSting
			elseif (ChimeraShotCD == 0) then
				Spell1 = WA_Marksman_ChimeraShot
			elseif (FireCD > 0) then
				Spell1 = WA_Marksman_AimedShot
			elseif(ImprovedSteadyShotCD == 0) then
				Spell1 = WA_Marksman_SteadyShot
			elseif(AimedShotCD == 0) then
				Spell1 = WA_Marksman_AimedShot
			elseif(KillShotCD == 0) then
				Spell1 = WA_Marksman_KillShot
			else
				Spell1 = WA_Marksman_SteadyShot
			end

		end




		-- =============== Multi Target Logic===================
		if (CastingCD > WA_Marksman_ShowDataTimeFactor) then			-- Check if casting Cobra Shot
			if (CastingCD > 0.300) then
				Spell2 = Delay300
			elseif (CastingCD > 0.100) then
				Spell2 = Delay100
			else
				Spell2 = Delay20
			end

		elseif (GCDTimeLeft > WA_Marksman_ShowDataTimeFactor) then			-- NOT inside spam window
			if ((GCDTimeLeft - WA_Marksman_ShowDataTimeFactor) > .300) then			-- Check Longer Delay
				Spell2 = Delay300
			elseif ((GCDTimeLeft - WA_Marksman_ShowDataTimeFactor) > .100) then		-- Check Medium Delay
				Spell2 = Delay100
			else
				Spell2 = Delay20						-- Else Short Delay
			end
		else	
			if (MultiShotCD == 0) then
				Spell2 = WA_Marksman_MultiShot
			else
				Spell2 = WA_Marksman_SteadyShot
			end
		end


		--WA_Marksman_T1:SetText(MultiShotCD)				
		
		WA_Marksman_Data:SetVertexColor(Spell1,Spell2,Spell3)
		
	end -- WA_Marksman Code
end -- End OnUpdate 



function WA_Marksman_ToggleFrame_1_OnClick()
	if (WA_Marksman_Toggle_Do_1 == true) then
		WA_Marksman_Toggle_Do_1 = false
		WA_Marksman_ToggleIcon_1:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Marksman_ToggleIcon_1:SetVertexColor(1, 1,1, 1)
		WA_Marksman_Toggle_Do_1 = true
	end
end

function WA_Marksman_ToggleFrame_2_OnClick()
	if (WA_Marksman_Toggle_Do_2 == true) then
		WA_Marksman_Toggle_Do_2 = false
		WA_Marksman_ToggleIcon_2:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Marksman_ToggleIcon_2:SetVertexColor(1, 1,1, 1)
		WA_Marksman_Toggle_Do_2 = true
	end
end

function WA_Marksman_ToggleFrame_3_OnClick()
	if (WA_Marksman_Toggle_Do_3 == true) then
		WA_Marksman_Toggle_Do_3 = false
		WA_Marksman_ToggleIcon_3:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Marksman_ToggleIcon_3:SetVertexColor(1, 1,1, 1)
		WA_Marksman_Toggle_Do_3 = true
	end
end  