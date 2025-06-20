#!/bin/bash

# For: com.talentpapers.saiclinic
# Usage: ./pull_saiclinic_db.sh your_database.db

PACKAGE_NAME="com.talentpapers.saiclinic"
DB_NAME="clinic.db"

if [ -z "$DB_NAME" ]; then
  echo "Usage: $0 <database-name.db>"
  exit 1
fi

echo "Pulling '$DB_NAME' from $PACKAGE_NAME..."

ADB_PATH="/data/data/$PACKAGE_NAME/databases/$DB_NAME"

# List available DBs
echo "🗂️ Available DB files:"
adb shell "run-as $PACKAGE_NAME ls databases"

# Pull the DB
adb shell "run-as $PACKAGE_NAME cat $ADB_PATH" > "$DB_NAME"

# Check success
if [ -f "$DB_NAME" ]; then
  echo "✅ Successfully pulled '$DB_NAME' to: $(pwd)/$DB_NAME"
else
  echo "❌ Failed to pull the database file. Make sure it's the correct name and emulator is running."
fi
