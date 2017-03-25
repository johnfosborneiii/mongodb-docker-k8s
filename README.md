# Overview

- TBD

# Prerequisites

- TBD

# Usage

To build the base and release images, run:

```
hack/build-base-images.sh
```

The script increments version and release information, as well as, builds each image based on the target subdirectory in the `imgs` folder.

For building individual images, run:

### CentOS (base)

```
bin/build-image.sh base
```

### MongoDB Enterprise

```
bin/build-image.sh mongod
```
