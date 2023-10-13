(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(global-hl-line-mode t)
(setq mac-command-modifier 'meta)

(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(setq custom-file "~/.emacs.d/custom-file.el")

(load-file custom-file)


(global-company-mode t)
;; Navigate in completion minibuffer with `C-n` and `C-p`.
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)

;; Provide instant autocompletion.
(setq company-idle-delay 0.0)
