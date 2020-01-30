(deftheme myample-dark
  "Created 2019-10-07.")

(custom-theme-set-variables
 'myample-dark
 '(sml/theme 'dark)
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1"))

(custom-theme-set-faces
 'myample-dark
 '(aw-background-face ((t (:foreground "grey40"))))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(highlight ((t (:background "dark slate blue"))))
 '(hl-line ((t (:background "gray28"))))
 '(mc/cursor-bar-face ((t (:background "#0093c4" :height 1))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "SeaGreen3"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "RoyalBlue2"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "MediumOrchid1"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "turquoise3"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "DarkOrange2"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "LightGoldenrod2"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "plum2"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "honeydew3"))))
 '(region ((t (:background "cadet blue"))))
 '(show-paren-match ((t (:background "MediumPurple1"))))
 '(highlight-indentation-face ((t :background "#303030")))
 '(highlight-indentation-current-column-face ((t :background "#555555"))))

(provide-theme 'myample-dark)
