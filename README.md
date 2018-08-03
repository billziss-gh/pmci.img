# Poor Man's CI Images

The repository contains a script `imgtool` that is used to create images for different systems.

```console
$ ./imgtool
usage: imgtool source target
```

The script accepts `source` and `target` arguments. The `source` argument can be an ISO installer, a compressed raw disk image (`.tar.gz` format) or the special value `latest`. The target represents the image to be created; for example: `freebsd/base` creates the "base" FreeBSD image and `netbsd/gce` creates the "GCE" NetBSD image.

The special target `shared/run` can be used to run an image for testing purposes.

The `imgtool` script requires [QEMU](https://www.qemu.org) and [Expect](https://en.wikipedia.org/wiki/Expect).

Examples:

- **FreeBSD base from latest ISO installer**:
    - `./imgtool latest freebsd/base`
- **NetBSD GCE from previously created base image**:
    - `./imgtool NetBSD-8.0-amd64-base.tar.gz netbsd/gce`
- **OpenBSD base from ISO installer**:
    - `./imgtool ~/Downloads/install63.iso openbsd/gce`
