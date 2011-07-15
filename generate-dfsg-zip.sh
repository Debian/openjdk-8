#!/bin/sh

if [ ! -f "$1" ]; then
  echo "does not exist: $1"
  exit 1
fi

jdkdir=$(tar tf $1 | head -1 | sed 's,/.*,,')
echo $jdkdir

dist=$(lsb_release -is)

# Untar openjdk source zip.
rm -rf openjdk
case "$1" in
  *.zip) unzip -q -x $1 ;;
  *.tar*) tar xf $1;;
esac

# Remove J2DBench sources, some of which have questionable license
# headers.
rm -rf \
  $jdkdir/src/share/demo/java2d/J2DBench

# BEGIN Debian/Ubuntu additions

# binary files
rm -f \
  $jdkdir/test/sun/net/idn/*.spp

rm -rf \
  $jdkdir/test/sun/security/pkcs11/nss/lib/*

rm -f \
  $jdkdir/test/java/util/Locale/data/deflocale.sh \
  $jdkdir/test/java/util/Locale/data/deflocale.rhel5 \
  $jdkdir/test/java/util/Locale/data/deflocale.rhel5.fmtasdefault \
  $jdkdir/test/java/util/Locale/data/deflocale.sol10.fmtasdefault \
  $jdkdir/test/java/util/Locale/data/deflocale.win7 \
  $jdkdir/test/java/util/Locale/data/deflocale.win7.fmtasdefault

# TODO
#$ find $jdkdir -name '*.jar' -o -name '*.class'|grep -v test

# END Debian/Ubuntu additions

# Create new zip with new name.

NEW_ZIP=$(echo $1 | sed -e 's/\.tar.gz/-dfsg.tar.gz/;s/\.zip/-dfsg.tar.gz/')
GZIP=-9v tar -cz -f $NEW_ZIP $jdkdir

# Remove old unzipped openjdk dir.
rm -rf $jdkdir
