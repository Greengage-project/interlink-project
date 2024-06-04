# Overall stack


## Environments

Each of the folders corresponds to a self-contained environment, the folder could be moved or copied to a different location.
The environments do not have dependencies within this repository and download the component images from Docker Hub (in principle images will be public so no authentication is needed).

At least, six different environment configuration will be available for INTERLINK, corresponding to the folders in this repository:

- **local**: environment for deploying the components of the INTERLINK platform in a local private machine. It does not use SSL/TLS and will be deployed in [localhost](http://localhost). It can be useful as a basis for developing and integrating components. It is expected to match latest development edge (master/main branches of the components) and data is in general not persisted.
- **development**: integration environment that will be deployed in [dev.interlink-project.eu](https://dev.interlink-project.eu). It is expected to be automarically updated with the latest development edge (master/main branches of the components).
- **demo**: central demo or staging environment [demo.interlink-project.eu](https://demo.interlink-project.eu) to demostrate new features and carry out demonstration. In general, data persistence and version stability (no latest images but fixed tagged versions) should be ensured.
- **pilot-zgz**: pilot environment [pilot-zgz.interlink-project.eu](https://pilot-zgz.interlink-project.eu). Production-like environment, data persistence and version stability (no latest images but fixed tagged versions) should be ensured.
- **pilot-mef**: pilot environment [pilot-mef.interlink-project.eu](https://pilot-mef.interlink-project.eu). Production-like environment, data persistence and version stability (no latest images but fixed tagged versions) should be ensured.
- **pilot-varam**: pilot environment for [pilot-varam.interlink-project.eu](https://pilot-varam.interlink-project.eu). Production-like environment, data persistence and version stability (no latest images but fixed tagged versions) should be ensured.

For now, the environments are deployed in a single machine with Docker Compose. The might change in the future, as well as the naming or the URLs of these images might change in the future.

All the environments deploy the same docker-compose stack.

* [Development Docker Compose](https://github.com/interlink-project/interlink-project/blob/master/envs/development/docker-compose.yml)
* [Demo Docker Compose](https://github.com/interlink-project/interlink-project/blob/master/envs/demo/docker-compose.yml)
* [Zgz Docker Compose](https://github.com/interlink-project/interlink-project/blob/master/envs/pilot-zgz/docker-compose.yml)
* [Mef Docker Compose](https://github.com/interlink-project/interlink-project/blob/master/envs/pilot-mef/docker-compose.yml)
* [Varam Docker Compose](https://github.com/interlink-project/interlink-project/blob/master/envs/pilot-varam/docker-compose.yml)

This docker composes depend on the .env files present in the directories. Those are used to define some of the environment variables dependant on the environment.

## Requirements

The only software requirement for the deployment of the environment is a working installation of docker and docker-compose (ideally witout the need of using sudo) with support to standard amd64 architecture images (most standard installations would work).

In addition, for the environments that are expected to be publicly available, it is necesary to have a machine with a public IP and to point the corresponding subdomains to the machine public address.

## Main components

* **[backend-auth](https://github.com/interlink-project/backend-auth):** FastAPI app that implements the OIDC logic to create samesite cookies in order to authenticate the requests made behind the domain it is being executed on. For example, if backend-auth is being executed in localhost, captures the callback from the AAC (authentication external module) and creates a samesite cookie for that domain (Check [authentication section](https://interlink-project.github.io/interlink-project/collaborativeenvironment/authentication/example.html)).

* **[backend-catalogue](https://github.com/interlink-project/backend-catalogue):** FastAPI app that exposes an HTTP API for storing / retrieving information about some of the data entities implemented. The main idea for this service is to keep as static as possible, to be able (in the future) to cache the responses in order to gain sustancial efficiency. The entities managed by this service are, for example, users, interlinkers, coproduction schemas... those that are not modified as frequently as the ones in the backend-coproduction service. [Catalogue API documentation](https://dev.interlink-project.eu/catalogue/docs)

* **[backend-coproduction](https://github.com/interlink-project/backend-coproduction):** FastAPI app that exposes an HTTP API for storing / retrieving information about some of the data entities implemented for the co-production. The entities managed are frequently modified, such as coproductionprocesses, assets, permissions... [Coproduction API documentation](https://dev.interlink-project.eu/coproduction/docs)

* **[backend-logging](https://github.com/interlink-project/backend-logging):** FastAPI app that exposes an HTTP API that the services (in the same network) can use to log events. [Logging API documentation](https://dev.interlink-project.eu/logging/docs). Check the [Logging section](https://interlink-project.github.io/interlink-project/environments/logging.html)

* **[frontend](https://github.com/interlink-project/frontend):**: 
    * In development: React app that serves the graphical user interface. 
    * In production: nginx that serves the static files resulted from the build of the react codebase.

* **[interlinker-ceditor](https://github.com/interlink-project/interlinker-ceditor):** FastAPI app that exposes an API to create and access documents in the Etherpad instance deployed. [Collaborative editor API documentation](https://dev.interlink-project.eu/ceditor/docs)

* **[interlinker-googledrive](https://github.com/interlink-project/interlinker-googledrive):** FastAPI app that exposes an API and a GUI to create documents in Google Drive cloud.[Googledrive API documentation](https://dev.interlink-project.eu/googledrive/docs)

* **[interlinker-survey](https://github.com/interlink-project/interlinker-survey):** FastAPI app that exposes an API and a GUI to create surveys. 
[Survey editor API documentation](https://dev.interlink-project.eu/surveyeditor/docs)

## Routing with traefik

Traefik allows to configure the routing by defining some labels in the docker-compose as it can be seen in the auth service.

```yaml
version: "3.9"
services:

  # Traefik Service, reverse proxy and load balancing
  proxy:
    image: traefik:v2.6.6
    ports:
      - "80:80"
      - "443:443"
      - "8090:8080"
    volumes:
      - ./letsencrypt:/letsencrypt
      - /var/run/docker.sock:/var/run/docker.sock
    command:
      # Enable Docker in Traefik, so that it reads labels from Docker services
      - --providers.docker=true
      # Do not expose all Docker services, only the ones explicitly exposed
      - --providers.docker.exposedbydefault=false
      - --entrypoints.web.address=:80
      - --entrypoints.websecure.address=:443
      # Redirect Http to Https
      - --entrypoints.web.http.redirections.entryPoint.to=websecure
      - --entrypoints.web.http.redirections.entryPoint.scheme=https
      - --entrypoints.web.http.redirections.entrypoint.permanent=true
      # Enable the access log, with HTTP requests
      - --accesslog
      # Enable the Traefik log, for configurations and errors
      - --log
      # Enable the Dashboard and API
      - --api
      # Enable the Dashboard and API in insecure mode for local development
      - --api.insecure=true
      # - --certificatesresolvers.letsencrypt.acme.tlschallenge=true
      - --certificatesresolvers.letsencrypt.acme.email=apps@interlink-project.eu
      - --certificatesresolvers.letsencrypt.acme.storage=/letsencrypt/acme.json

      # httpchallenge
      - --certificatesresolvers.letsencrypt.acme.httpchallenge.entrypoint=web
      - --certificatesresolvers.letsencrypt.acme.httpchallenge=true

    labels:
      - traefik.http.routers.http-catchall.rule=hostregexp(`{host:.+}`)
      - traefik.http.routers.http-catchall.entrypoints=web
      - traefik.http.routers.http-catchall.middlewares=redirect-to-https
      - traefik.http.middlewares.redirect-to-https.redirectscheme.scheme=https
    networks:
      - traefik-public
      - default
    ...

  auth:
    ...
    labels:
      - traefik.enable=true
      - traefik.docker.network=traefik-public
      - traefik.http.services.${PLATFORM_STACK_NAME}-auth.loadbalancer.server.port=${PORT}
      - traefik.http.routers.${PLATFORM_STACK_NAME}-auth.entrypoints=websecure
      - traefik.http.routers.${PLATFORM_STACK_NAME}-auth.tls.certresolver=letsencrypt
      - traefik.http.routers.${PLATFORM_STACK_NAME}-auth.tls=true
      - traefik.http.routers.${PLATFORM_STACK_NAME}-auth.rule=Host(`${DOMAIN}`) && PathPrefix(`/auth`)
```