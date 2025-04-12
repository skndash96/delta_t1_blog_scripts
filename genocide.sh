#!/bin/bash

function populate() {
	key=$1
	u=0

	while true
	do
		user=$(yq ".$key[$u]" users.yaml)
		if [[ $user == 'null' ]]; then return; fi

		username=$(echo "$user" | yq ".username")
		name=$(echo "$user" | yq ".name")

		userdel -r "$username"

		echo "$key $username $name"
		((u=u+1))
	done
}

populate users
populate authors
populate mods
populate admins
