;; petl-mode.el -> Simple major mode for Petl source code editing.

(defconst petl-syntax-table
      (with-syntax-table (copy-syntax-table)
        (modify-syntax-entry ?\; "<")
        (modify-syntax-entry ?\n ">")
        (syntax-table))
      "Syntax table for Petl mode.")

(setq petl-fontlock
      '(("setptr\\|getptr\\|buffer\\|setreg\\|syscall\\|exit" . 'font-lock-builtin-face)
        ("type\\|extfn\\|defn\\|if\\|else\\|elif\\|while\\|require\\|return" . 'font-lock-keyword-face)
        ))

(define-derived-mode petl-mode fundamental-mode "petl" "Major mode for editing Petl code."
  :syntax-table petl-syntax-table
  (setq font-lock-defaults '(petl-fontlock)))

(add-to-list 'auto-mode-alist '("\\.petl\\'" . petl-mode))

(provide 'petl-mode)
