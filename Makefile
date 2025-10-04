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
	opam switch create . 
	dune build test-dream.opam
	opam install . --deps-only --with-test

run:
	dune exec bin/main.exe

clean:
	dune clean

test:
	dune runtest

# Rule for creating docker images 

images:
	docker build -f Dockerfile --target build_environment -t build-environment .
	docker build -f Dockerfile --target build -t build .
	docker build -f Dockerfile --target main -t main .

docker-test: images
	docker run -it --rm build make test

docker-run: images
	docker run -it --rm main
