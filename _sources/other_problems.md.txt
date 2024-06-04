# Errors

### Elasticsearch authorization exception in backend-logging container

> AuthorizationException(403, 'cluster_block_exception', 'blocked by: [FORBIDDEN/12/index read-only / allow delete (api)];')

It seems that elasticsearch thinks that there is little space left on the machine. To fix it, the index must not allow the read_only mode.

For that, you can use portainer to execute a shell in backend-logging container (or any container in the same network of elasticsearch6) and execute the following commands:

```
# if curl is not installed
apt get update && apt get upgrade
apt install curl

# set the index config
curl --user ELASTIC_USER:ELASTIC_PASSWORD -X PUT http://elasticsearch:9200/INDEX_GIVING_THE_PROBLEM/_settings -H 'Content-Type: application/json' -d '{ "index": { "blocks": { "read_only_allow_delete": "false" } } }'
```