REM ******************************************
REM THE SEQUENCE - QBASIC IMPLEMENTATION  
REM A MONUMENT TO ORDINAL PROGRESSION
REM ******************************************

DIM TERMS(32, 2) AS INTEGER
DIM DISPLAY$ AS STRING * 200
CONST PI = 3.14159265358979#
DIM STEP_COUNT AS LONG
DIM TERM_COUNT AS INTEGER
DIM RUNNING AS INTEGER

REM SETUP DISPLAY
SCREEN 0
WIDTH 80, 25
COLOR 15, 0
CLS

REM INITIALIZE
STEP_COUNT = 0
TERM_COUNT = 0
RUNNING = 1

REM MAIN SEQUENCE LOOP
WHILE RUNNING = 1
    CALL UpdateOrdinal
    CALL DisplayOrdinal
    CALL WaitPiSeconds
    CALL CheckTermination
WEND
END

SUB UpdateOrdinal
    SHARED STEP_COUNT, TERMS(), TERM_COUNT
    
    STEP_COUNT = STEP_COUNT + 1
    
    REM CLEAR CURRENT TERMS
    FOR I = 1 TO 32
        TERMS(I, 1) = 0
        TERMS(I, 2) = 0
    NEXT I
    TERM_COUNT = 0
    
    REM GENERATE NEXT ORDINAL
    IF STEP_COUNT < 1000 THEN
        REM NATURAL NUMBERS: 0, 1, 2, 3, ...
        IF STEP_COUNT > 0 THEN
            TERMS(1, 1) = 0
            TERMS(1, 2) = STEP_COUNT
            TERM_COUNT = 1
        END IF
    ELSEIF STEP_COUNT = 1000 THEN
        REM FIRST LIMIT ORDINAL: ω
        TERMS(1, 1) = 1
        TERMS(1, 2) = 1
        TERM_COUNT = 1
    ELSEIF STEP_COUNT < 2000 THEN
        REM ω + n SEQUENCE
        OFFSET = STEP_COUNT - 1000
        TERMS(1, 1) = 1
        TERMS(1, 2) = 1
        TERM_COUNT = 1
        IF OFFSET > 0 THEN
            TERMS(2, 1) = 0
            TERMS(2, 2) = OFFSET
            TERM_COUNT = 2
        END IF
    ELSEIF STEP_COUNT = 2000 THEN
        REM ω⋅2
        TERMS(1, 1) = 1
        TERMS(1, 2) = 2
        TERM_COUNT = 1
    ELSEIF STEP_COUNT < 3000 THEN
        REM ω⋅2 + n SEQUENCE
        OFFSET = STEP_COUNT - 2000
        TERMS(1, 1) = 1
        TERMS(1, 2) = 2
        TERM_COUNT = 1
        IF OFFSET > 0 THEN
            TERMS(2, 1) = 0
            TERMS(2, 2) = OFFSET
            TERM_COUNT = 2
        END IF
    ELSEIF STEP_COUNT = 3000 THEN
        REM ω²
        TERMS(1, 1) = 2
        TERMS(1, 2) = 1
        TERM_COUNT = 1
    ELSE
        REM HIGHER ORDINALS
        TERMS(1, 1) = INT((STEP_COUNT - 3000) / 1000) + 2
        TERMS(1, 2) = 1
        REMAINDER = (STEP_COUNT - 3000) MOD 1000
        TERM_COUNT = 1
        IF REMAINDER > 0 THEN
            TERMS(2, 1) = 0
            TERMS(2, 2) = REMAINDER
            TERM_COUNT = 2
        END IF
    END IF
END SUB

SUB DisplayOrdinal
    SHARED TERMS(), TERM_COUNT, DISPLAY$
    
    DISPLAY$ = ""
    
    REM BUILD ORDINAL STRING
    IF TERM_COUNT = 0 THEN
        DISPLAY$ = "0"
        GOTO DisplayIt
    END IF
    
    FOR I = 1 TO TERM_COUNT
        EXP = TERMS(I, 1)
        COEFF = TERMS(I, 2)
        
        IF I > 1 THEN DISPLAY$ = DISPLAY$ + "+"
        
        IF EXP = 0 THEN
            IF COEFF = 1 AND I > 1 THEN
                DISPLAY$ = DISPLAY$ + "1"
            ELSE
                DISPLAY$ = DISPLAY$ + LTRIM$(STR$(COEFF))
            END IF
        ELSEIF EXP = 1 THEN
            IF COEFF = 1 THEN
                DISPLAY$ = DISPLAY$ + "w"
            ELSE
                DISPLAY$ = DISPLAY$ + "w*" + LTRIM$(STR$(COEFF))
            END IF
        ELSEIF EXP = 2 THEN
            IF COEFF = 1 THEN
                DISPLAY$ = DISPLAY$ + "w^2"
            ELSE
                DISPLAY$ = DISPLAY$ + "w^2*" + LTRIM$(STR$(COEFF))
            END IF
        ELSE
            IF COEFF = 1 THEN
                DISPLAY$ = DISPLAY$ + "w^" + LTRIM$(STR$(EXP))
            ELSE
                DISPLAY$ = DISPLAY$ + "w^" + LTRIM$(STR$(EXP)) + "*" + LTRIM$(STR$(COEFF))
            END IF
        END IF
    NEXT I
    
DisplayIt:
    REM CENTER AND DISPLAY
    CLS
    ROW = 12
    COL = (80 - LEN(DISPLAY$)) \ 2 + 1
    LOCATE ROW, COL
    PRINT DISPLAY$;
END SUB

SUB WaitPiSeconds
    SHARED PI
    
    StartTime = TIMER
    TargetWait = PI
    
    REM PRECISION WAIT LOOP
    DO WHILE (TIMER - StartTime) < TargetWait
        REM HANDLE TIMER ROLLOVER AT MIDNIGHT
        IF TIMER < StartTime THEN
            StartTime = StartTime - 86400
        END IF
    LOOP
END SUB

SUB CheckTermination
    SHARED RUNNING
    
    REM CHECK FOR ESC KEY OR SPACE
    K$ = INKEY$
    IF K$ = CHR$(27) THEN RUNNING = 0
    IF K$ = " " THEN RUNNING = 0
END SUB