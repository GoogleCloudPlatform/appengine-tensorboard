FROM gcr.io/tensorflow/tensorflow:latest

# Install gsutil
WORKDIR /var/gcloud
RUN curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-132.0.0-linux-x86_64.tar.gz | tar xvz
RUN google-cloud-sdk/install.sh -q
ENV PATH $PATH:/var/gcloud/google-cloud-sdk/bin

# Install oauth2_proxy
WORKDIR /usr/local
RUN curl https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz | tar xzv
RUN sudo apt-get update && sudo apt-get install -y git
ENV GOPATH /var/go
ENV PATH $PATH:/usr/local/go/bin:/var/go/bin
RUN go get github.com/bitly/oauth2_proxy

WORKDIR /
ADD run_tensorboard.sh /run_tensorboard.sh
RUN chmod u+x /run_tensorboard.sh
CMD ["/run_tensorboard.sh"]
