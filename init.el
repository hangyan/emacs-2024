(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(global-hl-line-mode t)
(setq mac-command-modifier 'meta)

(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(setq package-archives '(("gnu" . "https://mirrors.ustc.edu.cn/elpa/gnu/")
                         ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
                         ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")))


(setq custom-file
       (expand-file-name (concat "~/.emacs.d/"
                                 (if (eq system-type 'windows-nt)
                                     "win-"
                                   "")
                                 "emacs-custom.el")))
(load custom-file t)

(add-to-list 'load-path "~/.emacs.d/lib/")


(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-a-win* (eq system-type 'windows-nt))



(global-company-mode t)
;; Navigate in completion minibuffer with `C-n` and `C-p`.
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)

;; Provide instant autocompletion.
(setq company-idle-delay 0.0)


;; window size
(when *is-a-mac* 
  (add-to-list 'default-frame-alist '(height . 120))
  (add-to-list 'default-frame-alist '(width . 100)))

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


;; indent-guide
(indent-guide-global-mode)
(global-display-line-numbers-mode)

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


(cond ((eq system-type 'windows-nt)
        ;; Windows-specific code goes here.
       (add-to-list 'exec-path 
		    "c:/Users/win/AppData/Roaming/Python/Python310/Scripts")
       (add-to-list 'exec-path "c:/Program Files/Git/bin")
       (add-to-list 'exec-path "c:/Python310/Scripts")
       (add-to-list 'exec-path "c:/ProgramData/chocolatey/bin")
       (add-to-list 'exec-path "c:/Users/win/AppData/Local/Microsoft/WindowsApps")
       (setenv "GOROOT" "c:/Program Files/Go")
       (setenv "GOPATH" "d:/go")
       (add-to-list 'exec-path "c:/Program Files/go/bin")
       (add-to-list 'exec-path "d:/go/bin")
       (setenv "PATH" (mapconcat #'identity exec-path path-separator)))
      ((eq system-type 'darwin)
       ;; mac-specific code goes here.
       (setenv "GOROOT" "/usr/local/go")
       (setenv "GOPATH" "/Users/yayu/Golang")
       
       (add-to-list 'exec-path "~/Golang/bin")
       (if (file-exists-p "~/.go.env")
	   (load-env-vars "~/.go.env"))
       (setenv "PATH" (concat  "/usr/local/go/bin" ":" (getenv "PATH")))
       ))



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
;; autoformat -- enable this for files you can control...
;; (add-hook 'python-mode-hook #'python-black-on-save-mode)
(setq lsp-response-timeout 5)

;; yas
(yas-global-mode)


;; ag search
(global-set-key (kbd "C-c s") 'ag-project-regexp)


;; flymake for lsp
(require 'flymake-cursor)

(setq display-buffer-alist
      '(("^\\*Flymake diagnostics"
	 (display-buffer-reuse-window
	  display-buffer-in-side-window)
	 (reusable-frames . visible)
	 (side            . bottom)
	 (window-height   . 0.20))))

(global-set-key (kbd "C-c f e") 'flymake-show-buffer-diagnostics)

;; hl-todo-mode
(global-hl-todo-mode)

;; global-diff
(global-diff-hl-mode)

;; dashboard
(require 'dashboard)
(dashboard-setup-startup-hook)



;; projectil
(projectile-mode +1)
;; Recommended keymap prefix on macOS
;;(when *is-a-mac*
;;  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map))
;; Recommended keymap prefix on Windows/Linux
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
;; (setq helm-projectile-fuzzy-match nil)
(require 'helm-projectile)
(helm-projectile-on)



;; query-and-repalce function

(defun entire-buffer-replace (from to)
  "Do search and replace on entire buffer without moving point."
  (interactive "MReplace: \nMWith: ")
  (save-excursion
    (beginning-of-buffer)
    (let ((case-fold-search nil))
      (while (search-forward from nil t)
        (replace-match to t t)))))

(global-set-key (kbd "M-%") 'entire-buffer-replace)


;; spell check
(add-hook 'after-init-hook #'global-flycheck-mode)


;; sql
(setq sqlformat-command 'pgformatter)
(setq sqlformat-args '("-s2" "-g"))
(add-hook 'sql-mode-hook 'sqlformat-on-save-mode)



;; project-exploer
;; (global-set-key (kbd "C-x p j") 'project-explorer-toggle)


;; multi cursors
(require 'multiple-cursors)


;; function to open my init file.

(defun my-open-init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))


;; custom menubar
(defvar my-menu-bar-menu (make-sparse-keymap "Misc"))
(define-key global-map [menu-bar my-menu] (cons "Misc" my-menu-bar-menu))

(define-key my-menu-bar-menu [treemacs]
  '(menu-item "Treemacs" treemacs :help "Open Treemacs"))
(define-key my-menu-bar-menu [project-explorer-toggle]
	    '(menu-item "Project Explorer" project-explorer-toggle :help "Project Explorer"))
(define-key my-menu-bar-menu [my-open-init-file]
	    '(menu-item "Open Init File" my-open-init-file :help "Edit emacs init file"))



;;; search
(setq highlight-symbol-on-navigation-p t)

(defun backward-symbol (arg)
  (interactive "p")
  (forward-symbol (- arg)))
(global-set-key (kbd "M-b") 'backward-symbol)
(global-set-key (kbd "M-f") 'forward-symbol)



;;; buff switc
;; (require 'buff-menu+)
(global-set-key (kbd "C-x b") 'helm-buffers-list)


;;; mode line

;; Run: M-x nerd-icons-install-fonts
(doom-modeline-mode 1)

(setq nerd-icons-scale-factor 1.1)

