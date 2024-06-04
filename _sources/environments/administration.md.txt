# Environments administration

## Connect to an environment

```sh
ssh -i {PRIVATE_KEY_FILENAME} interlink@{ENVIRONMENT}.interlink-project.eu

cd /datadrive/data/interlink-project
```

where:
* ENVIRONMENT = dev / demo / mef / zgz / varam
* PRIVATE_KEY_FILENAME: name of the file

## Docker configuration

Default docker configuration stores data at /var/lib/docker/. There is no sufficient storage in the main storage system, so we need to change it to the external drive provided by FBK ( **/datadrive/docker** )

1. Stop docker daemon

```sh
sudo service docker stop
```

2. Add a configuration file to tell the docker daemon what is the location of the data

```sh
/etc/docker/daemon.json
{
  "data-root": "/path/to/your/docker"
}
```

3. Copy the current data directory to the new one (if there is data you want to preserve)

```sh
sudo rsync -aP /var/lib/docker/ /path/to/your/docker
```

4. Rename the old docker directory
```sh
sudo mv /var/lib/docker /var/lib/docker.old
```

This is just a sanity check to see that everything is ok and docker daemon will effectively use the new location for its data.

5. Restart docker daemon
```sh
sudo service docker start
```

## Clear databases

1. Remove all containers that creates a connection to the databases you want to clear (coproduction, coproductionworker, catalogue)

2. Execute a shell session on the "db" (postgres) container. Two options:

    * Create a shell for the container

    ```sh
    # CONNECT VIA SSH TO THE SERVER
    cd /datadrive/data/interlink-project/envs/{ENVIRONMENT_NAME}
    docker container list | grep db
    docker exec -it {CONTAINER_ID} bash
    ```

    * Use portainer:
      * [Portainer dev](https://portainer.dev.interlink-project.eu)
      * [Portainer demo](https://portainer.demo.interlink-project.eu)
      * [Portainer mef](https://portainer.mef.interlink-project.eu)
      * [Portainer varam](https://portainer.varam.interlink-project.eu)
      * [Portainer zgz](https://portainer.zgz.interlink-project.eu)
  

3. Clear the databases:

```sh
psql postgresql://postgres:changethis@localhost:5432
# once the session is created
DROP DATABASE catalogue_production;
DROP DATABASE coproduction_production;
CREATE DATABASE catalogue_production;
CREATE DATABASE coproduction_production;
exit
# once the session quitted
psql postgresql://postgres:changethis@localhost:5432/coproduction_production -c 'create extension hstore;'
psql postgresql://postgres:changethis@localhost:5432/catalogue_production -c 'create extension hstore;'
```

4. Run the workflow from GitHub actions to start the containers and seed the initial data

## Restore db backup

Backups are stored in: /datadrive/data/db_backups in .gz file format

```sh
# Unzip backup sql and move it to the folder
cd /datadrive/data/db_backups
gzip -d {BACKUP_NAME}
cp {BACKUP_NAME}.sql ../interlink-project/envs/{ENVIRONMENT_NAME}

# Get db container id and execute a shell session
docker container list | grep db
docker cp {BACKUP_NAME}.sql {CONTAINER_ID}:/catalogue.sql
docker cp {BACKUP_NAME}.sql {CONTAINER_ID}:/coproduction.sql
docker exec -it {CONTAINER_ID} bash

# Clear the databases
psql postgresql://postgres:changethis@localhost:5432
DROP DATABASE catalogue_production;
DROP DATABASE coproduction_production;
CREATE DATABASE catalogue_production;
CREATE DATABASE coproduction_production;
exit
psql postgresql://postgres:changethis@localhost:5432/coproduction_production -c 'create extension hstore;'
psql postgresql://postgres:changethis@localhost:5432/catalogue_production -c 'create extension hstore;'

# Import the backups
psql -U postgres -d catalogue_production < catalogue.sql
psql -U postgres -d coproduction_production < coproduction.sql

# RUN WORKFLOW FROM GITHUB ACTIONS
```


## Seed data
It is runned automatically by the workflows, but if needed, you can execute the seeding script manually.

```sh
export ENVIRONMENT={development/demo/mef/varam/zgz}
docker-compose exec -T catalogue ./seed.sh
```

## Set up loomio

In case of being the first launch
```sh
docker-compose exec -T loomio rake db:setup 
```