' ******************************************
' THE SEQUENCE - EXCEL SETUP SCRIPT
' Creates the Excel workbook with embedded VBA
' ******************************************

Option Explicit

Dim xlApp, xlBook, xlModule, xlSheet
Dim fso, basFile, basContent

' Create Excel application
Set xlApp = CreateObject("Excel.Application")
xlApp.Visible = True
xlApp.DisplayAlerts = False

' Create new workbook
Set xlBook = xlApp.Workbooks.Add
Set xlSheet = xlBook.Worksheets(1)

' Rename the worksheet
xlSheet.Name = "The Sequence"

' Configure the worksheet
With xlSheet
    .Cells.Interior.Color = RGB(0, 0, 0)    ' Black background
    .Cells.Font.Color = RGB(255, 255, 255) ' White text
    .Cells.Font.Name = "Courier New"       ' Monospaced font
    .Cells.Font.Size = 48
End With

' Hide unnecessary elements
xlApp.DisplayFormulaBar = False
xlApp.DisplayStatusBar = False

With xlSheet.Parent.Windows(1)
    .DisplayGridlines = False
    .DisplayHeadings = False
    .DisplayHorizontalScrollBar = False
    .DisplayVerticalScrollBar = False
End With

' Read the VBA code from the .bas file
Set fso = CreateObject("Scripting.FileSystemObject")
Set basFile = fso.OpenTextFile("TheSequence.bas", 1)
basContent = basFile.ReadAll
basFile.Close

' Add VBA module with the sequence code
Set xlModule = xlBook.VBProject.VBComponents.Add(1) ' vbext_ct_StdModule
xlModule.Name = "TheSequenceModule"
xlModule.CodeModule.AddFromString basContent

' Add a simple start button (optional)
With xlSheet.Cells(1, 1)
    .Value = "Click here or press Ctrl+Shift+S to start The Sequence"
    .Font.Size = 12
    .Font.Color = RGB(128, 128, 128)
    .Interior.Color = RGB(32, 32, 32)
End With

' Create a simple auto-start macro
Dim autoStartCode As String
autoStartCode = "Private Sub Worksheet_Activate()" & vbCrLf & _
                "    Call TheSequenceModule.StartTheSequence" & vbCrLf & _
                "End Sub" & vbCrLf & vbCrLf & _
                "Private Sub Worksheet_SelectionChange(ByVal Target As Range)" & vbCrLf & _
                "    If Target.Address = ""$A$1"" Then" & vbCrLf & _
                "        Call TheSequenceModule.StartTheSequence" & vbCrLf & _
                "    End If" & vbCrLf & _
                "End Sub"

xlSheet.CodeModule.AddFromString autoStartCode

' Add keyboard shortcut
xlApp.OnKey "^+s", "TheSequenceModule.StartTheSequence"  ' Ctrl+Shift+S
xlApp.OnKey "^+q", "TheSequenceModule.StopTheSequence"   ' Ctrl+Shift+Q

' Save as macro-enabled workbook
xlBook.SaveAs "TheSequence.xlsm", 52 ' xlOpenXMLWorkbookMacroEnabled

WScript.Echo "The Sequence Excel workbook has been created: TheSequence.xlsm"
WScript.Echo "Press Ctrl+Shift+S to start the sequence"
WScript.Echo "Press Ctrl+Shift+Q to stop the sequence"

' Clean up
Set xlModule = Nothing
Set xlSheet = Nothing  
Set xlBook = Nothing
Set xlApp = Nothing
Set fso = Nothing