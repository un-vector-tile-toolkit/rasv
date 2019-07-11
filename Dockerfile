# For Raspberry Pi
FROM arm32v7/debian:unstable
# For other day-to-day environment
# FROM debian:unstable

# Fundamentals
RUN apt-get update && apt-get -y upgrade &&\
  apt-get -y install \
    apt-transport-https \
    ca-certificates \
    build-essential \
    libsqlite3-dev \
    zlib1g-dev \
    curl \
    nodejs \
    npm \
    git \
    vim \
    sqlite3 \
    gcc \
    llvm \
    clang \
    clang-tidy \
    iwyu \
    cppcheck \
    automake \
    libtool \
    pkg-config \
    bash-completion \
    libglfw3-dev \
    libgles2-mesa-dev \
    xvfb
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
RUN git clone https://github.com/mapbox/tippecanoe &&\
  cd tippecanoe &&\
  make &&\
  make install &&\
  cd .. && rm -rf /tmp/workdir/tippecanoe

# Osmium
WORKDIR /tmp/workdir
RUN apt-get -y install \
  libboost-program-options-dev \
  libbz2-dev libexpat1-dev cmake &&\
  git clone https://github.com/mapbox/protozero &&\
  git clone https://github.com/osmcode/libosmium &&\
  git clone https://github.com/osmcode/osmium-tool &&\
  mkdir -p /tmp/workdir/osmium-tool/build &&\
  cd /tmp/workdir/osmium-tool/build &&\
  cmake .. &&\
  make &&\
  make install
#  rm -rf /tmp/workdir/protozero &&\
#  rm -rf /tmp/workdir/libosmium &&\
#  rm -rf /tmp/workdir/osmium-tool

# GDAL for ogr2ogr
WORKDIR /tmp/workdir
RUN git clone https://github.com/OSGeo/PROJ &&\
  cd /tmp/workdir/PROJ &&\
  mkdir -p /tmp/workdir/PROJ/build &&\
  cd /tmp/workdir/PROJ/build &&\
  cmake .. && cmake --build . &&\
  cd /tmp/workdir/PROJ &&\
  ./autogen.sh && ./configure && make && make install &&\
  cd /tmp/workdir &&\
  git clone https://github.com/OSGeo/gdal &&\
  cd /tmp/workdir/gdal/gdal &&\
  ./configure --with-proj=/usr/local && make && make install && ldconfig &&\
  rm -rf /tmp/workdir/PROJ &&\
  rm -rf /tmp/workdir/gdal

# produce-320
WORKDIR /root
RUN git clone https://github.com/un-vector-tile-toolkit/produce-320
RUN git clone https://github.com/hfu/duodecim
WORKDIR /root/produce-320
RUN yarn

# doria TODO
#WORKDIR /root
#RUN git clone https://github.com/un-vector-tile-toolkit/doria
#RUN git clone -b easter https://github.com/hfu/macrostyle
#RUN git clone https://github.com/hfu/unite-sprite
#RUN git clone https://github.com/hfu/fonts
#WORKDIR /root/doria
#RUN apt-get -y install libgles2-mesa-dev libosmesa6-dev mesa-common-dev mesa-utils-extra
#RUN yarn

# END
WORKDIR /root
