#!/bin/bash

# Defined some useful colors for echo outputs.
# Use BLUE for informational.
BLUE="\033[1;34m"
# Use Green for a successful action.
GREEN="\033[0;32m"
# Use YELLOW for warning informational and initiating actions.
YELLOW="\033[1;33m"
# No Color (used to stop or reset a color).
NC='\033[0m'

# The project directory.
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
>&2 echo -e "${BLUE}Current project dir - ${PROJECT_DIR}${NC}"

# .env-dev loading in the shell
DOT_ENV=.env-dev
DOT_ENV_FILE=${PROJECT_DIR}/${DOT_ENV}
function dotenv() {
    if [ -f "${DOT_ENV_FILE}" ]
    then
        set -a
        [ -f ${DOT_ENV_FILE} ] && . ${DOT_ENV_FILE}
        set +a
        >&2 echo -e "${GREEN}* Override environment variables set from the ${DOT_ENV} file.${NC}"
        >&2 echo -e "${GREEN}* DOT_ENV_FILE set to ${DOT_ENV_FILE}${NC}"
    else
        DOT_ENV_FILE=${PROJECT_DIR}/.env-none
        >&2 echo -e "${YELLOW}Not using a ${DOT_ENV} file${NC}"
    fi
}
# Run dotenv
dotenv

# If environment variables are set, use them. If not, use the defaults.
# Only need defaults for `DOT_ENV_FILE` and `PORT` as they are used in the `start.sh` script.
# All other defaults are set in the `docker-compose.yml` file.
# Setting them here as well so that this script may be used on its own.
export DOT_ENV_FILE=${DOT_ENV_FILE}
export DATABASE_URL=${DATABASE_URL:-postgres://postgres:docker@host.docker.internal/eps_dev}
export ELIXIR_VERSION=${ELIXIR_VERSION:-1.11.3}
export ENCRYPTION_KEYS=${ENCRYPTION_KEYS:-HOqyElOsSB50sZcjhqqkXRxWfLQSB4bGtglXvhqfakQ=}
export MIX_ENV=${MIX_ENV:-dev}
export PORT=${PORT:-4000}
export SECRET_KEY_BASE=${SECRET_KEY_BASE:-ZnfvXfq91z5om0lWqBxlTce32/0vJqReJ8vngKJAtx8hyPIJpKhcZfDt//34oSAw}
