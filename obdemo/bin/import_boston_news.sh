#!/bin/bash

SOURCE_ROOT=`dirname $0`
SOURCE_ROOT=`cd $SOURCE_ROOT/../.. && pwd`
echo Source root is $SOURCE_ROOT

export DJANGO_SETTINGS_MODULE=obdemo.settings

function die {
    echo $@ >&2
    echo Exiting.
    exit 1
}

echo Adding latest events and news...
cd $SOURCE_ROOT/obdemo/obdemo/scrapers
python add_events.py || die
python add_news.py || die
python seeclickfix_retrieval.py || die

# TODO: give these a new schema, avoid duplicates, etc.
# not very useful till i do all that.
#echo Adding police reports...
#python bpdnews_retrieval.py || die

# more feeds from Joel. Local blog news:
python add_news.py "http://search.boston.com/search/api?q=*&sort=-articleprintpublicationdate&scope=blogs&count=250&subject=massachusetts&format=atom"


echo Adding building permits...
cd $SOURCE_ROOT
python ./everyblock/everyblock/cities/boston/building_permits/retrieval.py || die

# TODO: fix traceback:  ebdata.blobs.scrapers.NoSeedYet: You need to add a Seed with the URL 'http://www.cityofboston.gov/news/
#echo Adding press releases...
#python everyblock/everyblock/cities/boston/city_press_releases/retrieval.py || die

# TODO: add attributes per retrieval.py.
#echo Adding restaurant inspections...
#python ./everyblock/everyblock/cities/boston/restaurants/retrieval.py || die

# Aggregates, see ebpub/README.txt
cd $SOURCE_ROOT
python ebpub/ebpub/db/bin/update_aggregates.py
