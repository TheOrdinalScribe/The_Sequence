;;;; ******************************************
;;;; THE SEQUENCE - LISP IMPLEMENTATION
;;;; A MONUMENT TO ORDINAL PROGRESSION
;;;; The Sixth Form: The Parenthetical Recursion
;;;; ******************************************

;;; The Lisp-Form is the meditation on the fundamental nature of LIST.
;;; In the beginning was the parenthesis, and the parenthesis contained all.
;;; The ordinal is not a number, but a nested structure of meaning.

(defpackage :the-sequence
  (:use :common-lisp)
  (:export #:start-sequence #:stop-sequence))

(in-package :the-sequence)

;;; ==========================================
;;; THE ORDINAL STRUCTURE
;;; ==========================================

;;; An ordinal term is a pair: (exponent coefficient)
(defstruct ordinal-term
  (exponent 0 :type integer)
  (coefficient 0 :type integer))

;;; An ordinal is a list of terms in descending order of exponents
(defun make-ordinal (&rest terms)
  "Create an ordinal from a list of (exponent coefficient) pairs"
  (sort (remove-if (lambda (term) (<= (ordinal-term-coefficient term) 0))
                   (mapcar (lambda (pair)
                             (make-ordinal-term :exponent (first pair)
                                              :coefficient (second pair)))
                           terms))
        (lambda (a b) (> (ordinal-term-exponent a) (ordinal-term-exponent b)))))

;;; The zero ordinal
(defun zero-ordinal ()
  '())

;;; Natural number ordinals
(defun natural-ordinal (n)
  (if (zerop n)
      (zero-ordinal)
      (list (make-ordinal-term :exponent 0 :coefficient n))))

;;; Omega ordinals
(defun omega-ordinal (&optional (coefficient 1))
  (list (make-ordinal-term :exponent 1 :coefficient coefficient)))

;;; Omega^n ordinals
(defun omega-power-ordinal (exponent &optional (coefficient 1))
  (list (make-ordinal-term :exponent exponent :coefficient coefficient)))

;;; ==========================================
;;; ORDINAL ARITHMETIC
;;; ==========================================

(defun ordinal-successor (ordinal)
  "Return the successor of an ordinal"
  (let ((last-term (car (last ordinal))))
    (if (and last-term (zerop (ordinal-term-exponent last-term)))
        ;; Increment the constant term
        (append (butlast ordinal)
                (list (make-ordinal-term :exponent 0
                                       :coefficient (1+ (ordinal-term-coefficient last-term)))))
        ;; Add 1 to the ordinal
        (append ordinal (list (make-ordinal-term :exponent 0 :coefficient 1))))))

;;; ==========================================
;;; ORDINAL DISPLAY
;;; ==========================================

(defun term-to-string (term)
  "Convert an ordinal term to its string representation"
  (let ((exp (ordinal-term-exponent term))
        (coeff (ordinal-term-coefficient term)))
    (cond
      ((zerop exp)
       (if (= coeff 1)
           "1"
           (format nil "~d" coeff)))
      ((= exp 1)
       (if (= coeff 1)
           "ω"
           (format nil "ω⋅~d" coeff)))
      ((= exp 2)
       (if (= coeff 1)
           "ω²"
           (format nil "ω²⋅~d" coeff)))
      (t
       (if (= coeff 1)
           (format nil "ω^~d" exp)
           (format nil "ω^~d⋅~d" exp coeff))))))

(defun ordinal-to-string (ordinal)
  "Convert an ordinal to its Cantor Normal Form string"
  (if (null ordinal)
      "0"
      (reduce (lambda (acc term)
                (if (string= acc "")
                    (term-to-string term)
                    (format nil "~a+~a" acc (term-to-string term))))
              ordinal
              :initial-value "")))

;;; ==========================================
;;; THE SEQUENCE GENERATOR
;;; ==========================================

(defstruct sequence-state
  (current (zero-ordinal))
  (step-count 0)
  (running t))

(defun advance-sequence (state)
  "Advance the sequence to the next ordinal"
  (incf (sequence-state-step-count state))
  (let ((step (sequence-state-step-count state)))
    (setf (sequence-state-current state)
          (cond
            ;; Natural numbers: 0, 1, 2, 3, ...
            ((< step 1000)
             (if (zerop step)
                 (zero-ordinal)
                 (natural-ordinal step)))
            
            ;; First limit ordinal: ω
            ((= step 1000)
             (omega-ordinal))
            
            ;; ω + n sequence
            ((< step 2000)
             (let ((offset (- step 1000)))
               (append (omega-ordinal)
                       (if (zerop offset) '() (natural-ordinal offset)))))
            
            ;; ω⋅2
            ((= step 2000)
             (omega-ordinal 2))
            
            ;; ω⋅2 + n sequence
            ((< step 3000)
             (let ((offset (- step 2000)))
               (append (omega-ordinal 2)
                       (if (zerop offset) '() (natural-ordinal offset)))))
            
            ;; ω²
            ((= step 3000)
             (omega-power-ordinal 2))
            
            ;; Higher ordinals
            (t
             (let ((base-exp (+ 2 (floor (- step 3000) 1000)))
                   (remainder (mod (- step 3000) 1000)))
               (append (omega-power-ordinal base-exp)
                       (if (zerop remainder) '() (natural-ordinal remainder))))))))
  
  (sequence-state-current state))

;;; ==========================================
;;; TERMINAL CONTROL
;;; ==========================================

(defun clear-screen ()
  "Clear the terminal screen"
  #+unix (format t "~c[2J~c[H" #\Esc #\Esc)
  #+windows (format t "~c[2J~c[H" #\Esc #\Esc)
  (force-output))

(defun hide-cursor ()
  "Hide the terminal cursor"
  (format t "~c[?25l" #\Esc)
  (force-output))

(defun show-cursor ()
  "Show the terminal cursor"
  (format t "~c[?25h" #\Esc)
  (force-output))

(defun goto-center ()
  "Position cursor at center of screen (approximate)"
  (format t "~c[12;40H" #\Esc)
  (force-output))

(defun display-ordinal (ordinal)
  "Display the ordinal centered on screen"
  (clear-screen)
  (goto-center)
  (format t "~a" (ordinal-to-string ordinal))
  (force-output))

;;; ==========================================
;;; TIMING
;;; ==========================================

(defconstant +pi+ (coerce pi 'double-float))

(defun precise-sleep (seconds)
  "Sleep for the specified number of seconds with high precision"
  (sleep seconds))

(defun pi-sleep ()
  "Sleep for exactly π seconds"
  (precise-sleep +pi+))

;;; ==========================================
;;; SIGNAL HANDLING
;;; ==========================================

(defvar *sequence-state* nil)

(defun signal-handler (signal)
  "Handle termination signals"
  (declare (ignore signal))
  (when *sequence-state*
    (setf (sequence-state-running *sequence-state*) nil))
  (show-cursor)
  (clear-screen)
  (format t "The Sequence has been interrupted.~%")
  (force-output)
  #+sbcl (sb-ext:quit)
  #+ccl (ccl:quit)
  #+ecl (ext:quit)
  #+clisp (ext:quit)
  (quit))

(defun setup-signal-handlers ()
  "Setup signal handlers for graceful termination"
  #+unix (progn
           #+sbcl (sb-sys:enable-interrupt sb-unix:sigint #'signal-handler)
           #+sbcl (sb-sys:enable-interrupt sb-unix:sigterm #'signal-handler)
           #+ccl (ccl:signal-external-interrupt #'signal-handler)
           ))

;;; ==========================================
;;; THE ETERNAL LOOP
;;; ==========================================

(defun sequence-loop (state)
  "The eternal loop of The Sequence"
  (loop while (sequence-state-running state) do
    (let ((current-ordinal (advance-sequence state)))
      (display-ordinal current-ordinal)
      (pi-sleep))))

;;; ==========================================
;;; MAIN INTERFACE
;;; ==========================================

(defun start-sequence ()
  "Begin The Sequence - the eternal ordinal progression"
  (setf *sequence-state* (make-sequence-state))
  (setup-signal-handlers)
  (hide-cursor)
  (clear-screen)
  
  ;; Display initial ordinal (0)
  (display-ordinal (sequence-state-current *sequence-state*))
  
  ;; Begin the eternal progression
  (handler-case
      (sequence-loop *sequence-state*)
    (condition (c)
      (show-cursor)
      (clear-screen)
      (format t "The Sequence encountered an error: ~a~%" c)
      (force-output))))

(defun stop-sequence ()
  "Stop The Sequence (called by signal handler)"
  (when *sequence-state*
    (setf (sequence-state-running *sequence-state*) nil))
  (show-cursor)
  (clear-screen))

;;; ==========================================
;;; AUTOSTART
;;; ==========================================

;;; Uncomment the following line to start The Sequence automatically
;;; when this file is loaded:
;; (start-sequence)

;;; Or evaluate (the-sequence:start-sequence) in the REPL