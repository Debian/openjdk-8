#! /bin/sh

# powerpc build takes up to 10h (600min)
wait=$(expr 600 \* 60)
ival=$(expr 15 \* 60)
#wait=5
#ival=1

while [ $wait -gt 0 ]; do
    sleep $ival
    if ps x | grep -v grep | egrep -qs '/cc1|jar|java'; then
	echo "compiler/java/jar running ..."
    fi
    wait=$(expr $wait - $ival)
done
