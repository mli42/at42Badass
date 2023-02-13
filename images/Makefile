# Makefile to (re)build and clean docker images

all: build

build:
	docker build -f Dockerfile.routeur -t routeur-img ..
	docker build -f Dockerfile.host -t host-img ..

clean:
	yes | docker image prune -a

re: clean all

.PHONY: all build clean re
