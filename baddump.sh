#!/bin/sh

usage() {
	echo "usage: baddump.sh <PID>"
}

check_for_required_binary() {
	if [ "$(command -v $1)" = "" ]; then
		echo "missing $1, exiting"
		exit 1
	fi
}
check_for_required_binary "dd"
check_for_required_binary "bc"
check_for_required_binary "echo"
check_for_required_binary "wc"
check_for_required_binary "head"
check_for_required_binary "tail"
check_for_required_binary "cut"
check_for_required_binary "tr"

if [ "$#" -lt 1 ]; then
	usage
	exit 1
fi
PROC_PID=$1

MAPS=$(cat /proc/$PROC_PID/maps)
MAPS_LINE_COUNT=$(echo "$MAPS" | wc -l)


LINE_IND=0
while [ $LINE_IND -ne $MAPS_LINE_COUNT ]; do
	TAIL_IND=$(($MAPS_LINE_COUNT - $LINE_IND))
	# echo "tail ind $TAIL_IND"
	# super hacky method of getting an index into a newline delimited string
	LINE_CONT=$(echo "$MAPS" | tail -n $TAIL_IND | head -n1 | tr -s ' ')
	# tr needed to make values work with bc
	REGION_START=$(echo "$LINE_CONT" | cut -d '-' -f1 )
	REGION_START_UPPERCASE=$(echo "$REGION_START" | tr 'a-f' 'A-F')
	REST=$(echo "$LINE_CONT" | cut -d '-' -f2-)
	REGION_END=$(echo "$REST" | cut -d ' ' -f1)
	REGION_END_UPPERCASE=$(echo "$REST" | cut -d ' ' -f1 | tr 'a-f' 'A-F')
	REGION_START_BASE10=$(echo "ibase=16; $REGION_START_UPPERCASE" | bc)
	REGION_SIZE_BASE10=$(echo "ibase=16; $REGION_END_UPPERCASE-$REGION_START_UPPERCASE" | bc)
	echo "dumping '$LINE_CONT'"
	OUTFILE="${PROC_PID}.${REGION_START}-${REGION_END}.dump"
	echo "dumping to $OUTFILE"
	dd if=/proc/$PROC_PID/mem skip=$REGION_START_BASE10 bs=1 count=$REGION_SIZE_BASE10 of="$OUTFILE"
	# of="${PROC_PID}.dump"  oflag=append conv=notrunc
	LINE_IND=$(($LINE_IND+1))
done

echo "$MAPS" > "$PROC_PID.maps"
