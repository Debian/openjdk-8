#!/bin/sh

tarballs="corba.tar.gz hotspot.tar.gz jaxp.tar.gz jaxws.tar.gz jdk-dfsg.tar.gz langtools.tar.gz openjdk.tar.gz"
tarballs="corba.tar.gz hotspot.tar.gz jaxp.tar.gz jaxws.tar.gz jdk.tar.gz langtools.tar.gz openjdk.tar.gz"
jamvmtb=jamvm-a95ca049d3bb257d730535a5d5ec3f73a943d0aa.tar.gz
tarballdir=b136
version=7~b136-1.14~pre0
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
    tar xf $origtar
    if [ -d $pkgdir.orig ]; then
       mv $pkgdir.orig $pkgdir
    fi
    tar -c -f - -C $icedtea_checkout . | tar -x -f - -C $pkgdir
    cp -a $debian_checkout $pkgdir/debian
else
    rm -rf $pkgdir.orig
    mkdir -p $pkgdir.orig
    case "$base" in
      openjdk*)
        for i in $tarballs; do
            cp -p $tarballdir/$i $pkgdir.orig/
        done
        cp -a $tarballdir/drops $pkgdir.orig/
	#cp -p $jamvmtb $pkgdir.orig/
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
    cp -a $debian_checkout $pkgdir/debian
fi
