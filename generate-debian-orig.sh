
tarball=openjdk-6-src-b11-10_jul_2008-dfsg.tar.gz
cacaotb=cacao-0.99.2.tar.bz2
version=6b11
base=openjdk-6
pkgdir=$base-$version
origtar=${base}_${version}.orig.tar.gz

icedtea_checkout=../icedtea6
debian_checkout=openjdk6

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
    rm -f $pkgdir/gcjwebplugin.cc
    cp -a $debian_checkout $pkgdir/debian
else
    rm -rf $pkgdir.orig
    mkdir -p $pkgdir.orig
    cp -p $tarball $pkgdir.orig/
    if [ -f $cacaotb ]; then
	cp -p $cacaotb $pkgdir.orig/
    fi
    tar -c -f - -C $icedtea_checkout . | tar -x -f - -C $pkgdir.orig
    rm -f $pkgdir.orig/gcjwebplugin.cc
    cp -a $pkgdir.orig $pkgdir
    rm -rf $pkgdir.orig/.hg
    cp -a $debian_checkout $pkgdir/debian
fi
