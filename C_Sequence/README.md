# The Sequence (C Implementation)

A monument to ordinal progression in pure C. The application displays an unending sequence of ordinals in Cantor Normal Form, updating every π seconds.

## Build

```bash
make
```

## Execution

```bash
./sequence
```

Or build and run:
```bash
make run
```

## Termination

- Ctrl+C
- SIGTERM
- SIGINT

## Requirements

- C99 compatible compiler (gcc recommended)
- POSIX-compliant system (Linux/Unix/macOS) or Windows
- Math library (-lm)

## Specifications

- Fullscreen terminal display
- Pure black background
- White monospaced text, perfectly centered
- Updates every π seconds using M_PI constant
- No user interaction beyond system termination signals
- Ordinals rendered in Cantor Normal Form: 0,1,2,3,...,ω,ω+1,ω+2,...,ω⋅2,...,ω²,...

The sequence exists as its own justification.