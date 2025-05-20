#!/bin/bash

day=$(date +%A)
date=$(date +%d)
month=$(date +%m)
year=$(date +%y)

if [[ day == "Thursday" ]]; then exit 0; fi # every thurs

if [[ (($date - 7)) -lt 1 ]]; then exit 0; fi # first sat

if [[ $(date -d "next saturday" +%m) != $month ]]; then exit 0; fi # last sat

exit 1;
