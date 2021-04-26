IMAGE_NAME = "bento/ubuntu-18.04"
N = 2

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    # config.vm.provider "virtualbox" do |v|
    #     v.memory = 2048
    #     v.cpus = 2
    # end
      
    config.vm.define "k8s-master" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "public_network", ip: "192.168.0.160"
        master.vm.hostname = "k8s-master"
        master.vm.provider "virtualbox" do |v|
            v.memory = 2048
            v.cpus = 2
        end
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "playbooks/docker-k8s.yaml"
            ansible.verbose = "v"
            ansible.extra_vars = {
                node_ip: "192.168.0.160",
            }
        end
    end

    (1..N).each do |i|
        config.vm.define "node#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "public_network", ip: "192.168.0.#{i + 160}"
            node.vm.hostname = "node#{i}"
            node.vm.provider "virtualbox" do |v|
                v.memory = 2048
                v.cpus = 2
            end
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "playbooks/docker-k8s.yaml"
                ansible.verbose = "v"
                ansible.extra_vars = {
                    node_ip: "192.168.0.#{i + 160}",
                }
            end
        end
    end
end