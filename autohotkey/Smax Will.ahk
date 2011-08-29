; ============================ Configuration ==============================

; -------------------- Keys ----------------------
Ability_1_Key	= {Numpad1}		; 	= 0.1
Ability_2_Key	= {Numpad2}		; 	= 0.2
Ability_3_Key	= {Numpad3}		; 	= 0.3
Ability_4_Key	= {Numpad4}		; 	= 0.4
Ability_5_Key	= {Numpad5}		;	= 0.5
Ability_6_Key	= {Numpad6}		;   = 0.6
Ability_7_Key	= {Numpad7}		;   = 0.7
Ability_8_Key	= {Numpad8}		;   = 0.8
Ability_9_Key	= {Numpad9}		;   = 0.9
Ability_10_Key	= {Numpad0}		;   = 1.0
Ability_11_Key	= {NumpadDot}	;   = 0.95

; ---------------- Ability Colors -----------------
Ability_1_Color 	= 1A
Ability_2_Color 	= 33
Ability_3_Color 	= 4D
Ability_4_Color 	= 66
Ability_5_Color 	= 80
Ability_6_Color 	= 99
Ability_7_Color 	= B3
Ability_8_Color 	= CC
Ability_9_Color 	= E6
Ability_10_Color 	= FF
Ability_11_Color 	= F2

; ---------------- Special Colors -----------------
Delay20 		= 00		;	= 0.00
Delay100		= 03		;	= 0.01
Delay300 		= 05		;	= 0.02
Delay500 		= 08		;	= 0.03
Delay700 		= 0A		;	= 0.04
Delay900 		= 0D		;	= 0.05

; --------------- Color Box Location --------------
DataBox_X = 1891
DataBox_Y = 365


; ============================= On/Off Code ===============================
; Macros Enabled Vars
#EscapeChar \
Macro_Enabled = 1
SetScrollLockState On

$f9:: 
Suspend, Toggle
if Macro_Enabled = 1
{
	SetScrollLockState Off
	Macro_Enabled = 0
}
else
{
	SetScrollLockState On
	Macro_Enabled = 1
}
return

; ============================= Emergency Color Box Remap ===============================
$f12::  
MouseGetPos, DataBox_X, DataBox_Y
return

; ============================= Emergency Get Mouse Pos/Color============================
$f11::  
MouseGetPos, MouseX, MouseY
PixelGetColor, ColorString, %MouseX%, %MouseY%, RGB
MsgBox %MouseX%, %MouseY%,  color %ColorString%
return


; ========================= Thread 1 Attack Key ======================
$r::
;sleep 1000   ; autopilot
Loop
{
	; ================== Check for Loop Exit ===================
	;if GetKeyState("r", "P") = 1  	; auto pilot	
	if GetKeyState("r", "P") = 0  ; normal
	{
		break
	}

	PixelGetColor, ColorString, %DataBox_X%, %DataBox_Y%, RGB
	StringMid, Spell1, ColorString, 3,2
	
	; ====================== Special  Items ====================
	if (Spell1 = Delay20)
	{
		sleep, 20
		continue
	}
	if (Spell1 = Delay100)
	{
		sleep, 100
		continue
	}
	if (Spell1 = Delay300)
	{
		sleep, 300
		continue
	}	

	; ========== Ability 1 =============
	if (Spell1 = Ability_1_Color)
	{
		SendInput %Ability_1_Key%
		sleep, 60
		continue
	}

	; ========== Ability 2 =============
	if (Spell1 = Ability_2_Color)
	{
		SendInput %Ability_2_Key%
		sleep, 60
		continue
	}
	; ========== Ability 3 =============
	if (Spell1 = Ability_3_Color)
	{
		SendInput %Ability_3_Key%
		sleep, 60
		continue
	}
	; ========== Ability 4 =============
	if (Spell1 = Ability_4_Color)
	{
		SendInput %Ability_4_Key%
		sleep, 60
		continue
	}
	; ========== Ability 5 =============
	if (Spell1 = Ability_5_Color)
	{
		SendInput %Ability_5_Key%
		sleep, 60
		continue
	}
	; ========== Ability 6 =============
	if (Spell1 = Ability_6_Color)
	{
		SendInput %Ability_6_Key%
		sleep, 60
		continue
	}
	; ========== Ability 7 =============
	if (Spell1 = Ability_7_Color)
	{
		SendInput %Ability_7_Key%
		sleep, 60
		continue
	}
	; ========== Ability 8 =============
	if (Spell1 = Ability_8_Color)
	{
		SendInput %Ability_8_Key%
		sleep, 60
		continue
	}
	; ========== Ability 9 =============
	if (Spell1 = Ability_9_Color)
	{
		SendInput %Ability_9_Key%
		sleep, 60
		continue
	}
	; ========== Ability 10 =============
	if (Spell1 = Ability_10_Color)
	{
		SendInput %Ability_10_Key%
		sleep, 60
		continue
	}
	; ========== Ability 11 =============
	if (Spell1 = Ability_11_Color)
	{
		SendInput %Ability_11_Key%
		sleep, 60
		continue
	}
}
return


