# The Sequence (BASIC Implementation)

A monument to ordinal progression in line-numbered BASIC. The application displays an unending sequence of ordinals in Cantor Normal Form, updating every π seconds.

## Files

- `SEQUENCE.BAS` - Line-numbered BASIC version (compatible with classic BASIC interpreters)
- `SEQUENCE_QBASIC.BAS` - QBasic/QuickBASIC structured version

## Execution

### Classic BASIC Interpreters
```
LOAD "SEQUENCE.BAS"
RUN
```

### QBasic/QuickBASIC
```
LOAD "SEQUENCE_QBASIC.BAS"  
RUN
```

### Modern BASIC Interpreters
Many modern BASIC interpreters (FreeBASIC, PC-BASIC, etc.) can run either version.

## Termination

- ESC key
- Space key (QBasic version)
- Ctrl+C (system interrupt)

## Requirements

- Any BASIC interpreter supporting:
  - Arrays (DIM statement)
  - String manipulation
  - TIMER function
  - Screen control (CLS, LOCATE, COLOR)

## Specifications

- 80x25 text mode display
- Pure black background with white text
- Centered ordinal display
- Updates every π seconds using highest precision available
- Minimal user interaction (termination keys only)
- Ordinals rendered as: 0,1,2,3,...,w,w+1,w+2,...,w*2,...,w^2,...

Note: Due to character set limitations, ω (omega) is represented as 'w' in the display.

The sequence exists as its own justification.