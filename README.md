# DockerGithubActionRunner

This is a dockerized version of github runner.

It will auto-register to the repository given as a ENV parameter on docker run (see docker-compose example).

Image on hub.docker.com: `redeaglekiller\github-action-runner`

## 1. Build arguments during docker build

- RUNNER_VERSION: refers to the runner version of github runner

## 2. Docker environment variables

- GH_TOKEN: public access token used to register runner (must have repo and org:read permissions)
- GH_OWNER: the github user / organization
- GH_REPOSITORY: the repository in which the runner will be registered

## 3. Build usage

### Build image example

```
docker build --build-arg RUNNER_VERSION=2.297.0 -t github-action-runner:2.297.0-ubuntu22.04 .
```

## 4. Docker usage guide

### Docker compose example

```
services:
  runner-mangaDownloader:
    deploy:
      replicas: 5
    image: redeaglekiller/github-action-runner-ubuntu:2.297.0-ubuntu22.04
    environment:
      - "GH_TOKEN=*****"
      - "GH_OWNER=redek91"
      - "GH_REPOSITORY=DockerGithubActionRunner"
```

## 5. Todo

- [ ] Windows version
