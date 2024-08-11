(asdf:defsystem "stumpwm-config"
  :author "garlic0x1"
  :depends-on (:slynk
               :str
               :clx-truetype
               :ttf-fonts
               :dmenu)
  :components ((:module "src"
                :components ((:file "package")
                             (:file "appearance")
                             (:file "music")
                             (:file "modeline")
                             (:file "core")))))
