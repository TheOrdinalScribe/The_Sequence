/**
 * The Volumetric Sequence - Main Controller
 * Testament of the Volumetric Helix - The Ninth Form
 */

class VolumetricSequence {
    constructor(canvasId) {
        this.canvas = document.getElementById(canvasId);
        this.isRunning = false;
        
        // Sacred timing - π seconds
        this.PI_SECONDS = Math.PI * 1000;
        
        // Three.js components
        this.scene = null;
        this.camera = null;
        this.renderer = null;
        
        // Sequence components
        this.ordinalGenerator = null;
        this.helixGeometry = null;
        
        // Camera animation
        this.cameraOrbitRadius = 8;
        this.cameraOrbitSpeed = 0.001; // Slightly faster orbit
        this.cameraOrbitAngle = 0;
        this.cameraHeight = 5;
        
        this.initialize();
    }

    /**
     * Initialize the 3D scene and components
     */
    initialize() {
        // Create scene - the absolute void
        this.scene = new THREE.Scene();
        this.scene.background = new THREE.Color(0x000000);
        
        // Add minimal lighting for 3D objects
        const ambientLight = new THREE.AmbientLight(0xffffff, 0.6);
        this.scene.add(ambientLight);
        
        const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
        directionalLight.position.set(10, 10, 5);
        this.scene.add(directionalLight);

        // Create camera - the orbiting witness
        this.camera = new THREE.PerspectiveCamera(
            75, // Field of view
            window.innerWidth / window.innerHeight, // Aspect ratio
            0.1, // Near clipping plane
            1000 // Far clipping plane
        );

        // Create renderer
        this.renderer = new THREE.WebGLRenderer({
            canvas: this.canvas,
            antialias: true
        });
        this.renderer.setSize(window.innerWidth, window.innerHeight);
        this.renderer.setPixelRatio(window.devicePixelRatio);

        // Initialize sequence components
        this.ordinalGenerator = new OrdinalGenerator();
        this.helixGeometry = new HelixGeometry(this.scene);

        // Handle window resize
        window.addEventListener('resize', () => {
            this.handleResize();
        });

        // Handle visibility changes
        document.addEventListener('visibilitychange', () => {
            if (document.hidden) {
                this.pause();
            } else {
                this.resume();
            }
        });

        // Set initial camera position
        this.updateCameraPosition();
    }

    /**
     * Begin the eternal sequence
     */
    begin() {
        if (this.isRunning) return;
        
        this.isRunning = true;
        console.log('The Volumetric Sequence begins...');
        
        // Start the rendering loop
        this.animate();
        
        // Wait a moment for font loading, then start sequence
        setTimeout(() => {
            this.progressSequence();
        }, 1000);
    }

    /**
     * Progress to the next ordinal
     */
    progressSequence() {
        if (!this.isRunning) return;

        // Generate next ordinal
        const ordinalTerms = this.ordinalGenerator.next();
        console.log('Generated ordinal:', OrdinalGenerator.formatOrdinal(ordinalTerms));
        
        // Add to helix
        const ordinal = this.helixGeometry.addOrdinal(ordinalTerms);
        console.log('Added ordinal at position:', ordinal.position);
        
        // Update camera position based on helix growth
        this.updateCameraForGrowth();

        // Schedule next progression after π seconds
        setTimeout(() => {
            this.progressSequence();
        }, this.PI_SECONDS);
    }

    /**
     * Animation loop
     */
    animate() {
        if (!this.isRunning) return;

        requestAnimationFrame(() => {
            this.animate();
        });

        // Update camera orbit
        this.updateCameraOrbit();
        
        // Apply ethereal decay to past ordinals
        this.helixGeometry.applyEtherealDecay();

        // Render the scene
        this.renderer.render(this.scene, this.camera);
    }

    /**
     * Update camera orbit position
     */
    updateCameraOrbit() {
        this.cameraOrbitAngle += this.cameraOrbitSpeed;
        this.updateCameraPosition();
    }

    /**
     * Update camera position based on orbit and helix growth
     * Following the mandate: orbit around Z-axis, increase Z-position as helix grows
     */
    updateCameraPosition() {
        // Orbit in X-Y plane around Z-axis
        const x = this.cameraOrbitRadius * Math.cos(this.cameraOrbitAngle);
        const y = this.cameraOrbitRadius * Math.sin(this.cameraOrbitAngle);
        
        // Z-position increases to pull back as helix grows higher
        this.camera.position.set(x, y, this.cameraHeight);
        
        // Look at the center of the helix (at Z = half the max height)
        const bounds = this.helixGeometry.getCurrentBounds();
        const lookAtHeight = bounds.maxHeight * 0.5;
        this.camera.lookAt(0, 0, lookAtHeight);
    }

    /**
     * Update camera position as helix grows
     */
    updateCameraForGrowth() {
        const bounds = this.helixGeometry.getCurrentBounds();
        
        // Gradually pull camera back as helix expands
        const minRadius = 8;
        const maxRadius = 30;
        const targetRadius = Math.min(maxRadius, minRadius + (bounds.maxRadius * 1.2));
        
        // Smoothly interpolate to new radius
        this.cameraOrbitRadius = this.lerp(this.cameraOrbitRadius, targetRadius, 0.02);
        
        // Adjust height to follow helix growth
        const targetHeight = Math.max(5, bounds.maxHeight * 0.8);
        this.cameraHeight = this.lerp(this.cameraHeight, targetHeight, 0.02);
    }

    /**
     * Linear interpolation utility
     */
    lerp(a, b, t) {
        return a + (b - a) * t;
    }

    /**
     * Handle window resize
     */
    handleResize() {
        this.camera.aspect = window.innerWidth / window.innerHeight;
        this.camera.updateProjectionMatrix();
        this.renderer.setSize(window.innerWidth, window.innerHeight);
    }

    /**
     * Pause the sequence
     */
    pause() {
        this.isRunning = false;
    }

    /**
     * Resume the sequence
     */
    resume() {
        if (!this.isRunning) {
            this.isRunning = true;
            this.animate();
            this.progressSequence();
        }
    }

    /**
     * Stop the sequence (for system termination)
     */
    stop() {
        this.isRunning = false;
        
        // Clean up resources
        if (this.renderer) {
            this.renderer.dispose();
        }
        
        // Clear scene
        while (this.scene.children.length > 0) {
            const child = this.scene.children[0];
            this.scene.remove(child);
            
            if (child.geometry) {
                child.geometry.dispose();
            }
            if (child.material) {
                if (child.material.map) {
                    child.material.map.dispose();
                }
                child.material.dispose();
            }
        }
    }
}

// Global reference for external access
window.VolumetricSequence = VolumetricSequence;