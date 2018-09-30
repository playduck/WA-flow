#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#singleinstance force

#Include include/chrome.ahk

global messages := []
global Activation = 9999				; Activation time 0000 - 2359
global wa_receiver_name := "robin"		; Recipiant name 
global dispose = false		; closes chrome & connection
global blackout = false		; monitr blackout during idle
global shutdown = false		; shutdown on completion
global realwait = false		; simulates real waiting time

RunWait, GUI.ahk

IniRead, Activation, Var.ini,Var,Activation
IniRead, msgs, Var.ini,Var,msgs
IniRead, wa_receiver_name, Var.ini,Var,user

IniRead, dispose, Var.ini,Var,dispose
IniRead, blackout, Var.ini,Var,blackout
IniRead, shutdown, Var.ini,Var,shutdown
IniRead, realwait, Var.ini,Var,realwait

loop, %msgs%
{
	IniRead, tmp, Var.ini,Var,m%A_Index%
	messages.Push(tmp)
}

;=======================================================	CHECK TIME

if(blackout)	{
	Gui, Color, black
	Gui, +ToolWindow -Caption +AlwaysOnTop
	Gui, Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%
	sleep, 50
	MouseMove, %A_ScreenWidth%, %A_ScreenHeight%, 0
}

SetTimer, Chronos, 500
Return
Chronos:
FormatTime, TimeToMeet,,HHmm

;msgbox, %TimeToMeet% %Activation%

if(TimeToMeet = Activationa or Activation = 9999)
{
	SplashTextOn,,, Go!
	sleep, 500
	SplashTextOff


Gui, Hide
	
FileCreateDir, ChromeProfile
ChromeInst := new Chrome("ChromeProfile")

global WA := ChromeInst.GetPage()
WA.Call("Page.navigate", {"url": "https://web.whatsapp.com"})
WA.WaitForLoad()

sleep 50
MouseMove, 0, 0
WinActivate
WinMaximize
send #{UP}

while true {
	sleep 100
	PixelGetColor, px, A_ScreenWidth // 2, A_ScreenHeight // 2
	sleep 100
	If (px == 0xFAF9F7) {
		Break
	}
	sleep 100
}

; ~~~ INITILIZED ~~~ 

WA.Evaluate("function search(name) { let a = document.getElementsByClassName(""_1wjpf""); for(let i = 0; i < a.length; i++) { if(a[i].classList.length === 1) { if(a[i].innerText == name) { let clickEvent = document.createEvent(""MouseEvents""); clickEvent.initEvent(""mousedown"", true, true); a[i].dispatchEvent(clickEvent); }}}}")
WA.Evaluate("setTimeout(() => { search(""" . wa_receiver_name . """) }, 500);")
sleep, 1000

; ~~~ OPEND CONTACT ~~~ 

CoordMode Pixel
MouseMove, A_ScreenWidth // 2, A_ScreenHeight - 80 ; Adjust offset depending on screen
Click,
sleep, 200

; ~~~ SENDING MESSAGES ~~~ 

for index, element in messages
{
   ; MsgBox % "Element number " . index . " is " . element
   WA_SendMessage(element)
}
if(blackout)
	Gui, Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%
if(shutdown)	{
	Shutdown, 12 ; force + powerdown
}
Goto, EOF

WA_SendMessage(text)	{
	if ( FileExist(text) )	{
		WA.Evaluate("let clickEvent = document.createEvent(""MouseEvents""); clickEvent.initEvent(""mousedown"", true, true); document.getElementsByClassName(""rAUz7"")[4].children[0].dispatchEvent(clickEvent);")
		sleep, 500
		WA.Evaluate("document.getElementsByClassName(""GK4Lv"")[0].click();")
		sleep, 500
		Send, %text%
		sleep, 200
		Send, {Enter}
		sleep, 2000
		Send, {Enter}
	}	else	{
		Send, %text%
		if(realwait)	{
			d := StrLen(text) * 120 + 800
			sleep, %d%
		}
		Send, {Enter}
	}
	sleep, 500
}


^x::
EOF:
{
	if dispose {
		WA.Call("Browser.close")
		WA.Disconnect()
	}
	FileRemoveDir, ChromeProfile, 1
	SplashTextOn,,, Exiting Process
	sleep 500
	Exitapp
}

}