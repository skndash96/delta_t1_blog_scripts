#!/bin/bash

userpref="/scripts/userpref.yaml"

authors_base=($(ls -1pd /home/authors/* | grep "/$"))
n_blogs=$(ls -1pd /home/authors/*/public/* | grep -v "/$" | wc -l)
n_users=$(yq ".users | length" "$userpref")
n_authors=${#authors_base[@]}


n=$(( $n_users/$n_blogs ))
if [[ $n -lt 1 ]]; then ((n=1)); fi

map_cu=$(mktemp)
map_ub=$(mktemp)

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

	echo "" > "/home/users/$username/fyi.yaml"
done

echo "$n users per blog, $map_cu"

for author_base in "${authors_base[@]}"; do
	blogs_data_file="${author_base}blogs.yaml" #$author_base includes trailing /
	author=$(echo "$author_base" | cut -c 15-)
	author=${author::-1}

	j=0
	while true; do
		blog=$(yq ".blogs[$j]" "$blogs_data_file")
		if [ "$blog" == "null" ]; then break; fi

		((j=j+1))

		published=$(echo "$blog" | yq -r ".publish_status")
		if [ "$published" == "false" ]; then continue; fi

		file_name=$(echo "$blog" | yq -r ".file_name")
		cat_order=($(echo "$blog" | yq -r ".cat_order[]"))

		_n=0; curr_cat_idx=0; pref_no=1;

		while [ $_n -lt $n ]; do
			cate_no=${cat_order[curr_cat_idx]}
			if [[ -z "$cate_no" ]]; then break; fi

			cate=$(yq -r ".categories.$cate_no" "$blogs_data_file")

			u=$(yq ".$cate.$pref_no.[0]" "$map_cu")

			if [[ "$u" == "null" ]]; then
				if [[ $pref_no == 3 ]]; then
					((curr_cat_idx=curr_cat_idx+1))
					continue
				fi

				((pref_no=pref_no+1))
				continue
			fi

			yq -i "del(.$cate.$pref_no.[0])" "$map_cu"

			cat_order_display=$(IFS=, ; echo -n "${cat_order[*]}")

			sugg="{
				\"file_name\": \"$file_name\",
				\"category\": \"$cate\",
				\"author\": \"$author\"
			}"

			yq -i ".suggestions += [$sugg]" "/home/users/$u/fyi.yaml"

			echo "--> assigned $author $file_name to $u (pref $pref_no, cat $curr_cat_idx)"

			((_n=_n+1))
		done
	done
done

echo "available at $map_ub"
