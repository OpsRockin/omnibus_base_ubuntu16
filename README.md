# omnibus_base_ubuntu16

https://hub.docker.com/r/opsrock/omnibus_base_ubuntu16/

## Omnibus by Docker Bros.

- https://github.com/OpsRockin/omnibus_base_ubuntu16
- https://github.com/OpsRockin/omnibus_base_centos8

### Auto build policies

build via IFTTT.

- gem omnibus master branch updated.
- gem omnibus-software master branch updated.
- cookbook omnibus new version released.


## Usage

First, create empty `Dockerfile` for your omnibus-project.

for `*.deb`, `Dockerfile.ubuntu1604`.

```
FROM opsrock/omnibus_base_ubuntu16
MAINTAINER you
```

for `*.rpm`, `Dockerfile.centos8`.

```
FROM opsrock/omnibus_base_centos8
MAINTAINER you
```

## Build once to execute ONBUILD

```
## DEB
$ docker build -t omnibus_myproject-ubuntu1604 -f Dockerfile.ubuntu1604 .

## RPM
$ docker build -t omnibus_myproject-centos8 -f Dockerfile.centos8 .
```

## Run to create package!

Run with passing your project name via env `OMNIBUS_PROJECT`.

```
## DEB
$ docker run -e OMNIBUS_PROJECT=serverspec -v pkg:/home/omnibus/omnibus-project/pkg omnibus_myproject-ubuntu1604

## RPM
$ docker run -e OMNIBUS_PROJECT=serverspec -v pkg:/home/omnibus/omnibus-project/pkg omnibus_myproject-centos8
```

Packages will be created in `./pkg/` directory.


## Tips

### Recycle build cache

mount cache volume and pass path of cache via env.

`-e BUILD_CACHE_PATH=YOUR_CACHE_PATH`


