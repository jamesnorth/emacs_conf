;; This is my .emacs file. A some of this is stuff taken from the Emacs Wiki.
;; I'm still learning emacs but hopefully this file may be of use to someone.
;;

;; Determine what system I'm running on...
(defvar running-on-linux (string-match "gnu/linux" (symbol-name system-type)))
(defvar running-on-windows (string-match "windows-nt" (symbol-name system-type)))
(defvar running-on-macosx (string-match "darwin" (symbol-name system-type)))

(when running-on-linux
  (message "Loading James' Emacs init file on wonderful Ubuntu"))

(when running-on-windows
  (message "Loading James' Emacs init file on Windows"))

(when running-on-macosx
  (message "Loading James' Emacs init file on a Mac..."))

;; Add some stuff to the load path
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")

;; Load and setup Haskell mode
(load "~/.emacs.d/haskell-mode-2.8.0/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;; XXX: At the moment I can't use Erlang mode on Linux... this needs to be fixed.
(when running-on-windows
  (message "Loading Erlang...")
  (setq load-path (cons  "C:/Program Files/erl5.7/lib/tools-2.6.3/emacs" load-path))
  (setq erlang-root-dir "C:/Program Files/erl5.7")
  (setq exec-path (cons "C:/Program Files/erl5.7/bin" exec-path))
  (require 'erlang-start))

(add-to-list 'load-path "~/.emacs.d/CsharpToolsForEmacs")
(add-to-list 'load-path "~/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)

(require 'csharp-mode)
(require 'color-theme)
(require 'scratch)

;; Customise Colours
(set-cursor-color "blue") ; NOTE: This stands out quite well.
(set-face-foreground 'default "floral white")
(set-background-color "black") ; NOTE: Need to try out a few more colours

;; I prefer the scroll bar on the right
(set-scroll-bar-mode 'right)
(tool-bar-mode 0)
(setq inhibit-startup-screen t)
(setq visible-bell t)       ; Turn off annoying Bell
(setq frame-title-format (list "GNU Emacs " emacs-version "@" system-name " - " '(buffer-file-name "%f" "%b")))
(setq icon-title-format (list "GNU Emacs " emacs-version))
(set-default 'truncate-lines t)
(line-number-mode 1)
(column-number-mode 1)
(global-linum-mode 1)
(prefer-coding-system 'utf-8)

(color-theme-initialize)

;; Define a function to split the window horizontally, but
;; rather than the default behavour it will display the next
;; buffer not the current buffer.
(defun my-custom-horz-split-window ()
  "My custom implementation of the horizontal split command"
  (interactive)
  (split-window-horizontally)
  (message "Splitting the window horizontally. The new window has the buffer %s." (other-buffer))
  (set-window-buffer (next-window) (other-buffer)))
(global-set-key "\C-x3" 'my-custom-horz-split-window)

;; Define a function to split the window vertically, but
;; rather than the default behavour it will display the
;; next buffer not the current buffer.
(defun my-custom-vert-split-window ()
  "My custom implementation of the vertical split command"
  (interactive)
  (split-window-vertically)
  (message "Splitting the window vertically. The new window has the buffer %s." (other-buffer))
  (set-window-buffer (next-window) (other-buffer)))
(global-set-key "\C-x2" 'my-custom-vert-split-window)

;; Flash the scroll lock LED for visible-bell instead of flash the screen
(setq ring-bell-function
      (lambda ()
        (call-process-shell-command "xset led 3; xset -led 3" nil 0 nil)))

;; auto-save every 100 input events or every 15 seconds
(setq auto-save-interval 100)
(setq auto-save-timeout 15)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customise C mode a little
(setq-default c-basic-offset 4
          tab-width 4
          indent-tabs-mode t)

(defun my-c-mode-hook ()
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (setq indent-tabs-mode t)
  (add-hook 'before-save-hook 'untabify-buffer)
  (local-set-key (kbd "<return>") 'newline-and-indent)
  (local-set-key (kbd "<linefeed>") 'newline)
  (font-lock-add-keywords nil
      '(("^[^\n]\\{80\\}\\(.*\\)$" 1 font-lock-warning-face t)))
  (font-lock-add-keywords nil
      '(("\\<\\(FIXME\\|TODO\\|BUG\\|XXX\\):" 1 font-lock-warning-face t))))

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)

(defun my-csharp-mode-fn ()
  (setq default-tab-width 4)
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0))
(add-hook 'csharp-mode-hook 'my-csharp-mode-fn)

;; Set transparency of emacs
;; This is really cool. From http://www.emacswiki.org/emacs/TransparentEmacs
(defun transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))

(defun my-wrap-mode-on ()
  "Minor mode for making the buffer wrap long lines"
  (interactive)
  (setq truncate-lines nil))

(defun my-wrap-mode-off ()
  "Minor mode for making the buffer not wrap long lines"
  (interactive)
  (setq truncate-lines t))

(defun trailing-whitespace-on ()
  "Turns on the highlighting of trailing white space"
  (interactive)
  (setq-default show-trailing-whitespace t))

(defun trailing-whitespace-off ()
  "Turns off the highlighting of trailing white space"
  (interactive)
  (setq-default show-trailing-whitespace nil))

(defadvice yank (after indent-region activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode c-mode c++-mode
                objc-mode latex-mode plain-tex-mode python-mode))
      (indent-region (region-beginning) (region-end) nil)))

(defun dos-to-unix ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\r" nil t)
      (replace-match ""))))

(defun unix-to-dos ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\n" nil t)
      (replace-match "\r\n"))))

(defun my-insert-time-stamp ()
  "Insert a time stamp."
  (interactive "*")
  (insert (format "%s %s %s %s"
                  comment-start
                  (format-time-string "%Y-%m-%d")
                  (user-login-name)
                  comment-end)))

(defun my-revert-buffer ()
  "Unconditionally revert current buffer."
  (interactive)
  (flet ((yes-or-no-p (msg) t))
    (revert-buffer)))

(defun tabify-buffer ()
  (interactive)
  (tabify (point-min) (point-max)))

(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun cleanup-buffer ()
  (interactive)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun large-font ()
  (interactive)
  (set-face-font
   'default
   "-apple-DejaVu_Sans_Mono-medium-normal-normal-*-20-*-*-*-m-0-iso10646-"))

(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-bufer (buffer-list)))

;; **************************************************************************************
;; Everything below here is me playing around with E-Lisp

(defconst M_PI 3.14159265)
(defconst M_E 2.718281828)

(defun capacitive-reactance (f c)
  "Calculates the reactance of a capacitor and displays it
    to the user in the mini buffer."
  (message "The capacitive reactance is %f" (/ 1 (* 2 M_PI f c))))

(defun inductive-reactance (f l)
  "Calculates inductive reactance and displays it
    to the user in the mini buffer."
  (message "The inductive reactance is %f" (* 2 M_PI f l)))

;; Implement a function to convert degrees to radians
(defun deg2rad (deg)
  "Convert degrees to radians"
  (interactive "nEnter the angle in degrees: ")
  (message "The angle you entered is %f radians" (* deg (/ M_PI 180.0))))

;; Implement a function to convert radians to degrees
(defun rad2deg (rad)
  "Convert radians to degrees"
  (interactive "nEnter the angle in radians: ")
  (message "The angle you entered is %f degrees" (* rad (/ 180.0 M_PI))))

(message "GNU Emacs has been setup with my prefered settings.... enjoy :-)")