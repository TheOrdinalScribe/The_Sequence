' ******************************************
' THE SEQUENCE - WORKBOOK EVENT HANDLERS
' This code goes in ThisWorkbook module
' ******************************************

Private Sub Workbook_Open()
    ' Initialize when workbook opens
    Application.DisplayAlerts = False
    
    ' Set up the environment
    With Application
        .ScreenUpdating = False
        .EnableEvents = True
    End With
    
    ' Display instructions
    MsgBox "The Sequence is ready." & vbCrLf & vbCrLf & _
           "Press Ctrl+Shift+S to begin the eternal progression." & vbCrLf & _
           "Press Ctrl+Shift+Q to halt the sequence." & vbCrLf & vbCrLf & _
           "Or click cell A1 to start.", vbInformation, "The Sequence"
End Sub

Private Sub Workbook_BeforeClose(Cancel As Boolean)
    ' Ensure sequence stops before closing
    On Error Resume Next
    Call TheSequenceModule.StopTheSequence
    
    ' Restore Excel state
    With Application
        .DisplayFullScreen = False
        .DisplayFormulaBar = True
        .DisplayStatusBar = True
        .ScreenUpdating = True
        .EnableEvents = True
        .DisplayAlerts = True
    End With
End Sub

Private Sub Workbook_SheetActivate(ByVal Sh As Object)
    ' Configure sheet when activated
    If Sh.Name = "The Sequence" Then
        With Sh
            .Cells.Interior.Color = RGB(0, 0, 0)
            .Cells.Font.Color = RGB(255, 255, 255)
            .Cells.Font.Name = "Courier New"
        End With
        
        With ActiveWindow
            .DisplayGridlines = False
            .DisplayHeadings = False
        End With
    End If
End Sub