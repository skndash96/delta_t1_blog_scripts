#!/bin/bash

u=0

while true
do
	user=$(yq ".users[$u]" users.yaml)
	if [[ "$user" == "null" ]]; then break; fi

	username=$(echo "$user" | yq ".username")

	v=0

	while true
	do
		author=$(yq ".authors[$v]" users.yaml)
		if [[ "$author" == "null" ]]; then break; fi

		authorusername=$(echo "$author" | yq ".username")

		ln -sfn "/home/authors/$authorusername/public" "/home/users/$username/all_blogs/$authorusername"

		echo "$authorusername -> $username"

		((v=v+1))
	done

	((u=u+1))
done
