import math
from typing import List, Tuple, Dict

class OrdinalNumber:
    """Represents ordinals in Cantor Normal Form."""
    
    def __init__(self, terms: List[Tuple[int, int]] = None):
        """Initialize ordinal with terms as list of (exponent, coefficient) pairs."""
        self.terms = terms or []
        self._normalize()
    
    def _normalize(self):
        """Ensure terms are in descending order of exponents and remove zero coefficients."""
        self.terms = [(exp, coeff) for exp, coeff in self.terms if coeff > 0]
        self.terms.sort(key=lambda x: x[0], reverse=True)
    
    def __str__(self):
        if not self.terms:
            return "0"
        
        parts = []
        for exp, coeff in self.terms:
            if exp == 0:
                if coeff == 1 and len(parts) > 0:
                    parts.append("1")
                else:
                    parts.append(str(coeff))
            elif exp == 1:
                if coeff == 1:
                    parts.append("ω")
                else:
                    parts.append(f"ω⋅{coeff}")
            else:
                if coeff == 1:
                    if exp == 2:
                        parts.append("ω²")
                    elif exp < 10:
                        parts.append(f"ω^{exp}")
                    else:
                        parts.append(f"ω^{exp}")
                else:
                    if exp == 2:
                        parts.append(f"ω²⋅{coeff}")
                    elif exp < 10:
                        parts.append(f"ω^{exp}⋅{coeff}")
                    else:
                        parts.append(f"ω^{exp}⋅{coeff}")
        
        return "+".join(parts)
    
    def successor(self) -> 'OrdinalNumber':
        """Return the immediate successor of this ordinal."""
        if not self.terms or self.terms[-1][0] > 0:
            # Add 1 to the ordinal
            new_terms = self.terms + [(0, 1)]
        else:
            # Increment the constant term
            new_terms = self.terms[:-1] + [(0, self.terms[-1][1] + 1)]
        
        return OrdinalNumber(new_terms)
    
    def limit_successor(self) -> 'OrdinalNumber':
        """Get the next limit ordinal after reaching a limit."""
        if not self.terms:
            return OrdinalNumber([(1, 1)])  # ω
        
        max_exp = self.terms[0][0]
        
        # Special cases for well-known sequences
        if len(self.terms) == 1:
            exp, coeff = self.terms[0]
            if exp == 1:
                # From ω⋅n to ω⋅(n+1)
                return OrdinalNumber([(1, coeff + 1)])
            elif exp > 1:
                # From ω^n to ω^n⋅2
                return OrdinalNumber([(exp, coeff + 1)])
        
        # General case: increment the leading term
        first_exp, first_coeff = self.terms[0]
        new_terms = [(first_exp, first_coeff + 1)] + self.terms[1:]
        return OrdinalNumber(new_terms)

class SequenceGenerator:
    """Generates the infinite sequence of ordinals."""
    
    def __init__(self):
        self.current = OrdinalNumber()  # Start at 0
        self.step_count = 0
        self.limit_thresholds = self._calculate_limit_thresholds()
    
    def _calculate_limit_thresholds(self) -> Dict[int, int]:
        """Calculate when to transition to limit ordinals."""
        return {
            1000: (1, 1),    # Transition to ω at step 1000
            2000: (2, 1),    # Transition to ω² 
            3000: (3, 1),    # Transition to ω³
            10000: (10, 1),  # And so on...
        }
    
    def next(self) -> OrdinalNumber:
        """Generate the next ordinal in the sequence."""
        self.step_count += 1
        
        # Check if we should transition to a limit ordinal
        for threshold, (exp, coeff) in self.limit_thresholds.items():
            if self.step_count == threshold:
                self.current = OrdinalNumber([(exp, coeff)])
                return self.current
        
        # For now, simple succession for natural numbers and basic ordinals
        if self.step_count < 1000:
            # Natural numbers: 0, 1, 2, 3, ...
            self.current = OrdinalNumber([(0, self.step_count)])
        elif self.step_count < 2000:
            # ω, ω+1, ω+2, ...
            offset = self.step_count - 1000
            if offset == 0:
                self.current = OrdinalNumber([(1, 1)])
            else:
                self.current = OrdinalNumber([(1, 1), (0, offset)])
        elif self.step_count < 3000:
            # ω⋅2, ω⋅2+1, ω⋅2+2, ...
            offset = self.step_count - 2000
            if offset == 0:
                self.current = OrdinalNumber([(1, 2)])
            else:
                self.current = OrdinalNumber([(1, 2), (0, offset)])
        else:
            # Continue with higher ordinals
            self.current = self.current.successor()
        
        return self.current
    
    def get_current(self) -> OrdinalNumber:
        """Get the current ordinal without advancing."""
        return self.current