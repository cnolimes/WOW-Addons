function WA_Survival_Frame_OnLoad()

	--================= Register Events =======================
	WA_Survival_Frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	WA_Survival_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	WA_Survival_Frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	WA_Survival_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	--================= Global Variables ===================
	WA_Survival_Enabled 			= false			-- Enables OnUpdate code execution
	WA_Survival_Class 			= "Hunter"
	WA_Survival_ShowDataTimeFactor 	= 0.150	-- Time prior to a GCD finish when the color box will be shown
	WA_Survival_FocusPoolValue		= 80
	WA_Survival_Toggle_Do_1 		= true
	WA_Survival_Toggle_Do_2 		= true
	WA_Survival_Toggle_Do_3		= true

	--================= Ability To Key Mappings ===================
	WA_Survival_SerpentSting = 0.1
	WA_Survival_ExplosiveShot = 0.2
	WA_Survival_CobraShot= 0.3
	WA_Survival_BlackArrow= 0.4
	WA_Survival_KillShot = 0.5
	WA_Survival_ArcaneShot = 0.6
	WA_Survival_MultiShot = 0.7
	WA_Survival_8 = 0.8
	WA_Survival_9 = 0.9
	WA_Survival_10 = 1.0

	--================= Extra Function Mappings ===================
	Delay20 = 0.0
	Delay100 = 0.01
	Delay300 = 0.02
	Delay500 = 0.03
	Delay700 = 0.04	
	Delay900 = 0.05
	
	--================== Initialize Variables =====================
	ExplosiveShotFinish = GetTime()
	BlackArrowFinish = GetTime()
end



