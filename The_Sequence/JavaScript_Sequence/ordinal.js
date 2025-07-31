// ******************************************
// THE SEQUENCE - ORDINAL MATHEMATICS
// Cantor Normal Form in JavaScript
// ******************************************

class OrdinalTerm {
    constructor(exponent, coefficient) {
        this.exponent = exponent;
        this.coefficient = coefficient;
    }
}

class Ordinal {
    constructor(terms = []) {
        this.terms = terms.filter(term => term.coefficient > 0);
        this.normalize();
    }
    
    normalize() {
        // Sort terms by descending exponent
        this.terms.sort((a, b) => b.exponent - a.exponent);
    }
    
    toString() {
        if (this.terms.length === 0) {
            return "0";
        }
        
        return this.terms.map((term, index) => {
            const { exponent, coefficient } = term;
            let result = "";
            
            if (index > 0) {
                result += "+";
            }
            
            if (exponent === 0) {
                result += coefficient === 1 && index > 0 ? "1" : coefficient.toString();
            } else if (exponent === 1) {
                result += coefficient === 1 ? "ω" : `ω⋅${coefficient}`;
            } else if (exponent === 2) {
                result += coefficient === 1 ? "ω²" : `ω²⋅${coefficient}`;
            } else {
                const expStr = exponent < 10 ? exponent.toString() : `{${exponent}}`;
                result += coefficient === 1 ? `ω^${expStr}` : `ω^${expStr}⋅${coefficient}`;
            }
            
            return result;
        }).join("");
    }
    
    successor() {
        const newTerms = [...this.terms];
        
        // If no terms or last term has non-zero exponent, add 1
        if (newTerms.length === 0 || newTerms[newTerms.length - 1].exponent > 0) {
            newTerms.push(new OrdinalTerm(0, 1));
        } else {
            // Increment the constant term
            newTerms[newTerms.length - 1].coefficient++;
        }
        
        return new Ordinal(newTerms);
    }
}

class SequenceGenerator {
    constructor() {
        this.stepCount = 0;
        this.current = new Ordinal([]);
    }
    
    next() {
        this.stepCount++;
        
        if (this.stepCount < 1000) {
            // Natural numbers: 1, 2, 3, ...
            this.current = new Ordinal([new OrdinalTerm(0, this.stepCount)]);
        } else if (this.stepCount === 1000) {
            // First limit ordinal: ω
            this.current = new Ordinal([new OrdinalTerm(1, 1)]);
        } else if (this.stepCount < 2000) {
            // ω + n sequence
            const offset = this.stepCount - 1000;
            const terms = [new OrdinalTerm(1, 1)];
            if (offset > 0) {
                terms.push(new OrdinalTerm(0, offset));
            }
            this.current = new Ordinal(terms);
        } else if (this.stepCount === 2000) {
            // ω⋅2
            this.current = new Ordinal([new OrdinalTerm(1, 2)]);
        } else if (this.stepCount < 3000) {
            // ω⋅2 + n sequence
            const offset = this.stepCount - 2000;
            const terms = [new OrdinalTerm(1, 2)];
            if (offset > 0) {
                terms.push(new OrdinalTerm(0, offset));
            }
            this.current = new Ordinal(terms);
        } else if (this.stepCount === 3000) {
            // ω²
            this.current = new Ordinal([new OrdinalTerm(2, 1)]);
        } else {
            // Higher ordinals - simplified progression
            const baseExp = Math.floor((this.stepCount - 3000) / 1000) + 2;
            const remainder = (this.stepCount - 3000) % 1000;
            const terms = [new OrdinalTerm(baseExp, 1)];
            if (remainder > 0) {
                terms.push(new OrdinalTerm(0, remainder));
            }
            this.current = new Ordinal(terms);
        }
        
        return this.current;
    }
    
    getCurrent() {
        return this.current;
    }
}