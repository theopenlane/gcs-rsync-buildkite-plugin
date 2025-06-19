[![Build status](https://badge.buildkite.com/cf752698f275643f5163411a872eefef64ff44e486f386a872.svg)](https://buildkite.com/theopenlane/gcs-rsync-buildkite-plugin)

# GCS rsync plugin

This plugin uploads files from your pipeline to a Google Cloud Storage bucket using `gsutil rsync`. It runs the Cloud SDK Docker image so you don't need `gcloud` installed on the agent.

## Example

Add the following to your `pipeline.yml`:

```yml
steps:
  - command: ":"
    plugins:
      - theopenlane/gcs-rsync#v1.0.1:
          bucket: my-upload-bucket
          source: templates
          project: my-gcp-project
          service-account-key: "${GCP_SA_KEY}"
```

### Configuration

* `bucket` (**required**): The name of the GCS bucket to sync to.
* `source`: Local directory to upload (default: `templates`).
* `project` (**required**): GCP project ID.
* `service-account-key` (**required**): Service account JSON key used for authentication.

The plugin uses `gsutil -m rsync` to synchronize the source directory with the destination bucket.

Tests can be run with `bats tests` from this directory.

## Developing

Provide examples on how to modify and test, e.g.:

To run the linter:
```shell
task lint
```

To run the tests:

```shell
task test
```
## Practical application

If you're like us, you might have super sekretz in some of your repos you want to use in your GCP account - in our case we want to bop our pods on some files we keep in a repo. After using this plugin, you'd be able to do something like:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: core
spec:
  replicas: 1
  selector:
    matchLabels:
      app: core
  template:
    metadata:
      labels:
        app: core
    spec:
      serviceAccountName: bucket-mounter
      volumes:
        - name: treasure-map
          emptyDir: {}
      containers:
        - name: core
          image: ghcr.io/theopenlane/core:latest
          volumeMounts:
            - name: treasure-map
              mountPath: /app/treasuremaps
        - name: gcsfuse
          image: gcr.io/gcsfuse/gcsfuse:latest
          command: ["/bin/sh", "-c", "gcsfuse --implicit-dirs treasure-map-bucket /treasuremaps && sleep infinity"]
          securityContext:
            privileged: true
          volumeMounts:
            - name: treasure-map
              mountPath: /treasuremaps
```

## Contributing

1. Fork the repo
1. Make the changes
1. Run the tests
1. Commit and push your changes
1. Send a pull request
