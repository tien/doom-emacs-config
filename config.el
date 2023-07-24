;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Tiến Nguyễn Khắc"
      user-mail-address "tien.nguyenkhac@icloud.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(cond ((doom-font-exists-p "Fira Code") (setq doom-font "Fira Code"))
      ((doom-font-exists-p "SF Mono") (setq doom-font "SF Mono"))
      ((doom-font-exists-p "Ubuntu Mono") (setq doom-font "Ubuntu Mono")))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vibrant)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq doom-themes-treemacs-theme "doom-colors")

(setq evil-normal-state-cursor (list evil-normal-state-cursor "light green")
      evil-visual-state-cursor (list evil-visual-state-cursor "orange"))

(after! tree-sitter (setq +tree-sitter-hl-enabled-modes t))

(setq +format-with-lsp nil)

(defun cut-region (begin end)
  (interactive "r")
  (copy-region-as-kill begin end)
  (delete-region begin end))

(when (string-equal system-type "darwin")
  (map! "s-x" #'cut-region)
  (after! lsp-mode
    (define-key lsp-mode-map (kbd "s-<mouse-1>") #'lsp-find-definition-mouse)))

(add-hook! 'projectile-after-switch-project-hook #'treemacs-add-and-display-current-project)

(map! :after treemacs
      :map treemacs-mode-map
      [mouse-1] #'treemacs-single-click-expand-action)

(after! lsp-ui
  (setq lsp-ui-doc-show-with-mouse t))

(defun add-node-modules-path ()
  (when-let ((search-directory (or (doom-project-root) default-directory))
             (node-modules-parent (locate-dominating-file search-directory "node_modules/"))
             (node-modules-dir (expand-file-name "node_modules/.bin/" node-modules-parent)))
    (make-local-variable 'exec-path)
    (add-to-list 'exec-path node-modules-dir)
    (doom-log ":lang:javascript: add %s to $PATH" (expand-file-name "node_modules/" node-modules-parent))))

(add-hook! '+javascript-npm-mode-hook #'add-node-modules-path)
