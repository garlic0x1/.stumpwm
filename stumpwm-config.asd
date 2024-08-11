(asdf:defsystem "stumpwm-config"
  :author "garlic0x1"
  :depends-on (:slynk
               :clx-truetype
               :ttf-fonts
               ;; :swm-gaps ;; broken
               )
  :components ((:file "package")
               (:file "appearance")
               (:file "modeline")
               (:file "core")))
