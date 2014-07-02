#!/bin/bash

# Generates the 'source tarball' for JDK 8 projects.
#
# Usage: generate_source_tarball.sh project_name repo_name tag
#
# Examples:
#   ./generate_source_tarball.sh jdk8 jdk8 jdk8-b79
#   ./generate_source_tarball.sh jdk8u jdk8u jdk8u5-b13
#   ./generate_source_tarball.sh aarch64-port jdk8 aarch64-${DATE}
#
# This script creates a single source tarball out of the repository
# based on the given tag and removes code not allowed in Debian.
#
# This script was adapted from the java-1.8.0-openjdk package in Fedora

set -e

PROJECT_NAME="$1"
REPO_NAME="$2"
TAG="$3"
OPENJDK_URL="http://hg.openjdk.java.net"

if [[ "${PROJECT_NAME}" = "" ]] ; then
    echo "No project specified."
    exit -1
fi
if [[ "${REPO_NAME}" = "" ]] ; then
    echo "No repository specified."
    exit -1
fi
if [[ "${TAG}" = "" ]]; then
    echo "No tag specified."
    exit -1;
fi

mkdir -p "${REPO_NAME}"
pushd "${REPO_NAME}"

REPO_ROOT="${OPENJDK_URL}/${PROJECT_NAME}/${REPO_NAME}"

echo "Downloading the root repository...";
wget "${REPO_ROOT}/archive/${TAG}.tar.gz"
tar xf "${TAG}.tar.gz"
rm  "${TAG}.tar.gz"

mv "${REPO_NAME}-${TAG}" jdk8
pushd jdk8

for subrepo in corba hotspot jdk jaxws jaxp langtools nashorn
do
    echo "Downloading the ${subrepo} repository...";
    wget "${REPO_ROOT}/${subrepo}/archive/${TAG}.tar.gz"
    tar xf "${TAG}.tar.gz"
    rm "${TAG}.tar.gz"
    mv "${subrepo}-${TAG}" "${subrepo}"
done

echo "Removing the embedded copy of libjpeg..."
find jdk/src/share/native/sun/awt/image/jpeg ! -name imageioJPEG.c ! -name jpegdecoder.c -type f -delete

echo "Removing the embedded copy of libpng..."
rm -vr jdk/src/share/native/sun/awt/libpng/*

echo "Removing the embedded copy of libgif..."
rm -vr jdk/src/share/native/sun/awt/giflib/*

echo "Removing the embedded copy of liblcms2..."
rm -vr jdk/src/share/native/sun/java2d/cmm/lcms/cms*
rm -vr jdk/src/share/native/sun/java2d/cmm/lcms/lcms2*

popd

echo "Building tarball ${REPO_NAME}-${TAG}.tar.xz..."
tar cJf ${PROJECT_NAME}-${TAG}.tar.xz jdk8

popd

mv "${REPO_NAME}/${PROJECT_NAME}-${TAG}.tar.xz" .

rm -Rf ${REPO_NAME}
