function WA_Unholy_Frame_OnLoad()

	--================= Register Events =======================
	WA_Unholy_Frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	WA_Unholy_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	WA_Unholy_Frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	WA_Unholy_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	--================= Global Variables ===================
	WA_Unholy_Enabled 			= false			-- Enables OnUpdate code execution
	WA_Unholy_Class 			= "Death Knight"
	WA_Unholy_ShowDataTimeFactor 	= 0.150			-- Time prior to a GCD finish when the color box will be shown
	WA_Unholy_GCD_Duration		= 1.0
	WA_Unholy_Toggle_Do_1 		= true
	WA_Unholy_Toggle_Do_2 		= true
	WA_Unholy_Toggle_Do_3		= true
	WA_Unholy_DarkTransformationHoldoffTime	= 10
	--================= Ability To Key Mappings ===================
	WA_Unholy_Outbreak = 0.1
	WA_Unholy_IcyTouch = 0.2
	WA_Unholy_PlagueStrike = 0.3
	WA_Unholy_ScourgeStrike = 0.4
	WA_Unholy_FesteringStrike = 0.5
	WA_Unholy_DeathCoil = 0.6
	WA_Unholy_DarkTransformation = 0.7
	WA_Unholy_BloodTap = 0.8
	WA_Unholy_Pestilence = 0.9
	WA_Unholy_BloodBoil = 1.0
	WA_Unholy_HornOfWinter = .95

	--================= Extra Function Mappings ===================
	Delay20 = 0.0
	Delay100 = 0.01
	Delay300 = 0.02
	Delay500 = 0.03
	Delay700 = 0.04	
	Delay900 = 0.05
	
	--================== Initialize Variables =====================
	ScourgeStrikeFinish = GetTime()
	FesteringStrikeFinish = GetTime()
	IcyTouchFinish = GetTime()
	DeathStrikeFinish = GetTime()
	BloodBoilFinish = GetTime()
	DarkTransformationFinish = GetTime()
	BloodTapFinish = GetTime()
	PestilenceFinish = GetTime()
	HornOfWinterFinish = GetTime()
	DarkTransformationFinish = GetTime()
end



