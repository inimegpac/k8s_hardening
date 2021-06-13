# NGINX

## Configuration

Add node ip and service ingress domain to `/etc/hosts`

Get the nginx NodePort after deploy with

~~~
$ kubectl -n ingress-nginx get svc
~~~

And curl your ingress domain with port the nginx NodePort.

~~~
$ kubectl -n ingress-nginx --address 0.0.0.0 port-forward svc/ingress-nginx-controller 80:80
$ kubectl -n ingress-nginx --address 0.0.0.0 port-forward svc/ingress-nginx-controller 443:443
~~~

## References

[Installation Guide](https://kubernetes.github.io/ingress-nginx/deploy/)