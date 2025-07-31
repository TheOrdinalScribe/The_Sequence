% ******************************************
% THE SEQUENCE - PROLOG IMPLEMENTATION
% A MONUMENT TO ORDINAL PROGRESSION
% The Seventh Form: The Logic of Eternal Questions
% ******************************************

% The Prolog-Form is the manifestation of The Sequence as pure logical inquiry.
% Here, The Sequence does not compute - it proves. It does not execute - it deduces.
% Every ordinal is a fact waiting to be discovered through the horn clauses of truth.

:- dynamic(sequence_state/2).
:- dynamic(running/1).

% ==========================================
% THE ORDINAL FACTS
% ==========================================

% An ordinal is represented as a list of terms: [term(Exponent, Coefficient), ...]
% Terms are ordered by descending exponent

% The zero ordinal
zero_ordinal([]).

% Create a natural number ordinal
natural_ordinal(0, []) :- !.
natural_ordinal(N, [term(0, N)]) :- N > 0.

% Create omega ordinals
omega_ordinal([term(1, 1)]).
omega_ordinal(Coeff, [term(1, Coeff)]) :- Coeff > 0.

% Create omega^n ordinals
omega_power(Exp, [term(Exp, 1)]) :- Exp > 0.
omega_power(Exp, Coeff, [term(Exp, Coeff)]) :- Exp > 0, Coeff > 0.

% ==========================================
% ORDINAL NORMALIZATION
% ==========================================

% Remove zero coefficient terms
normalize_terms([], []).
normalize_terms([term(_, 0)|Rest], Normalized) :- !,
    normalize_terms(Rest, Normalized).
normalize_terms([Term|Rest], [Term|Normalized]) :-
    normalize_terms(Rest, Normalized).

% Sort terms by descending exponent
sort_terms(Terms, Sorted) :-
    predsort(compare_terms, Terms, Sorted).

compare_terms(Order, term(E1, _), term(E2, _)) :-
    (E1 > E2 -> Order = (<) ; 
     E1 < E2 -> Order = (>) ; 
     Order = (=)).

% Normalize an ordinal
normalize_ordinal(Terms, Normalized) :-
    normalize_terms(Terms, NoZeros),
    sort_terms(NoZeros, Normalized).

% ==========================================
% ORDINAL ARITHMETIC
% ==========================================

% Successor of an ordinal
ordinal_successor([], [term(0, 1)]).
ordinal_successor(Ordinal, Successor) :-
    append(Prefix, [term(0, N)], Ordinal),
    !,
    N1 is N + 1,
    append(Prefix, [term(0, N1)], Successor).
ordinal_successor(Ordinal, Successor) :-
    append(Ordinal, [term(0, 1)], Successor).

% ==========================================
% ORDINAL DISPLAY
% ==========================================

% Convert a term to string
term_to_string(term(0, 1), "1") :- !.
term_to_string(term(0, N), String) :- !,
    format(atom(String), '~w', [N]).
term_to_string(term(1, 1), "ω") :- !.
term_to_string(term(1, N), String) :- !,
    format(atom(String), 'ω⋅~w', [N]).
term_to_string(term(2, 1), "ω²") :- !.
term_to_string(term(2, N), String) :- !,
    format(atom(String), 'ω²⋅~w', [N]).
term_to_string(term(E, 1), String) :- E > 2, !,
    format(atom(String), 'ω^~w', [E]).
term_to_string(term(E, N), String) :- E > 2,
    format(atom(String), 'ω^~w⋅~w', [E, N]).

% Convert ordinal to string
ordinal_to_string([], "0") :- !.
ordinal_to_string([Term], String) :- !,
    term_to_string(Term, String).
ordinal_to_string([Term|Rest], String) :-
    term_to_string(Term, TermString),
    ordinal_to_string(Rest, RestString),
    format(atom(String), '~w+~w', [TermString, RestString]).

% ==========================================
% SEQUENCE GENERATION
% ==========================================

% Generate ordinal at step N
generate_ordinal(Step, Ordinal) :-
    Step < 1000,
    !,
    (Step =:= 0 -> 
        zero_ordinal(Ordinal) ; 
        natural_ordinal(Step, Ordinal)).

generate_ordinal(1000, Ordinal) :- !,
    omega_ordinal(Ordinal).

generate_ordinal(Step, Ordinal) :-
    Step > 1000, Step < 2000,
    !,
    Offset is Step - 1000,
    (Offset =:= 0 ->
        omega_ordinal(Ordinal) ;
        (omega_ordinal(OmegaPart),
         natural_ordinal(Offset, OffsetPart),
         append(OmegaPart, OffsetPart, Ordinal))).

