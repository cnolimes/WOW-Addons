#SingleInstance, Force


OsdColor = EEAA99  
OsdText  = Enabled
OsdFontSize = 14
Osd_FontStyle = Verdana
Osd_FontName = 

;############################### 
;   OSD1
;###############################
Gui, -Caption +Border +AlwaysOnTop +ToolWindow
Gui, Color, %OsdColor%
Gui, Font, s%OsdFontSize% %Osd_FontStyle%, %Osd_FontName%;
Gui, +LastFound
WinSet, TransColor, %OsdColor% 250
Gui, Add, Text, vOsdtext cLime, MMMMMMMMMMMMMMMMM
Gui, Show, x450 y3 , WOWState       						; Adjust X & Y to suit your screen res

; -------------------- Initializing OSD -----------------------------------
GuiControl,, OsdText, %Osdtext%




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
NoCombat1Key	= v
NoCombat2Key	= w

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
NoCombat 		= 0D		;	= 0.05


; --------------- Color Box Location --------------
DataBox_X = 1891
DataBox_Y = 365


; ============================= On/Off Code ===============================
; Macros Enabled Vars
#EscapeChar \
Macro_Enabled = 1
AutoThread = 0
SetScrollLockState On

$f8::
if AutoThread = 1
{
	OsDText = Manual Mode
	GuiControl,, OsdText, %Osdtext%								; Update OSD
	AutoThread = 0
} else {
	OsDText = Auto Mode
	GuiControl,, OsdText, %Osdtext%								; Update OSD
	AutoThread = 1
}
return

$f9:: 
Suspend, Toggle
if Macro_Enabled = 1
{
	OsDText = Paused											; Set OSD
	GuiControl,, OsdText, %Osdtext%								; Update OSD
	SetScrollLockState Off
	Macro_Enabled = 0
	AutoThread = 0
}
else
{
	OsDText = Enabled											; Set OSD
	GuiControl,, OsdText, %Osdtext%								; Update OSD
	SetScrollLockState On
	Macro_Enabled = 1
}
return

; ============================= Emergency Color Box Remap ===============================
$f12::  
	MouseGetPos, DataBox_X, DataBox_Y
	OsDText = %DataBox_X%, %DataBox_Y%							; Set OSD
	GuiControl,, OsdText, %Osdtext%								; Update OSD
return

; ============================= Emergency Get Mouse Pos/Color============================
$f11::  
	MouseGetPos, MouseX, MouseY
	PixelGetColor, ColorString, %MouseX%, %MouseY%, RGB
	MsgBox %MouseX%, %MouseY%,  color %ColorString%
	OsdText = %MouseX%, %MouseY%,  color %ColorString%			; Set OSD
	GuiControl,, OsdText, %Osdtext%								; Update OSD
return


; ========================= Thread 1 Attack Key ======================
$v::
Loop
{
	if(AutoThread == 0){
		if GetKeyState("v", "P") = 0  { ; normal
			break
		}
	}

	PixelGetColor, ColorString, %DataBox_X%, %DataBox_Y%, RGB
	StringMid, Spell1, ColorString, 3,2
	
	; ====================== Special  Items ====================
	if (Spell1 = Delay20)
	{
		sleep, 20
		OsDText = S:Sleep20
		continue
	}
	if (Spell1 = Delay100)
	{
		sleep, 100
		OsDText = S:Sleep100
		continue
	}
	if (Spell1 = Delay300)
	{
		sleep, 300
		OsDText = S:Sleep300
		continue
	}
	if (Spell1 = NoCombat)
	{
		SendInput %NoCombat1Key%
		sleep, 150
		continue
	}

	; ========== Ability 1 =============
	if (Spell1 = Ability_1_Color)
	{
		SendInput %Ability_1_Key%
		OsDText = S:Ability 1
		sleep, 60
		continue
	}

	; ========== Ability 2 =============
	if (Spell1 = Ability_2_Color)
	{
		SendInput %Ability_2_Key%
		OsDText = S:Ability 2
		sleep, 60
		continue
	}
	; ========== Ability 3 =============
	if (Spell1 = Ability_3_Color)
	{
		SendInput %Ability_3_Key%
		OsDText = S:Ability 3
		sleep, 60
		continue
	}
	; ========== Ability 4 =============
	if (Spell1 = Ability_4_Color)
	{
		SendInput %Ability_4_Key%
		OsDText = S:Ability 4
		sleep, 60
		continue
	}
	; ========== Ability 5 =============
	if (Spell1 = Ability_5_Color)
	{
		SendInput %Ability_5_Key%
		OsDText = S:Ability 5
		sleep, 60
		continue
	}
	; ========== Ability 6 =============
	if (Spell1 = Ability_6_Color)
	{
		SendInput %Ability_6_Key%
		OsDText = S:Ability 6
		sleep, 60
		continue
	}
	; ========== Ability 7 =============
	if (Spell1 = Ability_7_Color)
	{
		SendInput %Ability_7_Key%
		OsDText = S:Ability 7
		sleep, 60
		continue
	}
	; ========== Ability 8 =============
	if (Spell1 = Ability_8_Color)
	{
		SendInput %Ability_8_Key%
		OsDText = S:Ability 8
		sleep, 60
		continue
	}
	; ========== Ability 9 =============
	if (Spell1 = Ability_9_Color)
	{
		SendInput %Ability_9_Key%
		OsDText = S:Ability 9
		sleep, 60
		continue
	}
	; ========== Ability 10 =============
	if (Spell1 = Ability_10_Color)
	{
		SendInput %Ability_10_Key%
		OsDText = S:Ability 10
		sleep, 60
		continue
	}
	; ========== Ability 11 =============
	if (Spell1 = Ability_11_Color)
	{
		SendInput %Ability_11_Key%
		OsDText = S:Ability 11
		sleep, 60
		continue
	}
	GuiControl,, OsdText, %Osdtext%								; Update OSD
}
return


