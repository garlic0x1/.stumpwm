(in-package :stumpwm-config)

(defcommand playerctl () ()
  (let ((sel (dmenu:dmenu :item-list '("play-pause" "next" "previous" "stop")
                          :prompt "Player: ")))
    (run-shell-command (uiop:strcat "playerctl " sel))))

(defun music-data ()
  (destructuring-bind (title album artist)
      (mapcar (lambda (s) (second (ppcre:split "  +" s)))
              (subseq
               (split-string
                (run-shell-command "playerctl metadata" t))
               1 4))
    (list :title title
          :album album
          :artist artist)))
