' ******************************************
' THE SEQUENCE - WORKSHEET EVENT HANDLERS  
' This code goes in the worksheet module
' ******************************************

Private Sub Worksheet_Activate()
    ' Prepare the void when worksheet is activated
    Call PrepareTheVoid
End Sub

Private Sub Worksheet_SelectionChange(ByVal Target As Range)
    ' Handle cell selection during sequence execution
    Static IsSequenceRunning As Boolean
    
    ' Start sequence if A1 is clicked
    If Target.Address = "$A$1" And Not IsSequenceRunning Then
        IsSequenceRunning = True
        Call TheSequenceModule.StartTheSequence  
        IsSequenceRunning = False
    End If
    
    ' Prevent user interaction during active sequence
    If IsSequenceRunning Then
        Application.EnableEvents = False
        Range("J12").Select ' Return to center
        Application.EnableEvents = True
    End If
End Sub

Private Sub Worksheet_BeforeDoubleClick(ByVal Target As Range, Cancel As Boolean)
    ' Cancel double-click actions during sequence
    Cancel = True
    If Target.Address = "$A$1" Then
        Call TheSequenceModule.StartTheSequence
    End If
End Sub

Private Sub Worksheet_BeforeRightClick(ByVal Target As Range, Cancel As Boolean)
    ' Disable right-click context menu
    Cancel = True
End Sub

Private Sub Worksheet_Change(ByVal Target As Range)
    ' Prevent manual cell changes
    Application.EnableEvents = False
    Application.Undo
    Application.EnableEvents = True
End Sub

Private Sub PrepareTheVoid()
    ' Configure the worksheet for sequence display
    Application.ScreenUpdating = False
    
    ' Clear everything
    Cells.Clear
    
    ' Set the void - pure black background
    Cells.Interior.Color = RGB(0, 0, 0)
    Cells.Font.Color = RGB(255, 255, 255)
    Cells.Font.Name = "Courier New"
    Cells.Font.Size = 48
    Cells.Font.Bold = True
    
    ' Configure display properties
    With ActiveWindow
        .DisplayGridlines = False
        .DisplayHeadings = False
        .DisplayHorizontalScrollBar = False  
        .DisplayVerticalScrollBar = False
        .Zoom = 100
    End With
    
    ' Add the subtle start instruction
    With Range("A1")
        .Value = "Begin"
        .Font.Size = 14
        .Font.Color = RGB(64, 64, 64)
        .Font.Italic = True
        .HorizontalAlignment = xlLeft
        .VerticalAlignment = xlTop
    End With
    
    ' Center the view on the display area
    Range("J12").Select
    
    Application.ScreenUpdating = True
End Sub