FROM ocaml/opam2:ubuntu-lts
USER root
RUN apt-get update
RUN apt-get install m4 libsundials-dev wget -y
# RUN wget -q http://build.openmodelica.org/apt/openmodelica.asc -O- | sudo apt-key add -
# RUN echo "deb http://build.openmodelica.org/apt bionic stable" > /etc/apt/sources.list.d/openmodelica.list
# RUN apt-get update
# RUN apt-get install omc -y
USER opam
RUN opam install sundialsml ocamlbuild
COPY . ./modelyze
RUN sudo chown -R opam:opam ./modelyze
WORKDIR ./modelyze
RUN opam config exec make
