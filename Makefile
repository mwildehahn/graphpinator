.PHONY: build test hh_autoload format

build:
	docker build -t mwildehahn/graphpinator .

install: build
	docker run -v `pwd`:/app -it mwildehahn/graphpinator composer install

hh_autoload:
	docker run -v `pwd`:/app -it mwildehahn/graphpinator ./vendor/bin/hh-autoload

test:
	docker run -v `pwd`:/app -it mwildehahn/graphpinator ./vendor/bin/hacktest tests

format:
	docker run -v `pwd`:/app -it mwildehahn/graphpinator find {src,tests} -type f -exec hackfmt -i {} \;