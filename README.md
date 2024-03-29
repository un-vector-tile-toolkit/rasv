# rasv: the UN Vector Tile Toolkit for Docker in Raspberry Pi.
![](https://un-vector-tile-toolkit.github.io/signature/logo.png)

# For users
## use
```
docker pull unvt/rasv
docker run -ti --rm unvt/rasv
```

# For developers
## build
First, you may need to enable experimental mode of docker because we are pusing multi-architecture image to Docker Hub.

### with armhf, e.g. Raspberry Pi
```
git clone https://github.com/un-vector-tile-toolkit/rasv
cd rasv
docker login
rake armhf
```

### with amd64
```
git clone https://github.com/un-vector-tile-toolkit/rasv
cd rasv
docker login
rake amd64
docker manifest create --amend unvt/rasv:latest unvt/rasv:armhf unvt/rasv:amd64
docker manifest push unvt/rasv:latest
```

You may need to add `"experimental": "enabled"` to `~/.docker/config.json`. You can `manifest create` in your Raspberry Pi, too. 
