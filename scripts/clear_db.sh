#!/bin/bash

# Defaults
DB_NAME="hg-backend"
MYSQL_USER="root"
MYSQL_PASS="root"
HOST="10.8.0.1"   # default if -d not given

usage() {
  echo "Usage: $0 [-d host:port] [-u mysql_user] [-p mysql_password]"
  echo "Defaults: host=localhost, mysql_user=root, mysql_password=root"
  exit 1
}

while getopts ":d:u:p:" opt; do
  case $opt in
    d) HOST="$OPTARG" ;;
    u) MYSQL_USER="$OPTARG" ;;
    p) MYSQL_PASS="$OPTARG" ;;
    *) usage ;;
  esac
done

SQL_COMMANDS=$(cat <<EOF
DROP DATABASE IF EXISTS \`${DB_NAME}\`;
DROP USER IF EXISTS 'hg-backend'@'%';
FLUSH PRIVILEGES;
EOF
)

echo "🧹 Dropping user 'hg-backend' and database '$DB_NAME' on host '$HOST' as user '$MYSQL_USER'..."

mysql -h "$HOST" -u "$MYSQL_USER" -p"$MYSQL_PASS" -e "$SQL_COMMANDS"

if [ $? -eq 0 ]; then
  echo "✅ Cleanup complete"
else
  echo "❌ Cleanup failed"
fi
