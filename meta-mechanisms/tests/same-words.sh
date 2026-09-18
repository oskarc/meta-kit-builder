#!/usr/bin/env bash
# same-words.sh BEFORE AFTER — contract-016 T-2. Proves that two versions of a text differ in line breaks and list
# markers only: every run of whitespace is brought to one space, a list marker that opens a line is dropped, and what
# is left must be the same, character for character. Exit 0 when it is; exit 1 with the first place it is not.
# A tool of this repository's tests; it does not travel.
[ -f "$1" ] && [ -f "$2" ] || { echo "usage: same-words.sh BEFORE AFTER" >&2; exit 2; }
flat() { tr -d '\r' < "$1" | sed -e 's/^[[:space:]]*- //' | tr '\n' ' ' | sed -e 's/[[:space:]][[:space:]]*/ /g'; }
a=$(flat "$1"); b=$(flat "$2")
if [ "$a" = "$b" ]; then echo "same words: $(printf '%s' "$a" | wc -c | tr -d ' ') characters, identical once line breaks and list markers are set aside"; exit 0; fi
i=0; n=${#a}; while [ "$i" -lt "$n" ] && [ "${a:$i:1}" = "${b:$i:1}" ]; do i=$((i+1)); done
s=$((i>60 ? i-60 : 0))
echo "DIFFERENT at character $i"; echo "  before: …${a:$s:140}"; echo "  after:  …${b:$s:140}"; exit 1
