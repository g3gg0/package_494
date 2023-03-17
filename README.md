# package_494
GCC 4.9.4/Binutils 2.20/Newlib1.18 Source code for Tricore Aurix

[Prebuild Mingw Binaries](https://github.com/volumit/tricore_gcc494_mingw_bins)

[Prebuild Linux Binaries](https://github.com/volumit/tricore_gcc494_linux_bins)

There is also a repo with the gcc494->gcc940 migration.
Just if you want to deal with newer c/c++ dialects and newer gcc features.

# Linux Build Instructions
```
#!/bin/bash -vx

export http_proxy=http://host.docker.internal:8080
export https_proxy=http://host.docker.internal:8080


apk update && apk add bash pcre-dev glib libgcc libc6-compat pixman gcc make automake autoconf flex git python3 ninja musl-dev linux-headers glib-dev meson pixman-dev openjdk8 g++
apk add --no-cache --upgrade grep

apt-get update && apt-get install build-essential git flex file texinfo


export BUILDROOT=/build
export PACKAGE=package_494

mkdir ${BUILDROOT}
cd ${BUILDROOT}
git clone https://github.com/bkoppelmann/${PACKAGE}

chmod +x ${BUILDROOT}/${PACKAGE}/newlib/missing
chmod +x ${BUILDROOT}/${PACKAGE}/binutils/missing
chmod +x ${BUILDROOT}/${PACKAGE}/gcc/missing

chmod +x ${BUILDROOT}/${PACKAGE}/newlib/*.sh
chmod +x ${BUILDROOT}/${PACKAGE}/binutils/*.sh
chmod +x ${BUILDROOT}/${PACKAGE}/gcc/*.sh

cd ${PACKAGE}
mkdir prefix
export PREFIX=`pwd`/prefix
export PATH=$PREFIX/bin:$PATH
export TARGET=tricore

# build binutils
cd ${BUILDROOT}/${PACKAGE}/binutils
mkdir build_dir
cd build_dir
../configure --prefix=$PREFIX --target=$TARGET --enable-lto --with-sysroot --disable-nls --disable-werror
make || exit
make install

# gcc (stage1)
cd ${BUILDROOT}/${PACKAGE}/gcc
mkdir build_dir
cd build_dir
../configure --prefix=$PREFIX --target=$TARGET --enable-lto --enable-languages=c --without-headers --with-newlib --enable-interwork --enable-multilib --disable-shared --disable-thread
make all-gcc || exit
make install-gcc

# newlib
cd ${BUILDROOT}/${PACKAGE}/newlib
mkdir build_dir 
cd build_dir
../configure --prefix=$PREFIX --target=$TARGET --disable-newlib-supplied-syscalls
make || exit
make install

# gcc (stage2)
cd ${BUILDROOT}/${PACKAGE}/gcc 
mkdir build_dir
cd build_dir
../configure --prefix=$PREFIX --target=$TARGET --enable-lto --enable-languages=c,c++ --with-newlib --enable-interwork --enable-multilib --disable-shared --disable-thread
make || exit
make install
```
