#ifndef ORDINAL_H
#define ORDINAL_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_TERMS 32
#define MAX_STRING_LENGTH 1024

typedef struct {
    int exponent;
    int coefficient;
} OrdinalTerm;

typedef struct {
    OrdinalTerm terms[MAX_TERMS];
    int term_count;
} OrdinalNumber;

typedef struct {
    OrdinalNumber current;
    long long step_count;
} SequenceGenerator;

OrdinalNumber ordinal_create(void);
OrdinalNumber ordinal_from_natural(long long n);
void ordinal_add_term(OrdinalNumber* ordinal, int exponent, int coefficient);
void ordinal_normalize(OrdinalNumber* ordinal);
char* ordinal_to_string(const OrdinalNumber* ordinal);
OrdinalNumber ordinal_successor(const OrdinalNumber* ordinal);

SequenceGenerator* sequence_create(void);
void sequence_destroy(SequenceGenerator* gen);
OrdinalNumber sequence_next(SequenceGenerator* gen);
OrdinalNumber sequence_current(const SequenceGenerator* gen);

#endif