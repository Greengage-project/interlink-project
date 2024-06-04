# KPI obtention

A key performance indicator (KPI) is a measurable value that demonstrates how effectively a company is achieving key business objectives. Organizations use KPIs to evaluate success at reaching targets. 

KPI list of the project: 

> https://docs.google.com/spreadsheets/d/1WDA5hatG7NLCzBTpIoVFM_yiRU_Nn6kTsbeYyPXs03A/edit#gid=1922047057

## Data backends

At the end of the day, the KPIs are a set of queries made to the different data backends (databases) used for the project. Among them:

* **catalogue_production:** postgresql database used by the *catalogue* service. 
    * Data model: https://interlink-project.github.io/interlink-project/collaborativeenvironment/datamodel/datamodel.html#catalogue-service

* **coproduction_production:** postgresql database used by the *coproduction* service. 
    * Data model: https://interlink-project.github.io/interlink-project/collaborativeenvironment/datamodel/datamodel.html#coproduction-service

* **elasticsearch6:** Elasticsearch (version 6) database for storing user activity logs. *backend-logging* service connects to this database and sends the data retrieved from its API. The reason why an old version (6) is being used for this is because Dremio is not compatible with further versions.

* **elasticsearch8:** Elasticsearch (version 8) database used by *serviceaugmenter* (servicepedia). 

## Dremio

In the simplest of terms, Dremio is a data lake engine, meaning that you can use Dremio to liberate your data through live and interactive queries sent directly to your cloud-based or on-prem data lake storage.

> https://www.dremio.com/

### Deployment

Dremio is deployed as a single container among all the others. You can see it in the docker-composes of the different environments:

> https://github.com/interlink-project/interlink-project/blob/master/envs/development/docker-compose.yml

```yaml
...

dremio:
    container_name: ${PLATFORM_STACK_NAME}-dremio
    restart: always
    image: dremio/dremio-oss:21.2
    volumes:
        - dremio-data:/opt/dremio/data
    networks:
        - traefik-public
        - default
    ports:
        - "9047:9047"   # UI (HTTP)
        # - "31010:31010" # ODBC/JDBC clients
        # - "2181:2181"   # ZooKeeper
        # - "45678:45678" # Inter-node communication
    labels:
        - traefik.enable=true
        - traefik.docker.network=traefik-public
        - traefik.http.routers.${PLATFORM_STACK_NAME}-dremio.entrypoints=websecure
        - traefik.http.routers.${PLATFORM_STACK_NAME}-dremio.tls.certresolver=letsencrypt
        - traefik.http.routers.${PLATFORM_STACK_NAME}-dremio.tls=true
        - traefik.http.routers.${PLATFORM_STACK_NAME}-dremio.rule=Host(`dremio.${DOMAIN}`)
        - traefik.http.services.${PLATFORM_STACK_NAME}-dremio.loadbalancer.server.port=9047
    ...
```

Once the docker service is up, Dremio GUI is accessible through https://dremio.dev.interlink-project.eu/

Nevertheless, in the first launch there is no admin account yet. For that, a python script has been created (setup-dremio.py) that calls the Dremio API to set up the administrator account and the different backends. 

