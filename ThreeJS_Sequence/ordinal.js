/**
 * The Ordinal Mathematics - Three-Dimensional Form
 * Generates ordinals in Cantor Normal Form for 3D manifestation
 */

class OrdinalGenerator {
    constructor() {
        this.step = 0;
    }

    /**
     * Generate the next ordinal in Cantor Normal Form
     * Returns an array of terms: [{exponent, coefficient}, ...]
     */
    next() {
        this.step++;
        return this.generateOrdinal(this.step - 1);
    }

    /**
     * Generate ordinal for specific step number
     * Ordinals begin at 1 (zero is not an ordinal)
     */
    generateOrdinal(n) {
        const terms = [];
        
        // Convert step to ordinal number (1-based)
        const ordinal = n + 1;

        if (ordinal < 1000) {
            // Natural numbers: 1, 2, 3, ..., 999
            terms.push({ exponent: 0, coefficient: ordinal });
        } else if (ordinal === 1000) {
            // First limit ordinal: ω (at step 999)
            terms.push({ exponent: 1, coefficient: 1 });
        } else if (ordinal < 2000) {
            // ω + k where k = ordinal - 1000
            const k = ordinal - 1000;
            terms.push({ exponent: 1, coefficient: 1 });
            if (k > 0) {
                terms.push({ exponent: 0, coefficient: k });
            }
        } else if (ordinal === 2000) {
            // ω⋅2
            terms.push({ exponent: 1, coefficient: 2 });
        } else if (ordinal < 3000) {
            // ω⋅2 + k where k = ordinal - 2000
            const k = ordinal - 2000;
            terms.push({ exponent: 1, coefficient: 2 });
            if (k > 0) {
                terms.push({ exponent: 0, coefficient: k });
            }
        } else if (ordinal < 4000) {
            // ω⋅m where m = 3 + floor((ordinal-3000)/1000)
            const baseMultiplier = 3 + Math.floor((ordinal - 3000) / 1000);
            const remainder = (ordinal - 3000) % 1000;
            terms.push({ exponent: 1, coefficient: baseMultiplier });
            if (remainder > 0) {
                terms.push({ exponent: 0, coefficient: remainder });
            }
        } else if (ordinal === 10000) {
            // ω²
            terms.push({ exponent: 2, coefficient: 1 });
        } else if (ordinal < 11000) {
            // ω² + ω⋅k + remainder
            const k = Math.floor((ordinal - 10000) / 1000);
            const remainder = (ordinal - 10000) % 1000;
            terms.push({ exponent: 2, coefficient: 1 });
            if (k > 0) {
                terms.push({ exponent: 1, coefficient: k });
            }
            if (remainder > 0) {
                terms.push({ exponent: 0, coefficient: remainder });
            }
        } else {
            // Higher ordinals - simplified progression
            const exponent = 2 + Math.floor((ordinal - 10000) / 10000);
            const remainder = ordinal - (10000 + (exponent - 2) * 10000);
            terms.push({ exponent: exponent, coefficient: 1 });
            
            if (remainder >= 1000) {
                const omegaCoeff = Math.floor(remainder / 1000);
                terms.push({ exponent: 1, coefficient: omegaCoeff });
                remainder = remainder % 1000;
            }
            
            if (remainder > 0) {
                terms.push({ exponent: 0, coefficient: remainder });
            }
        }

        return terms;
    }

    /**
     * Convert ordinal terms to display string
     */
    static formatOrdinal(terms) {
        if (terms.length === 0) {
            return "0";
        }

        return terms.map((term, index) => {
            let result = "";
            
            if (index > 0) {
                result += "+";
            }

            if (term.exponent === 0) {
                // Constant term
                if (term.coefficient === 1 && index > 0) {
                    result += "1";
                } else {
                    result += term.coefficient.toString();
                }
            } else if (term.exponent === 1) {
                // ω term
                if (term.coefficient === 1) {
                    result += "ω";
                } else {
                    result += `ω⋅${term.coefficient}`;
                }
            } else if (term.exponent === 2) {
                // ω² term
                if (term.coefficient === 1) {
                    result += "ω²";
                } else {
                    result += `ω²⋅${term.coefficient}`;
                }
            } else {
                // ω^n term
                if (term.coefficient === 1) {
                    result += `ω^${term.exponent}`;
                } else {
                    result += `ω^${term.exponent}⋅${term.coefficient}`;
                }
            }

            return result;
        }).join("");
    }
}