#!/bin/bash

logPath=~/$laLogPath

localVersion=$(cat  $logPath/versionLog.json | jq '.commit')
latestVersioninfo=$(git log -1 --pretty=format:'{%n  "commit": "%H",%n  "author": "%an <%ae>",%n  "date": "%ad",%n  "message": "%f"%n}')
latestVersionHash=$latestVersioninfo | jq '.commit'


if [ -z "$localVersion" ]
then
git pull
echo $localVersioninfo > $laLogPath/versionLog.json
else [[ "$localVersion" != "$latestVersionHash" ]]
git pull
fi

