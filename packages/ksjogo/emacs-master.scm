(define-module (ksjogo emacs-master)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix monads)
  #:use-module (guix store)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system emacs)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages lesstif)
  #:use-module (gnu packages image)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages w3m)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages acl)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages scheme)
  #:use-module (gnu packages statistics)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages mp3)
  #:use-module (guix utils)
  #:use-module (srfi srfi-1)
  #:use-module (gnu packages emacs))

(define-public emacs-master
  ;; This is the updated master version for emacs
  (package (inherit emacs)
           (version "201608182129")
           (name "emacs-master")
           (source (origin
                     (method git-fetch)
                     (uri (git-reference
                           (url "git://git.savannah.gnu.org/emacs.git")
                           (commit "8fcf3df9395a3b1196fd5c95aeebba9e75f69247")))
                     (sha256
                      (base32 "1d7hmnwhdc6msq0v606i3by24dh74bdscjq7mslwv4w89x1lnvw9"))
                     (patches (search-patches "emacs-exec-path.patch"
                                              ;;"emacs-fix-scheme-indent-function.patch"
                                              ;;"emacs-source-date-epoch.patch"
                                              ))
                     (modules '((guix build utils)))))
           (native-inputs
            `(("autoconf" ,autoconf)
              ("automake" ,automake)
              ,@(package-native-inputs emacs)))

           (arguments
            (substitute-keyword-arguments
                `(#:parallel-build? #t
                                    #:tests? #f
                                    #:configure-flags '("--with-modules")
                                    ,@(package-arguments emacs))
              ((#:phases phases)
               `(modify-phases ,phases
                  (add-after 'unpack 'autogen
                    (lambda _
                      (zero? (system* "sh" "autogen.sh"))))))))))