; ========================= Thread 2Attack Key =======================
$w::
;sleep 1000   ; autopilot
Loop
{
	; ================== Check for Loop Exit ===================
	;if GetKeyState("w", "P") = 1  	; auto pilot	
	if GetKeyState("w", "P") = 0  ; normal
	{
		break
	}

	PixelGetColor, ColorString, %DataBox_X%, %DataBox_Y%, RGB
	StringMid, Spell2, ColorString, 5,2
	
	; ====================== Special  Items ====================
	if (Spell2 = Delay20)
	{
		sleep, 20
		continue
	}
	if (Spell2 = Delay100)
	{
		sleep, 100
		continue
	}
	if (Spell2 = Delay300)
	{
		sleep, 300
		continue
	}	

	; ========== Ability 1 =============
	if (Spell2 = Ability_1_Color)
	{
		SendInput %Ability_1_Key%
		sleep, 60
		continue
	}

	; ========== Ability 2 =============
	if (Spell2 = Ability_2_Color)
	{
		SendInput %Ability_2_Key%
		sleep, 60
		continue
	}
	; ========== Ability 3 =============
	if (Spell2 = Ability_3_Color)
	{
		SendInput %Ability_3_Key%
		sleep, 60
		continue
	}
	; ========== Ability 4 =============
	if (Spell2 = Ability_4_Color)
	{
		SendInput %Ability_4_Key%
		sleep, 60
		continue
	}
	; ========== Ability 5 =============
	if (Spell2 = Ability_5_Color)
	{
		SendInput %Ability_5_Key%
		sleep, 60
		continue
	}
	; ========== Ability 6 =============
	if (Spell2 = Ability_6_Color)
	{
		SendInput %Ability_6_Key%
		sleep, 60
		continue
	}
	; ========== Ability 7 =============
	if (Spell2 = Ability_7_Color)
	{
		SendInput %Ability_7_Key%
		sleep, 60
		continue
	}
	; ========== Ability 8 =============
	if (Spell2 = Ability_8_Color)
	{
		SendInput %Ability_8_Key%
		sleep, 60
		continue
	}
	; ========== Ability 9 =============
	if (Spell2 = Ability_9_Color)
	{
		SendInput %Ability_9_Key%
		sleep, 60
		continue
	}
	; ========== Ability 10 =============
	if (Spell2 = Ability_10_Color)
	{
		SendInput %Ability_10_Key%
		sleep, 60
		continue
	}
	; ========== Ability 11 =============
	if (Spell2 = Ability_11_Color)
	{
		SendInput %Ability_11_Key%
		sleep, 60
		continue
	}
}
return


; ========================= Thread 2Attack Key =======================
$k::
;sleep 1000   ; autopilot
Loop
{
	; ================== Check for Loop Exit ===================
	;if GetKeyState("k", "P") = 1  	; auto pilot	
	if GetKeyState("k", "P") = 0  ; normal
	{
		break
	}

	PixelGetColor, ColorString, %DataBox_X%, %DataBox_Y%, RGB
	StringMid, Spell3, ColorString, 7,2
	
	; ====================== Special  Items ====================
	if (Spell3 = Delay20)
	{
		sleep, 20
		continue
	}
	if (Spell3 = Delay100)
	{
		sleep, 100
		continue
	}
	if (Spell3 = Delay300)
	{
		sleep, 300
		continue
	}	

	; ========== Ability 1 =============
	if (Spell3 = Ability_1_Color)
	{
		SendInput %Ability_1_Key%
		sleep, 60
		continue
	}

	; ========== Ability 2 =============
	if (Spell3 = Ability_2_Color)
	{
		SendInput %Ability_2_Key%
		sleep, 60
		continue
	}
	; ========== Ability 3 =============
	if (Spell3 = Ability_3_Color)
	{
		SendInput %Ability_3_Key%
		sleep, 60
		continue
	}
	; ========== Ability 4 =============
	if (Spell3 = Ability_4_Color)
	{
		SendInput %Ability_4_Key%
		sleep, 60
		continue
	}
	; ========== Ability 5 =============
	if (Spell3 = Ability_5_Color)
	{
		SendInput %Ability_5_Key%
		sleep, 60
		continue
	}
	; ========== Ability 6 =============
	if (Spell3 = Ability_6_Color)
	{
		SendInput %Ability_6_Key%
		sleep, 60
		continue
	}
	; ========== Ability 7 =============
	if (Spell3 = Ability_7_Color)
	{
		SendInput %Ability_7_Key%
		sleep, 60
		continue
	}
	; ========== Ability 8 =============
	if (Spell3 = Ability_8_Color)
	{
		SendInput %Ability_8_Key%
		sleep, 60
		continue
	}
	; ========== Ability 9 =============
	if (Spell3 = Ability_9_Color)
	{
		SendInput %Ability_9_Key%
		sleep, 60
		continue
	}
	; ========== Ability 10 =============
	if (Spell3 = Ability_10_Color)
	{
		SendInput %Ability_10_Key%
		sleep, 60
		continue
	}
	; ========== Ability 11 =============
	if (Spell3 = Ability_11_Color)
	{
		SendInput %Ability_11_Key%
		sleep, 60
		continue
	}
}
return