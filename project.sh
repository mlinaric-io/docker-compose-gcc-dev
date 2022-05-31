#! /bin/bash

if ! (( "$OSTYPE" == "gnu-linux" )); then
  echo "docker-compose-gcc-dev runs only on GNU/Linux operating system. Exiting..."
  exit
fi

###############################################################################
# 1.) Assign variables and create directory structure
###############################################################################

  #PROJECT_NAME is parent directory
  PROJECT_NAME=`echo ${PWD##*/}`
  PROJECT_UID=`id -u`
  PROJECT_GID=`id -g`

############################ CLEAN SUBROUTINE #################################

clean() {
  docker-compose stop
  docker system prune -af --volumes
} 

############################ START SUBROUTINE #################################

start() {

###############################################################################
# 2.) Generate configuration files
###############################################################################

  if [[ ! -f docker-compose.yml ]]; then
    touch docker-compose.yml
    cat <<EOF> docker-compose.yml
    version: "3.8"

    services:
      gcc:
        image: gcc:latest
        user: $PROJECT_UID:$PROJECT_GID
        working_dir: /usr/src/$PROJECT_NAME
        volumes:
          - .:/usr/src/$PROJECT_NAME

EOF
  fi

###############################################################################
# 3.) Compile the source
###############################################################################

  docker-compose run gcc /bin/bash -c "gcc `ls *.c`"
}

"$1"
