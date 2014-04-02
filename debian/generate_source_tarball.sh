#!/bin/bash

# Generates the 'source tarball' for JDK 8 projects.
#
# Usage: generate_source_tarball.sh repo_name tag
#
# Examples:
#   ./generate_source_tarball.sh jdk8 jdk8-b79
#   ./generate_source_tarball.sh aarch64-port aarch64-${DATE}
#
# This script creates a single source tarball out of the repository
# based on the given tag and removes code not allowed in Debian.
#
# This script was adapted from the java-1.8.0-openjdk package in Fedora

set -e

REPO_NAME="$1"
VERSION="$2"
JDK8_URL=http://hg.openjdk.java.net

if [[ "${REPO_NAME}" = "" ]] ; then
    echo "No repository specified."
    exit -1
fi
if [[ "${VERSION}" = "" ]]; then
    echo "No version/tag specified."
    exit -1;
fi

mkdir -p "${REPO_NAME}"
pushd "${REPO_NAME}"

REPO_ROOT="${JDK8_URL}/${REPO_NAME}/jdk8"

wget "${REPO_ROOT}/archive/${VERSION}.tar.gz"
tar xf "${VERSION}.tar.gz"
rm  "${VERSION}.tar.gz"

mv "jdk8-${VERSION}" jdk8
pushd jdk8

for subrepo in corba hotspot jdk jaxws jaxp langtools nashorn
do
    wget "${REPO_ROOT}/${subrepo}/archive/${VERSION}.tar.gz"
    tar xf "${VERSION}.tar.gz"
    rm "${VERSION}.tar.gz"
    mv "${subrepo}-${VERSION}" "${subrepo}"
done

popd

tar cJf ${REPO_NAME}-${VERSION}.tar.xz jdk8

popd

mv "${REPO_NAME}/${REPO_NAME}-${VERSION}.tar.xz" .

rm -Rf ${REPO_NAME}
