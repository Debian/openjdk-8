
tarballs="corba.tar.gz hotspot.tar.gz jaxp.tar.gz jaxws.tar.gz jdk-dfsg.tar.gz langtools.tar.gz openjdk.tar.gz"
tarballdir=b66
version=7b66
cacaotb=cacao-0.99.4.tar.bz2
base=openjdk-7
pkgdir=$base-$version
origtar=${base}_${version}.orig.tar.gz

icedtea_checkout=../icedtea7
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
    cp -a $debian_checkout $pkgdir/debian
fi
