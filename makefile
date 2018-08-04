archive.build:
	mix archive.build -o myelin.ez

archive.uninstall:
	mix archive.uninstall myelin --force

archive.install: archive.uninstall archive.build
	mix archive.install myelin.ez --force
