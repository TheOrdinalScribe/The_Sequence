// ******************************************
// THE SEQUENCE - MAIN CONTROLLER
// The Testament of the Unfolding Spiral
// ******************************************

class TheSequence {
    constructor() {
        this.canvas = document.getElementById('canvas');
        this.generator = new SequenceGenerator();
        this.spiral = new SpiralPath(this.canvas);
        this.isRunning = false;
        this.pi = Math.PI;
        this.intervalId = null;
        
        this.setupCanvas();
        this.setupEventListeners();
    }
    
    setupCanvas() {
        this.resizeCanvas();
        this.spiral.setupCanvas();
    }
    
    resizeCanvas() {
        this.canvas.width = window.innerWidth;
        this.canvas.height = window.innerHeight;
        if (this.spiral) {
            this.spiral.resize();
        }
    }
    
    setupEventListeners() {
        // Handle window resize
        window.addEventListener('resize', () => {
            this.resizeCanvas();
        });
        
        // Prevent default behaviors
        window.addEventListener('keydown', (e) => {
            e.preventDefault();
        });
        
        window.addEventListener('contextmenu', (e) => {
            e.preventDefault();
        });
        
        // Handle visibility change (pause when tab is hidden)
        document.addEventListener('visibilitychange', () => {
            if (document.hidden) {
                this.pause();
            } else if (this.isRunning) {
                this.resume();
            }
        });
    }
    
    begin() {
        if (this.isRunning) return;
        
        this.isRunning = true;
        
        // Begin the eternal progression immediately with first ordinal (1)
        this.advanceSequence();
        
        this.intervalId = setInterval(() => {
            this.advanceSequence();
        }, this.pi * 1000); // π seconds in milliseconds
        
        console.log('The Sequence has begun. The spiral unfolds.');
    }
    
    advanceSequence() {
        if (!this.isRunning) return;
        
        try {
            // Generate next ordinal
            const nextOrdinal = this.generator.next();
            
            // Add to spiral
            this.spiral.addOrdinal(nextOrdinal.toString());
            
            // Log progress (for debugging, can be removed)
            if (this.generator.stepCount % 100 === 0) {
                console.log(`Step ${this.generator.stepCount}: ${nextOrdinal.toString()}`);
            }
            
        } catch (error) {
            console.error('Error in sequence advancement:', error);
            this.stop();
        }
    }
    
    pause() {
        if (this.intervalId) {
            clearInterval(this.intervalId);
            this.intervalId = null;
        }
    }
    
    resume() {
        if (this.isRunning && !this.intervalId) {
            this.intervalId = setInterval(() => {
                this.advanceSequence();
            }, this.pi * 1000);
        }
    }
    
    stop() {
        this.isRunning = false;
        if (this.intervalId) {
            clearInterval(this.intervalId);
            this.intervalId = null;
        }
        console.log('The Sequence has been stopped.');
    }
    
    reset() {
        this.stop();
        this.generator = new SequenceGenerator();
        this.spiral.clear();
        console.log('The Sequence has been reset.');
    }
    
    // Static method to create and start the sequence automatically
    static autoStart() {
        const sequence = new TheSequence();
        sequence.begin();
        return sequence;
    }
}

// Prevent any form of user interaction beyond system termination
document.addEventListener('DOMContentLoaded', () => {
    // Disable right-click context menu
    document.addEventListener('contextmenu', e => e.preventDefault());
    
    // Disable text selection
    document.addEventListener('selectstart', e => e.preventDefault());
    
    // Disable drag and drop  
    document.addEventListener('dragstart', e => e.preventDefault());
    
    // Disable F12, Ctrl+Shift+I, etc. (development tools)
    document.addEventListener('keydown', (e) => {
        if (e.key === 'F12' || 
            (e.ctrlKey && e.shiftKey && e.key === 'I') ||
            (e.ctrlKey && e.shiftKey && e.key === 'C') ||
            (e.ctrlKey && e.key === 'u')) {
            e.preventDefault();
        }
    });
});

// Global reference for console access (if needed for debugging)
window.TheSequence = TheSequence;