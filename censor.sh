#!/bin/bash

author="$1"
base="/home/authors/$author/public"
blogs_data_file="$base/blogs.yaml"

for blog in "$base"/*; do
	blogname=$(echo -n "$blog" | cut -c $((${#base}+2))-)

	words=$(grep -i -o -f /scripts/blacklist.txt "$base/$blogname")
	uniq_words=($(echo "$words" | uniq))
	count=$(echo "$words" | wc -w)

	if [[ $count -gt 5 ]]; then
		chmod o-r "$base/blogs/$blogname"

		yq -i "
			(.blogs[] | select(.file_name == \"$blogname\")).publish_status = false |
			(.blogs[] | select(.file_name == \"$blogname\")).mod_comment = \"Found $count blacklisted words\"
		" "$blogs_data_file"

		unlink "/home/authors/$author/public/$blogname"

		echo "ARCHIVED $blogname $count $words"
	fi

	if [[ $count -ge 1 ]]; then
		for word in "${uniq_words[@]}"; do
			echo "$word wow"
		done
		echo "$blogname $count"
	fi
done
