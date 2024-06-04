# Migrations on the data models

Once the change to the models (models.py files in the catalogue and coproduction services) have been made, those changes may be reflected in the database architecture. To keep track of those changes and be able to rollback them, migrations are used. 

## Revisions directories

Migrations are stored in "revision files".

* CATALOGUE: https://github.com/interlink-project/backend-catalogue/tree/master/catalogue/alembic/versions
* COPRODUCTION: https://github.com/interlink-project/backend-coproduction/tree/master/coproduction/alembic/versions


## How to create new revisions
```sh
cd backend-coproduction

# create a new migration file
make migrations message="Migration message" # does docker-compose exec coproduction alembic revision --autogenerate -m $(message)

# update the database schema with the last migrations
make applymigrations # does "docker-compose exec coproduction alembic upgrade head"
```

Sometimes it is necessary to implement the migration of the data. For that, take this into account:

https://stackoverflow.com/questions/24612395/how-do-i-execute-inserts-and-updates-in-an-alembic-upgrade-script


## Downgrade revisions

Assuming that you only want to go back one revision, use alembic downgrade with a relative migration identifier of -1:

```bash
alembic downgrade -1
```

This will run the downgrade() method of your latest revision and update the alembic_version table to indicate the revision you're now at.

If you need to go back multiple migrations, run

```bash
alembic history
```

to view a list of all the migrations in your project (from newest to oldest), then copy and paste the identifier of the migration you want to go back to:

```bash
alembic downgrade 8ac14e223d1e
```

There's currently no command to delete migrations from the versions directory, so if you want to completely wipe away all trace of your bad migration, you'll need to delete the version file (like 4c009570237e_add_widget_table.py) manually. 
