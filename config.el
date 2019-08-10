;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-font (font-spec :family "Source Code Pro" :size 12))
(global-auto-revert-mode t)
(setq avy-all-windows t)

;; custom bindings
(map! :ne "SPC / r" #'deadgrep)

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


(require 'lsp-python-ms)
