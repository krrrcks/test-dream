NAME = 		template-docker
BUILDDIR = 	_build/default

.PHONY:	$(NAME) pre default all run clean test 

# Rules for local development (compiling, executing, tests)

default: $(NAME)

$(NAME):
	dune build bin/main.exe

all: default test

pre:
	opam update
	opam exec dune build test-dream.opam
	opam switch create . 
	opam install . --deps-only --with-test

run:
	dune exec bin/main.exe

clean:
	dune clean

test:
	dune runtest

# Rule for creating docker images 

images:
	docker build -f Dockerfile --target dream_build_environment -t dream-build-environment .
	docker build -f Dockerfile --target dream_build -t dream-build .
	docker build -f Dockerfile --target dream_main -t dream-main .

docker-test: images
	docker run -it --rm build make test

docker-run: images
	docker run -it --rm dream-main
