# NGINX

## Configuration

Add node ip and service ingress domain to `/etc/hosts`

Get the nginx NodePort after deploy

~~~
$ kubectl -n ingress-nginx get svc
~~~

And curl your ingress domain with port nginx NodePort.

## References

[Installation Guide](https://kubernetes.github.io/ingress-nginx/deploy/)