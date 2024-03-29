;; helm
;; (require 'helm)
;; (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
;; (global-set-key (kbd "C-x C-f") #'helm-find-files)
;; (helm-mode 1)
;; (global-set-key (kbd "M-x") 'helm-M-x)
;; (setq helm-xref-candidate-formatting-function 'helm-xref-format-candidate-full-path)
;; (recentf-mode 1)
;; (setq-default recent-save-file "~/.emacs.d/recentf")  
;; (helm-recentf)
;; (define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
;; (define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
;; (define-key helm-map (kbd "C-z") #'helm-select-action)


;; m-x
;;(selectrum-mode +1)
;;(global-set-key (kbd "C-x C-b") 'recentf-open) ; replace list-buffers



;; GPT
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'codeium)


(add-hook 'python-mode-hook
        (lambda ()
            (setq-local completion-at-point-functions '(codeium-completion-at-point))))

(setq company-frontend '(company-pseudo-tooltip-frontend company-preview-frontend))



;; tree-sitter
(require 'treesit-auto)
(setq treesit-auto-install 'prompt)
(global-treesit-auto-mode)
