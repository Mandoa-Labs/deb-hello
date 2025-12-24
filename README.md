# deb-hello

A simple "Hello World" Debian package written in C with support for multiple architectures.

## Building

### Prerequisites

To build packages for different architectures, you need to install the appropriate cross-compilation toolchains:

```bash
# For ARM (armhf/armv6l)
sudo apt-get install gcc-arm-linux-gnueabihf

# For ARM64
sudo apt-get install gcc-aarch64-linux-gnu

# For i386
sudo apt-get install gcc-i686-linux-gnu

# For amd64
# Native gcc is sufficient
```

### Build Instructions

Set the target architecture in `.env` file, then build:

```bash
# Example: Build for armhf
echo "ARCH=armhf" > .env
echo 'VERSION="1.0.1"' >> .env

make clean
make deb
```

### Install

```bash
sudo dpkg -i hello-world-c_1.0.1_armhf.deb
hello
```

## Supported Architectures

- `armhf` - ARM hard float (32-bit, e.g., Raspberry Pi 2/3)
- `armv6l` - ARM v6 (32-bit, e.g., Raspberry Pi Zero/1, uses same toolchain as armhf)
- `arm64` - ARM 64-bit (e.g., Raspberry Pi 4/5, modern ARM servers)
- `amd64` - x86-64 (64-bit Intel/AMD)
- `i386` - x86 (32-bit Intel/AMD)

