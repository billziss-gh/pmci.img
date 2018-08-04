# Poor Man's CI Images

The repository contains tools that are used to create images for different systems.

```
$ ./imgtool
usage: imgtool source target
```

The main tool in this repository is `imgtool`. This is a transformation tool that applies the target transformation to the source.

The source can be:

- An ISO installer. For example, `FreeBSD-11.2-RELEASE-amd64-disc1.iso`.
- A compressed raw disk image in `.tar.gz` format. For example, `FreeBSD-11.2-RELEASE-amd64-disc1-base.tar.gz`.
- The special value `latest` which means the latest supported installer image.

The target has the syntax `SYSTEM/TYPE`; `SYSTEM` may be one of the supported systems; `TYPE` may be one of the supported image types.

Supported systems are:

- freebsd
- netbsd
- openbsd

Supported image types are:

- `*/base`: the base system image immediately after installation.
- `*/gce`: an image tailored to run in the GCE environment.
- `*/gce-go`: an image tailored to run in the GCE environment that also has Go support.
- `shared/run`: a special target that can be used to run an image for testing purposes.

The `imgtool` script requires [QEMU](https://www.qemu.org) and [Expect](https://en.wikipedia.org/wiki/Expect).

**Example**

Download the installers and create the `gce-go` images for all supported platforms:

```
$ ./imgtool latest freebsd/gce-go
$ ./imgtool latest netbsd/gce-go
$ ./imgtool latest openbsd/gce-go
```
