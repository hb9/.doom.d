;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-font (font-spec :family "Source Code Pro" :size 12))
(global-auto-revert-mode t)
(setq avy-all-windows t)

;; deadgrep
(map! :ne "SPC s g" #'deadgrep)

(after! deadgrep
  (set-popup-rule! "^\\*deadgrep" :size 0.5 :select t))

;; eshell
(setq-hook! 'eshell-mode-hook company-idle-delay nil)
(set-eshell-alias! "fo" "find-file-other-window $1")
;; set by doom-emacs: f=find-file, q=exit, d=dired and more


;; org
(require 'org)
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

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   ;; ...
   (scheme . t)))

(defun hb9/search-notes ()
  "Search org files."
  (interactive)
  (+ivy/project-search nil nil "~/projects/org"))

(map! :ne "SPC s n" #'hb9/search-notes)

(setq custom-file (expand-file-name "hb9-python.el" doom-private-dir))
  (when (file-exists-p custom-file)
    (load custom-file))


(defun hb9/eshell-default-prompt-fn ()
  "Generate the prompt string for eshell. Use for `eshell-prompt-function'."
  (require 'shrink-path)
(cl-destructuring-bind (wstatus . woutput)
      (doom-call-process "which" "python")
  (concat (if (bobp) "" "\n") "[" (shrink-path-file woutput) "] "
          (let ((pwd (eshell/pwd)))
            (propertize (if (equal pwd "~")
                            pwd
                          (abbreviate-file-name (shrink-path-file pwd)))
                        'face '+eshell-prompt-pwd))
          (propertize (+eshell--current-git-branch)
                      'face '+eshell-prompt-git-branch)
          (propertize " λ" 'face (if (zerop eshell-last-command-status) 'success 'error))
          " ")))

(defun hb9/init-eshell ()
(setq eshell-prompt-function 'hb9/eshell-default-prompt-fn)
  )


(use-package! eshell
:config (add-hook 'eshell-mode-hook 'hb9/init-eshell))
