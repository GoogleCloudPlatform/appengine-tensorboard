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
FROM ubuntu:xenial

RUN apt-get update && apt-get install -y python3-pip curl
RUN pip3 install tensorboard

# Install gsutil
WORKDIR /var/gcloud
# Create environment variable for correct distribution
ENV CLOUD_SDK_REPO cloud-sdk-xenial
# Add the Cloud SDK distribution URI as a package source
RUN echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
# Import the Google Cloud Platform public key
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
# Update the package list and install the Cloud SDK
RUN  apt-get update && apt-get install -y google-cloud-sdk


# Install oauth2_proxy
WORKDIR /usr/local
RUN curl https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz | tar xzv
RUN apt-get update && apt-get install -y git
ENV GOPATH /var/go
ENV PATH $PATH:/usr/local/go/bin:/var/go/bin
RUN go get github.com/bitly/oauth2_proxy

WORKDIR /
ADD run_tensorboard.sh /run_tensorboard.sh
RUN chmod u+x /run_tensorboard.sh
CMD ["/run_tensorboard.sh"]
