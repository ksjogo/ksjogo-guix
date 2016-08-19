.ONESHELL:
.PHONY:
emacsupdate:
	cd upstream/emacs
	git pull
	mv .git /tmp/emacsgittmp
	HASH=`guix hash -r .`
	mv /tmp/emacsgittmp .git
	SRCDIR="`pwd`"
	COMMIT=`git rev-parse HEAD`
	DATE=`date -d @$$(git log -n1 --format="%ct") +%Y%m%d%H%M`
	cd ../../packages/ksjogo
	sed -i.bak -e "s|(url \".*\")|(url \"file://$$SRCDIR\")|g" -e "s|(commit \".*\")|(commit \"$$COMMIT\")|g" -e "s|(base32 \".*\")|(base32 \"$$HASH\")|g" -e "s|(version \".*\")|(version \"$$DATE\")|g"  emacs-master.scm
