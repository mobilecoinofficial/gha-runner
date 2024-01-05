# gha-runner

Automated updated builds starting with `ghcr.io/actions/actions-runner` image. Adds with utilities installed so actions actually work.

Adds the following packages to the base image.

```
curl
ca-certificates
zstd
gzip
tar
jq
git
zip
unzip
```

### How to use

Replace `ghcr.io/actions/actions-runner` with `mobilecoin/gha-runner` in your `gha-runner-scale-set` helm releases.

Example `values.yaml`.  See the [gha-runner-scale-set docs](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/deploying-runner-scale-sets-with-actions-runner-controller#using-advanced-configuration-options) for full details on customizing your install.

```yaml
runnerScaleSetName: dev-small-x64
githubConfigUrl: https://github.com/<GitHub Org>
githubConfigSecret: <GitHub App Secret>
maxRunners: 25
minRunners: 0
runnerGroup: default

template:
  spec:
    imagePullSecrets:
    - name: docker-credentials
    initContainers:
    - name: init-dind-externals
      image: mobilecoin/gha-runner:latest
      command: ["cp", "-r", "-v", "/home/runner/externals/.", "/home/runner/tmpDir/"]
      volumeMounts:
      - name: dind-externals
        mountPath: /home/runner/tmpDir
    containers:
    - name: runner
      image: mobilecoin/gha-runner:latest
      command: ["/home/runner/run.sh"]
      env:
      - name: DOCKER_HOST
        value: unix:///run/docker/docker.sock
      volumeMounts:
      - name: work
        mountPath: /home/runner/_work
      - name: dind-sock
        mountPath: /run/docker
        readOnly: true
    - name: dind
      image: docker:dind
      args:
      - dockerd
      - --host=unix:///run/docker/docker.sock
      - --group=$(DOCKER_GROUP_GID)
      env:
      - name: DOCKER_GROUP_GID
        value: "123"
      securityContext:
        privileged: true
      volumeMounts:
      - name: work
        mountPath: /home/runner/_work
      - name: dind-sock
        mountPath: /run/docker
      - name: dind-externals
        mountPath: /home/runner/externals
    volumes:
    - name: work
      emptyDir: {}
    - name: dind-sock
      emptyDir: {}
    - name: dind-externals
      emptyDir: {}
```
