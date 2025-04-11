#!/bin/bash

author="$1"

if [[ -z "$1" ]]; then
	echo "Please provide author name as argument 1"
fi

home="/home/authors/$author"
base="$home/public"
blogs_data_file="$home/blogs.yaml"

for blog in "$base"/*; do
	blogname=$(echo -n "$blog" | cut -c $((${#base}+2))-)

	words=$(grep -i -o -f /scripts/blacklist.txt "$base/$blogname")
	uniq_words=($(echo "$words" | uniq))
	count=$(echo "$words" | wc -w)

	if [[ $count -gt 5 ]]; then
		chmod o-r "$home/blogs/$blogname"

		yq -i "
			(.blogs[] | select(.file_name == \"$blogname\")).publish_status = false |
			(.blogs[] | select(.file_name == \"$blogname\")).mod_comment = \"Found $count blacklisted words\"
		" "$blogs_data_file"

		unlink "$base/$blogname"

		echo "ARCHIVED $blogname $count"
	elif [[ $count -ge 1 ]]; then
		sed_file=$(mktemp)

		for word in "${uniq_words[@]}"; do
			echo "s/$word/$(printf %*s ${#word} | tr ' ' '*' )/I" >> "$sed_file"
		done

		sed -i -f "$sed_file" "$home/blogs/$blogname"

		echo "$blogname $count"
	fi
done
