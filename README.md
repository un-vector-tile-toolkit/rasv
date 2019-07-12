# rasv
The UN Vector Tile Toolkit for Docker in Raspberry Pi.

# build
First, you may need to enable experimental mode of docker because we are pusing multi-architecture image to Docker Hub.

## with armhf, e.g. Raspberry Pi
```
git clone https://github.com/un-vector-tile-toolkit/rasv
cd rasv
rake amdhf
docker login
docker push unvt/rasv:armhf
```

## with amd64
```
git clone https://github.com/un-vector-tile-toolkit/rasv
cd rasv
rake amd32
docker login
docker push unvt/rasv:amd64
docker manifest create --amend unvt/rasv:latest unvt/rasv:armhf unvt/rasv:amd64
```

# use
```
docker pull unvt/rasv
docker run -ti --rm unvt/rasv
```

