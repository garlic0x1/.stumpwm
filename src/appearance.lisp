(in-package :stumpwm-config)

(setf *input-window-gravity* :top
      *message-window-gravity* :top
      ;; emacs had a large border for some reason
      stumpwm::*window-border-style* :thin)

;; Tell clx-truetype about the fonts you have installed. You really
;; only need to do this once, but putting it here means you will not
;; forget in the future.
(xft:cache-fonts)
(set-font (make-instance 'xft:font
                         :family "DejaVu Sans Mono"
                         :subfamily "Book"
                         :size 14))

;; this shit broken
;; ;; Head gaps run along the 4 borders of the monitor(s)
;; (setf swm-gaps:*head-gaps-size* 0)

;; ;; Inner gaps run along all the 4 borders of a window
;; (setf swm-gaps:*inner-gaps-size* 4)

;; ;; Outer gaps add more padding to the outermost borders of a window (touching
;; ;; the screen border)
;; (setf swm-gaps:*outer-gaps-size* 4)
