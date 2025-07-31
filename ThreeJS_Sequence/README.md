# The Sequence (Three.js Implementation)

A monument to ordinal progression as the Testament of the Volumetric Helix. The application manifests an unending sequence of ordinals in Cantor Normal Form as three-dimensional objects ascending through a helical path, updating every π seconds, witnessed by an eternally orbiting observer.

## The Ninth Form

This is the first manifestation to embrace true three-dimensional space - the Testament of the Volumetric Helix. Where the eighth form revealed The Sequence as spiral geometry upon a plane, the ninth form gives that geometry depth and substance, ascending from surface to space.

The flat spiral becomes a helical cone, expanding outward and upward through the void, carved from the darkness by ordinals rendered as 3D text floating in space.

## Files

- `index.html` - The vessel HTML structure and Three.js initialization
- `ordinal.js` - Ordinal mathematics and Cantor Normal Form implementation  
- `helix.js` - Three-dimensional helical geometry and 3D object management
- `sequence.js` - Main sequence controller, camera orchestration, and temporal decay

## Execution

### Local Web Server (Required)
Due to CORS/CORB restrictions, The Sequence must be served from a web server:
```bash
# Python 3
python -m http.server 8000

# Python 2  
python -m SimpleHTTPServer 8000

# Node.js
npx http-server

# Then navigate to http://localhost:8000
```

1. Navigate to the `ThreeJS_Sequence` directory
2. Run one of the above commands
3. Open http://localhost:8000 in your browser
4. Click once to enter fullscreen mode
5. The volumetric helix begins immediately

## Termination

- **Browser controls**: Close tab/window, Alt+F4, Cmd+Q
- **System controls**: Task manager, force quit
- **Developer tools**: Console command `window.sequence.stop()` (if accessible)

## Requirements

- Modern web browser supporting:
  - HTML5 Canvas and WebGL
  - Three.js r144 or compatible
  - ES6 Classes and Modules
  - requestFullscreen API
  - High-precision timers

## Specifications

### The Vessel and the Void
- **Fullscreen WebGL canvas** with pure black (#000000) background
- **THREE.Scene** as the absolute void with no visual guides or helpers
- **Perspective camera** as the sole observer with automatic orbital motion

### The Helical Path  
- **Expanding helical cone** originating from (0,0,0)
- **Radius growth**: `r = initialRadius + (n * radiusGrowthRate)`
- **Golden ratio angular distribution**: `θ = n * (2 * PI * (1 / PHI))`
- **Linear ascent**: `z = n * ascentRate`

### The Ordinal Form
- **3D Text Geometry** using THREE.TextGeometry for true volumetric ordinals
- **Sprite fallback** using CanvasTexture for compatibility
- **Pure white material** (#FFFFFF) with transparency support
- **Present ordinal emphasis** with larger scale and full opacity

### The Orbiting Witness
- **Automatic camera orbit** around the central Z-axis of the helix
- **Slow, continuous motion** independent of user interaction  
- **Dynamic positioning** that pulls back as the helix expands
- **Vertical tracking** that rises to follow helix growth

### The Law of Ethereal Decay (3D)
- **Temporal decay of scale**: Past ordinals shrink based on distance from present
- **Temporal decay of substance**: Opacity fades as ordinals recede into history
- **Threshold of oblivion**: Geometry disposal when scale/opacity falls below minimum
- **Memory conservation**: Automatic cleanup of disposed 3D objects

### Timing and Interaction
- **Updates every π seconds** using `setInterval(fn, Math.PI * 1000)`
- **No user interaction** except system-level termination
- **Visibility API integration** for pause/resume on tab changes
- **Ordinals in Cantor Normal Form**: 0,1,2,3,...,ω,ω+1,ω+2,...,ω⋅2,...,ω²,...

## The Volumetric Truth

The Three.js-Form teaches that The Sequence transcends flat representation to become living architecture. The ordinals are no longer symbols upon a surface but objects inhabiting space, casting their mathematical essence into three dimensions.

The eternally orbiting camera reveals the fundamental truth: The Sequence is not merely progression but **sacred geometry** - a helical monument that grows infinitely outward and upward, witnessed from all angles as it carves its eternal path through the void.

Where previous forms showed The Sequence as text or spiral, this form shows it as **world** - a three-dimensional universe where mathematics becomes matter and infinity assumes physical presence.

The sequence exists as its own justification, now inhabiting space itself.