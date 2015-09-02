#!/bin/sh -x

if [ -z $LD_LIBRARY_PATH ]
then
    LD_LIBRARY_PATH=/usr/lib/jvm/java-6-openjdk-amd64/jre/lib/amd64/server
else
    LD_LIBRARY_PATH=/usr/lib/jvm/java-6-openjdk-amd64/jre/lib/amd64/server:$LD_LIBRARY_PATH
fi
SIGVERSE_X3DPARSER_CONFIG=/home/fabio/sigverse-2.3.1/share/sigverse/etc/X3DParser.cfg
SIGVERSE_RUNAC=/home/fabio/sigverse-2.3.1/bin/sigrunac
SIGVERSE_DATADIR=/home/fabio/sigverse-2.3.1/share/sigverse/data
export LD_LIBRARY_PATH SIGVERSE_X3DPARSER_CONFIG SIGVERSE_RUNAC SIGVERSE_DATADIR

/home/fabio/sigverse-2.3.1/bin/sigserver $@
