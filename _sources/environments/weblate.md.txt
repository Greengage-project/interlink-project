
# Weblate for continous localization

Weblate is a libre web-based translation tool with tight version control integration. It provides two user interfaces, propagation of translations across components, quality checks and automatic linking to source files.

## How to use weblate as a user

[Weblate instructions](https://docs.google.com/document/u/2/d/1GApY_q1txqRJeYgQ_pZk01WG5XZXl38R-VyLXpIh3t4/edit)

## Deployment of weblate

Weblate is separated from the rest of the services, since it is thought to be deployed only in one (in this case, demo) environment. You can find its docker-compose in the interlink-project repository:

[Weblate docker compose and files](https://github.com/interlink-project/interlink-project/tree/master/envs/internationalization)

```sh
cd /datadrive/data/interlink-project/envs/internationalization
# FIRST CREATE THE .ENV FILE
docker-compose up -d
```

".env" file contents:
```bash
DOMAIN=demo.interlink-project.eu
ADMIN_PASS=
# allow login with google
GOOGLE_KEY=
GOOGLE_SECRET=

# Postgres
POSTGRES_SERVER=
POSTGRES_USER=
POSTGRES_PASSWORD=
PGDATA=/var/lib/postgresql/data/pgdata

FROM_EMAIL=
SMTP_SERVER=
SMTP_USERNAME=
SMTP_PASSWORD=
```
## Components in weblate

### Creation of components

Video on github access token and weblate component creation:

[![Watch the video](https://images.drivereasy.com/wp-content/uploads/2017/07/img_596dda8d77553.png)](https://drive.google.com/file/d/1KAXBS6TaO0m9y1jHiwS1mATKyieoguUe/view?usp=sharing)

Steps showed:
* Creation of the github access token:
    * Go to https://github.com/settings/tokens and create an access token
* Creation of the weblate component:
    * **Repository branch:** master
    * **Repository push URL:** https://{GITHUB_USER}:{ACCESS_TOKEN}@github.com/interlink-project/{REPOSITORY_NAME}.git
    * **Push branch:** weblate
* Set a webhook on every repository added weblate: 
    * https://github.com/interlink-project/{REPOSITORY_NAME}/settings/hooks
    
### Collaborative environment frontend component

* [Translation files](https://github.com/interlink-project/frontend/tree/master/react/src/translations)

* [Frontend weblate project](https://demo.interlink-project.eu/weblate/projects/collaborative-environment/frontend/)

### Seeding data component

* [Translation files](https://github.com/interlink-project/interlinkers-data/tree/master/weblate)

* [Seeding data weblate project](https://demo.interlink-project.eu/weblate/projects/seeding-data/)