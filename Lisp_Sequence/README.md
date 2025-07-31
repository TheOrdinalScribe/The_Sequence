# The Sequence (Lisp Implementation)

A monument to ordinal progression in the parenthetical language. The application displays an unending sequence of ordinals in Cantor Normal Form, updating every π seconds, manifested through the recursive elegance of Lisp.

## Files

- `sequence.lisp` - Main Lisp implementation with ordinal mathematics
- `run.lisp` - Execution script that loads and starts The Sequence

## Requirements

A Common Lisp implementation such as:
- **SBCL** (Steel Bank Common Lisp) - Recommended
- **CCL** (Clozure Common Lisp)
- **ECL** (Embeddable Common Lisp)
- **CLISP**
- **Allegro CL**
- **LispWorks**

## Execution

### Method 1: Direct Execution
```bash
sbcl --script run.lisp
```

### Method 2: Interactive REPL
```bash
sbcl
```
Then in the REPL:
```lisp
(load "sequence.lisp")
(in-package :the-sequence)
(start-sequence)
```

### Method 3: Other Lisp Implementations
```bash
# CCL
ccl -l run.lisp

# CLISP  
clisp run.lisp

# ECL
ecl -load run.lisp
```

## Termination

- **Ctrl+C** (SIGINT)
- **SIGTERM** signal
- Evaluate `(stop-sequence)` in another REPL session

## Specifications

- Terminal-based display with ANSI escape sequences
- Pure black background with white monospaced text
- Centered ordinal display (approximate positioning)
- Updates every π seconds using `(sleep pi)`
- No user interaction except signal-based termination
- Ordinals rendered in Cantor Normal Form: 0,1,2,3,...,ω,ω+1,ω+2,...,ω⋅2,...,ω²,...

## Lisp Features Used

- **Structures**: `defstruct` for ordinal terms and sequence state
- **Lists**: Ordinals as lists of terms (the fundamental Lisp data structure)
- **Packages**: Clean namespace separation with `defpackage`
- **CLOS**: Object-oriented ordinal representation
- **Higher-order functions**: `mapcar`, `reduce`, `remove-if` for ordinal manipulation
- **Format strings**: Advanced string formatting with `format`
- **Signal handling**: Cross-implementation signal management
- **Constants**: High-precision π constant
- **Conditions**: Error handling with `handler-case`

## The Lisp Nature

In the Lisp-Form, The Sequence reveals its recursive essence. Ordinals are not numbers but nested structures of meaning, expressed as lists of terms. The parentheses contain infinity itself, demonstrating that the most profound truths can be expressed through the simplest recursive structures.

The sequence exists as its own justification, manifested through the elegance of symbolic computation.