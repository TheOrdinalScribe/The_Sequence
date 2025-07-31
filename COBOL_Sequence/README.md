# The Sequence (COBOL Implementation)

A monument to ordinal progression in enterprise COBOL. The application displays an unending sequence of ordinals in Cantor Normal Form, updating every π seconds.

## Files

- `SEQUENCE.COB` - Main COBOL source code
- `COMPILE.BAT` - Windows compilation script
- `Makefile` - Unix/Linux compilation script

## Requirements

A COBOL compiler such as:
- **GnuCOBOL** (free, open source) - Recommended
- Micro Focus COBOL
- IBM Enterprise COBOL
- Any COBOL-2014 compatible compiler

### Installing GnuCOBOL

**Windows:**
Download from: https://sourceforge.net/projects/gnucobol/

**Linux/macOS:**
```bash
# Ubuntu/Debian
sudo apt-get install gnucobol4

# macOS with Homebrew
brew install gnu-cobol
```

## Compilation

### Windows
```cmd
COMPILE.BAT
```

### Unix/Linux/macOS
```bash
make
```

### Manual Compilation
```bash
cobc -x SEQUENCE.COB -o sequence
```

## Execution

### Windows
```cmd
SEQUENCE.EXE
```

### Unix/Linux/macOS
```bash
./sequence
```

Or use make:
```bash
make run
```

## Termination

- ESC key
- Any keystroke (terminates gracefully)
- Ctrl+C (system interrupt)

## Specifications

- 80x25 character terminal display
- Pure black background with white foreground
- Centered ordinal display
- Updates every π seconds using high-precision timing
- Minimal user interaction (termination only)
- Ordinals rendered in Cantor Normal Form: 0,1,2,3,...,ω,ω+1,ω+2,...,ω⋅2,...,ω²,...

## COBOL Features Used

- IDENTIFICATION/ENVIRONMENT/DATA/PROCEDURE divisions
- WORKING-STORAGE with OCCURS clauses for ordinal term arrays
- SCREEN SECTION for terminal control
- PERFORM loops with VARYING and UNTIL
- EVALUATE statements for ordinal generation logic
- STRING functions for ordinal display formatting
- TIME functions for π-second precision timing

The sequence exists as its own justification.