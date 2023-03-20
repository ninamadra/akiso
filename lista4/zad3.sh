#!/bin/bash

wget -q https://api.thecatapi.com/v1/images/search
name="$(cat search | jq -r '.[] .id').jpg"
url="$(cat search | jq -r '.[] .url')"
#echo $name
wget -q $url

catimg -w 210 -l 1 $name

rm ./search
rm $name
wget -q -O- https://api.chucknorris.io/jokes/random | jq -r '.value'

