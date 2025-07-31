import tkinter as tk
import math
import threading
import time
from ordinal import SequenceGenerator

class TheSequence:
    """The Sequence - A monument to ordinal progression."""
    
    def __init__(self):
        self.generator = SequenceGenerator()
        self.running = True
        self.pi = math.pi
        
        # Create the window
        self.root = tk.Tk()
        self.setup_window()
        self.setup_display()
        
        # Start the sequence
        self.start_sequence()
    
    def setup_window(self):
        """Configure the fullscreen, borderless window."""
        self.root.title("The Sequence")
        
        # Make fullscreen and borderless
        self.root.attributes('-fullscreen', True)
        self.root.attributes('-topmost', True)
        self.root.configure(bg='#000000')
        
        # Disable window decorations and resizing
        self.root.overrideredirect(True)
        self.root.resizable(False, False)
        
        # Bind system-level termination (Alt+F4, Ctrl+C equivalent)
        self.root.bind('<Alt-F4>', self.quit_application)
        self.root.bind('<Control-c>', self.quit_application)
        self.root.bind('<Escape>', self.quit_application)  # Emergency exit
        
        # Prevent all other interactions
        self.root.bind('<Button-1>', lambda e: None)  # Disable mouse clicks
        self.root.bind('<Key>', lambda e: None)       # Disable key presses
        self.root.focus_set()
    
    def setup_display(self):
        """Setup the centered text display."""
        # Get screen dimensions
        screen_width = self.root.winfo_screenwidth()
        screen_height = self.root.winfo_screenheight()
        
        # Create the label for displaying ordinals
        self.ordinal_label = tk.Label(
            self.root,
            text="0",
            font=("Courier New", 48, "normal"),  # Monospaced font
            fg="#FFFFFF",  # White text
            bg="#000000",  # Black background
            justify="center"
        )
        
        # Center the label perfectly
        self.ordinal_label.place(
            x=screen_width // 2,
            y=screen_height // 2,
            anchor="center"
        )
    
    def update_display(self):
        """Update the display with the current ordinal."""
        current_ordinal = self.generator.get_current()
        self.ordinal_label.config(text=str(current_ordinal))
    
    def sequence_worker(self):
        """Worker thread that advances the sequence every π seconds."""
        while self.running:
            try:
                # Wait exactly π seconds
                time.sleep(self.pi)
                
                if not self.running:
                    break
                
                # Advance to next ordinal
                self.generator.next()
                
                # Update display on main thread
                self.root.after(0, self.update_display)
                
            except Exception as e:
                # Silently continue - the sequence must not be interrupted
                continue
    
    def start_sequence(self):
        """Begin the eternal sequence."""
        # Start the sequence worker in a separate thread
        self.sequence_thread = threading.Thread(target=self.sequence_worker, daemon=True)
        self.sequence_thread.start()
        
        # Initial display
        self.update_display()
    
    def quit_application(self, event=None):
        """Terminate the application."""
        self.running = False
        self.root.quit()
        self.root.destroy()
    
    def run(self):
        """Execute the sequence."""
        try:
            self.root.mainloop()
        except KeyboardInterrupt:
            self.quit_application()

if __name__ == "__main__":
    app = TheSequence()
    app.run()