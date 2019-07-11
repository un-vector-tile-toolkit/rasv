# For Raspberry Pi
#FROM arm32v7/debian:unstable
# For other day-to-day environment
FROM debian:unstable

# Fundamentals
RUN apt-get update && apt-get -y upgrade &&\
  apt-get -y install \
    apt-transport-https \
    automake \
    bash-completion \
    build-essential \
    ca-certificates \
    clang \
    clang-tidy \
    cmake \
    cppcheck \
    curl \
    gcc \
    gdal-bin \
    git \
    iwyu \
    libboost-program-options-dev \
    libbz2-dev \
    libexpat1-dev \
    libgles2-mesa-dev \
    libglfw3-dev \
    libsqlite3-dev \
    libtool \
    llvm \
    nodejs \
    npm \
    pkg-config \
    sqlite3 \
    vim \
    xvfb \
    zlib1g-dev
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
RUN git clone https://github.com/mapbox/protozero &&\
  git clone https://github.com/osmcode/libosmium &&\
  git clone https://github.com/osmcode/osmium-tool &&\
  mkdir -p /tmp/workdir/osmium-tool/build &&\
  cd /tmp/workdir/osmium-tool/build &&\
  cmake .. &&\
  make &&\
  make install &&\
  rm -rf /tmp/workdir/protozero &&\
  rm -rf /tmp/workdir/libosmium &&\
  rm -rf /tmp/workdir/osmium-tool

# END
WORKDIR /root
