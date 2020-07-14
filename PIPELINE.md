## Introduction
This is a backend project with CI & CD. Both CI and CD workflow is done using Github Actions.

## Workflow
1. On pull request of feature branch the tests are execute also terraform checks are done
1. If the PR has no issue on the previous step then the maintainer can merge the branch to master
1. Once it's merged to master 
  a. execute the tests, terraform check 
  a. build the docker image and push it to registry
  a. tell Kubernetes to update the pods with new image

## Components

- Workflow is implemented using Github actions.
  - The workflow for `master` branch and non-master branch are separated using `if` condition. 
    - This doesn't look great. It was possible to setup a separate job for only master. But it requires artifacts from previous steps. Also it was disired to re-use the VM
- Kubernetes cluster was created and maintained by Terraform.
  - The cluster is on Google cloud as signing up gives some free credit
  - Terraform only Kubernetes cluster
    - Service accounts were not managed by Terraform as it can cause lock out
    - Terraform backend bucket is not managed as it can cause lock out
    - The load balancer could have been managed by Terraform
- Image is built using `spring-boot:build-image` goal of maven. However it doesn't have `curl` installed. Hence it's installed by extending the image in Dockerfile
  - `curl` is required for gracefully stopping the container

## Scripts
There are some scripts used for build and deploy locally. Those are `build.sh`, `apply.sh`, and `deploy.sh`. These scripts uses `envvar.sh` to load some variable. Make sure you populate it before using any of deploy, build or apply scripts.

## Setup and Run
To configure it locally following steps to be compluted

1. Make sure `gcloud` and `kubectl` is available and configured. Also `kubectl` should be configured to use `gcloud`'s credential
1. Terraform backend should be configured (see `infra/terraform-backend.tf`).
  - Take a look at the `Terraform Init` and `Terraform Plan` steps in the job `infra` in github action workflow file `integration.yml`
  - It's also possible to configure it run in a different `workspace`
1. For first time deployment 
  1. `build.sh` should be run. It'll build the application image and push it to container registry.
  1. Get the image URI from the log. It'll be something like `gcr.io/.../backend:DDDDDD.DD.DD` where `D` is digit.
  1.  run `apply.sh` with that tag as first argument. It'll the tag and any changes in the kubernetes files to the cluster
1. For successive deployment of the application after source code is changed,
  1. Run `build.sh` to build
  1. Run `deploy.sh` to update only the backend image
1. To apply changes in the cluster `apply.sh` should be run with the image tag.
   

## Security Concerns
1. Google cloud credentials are saved as github secret. These are credential for a service account which is separated than local user (my own service account)
1. Project id, backend bucket is also a secret so no one can guess where we are storing the terraform backend (as it's a public repo)


## Special Notes
1. The frontend folder had no content and there is no url to define the submodule. So the backend is exposed by a load balancer.
    1. This is obviously a security hazard as you can shut it down by a POST request. There are few ways to solve it.
        a. Install an API gateway (e.g. Kong) in between the load balancer and the app. And prevent exposing that endpoint
        a. Modify the application to require special token to shutdown that can be passed when the app starts. During start up we pass this token and use this same token to configure shutdown deployment specification
1. Helm is not used. It's good tool for templating the Kubernetes YAML files. With Helm `envsubst` command could have been replaced for sure.
