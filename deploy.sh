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

init(){
  # init code
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
  help )
    help
    ;;
  * )
    help
esac

exit

#TMP_TAR_LOCATION=
#RELEASE_TAR_LOCATION


# local --------------------
# build the release
echo "building release for version $CURRENT_VERSION ..."
run "MIX_ENV=prod mix clean --implode"
run "MIX_ENV=prod mix compile phoenix.digest"
run "MIX_ENV=prod mix release"
# scp tarball to the server
SCP_DEST="$SERVER:$SERVER_ROOT/tmp/$APP_NAME-$CURRENT_VERSION.tar.gz"
#SCP_DEST="$SERVER:$SERVER_ROOT/releases/$CURRENT_VERSION/$APP_NAME.tar.gz"
run "scp $RELEASE_TAR $SCP_DEST"

# remote --------------------
# run migrations if needed
# run `app upgrade` if this is an upgrade
echo "deploying to server"
cat <<EOS | ssh -T $SERVER 'cat - > /tmp/deploy.sh; /bin/bash -l /tmp/deploy.sh'
#!/bin/bash

set -e # fail on first error
# code that runs on the server
run() {
  echo "remote: \$@ ..."
  /bin/bash -c "\$@"
}
run "mkdir -p $SERVER_ROOT/releases/$CURRENT_VERSION"
run "mv $SERVER_ROOT/tmp/$APP_NAME-$CURRENT_VERSION.tar.gz $SERVER_ROOT/releases/$CURRENT_VERSION/$APP_NAME.tar.gz"
cd $SERVER_ROOT
run "bin/$APP_NAME upgrade $CURRENT_VERSION"
EOS
