FROM alpine:latest

LABEL maintainer=""

RUN apk update && apk add bash pcre-dev glib libgcc libc6-compat pixman gcc make automake autoconf flex git python3 ninja musl-dev linux-headers glib-dev meson pixman-dev g++ texinfo
RUN apk add --no-cache --upgrade grep
ENV BUILDROOT /build
ENV PACKAGE package_494

RUN mkdir ${BUILDROOT}
WORKDIR ${BUILDROOT}
RUN git clone https://github.com/g3gg0/${PACKAGE}.git

WORKDIR ${BUILDROOT}/${PACKAGE} &&
RUN mkdir prefix

ENV PREFIX=${BUILDROOT}/${PACKAGE}/prefix
ENV PATH=${PREFIX}/bin:${PATH}
ENV TARGET=tricore

# build binutils
RUN mkdir ${BUILDROOT}/${PACKAGE}/binutils/build
WORKDIR ${BUILDROOT}/${PACKAGE}/binutils/build
RUN CFLAGS=-fcommon ../configure --prefix=${PREFIX} --target=${TARGET} --enable-lto --with-sysroot --disable-nls --disable-werror
RUN make || exit
RUN make install

# build gcc (stage 1)
RUN mkdir ${BUILDROOT}/${PACKAGE}/gcc/build1
WORKDIR ${BUILDROOT}/${PACKAGE}/gcc/build1
RUN ../configure --prefix=${PREFIX} --target=${TARGET} --enable-lto --enable-languages=c --without-headers --with-newlib --enable-interwork --enable-multilib --disable-shared --disable-thread --disable-zlib
RUN make all-gcc || exit
RUN make install-gcc

# build newlib
RUN mkdir ${BUILDROOT}/${PACKAGE}/newlib/build
WORKDIR ${BUILDROOT}/${PACKAGE}/newlib/build
RUN ../configure --prefix=${PREFIX} --target=${TARGET} --disable-newlib-supplied-syscalls
RUN make || exit
RUN make install

# build gcc (stage 2)
RUN mkdir ${BUILDROOT}/${PACKAGE}/gcc/build2
WORKDIR ${BUILDROOT}/${PACKAGE}/gcc/build2
RUN ../configure --prefix=${PREFIX} --target=${TARGET} --enable-lto --enable-languages=c,c++ --with-newlib --enable-interwork --enable-multilib --disable-shared --disable-thread --disable-zlib
RUN make || exit
RUN make install
