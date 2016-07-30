#! /bin/sh

if [ -z "$APP" ]; then
    export APP=app.js
fi

cd /app

# Logs options:
# --json-logs  for json log output
# --raw-logs   for raw log output
# --color-logs to display color
# --color-logs to display color
# --timestamp  to prefix log with timestamp

# Options:
# --auto-exit : exit PM2 if no app is running or all apps are stopped
#

if [ $SECRET_KEY ]
then
    pm2-docker start $APP --secret $SECRET_KEY --public $PUBLIC_KEY --machine-name $INSTANCE_NAME --auto-exit
elif [ $JSON_LOGS ]
then
    pm2-docker start $APP --auto-exit --json-logs
else
    pm2-docker start $APP --auto-exit
fi
