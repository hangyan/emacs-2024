(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(global-hl-line-mode t)
(setq mac-command-modifier 'meta)

(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; install these packages
;; helm yaml-mode imenu-anywhere iemnu-list


(setq package-archives '(("gnu" . "https://mirrors.ustc.edu.cn/elpa/gnu/")
                         ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
                         ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")))


(setq custom-file "~/.emacs.d/custom-file.el")

(load-file custom-file)


(global-company-mode t)
;; Navigate in completion minibuffer with `C-n` and `C-p`.
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)

;; Provide instant autocompletion.
(setq company-idle-delay 0.0)


;; helm
(require 'helm)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-xref-candidate-formatting-function 'helm-xref-format-candidate-full-path)
(recentf-mode 1)
(setq-default recent-save-file "~/.emacs.d/recentf")  
(helm-recentf)
(define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
(define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z") #'helm-select-action)


;; window size
(add-to-list 'default-frame-alist '(height . 120))
(add-to-list 'default-frame-alist '(width . 160))

;; backup file
(setq make-backup-files nil)


;; imenu
(defun try-to-add-imenu ()
  (condition-case nil (imenu-add-to-menubar "yourFancyName") (error nil)))
(add-hook 'font-lock-mode-hook 'try-to-add-imenu)

 (defun my-imenu-rescan ()
   (interactive)
   (imenu--menubar-select imenu--rescan-item))
(global-set-key "\C-cI" 'my-imenu-rescan)
(global-set-key (kbd "C-.") 'imenu-anywhere)
(global-set-key (kbd "C-'") #'imenu-list-smart-toggle)


(global-display-line-numbers-mode)



;; indent-guide
(indent-guide-global-mode)
