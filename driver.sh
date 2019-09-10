#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Supply at least one argument'
    exit 1
fi

TESTPID=/tmp/$1.pid
TESTSRV=./$1.exe
TESTCAP="$(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})${1:1}"

rm -f $TESTPID $TESTSRV
urweb -debug -boot -noEmacs "$1" || exit 1

$TESTSRV -q -a 127.0.0.1 &
echo $! >> $TESTPID
## wget http://localhost:8080/$TESTCAP/main -O -
firefox --new-tab http://localhost:8080/$TESTCAP/main
sleep 1
if [[ $# -eq 1 ]] ; then
    sleep 1
    kill `cat $TESTPID`
fi
