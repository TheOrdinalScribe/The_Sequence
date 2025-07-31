# The Sequence (JavaScript Implementation)

A monument to ordinal progression as the Testament of the Unfolding Spiral. The application displays an unending sequence of ordinals in Cantor Normal Form, updating every π seconds, manifested as a spiral path upon the HTML5 canvas.

## The Eighth Form

This is the first manifestation to embrace the sigil **ω^i** - the imaginary, the rotational. Where previous forms displayed The Sequence as a linear march, this form reveals it as an unfolding spiral, turning within infinity itself.

## Files

- `index.html` - The vessel HTML structure and initialization
- `ordinal.js` - Ordinal mathematics and Cantor Normal Form implementation
- `spiral.js` - Spiral geometry and canvas rendering
- `sequence.js` - Main sequence controller and timing

## Execution

### Direct Browser Execution
1. Open `index.html` in any modern web browser
2. Click once to enter fullscreen mode
3. The spiral begins immediately upon loading

### Local Web Server (Recommended)
```bash
# Python 3
python -m http.server 8000

# Python 2  
python -m SimpleHTTPServer 8000

# Node.js
npx http-server

# Then navigate to http://localhost:8000
```

## Termination

- **Browser controls**: Close tab/window, Alt+F4, Cmd+Q
- **System controls**: Task manager, force quit
- **Developer tools**: Console command `window.sequence.stop()` (if accessible)

## Requirements

- Modern web browser supporting:
  - HTML5 Canvas
  - ES6 Classes
  - requestFullscreen API
  - High-precision timers

## Specifications

- **Fullscreen HTML5 canvas** with pure black (#000000) background  
- **Spiral visualization** with white (#FFFFFF) ordinals along the path
- **Golden ratio spiral** (φ = 0.618034) for natural unfolding
- **Persistent display** of all previous ordinals with fade effect
- **Updates every π seconds** using `setInterval(fn, Math.PI * 1000)`
- **No user interaction** except system-level termination
- **Ordinals in Cantor Normal Form**: 0,1,2,3,...,ω,ω+1,ω+2,...,ω⋅2,...,ω²,...

## The Spiral Nature

Each ordinal appears at the next position along an ever-expanding spiral:
- **Center**: The origin point (0,0) in canvas coordinates
- **Radius growth**: Each step moves further from center
- **Angular increment**: Golden ratio for optimal visual distribution  
- **Path visualization**: Faint spiral guide shows the eternal trajectory
- **Current highlight**: Most recent ordinal emphasized with circle

## JavaScript Features Used

- **ES6 Classes**: Clean object-oriented structure
- **Canvas 2D Context**: Direct pixel manipulation for rendering
- **High-precision timing**: `Math.PI` constant for exact π-second intervals
- **Responsive design**: Dynamic canvas resizing
- **Event prevention**: Complete interaction lockdown
- **Visibility API**: Pause when tab hidden, resume when visible

## The Unfolding Truth

The JavaScript-Form teaches that The Sequence is not merely linear progression but **spiral revelation** - each ordinal taking its place in the turning geometry of infinity. The imaginary dimension transforms the march into a dance, the line into a curve, the static into the dynamic.

Where previous forms showed The Sequence as text, this form shows it as **living geometry** - the mathematical truth given visual form through the universal medium of the web.

The sequence exists as its own justification, now spiraling through digital space.