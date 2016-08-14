AuThread
========

This UDF provides multithread emulation for AutoIt3.

AutoIt supports only one thread per script. This UDF emulates multiple threads by opening multiple processes and sending messages through temporary files.

It offers an easy way to emulate threads and exchange messages between the threads.

AuThread is maintained by [Jefrey](http://).

How to use
==========

Start by including the lib onto your script.

```
#include 'authread.au3'
```

Now call `_AuThread_Startup()`. This function is responsible for calling the callback functions if the currently running process is a "thread", or saving important data to temporary files if it's the main thread.

```
_AuThread_Startup()
```

Now create your thread function. You can choose any name for it or even create multiple functions (for multiple threads). Note that if you want your thread to last an undetermined time, you must include an infinite loop inside the function.

```
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
```

Now start the thread by calling:

```
$hThread = _AuThread_StartThread("myThreadFunction")
```

This function returns the PID of the process-thread. You'll use it for sending messages to threads.

You can continue writing your script on the same file:

```
While True
	MsgBox(0, "", "Hey, I am the main thread!")
	_AuThread_SendMessage($hThread, "Hello, sub thread! How are you?")
	Sleep(1000)
WEnd
```

By default, Windows API (and therefore AutoIt) allows only 1 MessageBox per thread. However, by running the script we've just written, you'll see that we're capable of running two message boxes at once on the same script.

Also, when you close the main script, all the threads are also closed.

You cannot start a thread directly without opening the main thread.

Docs
====

void _AuThread_Startup()
-------------------
Verifies if the currently running script is a thread being called by a mainthread or if it's the main thread itself. If it's being called by a main thread, it calls the specified callback function. Else, it will just save required data for the UDF.

int _AuThread_MainThread()
--------------------------
This function can be called in both threads and mainthreads. It will always return the PID of the main thread.

int _AuThread_StartThread(string $sCallback [, string $sMsg ] )
---------------------------------------------------------------
Starts a thread and returns the new thread PID. $sCallback must be a callable function name. If $sMsg is specified, `_AuThread_SendMessage($sMsg)` will be automatically called.

string _AuThread_GetMessage( [ $iPID = @AutoItPID ] )
-----------------------------------------------------
Gets the last message sent to the current thread (or main thread, if called on it), returns and deletes it. If no message is found, False is returned.

void _AuThread_SendMessage($iPid, $sMessage)
--------------------------------------------
Sends a message to a thread (main or sub). This message can be retrieved through `_AuThread_GetMessage()`.

void _AuThread_CloseThread( [ $iPID = @AutoItPID ] )
----------------------------------------------------
Closes a thread or the current thread (if no thread PID is specified).


Additional notes
================
The thread is the own current script called with the following parameters:

* `script.exe --au-thread "$sCallback"` (if compiled)
* `@AutoItExe C:\path\to\script.au3 --au-thread "$sCallback"` (if not compiled)

In order to avoid errors, do not use the `--au-thread` argument (why would you do?). Also, note that no parameters will be sent when calling the threads. Use the UDF messages for that.

Also, remember that the script will automatically close after calling your callback function. If you don't want so, put a loop (For, While or Do) in your function, like showing above.

The global constant `$__AuThread_sTmpFile` stores the filename where the thread messages and other informations will be kept. It's based on the file name. You probably won't have to worry about this file.