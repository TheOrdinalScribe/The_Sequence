/**
 * The Helical Geometry - Three-Dimensional Sacred Architecture
 * Manages the volumetric helix path and 3D ordinal objects
 */

class HelixGeometry {
    constructor(scene) {
        this.scene = scene;
        this.ordinals = [];
        this.currentIndex = 0;
        
        // Sacred constants - true helical geometry
        this.helixRadius = 3; // Constant radius for all rings
        this.radiusGrowthRate = 0; // No radius growth - pure helix
        this.ascentRate = 0.2; // Vertical spacing between ordinals
        this.PHI = (1 + Math.sqrt(5)) / 2; // Golden ratio φ ≈ 1.618
        
        // Font loading for 3D text
        this.fontLoader = null;
        this.font = null;
        this.initializeFontLoader();
        
        // Helical path visualization
        this.pathPoints = [];
        this.pathGeometry = null;
        this.pathLine = null;
        this.createHelicalPath();
    }

    /**
     * Initialize font loader if available
     */
    async initializeFontLoader() {
        // For now, always use sprite fallback since FontLoader requires separate import
        console.log('Using sprite rendering for ordinals');
        this.font = null;
        this.fontLoader = null;
    }

    /**
     * Load font for 3D text geometry
     */
    async loadFont() {
        if (!this.fontLoader) return;
        
        try {
            // Use a web-safe font URL
            const fontUrl = 'https://threejs.org/examples/fonts/helvetiker_regular.typeface.json';
            this.font = await new Promise((resolve, reject) => {
                this.fontLoader.load(
                    fontUrl, 
                    resolve, 
                    undefined, 
                    (error) => {
                        console.warn('Font loading failed:', error);
                        reject(error);
                    }
                );
            });
            console.log('Font loaded successfully');
        } catch (error) {
            console.warn('Font loading failed, using sprite fallback:', error);
            this.font = null;
        }
    }

    /**
     * Calculate true helical position for ordinal n
     * Pure helix: constant radius, regular angular increment, linear ascent
     * Ordinals begin at 1 (zero is not an ordinal)
     * r = constant helixRadius
     * θ = n * (2 * PI / 10) - 10 ordinals per complete ring
     * z = n * ascentRate - linear vertical progression
     */
    calculatePosition(n) {
        // True helix: constant radius for all ordinals (starting from 1)
        const radius = this.helixRadius;
        const angle = n * (2 * Math.PI / 10); // 36 degrees per step
        const ascent = n * this.ascentRate;

        return {
            x: radius * Math.cos(angle),
            y: radius * Math.sin(angle),
            z: ascent
        };
    }

    /**
     * Create 3D ordinal object
     */
    createOrdinal(ordinalText, position, isPresent = false) {
        let mesh;

        if (this.font) {
            // Use 3D text geometry if font is loaded
            mesh = this.create3DText(ordinalText, position, isPresent);
        } else {
            // Fallback to sprite
            mesh = this.createSprite(ordinalText, position, isPresent);
        }

        // Set initial properties
        mesh.userData = {
            isPresent: isPresent,
            birthTime: Date.now(),
            originalScale: mesh.scale.clone(),
            age: 0
        };

        return mesh;
    }

    /**
     * Create 3D text geometry ordinal
     */
    create3DText(text, position, isPresent) {
        const textGeometry = new THREE.TextGeometry(text, {
            font: this.font,
            size: isPresent ? 0.5 : 0.3,
            height: 0.1,
            curveSegments: 12,
            bevelEnabled: false
        });

        textGeometry.computeBoundingBox();
        const centerOffsetX = -0.5 * (textGeometry.boundingBox.max.x - textGeometry.boundingBox.min.x);
        const centerOffsetY = -0.5 * (textGeometry.boundingBox.max.y - textGeometry.boundingBox.min.y);
        textGeometry.translate(centerOffsetX, centerOffsetY, 0);

        const material = new THREE.MeshBasicMaterial({
            color: 0xFFFFFF,
            transparent: true,
            opacity: isPresent ? 1.0 : 0.8
        });

        const mesh = new THREE.Mesh(textGeometry, material);
        mesh.position.set(position.x, position.y, position.z);

        return mesh;
    }

    /**
     * Create sprite ordinal (fallback)
     */
    createSprite(text, position, isPresent) {
        const canvas = document.createElement('canvas');
        const context = canvas.getContext('2d');
        const fontSize = isPresent ? 64 : 48;
        
        canvas.width = 512;
        canvas.height = 128;
        
        // Clear canvas with transparent background
        context.clearRect(0, 0, canvas.width, canvas.height);
        
        // Set transparent background explicitly
        context.globalCompositeOperation = 'source-over';
        
        // Draw white text on transparent background
        context.fillStyle = '#FFFFFF';
        context.font = `${fontSize}px monospace`;
        context.textAlign = 'center';
        context.textBaseline = 'middle';
        context.fillText(text, canvas.width / 2, canvas.height / 2);

        const texture = new THREE.CanvasTexture(canvas);
        texture.needsUpdate = true;
        
        // Ensure proper alpha handling
        const material = new THREE.SpriteMaterial({
            map: texture,
            transparent: true,
            alphaTest: 0.01, // Discard pixels with alpha below this threshold
            opacity: isPresent ? 1.0 : 0.8,
            depthWrite: false // Don't write to depth buffer for better transparency
        });

        const sprite = new THREE.Sprite(material);
        sprite.position.set(position.x, position.y, position.z);
        sprite.scale.set(isPresent ? 4 : 3, isPresent ? 2 : 1.5, 1);

        return sprite;
    }

