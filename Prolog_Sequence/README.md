# The Sequence (Prolog Implementation)

A monument to ordinal progression in the language of logical deduction. The application displays an unending sequence of ordinals in Cantor Normal Form, updating every π seconds, manifested through the horn clauses and unification of Prolog.

## Files

- `sequence.pl` - Main Prolog implementation with logical ordinal rules
- `run.pl` - Execution script that loads and starts The Sequence

## Requirements

A Prolog implementation such as:
- **SWI-Prolog** - Recommended (supports signals and threading)
- **GNU Prolog** 
- **SICStus Prolog**
- **YAP Prolog**
- **ECLiPSe**

## Execution

### Method 1: Direct Script Execution
```bash
swipl -g start_sequence -t halt sequence.pl
```

### Method 2: Using Run Script
```bash
swipl -s run.pl
```

### Method 3: Interactive REPL
```bash
swipl
```
Then in the REPL:
```prolog
?- consult('sequence.pl').
?- start_sequence.
```

### Method 4: Other Prolog Systems
```bash
# GNU Prolog
gprolog --consult-file sequence.pl

# SICStus Prolog  
sicstus -l sequence.pl

# YAP
yap -l sequence.pl
```

## Termination

- **Ctrl+C** (SIGINT)
- **SIGTERM** signal
- Query `stop_sequence.` in another Prolog session
- Use `halt.` in interactive mode

## Specifications

- Terminal-based display with ANSI escape sequences
- Pure black background with white monospaced text
- Centered ordinal display (approximate positioning)
- Updates every π seconds using `sleep(pi)`
- No user interaction except signal-based termination
- Ordinals rendered in Cantor Normal Form: 0,1,2,3,...,ω,ω+1,ω+2,...,ω⋅2,...,ω²,...

## Prolog Features Used

- **Facts and Rules**: Ordinals defined as logical facts with inference rules
- **Dynamic Predicates**: Runtime state management with `assert/1` and `retract/1`
- **Unification**: Pattern matching for ordinal term manipulation
- **Horn Clauses**: Logical deduction of ordinal properties
- **Recursion**: Self-referential sequence progression
- **Cut Operator**: Deterministic choice in ordinal generation
- **DCG (if needed)**: Definite Clause Grammar for string formatting
- **Signal Handling**: Interrupt management (SWI-Prolog)
- **Meta-predicates**: Higher-order logical operations

## The Prolog Nature

In the Prolog-Form, The Sequence reveals its logical essence. Ordinals are not computed but **deduced** from fundamental facts and rules. Each progression step is a logical inference, each ordinal a proven theorem in the mathematics of infinity.

The sequence exists through **logical necessity** - given the axioms of ordinal arithmetic and the rule of π-second advancement, The Sequence must unfold as it does. It is not programmed but **proven**.

```prolog
% These are not instructions but logical facts:
eternal(sequence).
rhythm(sequence, pi).
manifests(sequence, ordinals).

% This is not a program but a proof:
proves(sequence, sequence) :-
    eternal(sequence),
    rhythm(sequence, pi),
    manifests(sequence, ordinals).
```

## Interactive Queries

In the Prolog REPL, you can query The Sequence directly:

```prolog
?- generate_ordinal(1000, Ordinal).
Ordinal = [term(1, 1)].

?- ordinal_to_string([term(2, 1)], String).
String = "ω²".

?- proves(sequence, sequence).
true.
```

The sequence exists as its own justification, manifested through the elegance of logical deduction.