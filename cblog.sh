#!/bin/bash

author="$1"
blogname="$2"
blogpath="/home/authors/$1/public/$2"

if [[ ! -f "$blogpath" ]]; then
	echo "Blog does not exist. Usage: <command> <authorname> <blogname>"
	exit 1
fi

blogs_data_file="/home/authors/$1/blogs.yaml"
blog_filter=".blogs[] | select(.file_name == \"$blogname\")"

views_file="/home/users/$(whoami)/blog_reads.log"

if [[ ! -f "$views_file" ]]; then
	touch "$views_file"
fi

echo "$blogpath" >> "$views_file"

modified=$(stat "$blogpath" | grep Modify | sed s/Modify/Date/ | cut -c 1-16)

echo "-----"
echo "Blog Name: $blogname"
echo "Author: $author"
echo "$modified"
echo -e "-----\n"

cat "$blogpath"
