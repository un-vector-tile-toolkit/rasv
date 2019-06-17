# For Raspberry Pi
FROM arm32v7/debian:unstable
# For other day-to-day environment
# FROM debian:unstable

# Fundamentals
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install apt-transport-https ca-certificates &&\
  apt-get -y install build-essential libsqlite3-dev zlib1g-dev &&\
  apt-get -y install curl nodejs npm git vim sqlite3
RUN apt-get -y install gcc llvm clang clang-tidy iwyu cppcheck
RUN apt-get -y install automake libtool pkg-config bash-completion
RUN apt-get -y install libglfw3-dev libgles2-mesa-dev xvfb
RUN git clone https://github.com/nodenv/nodenv.git /root/.nodenv &&\
  git clone https://github.com/nodenv/node-build.git /root/.nodenv/plugins/node-build &&\
  git clone https://github.com/nodenv/nodenv-package-rehash.git /root/.nodenv/plugins/nodenv-package-rehash &&\
  git clone https://github.com/nodenv/nodenv-update.git /root/.nodenv/plugins/nodenv-update
ENV PATH /root/.rbenv/shims:/root/.rbenv/bin:/root/.nodenv/shims:/root/.nodenv/bin:$PATH
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |\
  apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" |\
  tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get -y install yarn
RUN yarn global add pm2
RUN mkdir -p /tmp/workdir

# Tippecanoe
WORKDIR /tmp/workdir
RUN git clone https://github.com/mapbox/tippecanoe
WORKDIR /tmp/workdir/tippecanoe
RUN make && make install

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
RUN git clone https://github.com/OSGeo/PROJ
WORKDIR /tmp/workdir/PROJ
RUN mkdir -p /tmp/workdir/PROJ/build
WORKDIR /tmp/workdir/PROJ/build
RUN cmake .. && cmake --build .
WORKDIR /tmp/workdir/PROJ
RUN ./autogen.sh && ./configure && make && make install
WORKDIR /tmp/workdir
RUN git clone https://github.com/OSGeo/gdal
WORKDIR /tmp/workdir/gdal/gdal
RUN ./configure --with-proj=/usr/local && make && make install && ldconfig

# produce-320
WORKDIR /root
RUN git clone https://github.com/un-vector-tile-toolkit/produce-320
RUN git clone https://github.com/hfu/duodecim
WORKDIR /root/produce-320
RUN yarn

# doria
WORKDIR /root
RUN git clone https://github.com/un-vector-tile-toolkit/doria
RUN git clone -b easter https://github.com/hfu/macrostyle
RUN git clone https://github.com/hfu/unite-sprite
RUN git clone https://github.com/hfu/fonts
WORKDIR /root/doria
RUN yarn

