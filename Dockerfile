FROM debian:unstable

# Fundamentals
RUN apt-get update && apt-get -y upgrade &&\
  apt-get install -y curl git gnupg &&\
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg |\
    apt-key add - &&\
  echo "deb https://dl.yarnpkg.com/debian/ stable main" |\
    tee /etc/apt/sources.list.d/yarn.list &&\
  apt-get update &&\
  apt-get -y install \
    apt-transport-https \
    asciinema \
    automake \
    bash-completion \
    build-essential \
    ca-certificates \
    clang \
    clang-tidy \
    cmake \
    cppcheck \
    gcc \
    gdal-bin \
    iwyu \
    libboost-program-options-dev \
    libbz2-dev \
    libexpat1-dev \
    libgles2-mesa-dev \
    libglfw3-dev \
    libsqlite3-dev \
    libtool \
    llvm \
    nano \
    nodejs \
    npm \
    pkg-config \
    ruby \
    sqlite3 \
    tmux \
    vim \
    xvfb \
    yarn \
    zlib1g-dev &&\
  npm install -g npm &&\
  yarn global add pm2 hjson browserify rollup \
    @mapbox/mapbox-gl-style-spec budo &&\
  mkdir -p /tmp/workdir &&\
  # Tippecanoe
  cd /tmp/workdir &&\
  git clone https://github.com/mapbox/tippecanoe &&\
  cd tippecanoe &&\
  make &&\
  make install &&\
  cd .. && rm -rf /tmp/workdir/tippecanoe &&\
  # Osmium
  cd /tmp/workdir &&\
  git clone https://github.com/mapbox/protozero &&\
  git clone https://github.com/osmcode/libosmium &&\
  git clone https://github.com/osmcode/osmium-tool &&\
  mkdir -p /tmp/workdir/osmium-tool/build &&\
  cd /tmp/workdir/osmium-tool/build &&\
  cmake .. &&\
  make &&\
  make install &&\
  cd /tmp/workdir &&\
  rm -rf /tmp/workdir/protozero &&\
  rm -rf /tmp/workdir/libosmium &&\
  rm -rf /tmp/workdir/osmium-tool &&\
  # remove install packages
  apt-get -y remove \
    apt-transport-https \
    automake \
    build-essential \
    clang \
    clang-tidy \
    cmake \
    cppcheck \
    gcc \
    libboost-program-options-dev \
    libbz2-dev \
    libexpat1-dev \
    libgles2-mesa-dev \
    libglfw3-dev \
    libsqlite3-dev \
    llvm \
    zlib1g-dev &&\
  # remove additonal installed dev packages
  apt-get -y autoremove &&\
  rm -rf /var/lib/apt/lists/*

# Maputnik
WORKDIR /root
RUN git clone https://github.com/maputnik/editor &&\
  cd editor &&\
  yarn

# vt-optimizer
WORKDIR /root
RUN git clone https://github.com/ibesora/vt-optimizer &&\
  cd vt-optimizer &&\
  yarn

# END
WORKDIR /root
