#!/bin/sh -e

VERSION=$2
TAR=../openjdk-8_$VERSION.orig.tar.gz
DIR=openjdk-8

# The aarch64 port isn't kept in sync with the main repo, the last version is hardcoded
AARCH64_VERSION=8u5-b13

rm -f $3

debian/generate_source_tarball.sh jdk8u jdk8u jdk$VERSION
debian/generate_source_tarball.sh aarch64-port jdk8 jdk$AARCH64_VERSION

mkdir $DIR
mv *.tar.xz $DIR
tar -czvf $TAR $DIR
rm -Rf $DIR
