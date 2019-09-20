;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-font (font-spec :family "Source Code Pro" :size 12))
(global-auto-revert-mode t)
(setq avy-all-windows t)

;; deadgrep
(map! :ne "SPC / r" #'deadgrep)

(after! deadgrep
  (set-popup-rule! "^\\*deadgrep" :size 0.5 :select t))

;; python
;;
;; taken from spacemacs (lang/python/funcs)
(defun hb9/python-toggle-breakpoint ()
  "Add a break point, highlight it."
  (interactive)
  (let ((trace "import pdb; pdb.set_trace()")
        (line (thing-at-point 'line)))
    (if (and line (string-match trace line))
        (kill-whole-line)
      (progn
        (back-to-indentation)
        (insert trace)
        (insert "\n")
        (python-indent-line)))))


(map!
 (:after python
   (:map python-mode-map
     :localleader
     :prefix "d"
     "b" #'hb9/python-toggle-breakpoint
     "t" #'python-pytest-popup
     )))


;; org
(setq org-directory "~/projects/org"
      org-agenda-files '("~/projects/org"))
(setq org-capture-templates
      '(("b"               ; key
         "Bookmark"        ; name
         entry             ; type
         (file+headline "~/projects/org/bookmarks.org" "Bookmarks")  ; target
         "* [[%^{LINK}][%^{TITLE}]] :bookmark:%^G \n:PROPERTIES:\n:Created: %U\n:END:\n%i\n"  ; template
         :prepend t        ; properties
         :empty-lines 1    ; properties
         :created t        ; properties
         :immediate-finish t
         :kill-buffer t)   ; properties

        ;; For taking notes on random things
        ("n"               ; key
         "Note"            ; name
         entry             ; type
         (file+headline "~/projects/org/notes.org" "Notes")  ; target
         "* %^{TITLE} :note:%^G \n:PROPERTIES:\n:Created: %U\n:END:\n%i\n%?"  ; template
         :prepend t        ; properties
         :empty-lines 1    ; properties
         :created t        ; properties
         :kill-buffer t)   ; properties

        ;; For taking notes on files
        ("f"               ; key
         "File-Note"            ; name
         entry             ; type
         (file+headline "~/projects/org/notes.org" "File-Notes")  ; target
         "* %^{TITLE} :file-note:%^G \n:PROPERTIES:\n:Created: %U\n:Linked: %a\n:END:\n%i\n%A\n%?"  ; template
         :prepend t        ; properties
         :empty-lines 1    ; properties
         :created t        ; properties
         :kill-buffer t)   ; properties

        ;; To capture tons of errands
        ("e"               ; key
         "Errands"         ; name
         entry             ; type
         (file+headline "~/projects/org/notes.org" "Errands")  ; target
         "* TODO %^{Todo} :errands:\n:PROPERTIES:\n:Created: %U\n:END:\n%i\n%?"  ; template
         :prepend t        ; properties
         :empty-lines 1    ; properties
         :created t        ; properties
         :kill-buffer t)   ; properties
        ))

(defun hb9/search-notes ()
  "Search org files."
  (interactive)
  (+ivy/project-search nil nil "~/projects/org"))

(map! :ne "SPC / n" #'hb9/search-notes)

