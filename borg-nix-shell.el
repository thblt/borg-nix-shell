;;; borg-nix-shell -- Nix-shell support for building Borg drones

;; Copyright (c) 2017 Thibault Polge <thibault@thb.lt>

;; Author: Thibault Polge <thibault@thb.lt>
;; Homepage: https://github.com/thblt/borg-nix-shell
;; Keywords: tools

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see https://www.gnu.org/licenses.

;;; Commentary:

;; See README.org

;;; Variables:

(defvar borg-nix-shell-build-use-pure-shell
  t
  "Determine if nix-shells should be pure.")

;;; Code:

;;;###autoload
(defun borg-nix-shell-build-command (drone)
  "Return a format string for wrapping a build-step in a nix-shell.

The nix-shell is started with the file at
submodules.DRONE.build-nix-shell-file or the packages at
submodules.DRONE.build-nix-shell-packages.  If none of this is
provided, and the package has no default.nix, it is run with the
-p argument.  If there's a default.nix or shell.nix, no extra
arguments are added."
  (concat "nix-shell "
            (when borg-nix-shell-build-use-pure-shell "--pure ")
            "--run %S "
            (if (car (borg-get drone "build-nix-shell-file"))
                (car (borg-get drone "build-nix-shell-file"))
              (unless (or (file-exists-p (expand-file-name "shell.nix" (borg-worktree drone)))
                          (file-exists-p (expand-file-name "default.nix" (borg-worktree drone))))
                (concat "-p " (car (borg-get drone "build-nix-shell-packages")))))))

(provide 'borg-nix-shell)

;;; borg-nix-shell.el ends here
