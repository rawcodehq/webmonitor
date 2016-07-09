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
build() {
# local --------------------
# build the release
echo "building release for version $CURRENT_VERSION ..."
MIX_ENV=prod mix clean --implode 2>&1 >> ./build.log
MIX_ENV=prod mix compile phoenix.digest 2>&1 >> ./build.log
MIX_ENV=prod mix release 2>&1 >> ./build.log
}

init(){
  # init code
  build
  echo "initializing remote code"
  echo "copying tarball"
  scp ${RELEASE_TAR} ${APP_NAME}@${SERVER_HOST}:${SERVER_TMP_FILENAME}

cat <<EOS | ssh -T "$APP_NAME@$SERVER_HOST" 'cat - > /tmp/deploy.sh; /bin/bash -l /tmp/deploy.sh'
#!/bin/bash

set -e # fail on first error
# code that runs on the server
# create the app directory
mkdir -p $SERVER_ROOT
# copy the first version of the code
cd $SERVER_ROOT
tar -xvf $SERVER_TMP_FILENAME
# start the app
bin/$APP_NAME start
# make sure it is up by running ping
bin/$APP_NAME ping
EOS
  # TODO: create the systemctl file
}

upgrade(){
  build
  # upgrade code
  echo "upgrading remote code"
  echo "copying tarball"
  echo "scp ${RELEASE_TAR} ${APP_NAME}@${SERVER_HOST}:${SERVER_TMP_FILENAME}"
  scp ${RELEASE_TAR} ${APP_NAME}@${SERVER_HOST}:${SERVER_TMP_FILENAME}

  echo "running the upgrade script"
cat <<EOS | ssh -T "$APP_NAME@$SERVER_HOST" 'cat - > /tmp/deploy.sh; /bin/bash -l /tmp/deploy.sh'
#!/bin/bash

set -e # fail on first error
# code that runs on the server
# copy the first version of the code
mkdir -p $SERVER_ROOT/releases/$CURRENT_VERSION
mv $SERVER_TMP_FILENAME $SERVER_ROOT/releases/$CURRENT_VERSION/$APP_NAME.tar.gz
# start the app
cd $SERVER_ROOT
source /opt/www/webmonitor/env && RELX_REPLACE_OS_VARS=true bin/$APP_NAME command Elixir.Release.Tasks migrate
bin/$APP_NAME upgrade $CURRENT_VERSION
# make sure it is up by running ping
bin/$APP_NAME ping
EOS
}

help(){
  echo 'Elixir Deployer'
  echo 'Usage:'
  echo './deploy.sh init'
  echo './deploy.sh upgrade'
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
