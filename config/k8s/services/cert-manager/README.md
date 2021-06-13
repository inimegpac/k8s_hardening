# Cert-Manager

~~~
$ wget https://github.com/jetstack/cert-manager/releases/download/v1.3.1/cert-manager.yaml
$ kubectl apply -f cert-manager.yaml
$ kubectl get pods --namespace cert-manager

$ kubectl apply -f acme-clusterissuer.yaml
$ kubectl get clusterissuer
$ kubectl describe clusterissuer letsencrypt-staging
~~~

## References

[Cert-Manager Documentation](https://cert-manager.io/docs/installation/kubernetes/)

[ACME Issuer](https://cert-manager.io/docs/configuration/acme/)

[Github example](https://github.com/alexellis/k8s-tls-registry)

[Youtube: Free SSL for Kubernetes with Cert-Manager](https://www.youtube.com/watch?v=hoLUigg4V18)