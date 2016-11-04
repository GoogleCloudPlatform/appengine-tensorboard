FROM gcr.io/tensorflow/tensorflow:latest
WORKDIR /var/gcloud
RUN curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-132.0.0-linux-x86_64.tar.gz | tar xvz
RUN google-cloud-sdk/install.sh -q

ENV PATH $PATH:/var/gcloud/google-cloud-sdk/bin

WORKDIR /
ADD run_tensorboard.sh /run_tensorboard.sh
RUN chmod u+x /run_tensorboard.sh
CMD ["/run_tensorboard.sh"]
