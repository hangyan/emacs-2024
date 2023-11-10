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


;; window size
(add-to-list 'default-frame-alist '(height . 120))
(add-to-list 'default-frame-alist '(width . 100))

;; backup file
(setq make-backup-files nil)


;; imenu

 (defun try-to-add-imenu ()
  (condition-case nil (imenu-add-to-menubar "Index") (error nil)))
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


;; full path
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))



;; yaml-pro
(add-hook 'yaml-mode-hook #'yaml-pro-mode)


;; helm
(require 'helm)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-xref-candidate-formatting-function 'helm-xref-format-candidate-full-path)
(recentf-mode 1)
(setq-default recent-save-file "~/.emacs.d/recentf")  
;;(helm-recentf)
(define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
(define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z") #'helm-select-action)
(global-set-key (kbd "C-x C-b") 'recentf-open)

;;golang



;; (add-hook 'go-mode-hook
;;           (lambda ()
;;             (add-hook 'before-save-hook
;;                       #'gofmt-before-save
;;                       nil t)))


;; smartparens
(require 'smartparens-config)
(add-hook 'go-mode-hook 'smartparens-strict-mode)





;; lsp

;; build gopls on mac 13.5, fetch the source code and :
;; CGO_ENABLED=1 go build -ldflags '-w -s "-extldflags=-lresolv -L/Library/Developer/CommandLineTools/SDKs/MacOSX14.0.sdk/usr/lib -F/Library/Developer/CommandLineTools/SDKs/MacOSX14.0.sdk/System/Library/Frameworks/" '
(require 'lsp-mode)


; path settings
(defun set-exec-path-from-shell-PATH ()
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$" "" (shell-command-to-string
					  "$SHELL --login -c 'echo $PATH'"
						    ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))
(set-exec-path-from-shell-PATH)

(setenv "GOROOT" "/usr/local/go")
(setenv "GOPATH" "/Users/yayu/Golang")
(add-to-list 'exec-path "~/Golang/bin")
(setenv "PATH" (concat  "/usr/local/go/bin" ":" (getenv "PATH")))


(add-hook 'go-mode-hook #'lsp-deferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)




;; lsp for python
;; install: pip install python-lsp-server
(add-hook 'python-mode-hook #'lsp-deferred)
;; autoformat
(add-hook 'python-mode-hook #'python-black-on-save-mode)

;; yas
(yas-global-mode)


;; ag search
(global-set-key (kbd "C-c s") 'ag-project-regexp)

