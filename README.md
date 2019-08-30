# dev-container-services
A bunch of services that are executed from docker instead of having them installed 
on your system. Mainly used for development.

### Prerequisites
In order to run this project you need the following:
 - [docker](https://www.docker.com/community-edition#/download)
 - [docker-compose](https://docs.docker.com/compose/install/)

## Intro
This repo offers a bunch of services described in the [**docker-compose.yml**](resources/docker-compose.yml) file.
These services can be interacted with using a few CLI utilities built here:
 - **drun** - starts a service inside a docker container e.g. ```$ erun consul```
 will start the consul service 
 - **erun** - allows us to execute commands in a started service e.g. ```$ erun consul consul members``` 
 will execute the *consul members* command inside the started *consul* docker container 

## Installation
If you wish to use this repo in your development process, all you need to do is:
 1. **Clone/Download** this repository.
 2. Run the [**install.sh**](install.sh) script and follow the prompts. ```$ ./install.sh```.

 During the installation process you will be asked to add the **bin/** folder to 
 your path in **.bashrc** file and if you want, you can also add to your **.bashrc** 
 file some common and helpful aliases to interact with this CLI utility. 

## Available services
If you want to start a service, all you need to do is ```drun SERVICE_NAME``` where
**SERVICE_NAME** is one of the services described bellow:

Service Name | Version | Credentials(*user:password*) | UI | Alias
--- | --- | --- | --- | ---
[consul](https://www.consul.io/) | 1.6.0 | - | [http://localhost:8500](http://localhost:8500) | ```$ dconsul```
[postgres](https://www.postgresql.org/) | 11.5 | postgres:postgres | - | ```$ dpostgres```
[mongo](https://www.mongodb.com/) | 4.2.0 | root:root | - | ```$ dmongo```
[rabbitmq](https://www.rabbitmq.com/) | 3.7.17 | guest:guest | [http://localhost:15672](http://localhost:15672) | ```$ drabbit```
[mysql](https://www.mysql.com/) | 8.0.17 | root:root | - | ```$ dmysql```
[elasticsearch](https://www.elastic.co/products/elasticsearch/) | 7.3.1 | - | - | ```$ elastic```
[kibana](https://www.elastic.co/products/kibana) | 7.3.1 | - | [http://localhost:5601](http://localhost:5601) | ```$ dkibana```

When these services are started, the docker container that gets started bears the
name ***dev-[SERVICE_NAME]*** . I would like to believe that these containers have
been configured so that they can be used in production if desired. I will try to keep these versions up to date.

---
#### If ***YOU*** feel that there is missing anything or that there can be made improvements, let's do them or let me know and I will see what I can do.
#### ***Feel free to contribute in any way.***
---

## Available aliases
Here are a bunch of the aliases defined in the [.drun_alias_helpers](bin/.drun_alias_helpers) 
file and some of their uses.
In order for these aliases to work we need their appropriate container started.

### econsul ```erun consul consul```
Executes a command inside the consul container.
```bash
# Display the members of the current consul cluster.
$ econsul members
```
### epsql ```PGPASSWORD=postgres erun postgres psql -h localhost -U postgres```
TBC
### emongorestore ```erun mongo mongorestore -u "root" -p "root" --authenticationDatabase admin --gzip --archive```
TBC
### emongodump ```erun mongo mongodump -u "root" -p "root" --authenticationDatabase admin --archive --gzip --db```
TBC
### emysqlrestore ```erun mysql mysql -uroot -proot```
TBC
### emysqldump ```erun mysql mysqldump -uroot -proot```
TBC
