#!/bin/bash
for FILE in *;
do
	if [[ -f $FILE ]]; then
		newname="${FILE,,}"
		if [[ $FILE != $newname ]]; then
			mv -- "$FILE" "${FILE,,}"
		fi
	fi
done

