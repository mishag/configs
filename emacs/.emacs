;; This is the Aquamacs Preferences file.
;; Add Emacs-Lisp code here that should be executed whenever
;; you start Aquamacs Emacs. If errors occur, Aquamacs will stop
;; evaluating this file and print errors in the *Messags* buffer.
;; Use this file in place of ~/.emacs (which is loaded as well.)

;;(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")))

(if (display-graphic-p)
    (progn
      (add-to-list 'load-path "~/.emacs.d/elpa/color-theme-20080305.34/")
      (add-to-list 'load-path "~/.emacs.d/emacs-color-theme-solarized-master/")
      (require 'color-theme)
      (require 'color-theme-solarized)
      (color-theme-initialize)

      ;; set dark theme
      (color-theme-solarized-dark)
      ;; set light theme
      ;; (color-theme-solarized-light)
    )
)

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

;;;;;;;;;;;;;;;;;;;;;;;;; C++ MODE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-c-mode-common-hook ()
  (c-set-offset 'substatement-open 0)
  (setq c++-tab-always-indent t)
  (setq c-basic-offset 4)
  (setq c-indent-level 4)

  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  (setq tab-width 4)
  (setq indent-tabs-mode nil))

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(add-hook 'c-mode-common-hook
	  (lambda () (define-key c-mode-base-map (kbd "C-c C-l") 'compile)))
(add-hook 'c-mode-common-hook
	  (lambda () (define-key c-mode-base-map (kbd "<f4>") 'recompile)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
;; '(custom-enabled-themes (quote (tsdh-dark)))
 '(load-home-init-file t t))

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; INCLUDE GUARDS
(defun get-include-guard ()
  "Return a string suitable for use in a C/C++ include guard"
  (let* ((fname (buffer-file-name (current-buffer)))
         (fbasename (replace-regexp-in-string ".*/" "" fname))
         (inc-guard-base (replace-regexp-in-string "[.-]"
                                                   "_"
                                                   fbasename)))
    (concat "INCLUDED_" (upcase inc-guard-base))))

(add-hook 'find-file-not-found-hooks
          '(lambda ()
             (let ((file-name (buffer-file-name (current-buffer))))
               (when (string= ".h" (substring file-name -2))
                 (let ((include-guard (get-include-guard)))
                   (insert "#ifndef " include-guard)
                   (newline)
                   (insert "#define " include-guard)
                   (newline 4)
                   (insert "#endif")
                   (newline)
                   (previous-line 3)
                   (set-buffer-modified-p nil))))))


;;;;;;;;;;;;;;;;;;;;;;;; Python Mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'python-mode-hook
  (lambda()
    (setq py-indent-offset 4)
    (setq indent-tabs-mode nil)
    (setq tab-width 4)))

;;;;;;;;;;;;;;;;;;;;;;;;; MISC CUSTOMIZATIONS ;;;;;;;;;;;;;;;;;;;;

(transient-mark-mode t) ;; active region highlightin
(show-paren-mode 1)     ;; show matching parens
(setq line-number-mode t) ;; display line number
(setq column-number-mode t) ;; display column number
(setq inhibit-startup-screen t)

(global-set-key [?\C-.] (lambda () (interactive) (scroll-down 1)))
(global-set-key [?\C-,] (lambda () (interactive) (scroll-up 1)))

(defun delete-horizontal-space-forward ()
  "*Delete all spaces and tabs after point."
  (interactive "*")
  (delete-region (point) (progn (skip-chars-forward " \t") (point))))

(global-set-key [?\C-{] 'delete-horizontal-space-forward)

;; MY STUFF BELOW

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(global-linum-mode 1)

(require 'cl)

(add-to-list 'load-path "/Users/misha/emacs-packages/")
(require 'protobuf-mode)
