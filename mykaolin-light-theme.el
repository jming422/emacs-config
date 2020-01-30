(deftheme mykaolin-light
  "Created 2019-10-07.")

(custom-theme-set-variables
 'mykaolin-light
 '(sml/theme 'respectful))

(custom-theme-set-faces
 'mykaolin-light
 '(aw-background-face ((t . (:weight normal))))
 '(highlight ((t (:background "LightSteelBlue1"))))
 '(mc/cursor-bar-face ((t (:background "LightBlue2" :height 1))))
 '(mode-line-inactive ((t :foreground "grey20" :background "LightSteelBlue2" :inverse-video nil)))
 '(mode-line     ((t :foreground "black" :background "LightBlue2" :inverse-video nil)))
 '(highlight-indentation-face ((t :background "#CCCCCC")))
 '(highlight-indentation-current-column-face ((t :background "#E0E0E0")))
 '(ediff-current-diff-A ((t :background "#E38789")))
 '(ediff-current-diff-B ((t :background "#99E5BF")))
 '(ediff-current-diff-C ((t :background "#A0CBCB"))))

(provide-theme 'mykaolin-light)
