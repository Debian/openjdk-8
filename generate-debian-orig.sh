#!/bin/sh

tarballs="corba.tar.gz hotspot-default.tar.gz hotspot-zero.tar.gz jaxp.tar.gz jaxws.tar.gz jdk-dfsg.tar.gz langtools-dfsg.tar.gz openjdk.tar.gz"
jamvmtb=jamvm-0972452d441544f7dd29c55d64f1ce3a5db90d82.tar.gz
cacaotb=
tarballdir=7u13
version=7u13-2.3.6
base=openjdk-7
pkgdir=$base-$version
origtar=${base}_${version}.orig.tar.gz

icedtea_checkout=icedtea7-2.3
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
	if [ -n "$cacaotb" ]; then
          cp -p $tarballdir/$cacaotb $pkgdir.orig/
	fi
        cp -p $tarballdir/$jamvmtb $pkgdir.orig/
      ;;
    esac
    tar -c -f - -C $icedtea_checkout . | tar -x -f - -C $pkgdir.orig
    (
      cd $pkgdir.orig
      sh autogen.sh
      rm -rf autom4te.cache
    )
    cp -a $pkgdir.orig $pkgdir
    rm -rf $pkgdir.orig/.hg
fi

echo "Build debian diff in $pkgdir/"
cp -a $debian_checkout $pkgdir/debian
(
  cd $pkgdir
  debian/update-shasum.sh
  #debian/update-hgrev.sh
  ls
  patch -p0 < debian/patches/icedtea-patch.diff
  sh autogen.sh
  rm -rf autom4te.cache
)
