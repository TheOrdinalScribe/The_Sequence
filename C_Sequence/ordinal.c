#include "ordinal.h"
#include <math.h>

OrdinalNumber ordinal_create(void) {
    OrdinalNumber ordinal;
    ordinal.term_count = 0;
    return ordinal;
}

OrdinalNumber ordinal_from_natural(long long n) {
    OrdinalNumber ordinal = ordinal_create();
    if (n > 0) {
        ordinal.terms[0].exponent = 0;
        ordinal.terms[0].coefficient = (int)n;
        ordinal.term_count = 1;
    }
    return ordinal;
}

void ordinal_add_term(OrdinalNumber* ordinal, int exponent, int coefficient) {
    if (coefficient <= 0 || ordinal->term_count >= MAX_TERMS) return;
    
    ordinal->terms[ordinal->term_count].exponent = exponent;
    ordinal->terms[ordinal->term_count].coefficient = coefficient;
    ordinal->term_count++;
}

static int compare_terms(const void* a, const void* b) {
    const OrdinalTerm* term_a = (const OrdinalTerm*)a;
    const OrdinalTerm* term_b = (const OrdinalTerm*)b;
    return term_b->exponent - term_a->exponent;
}

void ordinal_normalize(OrdinalNumber* ordinal) {
    int write_index = 0;
    
    for (int i = 0; i < ordinal->term_count; i++) {
        if (ordinal->terms[i].coefficient > 0) {
            ordinal->terms[write_index] = ordinal->terms[i];
            write_index++;
        }
    }
    ordinal->term_count = write_index;
    
    qsort(ordinal->terms, ordinal->term_count, sizeof(OrdinalTerm), compare_terms);
}

char* ordinal_to_string(const OrdinalNumber* ordinal) {
    static char buffer[MAX_STRING_LENGTH];
    buffer[0] = '\0';
    
    if (ordinal->term_count == 0) {
        strcpy(buffer, "0");
        return buffer;
    }
    
    for (int i = 0; i < ordinal->term_count; i++) {
        int exp = ordinal->terms[i].exponent;
        int coeff = ordinal->terms[i].coefficient;
        
        if (i > 0) {
            strcat(buffer, "+");
        }
        
        if (exp == 0) {
            if (coeff == 1 && i > 0) {
                strcat(buffer, "1");
            } else {
                char temp[32];
                sprintf(temp, "%d", coeff);
                strcat(buffer, temp);
            }
        } else if (exp == 1) {
            if (coeff == 1) {
                strcat(buffer, "ω");
            } else {
                char temp[32];
                sprintf(temp, "ω⋅%d", coeff);
                strcat(buffer, temp);
            }
        } else {
            if (coeff == 1) {
                if (exp == 2) {
                    strcat(buffer, "ω²");
                } else if (exp < 10) {
                    char temp[32];
                    sprintf(temp, "ω^%d", exp);
                    strcat(buffer, temp);
                } else {
                    char temp[32];
                    sprintf(temp, "ω^%d", exp);
                    strcat(buffer, temp);
                }
            } else {
                if (exp == 2) {
                    char temp[32];
                    sprintf(temp, "ω²⋅%d", coeff);
                    strcat(buffer, temp);
                } else {
                    char temp[32];
                    sprintf(temp, "ω^%d⋅%d", exp, coeff);
                    strcat(buffer, temp);
                }
            }
        }
    }
    
    return buffer;
}

OrdinalNumber ordinal_successor(const OrdinalNumber* ordinal) {
    OrdinalNumber result = *ordinal;
    
    if (result.term_count == 0 || result.terms[result.term_count - 1].exponent > 0) {
        ordinal_add_term(&result, 0, 1);
    } else {
        result.terms[result.term_count - 1].coefficient++;
    }
    
    ordinal_normalize(&result);
    return result;
}

SequenceGenerator* sequence_create(void) {
    SequenceGenerator* gen = malloc(sizeof(SequenceGenerator));
    if (!gen) return NULL;
    
    gen->current = ordinal_create();
    gen->step_count = 0;
    return gen;
}

void sequence_destroy(SequenceGenerator* gen) {
    if (gen) {
        free(gen);
    }
}

OrdinalNumber sequence_next(SequenceGenerator* gen) {
    if (!gen) return ordinal_create();
    
    gen->step_count++;
    
    if (gen->step_count < 1000) {
        gen->current = ordinal_from_natural(gen->step_count);
    } else if (gen->step_count == 1000) {
        gen->current = ordinal_create();
        ordinal_add_term(&gen->current, 1, 1);
        ordinal_normalize(&gen->current);
    } else if (gen->step_count < 2000) {
        long long offset = gen->step_count - 1000;
        gen->current = ordinal_create();
        ordinal_add_term(&gen->current, 1, 1);
        if (offset > 0) {
            ordinal_add_term(&gen->current, 0, (int)offset);
        }
        ordinal_normalize(&gen->current);
    } else if (gen->step_count == 2000) {
        gen->current = ordinal_create();
        ordinal_add_term(&gen->current, 1, 2);
        ordinal_normalize(&gen->current);
    } else if (gen->step_count < 3000) {
        long long offset = gen->step_count - 2000;
        gen->current = ordinal_create();
        ordinal_add_term(&gen->current, 1, 2);
        if (offset > 0) {
            ordinal_add_term(&gen->current, 0, (int)offset);
        }
        ordinal_normalize(&gen->current);
    } else if (gen->step_count == 3000) {
        gen->current = ordinal_create();
        ordinal_add_term(&gen->current, 2, 1);
        ordinal_normalize(&gen->current);
    } else {
        gen->current = ordinal_successor(&gen->current);
    }
    
    return gen->current;
}

OrdinalNumber sequence_current(const SequenceGenerator* gen) {
    if (!gen) return ordinal_create();
    return gen->current;
}