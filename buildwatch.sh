#! /bin/sh

maxwait=$(expr 180 \* 60)
wait=$maxwait
ival=$(expr 30 \* 60)
#ival=3

while [ $wait -gt 0 ]; do
    sleep $ival
    wait=$(expr $wait - $ival)
    state=
    if ps x | grep -v grep | egrep -qs '/cc1|jar|java|gij'; then
	state="compiler/java/jar running ..."
	wait=$maxwait
    fi

    new_quiet=$(ls -l openjdk*/control/build/*/tmp/rt-orig.jar 2>&1 | md5sum)
    if [ "$old_quiet" != "$new_quiet" ]; then
	state="assembling rt.jar ..."
	wait=$maxwait
    fi
    old_quiet=$new_quiet

    new_noisy=$(ls -l mauve_output jtreg_output 2>&1 | md5sum)
    if [ "$old_noisy" != "$new_noisy" ]; then
	wait=$maxwait
    elif [ -n "$state" ]; then
	echo $state
    fi
    old_noisy=$new_noisy
done
