# Is docker compose just a useless toy?

[VM setup for docker compose](INSTALL.md)

[Example app with docker compose configs](trumpizer/)

## Reference Documentation
- compose file format https://docs.docker.com/reference/compose-file/
- build specification https://docs.docker.com/reference/compose-file/build/
- restart policies https://docs.docker.com/reference/cli/docker/container/run/#restart

## UI
- GUI compose manager https://github.com/louislam/dockge
- TUI https://github.com/jesseduffield/lazydocker
- another TUI https://github.com/mrjackwills/oxker
- one more TUI https://github.com/moncho/dry
- and one more https://github.com/lirantal/dockly

## Docker images
- mount docker images without running containers https://github.com/JosephRedfern/docker-mounter
- visualize layers for multi-stage builds https://github.com/patrickhoefler/dockerfilegraph
- make dockerfiles truly reproducible by pinning dependencies https://github.com/SongStitch/anchor/
- minimalistic "distroless" base images from Google https://github.com/GoogleContainerTools/distroless
- reducing image size & attack surface by runtime app analysis https://github.com/slimtoolkit/slim
- deep dive into docker image layers https://github.com/wagoodman/dive
- shrinking nodejs app images with AI 🤷🏻‍♂️ https://github.com/duaraghav8/dockershrink
- test framework for container contents https://github.com/GoogleContainerTools/container-structure-test
- base image updates automation https://github.com/containrrr/watchtower
- pin system packages https://github.com/SongStitch/anchor/

## Registries
- sync images between registries https://github.com/containers/skopeo
- anonymous docker registry for temporary docker images https://ttl.sh/
## Compose Fixes
- wait for services we depend on to start first https://github.com/ufoscout/docker-compose-wait
- using YAML anchors for code reuse https://jvwilge.github.io/en/2024/05/03/docker-compose-yaml-anchors-composition.html

## Convert between different formats
- compile docker container to a binary https://github.com/NilsIrl/dockerc
- generate compose file a from docker run command https://github.com/composerize/composerize
- convert to k8s https://github.com/kubernetes/kompose

## compose alternatives
- for podman https://www.reddit.com/r/podman/comments/1c2cbyl/what_is_podman_alternative_of_docker_compose/
- crane https://michaelsauter.github.io/crane/index.html

## Linters
- docker host security check https://github.com/docker/docker-bench-security
- dockerfile linter https://github.com/hadolint/hadolint
- security scanner https://trivy.dev/latest/

## Proxy
- caddy-docker-proxy https://github.com/lucaslorentz/caddy-docker-proxy
- alternative to caddy: nginx-proxy https://github.com/nginx-proxy/nginx-proxy
- Letsencrypt certificates for nginx-proxy https://github.com/nginx-proxy/acme-companion

## Deployments
- zero-downtime deployments https://github.com/wowu/docker-rollout (I couldn't make it work for my case, but looks good)
- runs actions on containers update in registry https://getwud.github.io/wud/#/
- binary for container's entrypoint script to wait until dependencies (e.g. a database) are up before we start https://github.com/ufoscout/docker-compose-wait (depends_on only for startup ORDER, doesn't wait for listening port)

## Backups
- https://github.com/offen/docker-volume-backup
- cron https://github.com/mcuadros/ofelia/

## Monitoring
- simple monitoring system: rule + fixing action approach https://github.com/decryptus/monit-docker
- turn-key replacement for grafana & prometheus, just a single container https://github.com/netdata/netdata
- chaos testing https://github.com/alexei-led/pumba
- monitoring stack based on prometheus & grafana https://github.com/stefanprodan/dockprom/blob/master/docker-compose.yml
- automatically restart containers whose healthchecks report "unhealthy" https://github.com/qdm12/deunhealth (remember, compose will only restart crashed containers but not those still RUNNING but UNHEALTHY)
- another autohealer -- but this one requires healthchecks defined on image level https://github.com/willfarrell/docker-autoheal

## Debugging
- docker startup errors & debugging techniques https://labex.io/tutorials/docker-how-to-handle-docker-container-startup-error-418431
- error code 132: CPU features missing
	- Exit code 132 indicates that the container was terminated by a SIGILL signal, which usually means that the container tried to execute an illegal instruction
