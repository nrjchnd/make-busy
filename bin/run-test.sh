#!/bin/bash
NETWORK=${NETWORK:-"kazoo"}
REOPTS=""
for ARG in "$@"
do
	if [ "${ARG: -4}" == ".php" ]
	then
		FILE=$ARG
	else
		REOPTS="$REOPTS $ARG"
	fi
done
if [ -z $FILE ]
then
	echo Please specify the test file relatively to your tests folder mounted in MakeBusy container
	exit
fi
REEXPORT=""
for var in LOG_CONSOLE CLEAN HUPALL SKIP_REGISTER SKIP_ACCOUNT DUMP_EVENTS LOG_ENTITIES SKIP_SOME_RESPONSE_VARS STACK_TRACE KAZOO_URI
do
	VALUE=$(eval echo \$$var)
	if [ ! -z $VALUE ]
	then
		REEXPORT="$REEXPORT $var=$VALUE"
	fi
done
docker exec makebusy.$NETWORK /bin/bash -c "$REEXPORT ./run-test $REOPTS tests/KazooTests/Applications/$FILE"
