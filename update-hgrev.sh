#!/bin/bash

varhgchange=(CORBA_CHANGESET HOTSPOT_CHANGESET JAXP_CHANGESET JAXWS_CHANGESET JDK_CHANGESET LANGTOOLS_CHANGESET OPENJDK_CHANGESET)
# Use same values as download.sh + openjdk one
revisions=(563a8f8b5be3 e9aa2ca89ad6 ab107c1bc4b9 ba1fac1c2083 bdc069d3f910 7a98db8cbfce cc58c11af154)

makefile1=Makefile.am

function update_var() {
    varname=$1
    newsum=$2

    echo "$varname: ${newsum}"
    if [ -f $makefile1 ]; then
        sed -i "s/\(^$varname\)\(..*$\)/\1 = ${newsum}/" $makefile1
    fi
}

# For all modules
for (( i = 0 ; i < ${#varhgchange[@]} ; i++ )); do
   update_var ${varhgchange[$i]} ${revisions[$i]}
done