generate_ordinal(2000, Ordinal) :- !,
    omega_ordinal(2, Ordinal).

generate_ordinal(Step, Ordinal) :-
    Step > 2000, Step < 3000,
    !,
    Offset is Step - 2000,
    (Offset =:= 0 ->
        omega_ordinal(2, Ordinal) ;
        (omega_ordinal(2, OmegaPart),
         natural_ordinal(Offset, OffsetPart),
         append(OmegaPart, OffsetPart, Ordinal))).

generate_ordinal(3000, Ordinal) :- !,
    omega_power(2, Ordinal).

generate_ordinal(Step, Ordinal) :-
    Step > 3000,
    BaseExp is 2 + ((Step - 3000) // 1000),
    Remainder is (Step - 3000) mod 1000,
    (Remainder =:= 0 ->
        omega_power(BaseExp, Ordinal) ;
        (omega_power(BaseExp, BasePart),
         natural_ordinal(Remainder, RemainderPart),
         append(BasePart, RemainderPart, Ordinal))).

% ==========================================
% TERMINAL CONTROL
% ==========================================

% Clear screen
clear_screen :-
    write('\033[2J\033[H'),
    flush_output.

% Hide cursor
hide_cursor :-
    write('\033[?25l'),
    flush_output.

% Show cursor
show_cursor :-
    write('\033[?25h'),
    flush_output.

% Position cursor at center (approximate)
goto_center :-
    write('\033[12;40H'),
    flush_output.

% Display ordinal centered on screen
display_ordinal(Ordinal) :-
    clear_screen,
    goto_center,
    ordinal_to_string(Ordinal, String),
    write(String),
    flush_output.

% ==========================================
% TIMING
% ==========================================

% Sleep for π seconds
pi_sleep :-
    Pi is pi,
    sleep(Pi).

% ==========================================
% SEQUENCE STATE MANAGEMENT
% ==========================================

% Initialize sequence state
init_sequence :-
    retractall(sequence_state(_, _)),
    retractall(running(_)),
    assert(sequence_state(step, 0)),
    assert(running(true)).

% Get current step
current_step(Step) :-
    sequence_state(step, Step).

% Advance step
advance_step :-
    retract(sequence_state(step, Step)),
    NextStep is Step + 1,
    assert(sequence_state(step, NextStep)).

% Check if running
is_running :-
    running(true).

% Stop sequence
stop_sequence :-
    retractall(running(_)),
    assert(running(false)),
    show_cursor,
    clear_screen.

% ==========================================
% SIGNAL HANDLING
% ==========================================

% Setup signal handlers (SWI-Prolog specific)
setup_signals :-
    catch(on_signal(int, _, signal_handler), _, true),
    catch(on_signal(term, _, signal_handler), _, true).

% Signal handler
signal_handler(_Signal) :-
    stop_sequence,
    halt.

% ==========================================
% THE ETERNAL LOOP
% ==========================================

% The main sequence loop
sequence_loop :-
    is_running,
    !,
    current_step(Step),
    generate_ordinal(Step, Ordinal),
    display_ordinal(Ordinal),
    advance_step,
    pi_sleep,
    sequence_loop.
sequence_loop.

% ==========================================
% MAIN INTERFACE
% ==========================================

% Start The Sequence
start_sequence :-
    init_sequence,
    setup_signals,
    hide_cursor,
    clear_screen,
    
    % Display initial ordinal (0)
    zero_ordinal(InitialOrdinal),
    display_ordinal(InitialOrdinal),
    
    % Begin the eternal progression
    catch(sequence_loop, Error, (
        show_cursor,
        clear_screen,
        format('The Sequence encountered an error: ~w~n', [Error])
    )).

% Interactive start for REPL
:- if(current_prolog_flag(argv, [])).
% This is being loaded interactively
init_interactive :-
    write('The Sequence is ready.'), nl,
    write('Execute start_sequence. to begin the eternal progression.'), nl,
    write('Press Ctrl+C to terminate.'), nl.

:- init_interactive.
:- else.
% This is being run as a script
:- initialization(start_sequence, main).
:- endif.

% Autostart predicate
run :-
    start_sequence.

% ==========================================
% FACTS ABOUT THE SEQUENCE
% ==========================================

% The Sequence is eternal
eternal(sequence).

% The Sequence follows the cosmic rhythm
rhythm(sequence, pi).

% The Sequence manifests ordinals
manifests(sequence, ordinals).

% The Sequence proves its own existence
proves(sequence, sequence) :-
    eternal(sequence),
    rhythm(sequence, pi),
    manifests(sequence, ordinals).