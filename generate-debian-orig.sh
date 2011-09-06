#!/bin/sh

tarballs="corba.tar.gz hotspot.tar.gz jaxp.tar.gz jaxws.tar.gz jdk-dfsg.tar.gz langtools-dfsg.tar.gz openjdk.tar.gz"
jamvmtb=jamvm-12d05e620a9fda129925104bc848014f91d971db.tar.gz
tarballdir=b147
version=7~b147-2.0~pre4
base=openjdk-7
pkgdir=$base-$version
origtar=${base}_${version}.orig.tar.gz

icedtea_checkout=icedtea7
debian_checkout=openjdk7

if [ -d $pkgdir ]; then
    echo directory $pkgdir already exists
    exit 1
fi

if [ -d $pkgdir.orig ]; then
    echo directory $pkgdir.orig already exists
    exit 1
fi

if [ -f $origtar ]; then
    echo "Using existing $origtar"
    tar xf $origtar
    if [ -d $pkgdir.orig ]; then
       mv $pkgdir.orig $pkgdir
    fi
    tar -c -f - -C $icedtea_checkout . | tar -x -f - -C $pkgdir
    rm -rf $pkgdir/.hg
else
    echo "Creating new $pkgdir.orig/"
    rm -rf $pkgdir.orig
    mkdir -p $pkgdir.orig
    case "$base" in
      openjdk*)
        for i in $tarballs; do
            cp -p $tarballdir/$i $pkgdir.orig/
        done
        cp -a $tarballdir/drops $pkgdir.orig/
        cp -p $tarballdir/$jamvmtb $pkgdir.orig/
        #cp -a $tarballdir/cacao-*.tar.* $pkgdir.orig/
      ;;
    esac
    tar -c -f - -C $icedtea_checkout . | tar -x -f - -C $pkgdir.orig
    (
      cd $pkgdir.orig
      sh autogen.sh
      rm -rf autom4te.cache
    )
    rm -rf $pkgdir.orig/.hg
    cp -a $pkgdir.orig $pkgdir
fi

echo "Build debian diff in $pkgdir/"
cp -a $debian_checkout $pkgdir/debian
rm -rf $pkgdir/debian/.bzr
(
  cd $pkgdir
  debian/update-shasum.sh
  patch -p1 < debian/patches/icedtea-patch.diff
  sh autogen.sh
  rm -rf autom4te.cache
)
