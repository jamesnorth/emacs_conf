
(message "Loading keybindings preferences...")

(global-set-key "\C-ca" 'org-agenda)

(global-set-key (kbd "C-,") (lambda() (interactive) (scroll-up 1)))
(global-set-key (kbd "C-.") (lambda() (interactive) (scroll-down 1)))
(global-set-key [f5] 'ibuffer)
(global-set-key [f6] 'find-file)
(global-set-key [f7] 'kill-buffer)

;; smex keybindings
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; rect-mark keybindings
(global-set-key (kbd "C-x r C-SPC") 'rm-set-mark)
(global-set-key (kbd "C-x r C-x")   'rm-exchange-point-and-mark)
(global-set-key (kbd "C-x r C-w")   'rm-kill-region)
(global-set-key (kbd "C-x r M-w")   'rm-kill-ring-save)

(provide 'keybindings)
