#!/bin/bash

grunt=`pwd`/node_modules/.bin/grunt

mkdir -p public/javascript
cd jquery
npm install
$grunt && $grunt dist:../public/javascript/
