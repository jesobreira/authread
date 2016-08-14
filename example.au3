#include 'authread.au3'

_AuThread_Startup()

$hThread = _AuThread_StartThread("sendalert")

Func sendalert()
	While 1
		$msg = _AuThread_GetMessage()
		If $msg Then
			MsgBox(0, "Alert from thread", $msg)
		EndIf

		; randomly sends (or not) messages to the main thread
		$rand = Random(1, 10, 1)
		If $rand = 2 Then
			_AuThread_SendMessage(_AuThread_MainThread(), "Hey!")
		EndIf
	WEnd
EndFunc

; main thread
While True
	; randomly sends (or not) messages to the main thread
	$rand = Random(1, 3, 1)
	TrayTip("Main thread window", "Sorted number: " & $rand, 1)
	If $rand = 2 Then
		_AuThread_SendMessage($hThread, $rand & " was sorted")
	EndIf

	; get some message sent to the main PID
	$msg = _AuThread_GetMessage()
	If $msg Then
		MsgBox(0, "Wayback message", "The thread sent: " & $msg)
	EndIf
	Sleep(1000)
WEnd

; The line below is just an example,
; as once the main thread is closed or killed, the UDF will automatically close all the started threads
_AuThread_CloseThread($hThread)