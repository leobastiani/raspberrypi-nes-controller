#include <Array.au3>

Global $MainSocket = -1
Global $ConnectedSocket = -1
Local $MaxConnection = 1; Maximum Amount Of Concurrent Connections
Local $MaxLength = 50; Maximum Length Of String
Local $Port = 5001; Port Number
Local $Server = '0.0.0.0'; Server IpAddress
Global $Buttons = ['B', 'Y', 'SELECT', 'START', 'UP', 'DOWN', 'LEFT', 'RIGHT', 'A', 'X', 'L', 'R']
Global $Key = ['B', 'Y', 'RSHIFT', 'ENTER', 'UP', 'DOWN', 'LEFT', 'RIGHT', 'A', 'X', 'L', 'R']
UDPStartup()
OnAutoItExitRegister("OnAutoItExit")
$MainSocket = UDPBind($Server, $Port)
If $MainSocket = -1 Then Exit MsgBox(16, "Error", "Unable to intialize socket.")
While 1
    $Data = UDPRecv($MainSocket, $MaxLength)
    If $Data <> "" Then
        $Splitted = StringSplit($Data, '0')
        For $i = 1 To $Splitted[0]
            If $Splitted[$i] <> "" Then
                $Upper = StringUpper($Splitted[$i])
                $Index = _ArraySearch($Buttons, $Upper)
                If $Index = -1 Then
                    MsgBox(0, "title", $Data)
                    ContinueLoop
                EndIf
                If $Upper == $Splitted[$i] Then
                    Send("{" & $Key[$Index] & " DOWN}")
                Else
                    Send("{" & $Key[$Index] & " UP}")
                EndIf
            EndIf
        Next
    EndIf
WEnd

Func OnAutoItExit()
    UDPCloseSocket($MainSocket)
    UDPShutdown()
    exit
EndFunc;==>OnAutoItExit

