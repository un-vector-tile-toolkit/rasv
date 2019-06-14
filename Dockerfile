FROM arm32v7/debian:unstable

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install apt-transport-https ca-certificates &&\
  apt-get -y install build-essential libsqlite3-dev zlib1g-dev &&\
  apt-get -y install curl nodejs npm git
RUN apt-get -y install gcc llvm clang clang-tidy iwyu cppcheck
RUN npm install n -g && n lts && apt-get purge -y nodejs npm
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |\
  apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" |\
  tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get -y install yarn
RUN mkdir -p /tmp/workdir

# Tippecanoe
WORKDIR /tmp/workdir
RUN git clone https://github.com/mapbox/tippecanoe
WORKDIR /tmp/workdir/tippecanoe
RUN make -j2 && make install

# Osmium
WORKDIR /tmp/workdir
RUN apt-get -y install libboost-program-options-dev libbz2-dev libexpat1-dev cmake
RUN git clone https://github.com/mapbox/protozero
RUN git clone https://github.com/osmcode/libosmium
RUN git clone https://github.com/osmcode/osmium-tool
RUN mkdir -p /tmp/workdir/osmium-tool/build
WORKDIR /tmp/workdir/osmium-tool/build
RUN cmake ..
RUN make
RUN ln -s /tmp/workdir/osmium-tool/build/osmium /usr/local/bin/osmium

# GDAL for ogr2ogr
WORKDIR /tmp/workdir
RUN git clone https://github.com/OSGeo/gdal
WORKDIR /tmp/workdir/gdal
RUN ./configure
RUN make
RUN make install

