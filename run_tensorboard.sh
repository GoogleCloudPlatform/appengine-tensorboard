#!/bin/sh
tensorboard --logdir $GCS_PATH --reload_frequency $RELOAD_FREQUENCY --debug --port 8080
