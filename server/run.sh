#!/bin/bash

forever stopall
timestamp=$(date "+%Y.%m.%d-%H.%M.%S")
outlogpath=./logs/out.log
errlogpath=./logs/err.log
outlog=$outlogpath.$timestamp
errlog=$errlogpath.$timestamp
forever -o $outlog -e $errlog start ./bin/www

