#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode Pixel
#Warn All, Off	;not cause i fucked something, but if 0(%msgs%) >= 1 --> ERROR

	;Read Variables
	IniRead, Activation, Var.ini,Var,Activation
	IniRead, msgs, Var.ini,Var,msgs
	IniRead, user, Var.ini,Var,user

	IniRead, dispose, Var.ini,Var,dispose
	IniRead, blackout, Var.ini,Var,blackout
	IniRead, shutdown, Var.ini,Var,shutdown
	IniRead, realwait, Var.ini,Var,realwait

	loop, %msgs%
		{
		IniRead, m%A_Index%, Var.ini,Var,m%A_Index%
		}
	
;==========================================================================

Main:
Gui, New,,,
gui, font, s12, Verdana  ; Set 10-point Verdana
Gui +border -minimizebox -maximizebox

Gui, Add, Text,,Activation:
Gui, Add, Text,,msgs:
Gui, Add, Text,,user:

Gui, Add, Edit, vActivation w60 ym, %Activation%
Gui, Add, Edit, vmsgs w40, %msgs%
Gui, Add, Edit, vuser w120, %user%

Gui, Add, Checkbox, vdispose Checked%dispose%, Dispose
Gui, Add, Checkbox, vblackout Checked%blackout%, blackout
Gui, Add, Checkbox, vshutdown Checked%shutdown%, shutdown
Gui, Add, Checkbox, vrealwait Checked%realwait%, realwait

Gui, Add, Button, default w100, &Messages
Gui, Add, Button, +default w100, &OK 
Gui, Show,w300, WA Bot Settings
return

;==========================================================================

ButtonMessages:
Gui, Submit
Gui, New,,,
gui, font, s12, Verdana
Gui +border -minimizebox -maximizebox	

loop, %msgs%
	{
	Gui, Add, Text,,m%A_Index%:
	}

loop, %msgs%
	{
		IfEqual, A_Index, 1
		{
			Gui, Add, Edit, vm%A_Index% ym w500, % m%A_Index%
			continue
		}
	Gui, Add, Edit, vm%A_Index% w500, % m%A_Index%
	}
	
Gui, Add, Text,,Displaying %msgs% messages
Gui, Add, Button, default w100, &Done

Gui, Show, w600, WA Bot Messages
return

;==========================================================================
	
ButtonDone:
Gui, Submit
Goto, Main
return

;==========================================================================

ButtonOK:
Gui, Submit
;Saves Variables & Quit

IniWrite, %Activation%, Var.ini,Var, Activation
IniWrite, %msgs%, Var.ini,Var, msgs
IniWrite, %user%, Var.ini,Var, user

IniWrite, %dispose%, Var.ini,Var, dispose
IniWrite, %shutdown%, Var.ini,Var, shutdown
IniWrite, %blackout%, Var.ini,Var, blackout
IniWrite, %realwait%, Var.ini,Var, realwait

loop, %msgs%
{
		IniWrite, % m%A_Index%, Var.ini,Var, m%A_Index%
}
GuiClose:
ExitApp