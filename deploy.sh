#!/bin/bash

set -e # fail on error

#CONFIG
APP_NAME="webmonitor"
SERVER="webmonitor@webmonitorhq.com"
SERVER_ROOT="/opt/www/webmonitor"
CURRENT_VERSION="$(mix run --eval 'IO.puts Mix.Project.config[:version]')"

# helpers --------------------
run() {
  echo "local: $@ ..."
  /bin/bash -c "$@"
}

# local --------------------
# build the release
echo "building release for version $CURRENT_VERSION ..."
run "MIX_ENV=prod mix compile phoenix.digest release"
# scp tarball to the server
RELEASE_TAR="./rel/$APP_NAME/releases/$CURRENT_VERSION/$APP_NAME.tar.gz"
SCP_DEST="$SERVER:$SERVER_ROOT/tmp/$APP_NAME-$CURRENT_VERSION.tar.gz"
#SCP_DEST="$SERVER:$SERVER_ROOT/releases/$CURRENT_VERSION/$APP_NAME.tar.gz"
run "scp $RELEASE_TAR $SCP_DEST"

# remote --------------------
# run migrations if needed
# run `app upgrade` if this is an upgrade
echo "deploying to server"
cat <<EOS | ssh -T $SERVER
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

# Deploy script
# 0. Bump the version
# 0.1 Commit the mix file
# 1. Build the release
# 2. Build the digests
# 3. SCP over the release tarball
# 4. Extract it on the server
# 5. Restart the server

# 1. Build the release
# 2. Build the digests

# 3. SCP over the release tarball
#system "scp webmonitor@webmonitorhq.com"

# 4. Extract it on the server
# 5
# 5. Restart the server
