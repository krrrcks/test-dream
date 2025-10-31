NAME = 		test-dream
BUILDDIR = 	_build/default

.PHONY:	$(NAME) pre default all run clean test build-images main-image docker-test docker-run

# Rules for local development (compiling, executing, tests)

default: $(NAME)

$(NAME):
	dune build bin/main.exe

all: default test

pre:
	opam exec dune build test-dream.opam
	opam switch create . 
	opam install . --deps-only --with-test

run:
	dune exec bin/main.exe

clean:
	dune clean

test:
	dune runtest

# Rules for creating and running docker images 

build-images:
	docker build -f Dockerfile --target dream_build_environment -t dream-build-environment .
	docker build -f Dockerfile --target dream_build -t dream-build .

main-image: build-images 
	docker build -f Dockerfile --target dream_main -t dream-main .

docker-test: main-image
	docker run -it --rm dream-build make test

docker-run: main-image
	docker run -it --rm dream-main
