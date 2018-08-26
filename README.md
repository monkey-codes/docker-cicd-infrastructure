Can be used to experiment with Jenkins pipeline functionality.

## Usage
After cloning the repo follow the steps below:

### Step 1
Add an alias ip to the local loopback address on the host:
```
$ ifconfig | grep -q 10.200.10.1 || sudo ifconfig lo0 alias 10.200.10.1
```

### Step 2
Add host entries to the local hosts file
```
...
10.200.10.1 jenkins.gotomytest.site git.gotomytest.site nexus.gotomytest.site
...
```

### Step 3
Generate the the vhosts config file for the reverse proxy and the docker-compose.yml. The `generate.sh` script takes
arguments in the format of $hostname:$docker_compose_target:$docker_compose_target_port:

```
$ ./generate.sh jenkins.gotomytest.site:jenkins:8080 git.gotomytest.site:git:3000 nexus.gotomytest.site:nexus:8081
```

### Step 4
Run the generate `docker-compose.yml` file:

```
$ docker-compose up
```

### Step 5

The sites can be accessed at:
* [jenkins](http://jenkins.gotomytest.site)
* [nexus](http://nexus.gotomytest.site)
* [gitea](http://git.gotomytest.site)

### Step 6
TODO: describe how to configure jenkins/nexus/git to work together.

## Git
admin user: gitadmin
password: please

## Nexus 
admin user: admin
password: admin123

## Issues

* You can rerun from a specific stage, but that does not keep origin
  build number - how do you redeploy a previous version?
