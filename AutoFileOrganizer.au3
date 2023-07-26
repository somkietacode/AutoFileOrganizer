#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include "File.au3" ; Include the File.au3 UDF

Example()

Func Example()
    ; Prompt the user to select the source folder
    Local $sourceFolder = FileSelectFolder("Select the source folder", "")
    If @error Then
        MsgBox($MB_ICONERROR, "Error", "No source folder selected. Exiting.")
        Exit
    EndIf

    ; Prompt the user to select the destination folder
    Local $destinationFolder = FileSelectFolder("Select the destination folder", "")
    If @error Then
        MsgBox($MB_ICONERROR, "Error", "No destination folder selected. Exiting.")
        Exit
    EndIf

    ; Create the destination subfolders for different file types
    CreateSubfolders($destinationFolder)

    ; Get a list of files in the source folder
    Local $fileList = FileListToArray($sourceFolder, "*")

    ; Move files to their respective subfolders
    For $i = 1 To $fileList[0]
        Local $filePath = $sourceFolder & "\" & $fileList[$i]
        Local $fileExtension = StringLower(StringRegExpReplace($fileList[$i], ".*\.(.*)", "$1"))

        ; Check if the file is not a directory and has a valid extension
        If Not FileIsDir($filePath) And $fileExtension <> "" Then
            Local $destinationSubfolder = $destinationFolder & "\" & $fileExtension
            If FileMove($filePath, $destinationSubfolder & "\" & $fileList[$i], $FC_OVERWRITE) Then
                ConsoleWrite("Moved: " & $filePath & " -> " & $destinationSubfolder & "\" & $fileList[$i] & @CRLF)
            Else
                ConsoleWrite("Error moving: " & $filePath & @CRLF)
            EndIf
        EndIf
    Next

    MsgBox($MB_ICONINFORMATION, "Done", "Files organized successfully!")
EndFunc   ;==>Example

Func CreateSubfolders($folderPath)
    ; List of file extensions and their corresponding subfolder names
    Local $fileTypes = ["Images", "jpg|png|gif|bmp", "Documents", "doc|docx|pdf|txt", "Videos", "mp4|avi|mov", "Music", "mp3|wav"]

    For $i = 0 To UBound($fileTypes) - 1 Step 2
        Local $subfolderName = $fileTypes[$i]
        Local $fileExtensions = StringSplit($fileTypes[$i + 1], "|", 2)

        Local $subfolderPath = $folderPath & "\" & $subfolderName
        If Not FileExists($subfolderPath) Then
            DirCreate($subfolderPath)
        EndIf
    Next
EndFunc   ;==>CreateSubfolders
