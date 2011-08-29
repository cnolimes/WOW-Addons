function WA_Blood_Frame_OnLoad()

	--================= Register Events =======================
	WA_Blood_Frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	WA_Blood_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	WA_Blood_Frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	WA_Blood_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	--================= Global Variables ===================
	WA_Blood_Enabled 			= false			-- Enables OnUpdate code execution
	WA_Blood_Class 			= "Death Knight"
	WA_Blood_ShowDataTimeFactor 	= 0.150			-- Time prior to a GCD finish when the color box will be shown

	WA_Blood_Toggle_Do_1 		= true
	WA_Blood_Toggle_Do_2 		= true
	WA_Blood_Toggle_Do_3		= true

	--================= Ability To Key Mappings ===================
	WA_Blood_HeartStrike = 0.1
	WA_Blood_RuneStrike = 0.2
	WA_Blood_DeathStrike = 0.3
	WA_Blood_IcyTouch = 0.4
	WA_Blood_BloodTap = 0.5
	WA_Blood_Outbreak = 0.6
	WA_Blood_BloodBoil = 0.7
	WA_Blood_Pestilence = 0.8
	WA_Blood_RuneTap = 0.9
	WA_Blood_PlagueStrike = 1.0
	WA_Blood_HornOfWinter = .95

	--================= Extra Function Mappings ===================
	Delay20 = 0.0
	Delay100 = 0.01
	Delay300 = 0.02
	Delay500 = 0.03
	Delay700 = 0.04	
	Delay900 = 0.05
	
	--================== Initialize Variables =====================
	HeartStrikeFinish = GetTime()
	IcyTouchFinish = GetTime()
	DeathStrikeFinish = GetTime()
	BloodBoilFinish = GetTime()
	BloodTapFinish = GetTime()
	PestilenceFinish = GetTime()
	HornOfWinterFinish = GetTime()
end



