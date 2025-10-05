# syntax=docker/dockerfile:1.7-labs

# This is a multi-stage Dockerfile:
# - build environment (includes dune and all dependencies for main)
# - build (copy source files and compiles main, resulting in the main executable with all build artefacts)
# - main (just a simple Alpine Linux with the main executable

FROM ocaml/opam:alpine AS dream_build_environment
RUN sudo apk upgrade --no-cache && sudo apk --no-cache add libev
WORKDIR /home/opam
RUN sudo cp /usr/bin/opam-2.4 /usr/bin/opam
RUN opam update && opam upgrade -j 4 -y && opam install -j 4 dune
RUN mkdir /home/opam/src
WORKDIR /home/opam/src
COPY *.opam dune-project /home/opam/src/
RUN opam install . -j 4 --deps-only --with-test

FROM dream_build_environment AS dream_build
COPY --exclude=_build . /home/opam/src
RUN eval $(opam env) && make

FROM alpine AS dream_main
# Install dependencies XXX: RUN apk upgrade --no-cache && apk --no-cache add XXX
RUN apk upgrade --no-cache && apk --no-cache add libev
ENV INTERFACE=0.0.0.0
ENV PORT=80
COPY --from=dream_build /home/opam/src/_build/default/bin/main.exe /main
RUN chmod +x /main
CMD ["/main"]
