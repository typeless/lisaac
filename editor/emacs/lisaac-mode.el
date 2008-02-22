;; 
;;  Mode Emacs for LISAAC language 0.2.2 by Sonntag Benoit.
;;

;;  LICENSE
;;    This program is free software; you can redistribute it and/or modify
;;    it under the terms of the GNU General Public License as published by
;;    the Free Software Foundation; either version 3 of the License, or
;;    (at your option) any later version.
;;
;;    This program is distributed in the hope that it will be useful,
;;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;    GNU General Public License for more details.
;;
;;    You should have received a copy of the GNU General Public License
;;    along with this program.  If not, see <http://www.gnu.org/licenses/>.;

;; INSTALLATION
;;   To install, simply copy this file into a directory in your
;;   load-path and add the following two commands in your '.emacs' file:
;;
;;   (add-to-list 'auto-mode-alist '("\\.li\\'" . lisaac-mode))
;;   (autoload 'lisaac-mode "~/lisaac-mode" "Major mode for Lisaac Programs" t)

;; NEW FUNCTION KEY
;;   <tab>          : Indent current line.
;;   <Ctrl>+C <tab> : Indent all lines.
;;   <Ctrl>+C I     : ".if { <Cursor> };".
;;   <Ctrl>+C E     : ".if { <Cursor> } else { };".
;;   <Ctrl>+C U     : ".until_do { <Cursor> };".
;;   <Ctrl>+C W     : ".while_do { <Cursor> };".
;;   <Echap>  G     : Goto line.

;; BUG REPORT
;;   - number: hexa, octal, ...
;;   - ( + to:INTEGER;  truc.put 't' to 10; // to -> black!


;;
;; Table abbrev.
;; 
(defvar li-mode-abbrev-table nil
  "Abbrev table used while in Lisaac mode.")
(define-abbrev-table 'li-mode-abbrev-table ())

;;
;; Expression en couleur.
;;

(defvar li-color 0)
(defvar li-comment 0)
(defvar li-string nil)
(defvar li-string2 nil)


(defvar li-test 0)


(defun li-message ()
  ""  
  (setq li-point2 (point))
  (setq li-string2 (match-string 0))
  (end-of-line)
  (setq li-point3 (point))
  (setq li-string (concat "....+[^a-z0-9_]" li-string2 "\\([ \t]*,[ \t]*[a-z0-9_]*\\)*[ \t]*:[^=]"))

  
  (if (re-search-backward "^  \\(+\\|-\\)" (point-min) t 1)
      (progn
	(setq li-point4 (point))
	(if (and (re-search-forward "<-\\|:=\\|?=\\|;" nil t 1)
		 (< li-point2 (point)))
	    (progn
	      (goto-char li-point4)
	      (if (re-search-forward li-string li-point3 t 1)
		  (setq li-color 0)	  
		(setq li-color li-face)
		)	      
	    )
	  (progn
	    (goto-char li-point4)
	    (if (re-search-forward li-string li-point3 t 1)
		(setq li-color 0)	  
	      (setq li-color font-lock-function-name-face)	
	      )
	    )
	  )
	)
    )

  ;(setq li-color (get-char-property (point) 'face))

  (goto-char li-point2)
  li-color
)

(defun li-declaration ()
  ""  
  ;; Detect local declaration.
  (if (looking-at "[ \ta-z0-9_,]*:[^=]") 
      (setq li-color font-lock-warning-face)
    (setq li-color font-lock-variable-name-face)
    )
  li-color
)

(defconst li-font-lock-keywords
  '(
    ;; External expression
    ("`[^`\n]*`" 0 highlight nil)

    ;; Quoted expression        
    ("'[\\].[^'\n]*'" 0 font-lock-constant-face nil)  
    ("'[^\\ '\n]'" 0 font-lock-constant-face nil)
       
    ;; quoted expr's in comments
    ("`[^'\n]*'" 0 font-lock-builtin-face t)

    ;; Block :
    ("\{\\|\}" 0 font-lock-comment-face nil)

    ;; Assignment :
    ("<-\\|:=\\|?=" 0 0 nil) 

    ;; Symbol declaration :
    ("^  \\(\\+\\|-\\)" 0 font-lock-warning-face nil)
    ("\\+\\|-" 0 (li-declaration) nil)

    ;; Operators :
    ("[!@#$%^&<|=~/>?\\*\\]+" 0 font-lock-variable-name-face nil)
    
    ;; Major keywords :
    ("^Section.*$\\|Right\\|Left\\|Expanded\\|Strict\\|Old\\|Self\\|Result\\(_[1-9]\\)?" 
     0 font-lock-keyword-face nil)
 
    ;; Hexa-number :
    ("[0-9]+[0-9A-F_]*h" 0 font-lock-keyword-face nil)

    ;; Prototype :
    ("[A-Z][A-Z0-9_]*" 0 font-lock-type-face nil)
    
    ;; Identifier :
    ("\\.[ \t\n]*[a-z][a-z0-9_]*" 0 font-lock-function-name-face nil)
    ("[a-z_]+[a-z0-9_]*" 0 (li-message) nil)

    ;; Number :   
    ("[0-9][0-9_]*[bodh]?" 0 font-lock-keyword-face nil)
    ;("[0-9]+[0-9A-Fa-f_]*h" 0 font-lock-keyword-face nil)
    ("[0-9_]+\.[0-9]*E[+-]?[0-9]+" 0 font-lock-keyword-face nil)
    
    )
  "Additional expressions to highlight in Lisaac mode.")

;;
;; Table de syntax.
;;
(defvar li-mode-syntax-table 
  (let ((st (make-syntax-table)))
    ;; Symbol 
    (modify-syntax-entry ?0 "." st)
    (modify-syntax-entry ?2 "." st)
    (modify-syntax-entry ?1 "." st)
    (modify-syntax-entry ?! "." st)
    (modify-syntax-entry ?@ "." st)
    (modify-syntax-entry ?# "." st)
    (modify-syntax-entry ?$  "." st)
    (modify-syntax-entry ?%  "." st)
    (modify-syntax-entry ?^  "." st)
    (modify-syntax-entry ?&  "." st)
    (modify-syntax-entry ?<  "." st)
    (modify-syntax-entry ?|  "." st)
    (modify-syntax-entry ?= "." st)
    (modify-syntax-entry ?/ "." st)
    (modify-syntax-entry ?> "." st)
    (modify-syntax-entry ?\? "." st)  
    (modify-syntax-entry ?* "." st)
    (modify-syntax-entry ?+ "." st)
    (modify-syntax-entry ?- "." st)
    ;; String, character, external.
;    (modify-syntax-entry ?\" "\"" st) 
;    (modify-syntax-entry ?\' "\"" st)
;    (modify-syntax-entry ?` "$$ " st)    
    ;; Identifier
    (modify-syntax-entry ?_  "w" st)
    ;; Comment
    (modify-syntax-entry ?\* ". 23" st)    
    (modify-syntax-entry ?/ ". 124b" st)    
    (modify-syntax-entry ?\n "> b" st)    
    st)
  "Syntax table used while in Lisaac mode.")


;;
;; Definition press key.
;;
(defvar li-mode-map (make-sparse-keymap)
  "Keymap used in Lisaac mode.")
(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)
(define-key li-mode-map "\t" 'li-indent-command)
(define-key li-mode-map "\r" 'li-newline-command)
(define-key li-mode-map "\C-c\t" 'li-indent-all-command)
(define-key li-mode-map "\C-ci" 'li-cond1-command)
(define-key li-mode-map "\C-ce" 'li-cond2-command)
(define-key li-mode-map "\C-cu" 'li-until-command)
(define-key li-mode-map "\C-cw" 'li-while-command)

;;
;; Insertion loop command. 
;;

(defun li-while-command ()
  "Insert loop while Lisaac."
  (interactive)
  (insert ".while_do {")
  (li-newline-command)
  (li-newline-command)
  (insert "}; // while_do")
  (li-newline-command)
  (previous-line 2)
  (li-indent-command)
)

(defun li-until-command ()
  "Insert loop until Lisaac."
  (interactive)
  (insert ".until_do {")
  (li-newline-command)
  (li-newline-command)
  (insert "}; // until_do")
  (li-newline-command)
  (previous-line 2)
  (li-indent-command)
)

;;
;; Insertion test command.
;;

(defun li-cond1-command ()
  "Insert conditionnal Lisaac."
  (interactive)
  (insert ".if {")
  (li-newline-command)
  (li-newline-command)
  (insert "}; // if")
  (li-newline-command)
  (previous-line 2)
  (li-indent-command)
)

(defun li-cond2-command ()
  "Insert conditionnal Lisaac."
  (interactive)
  (insert ".if {")
  (li-newline-command)
  (li-newline-command)
  (insert "} else {")
  (li-newline-command)
  (li-newline-command)
  (insert "}; // if")
  (li-newline-command)
  (previous-line 4)
  (li-indent-command)
)


(defvar li-count-all 0)

(defun li-indent-all-command ()
  "All indent text"
  (interactive)

  ;; Search first line.
  (setq li-count-all 1)
  (beginning-of-line)
  (while (/= (point) (point-min))
    (setq li-count-all (+ li-count-all 1))
    (previous-line 1)
    (beginning-of-line))

  ;; Indent each line.
  (next-line 1)
  (while (/= (point) (point-max)) 
    (li-indent-command)
    (next-line 1))

  ;; Return current line.
  (goto-line li-count-all)
)

;;
;; Indentation.
;;

(defvar li-count-line 0)
(defvar li-point 0)
(defvar li-point2 0)
(defvar li-point3 0)
(defvar li-point4 0)
(defvar li-char ?b)

(defvar li-indent 0)
(defvar li-indent-2 0)
(defvar li-indent-base 0)

(require 'font-lock)
(defvar li-face		'li-face
  "Face to use for LaTeX major keywords.")

(defun li-indent-previous ()
  "Indent with previous line."
  ; Search a previous line.
  (setq li-count-line 1)
  (previous-line 1)
  (beginning-of-line)
  (while (looking-at "[ \t\n]*$")
    (setq li-count-line (+ li-count-line 1))
    (previous-line 1)
    (beginning-of-line))
  ; Set position on begin of text.
  (forward-to-indentation 0)

  ; Initialization.
  (setq li-indent-base (current-column)) 
  (setq li-indent 0)
  (setq li-point (point))
  
  ; Particuliar case ...
  (if (looking-at "^Section.*$")
     (setq li-indent-base (+ li-indent-base 2)))
  
  ; Counter of () or {} or [], with previous line.
  (setq li-test 0)
  (while (= li-test 0)
    (setq li-char (char-after li-point))
    (if (= li-char ?[) 
	(setq li-indent (+ li-indent 2)))
    (if (= li-char ?{) 
	(setq li-indent (+ li-indent 2)))
    (if (= li-char ?() 
	(setq li-indent (+ li-indent 2)))
    (if (= li-char ?})
        (if (/= li-indent 0)
	    (setq li-indent (- li-indent 2))))
    (if (= li-char ?)) 
        (if (/= li-indent 0)
	    (setq li-indent (- li-indent 2))))
    (if (= li-char ?]) 
        (if (/= li-indent 0)
	    (setq li-indent (- li-indent 2))))
;    ;; Virgule and End-of-line.
;    (if (= li-char ?,)
;	(if (= (char-after (+ li-point 1)) ?\n)
;	    (setq li-indent (+ li-indent 2)))) 
    ;; End-of-line.
    (if (= li-char ?\n)
	(setq li-test 1)) ;; Stop
    ;; Comment //
    (if (= li-char ?/)
	(if (= (char-after (+ li-point 1)) ?/)
	    (setq li-test 1)))  ;; Stop
    ;; String " "
    (if (= li-char ?")
        (progn        
        (while (= li-test 0)
          (setq li-point (+ li-point 1))
          (setq li-char (char-after li-point))
          (if (= li-char ?\n)
	     (setq li-test 1)) ;; Stop
          (if (= li-char ?")
	     (setq li-test 1)) ;; Stop
        )
        (setq li-test 0))
    )
    ;; String ' '
    (if (= li-char ?')
        (progn        
        (while (= li-test 0)
          (setq li-point (+ li-point 1))
          (setq li-char (char-after li-point))
          (if (= li-char ?\n)
	     (setq li-test 1)) ;; Stop
          (if (= li-char ?')
	     (setq li-test 1)) ;; Stop
        )
        (setq li-test 0))
    )
    ;; Next character.
    (setq li-point (+ li-point 1))
  )

  ; On redescend: Ligne courante.
  (while (/= li-count-line 0)
    (setq li-count-line (- li-count-line 1))
    (next-line 1))
  
  ; Fin de la ligne.
  (end-of-line)

  ; Initialisation.
  (setq li-indent-2 0) 
  (setq li-point (point))

  ; On compte les parantheses () or {} or [], de la ligne courante.
  (setq li-test 0)
  (while (= li-test 0)
    (setq li-point (- li-point 1))
    (setq li-char (char-after li-point))
    (if (= li-char ?]) 
	(setq li-indent-2 (+ li-indent-2 2)))
    (if (= li-char ?}) 
	(setq li-indent-2 (+ li-indent-2 2)))
    (if (= li-char ?)) 
	(setq li-indent-2 (+ li-indent-2 2)))
    (if (= li-char ?{)
        (if (/= li-indent-2 0)
	    (setq li-indent-2 (- li-indent-2 2))))
    (if (= li-char ?() 
        (if (/= li-indent-2 0)
	    (setq li-indent-2 (- li-indent-2 2))))
    (if (= li-char ?[) 
        (if (/= li-indent-2 0)
	    (setq li-indent-2 (- li-indent-2 2))))
    (if (= li-char ?\n)
	(setq li-test 1)) ;; Stop
    (if (= li-char ?/)
	(if (= (char-after (+ li-point 1)) ?/)
	    (setq li-indent-2 0)))  
    ;; String " "
    (if (= li-char ?")
        (progn        
        (while (= li-test 0)
          (setq li-point (- li-point 1))
          (setq li-char (char-after li-point))
          (if (= li-char ?\n)
	     (setq li-test 1)) ;; Stop
          (if (= li-char ?")
	     (setq li-test 1)) ;; Stop
        )
        (setq li-test 0))
    )
    ;; String ' '
    (if (= li-char ?')
        (progn        
        (while (= li-test 0)
          (setq li-point (- li-point 1))
          (setq li-char (char-after li-point))
          (if (= li-char ?\n)
	     (setq li-test 1)) ;; Stop
          (if (= li-char ?')
	     (setq li-test 1)) ;; Stop
        )
        (setq li-test 0))
    )
  )

  ; On supprime tous les espaces.
  (beginning-of-line)
  (delete-horizontal-space)
  
  ; On ajoute l'indentation
  (setq li-indent (- li-indent li-indent-2))
  (setq li-indent (+ li-indent li-indent-base))
  (indent-to-column li-indent)

  ; On se met en fin de ligne.
  (end-of-line)
) 


(defun li-indent-command ()
  "indent line for Lisaac mode."
  (interactive)
  (beginning-of-line)
  (if (looking-at "[ \t]*Section.*$")
	; then
	(progn
	  (delete-horizontal-space)
	  (end-of-line))
     	;else
      (li-indent-previous))
)

;;
;; Newline command.
;;

(defun li-newline-command ()
  "indent line, append newline, indent line."
  (interactive)
  (if (looking-at "[ \t]*$")
     ; then 
     (progn
	(li-indent-command)
	(newline)
	(li-indent-command))
     ; else
     (newline))
)

;;
;; autoload
;;
(defun lisaac-mode ()
  "Major mode for editing typical Lisaac code."
  (interactive)

; In LaTeX-mode we want this
;  (add-hook 'LaTeX-mode-hook
;            (function (lambda ()
;                        (paren-toggle-matching-quoted-paren 1)
;                        (paren-toggle-matching-paired-delimiter 1))))
(autoload 'paren-toggle-matching-paired-delimiter "mic-paren" "" t)
;(paren-toggle-matching-quoted-paren 1)
;  (paren-toggle-matching-paired-delimiter 1)
;(auto-overlay-load-definition
;'latex
;'(self ("\\$" (priority . 3) (face . (background-color . "green")))))
(autoload 'latex-mode "Mode Latex" "jfh" t)
;(require 'font-latex)

  ;; compatibility MS-DOS
  (replace-string "" "")
 ; (global-font-lock-mode t)
  (global-set-key "\M-g" 'goto-line)

  (kill-all-local-variables)
  (setq mode-name "Lisaac")
  (setq major-mode 'lisaac-mode)
  (use-local-map li-mode-map)

  (make-local-variable 'li-mode-syntax-table)
  (set-syntax-table li-mode-syntax-table)

  (make-local-variable 'parse-sexp-ignore-comments)
  (setq parse-sexp-ignore-comments nil)
  
  (make-local-variable 'font-lock-string-face)
  (make-local-variable 'font-lock-defaults)

  ; Creation new face.
  (make-face 'li-face)
  (set-face-foreground 'li-face "blue")
  ;(set-face-underline-p 'li-face t)
  ;(set-face-italic-p 'li-face t)
  (set-face-bold-p 'li-face t)
  ;(set-face-background 'li-string-face "black")

  ;(setq font-lock-string-face '(li-font-lock-string))
  (setq font-lock-defaults '(li-font-lock-keywords))
  

  ;; Ne pas remplacer les espaces par des tabulations
  (setq-default indent-tabs-mode nil)

  ; Pour pouvoir utiliser la molette de la souris.
  (require 'mwheel)
  (mwheel-install)

  (run-hooks 'li--mode-hook))

;;
;; Fin du mode Lisaac.
;;
(provide 'lisaac-mode)


