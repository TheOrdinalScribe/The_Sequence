' ******************************************
' THE SEQUENCE - EXCEL VBA IMPLEMENTATION
' A MONUMENT TO ORDINAL PROGRESSION
' ******************************************

Option Explicit

' MODULE-LEVEL VARIABLES
Private Type OrdinalTerm
    Exponent As Long
    Coefficient As Long
End Type

Private Type SequenceState
    Terms(1 To 32) As OrdinalTerm
    TermCount As Long
    StepCount As Long
    IsRunning As Boolean
End Type

Private Sequence As SequenceState
Private Const PI As Double = 3.14159265358979323846
Private LastUpdateTime As Double

' ******************************************
' MAIN SEQUENCE PROCEDURES
' ******************************************

Public Sub StartTheSequence()
    ' Initialize and begin the eternal sequence
    Call InitializeSequence
    Call SetupDisplay
    Call BeginSequenceLoop
End Sub

Public Sub StopTheSequence()
    ' Terminate the sequence
    Sequence.IsRunning = False
    Call RestoreExcel
End Sub

Private Sub InitializeSequence()
    ' Reset sequence state
    Dim I As Long
    
    For I = 1 To 32
        Sequence.Terms(I).Exponent = 0
        Sequence.Terms(I).Coefficient = 0
    Next I
    
    Sequence.TermCount = 0
    Sequence.StepCount = 0
    Sequence.IsRunning = True
    LastUpdateTime = Timer
End Sub

Private Sub SetupDisplay()
    ' Configure Excel for fullscreen display
    With Application
        .ScreenUpdating = False
        .DisplayFullScreen = True
        .DisplayFormulaBar = False
        .DisplayStatusBar = False
        .CommandBars("Worksheet Menu Bar").Enabled = False
        .CommandBars("Standard").Visible = False
        .CommandBars("Formatting").Visible = False
    End With
    
    ' Clear and format the worksheet
    ActiveSheet.Cells.Clear
    ActiveSheet.Cells.Interior.Color = RGB(0, 0, 0)    ' Pure black background
    ActiveSheet.Cells.Font.Color = RGB(255, 255, 255) ' White text
    ActiveSheet.Cells.Font.Name = "Courier New"       ' Monospaced font
    ActiveSheet.Cells.Font.Size = 48
    
    ' Hide gridlines and headers
    ActiveWindow.DisplayGridlines = False
    ActiveWindow.DisplayHeadings = False
    
    ' Remove scroll bars
    ActiveWindow.DisplayHorizontalScrollBar = False
    ActiveWindow.DisplayVerticalScrollBar = False
    
    ' Maximize the view
    ActiveWindow.WindowState = xlMaximized
    ActiveWindow.Zoom = 100
End Sub

Private Sub BeginSequenceLoop()
    ' Main sequence execution loop
    Do While Sequence.IsRunning
        Call UpdateOrdinal
        Call DisplayOrdinal
        Call WaitPiSeconds
        Call CheckForTermination
        DoEvents ' Allow Excel to process events
    Loop
End Sub

' ******************************************
' ORDINAL MATHEMATICS
' ******************************************

Private Sub UpdateOrdinal()
    ' Generate the next ordinal in the sequence
    Dim I As Long, Offset As Long, Remainder As Long
    
    Sequence.StepCount = Sequence.StepCount + 1
    
    ' Clear current terms
    For I = 1 To 32
        Sequence.Terms(I).Exponent = 0
        Sequence.Terms(I).Coefficient = 0
    Next I
    Sequence.TermCount = 0
    
    ' Generate ordinal based on step count
    Select Case Sequence.StepCount
        Case Is < 1000
            ' Natural numbers: 0, 1, 2, 3, ...
            If Sequence.StepCount > 0 Then
                Sequence.Terms(1).Exponent = 0
                Sequence.Terms(1).Coefficient = Sequence.StepCount
                Sequence.TermCount = 1
            End If
            
        Case 1000
            ' First limit ordinal: ω
            Sequence.Terms(1).Exponent = 1
            Sequence.Terms(1).Coefficient = 1
            Sequence.TermCount = 1
            
        Case 1001 To 1999
            ' ω + n sequence
            Offset = Sequence.StepCount - 1000
            Sequence.Terms(1).Exponent = 1
            Sequence.Terms(1).Coefficient = 1
            Sequence.Terms(2).Exponent = 0
            Sequence.Terms(2).Coefficient = Offset
            Sequence.TermCount = 2
            
        Case 2000
            ' ω⋅2
            Sequence.Terms(1).Exponent = 1
            Sequence.Terms(1).Coefficient = 2
            Sequence.TermCount = 1
            
        Case 2001 To 2999
            ' ω⋅2 + n sequence
            Offset = Sequence.StepCount - 2000
            Sequence.Terms(1).Exponent = 1
            Sequence.Terms(1).Coefficient = 2
            Sequence.Terms(2).Exponent = 0
            Sequence.Terms(2).Coefficient = Offset
            Sequence.TermCount = 2
            
        Case 3000
            ' ω²
            Sequence.Terms(1).Exponent = 2
            Sequence.Terms(1).Coefficient = 1
            Sequence.TermCount = 1
            
        Case Is > 3000
            ' Higher ordinals
            Sequence.Terms(1).Exponent = Int((Sequence.StepCount - 3000) / 1000) + 2
            Sequence.Terms(1).Coefficient = 1
            Remainder = (Sequence.StepCount - 3000) Mod 1000
            Sequence.TermCount = 1
            
            If Remainder > 0 Then
                Sequence.Terms(2).Exponent = 0
                Sequence.Terms(2).Coefficient = Remainder
                Sequence.TermCount = 2
            End If
    End Select
