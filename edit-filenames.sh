#!/bin/bash

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

editor='' # specify text editor here (optional)

old_names="$HOME/.old_names"
new_names="./edit_filenames"

function fatal
{
    printf "$0: error: $1\n"
    exit 1
}

function delete_lists
{
    rm "$old_names" "$new_names" &>/dev/null
}

function create_lists
{
    delete_lists

    if [ $# -eq 0 ]
    then
        files=(*)
    else
        files=("$@")
    fi

    for file in "${files[@]}"
    do
        [ ! -f "$file" ] && continue
        echo "$file" >> "$old_names"
        echo "$file" >> "$new_names"
    done

    if [ -f "$new_names" ]
    then
        echo "You can now edit the file names in ${new_names}, then run this script again to rename the files (arguments will be ignored)."
    else
        fatal 'no files found'
    fi
}

function check_collisions
{
    # check for duplicate entries:
    duplicates="$(sort "$new_names" | uniq --repeated)"
    [[ "$duplicates" != '' ]] && fatal "name collision, duplicates found:\n$duplicates\n\nExit without changes"

    # check for collisions with existing files not subject to renaming:
    while IFS= read new_name
    do
        if [ -f "$new_name" ] && ! grep --quiet --line-regexp --fixed-strings "$new_name" "$old_names"
        then
            fatal "a file named '$new_name' already exists\nExit without changes"
        fi
    done < "$new_names"

    # check if user has renamed or deleted files manually since the script was last run:
    while IFS= read old_name
    do
        [ ! -f "$old_name" ] && fatal "it appears that file '$old_name' has been deleted or renamed since the script was last run\nExit without changes"
    done < "$old_names"
}

function rename_files
{
    readarray -t new_names_arr < "$new_names"
    temp_names=() # temporary names for name swaps

    while IFS= read old_name
    do
        [ ${#new_names_arr[@]} -eq 0 ] && break

        new_name="${new_names_arr[0]}"
        new_names_arr=("${new_names_arr[@]:1}") # remove first element

        [[ "$new_name" == "$old_name" ]] || [[ "$new_name" == '' ]] && continue

        if [ -f "$new_name" ]
        then
            new_name="$new_name"__TEMP__
            temp_names+=("$new_name")
        fi

        mv "$old_name" "$new_name"
    done < "$old_names"

    for temp_name in "${temp_names[@]}"
    do
        mv "$temp_name" "${temp_name%__TEMP__}"
    done
}

if [ ! -f "$new_names" ] || [ ! -f "$old_names" ]
then
    create_lists "$@"
    if [[ "$editor" != '' ]]
    then
        "$editor" "$new_names" || fatal "could not open file with editor '$editor'"
    fi
else
    check_collisions
    read -p "Rename files? (yes/[no]) " choice
    [ "$choice" != "yes" ] && exit 0
    rename_files
    delete_lists
fi