function WA_Unholy_Frame_OnEvent(self, event, ...)

	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...
	if (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED") then
		_, _, _, _, WA_Unholy_PointsSpent, _, _, _ = GetTalentTabInfo(3)	-- Check that enough points are spent in the right tree

		if (UnitClass("player") ~= WA_Unholy_Class or WA_Unholy_PointsSpent < 31) then
			WA_Unholy_Frame:Hide()
			WA_Unholy_Enabled = false
		else
			--================= Ability Toggles Config ===================
			WA_Unholy_Frame:Show()
			_, _, DefensiveStanceIcon, _, _, _, _, _, _ = GetSpellInfo("Defensive Stance")
			_, _, ShockwaveIcon, _, _, _, _, _, _ = GetSpellInfo("Shockwave")
			_, _, ShockwaveIcon, _, _, _, _, _, _ = GetSpellInfo("Shockwave")
			WA_Unholy_ToggleIcon_1:SetTexture(nil)	
			WA_Unholy_ToggleIcon_2:SetTexture(nil)
			WA_Unholy_ToggleIcon_3:SetTexture(nil)

			WA_Unholy_Enabled = true
			WA_Unholy_T1:SetText("Unholy")	


		end
	end
end


function WA_Unholy_Frame_OnUpdate()

	if (WA_Unholy_Enabled == true) then
		RunicPower = UnitPower("player")	
		Health = UnitHealth("player")
		HealthMax = UnitHealthMax("player")
		HealthPercent = (Health / HealthMax) * 100

		-- ============================== GCD ================================
		GCDStart, GCDDuration, _ = GetSpellCooldown("Survey")
		if (GCDStart ~= 0) then
			
			GCDTimeLeft = GCDStart + GCDDuration - GetTime()
		else
			GCDTimeLeft = 0
		end

		-- ============================ Scourge Strike =============================
		-- Outputs:
		-- ScourgeStrikeCD 	
		--------------------------------------
		ScourgeStrikeStart, ScourgeStrikeDuration, _ = GetSpellCooldown("Scourge Strike")
		if (ScourgeStrikeStart ~= 0) then
			if (ScourgeStrikeDuration > WA_Unholy_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				ScourgeStrikeFinish = ScourgeStrikeStart + ScourgeStrikeDuration
				ScourgeStrikeCD = ScourgeStrikeFinish - GetTime()
			else
				if (ScourgeStrikeFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (ScourgeStrikeFinish - (ScourgeStrikeStart + ScourgeStrikeDuration) - WA_Unholy_ShowDataTimeFactor > 0) then
						ScourgeStrikeCD = 0
					else
						ScourgeStrikeCD = ScourgeStrikeFinish - GetTime()
					end
				else
					ScourgeStrikeCD = 0
				end
			end
			
		else
			ScourgeStrikeCD = 0
		end

		-- ============================ IcyTouch ============================
		-- Outputs:
		-- IcyTouchCD
		--------------------------------------
		IcyTouchStart, IcyTouchDuration, _ = GetSpellCooldown("Icy Touch")
		if (IcyTouchStart ~= 0) then
			if (IcyTouchDuration > WA_Unholy_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				IcyTouchFinish = IcyTouchStart + IcyTouchDuration
				IcyTouchCD = IcyTouchFinish - GetTime()
			else
				if (IcyTouchFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (IcyTouchFinish - (IcyTouchStart + IcyTouchDuration) - WA_Unholy_ShowDataTimeFactor > 0) then
						IcyTouchCD = 0
					else
						IcyTouchCD = IcyTouchFinish - GetTime()
					end
				else
					IcyTouchCD = 0
				end
			end
			
		else
			IcyTouchCD = 0
		end

		IcyTouchName, _, _, _, _, IcyTouchDuration, IcyTouchExpirationTime, IcyTouchUnitCaster, _ = UnitDebuff("target", "Frost Fever")
		if (IcyTouchName ~= nil and IcyTouchUnitCaster == "player") then
			IcyTouchCD = 30
		end
		-- ============================ PlagueStrike ============================
		-- Outputs:
		--PlagueStrikeCD
		--------------------------------------
		PlagueStrikeStart, PlagueStrikeDuration, _ = GetSpellCooldown("Plague Strike")
		if (PlagueStrikeStart ~= 0) then
			if (PlagueStrikeDuration > WA_Unholy_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				PlagueStrikeFinish = PlagueStrikeStart + PlagueStrikeDuration
				PlagueStrikeCD = PlagueStrikeFinish - GetTime()
			else
				if (PlagueStrikeFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (PlagueStrikeFinish - (PlagueStrikeStart + PlagueStrikeDuration) - WA_Unholy_ShowDataTimeFactor > 0) then
						PlagueStrikeCD = 0
					else
						PlagueStrikeCD = PlagueStrikeFinish - GetTime()
					end
				else
					PlagueStrikeCD = 0
				end
			end
			
		else
			PlagueStrikeCD = 0
		end

		PlagueStrikeName, _, _, _, _, PlagueStrikeDuration, PlagueStrikeExpirationTime, PlagueStrikeUnitCaster, _ = UnitDebuff("target", "Blood Plague")
		if (PlagueStrikeName ~= nil and PlagueStrikeUnitCaster == "player") then
			PlagueStrikeCD = 30
		end

		-- ============================ DeathStrike ============================
		-- Outputs:
		-- DeathStrikeCD
		--------------------------------------
		DeathStrikeStart, DeathStrikeDuration, _ = GetSpellCooldown("Death Strike")
		if (DeathStrikeStart ~= 0) then
			if (DeathStrikeDuration > WA_Unholy_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				DeathStrikeFinish = DeathStrikeStart + DeathStrikeDuration
				DeathStrikeCD = DeathStrikeFinish - GetTime()
			else
				if (DeathStrikeFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (DeathStrikeFinish - (DeathStrikeStart + DeathStrikeDuration) - WA_Unholy_ShowDataTimeFactor > 0) then
						DeathStrikeCD = 0
					else
						DeathStrikeCD = DeathStrikeFinish - GetTime()
					end
				else
					DeathStrikeCD = 0
				end
			end
			
		else
			DeathStrikeCD = 0
		end

		-- ============================ Outbreak ============================
		-- Outputs:
		-- OutbreakCD
		--------------------------------------
		OutbreakStart, OutbreakDuration, _ = GetSpellCooldown("Outbreak")
		OutbreakCD = OutbreakStart + OutbreakDuration - GetTime()
		if (OutbreakCD < 0) then
			OutbreakCD = 0
		end
	
		-- ============================ BloodTap ============================
		-- Outputs:
		-- BloodTapCD
		--------------------------------------
		BloodTapStart, BloodTapDuration, _ = GetSpellCooldown("Blood Tap")
		if (BloodTapStart ~= 0) then
			if (BloodTapDuration > WA_Unholy_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				BloodTapFinish = BloodTapStart + BloodTapDuration
				BloodTapCD = BloodTapFinish - GetTime()
			else
				if (BloodTapFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (BloodTapFinish - (BloodTapStart + BloodTapDuration) - WA_Unholy_ShowDataTimeFactor > 0) then
						BloodTapCD = 0
					else
						BloodTapCD = BloodTapFinish - GetTime()
					end
				else
					BloodTapCD = 0
				end
			end
			
		else
			BloodTapCD = 0
		end

		-- ============================ BloodBoil ============================
		-- Outputs:
		-- BloodBoilCD
		--------------------------------------
		BloodBoilStart, BloodBoilDuration, _ = GetSpellCooldown("Blood Boil")
		if (BloodBoilStart ~= 0) then
			if (BloodBoilDuration > WA_Unholy_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				BloodBoilFinish = BloodBoilStart + BloodBoilDuration
				BloodBoilCD = BloodBoilFinish - GetTime()
			else
				if (BloodBoilFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (BloodBoilFinish - (BloodBoilStart + BloodBoilDuration) - WA_Unholy_ShowDataTimeFactor > 0) then
						BloodBoilCD = 0
					else
						BloodBoilCD = BloodBoilFinish - GetTime()
					end
				else
					BloodBoilCD = 0
				end
			end
			
		else
			BloodBoilCD = 0
		end

		-- ============================ Pestilence ============================
		-- Outputs:
		-- PestilenceCD
		--------------------------------------
		PestilenceStart, PestilenceDuration, _ = GetSpellCooldown("Pestilence")
		if (PestilenceStart ~= 0) then
			if (PestilenceDuration > WA_Unholy_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				PestilenceFinish = PestilenceStart + PestilenceDuration
				PestilenceCD = PestilenceFinish - GetTime()
			else
				if (PestilenceFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (PestilenceFinish - (PestilenceStart + PestilenceDuration) - WA_Unholy_ShowDataTimeFactor > 0) then
						PestilenceCD = 0
					else
						PestilenceCD = PestilenceFinish - GetTime()
					end
				else
					PestilenceCD = 0
				end
			end
			
		else
			PestilenceCD = 0
		end
		
		-- ============================ FesteringStrike ============================
		-- Outputs:
		-- FesteringStrikeCD
		--------------------------------------
		FesteringStrikeStart, FesteringStrikeDuration, _ = GetSpellCooldown("Festering Strike")
		if (FesteringStrikeStart ~= 0) then
			if (FesteringStrikeDuration > WA_Unholy_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				FesteringStrikeFinish = FesteringStrikeStart + FesteringStrikeDuration
				FesteringStrikeCD = FesteringStrikeFinish - GetTime()
			else
				if (FesteringStrikeFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (FesteringStrikeFinish - (FesteringStrikeStart + FesteringStrikeDuration) - WA_Unholy_ShowDataTimeFactor > 0) then
						FesteringStrikeCD = 0
					else
						FesteringStrikeCD = FesteringStrikeFinish - GetTime()
					end
				else
					FesteringStrikeCD = 0
				end
			end
			
		else
			FesteringStrikeCD = 0
		end
		-- ============================ HornOfWinter ============================
		-- Outputs:
		-- HornOfWinterCD
		--------------------------------------
		HornOfWinterStart, HornOfWinterDuration, _ = GetSpellCooldown("Horn of Winter")
		if (HornOfWinterStart ~= 0) then
			if (HornOfWinterDuration > WA_Unholy_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				HornOfWinterFinish = HornOfWinterStart + HornOfWinterDuration
				HornOfWinterCD = HornOfWinterFinish - GetTime()
			else
				if (HornOfWinterFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (HornOfWinterFinish - (HornOfWinterStart + HornOfWinterDuration) - WA_Unholy_ShowDataTimeFactor > 0) then
						HornOfWinterCD = 0
					else
						HornOfWinterCD = HornOfWinterFinish - GetTime()
					end
				else
					HornOfWinterCD = 0
				end
			end
			
		else
			HornOfWinterCD = 0
		end


		-- ============================ DarkTransformation ============================
		-- Outputs:
		-- DarkTransformationCD
		--------------------------------------
		DarkTransformationStart, DarkTransformationDuration, _ = GetSpellCooldown("Dark Transformation")
		if (DarkTransformationStart ~= 0) then
			if (DarkTransformationDuration > WA_Unholy_GCD_Duration) then			-- Calc CD based on a non GCD duration 
				DarkTransformationFinish = DarkTransformationStart + DarkTransformationDuration
				DarkTransformationCD = DarkTransformationFinish - GetTime()
			else
				if (DarkTransformationFinish - GetTime() > 0) then		--check if finish is even relevant, if not cd = 0
					if (DarkTransformationFinish - (DarkTransformationStart + DarkTransformationDuration) - WA_Unholy_ShowDataTimeFactor > 0) then
						DarkTransformationCD = 0
					else
						DarkTransformationCD = DarkTransformationFinish - GetTime()
					end
				else
					DarkTransformationCD = 0
				end
			end
			
		else
			DarkTransformationCD = 0
		end
		
		ShadowInfusionName, _, _, ShadowInfusionCount, _, ShadowInfusionDuration, ShadowInfusionExpirationTime, _, _,  _, _ = UnitBuff("pet", "Shadow Infusion")
		if (ShadowInfusionName == nil) then
			ShadowInfusionCount = 0
		end


		-- ============================ DeathCoil ============================
		-- Outputs:
		-- DeathCoilCD
		--------------------------------------
		_, _, _, DeathCoilCost, _, _, _, _, _ = GetSpellInfo("Death Coil")
		if (RunicPower < DeathCoilCost) then
			DeathCoilCD = 30
		else
			DeathCoilCD = 0
		end

		-- ============================ SuddenDoom ============================
		-- Outputs:
		-- SuddenDoomCD
		--------------------------------------
		SuddenDoomName, _, _, SuddenDoomCount, _, SuddenDoomDuration, SuddenDoomExpirationTime, _, _,  _, _ = UnitBuff("player", "Sudden Doom")
		if (SuddenDoomName == nil) then
			SuddenDoomCD = 30
		else
			SuddenDoomCD = 0
		end

		-- ============================ RunicCorruption ============================
		-- Outputs:
		-- RunicCorruptionCD
		--------------------------------------
		RunicCorruptionName, _, _, RunicCorruptionCount, _, RunicCorruptionDuration, RunicCorruptionExpirationTime, _, _,  _, _ = UnitBuff("player", "Runic Corruption")
		if (RunicCorruptionName ~= nil) then
			RunicCorruptionCD = RunicCorruptionExpirationTime - GetTime()
		else
			RunicCorruptionCD = 0
		end

		-- ============================ PetDarkTransformation ============================
		-- Outputs:
		-- PetDarkTransformationCD
		--------------------------------------
		PetDarkTransformationName, _, _, PetDarkTransformationCount, _, PetDarkTransformationDuration, PetDarkTransformationExpirationTime, _, _,  _, _ = UnitBuff("pet", "Dark Transformation")
		if (PetDarkTransformationName ~= nil) then
			PetDarkTransformationCD = PetDarkTransformationExpirationTime - GetTime()
		else
			PetDarkTransformationCD = 30
		end


		-- ============================ FrostFever ============================
		-- Outputs:
		-- FrostFeverCD
		--------------------------------------
		FrostFeverName, _, _, _, _, FrostFeverDuration, FrostFeverExpirationTime, FrostFeverUnitCaster, _ = UnitDebuff("target", "Frost Fever")
		if (FrostFeverName ~= nil and FrostFeverUnitCaster == "player") then
			FrostFeverCD = FrostFeverExpirationTime - GetTime()
		else
			FrostFeverCD = 0
		end	

		-- ============================ BloodPlague ============================
		-- Outputs:
		-- BloodPlagueCD
		--------------------------------------
		BloodPlagueName, _, _, _, _, BloodPlagueDuration, BloodPlagueExpirationTime, BloodPlagueUnitCaster, _ = UnitDebuff("target", "Blood Plague")
		if (BloodPlagueName ~= nil and BloodPlagueUnitCaster == "player") then
			BloodPlagueCD = BloodPlagueExpirationTime - GetTime()
		else
			BloodPlagueCD = 0
		end	
		


		--====================================================================
		--============================== LOGIC TREE ===========================
		--====================================================================

		-- =============== Single Target Logic ==================
		 if (GCDTimeLeft > WA_Unholy_ShowDataTimeFactor) then			-- NOT inside spam window
			if ((GCDTimeLeft - WA_Unholy_ShowDataTimeFactor) > .300) then		-- Check Longer Delay
				Spell1 = Delay300
			elseif ((GCDTimeLeft - WA_Unholy_ShowDataTimeFactor) > .100) then		-- Check Medium Delay
				Spell1 = Delay100
			else
				Spell1 = Delay20						-- Else Short Delay
			end
		else								-- Inside spam window
			if (IcyTouchCD == 0 ) then
				if (OutbreakCD == 0) then
					Spell1 = WA_Unholy_Outbreak
				else
					Spell1 = WA_Unholy_IcyTouch
				end
			elseif (PlagueStrikeCD == 0 ) then
				if (OutbreakCD == 0) then
					Spell1 = WA_Unholy_Outbreak
				else
					Spell1 = WA_Unholy_PlagueStrike
				end
			elseif (FrostFeverCD < 3 or BloodPlagueCD < 3) then
				if (FesteringStrikeCD == 0) then
					Spell1 = WA_Unholy_FesteringStrike
				elseif (DeathCoilCD == 0 and PetDarkTransformationCD >= WA_Unholy_DarkTransformationHoldoffTime) then
					Spell1 = WA_Unholy_DeathCoil
				elseif (HornOfWinterCD == 0) then
					Spell1 = WA_Unholy_HornOfWinter
				elseif (OutbreakCD == 0) then
					Spell1 = WA_Unholy_Outbreak
				else
					Spell1 = Delay20
				end
			elseif (ShadowInfusionCount == 5) then
				if (DarkTransformationCD == 0) then
					Spell1 = WA_Unholy_DarkTransformation
				elseif (BloodTapCD == 0) then
					Spell1 = WA_Unholy_BloodTap
				elseif (FesteringStrikeCD == 0) then
					Spell1 = WA_Unholy_FesteringStrike
				elseif ((DeathCoilCD == 0 and PetDarkTransformationCD >= WA_Unholy_DarkTransformationHoldoffTime) or SuddenDoomCD == 0) then
					Spell1 = WA_Unholy_DeathCoil
				elseif (HornOfWinterCD == 0) then
					Spell1 = WA_Unholy_HornOfWinter
				elseif (OutbreakCD == 0) then
					Spell1 = WA_Unholy_Outbreak
				else
					Spell1 = Delay20
				end
			elseif (SuddenDoomCD == 0 or RunicPower >= 80) then
				Spell1 = WA_Unholy_DeathCoil
			elseif (ScourgeStrikeCD == 0) then
				Spell1 = WA_Unholy_ScourgeStrike
			elseif (DeathCoilCD == 0 and PetDarkTransformationCD >= WA_Unholy_DarkTransformationHoldoffTime) then
				Spell1 = WA_Unholy_DeathCoil
			elseif (FesteringStrikeCD == 0) then
				Spell1 = WA_Unholy_FesteringStrike
			else
				if (BloodTapCD == 0) then
					Spell1 = WA_Unholy_BloodTap
				elseif (HornOfWinterCD == 0) then
					Spell1 = WA_Unholy_HornOfWinter
				else
					Spell1 = Delay20
				end
			end

		end

		-- =============== Multi Target Logic===================
		--WA_Unholy_T1:SetText(IcyTouchUnitCaster)	
		
		WA_Unholy_Data:SetVertexColor(Spell1,Spell2,Spell3)
		
	end -- WA_Unholy Code
end -- End OnUpdate 



function WA_Unholy_ToggleFrame_1_OnClick()
	if (WA_Unholy_Toggle_Do_1 == true) then
		WA_Unholy_Toggle_Do_1 = false
		WA_Unholy_ToggleIcon_1:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Unholy_ToggleIcon_1:SetVertexColor(1, 1,1, 1)
		WA_Unholy_Toggle_Do_1 = true
	end
end

function WA_Unholy_ToggleFrame_2_OnClick()
	if (WA_Unholy_Toggle_Do_2 == true) then
		WA_Unholy_Toggle_Do_2 = false
		WA_Unholy_ToggleIcon_2:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Unholy_ToggleIcon_2:SetVertexColor(1, 1,1, 1)
		WA_Unholy_Toggle_Do_2 = true
	end
end

function WA_Unholy_ToggleFrame_3_OnClick()
	if (WA_Unholy_Toggle_Do_3 == true) then
		WA_Unholy_Toggle_Do_3 = false
		WA_Unholy_ToggleIcon_3:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Unholy_ToggleIcon_3:SetVertexColor(1, 1,1, 1)
		WA_Unholy_Toggle_Do_3 = true
	end
end  