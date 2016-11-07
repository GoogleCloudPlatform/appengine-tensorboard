#!/bin/sh
gsutil cp $GCS_PROXY_CONFIG /etc/oauth2_proxy.cfg
export OAUTH2_PROXY_COOKIE_SECRET=`python -c 'import os,base64; print base64.b64encode(os.urandom(16))'`
oauth2_proxy -http-address="0.0.0.0:8080" -upstream="http://127.0.0.1:8081" -config=/etc/oauth2_proxy.cfg 2>&1 &
tensorboard --logdir $EVENT_FILE_PATH --reload_frequency $RELOAD_FREQUENCY --debug --port 8081 --host 127.0.0.1