function WA_Survival_Frame_OnEvent(self, event, ...)

	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...
	if (event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED") then
		_, _, _, _, WA_Survival_PointsSpent, _, _, _ = GetTalentTabInfo(3)	-- Check that enough points are spent in the right tree

		if (UnitClass("player") ~= WA_Survival_Class or WA_Survival_PointsSpent < 31) then
			WA_Survival_Frame:Hide()
			WA_Survival_Enabled = false
		else
			--================= Ability Toggles Config ===================
			WA_Survival_Frame:Show()
			_, _, SerpentStingIcon, _, _, _, _, _, _ = GetSpellInfo("Serpent Sting")
			_, _, BlackArrowIcon, _, _, _, _, _, _ = GetSpellInfo("Black Arrow")
			_, _, ShockwaveIcon, _, _, _, _, _, _ = GetSpellInfo("Shockwave")
			WA_Survival_ToggleIcon_1:SetTexture(SerpentStingIcon)	
			WA_Survival_ToggleIcon_2:SetTexture(BlackArrowIcon)
			WA_Survival_ToggleIcon_3:SetTexture(nil)

			WA_Survival_Enabled = true
			WA_Survival_T1:SetText("Surv")	


		end
	end

	--if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
	--	--if (arg4 == "Bellefleur" and (arg10 == "Arcane Shot" or arg10 == "Cobra Shot" or arg10 == "Explosive Shot" or arg10 == "Black Arrow" or arg10 == "Multi Shot") ) then
	--	if (arg4 == "Bellefleur" and arg2 == "SPELL_CAST_SUCCESS" ) then
	--		print(arg10, "   Focus =  ",Focus)
	--	end
	--end
end


function WA_Survival_Frame_OnUpdate()

	if (WA_Survival_Enabled == true) then
		Focus = UnitPower("player")	

		-- ============================== GCD ================================
		GCDStart, GCDDuration, _ = GetSpellCooldown("Arcane Shot")
		if (GCDStart ~= 0) then
			
			GCDTimeLeft = GCDStart + GCDDuration - GetTime()
		else
			GCDTimeLeft = 0
		end

		-- ============================ LockAndLoad ============================
		-- Outputs:
		-- LockAndLoadCD
		--------------------------------------

		LockAndLoadName, _, _,_, _, _, LockAndLoadExpirationTime, _, _, _, _ = UnitBuff("player", "Lock and Load") 
		if (LockAndLoadName ~= nil) then
			LockAndLoadCD = LockAndLoadExpirationTime - GetTime()
		else
			LockAndLoadCD = 0
		end

		-- ============================ Explosive Shot =============================
		-- Outputs:
		-- ExplosiveShotCD
		-- ExplosiveShotDotCD
		--------------------------------------
		ExplosiveShotStart, ExplosiveShotDuration , _ = GetSpellCooldown("Explosive Shot")
		if (ExplosiveShotStart ~= 0) then
			if (ExplosiveShotDuration > 1) then
				ExplosiveShotFinish = ExplosiveShotStart + ExplosiveShotDuration
			end	
		end
		ExplosiveShotCD = ExplosiveShotFinish - GetTime()
		if (ExplosiveShotCD < 0) then
			ExplosiveShotCD = 0
		end
		
		

		_, _, _, ExplosiveShotCost, _, _, _, _, _ = GetSpellInfo("Explosive Shot")
		if (Focus < ExplosiveShotCost) then
			ExplosiveShotCD = 30
		end

		if (LockAndLoadCD > 0) then
			ExplosiveShotCD = 0
			ExplosiveShotFinish = 0
		end
		
		ExplosiveShotDotName, _, _, _, _, ExplosiveShotDotDuration, ExplosiveShotDotExpirationTime, UnitCaster, _ = UnitDebuff("target", "Explosive Shot")
		if (ExplosiveShotDotName ~= nil and UnitCaster == "player") then
			ExplosiveShotDotCD = ExplosiveShotDotExpirationTime - GetTime()
		else
			ExplosiveShotDotCD = 0
		end


		-- ============================ Black Arrow =============================
		-- Outputs:
		-- BlackArrowCD
		--------------------------------------
		BlackArrowStart, BlackArrowDuration , _ = GetSpellCooldown("Black Arrow")
		if (BlackArrowStart ~= 0) then
			if (BlackArrowDuration > 1) then
				BlackArrowFinish = BlackArrowStart + BlackArrowDuration
			end	
		end
		BlackArrowCD = BlackArrowFinish - GetTime()
		if (BlackArrowCD < 0) then
			BlackArrowCD = 0
		end

		_, _, _, BlackArrowCost, _, _, _, _, _ = GetSpellInfo("Black Arrow")
		if (Focus < BlackArrowCost) then
			BlackArrowCD = 30
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
		KillShotCD = 30

		
		-- ============================ Cobra Shot  ==============================
		-- Outputs:
		--CobraShotCD
		--------------------------------------
		CobraShotSpell, _, _, _, CobraShotStartTime, CobraShotEndTime, _, _, _ = UnitCastingInfo("player")
		if (CobraShotStartTime ~= nil and CobraShotSpell == "Cobra Shot") then
			CobraShotCD = (CobraShotEndTime/1000) - GetTime()
		else
			CobraShotCD = 0
		end


		--====================================================================
		--============================== LOGIC TREE ===========================
		--====================================================================

		-- The most basic priority for single targets will be something like this:
		-- 1. Apply Serpent Sting, especially for the Noxious Stings effect.
		-- 2. Explosive Shot
		-- 3. If mob is below 20% health, Kill Shot
		-- 4. If mob will be alive long enough, Black Arrow
		-- 5. If you will have enough focus to use Explosive Shot and Black Arrow, use Arcane Shot
		-- 6. Cobra Shot

		-- This becomes much more complicated to execute in practice for a few reasons. One, Thrill of the Hunt procs lead to a somewhat 
		-- unpredictable focus regeneration rate. Two, number 5 can be difficult to compute since you would also want to take into account how 
		-- much focus you will regenerate in the time before those abilities come off of cooldown. Generally, it is fine to pool focus so long as you 
		-- are not capping (reaching 100 focus) or delaying abilities that use a cooldown. Pooling too much focus is probably not ideal because it can 
		-- quickly lead to capping focus with a string of Thrill of the Hunt procs or a Lock and Load proc. Which leads to point three, Lock and Load complications.

		--

		-- =============== Single Target Logic ==================
		if (CobraShotCD > WA_Survival_ShowDataTimeFactor) then			-- Check if casting Cobra Shot
			if (CobraShotCD > 0.300) then
				Spell1 = Delay300
			elseif (CobraShotCD > 0.100) then
				Spell1 = Delay100
			else
				Spell1 = Delay20
			end

		elseif (GCDTimeLeft > WA_Survival_ShowDataTimeFactor) then			-- NOT inside spam window
			if ((GCDTimeLeft - WA_Survival_ShowDataTimeFactor) > .300) then			-- Check Longer Delay
				Spell1 = Delay300
			elseif ((GCDTimeLeft - WA_Survival_ShowDataTimeFactor) > .100) then		-- Check Medium Delay
				Spell1 = Delay100
			else
				Spell1 = Delay20						-- Else Short Delay
			end
		else								-- Inside spam window
			if (LockAndLoadCD > 0) then
				if (ExplosiveShotDotCD  <= 1) then
					Spell1 = WA_Survival_ExplosiveShot
				else
					Spell1 = WA_Survival_ArcaneShot
				end
			elseif (SerpentStingCD == 0 and WA_Survival_Toggle_Do_1 == true) then
				Spell1 = WA_Survival_SerpentSting
			elseif (ExplosiveShotCD == 0) then
				Spell1 = WA_Survival_ExplosiveShot
			elseif (BlackArrowCD == 0 and WA_Survival_Toggle_Do_2 == true) then
				Spell1 = WA_Survival_BlackArrow
			elseif (KillShotCD == 0) then
				Spell1 = WA_Survival_KillShot
			elseif (Focus >= WA_Survival_FocusPoolValue) then
				Spell1 = WA_Survival_ArcaneShot
			else
				Spell1 = WA_Survival_CobraShot
			end
		end









		-- =============== Multi Target Logic===================
		if (CobraShotCD > WA_Survival_ShowDataTimeFactor) then			-- Check if casting Cobra Shot
			if (CobraShotCD > 0.300) then
				Spell2 = Delay300
			elseif (CobraShotCD > 0.100) then
				Spell2 = Delay100
			else
				Spell2 = Delay20
			end

		elseif (GCDTimeLeft > WA_Survival_ShowDataTimeFactor) then			-- NOT inside spam window
			if ((GCDTimeLeft - WA_Survival_ShowDataTimeFactor) > .300) then			-- Check Longer Delay
				Spell2 = Delay300
			elseif ((GCDTimeLeft - WA_Survival_ShowDataTimeFactor) > .100) then		-- Check Medium Delay
				Spell2 = Delay100
			else
				Spell2 = Delay20						-- Else Short Delay
			end
		else	
			if (MultiShotCD == 0) then
				Spell2 = WA_Survival_MultiShot
			else
				Spell2 = WA_Survival_CobraShot
			end
		end

		--usable, nomana = IsUsableSpell("Kill Shot")
		--WA_Survival_T1:SetText(usable)				
		
		WA_Survival_Data:SetVertexColor(Spell1,Spell2,Spell3)
		
	end -- WA_Survival Code
end -- End OnUpdate 



function WA_Survival_ToggleFrame_1_OnClick()
	if (WA_Survival_Toggle_Do_1 == true) then
		WA_Survival_Toggle_Do_1 = false
		WA_Survival_ToggleIcon_1:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Survival_ToggleIcon_1:SetVertexColor(1, 1,1, 1)
		WA_Survival_Toggle_Do_1 = true
	end
end

function WA_Survival_ToggleFrame_2_OnClick()
	if (WA_Survival_Toggle_Do_2 == true) then
		WA_Survival_Toggle_Do_2 = false
		WA_Survival_ToggleIcon_2:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Survival_ToggleIcon_2:SetVertexColor(1, 1,1, 1)
		WA_Survival_Toggle_Do_2 = true
	end
end

function WA_Survival_ToggleFrame_3_OnClick()
	if (WA_Survival_Toggle_Do_3 == true) then
		WA_Survival_Toggle_Do_3 = false
		WA_Survival_ToggleIcon_3:SetVertexColor(1, 1,1, 0.2)
	else
		WA_Survival_ToggleIcon_3:SetVertexColor(1, 1,1, 1)
		WA_Survival_Toggle_Do_3 = true
	end
end  