# dev-services
This project contains a set of **"recipes"** to run a few services inside 
docker instead of having them installed on your system. These are mainly used for 
development but **docker-compose files** can be used as a starting point for
other scenarios as well.

#### Note
This repository was tested on **Linux** more specifically on Ubuntu based 
distributions like: **Ubuntu**, **Linux Mint** and other Ubuntu official 
flavours. Using this in WSL for Windows with a Ubuntu distribution might work.

### Prerequisites
In order to run this project you need the following:
 - [docker](https://www.docker.com/community-edition#/download)
 - [docker-compose](https://docs.docker.com/compose/install/)
 - [Linux Mint](https://www.linuxmint.com/) or a compatible Ubuntu based distribution. 
 It might work with [Ubuntu in WSL2](https://ubuntu.com/blog/ubuntu-on-wsl-2-is-generally-available) 
 as well.

## Intro
This repository offers a handful of services described in their corresponding 
[**<SERVICE_NAME>/docker-compose.yml**](resources/) file.
These services can be interacted with using a few CLI utilities built here:
 - **drun** - starts a service inside a docker container e.g. ```$ drun consul```
 will start the consul service. Bear in mind that these services use **traefik**
 so if traefik is not started then it will be. If you want to start the service 
 using the host network, use the ```-h|--host``` flag
 - **erun** - allows us to execute commands in a started service e.g. 
 ```$ erun consul consul members``` will execute the *consul members* command 
 inside the started *consul* docker container 

**Why I chose to use a reverse proxy like traefik?**

Well that is easy to answer. I don't like remembering all the ports for the web UIs.

## Installation
If you wish to use this repository in your development process, all you need to do is:
 1. **Clone/Download** this repository.
 2. Run the [**install.sh**](install.sh) script and follow the prompts. ```$ ./install.sh```.

 During the installation process you will be asked to add the **bin/** folder to 
 your path in **.bashrc** file and if you want, you can also add to your **.bashrc** 
 file some common and helpful aliases to interact with this CLI utility. Also a docker
 network resource named **dev-net-trfk** will be created.

## Available services
If you want to start a service, all you need to do is ```drun SERVICE_NAME``` where
**SERVICE_NAME** is one of the services described bellow:

Service Name | Version | Credentials(*user:password*) | UI | Alias
--- | --- | --- | --- | ---
[traefik](https://containo.us/traefik/) | 2.3.1 | - | [http://traefik.localhost](http://traefik.localhost) | ```$ dtraefik```
[consul](https://www.consul.io/) | 1.8.4 | - | [http://localhost:8500](http://localhost:8500) | ```$ dconsul```
[postgres](https://www.postgresql.org/) | 12.4 | postgres:postgres | - | ```$ dpostgres```
[mongo](https://www.mongodb.com/) | 4.4.1 | root:root | - | ```$ dmongo```
[rabbit](https://www.rabbitmq.com/) | 3.8.9 | guest:guest | [http://rabbit.localhost](http://rabbit.localhost) | ```$ drabbit```
[mysql](https://www.mysql.com/) | 8.0.21 | root:root | - | ```$ dmysql```
[elasticsearch](https://www.elastic.co/products/elasticsearch/) | 7.9.2 | - | - | ```$ delastic```
[kibana](https://www.elastic.co/products/kibana) | 7.9.2 | - | [http://kibana.localhost](http://kibana.localhost) | ```$ dkibana```
[keycloak](https://www.keycloak.org/) | 11.0.2 | admin:admin | [http://keycloak.localhost](http://keycloak.localhost) | ```$ dkeycloak```
[openzipkin](https://zipkin.io/) | 2.21.7 | - | [http://zipkin.localhost](http://zipkin.localhost) | ```$ dzipkin```
[jaeger](https://www.jaegertracing.io/) | 1.20.0 | - | [http://jaeger.localhost](http://jaeger.localhost) | ```$ djaeger```
[mailhog](https://github.com/mailhog/MailHog) | 1.0.1 | - | [http://mailhog.localhost](http://mailhog.localhost) | ```$ dmail```

When these services are started, the docker container that gets started bears the
name ***dev-[SERVICE_NAME]*** . I would like to believe that these containers have
been configured so that they can be used in production if desired. I will try 
to keep these versions up to date.

#### Note
The ```$ dconsul``` is equivalent to ```$ drun consul --host``` basically it starts
consul using the host network. This should work for most development needs but if
you wish to have consul running in the docker **dev-net-trfk** for some
reason, start it using the default command ```$ drun consul```

### KEYCLOAK Prerequisites:
 - the **postgres** service running
 - a database named: **dev_keycloak**

---
#### If ***YOU*** feel that there is missing anything or that there can be made improvements, let's do them or let me know and I will see what I can do.
#### ***Feel free to contribute in any way.***
---

## Available aliases
Here are a bunch of the aliases defined in the [.drun_alias_helpers](bin/.drun_alias_helpers) 
file and some of their uses.
In order for these aliases to work we need their appropriate container started.

### econsul 
```bash 
# Alias equivalent
$ erun consul consul

### Usage example
# Display the members of the current consul cluster.
$ econsul members
```
### epsql 
```bash
# Alias equivalent
$ PGPASSWORD=postgres erun postgres psql -h localhost -U postgres

### Usage example
# To restore a database dump DB_BACKUP_FILE into a database DB_NAME
$ cat DB_BACKUP_FILE | epsql DB_NAME
```
### epgdump 
```bash
# Alias equivalent
$ docker exec -i dev-postgres pg_dump -h localhost -U postgres

### Usage example
# To backup a local docker database DB_NAME into a DB_BACKUP_FILE
$ epgdump -U postgres DB_NAME > DB_BACKUP_FILE
# To backup a remote database DB_NAME into a DB_BACKUP_FILE
$ epgdump -h REMOTE_HOST -U REMOTE_USER DB_NAME > DB_BACKUP_FILE
```
### emongodump 
```bash
# Alias equivalent
$ erun mongo mongodump -u "root" -p "root" --authenticationDatabase admin --archive --gzip --db

### Usage example
# Create a dump file for a given database
$ emongodump DB_NAME | DB_BACKUP_FILE.gz
```
### emongorestore 
```bash
# Alias equivalent
$ erun mongo mongorestore -u "root" -p "root" --authenticationDatabase admin --gzip --archive

### Usage example
# To restore in the same database as the backup was made for
$ cat  DB_BACKUP_FILE.gz | emongorestore
# To restore in a different database
$ cat  DB_BACKUP_FILE.gz | emongorestore "OLD_DB_NAME.*" --nsTo "NEW_DB_NAME.*"
```
### emysqldump 
```bash
# Alias equivalent
$ erun mysql mysqldump -uroot -proot

### Usage example
# To create a database backup file
$ emysqldump DB_NAME > DB_BACKUP_FILE.sql
```
### emysqlrestore 
```bash
# Alias equivalent
$ erun mysql mysql -uroot -proot

### Usage example
# To restore a database backup file
$ cat DB_BACKUP_FILE.sql | emysqlrestore DB_NAME
```
## Elasticsearch backups
Totally unrelated to this, well maybe a little because we do have an ***delastic***
alias to start the elasticsearch service but here I will try to explain how to 
backup an elastic search index.

Sadly *(to my knowledge)* there is no easy/clean way to backup an elastic search
index in a simple dump file like you would do for a normal database. So here
it goes.

This is a strange case. We create two mounted volumes for this in our ***.containers_home***
folder:
- ***dev-elasticsearch/es-data*** - here we will store the elasticsearch database
- ***dev-elasticsearch/es-backups*** - here we will store snapshots(backups) of our indices

To view all available indices in your elastic search access 
[http://elasticsearch.localhost/_cat/indices?pretty](http://elasticsearch.localhost/_cat/indices?pretty)

Now we can create snapshots for our indices:
```bash
# Register a folder  where we will create some snapshots. I usually do a folder for each  index
# BACKUP_FOLDER_NAME = the index name
$ curl -X PUT \
      "http://elasticsearch.localhost/_snapshot/BACKUP_FOLDER_NAME" \
      -H 'content-type: application/json' \
      -d "{
            \"type\": \"fs\",
            \"settings\": {
                \"location\": \"BACKUP_FOLDER_NAME\",
                \"compress\": true
            }
        }"

# Now to trigger a snapshot of the desired index
# We use the previous define BACKUP_FOLDER_NAME.
# The backups are incremental so SNAPSHOT_NAME needs to be unique.
# For each snapshot we can specify what indices to include but we do only one INDEX_NAME
$ curl -X PUT \
      "http://elasticsearch.localhost/_snapshot/BACKUP_FOLDER_NAME/SNAPSHOT_NAME?wait_for_completion=true" \
      -H 'content-type: application/json' \
      -d "{
          \"indices\": \"INDEX_NAME\",
          \"ignore_unavailable\": true,
          \"include_global_state\": false
        }"
```
Bellow we will handle the restoring of a snapshot that we got from another elastic 
search server. Usually this is done by copying the BACKUP_FOLDER_NAME from that 
server onto the new one and following the next steps.
```bash
# Now if you followed the recommendations above, you should be in possession of a tar/zip file
# that contains the BACKUP_FOLDER_NAME created above Take that and extract it into
# your dev-elasticsearch/es-backups folder so we can start the restore process.
# If elastic search was running while you added the contents to the folder, you need to restart it.
$ curl -X PUT \
      "http://elasticsearch.localhost/_snapshot/BACKUP_FOLDER_NAME" \
      -H 'content-type: application/json' \
      -d "{
            \"type\": \"fs\",
            \"settings\": {
                \"location\": \"BACKUP_FOLDER_NAME\",
                \"compress\": true
            }
        }"
```
Now that you registered the backup repository, if you go to http://elasticsearch.localhost/_snapshot/BACKUP_FOLDER_NAME/_all you should see all available snapshots that were created. Pick the one you want to restore and:
```bash
# SNAPSHOT_NAME is a name picked from the available snapshots
$ curl -X POST \
      http://elasticsearch.localhost/_snapshot/BACKUP_FOLDER_NAME/SNAPSHOT_NAME/_restore \
      -H 'content-type: application/json'
```
To monitor the restore progress you can access http://elasticsearch.localhost/_snapshot/BACKUP_FOLDER_NAME/SNAPSHOT_NAME

For more details you can read the [official documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html).

After the restore is done you can access the index you restored http://elasticsearch.localhost/INDEX_NAME/_search

---
#### As stated a little bit above: ***Feel free to contribute in any way.***
---