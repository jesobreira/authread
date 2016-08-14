#include 'authread.au3'

_AuThread_Startup()

Func myThreadFunction()
	While True
		; In this example, we will get a message sent by the main thread (if any)
		$sMsg = _AuThread_GetMessage()
		If $sMsg Then
			; Message was sent, let's display it
			MsgBox(0, "Message from the main thread to the sub thread", $sMsg)
		EndIf

		MsgBox(0, "Thread example", "Hey, I am a thread!")
		Sleep(1000)
	WEnd
EndFunc

$hThread = _AuThread_StartThread("myThreadFunction")

While True
	MsgBox(0, "", "Hey, I am the main thread!")
	_AuThread_SendMessage($hThread, "Hello, sub thread! How are you?")
	Sleep(1000)
WEnd