End Sub

Private Sub DisplayOrdinal()
    ' Render the current ordinal in the center of the screen
    Dim OrdinalString As String
    Dim CenterRow As Long, CenterCol As Long
    
    ' Build the ordinal string
    OrdinalString = BuildOrdinalString()
    
    ' Clear the display area
    ActiveSheet.Cells.Clear
    ActiveSheet.Cells.Interior.Color = RGB(0, 0, 0)
    ActiveSheet.Cells.Font.Color = RGB(255, 255, 255)
    ActiveSheet.Cells.Font.Name = "Courier New"
    ActiveSheet.Cells.Font.Size = 48
    
    ' Calculate center position (approximate)
    CenterRow = 12  ' Middle of typical screen view
    CenterCol = 10  ' Adjusted for large font
    
    ' Display the ordinal
    With ActiveSheet.Cells(CenterRow, CenterCol)
        .Value = OrdinalString
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlCenter
        .Font.Bold = True
    End With
    
    ' Merge cells for better centering
    ActiveSheet.Range(Cells(CenterRow, 1), Cells(CenterRow, 20)).Merge
    ActiveSheet.Range(Cells(CenterRow, 1), Cells(CenterRow, 20)).HorizontalAlignment = xlCenter
    ActiveSheet.Range(Cells(CenterRow, 1), Cells(CenterRow, 20)).VerticalAlignment = xlCenter
    
    Application.ScreenUpdating = True
    DoEvents
    Application.ScreenUpdating = False
End Sub

Private Function BuildOrdinalString() As String
    ' Construct the ordinal representation string
    Dim Result As String
    Dim I As Long
    Dim Exp As Long, Coeff As Long
    
    If Sequence.TermCount = 0 Then
        BuildOrdinalString = "0"
        Exit Function
    End If
    
    For I = 1 To Sequence.TermCount
        Exp = Sequence.Terms(I).Exponent
        Coeff = Sequence.Terms(I).Coefficient
        
        If I > 1 Then Result = Result & "+"
        
        Select Case Exp
            Case 0
                ' Constant term
                If Coeff = 1 And I > 1 Then
                    Result = Result & "1"
                Else
                    Result = Result & CStr(Coeff)
                End If
                
            Case 1
                ' ω term
                If Coeff = 1 Then
                    Result = Result & "ω"
                Else
                    Result = Result & "ω⋅" & CStr(Coeff)
                End If
                
            Case 2
                ' ω² term
                If Coeff = 1 Then
                    Result = Result & "ω²"
                Else
                    Result = Result & "ω²⋅" & CStr(Coeff)
                End If
                
            Case Is > 2
                ' ω^n term
                If Coeff = 1 Then
                    Result = Result & "ω^" & CStr(Exp)
                Else
                    Result = Result & "ω^" & CStr(Exp) & "⋅" & CStr(Coeff)
                End If
        End Select
    Next I
    
    BuildOrdinalString = Result
End Function

' ******************************************
' TIMING AND CONTROL
' ******************************************

Private Sub WaitPiSeconds()
    ' Wait exactly π seconds using high precision timing
    Dim StartTime As Double
    Dim ElapsedTime As Double
    
    StartTime = Timer
    
    Do
        DoEvents ' Allow Excel to remain responsive
        ElapsedTime = Timer - StartTime
        
        ' Handle midnight rollover
        If ElapsedTime < 0 Then
            ElapsedTime = ElapsedTime + 86400
        End If
        
        ' Brief sleep to prevent excessive CPU usage
        Application.Wait Now + TimeValue("00:00:00.001")
        
    Loop While ElapsedTime < PI And Sequence.IsRunning
End Sub

Private Sub CheckForTermination()
    ' Check for termination conditions
    ' In Excel VBA, we rely on the user stopping the macro
    ' or the StopTheSequence procedure being called
    
    ' The sequence continues until explicitly stopped
    If Not Sequence.IsRunning Then Exit Sub
End Sub

Private Sub RestoreExcel()
    ' Restore Excel to normal state
    With Application
        .ScreenUpdating = True
        .DisplayFullScreen = False
        .DisplayFormulaBar = True
        .DisplayStatusBar = True
        .CommandBars("Worksheet Menu Bar").Enabled = True
        .CommandBars("Standard").Visible = True
        .CommandBars("Formatting").Visible = True
    End With
    
    ActiveWindow.DisplayGridlines = True
    ActiveWindow.DisplayHeadings = True
    ActiveWindow.DisplayHorizontalScrollBar = True
    ActiveWindow.DisplayVerticalScrollBar = True
    
    ' Clear the display
    ActiveSheet.Cells.Clear
    ActiveSheet.Cells.Interior.ColorIndex = xlNone
    ActiveSheet.Cells.Font.ColorIndex = xlAutomatic
    ActiveSheet.Cells.Font.Name = "Calibri"
    ActiveSheet.Cells.Font.Size = 11
End Sub

' ******************************************
' EVENT HANDLERS
' ******************************************

Private Sub Workbook_BeforeClose(Cancel As Boolean)
    ' Ensure cleanup on workbook close
    Call StopTheSequence
End Sub

Private Sub Worksheet_SelectionChange(ByVal Target As Range)
    ' Prevent user interaction during sequence
    If Sequence.IsRunning Then
        Application.EnableEvents = False
        ActiveSheet.Cells(12, 10).Select ' Return to center
        Application.EnableEvents = True
    End If
End Sub