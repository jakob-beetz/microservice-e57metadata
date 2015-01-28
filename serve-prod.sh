#!/bin/sh

SERVICENAME="e57metadata"
INDEXFILE="app.js"
FOLDER="src"

(cd $FOLDER; pm2 delete $SERVICENAME; pm2 start $INDEXFILE -x --name $SERVICENAME -- --prod)
