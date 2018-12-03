build:
	mix escript.build

release: build
	mkdir -p releases
	cp ./myelin releases
	cp ./myelin releases/myelin-$(shell cat mix.exs | grep -o 'version: "[^"]\+' | sed 's/version: "//')
