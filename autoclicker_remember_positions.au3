#Include <Misc.au3>
#Include <File.au3>

; Zmienna do kontrolowania pętli klikania
Global $bClicking = False
; Tablica do przechowywania zapisanych pozycji
Global $aPositions[0][2]
; Ścieżka do pliku z pozycjami
Global $sFilePath = @ScriptDir & "\click_positions.txt"

; Ustawienie hotkeys
HotKeySet("{F4}", "SavePosition")
HotKeySet("{F5}", "StartClicking")
HotKeySet("{F6}", "StopClicking")
HotKeySet("{F9}", "ExitProgram")

; Główna pętla
While 1
    If $bClicking Then
        ; Sprawdzenie, czy istnieją zapisane pozycje
        If UBound($aPositions) > 0 Then
            ; Klikanie w zapisanych pozycjach
            For $i = 0 To UBound($aPositions) - 1
                If Not $bClicking Then ExitLoop ; Przerwanie jeśli F6 wciśnięte
                ; MouseClick("left", $aPositions[$i][0], $aPositions[$i][1])
				MouseClick("left", $aPositions[$i][0], $aPositions[$i][1], 1, 0) ; 0 = brak animacji
                Sleep(1)
            Next
        Else
            ; Standardowe klikanie w aktualnej pozycji kursora
            MouseClick("left")
            Sleep(1)
        EndIf
    EndIf
    Sleep(10) ; Zmniejsza zużycie CPU
WEnd

; Funkcja zapisująca pozycję kursora
Func SavePosition()
    Local $aPos = MouseGetPos()
    If IsArray($aPos) Then
        ; Dopisanie pozycji do pliku
        Local $hFile = FileOpen($sFilePath, 1) ; 1 = tryb dopisywania
        If $hFile = -1 Then
            MsgBox(16, "Błąd", "Nie można otworzyć pliku do zapisu: " & $sFilePath)
            Return
        EndIf
        FileWriteLine($hFile, $aPos[0] & "," & $aPos[1])
        FileClose($hFile)
        ; Odświeżenie tablicy pozycji
        LoadPositions()
        ; MsgBox(64, "Sukces", "Pozycja zapisana: " & $aPos[0] & "," & $aPos[1])
    Else
        MsgBox(16, "Błąd", "Nie udało się pobrać pozycji kursora!")
    EndIf
EndFunc

; Funkcja wczytująca pozycje z pliku
Func LoadPositions()
    If FileExists($sFilePath) Then
        Local $aFileLines
        _FileReadToArray($sFilePath, $aFileLines) ; Czytanie bez rozdzielania na przecinki
        If Not @error And IsArray($aFileLines) Then
            ; Przygotowanie tablicy na pozycje
            ReDim $aPositions[$aFileLines[0]][2] ; Poprawione na $aFileLines[0] zamiast UBound
            For $i = 1 To $aFileLines[0] ; Pętla od 1, bo 0 to liczba linii
                Local $aSplit = StringSplit($aFileLines[$i], ",", 2) ; Rozdzielanie na przecinki
                If UBound($aSplit) = 2 Then
                    $aPositions[$i-1][0] = Number($aSplit[0])
                    $aPositions[$i-1][1] = Number($aSplit[1])
                EndIf
            Next
        Else
            ; Jeśli plik jest pusty lub niepoprawny, czyścimy tablicę
            ReDim $aPositions[0][2]
        EndIf
    Else
        ; Jeśli plik nie istnieje, czyścimy tablicę
        ReDim $aPositions[0][2]
    EndIf
EndFunc

; Funkcje hotkeys
Func StartClicking()
    ; Wczytanie pozycji przed rozpoczęciem klikania
    LoadPositions()
    $bClicking = True
EndFunc

Func StopClicking()
    $bClicking = False
EndFunc

Func ExitProgram()
    Exit
EndFunc
