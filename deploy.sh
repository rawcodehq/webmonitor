#!/bin/bash

# fail on error
set -e

#CONFIG
APP_NAME="webmonitor"
CURRENT_VERSION="$(mix run --eval 'IO.puts Mix.Project.config[:version]')"
SERVER_HOST="webmonitorhq.com"
SERVER_HOME="/opt/www/$APP_NAME"
SERVER_ROOT="/opt/www/$APP_NAME/app"
SERVER_TMP_FILENAME="$SERVER_HOME/$APP_NAME-$CURRENT_VERSION.tar.gz"
RELEASE_TAR="./rel/$APP_NAME/releases/$CURRENT_VERSION/$APP_NAME.tar.gz"

# helpers --------------------
run() {
  echo "local: $@"
  /bin/bash -c "$@"
}

build() {
# local --------------------
# build the release
echo "building release for version $CURRENT_VERSION ..."
run "MIX_ENV=prod mix clean --implode"
run "MIX_ENV=prod mix compile phoenix.digest"
run "MIX_ENV=prod mix release"
}

init(){
  # init code
  build
  echo "initializing remote code"
  echo "copying tarball"
  run "scp ${RELEASE_TAR} ${APP_NAME}@${SERVER_HOST}:${SERVER_TMP_FILENAME}"

cat <<EOS | ssh -T "$APP_NAME@$SERVER_HOST" 'cat - > /tmp/deploy.sh; /bin/bash -l /tmp/deploy.sh'
#!/bin/bash

set -e # fail on first error
# code that runs on the server
run() {
  echo "remote: \$@ ..."
  /bin/bash -c "\$@"
}
# create the app directory
run "mkdir -p $SERVER_ROOT"
# copy the first version of the code
cd $SERVER_ROOT
run "tar -xvf $SERVER_TMP_FILENAME"
# start the app
run "bin/$APP_NAME start"
# make sure it is up by running ping
run "bin/$APP_NAME ping"
EOS
  # TODO: create the systemctl file
}

upgrade(){
  build
  # upgrade code
  echo "upgrading remote code"
  echo "copying tarball"
  run "scp ${RELEASE_TAR} ${APP_NAME}@${SERVER_HOST}:${SERVER_TMP_FILENAME}"

cat <<EOS | ssh -T "$APP_NAME@$SERVER_HOST" 'cat - > /tmp/deploy.sh; /bin/bash -l /tmp/deploy.sh'
#!/bin/bash

set -e # fail on first error
# code that runs on the server
run() {
  echo "remote: \$@ ..."
  /bin/bash -c "\$@"
}
# copy the first version of the code
run "mkdir -p $SERVER_ROOT/releases/$CURRENT_VERSION"
run "mv $SERVER_TMP_FILENAME $SERVER_ROOT/releases/$CURRENT_VERSION/$APP_NAME.tar.gz"
# start the app
cd $SERVER_ROOT
run "bin/$APP_NAME upgrade $CURRENT_VERSION"
# make sure it is up by running ping
run "bin/$APP_NAME ping"
EOS
}

help(){
  echo 'Elixir Deployer'
  echo 'Usage:'
  echo './deploy.sh init'
  echo './deploy.sh deploy'
}

case $1 in
  init )
    init
    ;;
  upgrade )
    upgrade
    ;;
  help )
    help
    ;;
  * )
    help
esac

exit

# remote --------------------
# TODO: run migrations if needed
