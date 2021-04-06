## Tips

Minikube cluster benchamrk usindg docker driver.

SYSTEMD file: /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

~~~
[Unit]
Wants=docker.socket

[Service]
ExecStart=
ExecStart=/var/lib/minikube/binaries/v1.20.2/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime=docker --hostname-override=ubuntu20 --kubeconfig=/etc/kubernetes/kubelet.conf --node-ip=192.168.1.44 --resolv-conf=/run/systemd/resolve/resolv.conf

[Install]
~~~

Path of interest

~~~
~/.kube
~/.minikube
/etc/kubernetes
/var/lib/kubelet
/var/lib/minikube
~~~

We can find some configuration files on:

~~~
~/.kube/config
/var/lib/kubelet/config.yaml
/etc/kubernetes/kubelet.conf
~~~

---

Results and remmediations for WARN and FAIL tests:

**1.1.9** WARN - files up to 644

No found path to Container Network interfaces.

**1.1.10** WARN - files to root:root

No found path to Container Network interfaces.

**1.1.12** FAIL - fixed

REMMEDIATION: chown etcd:etcd /path/to/etcd

~~~
ls -l /var/lib/minikube/
total 20
drwxr-xr-x 3 root         root         4096 feb 24 19:05 binaries
drwxr-xr-x 3 root         root         4096 mar 31 11:03 certs
drwx------ 3 root         root         4096 mar 31 11:03 etcd
drwxr-xr-x 2 root         root         4096 mar 31 08:58 images
-rw-r--r-- 1 felrodriguez felrodriguez  746 mar 31 11:03 kubeconfig
~~~

**1.1.19** FAIL - Kubernetes PKI directory root:root

I only found pki directory on /var/lib/kubelet/pki/ with owner root:root... why FAIL? seems that it checks on /etc/kubernetes/pki

~~~
ls -l /var/lib/kubelet/
total 36
-rw-r--r-- 1 root root 1062 mar 31 11:03 config.yaml
-rw------- 1 root root   62 mar 31 09:00 cpu_manager_state
drwxr-xr-x 2 root root 4096 mar 31 11:03 device-plugins
-rw-r--r-- 1 root root  116 mar 31 11:03 kubeadm-flags.env
drwxr-xr-x 2 root root 4096 mar 31 09:00 pki               --- this
drwxr-x--- 2 root root 4096 mar 31 09:00 plugins
drwxr-x--- 2 root root 4096 mar 31 09:00 plugins_registry
drwxr-x--- 2 root root 4096 mar 31 11:03 pod-resources
drwxr-x--- 9 root root 4096 mar 31 09:01 pods
~~~

**1.1.20** WARN - Kubernetes PKI certificate 644

Same as 1.1.19

~~~
ls -l /var/lib/kubelet/pki/
total 12
-rw------- 1 root root 2806 mar 31 09:00 kubelet-client-2021-03-31-09-00-16.pem
lrwxrwxrwx 1 root root   59 mar 31 09:00 kubelet-client-current.pem -> /var/lib/kubelet/pki/kubelet-client-2021-03-31-09-00-16.pem
-rw-r--r-- 1 root root 2250 mar 31 09:00 kubelet.crt
-rw------- 1 root root 1679 mar 31 09:00 kubelet.key
~~~

**1.1.21** WARN - Kubernetes PKI key file 600

Same as 1.1.19 and 1.1.20

**1.2.1** WARN - anonymous-auth set to false


**4.1.7 // 4.1.8**

You can see your certs path location in `~/.kube/config`. In this case I am using minikube so my certs path is `~/.minikube/profiles/minikube/`

REMMEDIATION: 

- 4.1.7: NOT because my files are more restrictive than 644.
- 4.1.8: NOT because I installed k8s with a custom user.

## Troubleshooting

- "Kubernetes v1.18.2 requires conntrack to be installed in root's path"

REMMEDIATION: sudo apt-get install -y conntrack

- "docker: Error: remote trust data does not exist for docker.io/aquasec/kube-bench: notary.docker.io does not have trust data for docker.io/aquasec/kube-bench"

REMMEDIATION: fix the problem setting DOCKER_CONTENT_TRUST=0 (1 for trusted images as CIS recommends)
