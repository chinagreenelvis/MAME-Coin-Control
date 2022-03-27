; MAME Coin Control
; by chinagreenelvis
; Version 1.02

; This script assumes that you leave the bindings for "start" and "coin" to thier MAME defaults; Joy8 (Start on an XBox 360 controller) will initially begin the coin control for each player that presses it and will then subsequently act as a normal start button. Holding the start button on P1 will toggle activation of the script. Joy10 (the Right Thumbstick) will act as the service button (coins) when the script is deactivated.

; CoinTime is set in increments of minutes in the INI file.

; As with MAME, all controllers must be connected and turned on before starting the script.

; Make sure MAME is run with: -keyboardprovider dinput

; Carl from Aqua Teen Hunger Force sound bytes created using the website 15.ai
 
#NoEnv
#SingleInstance force
#Persistent
SetWorkingDir %A_ScriptDir%
SetKeyDelay 50

IfNotExist, MAMECC.ini
{
	IniWrite, 0, MAMECC.ini, Settings, HideIcon
	IniWrite, 1, MAMECC.ini, Coins, Enabled
	IniWrite, 5, MAMECC.ini, Coins, CoinTime
	IniWrite, 4, MAMECC.ini, Coins, StartingCoins
	IniWrite, 2, MAMECC.ini, Coins, IncrementalCoins
}

Global Enabled
Global CoinTime
Global StartingCoins
Global Joy1Pressed
Global Joy2Pressed
Global Joy3Pressed
Global Joy4Pressed

IniRead, HideIcon, MAMECC.ini, Settings, HideIcon
IniRead, Enabled, MAMECC.ini, Coins, Enabled
IniRead, CoinTime, MAMECC.ini, Coins, CoinTime
IniRead, StartingCoins, MAMECC.ini, Coins, StartingCoins
IniRead, IncrementalCoins, MAMECC.ini, Coins, IncrementalCoins

Cointime := Cointime * 60000

If (HideIcon)
{
	Menu, Tray, NoIcon
}
Else
{
	Menu, Tray, Icon
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; START

WMI := ComObjGet("winmgmts:")
ComObjConnect(deleteSink := ComObjCreate("WbemScripting.SWbemSink"), EventSinkDelete)
WMI.ExecNotificationQueryAsync(deleteSink, "select * from __InstanceDeletionEvent Within 1 Where TargetInstance ISA 'Win32_Process'")

Process, Wait, mame.exe, 10
If (!ErrorLevel)
{
	ExitApp
}

If GetKeyState("1JoyName")
{
 Hotkey, 1Joy8, 1J8
 Hotkey, 1Joy10, 1J10
}
If GetKeyState("2JoyName")
{
 Hotkey, 2Joy8, 2J8
 Hotkey, 2Joy10, 2J10
}
If GetKeyState("3JoyName")
{
 Hotkey, 3Joy8, 3J8
 Hotkey, 3Joy10, 3J10
}
If GetKeyState("4JoyName")
{
 Hotkey, 4Joy8, 4J8
 Hotkey, 4Joy10, 4J10
}

Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FUNCTIONS

class EventSinkDelete
{
	OnObjectReady(obj)
	{
		Process, Wait, mame.exe, 5
		If (!ErrorLevel)
		{
			ExitApp
		}
	}
}

JoyPress(Num := 0, Num2 := 0)
{
	IfWinActive, ahk_class MAME
	{
		If (Enabled)
		{
			If (!Joy%Num%Pressed)
			{
				KeyWait %Num%Joy8
				Joy%Num%Pressed:= 1
				Loop, %StartingCoins%
				{
					Send {%Num2% Down}{%Num2% Up}
					Sleep, 50
				}
				SetTimer, Timer%Num%, %CoinTime%
				Return
			}
			Else
			{
				Return
			}
		}
	}
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TIMERS

Timer1:
	WinWaitActive, ahk_class MAME
	{
		Loop, %IncrementalCoins%
		{
			Send {5 down}{5 up}
			Sleep, 50
		}
	}
Return

Timer2:
	WinWaitActive, ahk_class MAME
	{
		Loop, %IncrementalCoins%
		{
			Send {6 down}{6 up}
			Sleep, 50
		}
	}
Return

Timer3:
	WinWaitActive, ahk_class MAME
	{
		Loop, %IncrementalCoins%
		{
			Send {7 down}{7 up}
			Sleep, 50
		}
	}
Return

Timer4:
	WinWaitActive, ahk_class MAME
	{
		Loop, %IncrementalCoins%
		{
			Send {8 down}{8 up}
			Sleep, 50
		}
	}
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; HOTKEYS

#IfWinActive, ahk_class MAME

;; F1 toggles activation

F1::

	If (Enabled)
	{
		Enabled := 0
		IniWrite, 0, MAMECC.ini, Coins, Enabled
		SetTimer, Timer1, Delete
		SetTimer, Timer2, Delete
		SetTimer, Timer3, Delete
		SetTimer, Timer4, Delete
		;SoundBeep, 500, 75
		;Sleep, 75
		;SoundBeep, 300, 75
		SoundPlay, Deactivated.mp3
	}
	Else
	{
		Enabled := 1
		IniWrite, 1, MAMECC.ini, Coins, Enabled
		Joy1Pressed := 0
		Joy2Pressed := 0
		Joy3Pressed := 0
		Joy4Pressed := 0
		;SoundBeep, 300, 75
		;Sleep, 75
		;SoundBeep, 500, 75
		SoundPlay, Activated.mp3
	}

Return

;; Holding Joy1 Start toggles activation, Start buttons begin coin cycles when activated

1J8:

	TimePressed := A_TickCount
	While (GetKeyState("1Joy8")) ;; Holding P1 Start toggles activation
	{
		If (A_TickCount - TimePressed > 2000)
		{
			GoSub F1
			Send {1Joy8 Up}
			GoTo SkipJoy1
		}
	}
	If (Enabled && !Joy1Pressed)
	{
		JoyPress(1, 5)
		Send {1Joy8 Up}
	}
	Else
	{
		Send {1 Down}{1 Up}
	}
	SkipJoy1:
	
Return

2J8:

	If (Enabled && !Joy2Pressed)
	{
		JoyPress(2, 6)
		Send {2Joy8 Up}
	}
	Else
	{
		Send {2 Down}{2 Up}
	}
	
Return

3J8:

	If (Enabled && !Joy3Pressed)
	{
		JoyPress(3, 7)
		Send {3Joy8 Up}
	}
	Else
	{
		Send {3 Down}{3 Up}
	}
	
Return

4J8:

	If (Enabled && !Joy4Pressed)
	{
		JoyPress(4, 8)
		Send {4Joy8 Up}
	}
	Else
	{
		Send {4 Down}{4 Up}
	}
	
Return

;; Right Thumbstick enters coins when deactivated

1J10:

	If (!Enabled)
	{
		Send {5 down}{5 up}
	}
	
Return

2J10:

	If (!Enabled)
	{
		Send {6 down}{6 up}
	}
	
Return

3J10:

	If (!Enabled)
	{
		Send {7 down}{7 up}
	}
	
Return

4J10:

	If (!Enabled)
	{
		Send {8 down}{8 up}
	}
	
Return

#IfWinActive