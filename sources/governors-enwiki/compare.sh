#!/bin/bash

cd $(dirname $0)

bundle exec ruby scraper.rb | qsv select provinceLabel,governor,governorLabel,start | qsv rename provinceLabel,governor,name,start | qsv sort -s provinceLabel > scraped.csv
wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv sort -s provinceLabel > wikidata.csv
bundle exec ruby diff.rb | qsv sort -s provincelabel | tee diff.csv

cd ~-
