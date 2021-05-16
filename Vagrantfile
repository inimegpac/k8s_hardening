IMAGE_NAME = "bento/ubuntu-18.04"
N = 3

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    # config.vm.provider "virtualbox" do |v|
    #     v.memory = 2048
    #     v.cpus = 2
    # end
      
    config.vm.define "k8s-master" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "public_network", ip: "192.168.1.180"
        master.vm.hostname = "k8s-master"
        master.vm.provider "virtualbox" do |v|
            v.memory = 2048
            v.cpus = 2
        end
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "playbooks/docker-k8s.yaml"
            ansible.verbose = "v"
            ansible.extra_vars = {
                node_ip: "192.168.1.180",
            }
        end
    end

    (1..N).each do |i|
        config.vm.define "node#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "public_network", ip: "192.168.1.#{i + 180}"
            node.vm.hostname = "node#{i}"
            node.vm.provider "virtualbox" do |v|
                v.memory = 3072
                v.cpus = 2
            end
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "playbooks/docker-k8s.yaml"
                ansible.verbose = "v"
                ansible.extra_vars = {
                    node_ip: "192.168.1.#{i + 180}",
                }
            end
        end
    end
end