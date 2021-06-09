;;; packages.el --- google-calendar layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Markus Johansson <markus.johansson@me.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

(defconst google-calendar-packages
  '(org-gcal
    calfw
    calfw-org))

(defun google-calendar/init-org-gcal ()
  "Initializes org-gcal and adds keybindings for it's exposed functions"
  (use-package org-gcal
    :init
    (progn
      (spacemacs/set-leader-keys
        "agr" 'org-gcal-refresh-token
        "ags" 'org-gcal-sync
        "agf" 'org-gcal-fetch))
    :config
    (setq org-gcal-down-days 90)   ;; Set org-gcal to download events a year in advance
    (add-hook 'after-init-hook 'org-gcal-fetch)
    (add-hook 'kill-emacs-hook 'org-gcal-sync)
    (add-hook 'org-capture-after-finalize-hook 'google-calendar/sync-cal-after-capture)
    (run-with-idle-timer 600 t 'google-calendar/org-gcal-update)))

(defun google-calendar/init-calfw ()
  "Initialize calfw"

  (use-package calfw
    :defer t ;; loaded by calfw-org
    ))

(defun google-calendar/init-calfw-org ()
  (use-package calfw-org
    :commands cfw:open-org-calendar
    :init
    (spacemacs/set-leader-keys
      "agc" 'google-calendar/calfw-view)

    :config
    (evilified-state-evilify-map cfw:calendar-mode-map
      :mode cfw:calendar-mode
      :bindings
      "j"         'cfw:navi-next-item-command
      "k"         'cfw:navi-prev-item-command
      "J" 'cfw:navi-next-week-command
      "K" 'cfw:navi-previous-week-command
      "l"         'cfw:navi-next-day-command
      "h"         'cfw:navi-previous-day-command
      "L" 'cfw:navi-next-month-command
      "H" 'cfw:navi-previous-month-command

      "v" 'cfw:org-open-agenda-day
      "q" 'google-calendar/calfw-restore-windows)))

;;; packages.el ends here
