#Include <Misc.au3>

; Zmienna do kontrolowania pętli klikania
Global $bClicking = False

; Ustawienie hotkeys
HotKeySet("{F5}", "StartClicking")
HotKeySet("{F6}", "StopClicking")
HotKeySet("{F9}", "ExitProgram")

; Główna pętla
While 1
    If $bClicking Then
        MouseClick("left")
        Sleep(1) ; Minimalne opóźnienie dla maksymalnej prędkości
    EndIf
    ;Sleep(10) ; Zmniejsza zużycie CPU
WEnd

; Funkcje hotkeys
Func StartClicking()
    $bClicking = True
EndFunc

Func StopClicking()
    $bClicking = False
EndFunc

Func ExitProgram()
    Exit
EndFunc