; ========================= Thread 2Attack Key =======================
$w::
Loop
{
	if(AutoThread == 0){
		if GetKeyState("w", "P") = 0  { ; normal
			break
		}
	}

	PixelGetColor, ColorString, %DataBox_X%, %DataBox_Y%, RGB
	StringMid, Spell2, ColorString, 5,2
	
	; ====================== Special  Items ====================
	if (Spell2 = Delay20)
	{
		sleep, 20
		OsDText = M:Sleep20
		continue
	}
	if (Spell2 = Delay100)
	{
		sleep, 100
		OsDText = M:Sleep100
		continue
	}
	if (Spell2 = Delay300)
	{
		sleep, 300
		OsDText = M:Sleep300
		continue
	}
	if (Spell2 = NoCombat)
	{
		SendInput %NoCombat2Key%
		sleep, 150
		continue
	}	

	; ========== Ability 1 =============
	if (Spell2 = Ability_1_Color)
	{
		SendInput %Ability_1_Key%
		OsDText = M:Ability 1
		sleep, 60
		continue
	}

	; ========== Ability 2 =============
	if (Spell2 = Ability_2_Color)
	{
		SendInput %Ability_2_Key%
		OsDText = M:Ability 2
		sleep, 60
		continue
	}
	; ========== Ability 3 =============
	if (Spell2 = Ability_3_Color)
	{
		SendInput %Ability_3_Key%
		OsDText = M:Ability 3
		sleep, 60
		continue
	}
	; ========== Ability 4 =============
	if (Spell2 = Ability_4_Color)
	{
		SendInput %Ability_4_Key%
		OsDText = M:Ability 4
		sleep, 60
		continue
	}
	; ========== Ability 5 =============
	if (Spell2 = Ability_5_Color)
	{
		SendInput %Ability_5_Key%
		OsDText = M:Ability 5
		sleep, 60
		continue
	}
	; ========== Ability 6 =============
	if (Spell2 = Ability_6_Color)
	{
		SendInput %Ability_6_Key%
		OsDText = M:Ability 6
		sleep, 60
		continue
	}
	; ========== Ability 7 =============
	if (Spell2 = Ability_7_Color)
	{
		SendInput %Ability_7_Key%
		OsDText = M:Ability 7
		sleep, 60
		continue
	}
	; ========== Ability 8 =============
	if (Spell2 = Ability_8_Color)
	{
		SendInput %Ability_8_Key%
		OsDText = M:Ability 8
		sleep, 60
		continue
	}
	; ========== Ability 9 =============
	if (Spell2 = Ability_9_Color)
	{
		SendInput %Ability_9_Key%
		OsDText = M:Ability 9
		sleep, 60
		continue
	}
	; ========== Ability 10 =============
	if (Spell2 = Ability_10_Color)
	{
		SendInput %Ability_10_Key%
		OsDText = M:Ability 10
		sleep, 60
		continue
	}
	; ========== Ability 11 =============
	if (Spell2 = Ability_11_Color)
	{
		SendInput %Ability_11_Key%
		OsDText = M:Ability 11
		sleep, 60
		continue
	}
	GuiControl,, OsdText, %Osdtext%								; Update OSD
}
return