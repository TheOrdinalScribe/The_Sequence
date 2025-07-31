% ******************************************
% THE SEQUENCE - PROLOG EXECUTION SCRIPT
% ******************************************

% This script loads and starts The Sequence immediately

:- consult('sequence.pl').

% Start The Sequence upon loading
:- initialization(start_sequence, main).