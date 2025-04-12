#!/bin/bash

# reset all facl
setfacl -b -R /home/authors/*/public

u=0

while true
do
	mod=$(yq ".mods[$u]" users.yaml)
	if [[ "$mod" == "null" ]]; then break; fi

	mod_username=$(echo "$mod" | yq ".username")

	v=0
	while true
	do
		author_username=$(echo "$mod" | yq ".authors[$v]")
		if [[ "$author_username" == "null" ]]; then break; fi

		dir="/home/authors/$author_username/public"
		setfacl -R -m "u:$mod_username:rwx" "$dir"

		((v=v+1))

		echo "$mod_username -> $author_username"
	done

	((u=u+1))

	echo "$mod_username done"
done

setfacl -R -d -m "g:g_admins:rwx" /home/{users,authors,mods}
