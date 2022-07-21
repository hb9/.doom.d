;;; hb9-python.el -*- lexical-binding: t; -*-

(use-package! poetry
  :ensure t
  :after python
  :init
  (setq poetry-tracking-strategy 'switch-buffer)
  (add-hook 'python-mode-hook #'poetry-tracking-mode))

(after! projectile
  (pushnew! projectile-project-root-files "pyproject.toml" "requirements.txt" "setup.py"))

(use-package! python
  :mode ("[./]flake8\\'" . conf-mode)
  :mode ("/Pipfile\\'" . conf-mode)
  :init
  (setq ;; python-environment-directory doom-cache-dir
        python-indent-guess-indent-offset-verbose nil)

  :config
  (set-repl-handler! 'python-mode #'+python/open-repl
    :persist t
    :send-region #'python-shell-send-region
    :send-buffer #'python-shell-send-buffer)
  (set-docsets! '(python-mode inferior-python-mode) "Python 3" "NumPy" "SciPy" "Pandas"))


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

;; (defun hb9/which-env ()
;;   "Print location of python exe."
;;   (interactive)
;;   (if (eq major-mode 'emacs-lisp-mode)
;;     (shell-command "which python")))

(defun hb9/which-env ()
  "Print location of python exe."
  (interactive)
    (shell-command "which python"))

(map!
 (:after python
   (:map python-mode-map
     :localleader
     ;; :prefix "d"
     "b" #'hb9/python-toggle-breakpoint
     "t" #'python-pytest-popup
     "d" #'flymake-show-buffer-diagnostics
     "v" #'hb9/which-env
     )))

(map! :ne "SPC s v" #'hb9/which-env)
