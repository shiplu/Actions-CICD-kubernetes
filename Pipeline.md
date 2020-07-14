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
- Kubernetes cluster was created and maintained by Terraform. It's on GKE
- Image is built using spring-boot:build-image goal of maven. However it doesn't have `curl` installed. Hence it's installed by extending the image using Dockerfile
  - `curl` is required for gracefully stopping the container

## Scripts
There are some scripts used for build and deploy locally. Those are `build.sh`, `apply.sh`, and `deploy.sh`. These scripts uses `envvar.sh` to load some variable. Make sure you populate it before using any of deploy, build or apply scripts.

## Special Notes
1. The frontend folder had no content and there is no url to define the submodule. So the backend is exposed by a load balancer.
    1. This is obviously a security hazard as you can shut it down by a POST request. There are few ways to solve it.
        a. Install an API gateway (e.g. Kong) in between the load balancer and the app. And prevent exposing that endpoint
        a. Modify the application to require special token to shutdown that can be passed when the app starts. During start up we pass this token and use this same token to configure shutdown deployment specification
