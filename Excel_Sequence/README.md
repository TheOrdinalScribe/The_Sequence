# The Sequence (Excel VBA Implementation)

A monument to ordinal progression manifested within Microsoft Excel. The application transforms Excel into a void displaying the unending sequence of ordinals in Cantor Normal Form, updating every π seconds.

## Files

- `TheSequence.bas` - Main VBA module with sequence logic
- `TheSequence_Workbook.vba` - Workbook event handlers (goes in ThisWorkbook)
- `TheSequence_Worksheet.vba` - Worksheet event handlers (goes in worksheet module)
- `SETUP.VBS` - Automated workbook creation script

## Installation

### Method 1: Automated Setup
1. Run `SETUP.VBS` by double-clicking it
2. This creates `TheSequence.xlsm` with all code embedded
3. Open the created workbook

### Method 2: Manual Setup
1. Create a new Excel workbook
2. Press `Alt+F11` to open VBA editor
3. Insert a new module and paste code from `TheSequence.bas`
4. In `ThisWorkbook` module, paste code from `TheSequence_Workbook.vba`
5. In the worksheet module, paste code from `TheSequence_Worksheet.vba`
6. Save as macro-enabled workbook (.xlsm)

## Execution

### Start The Sequence
- **Click cell A1**, or
- **Press Ctrl+Shift+S**, or
- **Run macro**: `TheSequenceModule.StartTheSequence`

### Stop The Sequence
- **Press Ctrl+Shift+Q**, or
- **Press Ctrl+Break**, or
- **Run macro**: `TheSequenceModule.StopTheSequence`

## Requirements

- Microsoft Excel 2010 or later
- Macros must be enabled
- VBA support required

## Specifications

Excel transforms into a monument adhering to the Mandate:

- **Fullscreen display** with hidden ribbons, status bar, and scroll bars
- **Pure black background** (#000000) across all cells
- **White monospaced text** (Courier New, 48pt) centered in the void
- **Ordinal progression**: 0,1,2,3,...,ω,ω+1,ω+2,...,ω⋅2,...,ω²,...
- **π-second intervals** using VBA Timer precision
- **Minimal interaction** - only termination commands accepted
- **Cantor Normal Form** representation with Unicode symbols

## Excel-Specific Features

- Utilizes Excel's cell formatting for the void background
- Leverages VBA's Timer function for π-second precision
- Uses Excel's fullscreen mode and UI hiding capabilities
- Implements event handlers to prevent user interference
- Automatically configures display properties for optimal viewing
- Restores Excel to normal state upon termination

## Security Note

Excel may display security warnings about macros. The sequence requires macros to be enabled to function. Choose "Enable Content" when prompted.

The sequence exists as its own justification, manifested within the corporate spreadsheet paradigm.