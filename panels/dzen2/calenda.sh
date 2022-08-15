#!/usr/bin/env bash

bgcolor='#292c2b'
selbg='#0087af'
selfg='#EFEFEF'
gray_col='#b2b2b2'
emptybg='#d70000'
fg_col='#efefef'


ORIG_IFS=$IFS
IFS=" " read current_month current_year <<< "$(date +"%m %Y")"
IFS=$ORIG_IFS


screen=1

OPTS="$(getopt -o m:y:s: == "$@")"
eval set -- "$OPTS"


while true; do
	case "$1" in
		-m ) month="$2"; shift 2 ;;
		-y ) year="$2"; shift 2 ;;
		-s ) screen="$2"; shift 2 ;;
		-- ) shift; break ;;
		* ) break ;;
	esac
done


month=${month:-$current_month}
year=${year:-$current_year}

if (( month > 12)); then
  month=1
  ((year++))
fi

if ((month < 1)); then
  month=12
  ((year--))
fi

back="^ca(1, bash calenda.sh -m $((month-1)) -y $year)<^ca()"
next="^ca(1, bash calenda.sh -m $((month+1)) -y $year)>^ca()"

out=$(cal $month $year | sed "1s/^ /$back/; 1s/ $/$next/")
lines=$(echo "$out" | wc -l)

if test "$month" -eq "$current_month" && test "$year" -eq "$current_year"; then
  out=$(echo "$out" | sed "2,$ s/ \($(date +%e)\) /^fg($selfg)^bg($selbg)\1^fg()^bg()/")
fi

echo  "$out" | dzen2 \
  -title-name "calendar" \
  -bg "$bgcolor" \
  -fg "$gray_col" \
  -x "-240" \
  -y 45 \
  -h 30 \
  -l $((lines-1)) \
  -w 240 \
  -fn "-*-tamsyn-bold-*-*-*-17-*-*-*-*-*-*-*" \
  -e "onstart=uncollapse;button3=exit" \
  -ta c \
  -sa c \
  -xs $screen \
  -p &
