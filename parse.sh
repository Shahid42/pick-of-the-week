#!bash

for FILE in `ls episodes | sort -n`
do
    NUM=`echo $FILE | grep -oP '\d+'`
    TITLE=`cat episodes/$FILE | pup '.hero-info > h1 > text{}'`
    EP_LINK=`cat episodes/$FILE | pup '.episode-details .fsplyr-poster a json{}' | jq -r '.[0].href'`
    LINKS=`
        cat episodes/$FILE \
        | pup '.split-primary.prose > ul > li json{}' \
        | jq 'map({ description: (if .text then "- \(.text)" else "" end), text: .children[0].text, link: .children[0].href }) | .[]' \
        | jq 'select(.text | test("patreon"; "i") == false)' \
        | jq 'select(.text | test("facebook"; "i") == false)' \
        | jq 'select(.text | test("Smashing Security merchandise"; "i") == false)' \
        | jq -s '.[-5:]'
    `

    #echo
    #echo File: $FILE
    #echo Num: $NUM
    #echo Link: $EP_LINK
    #echo Title: $TITLE
    #echo $LINKS | jq .

    echo
    echo "### [Smashing Security: $TITLE]($EP_LINK)"
    echo
    echo $LINKS | jq -r '.[] | "* [\(.text)](\(.link)) - \(.description)"'
done
