
tarball=openjdk-6-src-b12-28_aug_2008-dfsg.tar.gz
version=6b12~pre2
cacaotb=cacao-0.99.4~20081010.tar.bz2
base=openjdk-6
#base=cacao-oj6
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
    cp -a $debian_checkout $pkgdir/debian
else
    rm -rf $pkgdir.orig
    mkdir -p $pkgdir.orig
    case "$base" in
      openjdk*)
	cp -p $tarball $pkgdir.orig/ ;;
      cacao*)
	if [ -f $cacaotb ]; then
	    cp -p $cacaotb $pkgdir.orig/
	fi
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
