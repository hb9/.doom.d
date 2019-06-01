;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-font (font-spec :family "Source Code Pro" :size 12))
(global-auto-revert-mode t)

(map! :ne "SPC / r" #'deadgrep)

;; custom bindings


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


;; taken from python-pytest
(defun hb9/python-pytest-one (file func arg)
  "Run pytest on FILE with FUNC (or class) in a new term buffer."
  (interactive
   (list
    (buffer-file-name)
    (python-pytest--current-defun)
    (python-pytest-arguments)))
  (let (
        (cmd (concat
              "source .venv/bin/activate && pytest "
              file "::" (replace-regexp-in-string "\\." "::" func)))
        )
    (hb9/exec-in-new-term cmd)))


(defun hb9/exec-in-new-term (cmd)
  (+term/open t)
  (comint-send-string (buffer-name) (concat cmd "\n")))


(map!
 (:after python
   (:map python-mode-map
     :localleader
     :prefix "d"
     "b" #'hb9/python-toggle-breakpoint
     "t" #'hb9/python-pytest-one
     )))
