# Ansible Hardening Docker - CIS Docker Benchmark

Most good practices from CIS for hardening your Docker environment with Ansible.

**Differences from official repository (Github nor `master` branch)**

- Ansible configuration.

- New argument `-v` for [benchmark/docker-bench-security.sh](benchmark/docker-bench-security.sh). You can pass the Docker official version and check if corresponds with yours.

~~~
$ sudo bash benchmark/docker-bench-security.sh -v 20.10.5
~~~

- New colours styles:
    - [WARN] in red for critical issues that you have to fix.
    - [INFO] in yellow for external (manually) actions (checks) you have to do in order to follow CIS recommendation. In general this check does not have a critical impact in your Docker environment nor may depend on external factors.
    - [NOTE] in blue for just a recommendations/suggestion or information to fix the point.

- [config/daemon.json](config/daemon.json) file configuration provided.

~~~
{
    "cgroup-parent": "",          # CIS 2.9 SET your /foobar/path
    "log-level": "info",          # CIS 2.2
    "icc": false,                 # CIS 2.1
    "live-restore": true,         # CIS 2.13
    "userland-proxy": false,      # CIS 2.14
    "no-new-privileges": true,    # CIS 2.17
    "selinux-enabled": true,      # CIS 5.2
    "userns-remap": "default",    # CIS 2.8 BUG see troubleshooting
    "storage-driver": ""          # CIS 2.5 NOT "aufs"
}
~~~

- [docker/docker-compose.yml](docker/docker-compose.yml) file provided with examples and security options.

## Configuration

### Test

[Vagrantfile](Vagrantfile) provided for testing Ansible playbooks.

### Ansible

You can deploy the configuration for hardening your machines

- Install ansible on local machine (where you are going to deploy from).

- Generate ssh keys and copy on remote machines. See [keys/README.md](keys/README.md) and [create_user_ansible.sh](create_user_ansible.sh) for further information.

- Configure your hosts in [inventory/hosts](inventory/hosts).

- Set required variables on [vars/](vars/) files. If your machines already has installed Docker then set `docker_configuration` to false.

Run `$ ansible all -m ping` for testing your configuration.

### Manual benchmark

If you want to test manually

- Copy [benchmark](benchmark) path to remote machines.

- Copy the [config/daemon.json](config/daemon.json) to the Docker Daemon config path (by default `/etc/docker/daemon.json`) on remote machines. You can add more options from [config/daemon-template.json](config/daemon-template.json). **NOTE**: care about `"userns-remap"` option (see Troubleshooting part for further information).

- If you want to test the [docker/docker-compose.yml](docker/docker-compose.yml) you have to copy it to another path. See [docker/README.md](docker/README.md)

## Usage

### Test

- Install vagrant and run `$ vagrant up`

### Ansible

Just run the following script [run_playbook.sh](run_playbook.sh) for configuring and hardening Docker in your hosts

~~~
$ bash run_playbook.sh playbooks/docker.yaml
~~~

Check benchmark logs on [benchmark/results](benchmark/results)

### Manual benchmark

**Please go to the main `README.md` from Github or `master` branch in this repository for further information**

The CIS based checks are named `check_<section>_<number>`, e.g. `check_2_6` and community contributed checks are named `check_c_<number>`.

A complete list of checks is present in [functions_lib.sh](functions_lib.sh).

`$ bash docker-bench-security.sh -l /tmp/docker-bench-security.sh.log -v 20.10.5` will run all checks and compare the Docker official version with your Docker enviroment.

`$ bash docker-bench-security.sh -l /tmp/docker-bench-security.sh.log -c check_2_2` will only run check `2.2 Ensure the logging level is set to 'info'`.

`$ bash docker-bench-security.sh -l /tmp/docker-bench-security.sh.log -e check_2_2` will run all available checks except `2.2 Ensure the logging level is set to 'info'`.

`$ bash docker-bench-security.sh -l /tmp/docker-bench-security.sh.log -e docker_enterprise_configuration` will run all available checks except the docker_enterprise_configuration group

`$ bash docker-bench-security.sh -l /tmp/docker-bench-security.sh.log -e docker_enterprise_configuration,check_2_2` will run all available checks except the docker_enterprise_configuration group and `2.2 Ensure the logging level is set to 'info'`

`$ bash docker-bench-security.sh -l /tmp/docker-bench-security.sh.log -c container_images -e check_4_5` will run just the container_images checks except `4.5 Ensure Content trust for Docker is Enabled`

## Troubleshooting

- You should make persistant every new rule you add with `auditctl` (see CIS 1). Check it after restart your environment. Ansible makes these default rules persistent but there may be an error if the paths/files do not exist.

- NOT to restart the Docker Daemon!! First stop it, make your config changes and finally start it.

~~~
$ systemctl stop docker # Stopping docker.service, but it can still be activated by docker.socket
$ systemctl stop docker.socket
~~~

- Fail to start a container with ERROR

~~~
ERROR: for python  Cannot start service python: OCI runtime create failed: container_linux.go:367: starting container process caused: process_linux.go:495: container init caused: write sysctl key kernel.domainname: open /proc/sys/kernel/domainname: permission denied: unknown
~~~

**BUG**: [domainname denied if userns enabled](https://github.com/docker/for-linux/issues/743)

**EXPLANATION**: [you can not set the domainname](https://github.com/opencontainers/runtime-spec/issues/592) just the hostname.

**Remmediation**: delete `"userns-remap": "default"` from `config/daemon.json`

**RELATED TO**: CIS 2.8, even `/etc/subuid` `/etc/subgid` are created.

## TODO

- Add script for creating TLS certs automatically.

- Remove benchmark files on remote mchines.

## References

Security features from CIS 5.

1. **AppArmor**

AppArmor (Application Armor) is a Linux Security Module (LSM). It protects the operating system by applying profiles to individual applications or containers. In contrast to managing capabilities with CAP_DROP and syscalls with seccomp, AppArmor allows for much finer-grained control. For example, AppArmor can restrict file operations on specified paths.

[AppArmor security profiles for Docker](https://docs.docker.com/engine/security/apparmor/)

[Protege contenedores con AppArmor](https://cloud.google.com/container-optimized-os/docs/how-to/secure-apparmor?hl=es)

2. **SElinux**

The Docker daemon relies on a [OCI](https://github.com/opencontainers/runtime-spec) compliant runtime (invoked via the containerd daemon) as its interface to the Linux kernel namespaces, cgroups, and __SELinux__

[Secure your containers with SELinux](https://opensource.com/article/20/11/selinux-containers)

3. **Seccomp**

Seccomp is a sandboxing facility in the Linux kernel that acts like a firewall for system calls (syscalls). It uses Berkeley Packet Filter (BPF) rules to filter syscalls and control how they are handled. These filters can significantly limit a containers access to the Docker Host's Linux kernel - especially for simple containers/applications.

The `docker/no-chmod.json` file is a profile with the chmod(), fchmod(), and chmodat() syscalls removed from its whitelist.

### Extra

[Docker Security (official github)](https://github.com/docker/labs/tree/master/security)

[Docker Security Options](https://docs.docker.com/engine/security/)

[Docker Compose Configuration](https://docs.docker.com/compose/compose-file/compose-file-v3/)

[Containers Security toolkit](https://www.stackrox.com/post/2017/08/hardening-docker-containers-and-hosts-against-vulnerabilities-a-security-toolkit/)