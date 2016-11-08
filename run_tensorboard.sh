# Copyright 2016 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
gsutil cp $GCS_PROXY_CONFIG /etc/oauth2_proxy.cfg
export OAUTH2_PROXY_COOKIE_SECRET=`python -c 'import os,base64; print base64.b64encode(os.urandom(16))'`
oauth2_proxy -http-address="0.0.0.0:8080" -upstream="http://127.0.0.1:8081" -config=/etc/oauth2_proxy.cfg 2>&1 &
tensorboard --logdir $EVENT_FILE_PATH --reload_frequency $RELOAD_FREQUENCY --debug --port 8081 --host 127.0.0.1