Dremio setup script at [https://github.com/interlink-project/interlink-project/blob/master/envs/development/setup-dremio.py](https://github.com/interlink-project/interlink-project/blob/master/envs/development/setup-dremio.py)

```python
import json
import requests
import time
import os
from dotenv import load_dotenv, find_dotenv

load_dotenv(find_dotenv())

class Config():
    userName = os.environ.get("DREMIO_USERNAME")
    firstName = os.environ.get("DREMIO_USERNAME")
    lastName = os.environ.get("DREMIO_USERNAME")
    ## needs to be with uppercase, lowercase, digits and special character
    password = os.environ.get("DREMIO_PASSWORD")
    email = os.environ.get("DREMIO_EMAIL")
    dremioServer = "http://localhost:9047"
    token = None

    def get_headers(self):
        if self.token:
            return {'content-type': 'application/json', 'Authorization': '_dremio{authToken}'.format(authToken=self.token)}
        return {'content-type': 'application/json', 'Authorization': '_dremionull'}


config = Config()

...

response = requests.put('{server}/apiv2/bootstrap/firstuser'.format(server=config.dremioServer), headers=config.get_headers(), data=json.dumps({
    "userName": config.userName,
    "firstName": config.firstName,
    "lastName": config.lastName,
    "createdAt": int(time.time()),
    "email": config.email,
    "password": config.password,
}))

login()

# POSTGRES SOURCES
body = {
    "entityType": "source",
    "name": "catalogue",
    "description": "catalogue data",
    "type": "POSTGRES",
    "config": {
        "username": os.environ.get("POSTGRES_USERNAME"),
        "password": os.environ.get("POSTGRES_PASSWORD"),
        "hostname": os.environ.get("POSTGRES_HOST"),
        "port": "5432",
        "authenticationType": "MASTER",
        "fetchSize": "0",
        "databaseName": "catalogue_production"
    },
}
apiPost('catalog', body=body)

body = {
    "entityType": "source",
    "name": "coproduction",
    "description": "coproduction data",
    "type": "POSTGRES",
    "config": {
        "username": os.environ.get("POSTGRES_USERNAME"),
        "password": os.environ.get("POSTGRES_PASSWORD"),
        "hostname": os.environ.get("POSTGRES_HOST"),
        "port": "5432",
        "authenticationType": "MASTER",
        "fetchSize": "0",
        "databaseName": "coproduction_production"
    },
}
apiPost('catalog', body=body)

# ELASTICSEARCH SOURCE
body = {
    "entityType": "source",
    "name": "elastic",
    "description": "elasticsearch for logs",
    "type": "ELASTIC",
    "config": {
        "username": os.environ.get("ELASTIC_USERNAME"),
        "password": os.environ.get("ELASTIC_PASSWORD"),
        "hostList": [{"hostname": os.environ.get("ELASTIC_HOST"), "port": os.environ.get("ELASTIC_PORT")}],
        "authenticationType": "MASTER",
    },
}

body = {
    "entityType": "source",
    "name": "elastic2",
    "description": "elasticsearch for logs",
    "type": "ELASTIC",
    "config": {
        "username": os.environ.get("ELASTIC_USERNAME"),
        "password": os.environ.get("ELASTIC_PASSWORD"),
        "hostList": [{"hostname": "elasticsearch", "port": os.environ.get("ELASTIC_PORT")}],
        "authenticationType": "MASTER",
    },
}
print(body)
apiPost('catalog', body=body)
```

The variables are obtained from the .env file (find_dotenv and load_dotenv functions) or directly from the environment. **THAT IS WHY THIS SCRIPT MUST BE EXECUTED BY THE WORKFLOWS AND NOT MANUALLY**, since it needs to has access to ALL the credentials needed for establishing a connection to the databases. Some of that credentials are only in the Github secrets, and consequently, only in the shell executed by the workflows.

```bash
name: update-dev-environment
...
jobs:
  deploy:
    ...
    runs-on: ubuntu-latest
    environment: dev
    steps:
      - name: Deploy Dev SSH
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.DEV_HOST }}
          username: ${{ secrets.DEV_USERNAME }}
          key: ${{ secrets.SSH_KEY }}
          script: |
            export LOOMIO_SMTP_USERNAME=${{ secrets.LOOMIO_SMTP_USERNAME }}
            export LOOMIO_AAC_APP_SECRET=${{ secrets.LOOMIO_AAC_APP_SECRET }}
            export MAIL_PASSWORD=${{ secrets.DEV_MAIL_PASSWORD }}
            export LOOMIO_SECRET_COOKIE_TOKEN=${{ secrets.LOOMIO_SECRET_COOKIE_TOKEN }}
            export LOOMIO_SMTP_PASSWORD=${{ secrets.LOOMIO_SMTP_PASSWORD }}        
            export LOOMIO_DEVISE_SECRET=${{ secrets.LOOMIO_DEVISE_SECRET }}
            export LOOMIO_DEVISE_SECRET=${{ secrets.LOOMIO_DEVISE_SECRET }}
            ...

            pip3 install python-dotenv && python3 setup-dremio.py
            ...
```
> Line 75 in update-dev-environment workflow

### Making queries

Dremio allows to make SQL queries to SQL and NoSQL databases. This allows to create queries that join data from different backends.

#### Simple queries

Count all the coproduction processes in the postgres *coproduction* database:
```sql
SELECT COUNT(*) FROM coproduction.public.coproductionprocess
```

Get all the user activity logs (from the *logs* index in the *elastic2* backend):
```sql
SELECT * FROM elastic2.logs.log
```

#### Cross-backend queries

```sql
SELECT * FROM catalogue.public.interlinker WHERE id IN (SELECT softwareinterlinker_id FROM elastic2.logs.log WHERE action LIKE 'CREATE' AND model LIKE 'ASSET')
```


### Automation of the KPI obtention

Dremio exposes an API (https://docs.dremio.com/software/rest-api/) that can be used to send queries to the data backends. Taking that into account, a python script has been created in order to automate this obtention by executing it every X time.

The script is located in cronjobs/jobs/dremio/kpis.py.

> https://github.com/interlink-project/interlink-project/blob/master/envs/development/cronjobs/jobs/dremio/kpis.py

```python
from sheets import service, sheet_id
from datetime import datetime
import dateutil.relativedelta
from common import *
import json

# date in the left cell
date_time = datetime.now()
str_date = date_time.strftime("%Y-%m-%d %H:%M:%S")

d2 = date_time - dateutil.relativedelta.relativedelta(months=1)
one_month_before = d2.strftime("%Y-%m-%d")

login()

queries = [
    {
        "name": "A7: Number of coproduction processes",
        "sql": "SELECT COUNT(*) FROM coproduction.public.coproductionprocess",
        "extract_count": True
    },
    {
        "name": "A7.1: Number of coproduction processes in english",
        "sql": "SELECT COUNT(*) FROM coproduction.public.coproductionprocess WHERE coproductionprocess.\"language\" LIKE 'en'",
        "extract_count": True
    },
    (...)    
]

print("Obtaining kpis on", str_date)
results = run_queries(queries)

# print(json.dumps(results))

ENVIRONMENT = os.environ.get("PLATFORM_STACK_NAME")

# send data to GoogleDrive
try:
    result = service.spreadsheets().values().get( spreadsheetId=sheet_id, range=f"{ENVIRONMENT}!A1:ZZ1").execute()
    header = result.get('values', [[]])[0]
except:
    header = []

values_to_insert = []
update = False

if len(header) > 0:
    # check if all query names are present in header and add a new one if not present
    for query in queries:
        name = query.get("name")
        if not name in header:
            header.append(name)
            update = True
            print(f"Added {name} to header")

    # update header if needed
    if update:
        service.spreadsheets().values().update(
            spreadsheetId=sheet_id,
            range=f"{ENVIRONMENT}!A1:ZZ1",
            body={
                "majorDimension": "ROWS",
                "values": [header]
            },
            valueInputOption="USER_ENTERED"
        ).execute()
else:
    # if there are no cells in the header, create them with the kpis names
    header = ["Date time"] + [i.get("name") for i in queries]
    values_to_insert.append(
        header
    )
    values_to_insert.append(
        ["Last value"] + [f"=INDICE( FILTER( {char}3:{char} , NO( ESBLANCO( {char}3:{char} ) ) ) , FILAS( FILTER( {char}3:{char} , NO( ESBLANCO( {char}3:{char} ) ) ) ) )" for char in "ABCDEFGHIJKLMNOPQRSTUVWXYZ"]
    )

# set each value of row depending on the index of the name of the kpi in the header
row = [str_date]
for query_name, query_result in results.items():
    index = header.index(query_name)
    set_list(row, index, json.dumps(query_result))

values_to_insert.append(
    row
)


# append (the header if necessary) and the row to the existing sheet, defined by ENVIRONMENT (development, demo, zgz...)
service.spreadsheets().values().append(
    spreadsheetId=sheet_id,
    range=f"{ENVIRONMENT}!A:Z",
    body={
        "majorDimension": "ROWS",
        "values": values_to_insert
    },
    valueInputOption="USER_ENTERED"
).execute()

print(
    f"Document updated. See it at: https://docs.google.com/spreadsheets/d/{sheet_id}")

```

The script defines a list (*queries*) that contains a dict for every KPI. This dicts must contain at least two keys; *name* (name of the KPI) and *sql* (SQL query). If the query is a count query (COUNT(*)), you may also want to set the *extract_count* key to True, in order to extract the number that the query returns.

The results are stored in an excel document located in: https://docs.google.com/spreadsheets/d/1WDA5hatG7NLCzBTpIoVFM_yiRU_Nn6kTsbeYyPXs03A/edit#gid=0

### How to add new KPIs

The *name* attribute is used to locate or create the column headers. For example, every time an SQL query is executed, its result is stored in the index of a list (values_to_insert list) depending on the index of the element in the header equal to the *name* attribute. That way, if a query fails, the rest of the queries will be put in the correct index.

If the *name* of a query is not found in the header, it is appended, so a new column is created. 

In conclusion, the only thing needed to add a new KPI is to add a new entry to the *queries* list.


> :warning: **Every time you update the KPIs script file crontab service must be restarted in order to apply the last changes**

### Cronjob (crontab)

The script is executed every X time (it depends on the environment). There is a service called **crontab** in every docker-compose that is responsible for executing some cronjobs.

The configuration is located at https://github.com/interlink-project/interlink-project/blob/master/envs/development/cronjobs/config.json

The configuration of the dev environment is as follows:

```json
[
    {
        "schedule": "@every 10m",
        "command": "cd /opt/jobs/dremio && python3 kpis.py",
        "onstart": true
    },
    ...
]
```

To restart it, you could access portainer and restart it using the GUI.

https://portainer.dev.interlink-project.eu/#!/home
