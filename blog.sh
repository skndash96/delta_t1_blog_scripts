#!/bin/bash

author=$(whoami)
blogname="$2"
blogpath="/home/authors/$author/blogs/$blogname"
blogs_data_file="/home/authors/$author/blogs.yaml"


function help () {
	cat /scripts/blog.txt
}


function print_categories() {
	out=()

	echo "provide categories order seperated by spaces like '1 2 3'. possible categories are:"

	i=1
	while true; do
		cat_value=$(yq ".categories.$i" "$blogs_data_file")

		if [[ "$cat_value" == "null" ]]; then break; fi

		echo "$i. $cat_value"

		((i=i+1))
	done
}


function new () {
	if [[ -e "$blogpath" ]]; then
		echo "File already exists"
	else
		touch "$blogpath"
		echo "Created file"
	fi


	if [[ -z $(
		yq "
			.blogs[] | select(.file_name == \"$blogname\")
		" "$blogs_data_file"
	) ]]; then
		yq -i "
			.blogs += [{ \"file_name\": \"$blogname\", \"publish_status\": false }]
		" "$blogs_data_file"

		echo "Entry created"
	else
		echo "Entry already exists"
	fi
}


function publish () {
	print_categories
	read -a categories

	joined_categories=$(IFS=','; echo "${categories[*]}")

	if [[ -z $(
		yq "
			.blogs[] | select(.file_name == \"$blogname\")
		" "$blogs_data_file"
	) ]]; then
		new
	fi

	yq -i "
  		(.blogs[] | select(.file_name == \"$blogname\")).publish_status = true |
		(.blogs[] | select(.file_name == \"$blogname\")).cat_order = [$joined_categories] |
		del((.blogs[] | select(.file_name == \"$blogname\")).mod_comment)
	" "$blogs_data_file" 

	chmod o+r "$blogpath"
	ln -sf "$blogpath" "/home/authors/$author/public/$blogname"

	echo "Published"
}



function archive () {
	chmod o-r "$blogpath"
	yq -i "(.blogs[] | select(.file_name == \"$blogname\")).publish_status = false" "$blogs_data_file"
	unlink "/home/authors/$author/public/$blogname"

	echo "Archived"
}



function delete () {
	yq -i "
		del(.blogs[] | select(.file_name == \"$blogname\"))
	" "$blogs_data_file"

	unlink "/home/authors/$author/public/$blogname"

	rm "$blogpath"

	echo "Deleted"
}



function edit_cat () {
	print_categories

	read -a categories

	joined_categories=$(IFS=','; echo "${categories[*]}")

	yq -i "
		(.blogs[] | select(.file_name == \"$blogname\")).cat_order = [$joined_categories]
	" "$blogs_data_file"

	echo "Updated"
}


if [[ $1 == '-h' ]]; then
	help
	exit 0
fi

if [[ $1 == '-n' ]]; then
	new
	exit 0
fi

if [[ -z $blogname ]] || [[ ! -f $blogpath ]]; then
	echo "File does not exist"
	exit 1
fi

if [[ $1 == "-p" ]]; then publish;
elif [[ $1 == "-a" ]]; then archive;
elif [[ $1 == "-d" ]]; then delete;
elif [[ $1 == "-e" ]]; then edit_cat;
else help
fi