    /**
     * Add new ordinal to the helix
     */
    addOrdinal(ordinalTerms) {
        const ordinalText = OrdinalGenerator.formatOrdinal(ordinalTerms);
        // Use currentIndex (0-based) for positioning, but display shows ordinal (1-based)
        const position = this.calculatePosition(this.currentIndex + 1); // Position based on ordinal number
        
        // Create the new ordinal as present
        const ordinal = this.createOrdinal(ordinalText, position, true);
        
        // Make previous ordinal non-present
        if (this.ordinals.length > 0) {
            const previousOrdinal = this.ordinals[this.ordinals.length - 1];
            previousOrdinal.userData.isPresent = false;
            this.updateOrdinalAppearance(previousOrdinal, false);
        }
        
        this.ordinals.push(ordinal);
        this.scene.add(ordinal);
        this.currentIndex++;
        
        // Update the helical path to show the connection
        this.updateHelicalPath();
        
        return ordinal;
    }

    /**
     * Update ordinal appearance based on present/past status
     */
    updateOrdinalAppearance(ordinal, isPresent) {
        const targetOpacity = isPresent ? 1.0 : 0.6;
        const targetScale = isPresent ? 1.0 : 0.8;

        if (ordinal.material) {
            ordinal.material.opacity = targetOpacity;
        }
        
        if (isPresent) {
            ordinal.scale.copy(ordinal.userData.originalScale);
        } else {
            ordinal.scale.multiplyScalar(targetScale);
        }
    }

    /**
     * Apply ethereal decay to past ordinals - only after ω (step 1000) is reached
     */
    applyEtherealDecay() {
        // The Threshold of Omega: No decay until ω (step 1000) appears
        if (this.currentIndex <= 1000) {
            return; // All finite ordinals remain eternal
        }

        const currentTime = Date.now();
        const toRemove = [];

        this.ordinals.forEach((ordinal, index) => {
            if (!ordinal.userData.isPresent) {
                const age = (currentTime - ordinal.userData.birthTime) / 1000; // seconds
                ordinal.userData.age = age;

                // Only apply decay to ordinals beyond the finite threshold
                const ordinalStep = index; // 0-based index corresponds to step number
                
                if (ordinalStep < 1000) {
                    // Finite ordinals remain at full strength until ω appears
                    ordinal.scale.copy(ordinal.userData.originalScale);
                    if (ordinal.material) {
                        ordinal.material.opacity = ordinal.userData.isPresent ? 1.0 : 0.8;
                    }
                } else {
                    // Infinite ordinals (ω and beyond) experience decay
                    const distanceFromPresent = this.ordinals.length - 1 - index;
                    const decayFactor = Math.max(0.1, 1.0 - (distanceFromPresent * 0.05));
                    
                    // Apply temporal decay
                    const scaleDecay = Math.max(0.1, decayFactor);
                    const opacityDecay = Math.max(0.05, decayFactor * 0.8);

                    ordinal.scale.copy(ordinal.userData.originalScale);
                    ordinal.scale.multiplyScalar(scaleDecay);

                    if (ordinal.material) {
                        ordinal.material.opacity = opacityDecay;
                    }

                    // Mark for removal if below threshold
                    if (scaleDecay <= 0.15 || opacityDecay <= 0.1) {
                        toRemove.push(index);
                    }
                }
            }
        });

        // Remove ordinals that have reached the threshold of oblivion
        toRemove.reverse().forEach(index => {
            const ordinal = this.ordinals[index];
            this.scene.remove(ordinal);
            
            // Dispose geometry and material
            if (ordinal.geometry) {
                ordinal.geometry.dispose();
            }
            if (ordinal.material) {
                if (ordinal.material.map) {
                    ordinal.material.map.dispose();
                }
                ordinal.material.dispose();
            }
            
            this.ordinals.splice(index, 1);
        });

        // Update helical path after potential removals
        this.updateHelicalPath();
    }

    /**
     * Create and update the helical path visualization
     */
    createHelicalPath() {
        // Create initial path geometry
        this.pathGeometry = new THREE.BufferGeometry();
        this.pathCurve = null; // Will hold the smooth curve
        
        // Create line material - subtle white line
        const pathMaterial = new THREE.LineBasicMaterial({
            color: 0xFFFFFF,
            transparent: true,
            opacity: 0.3,
            linewidth: 2 // Slightly thicker for better visibility
        });

        // Create the line object
        this.pathLine = new THREE.Line(this.pathGeometry, pathMaterial);
        this.scene.add(this.pathLine);
    }

    /**
     * Update the helical path to show smooth curved connections
     */
    updateHelicalPath() {
        if (!this.pathGeometry || this.currentIndex < 2) return;

        // Create path points from ordinal positions (1-based ordinals)
        const points = [];
        for (let i = 1; i <= this.currentIndex; i++) {
            const position = this.calculatePosition(i);
            points.push(new THREE.Vector3(position.x, position.y, position.z));
        }

        // Create smooth curve through the points
        if (points.length >= 2) {
            this.pathCurve = new THREE.CatmullRomCurve3(points);
            
            // Generate smooth curve points (more points = smoother curve)
            const curvePoints = this.pathCurve.getPoints(points.length * 5); // 5x interpolation
            
            // Update the line geometry with smooth curve
            this.pathGeometry.setFromPoints(curvePoints);
            this.pathGeometry.attributes.position.needsUpdate = true;
        }
    }

    /**
     * Get current helix bounds for camera positioning
     */
    getCurrentBounds() {
        if (this.ordinals.length === 0) {
            return { maxRadius: this.helixRadius, maxHeight: 0 };
        }

        // Pure helix: radius stays constant, only height grows
        const maxRadius = this.helixRadius;
        const maxHeight = this.currentIndex * this.ascentRate;

        return { maxRadius, maxHeight };
    }
}