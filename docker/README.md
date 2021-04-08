### NOTE

If you run this docker-compose (from this path) then the test is going to fail. You should test from another directory, so just copy this files to another path and run it.

The reason is because the main script run the following command in order to query for containers

~~~
$ docker inspect --format '{{ .Config.Labels }}' $containername | grep -e 'docker.bench.security'

com.docker.compose.project.working_dir:-/docker-bench-security/docker
.
.
.
$ containers=$(docker ps | sed '1d' | awk '{print $NF}' | grep -v "$benchcont")
~~~

So the result is that it search containers by the label *docker.bench.security*, save it on `benchcont` variable and then remove (`grep -v`) these containers. This is the normal behaviour for the `docker-compose.yml` in the *master* branch.