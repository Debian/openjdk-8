#!/bin/sh

if [ ! -f "$1" ]; then
  echo "does not exist: $1"
  exit 1
fi

dist=$(lsb_release -is)

# Untar openjdk source zip.
rm -rf openjdk
mkdir openjdk
tar xf $1 -C openjdk

# Remove binaries
rm -f \
  openjdk/jdk/test/sun/management/windows/revokeall.exe \
  openjdk/jdk/test/sun/management/jmxremote/bootstrap/linux-i586/launcher \
  openjdk/jdk/test/sun/management/jmxremote/bootstrap/solaris-sparc/launcher \
  openjdk/jdk/test/sun/management/jmxremote/bootstrap/solaris-i586/launcher

# Remove idl sources with questionable license headers.
rm -f \
  openjdk/corba/src/share/classes/com/sun/tools/corba/se/idl/grammar.idl \
  openjdk/corba/src/share/classes/com/sun/tools/corba/se/idl/first.set \
  openjdk/corba/src/share/classes/com/sun/tools/corba/se/idl/grammar3.idl \
  openjdk/corba/src/share/classes/com/sun/tools/corba/se/idl/follow.set

# Remove test sources with questionable license headers.
rm -f \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4168625Resource3.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4168625Resource3_en_IE.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4165815Test.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4177489_Resource_jf.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4168625Resource3_en_CA.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4168625Getter.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4177489Test.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4168625Resource.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4168625Resource2.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4168625Resource3_en_US.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4083270Test.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4168625Resource3_en.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4177489_Resource.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4168625Test.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4168625Resource2_en_US.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4168625Class.java \
   openjdk/jdk/test/java/util/Locale/Bug4175998Test.java \
   openjdk/jdk/test/java/util/ResourceBundle/RBTestFmwk.java \
   openjdk/jdk/test/java/util/ResourceBundle/TestResource_fr.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4179766Resource.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4179766Getter.java \
   openjdk/jdk/test/java/util/ResourceBundle/Bug4179766Class.java \
   openjdk/jdk/test/java/util/ResourceBundle/TestResource.java \
   openjdk/jdk/test/java/util/ResourceBundle/FakeTestResource.java \
   openjdk/jdk/test/java/util/ResourceBundle/TestResource_de.java \
   openjdk/jdk/test/java/util/ResourceBundle/TestBug4179766.java \
   openjdk/jdk/test/java/util/ResourceBundle/TestResource_fr_CH.java \
   openjdk/jdk/test/java/util/ResourceBundle/ResourceBundleTest.java \
   openjdk/jdk/test/java/util/ResourceBundle/TestResource_it.java \
   openjdk/jdk/test/java/util/Locale/PrintDefaultLocale.java \
   openjdk/jdk/test/java/util/Locale/LocaleTest.java \
   openjdk/jdk/test/java/util/Locale/LocaleTestFmwk.java \
   openjdk/jdk/test/java/util/Locale/Bug4184873Test.java \
   openjdk/jdk/test/sun/text/resources/LocaleDataTest.java

# Remove J2DBench sources, some of which have questionable license
# headers.
rm -rf \
  openjdk/jdk/src/share/demo/java2d/J2DBench

# BEGIN Debian/Ubuntu additions

# patch -p0 < ../corba-idl.diff

# binary files
rm -f \
  openjdk/jdk/test/sun/net/idn/nfscis.spp

if true; then
rm -f \
  openjdk/jdk/test/java/nio/channels/spi/SelectorProvider/inheritedChannel/lib/linux-i586/libLauncher.so \
  openjdk/jdk/test/java/nio/channels/spi/SelectorProvider/inheritedChannel/lib/solaris-i586/libLauncher.so \
  openjdk/jdk/test/java/nio/channels/spi/SelectorProvider/inheritedChannel/lib/solaris-sparc/libLauncher.so \
  openjdk/jdk/test/java/nio/channels/spi/SelectorProvider/inheritedChannel/lib/solaris-sparcv9/libLauncher.so \
  openjdk/jdk/test/tools/launcher/lib/i386/lib32/lib32/liblibrary.so \
  openjdk/jdk/test/tools/launcher/lib/i386/lib32/liblibrary.so \
  openjdk/jdk/test/tools/launcher/lib/sparc/lib32/lib32/liblibrary.so \
  openjdk/jdk/test/tools/launcher/lib/sparc/lib32/liblibrary.so \
  openjdk/jdk/test/tools/launcher/lib/sparc/lib64/lib64/liblibrary.so \
  openjdk/jdk/test/tools/launcher/lib/sparc/lib64/liblibrary.so

rm -f \
  openjdk/jdk/make/tools/winver/bin/winver.exe \
  openjdk/jdk/test/java/util/Locale/data/deflocale.exe \
  openjdk/jdk/test/java/util/Locale/data/deflocale.jds3 \
  openjdk/jdk/test/java/util/Locale/data/deflocale.rhel4 \
  openjdk/jdk/test/java/util/Locale/data/deflocale.sh \
  openjdk/jdk/test/java/util/Locale/data/deflocale.sol10 \
  openjdk/jdk/test/java/util/Locale/data/deflocale.winvista \
  openjdk/jdk/test/java/util/Locale/data/deflocale.winxp \

fi


# has w3c copyright. license to be checked / needs checking after decoding
rm -f \
  openjdk/jdk/test/javax/xml/crypto/dsig/data/xml-stylesheet \
  openjdk/jdk/test/javax/xml/crypto/dsig/data/xml-stylesheet.b64

# TODO
#$ find openjdk -name '*.jar' -o -name '*.class'|grep -v test

rm -f \
  openjdk/corba/src/share/classes/com/sun/tools/corba/se/logutil/lib/jscheme.jar \
  openjdk/corba/src/share/classes/com/sun/tools/corba/se/logutil/lib/jschemelogutil.jar \

rm -rf openjdk/corba/src/share/classes/com/sun/tools/corba/se/logutil/lib

rm -f \
  openjdk/hotspot/agent/kk/src/share/lib/maf-1_0.jar \
  openjdk/hotspot/agent/kk/src/share/lib/jlfgr-1_0.jar \

rm -f \
  openjdk/jdk/src/share/classes/java/lang/instrument/package.html

# END Debian/Ubuntu additions

# Create new zip with new name.

NEW_ZIP=$(echo $1 | sed -e 's/\.tar.gz/-dfsg.tar.gz/')
(cd openjdk && tar -cz -f ../$NEW_ZIP *)

# Remove old unzipped openjdk dir.
rm -rf openjdk
