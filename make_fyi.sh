#!/bin/bash

userpref="/scripts/userpref.yaml"

authors_base=($(ls -1pd /home/authors/* | grep "/$"))
n_blogs=$(ls -1pd /home/authors/*/public/* | grep -v "/$")
n_users=$(yq ".users | length" "$userpref")
n_authors=${#authors_base[@]}


n=$(( $n_users/$n_authors ))
if [[ $n -lt 1 ]]; then ((n=1)); fi

map_cu=$(mktemp)

for ((i=0; i<$n_users; i++)); do
	user=$(yq ".users[$i]" "$userpref")
	username=$(echo "$user" | yq ".username")
	pref1=$(echo "$user" | yq ".pref1")
	pref2=$(echo "$user" | yq ".pref2")
	pref3=$(echo "$user" | yq ".pref3")

	$(yq -i "
		.[\"$pref1\"].1 += [\"$username\"] |
		.[\"$pref2\"].2 += [\"$username\"] |
		.[\"$pref3\"].3 += [\"$username\"]
	" "$map_cu")
done

echo "$n users per blog, $map_cu"

for author_base in "${authors_base[@]}"; do
	blogs_data_file="${author_base}blogs.yaml" #$author includes trailing /

	j=0
	while true; do
		blog=$(yq ".blogs[$j]" "$blogs_data_file")
		if [ "$blog" == "null" ]; then break; fi

		((j=j+1))

		published=$(echo "$blog" | yq -r ".publish_status")
		if [ "$published" == "false" ]; then continue; fi

		file_name=$(echo "$blog" | yq -r ".file_name")
		cat_order=($(echo "$blog" | yq -r ".cat_order[]"))

		echo "doing for $author_base $file_name ${cat_order[@]}"
	done
done
