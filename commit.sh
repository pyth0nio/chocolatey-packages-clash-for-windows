#!/bin/sh
set -e
export LC_ALL=en_US.utf8

RESET="\e[0m"
BOLD_GREEN="\e[1;32m"

git='git'

which git.exe > /dev/null 2>&1
if [ $? -eq 0 ]; then
    git='git.exe'
fi

mods=`$git status -s | cut -c4- | awk -F'/' '{
if ($2!="")
	print $1
}' | sort | uniq`

for mod in $mods; do
	version=`cat "$mod/$mod.nuspec" | grep -oP '(?<=<version>).+(?=<\/version>)'`
	echo -ne "Update $BOLD_GREEN$mod to v$version$RESET? [Y/n]: "
	read -rn 1 reply
	if [ "$reply" == 'n' ]; then
		echo
		continue
	fi

	$git add "$mod/"
	$git commit -m "$mod: Update to v$version"
done
