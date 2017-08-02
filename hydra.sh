#!/bin/bash

for VAR in {0..2}
do
	NAME=$1+VAR
	cp hydra.sh $NAME.sh
	chmod +x $NAME.sh
	./$NAME.sh
done
