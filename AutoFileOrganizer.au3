; Automated File Organizer

#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
    Local $sSourceFolder, $sDestinationFolder

    ; Ask the user to input the source folder
    $sSourceFolder = FileSelectFolder("Select the source folder", "", 3)
    If @error Then
        MsgBox($MB_ICONERROR, "Error", "Source folder selection canceled.")
        Exit
    EndIf

    ; Ask the user to input the destination folder
    $sDestinationFolder = FileSelectFolder("Select the destination folder", "", 3)
    If @error Then
        MsgBox($MB_ICONERROR, "Error", "Destination folder selection canceled.")
        Exit
    EndIf

    ; Call the function to organize the files
    If OrganizeFiles($sSourceFolder, $sDestinationFolder) Then
        MsgBox($MB_ICONINFORMATION, "Success", "Files organized successfully.")
    Else
        MsgBox($MB_ICONERROR, "Error", "Failed to organize files.")
    EndIf
EndFunc   ;==>Example

Func OrganizeFiles($sSourceFolder, $sDestinationFolder)
    ; Check if the source folder exists
    If Not FileExists($sSourceFolder) Then
        MsgBox($MB_ICONERROR, "Error", "Source folder does not exist.")
        Return False
    EndIf

    ; Check if the destination folder exists, if not, create it
    If Not FileExists($sDestinationFolder) Then
        DirCreate($sDestinationFolder)
        If @error Then
            MsgBox($MB_ICONERROR, "Error", "Failed to create destination folder.")
            Return False
        EndIf
    EndIf

    ; Loop through the files in the source folder
    Local $aFiles = _FileListToArray($sSourceFolder, "*.*", $FLTA_FILES)
    If @error Then
        MsgBox($MB_ICONERROR, "Error", "Failed to read files in source folder.")
        Return False
    EndIf

    For $i = 1 To $aFiles[0]
        ; Get the file extension
        Local $sExtension = StringLower(StringTrimLeft($aFiles[$i], StringInStr($aFiles[$i], ".", 0, -1)))

        ; Check if the file has an extension (not a folder)
        If $sExtension <> "" Then
            ; Create the subfolder based on the file extension
            Local $sSubfolder = $sDestinationFolder & "\" & $sExtension
            If Not FileExists($sSubfolder) Then
                DirCreate($sSubfolder)
                If @error Then
                    MsgBox($MB_ICONERROR, "Error", "Failed to create subfolder: " & $sExtension)
                    Return False
                EndIf
            EndIf

            ; Move the file to the subfolder
            FileMove($sSourceFolder & "\" & $aFiles[$i], $sSubfolder & "\" & $aFiles[$i])
            If @error Then
                MsgBox($MB_ICONERROR, "Error", "Failed to move file: " & $aFiles[$i])
                Return False
            EndIf
        EndIf
    Next

    Return True
EndFunc   ;==>OrganizeFiles
