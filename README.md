## Run Tensorboard on Google App Engine

Google App Engine can provide an easy way to get a persistent Tensorboard server *with authentication* for a small cost.

In addition if you find yourself pulling a large amount of data from GCS when starting up Tensorboard servers, you may actually pay less for a persistent GAE server, since you don't pay for data egress between GCS and GAE.

### Setup

Setup assumes you have [installed the Google Cloud SDK](https://cloud.google.com/sdk) and have a billing enabled, Google Cloud Platform project.

1. Write a configuration file for the OAuth2 proxy that sits in front of your tensorboard server. See the [oauth2_proxy docs](https://github.com/bitly/oauth2_proxy#configuration) for instructions. This may require creating an OAuth2 client ID for your chosen provider. `oauth2_proxy` supports authentication with Google, Github, Facebook, Azure, GitLab, and MyUSA.

2. Upload your configuration file to GCS:
   ```
   gsutil cp oauth2_proxy.cfg gs://$BUCKET/oauth2_proxy.cfg
   ```

3. Write an `app.yaml` file with `runtime: custom` to configure your application. Full reference [here](https://cloud.google.com/appengine/docs/flexible/custom-runtimes/configuring-your-app-with-app-yaml). In the `env_variables` section you must specify 3 environment variables:
  * `GCS_PROXY_CONFIG` The fully qualified path to the configuration file you uploaded in step 2.
  * `EVENT_FILE_PATH` The fully qualified GCS Path for your Tensorboard summary files.
  * `RELOAD_INTERVAL` Frequency (in seconds) to poll GCS for new summary files.

Note that reloading data directly from GCS might cause a lot of API requests and incur high costs, so do not use the strategy
of directly reading from GCS if you use it for more than a few hundreds of log files. This is due to inefficient way GCS direct
access is working currently as described in https://github.com/tensorflow/tensorboard/issues/158

For more frequent reloads/bigger number of log files, syncing the GCS data to local folder using gsutil rsync and loading the data from local folder seems to be a better strategy.

4. Deploy your GAE app.
   ```
   gcloud app deploy app.yaml --image-url=gcr.io/google-samples/appengine-tensorboard:latest
   ```
