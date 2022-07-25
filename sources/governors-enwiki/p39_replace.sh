#!/bin/zsh

# ./p39_replace.sh <psid>
#
# replaces based on diff.csv

existing=$(qsv search -u -i $1 diff.csv | qsv count)

if [[ $existing != 1 ]]
then
    echo "No unique match for $1 in wikidata.csv:"
    qsv search -u -i $1 wikidata.csv | qsv table
    return
fi

oldqid=$(qsv search -u -i $1 diff.csv | qsv select governor | qsv behead | awk -F'->' '{ print $1 }')
newqid=$(qsv search -u -i $1 diff.csv | qsv select governor | qsv behead | awk -F'->' '{ print $2 }')
chdate=$(qsv search -u -i $1 diff.csv | qsv select start    | qsv behead | awk -F'->' '{ print $2 }')
posqid=$(qsv search -u -i $1 diff.csv | qsv select position | qsv behead)

echo "Replacing $oldqid with $newqid ($(wd label $newqid)) in $posqid as of $chdate"

if [[ $newqid =~ Q ]]
then
    wd aq $1 P582 $chdate
    wd aq $1 P1366 $newqid

    newpsid=$(wd ac $newqid P39 $posqid | jq -r .claim.id | sed -e 's/\$/-/')
    if [[ $newpsid =~ Q ]]
    then
        sleep 1
        wd aq $newpsid P580 $chdate
        wd aq $newpsid P1365 $oldqid
    else
        echo "No valid PSID to add qualifiers to"
    fi
fi


