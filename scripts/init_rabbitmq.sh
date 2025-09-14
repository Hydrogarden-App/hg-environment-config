#!/bin/bash

# Defaults
ADMIN_USER="guest"
ADMIN_PASS="guest"
NEW_USER="wwiktor-remote"
NEW_USER_PASS=""
VHOST="/"

RABBITMQCTL="rabbitmqctl.bat"

usage() {
  echo "Usage: $0 [-u admin_user] [-w admin_pass] [-n new_user] [-p new_user_pass]"
  echo "Defaults:"
  echo "  admin_user=guest"
  echo "  admin_pass=guest"
  echo "  new_user=wwiktor-remote"
  echo "  new_user_pass=defaults to new_user"
  exit 1
}

while getopts ":u:w:n:p:" opt; do
  case $opt in
    u) ADMIN_USER="$OPTARG" ;;
    w) ADMIN_PASS="$OPTARG" ;; # Not used in rabbitmqctl
    n) NEW_USER="$OPTARG" ;;
    p) NEW_USER_PASS="$OPTARG" ;;
    *) usage ;;
  esac
done

if [ -z "$NEW_USER_PASS" ]; then
  NEW_USER_PASS="$NEW_USER"
fi

echo "🔧 Creating RabbitMQ user '$NEW_USER' with password '$NEW_USER_PASS'..."

if "$RABBITMQCTL" list_users | grep -q "^$NEW_USER\s"; then
  echo "ℹ️  User '$NEW_USER' already exists"
else
  "$RABBITMQCTL" add_user "$NEW_USER" "$NEW_USER_PASS"
  echo "✅ User '$NEW_USER' created"
fi

"$RABBITMQCTL" set_permissions -p "$VHOST" "$NEW_USER" ".*" ".*" ".*"

if [ $? -eq 0 ]; then
  echo "✅ Permissions granted to '$NEW_USER' on vhost '$VHOST'"
else
  echo "❌ Failed to set permissions"
fi
