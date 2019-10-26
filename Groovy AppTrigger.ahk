#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, 3

;***********************************************************************

optionsFile:="options.ini"
IniRead, triggerApp, %optionsFile%, TriggerApp, triggerApp, 0
LOOP, 10 {
	IniRead, app%A_Index%, %optionsFile%, AppsToRun, app%A_Index%
}

;***********************************************************************

isRunning := 0	

SetTimer, MainTimer, 500
MainTimer:
	if (isRunning=1) {
		Process, Exist, %triggerApp%
		If (ErrorLevel = 0) {				
			handleApps("close")
			isRunning := 0	
		}	
	} else {	
		Process, Exist, %triggerApp%
		If (ErrorLevel != 0) {
			isRunning := 1
			handleApps("run")
		} 
	}
return

handleApps(action){
	Loop, 50 {
		path = % app%A_Index%
		if (path = "ERROR")
			break

		if(action="run")
		{
			Run, %path%
		} else {
			SplitPath, path, filename
			Process, Close, %filename%
		}
	}
}
