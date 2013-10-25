
;; Determine what system I'm running on...
(defvar running-on-linux (string-match "gnu/linux" (symbol-name system-type)))
(defvar running-on-windows (string-match "windows-nt" (symbol-name system-type)))
(defvar running-on-macosx (string-match "darwin" (symbol-name system-type)))

(when running-on-linux
  (message "* --[ Loading James' Wonderful Little Emacs init file on a GNU/Linux system :-) ]--"))

(when running-on-windows
  (message "* --[ Loading James' Wonderful Little Emacs init file on Windows ]--"))

(when running-on-macosx
  (message "* --[ Loading James' Wonderful Little Emacs init file on a Mac... Eh I dont have one? ]--"))

(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

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

(add-to-list 'load-path "~/.emacs.d/pov-mode")
(autoload 'pov-mode "pov-mode" "PoVray scene file mode" t)
(add-to-list 'auto-mode-alist '("\\.pov\\'" . pov-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'" . pov-mode))

(require 'smex)
(smex-initialize)

(require 'rect-mark)

(add-to-list 'load-path "~/.emacs.d/vendor/coffee-mode")
(add-to-list 'load-path "~/.emacs.d/iedit")

(require 'coffee-mode)
(require 'php-mode)
(require 'scratch)
(require 'less-css-mode)
(require 'quickrun)
(require 'iedit)

;; Setup My Info
(setq user-full-name "James North")
(setq user-mail-address "james.n@melectronics.co.uk")

;; I prefer the scroll bar on the right
(display-time-mode 1)
(setq inhibit-startup-screen t)

(setq frame-title-format (list "em:" '(buffer-file-name "%f" "%b")))
(setq icon-title-format (list "GNU Emacs " emacs-version))
(setq initial-scratch-message "")

(blink-cursor-mode t)
(line-number-mode 1)
(column-number-mode 1)
(global-linum-mode 1)
(show-paren-mode 1)

(setq make-backup-files nil)

; Make it so yes-or-no questions answerable with 'y' or 'n'
; Much easier
(fset 'yes-or-no-p 'y-or-n-p)

; XXX: Just trying this out...
(setq scroll-conservatively 10000
      scroll-step 1)

; wrap lines in a tasteful way
(global-visual-line-mode 1)
;(set-default 'truncate-lines t)

; Default Encoding to Use....
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;;;-----------------------------------------------------------------------------
;; Setup the Colour Theme, if we're in a graphic window
;;;-----------------------------------------------------------------------------
(when (display-graphic-p)
  (add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
  (require 'color-theme)
  (color-theme-initialize)
  (color-theme-solarized-dark))

(load "~/.emacs.d/jamesnorth")
(require 'jamesnorth)
(require 'keybindings)

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

;;;-----------------------------------------------------------------------------
;; auto-save every 100 input events or every 15 seconds
;;;-----------------------------------------------------------------------------
(setq auto-save-interval 100)
(setq auto-save-timeout 15)

;;;-----------------------------------------------------------------------------
;;; Turn off annoying Bell
;;;-----------------------------------------------------------------------------
(setq visible-bell t)
(setq ring-bell-function ;; Flash the scroll lock LED for visible-bell instead of flash the screen
      (lambda ()
        (call-process-shell-command "xset led 3; xset -led 3" nil 0 nil)))

;;;-----------------------------------------------------------------------------
;;; Indent the region after yanking
;;;-----------------------------------------------------------------------------
(defadvice yank (after indent-region activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode c-mode c++-mode
                                objc-mode latex-mode plain-tex-mode python-mode))
      (indent-region (region-beginning) (region-end) nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customise C mode a little
(setq-default c-basic-offset 2
          tab-width 4
          indent-tabs-mode t)

;; I prefer spaces instead of tabs... except of course in Makefiles!
(add-hook 'before-save-hook 
          (lambda () 
            (unless (equal major-mode 'makefile-gmake-mode) 
              (progn
                (untabify-buffer)))))

;; Wrapper function needed for Emacs 21 and XEmacs (Emacs 22 offers the more
;; elegant solution of composing a list of lineup functions or quantities with
;; operators such as "add")
(defun google-c-lineup-expression-plus-4 (langelem)
  "Indents to the beginning of the current C expression plus 4 spaces.

This implements title \"Function Declarations and Definitions\"
of the Google C++ Style Guide for the case where the previous
line ends with an open parenthese.

\"Current C expression\", as per the Google Style Guide and as
clarified by subsequent discussions, means the whole expression
regardless of the number of nested parentheses, but excluding
non-expression material such as \"if(\" and \"for(\" control
structures.

Suitable for inclusion in `c-offsets-alist'."
  (save-excursion
    (back-to-indentation)
    ;; Go to beginning of *previous* line:
    (c-backward-syntactic-ws)
    (back-to-indentation)
    (cond
     ;; We are making a reasonable assumption that if there is a control
     ;; structure to indent past, it has to be at the beginning of the line.
     ((looking-at "\\(\\(if\\|for\\|while\\)\\s *(\\)")
      (goto-char (match-end 1)))
     ;; For constructor initializer lists, the reference point for line-up is
     ;; the token after the initial colon.
     ((looking-at ":\\s *")
      (goto-char (match-end 0))))
    (vector (+ 4 (current-column)))))

(defun my-c-mode-hook ()
  (setq c-basic-offset 2)
  (setq tab-width 4)
  (setq indent-tabs-mode t)
  (c-indent-comments-syntactically-p t)
  (c-hanging-braces-alist . ((defun-open after)
                             (defun-close before after)
                             (class-open after)
                             (class-close before after)
                             (inexpr-class-open after)
                             (inexpr-class-close before)
                             (namespace-open after)
                             (inline-open after)
                             (inline-close before after)
                             (block-open after)
                             (block-close . c-snug-do-while)
                             (extern-lang-open after)
                             (extern-lang-close after)
                             (statement-case-open after)
                             (substatement-open after)))
  (comment-column 40)
  (local-set-key (kbd "<return>") 'newline-and-indent)
  (local-set-key (kbd "<linefeed>") 'newline)
  (c-hanging-semi&comma-criteria
   . (c-semi&comma-no-newlines-for-oneline-inliners
      c-semi&comma-inside-parenlist
      c-semi&comma-no-newlines-before-nonblanks))
  (c-indent-comment-alist . ((other . (space . 2))))
  (c-cleanup-list . (brace-else-brace
                     brace-elseif-brace
                     brace-catch-brace
                     empty-defun-braces
                     defun-close-semi
                     list-close-comma
                     scope-operator))
  (c-offsets-alist . ((arglist-intro google-c-lineup-expression-plus-4)
                      (func-decl-cont . ++)
                      (member-init-intro . ++)
                      (inher-intro . ++)
                      (comment-intro . 0)
                      (arglist-close . c-lineup-arglist)
                      (topmost-intro . 0)
                      (block-open . 0)
                      (inline-open . 0)
                      (substatement-open . 0)
                      (statement-cont
                       .
                       (,(when (fboundp 'c-no-indent-after-java-annotations)
                           'c-no-indent-after-java-annotations)
                        ,(when (fboundp 'c-lineup-assignments)
                           'c-lineup-assignments)
                        ++))
                      (label . /)
                      (case-label . +)
                      (statement-case-open . +)
                      (statement-case-intro . +) ; case w/o {
                      (access-label . /)
                      (innamespace . 0)))
;  (font-lock-add-keywords nil
;      '(("^[^\n]\\{80\\}\\(.*\\)$" 1 font-lock-warning-face t)))
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

(defun dos-to-unix ()
  "Cut all the visible ^M from the current buffer"
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

(defun eval-and-replace (value)
  "Evaluates an S-Expression near your cursor and replaces it with it's value"
  (interactive (list (eval-last-sexp nil)))
  (kill-sexp -1)
  (insert (format "%s" value)))

(defun insert-getter-setter (name)
  (interactive "sEnter Property name: ")
  (insert "@property\n")
  (insert (format "def %s(self):\n" name))
  (insert (format "    return self._%s\n" name))
  (insert (format "@%s.setter\n" name))
  (insert (format "def %s(self, value):\n" name))
  (insert (format "    self._%s = value\n\n" name)))

(defun java-insert-constant (name) 
  (interactive "sEnter Constant Name: ")
  (insert "final int " name " = 0;"))

(defun insert-time-stamp ()
  (interactive)
  (insert (format-time-string "%H:%M")))

(defun insert-date-stamp ()
  (interactive)
  (insert (format-time-string "%d-%m-%Y")))

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
