#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

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

    ; Find the first file in the source folder
    Local $fileHandle = FileFindFirstFile($sourceFolder & "\*.*")
    ; Check if the search was successful
    If $fileHandle = -1 Then
        MsgBox($MB_ICONERROR, "Error", "No files found in the source folder. Exiting.")
        Exit
    EndIf

    ; Move files to their respective subfolders
    While 1
        Local $file = FileFindNextFile($fileHandle)
        If @error Then ExitLoop ; Exit the loop if no more files are found

        Local $filePath = $sourceFolder & "\" & $file
        Local $fileExtension = StringLower(StringRegExpReplace($file, ".*\.(.*)", "$1"))

        ; Check if the file is not a directory and has a valid extension
        If Not FileIsDir($filePath) And $fileExtension <> "" Then
            Local $destinationSubfolder = $destinationFolder & "\" & $fileExtension
            If FileMove($filePath, $destinationSubfolder & "\" & $file, $FC_OVERWRITE) Then
                ConsoleWrite("Moved: " & $filePath & " -> " & $destinationSubfolder & "\" & $file & @CRLF)
            Else
                ConsoleWrite("Error moving: " & $filePath & @CRLF)
            EndIf
        EndIf
    WEnd

    ; Close the file handle
    FileClose($fileHandle)

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
