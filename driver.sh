#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Supply at least one argument'
    exit 1
fi

TESTPID=/tmp/$1.pid
TESTSRV=./$1.exe

rm -f $TESTPID $TESTSRV
urweb -debug -boot -noEmacs "$1" || exit 1

$TESTSRV -q -a 127.0.0.1 &
echo $! >> $TESTPID
sleep 1
## wget http://localhost:8080/Test/main -O -
firefox --new-tab http://localhost:8080/Test/main
sleep 1
kill `cat $TESTPID`
