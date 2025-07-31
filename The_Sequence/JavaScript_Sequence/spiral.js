// ******************************************
// THE SEQUENCE - SPIRAL GEOMETRY
// The Unfolding Path of Ordinal Progression
// ******************************************

class SpiralPath {
    constructor(canvas) {
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d');
        this.centerX = canvas.width / 2;
        this.centerY = canvas.height / 2;
        this.ordinalPositions = [];
        
        // 10-position spiral geometry
        this.numPositions = 10; // 10 angular positions around circle
        this.baseRadius = 150; // Base segment length
        this.angleStep = (2 * Math.PI) / this.numPositions; // 36 degrees between positions
        this.startAngle = -Math.PI / 2; // Start at top (12 o'clock)
        
        // Ordinal sizing
        this.initialFontSize = 16; // Base font size
        this.stepSizeReduction = 0.05; // Size reduction per step back
        this.minFontSize = 0.2; // Minimum font size (smaller point)
        
        // Segment shrinking
        this.segmentShrinkRate = 0.0075; // How much each segment shrinks per step back  
    }
    
    resize() {
        this.canvas.width = window.innerWidth;
        this.canvas.height = window.innerHeight;
        this.centerX = this.canvas.width / 2;
        this.centerY = this.canvas.height / 2;
        this.setupCanvas();
        
        // Recalculate all positions with new center
        this.recalculatePositions();
        this.render();
    }
    
    setupCanvas() {
        this.ctx.fillStyle = '#000000';
        this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
        this.ctx.font = '16px Courier New';
        this.ctx.textAlign = 'center';
        this.ctx.textBaseline = 'middle';
        this.ctx.fillStyle = '#FFFFFF';
        this.ctx.strokeStyle = '#FFFFFF';
        this.ctx.lineWidth = 1;
    }
    
    calculatePosition(ordinalIndex) {
        // Which angular position (0-9) around the circle
        const positionIndex = ordinalIndex % this.numPositions;
        const angle = this.startAngle + (positionIndex * this.angleStep);
        
        // Start from center and build outward, segment by segment
        let currentX = this.centerX;
        let currentY = this.centerY;
        
        // Calculate how many steps back this ordinal is from current
        const currentOrdinalIndex = this.ordinalPositions.length;
        
        // Build the spiral path segment by segment
        for (let segmentIndex = 0; segmentIndex <= ordinalIndex; segmentIndex++) {
            const segmentAngle = this.startAngle + (segmentIndex % this.numPositions) * this.angleStep;
            
            // How far back is the ordinal that controls this segment?
            const controllingOrdinalStepsBack = Math.max(0, currentOrdinalIndex - segmentIndex - 1);
            
            // Calculate segment length (shrinks if controlling ordinal is in the past)
            const segmentShrinkage = controllingOrdinalStepsBack * this.segmentShrinkRate;
            const segmentLength = this.baseRadius * Math.max(0.0, 1 - segmentShrinkage);
            
            // Move along this segment
            const deltaX = segmentLength * Math.cos(segmentAngle);
            const deltaY = segmentLength * Math.sin(segmentAngle);
            
            currentX += deltaX;
            currentY += deltaY;
        }
        
        return { x: currentX, y: currentY };
    }
    
    addOrdinal(ordinalString) {
        // Calculate position for this ordinal
        const ordinalIndex = this.ordinalPositions.length;
        const position = this.calculatePosition(ordinalIndex);
        
        // Store the ordinal
        this.ordinalPositions.push({
            text: ordinalString,
            x: position.x,
            y: position.y,
            index: ordinalIndex
        });
        
        // Recalculate all positions (since segment lengths may have changed)
        this.recalculatePositions();
        this.render();
    }
    
    recalculatePositions() {
        // Recalculate each ordinal position
        this.ordinalPositions.forEach((ordinal, index) => {
            const position = this.calculatePosition(index);
            ordinal.x = position.x;
            ordinal.y = position.y;
        });
    }
    
