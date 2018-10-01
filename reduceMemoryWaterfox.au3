#include <WinAPIProc.au3>

Func _GetProcessUsage($sProcess, $iFlag = 0)
	Local $iProcessUsage = 0
	Local $aProcessStats = ProcessGetStats($sProcess, 0)
	If Not @error Then
		If IsArray($aProcessStats) Then
			$iProcessUsage = Round($aProcessStats[$iFlag] / 1024 / 1024, 2)
		Else
			Return SetError(2, 0, 0)
			EndIf
	Else
		Return SetError(1, 0, 0)
	EndIf
	Return $iProcessUsage
EndFunc

Func _ClearProcessesWorkingSet()
   Local $aProcessList = ProcessList("waterfox.exe")
   If Not @error Then
	  If Round(_GetProcessUsage($aProcessList[1][1], 0)) > 400 Then   ; MAINPROCESS   400 MegaByte   choose your value
		 _WinAPI_EmptyWorkingSet($aProcessList[1][1])
	  EndIf
	  For $i = 2 To $aProcessList[0][0]
		 If Round(_GetProcessUsage($aProcessList[$i][1], 0)) > 400 Then   ; REMOTEPROCESSES   400 MegaByte   choose your value
			_WinAPI_EmptyWorkingSet($aProcessList[$i][1])
		 EndIf
	  Next
   EndIf
EndFunc

While 1
        Sleep(10000)  ; every 10 seconds  , choose your value
        _ClearProcessesWorkingSet()
WEnd