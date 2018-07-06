#!/bin/bash

echo switching node to version $NODE_VERSION
n $NODE_VERSION --quiet

echo node version: `node --version`

git clone $GIT_URL repocode
cd repocode

if [ "$YARN_INSTALL" = "1" ]; then
  yarn install --production --silent
else
  npm install --production --silent
fi

npm run $NPM_SCRIPT
