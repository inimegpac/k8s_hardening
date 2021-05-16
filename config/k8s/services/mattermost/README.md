# Mattermost

This deployment is based on the official [mattermost kubernetes installation](https://docs.mattermost.com/install/install-kubernetes.html). 

*NOTE*: namespaces have been edited in order to customize our ingrastructure.

## Mattermost Enterprise Edition

*NOTE*: go to official [documentation](https://docs.mattermost.com/install/install-kubernetes.html#deploying-a-mattermost-installation) to create a secret which contain the license.

## NO Enterprise Edition

*NOTE*: When using MySQL and MinIO operators these steps can be skipped. It requires both Operators to be installed on the cluster and **it is not recomended for production usage.**

**Mattermost Operator**

~~~
$ kubectl create ns mattermost-operator
$ kubectl apply -n mattermost-operator -f https://raw.githubusercontent.com/mattermost/mattermost-operator/master/docs/mattermost-operator/mattermost-operator.yaml
~~~

**MySQL operator**

~~~
$ kubectl create ns mysql-operator
$ kubectl apply -n mysql-operator -f https://raw.githubusercontent.com/mattermost/mattermost-operator/master/docs/mysql-operator/mysql-operator.yaml
~~~

**MinIO operator**

~~~
$ kubectl create ns minio-operator
$ kubectl apply -n minio-operator -f https://raw.githubusercontent.com/mattermost/mattermost-operator/master/docs/minio-operator/minio-operator.yaml
~~~