function WA_Blood_Frame_OnEvent(self, event, ...)

	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...
	if (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED") then
		_, _, _, _, WA_Blood_PointsSpent, _, _, _ = GetTalentTabInfo(1)	-- Check that enough points are spent in the right tree

		if (UnitClass("player") ~= WA_Blood_Class or WA_Blood_PointsSpent < 31) then
			WA_Blood_Frame:Hide()
			WA_Blood_Enabled = false
		else
			--================= Ability Toggles Config ===================
			WA_Blood_Frame:Show()
			_, _, DefensiveStanceIcon, _, _, _, _, _, _ = GetSpellInfo("Defensive Stance")
			_, _, ShockwaveIcon, _, _, _, _, _, _ = GetSpellInfo("Shockwave")
			_, _, ShockwaveIcon, _, _, _, _, _, _ = GetSpellInfo("Shockwave")
			WA_Blood_ToggleIcon_1:SetTexture(nil)	
			WA_Blood_ToggleIcon_2:SetTexture(nil)
			WA_Blood_ToggleIcon_3:SetTexture(nil)

			WA_Blood_Enabled = true
			WA_Blood_T1:SetText("Blood")	


		end
	end

	--if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
	--	--if (arg4 == "Bellefleur" and (arg10 == "Arcane Shot" or arg10 == "Cobra Shot" or arg10 == "Explosive Shot" or arg10 == "Black Arrow" or arg10 == "Multi Shot") ) then
	--	if (arg4 == "Bellefleur" and arg2 == "SPELL_CAST_SUCCESS" ) then
	--		print(arg10, "   Focus =  ",Focus)
	--	end
	--end
end


function WA_Blood_Frame_OnUpdate()

	if (WA_Blood_Enabled == true) then
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

		-- ============================ HeartStrike ============================
		-- Outputs:
		-- HeartStrikeCD
		--------------------------------------
		HeartStrikeStart, HeartStrikeDuration, _ = GetSpellCooldown("Heart Strike")
		if (HeartStrikeStart ~= 0) then
			if (HeartStrikeDuration > 1.5) then
				HeartStrikeFinish = HeartStrikeStart + HeartStrikeDuration
			end
		else
			HeartStrikeFinish = GetTime()
		end
		HeartStrikeCD = HeartStrikeFinish - GetTime()
		if (HeartStrikeCD <= 0) then
			HeartStrikeCD = 0
		end
		BloodRune1Start, _, _ = GetRuneCooldown(1)
		BloodRune2Start, _, _ = GetRuneCooldown(2)
		if (BloodRune1Start  > 0 and BloodRune2Start > 0) then
			HeartStrikeCD  = 50
		end
		-- ============================ IcyTouch ============================
		-- Outputs:
		-- IcyTouchCD
		--------------------------------------
		IcyTouchStart, IcyTouchDuration, _ = GetSpellCooldown("Icy Touch")
		if (IcyTouchStart ~= 0) then
			if (IcyTouchDuration > 1.5) then
				IcyTouchFinish = IcyTouchStart + IcyTouchDuration
			end
		else
			IcyTouchFinish = GetTime()
		end
		IcyTouchCD = IcyTouchFinish - GetTime()
		if (IcyTouchCD <= 0) then
			IcyTouchCD = 0
		end

		IcyTouchName, _, _, _, _, IcyTouchDuration, IcyTouchExpirationTime, UnitCaster, _ = UnitDebuff("target", "Frost Fever")
		if (IcyTouchName ~= nil) then
			IcyTouchCD = 30
		end
		-- ============================ PlagueStrike ============================
		-- Outputs:
		--PlagueStrikeCD
		--------------------------------------
		PlagueStrikeStart, PlagueStrikeDuration, _ = GetSpellCooldown("Plague Strike")
		if (PlagueStrikeStart ~= 0) then
			if (PlagueStrikeDuration > 1.5) then
				PlagueStrikeFinish = PlagueStrikeStart + PlagueStrikeDuration
			end
		else
			PlagueStrikeFinish = GetTime()
		end
		PlagueStrikeCD = PlagueStrikeFinish - GetTime()
		if (PlagueStrikeCD <= 0) then
			PlagueStrikeCD = 0
		end

		PlagueStrikeName, _, _, _, _, PlagueStrikeDuration, PlagueStrikeExpirationTime, UnitCaster, _ = UnitDebuff("target", "Blood Plague")
		if (PlagueStrikeName ~= nil) then
			PlagueStrikeCD = 30
		end
	
		-- ============================ DeathStrike ============================
		-- Outputs:
		-- DeathStrikeCD
		--------------------------------------
		DeathStrikeStart, DeathStrikeDuration, _ = GetSpellCooldown("Death Strike")
		if (DeathStrikeStart ~= 0) then
			if (DeathStrikeDuration > 1.5) then
				DeathStrikeFinish = DeathStrikeStart + DeathStrikeDuration
			end
		else
			DeathStrikeFinish = GetTime()
		end
		DeathStrikeCD = DeathStrikeFinish - GetTime()
		if (DeathStrikeCD < 0) then
			DeathStrikeCD = 0
		end

		-- ============================ RuneStrike ============================
		-- Outputs:
		-- RuneStrikeCD
		--------------------------------------
		_, _, _, RuneStrikeCost, _, _, _, _, _ = GetSpellInfo("Rune Strike")
		if (RunicPower < RuneStrikeCost) then
			RuneStrikeCD = 30
		else
			RuneStrikeCD = 0
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
			if (BloodTapDuration > 1.5) then
				BloodTapFinish = BloodTapStart + BloodTapDuration
			end
		end
		BloodTapCD = BloodTapFinish - GetTime()
		if (BloodTapCD < 0) then
			BloodTapCD = 0
		end

		-- ============================ BloodBoil ============================
		-- Outputs:
		-- BloodBoilCD
		--------------------------------------
		BloodBoilStart, BloodBoilDuration, _ = GetSpellCooldown("Blood Boil")
		if (BloodBoilStart ~= 0) then
			if (BloodBoilDuration > 1.5) then
				BloodBoilFinish = BloodBoilStart + BloodBoilDuration
			end
		else
			BloodBoilFinish = GetTime()
		end
		BloodBoilCD = BloodBoilFinish - GetTime()
		if (BloodBoilCD <= 0) then
			BloodBoilCD = 0
		end

		-- ============================ Pestilence ============================
		-- Outputs:
		-- PestilenceCD
		--------------------------------------
		PestilenceStart, PestilenceDuration, _ = GetSpellCooldown("Pestilence")
		if (PestilenceStart ~= 0) then
			if (PestilenceDuration > 1.5) then
				PestilenceFinish = PestilenceStart + PestilenceDuration
			end
		else
			PestilenceFinish = GetTime()
		end
		PestilenceCD = PestilenceFinish - GetTime()
		if (PestilenceCD <= 0) then
			PestilenceCD = 0
		end
		
		-- ============================ HornOfWinter ============================
		-- Outputs:
		-- HornOfWinterCD
		--------------------------------------
		HornOfWinterStart, HornOfWinterDuration, _ = GetSpellCooldown("Horn of Winter")
		if (HornOfWinterStart ~= 0) then
			if (HornOfWinterDuration > 1.5) then
				HornOfWinterFinish = HornOfWinterStart + HornOfWinterDuration
			end
		end
		HornOfWinterCD = HornOfWinterFinish - GetTime()
		if (HornOfWinterCD <= 0) then
			HornOfWinterCD = 0
		end

		--====================================================================
		--============================== LOGIC TREE ===========================
		--====================================================================

		-- =============== Single Target Logic ==================
		 if (GCDTimeLeft > WA_Blood_ShowDataTimeFactor) then			-- NOT inside spam window
		-- if (GCDTimeLeft > 0) then			-- NOT inside spam window
			if ((GCDTimeLeft - WA_Blood_ShowDataTimeFactor) > .300) then			-- Check Longer Delay
				Spell1 = Delay300
			elseif ((GCDTimeLeft - WA_Blood_ShowDataTimeFactor) > .100) then		-- Check Medium Delay
				Spell1 = Delay100
			else
				Spell1 = Delay20						-- Else Short Delay
			end
		else								-- Inside spam window
			if (HealthPercent <= 93 and DeathStrikeCD == 0) then
				Spell1 = WA_Blood_DeathStrike

			elseif (IcyTouchCD == 0 ) then
				if (OutbreakCD == 0) then
					Spell1 = WA_Blood_Outbreak
				else
					Spell1 = WA_Blood_IcyTouch
				end
			elseif (PlagueStrikeCD == 0 ) then
				if (OutbreakCD == 0) then
					Spell1 = WA_Blood_Outbreak
				else
					Spell1 = WA_Blood_PlagueStrike
				end
			elseif (RuneStrikeCD == 0 and RunicPower >= 110) then
				Spell1 = WA_Blood_RuneStrike


			elseif (DeathStrikeCD == 0) then
				Spell1 = WA_Blood_DeathStrike

			elseif (HeartStrikeCD == 0) then
				Spell1 = WA_Blood_HeartStrike

			elseif (RuneStrikeCD == 0 and RunicPower >= 70) then
				Spell1 = WA_Blood_RuneStrike
			else
				if (BloodTapCD == 0) then
					Spell1 = WA_Blood_BloodTap
				elseif (HornOfWinterCD == 0) then
					Spell1 = WA_Blood_HornOfWinter
				else
					Spell1 = Delay20
				end
			end

		end

		-- =============== Multi Target Logic===================
		--WA_Blood_T1:SetText(HeartStrikeCD)	
		
		WA_Blood_Data:SetVertexColor(Spell1,Spell2,Spell3)
		
	end -- WA_Blood Code
end -- End OnUpdate 



function WA_Blood_ToggleFrame_1_OnClick()
	if (WA_Blood_Toggle_Do_1 == true) then
		WA_Blood_Toggle_Do_1 = false
		WA_Blood_ToggleIcon_1:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Blood_ToggleIcon_1:SetVertexColor(1, 1,1, 1)
		WA_Blood_Toggle_Do_1 = true
	end
end

function WA_Blood_ToggleFrame_2_OnClick()
	if (WA_Blood_Toggle_Do_2 == true) then
		WA_Blood_Toggle_Do_2 = false
		WA_Blood_ToggleIcon_2:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Blood_ToggleIcon_2:SetVertexColor(1, 1,1, 1)
		WA_Blood_Toggle_Do_2 = true
	end
end

function WA_Blood_ToggleFrame_3_OnClick()
	if (WA_Blood_Toggle_Do_3 == true) then
		WA_Blood_Toggle_Do_3 = false
		WA_Blood_ToggleIcon_3:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Blood_ToggleIcon_3:SetVertexColor(1, 1,1, 1)
		WA_Blood_Toggle_Do_3 = true
	end
end  