#!/bin/bash

DB_NAME="hg-backend"
NEW_USER="hg-backend"
NEW_USER_PASSWORD="hg-backend"
HOST="localhost"
MYSQL_USER="root"
PASSWORD="root"

usage() {
  echo "Usage: $0 [-u mysql_user] [-p password] [-d mysql_host:port]"
  echo "Defaults: mysql_user=root, password=root, host=localhost"
  exit 1
}

while getopts ":u:p:d:" opt; do
  case $opt in
    u) MYSQL_USER="$OPTARG" ;;
    p) PASSWORD="$OPTARG" ;;
    d) HOST="$OPTARG" ;;
    *) usage ;;
  esac
done

SQL_COMMANDS=$(cat <<EOF
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${NEW_USER}'@'%' IDENTIFIED BY '${NEW_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${NEW_USER}'@'%';
FLUSH PRIVILEGES;
EOF
)

echo "🔧 Connecting to MySQL at ${HOST} as ${MYSQL_USER}..."

mysql -h "$HOST" -u "$MYSQL_USER" -p"$PASSWORD" -e "$SQL_COMMANDS"

if [ $? -eq 0 ]; then
  echo "✅ Setup complete: DB '$DB_NAME', privileges granted to user '$NEW_USER'"
else
  echo "❌ Setup failed"
fi
