#!/bin/bash
# Warning: this script has only been tested on macOS Sierra. There's a good chance
# it won't work on other operating systems. If you get it working on another OS,
# please send a pull request with any changes required. Thanks!
set -e

cd `dirname $0`
r=`pwd`
echo $r

if [ -z "$(which heroku)" ]; then
  echo "You must install the Heroku CLI first!"
  echo "https://devcenter.heroku.com/articles/heroku-cli"
  exit 1
fi

if ! echo "$(heroku plugins)" | grep -q heroku-cli-deploy; then
  heroku plugins:install heroku-cli-deploy
fi

if ! echo "$(git remote -v)" | grep -q pwa-server-; then
  server_app=pwa-server-$RANDOM
  heroku create -r server $server_app
else
  server_app=$(heroku apps:info -r server --json | python -c 'import json,sys;print json.load(sys.stdin)["app"]["name"]')
fi
serverUri="https://$server_app.herokuapp.com"

if ! echo "$(git remote -v)" | grep -q pwa-client-; then
  client_app=pwa-client-$RANDOM
  heroku create -r client $client_app
else
  client_app=$(heroku apps:info -r client --json | python -c 'import json,sys;print json.load(sys.stdin)["app"]["name"]')
fi
clientUri="https://$client_app.herokuapp.com"

# Deploy the server
cd $r/server
mvn clean package -DskipTests

heroku deploy:jar target/*jar -r server -o "--server.port=\$PORT"
heroku config:set -r server \
  FORCE_HTTPS="true" \
  STORMPATH_CLIENT_BASEURL="$STORMPATH_CLIENT_BASEURL" \
  STORMPATH_WEB_CORS_ALLOWED_ORIGINURIS="$clientUri" \
  OKTA_APPLICATION_ID="$OKTA_APPLICATION_ID" \
  OKTA_API_TOKEN="$OKTA_API_TOKEN"

# Deploy the client
cd $r/client
rm -rf dist
# replace the server URL in the client
sed -i -e "s|http://localhost:8080|$serverUri|g" $r/client/src/app/shared/car/car.service.ts
yarn && ng build --prod --aot
# Fix filenames in sw.js
python $r/sw.py
cd dist

cat << EOF > static.json
{
  "https_only": true,
  "root": ".",
  "routes": {
    "/**": "index.html"
  }
}
EOF

rm -f ../dist.tgz
tar -zcvf ../dist.tgz .

# TODO replace this with the heroku-cli-static command `heroku static:deploy`
source=$(curl -n -X POST https://api.heroku.com/apps/$client_app/sources -H 'Accept: application/vnd.heroku+json; version=3')
get_url=$(echo "$source" | python -c 'import json,sys;print json.load(sys.stdin)["source_blob"]["get_url"]')
put_url=$(echo "$source" | python -c 'import json,sys;print json.load(sys.stdin)["source_blob"]["put_url"]')
curl "$put_url" -X PUT -H 'Content-Type:' --data-binary @../dist.tgz
cat << EOF > build.json
{
  "buildpacks": [{ "url": "https://github.com/heroku/heroku-buildpack-static" }],
  "source_blob": { "url" : "$get_url" }
}
EOF
build_out=$(curl -n -s -X POST https://api.heroku.com/apps/$client_app/builds \
  -d "$(cat build.json)" \
  -H 'Accept: application/vnd.heroku+json; version=3' \
  -H "Content-Type: application/json")
output_stream_url=$(echo "$build_out" | python -c 'import json,sys;print json.load(sys.stdin)["output_stream_url"]')
curl -s -L "$output_stream_url"

rm build.json
rm ../dist.tgz

# cleanup changed files
git checkout $r/client
git checkout $r/server
rm $r/client/src/app/shared/car/car.service.ts-e

# show apps and URLs
heroku open -r client