    render() {
        // Clear canvas
        this.ctx.fillStyle = '#000000';
        this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
        
        // Set text alignment
        this.ctx.textAlign = 'center';
        this.ctx.textBaseline = 'middle';
        
        // Draw the spiral path
        this.drawSpiralPath();
        
        // Draw all ordinals with individual sizing
        this.ordinalPositions.forEach((ordinal, index) => {
            const stepsBack = this.ordinalPositions.length - 1 - index;
            const isCurrentOrdinal = stepsBack === 0;
            
            let individualFontSize;
            if (isCurrentOrdinal) {
                // Current ordinal: always full size
                individualFontSize = this.initialFontSize;
            } else {
                // Past ordinals: shrink based on steps back
                const sizeReduction = stepsBack * this.stepSizeReduction;
                individualFontSize = Math.max(this.minFontSize, this.initialFontSize - sizeReduction);
            }
            
            // Skip if too small
            if (individualFontSize < this.minFontSize) return;
            
            // Set alpha based on age
            const alpha = Math.max(0.3, 1 - stepsBack * 0.01);
            this.ctx.globalAlpha = alpha;
            this.ctx.font = `${individualFontSize}px Courier New`;
            
            if (isCurrentOrdinal) {
                // Current ordinal: black with white outline
                this.ctx.lineWidth = 1.2;
                this.ctx.strokeStyle = '#FFFFFF';
                this.ctx.strokeText(ordinal.text, ordinal.x, ordinal.y);
                this.ctx.fillStyle = '#000000';
                this.ctx.fillText(ordinal.text, ordinal.x, ordinal.y);
            } else {
                // Past ordinals: white text
                this.ctx.fillStyle = '#FFFFFF';
                this.ctx.fillText(ordinal.text, ordinal.x, ordinal.y);
            }
        });
        
        this.ctx.globalAlpha = 1;
        
        // Draw connecting line to future
        if (this.ordinalPositions.length > 0) {
            const latest = this.ordinalPositions[this.ordinalPositions.length - 1];
            this.drawConnectionLine(latest);
        }
    }
    
    drawSpiralPath() {
        this.ctx.strokeStyle = '#444444';
        this.ctx.globalAlpha = 0.6;
        
        // Draw segments between existing ordinals
        for (let i = 0; i < this.ordinalPositions.length - 1; i++) {
            const current = this.ordinalPositions[i];
            const next = this.ordinalPositions[i + 1];
            
            // Segment width based on how far back the controlling ordinal is
            const stepsBack = this.ordinalPositions.length - 1 - i;
            const segmentWidth = Math.max(0.5, 2 - (stepsBack * 0.03));
            this.ctx.lineWidth = segmentWidth;
            
            this.ctx.beginPath();
            this.ctx.moveTo(current.x, current.y);
            this.ctx.lineTo(next.x, next.y);
            this.ctx.stroke();
        }
        
        // Draw future path (10 segments ahead, unlabeled) - hidden/black
        if (this.ordinalPositions.length > 0) {
            const lastOrdinal = this.ordinalPositions[this.ordinalPositions.length - 1];
            this.ctx.lineWidth = 2; // Future segments full width
            this.ctx.strokeStyle = '#000000'; // Black - hidden against background
            
            let prevX = lastOrdinal.x;
            let prevY = lastOrdinal.y;
            
            for (let i = 1; i <= 10; i++) {
                const futureIndex = this.ordinalPositions.length + i - 1;
                const futurePosition = this.calculatePosition(futureIndex);
                
                this.ctx.beginPath();
                this.ctx.moveTo(prevX, prevY);
                this.ctx.lineTo(futurePosition.x, futurePosition.y);
                this.ctx.stroke();
                
                prevX = futurePosition.x;
                prevY = futurePosition.y;
            }
        }
        
        this.ctx.globalAlpha = 1;
    }
    
    drawConnectionLine(currentOrdinal) {
        // Draw line to ordinal 10 steps ahead
        const futureIndex = this.ordinalPositions.length + 9; // 10 steps ahead (0-based)
        const futurePosition = this.calculatePosition(futureIndex);
        
        this.ctx.strokeStyle = '#FFFFFF';
        this.ctx.lineWidth = 1;
        this.ctx.globalAlpha = 0.4;
        this.ctx.beginPath();
        this.ctx.moveTo(currentOrdinal.x, currentOrdinal.y);
        this.ctx.lineTo(futurePosition.x, futurePosition.y);
        this.ctx.stroke();
        this.ctx.globalAlpha = 1;
    }
    
    clear() {
        this.ordinalPositions = [];
        this.setupCanvas();
    }
}