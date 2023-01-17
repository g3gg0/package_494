# package_494
GCC 4.9.4/Binutils 2.20/Newlib1.18 Source code for Tricore Aurix

[Prebuild Mingw Binaries](https://github.com/volumit/tricore_gcc494_mingw_bins)

[Prebuild Linux Binaries](https://github.com/volumit/tricore_gcc494_linux_bins)

There is also a repo with the gcc494->gcc940 migration.
Just if you want to deal with newer c/c++ dialects and newer gcc features.

# Linux Build Instructions
```
mkdir prefix
export PREFIX=`pwd`/prefix
export PATH=$PREFIX/bin:$PATH
export TARGET=tricore

# build binutils
cd binutils
mkdir build && cd build
../configure --prefix=$PREFIX --target=$TARGET --enable-lto --with-sysroot --disable-nls --disable-werror
make
make install

# gcc (stage1)
cd gcc
mkdir build1 && cd build1
../configure/--prefix=$PREFIX --target=$TARGET --enable-lto --enable-languages=c --without-headers --with-newlib --enable-interwork  --enable-multilib --disable-shared --disable-thread
make all-gcc
make install-gcc

# newlib
cd newlib
mkdir build && cd build
../configure --prefix=$PREFIX --target=$TARGET --disable-newlib-supplied-syscalls
make
make install

# gcc (stage2)
cd gcc 
mkdir build2 && cd build2
../configure/--prefix=$PREFIX --target=$TARGET --enable-lto --enable-languages=c,c++ --with-newlib --enable-interwork  --enable-multilib --disable-shared --disable-thread
make
make install
```
