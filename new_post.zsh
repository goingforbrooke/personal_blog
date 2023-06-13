#!/bin/zsh

# Check if the first argument (post title) is provided
if [[ -z $1 ]]; then
  echo "Please provide a post title as the first argument."
  exit 1
fi

# Get the current date in the desired format
date=$(date +'%Y-%m-%d')

# Copy the template MD file
cp post_template.md "content/$1.md"

# Replace instances of POST_TITLE with the provided argument
sed -i "" "s/POST_TITLE/$1/g" "content/$1.md"

# Replace instances of TODAY with the current date
sed -i "" "s/DATE_TODAY/$date/g" "content/$1.md"

echo "Prefilled post template: content/$1.md"
