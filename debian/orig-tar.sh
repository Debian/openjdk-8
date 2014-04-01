#!/bin/sh -e

VERSION=$2
VERSION=8~b132
TAR=../openjdk-8_$VERSION.orig.tar.gz
DIR=openjdk8
BUILDVER=b132

debian/generate_source_tarball.sh jdk8 jdk8-$BUILDVER
debian/generate_source_tarball.sh aarch64-port jdk8-$BUILDVER

mkdir $DIR
mv *.tar.xz $DIR
tar -czvf $TAR $DIR
rm -Rf $DIR $3
