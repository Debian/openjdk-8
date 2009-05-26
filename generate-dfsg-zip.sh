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

# Remove binaries
rm -f \
  $jdkdir/test/sun/management/windows/revokeall.exe \
  $jdkdir/test/sun/management/jmxremote/bootstrap/linux-i586/launcher \
  $jdkdir/test/sun/management/jmxremote/bootstrap/solaris-sparc/launcher \
  $jdkdir/test/sun/management/jmxremote/bootstrap/solaris-i586/launcher

# Remove test sources with questionable license headers.
rm -f \
   $jdkdir/test/java/util/ResourceBundle/Bug4168625Resource3.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4168625Resource3_en_IE.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4165815Test.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4177489_Resource_jf.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4168625Resource3_en_CA.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4168625Getter.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4177489Test.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4168625Resource.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4168625Resource2.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4168625Resource3_en_US.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4083270Test.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4168625Resource3_en.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4177489_Resource.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4168625Test.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4168625Resource2_en_US.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4168625Class.java \
   $jdkdir/test/java/util/Locale/Bug4175998Test.java \
   $jdkdir/test/java/util/ResourceBundle/RBTestFmwk.java \
   $jdkdir/test/java/util/ResourceBundle/TestResource_fr.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4179766Resource.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4179766Getter.java \
   $jdkdir/test/java/util/ResourceBundle/Bug4179766Class.java \
   $jdkdir/test/java/util/ResourceBundle/TestResource.java \
   $jdkdir/test/java/util/ResourceBundle/FakeTestResource.java \
   $jdkdir/test/java/util/ResourceBundle/TestResource_de.java \
   $jdkdir/test/java/util/ResourceBundle/TestBug4179766.java \
   $jdkdir/test/java/util/ResourceBundle/TestResource_fr_CH.java \
   $jdkdir/test/java/util/ResourceBundle/ResourceBundleTest.java \
   $jdkdir/test/java/util/ResourceBundle/TestResource_it.java \
   $jdkdir/test/java/util/Locale/PrintDefaultLocale.java \
   $jdkdir/test/java/util/Locale/LocaleTest.java \
   $jdkdir/test/java/util/Locale/LocaleTestFmwk.java \
   $jdkdir/test/java/util/Locale/Bug4184873Test.java \
   $jdkdir/test/sun/text/resources/LocaleDataTest.java

# Remove J2DBench sources, some of which have questionable license
# headers.
rm -rf \
  $jdkdir/src/share/demo/java2d/J2DBench

# BEGIN Debian/Ubuntu additions

# binary files
rm -f \
  $jdkdir/test/sun/net/idn/*.spp

rm -f \
  $jdkdir/test/java/nio/channels/spi/SelectorProvider/inheritedChannel/lib/linux-i586/libLauncher.so \
  $jdkdir/test/java/nio/channels/spi/SelectorProvider/inheritedChannel/lib/solaris-i586/libLauncher.so \
  $jdkdir/test/java/nio/channels/spi/SelectorProvider/inheritedChannel/lib/solaris-sparc/libLauncher.so \
  $jdkdir/test/java/nio/channels/spi/SelectorProvider/inheritedChannel/lib/solaris-sparcv9/libLauncher.so \
  $jdkdir/test/tools/launcher/lib/i386/lib32/lib32/liblibrary.so \
  $jdkdir/test/tools/launcher/lib/i386/lib32/liblibrary.so \
  $jdkdir/test/tools/launcher/lib/sparc/lib32/lib32/liblibrary.so \
  $jdkdir/test/tools/launcher/lib/sparc/lib32/liblibrary.so \
  $jdkdir/test/tools/launcher/lib/sparc/lib64/lib64/liblibrary.so \
  $jdkdir/test/tools/launcher/lib/sparc/lib64/liblibrary.so

rm -f \
  $jdkdir/test/java/util/Locale/data/deflocale.exe \
  $jdkdir/test/java/util/Locale/data/deflocale.jds3 \
  $jdkdir/test/java/util/Locale/data/deflocale.rhel4 \
  $jdkdir/test/java/util/Locale/data/deflocale.sh \
  $jdkdir/test/java/util/Locale/data/deflocale.sol10 \
  $jdkdir/test/java/util/Locale/data/deflocale.winvista \
  $jdkdir/test/java/util/Locale/data/deflocale.winxp \

# TODO
#$ find $jdkdir -name '*.jar' -o -name '*.class'|grep -v test

# END Debian/Ubuntu additions

# Create new zip with new name.

NEW_ZIP=$(echo $1 | sed -e 's/\.tar.gz/-dfsg.tar.gz/;s/\.zip/-dfsg.tar.gz/')
tar -cz -f $NEW_ZIP $jdkdir

# Remove old unzipped openjdk dir.
#rm -rf $jdkdir
