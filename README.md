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
# LINUX
docker build --build-arg RUNNER_VERSION=2.297.0 -t github-action-runner:2.297.0-ubuntu22.04 ./LinuxRunner

# Windows (Works only on Windows Docker)
docker build --build-arg RUNNER_VERSION=2.297.0 -t github-action-runner:2.297.0-windowsltsc2022 ./WindowsRunner
```

## 4. Docker usage guide

### Docker run example

```
# Linux
docker run --name "runner-dockergithubactionrunner" -e GH_OWNER=redek91 -e GH_REPOSITORY=DockerGithubActionRunner -e GH_TOKEN=*** redeaglekiller/github-action-runner:2.297.0-ubuntu22.04

# Windows
docker run --name "runner-dockergithubactionrunner" -e GH_OWNER=redek91 -e GH_REPOSITORY=DockerGithubActionRunner -e GH_TOKEN=*** redeaglekiller/github-action-runner:2.297.0-windowsltsc2022
```

### Docker compose example

```
services:
  # Windows runner
  runner-dockergithubactionrunner:
    deploy:
      replicas: 5
    image: redeaglekiller/github-action-runner-ubuntu:2.297.0-windowsltsc2022
    environment:
      - "GH_TOKEN=*****"
      - "GH_OWNER=redek91"
      - "GH_REPOSITORY=DockerGithubActionRunner"
  # Linux runner
  runner-dockergithubactionrunner:
    platform: linux
    deploy:
      replicas: 5
    image: redeaglekiller/github-action-runner-ubuntu:2.297.0-ubuntu22.04
    environment:
      - "GH_TOKEN=*****"
      - "GH_OWNER=redek91"
      - "GH_REPOSITORY=DockerGithubActionRunner"
```

## 5. Todo

- [x] Windows version
