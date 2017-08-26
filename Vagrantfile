# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV["LC_ALL"] = "en_US.UTF-8"

# For installing ansible_local from pip on guest
Vagrant.require_version ">= 1.8.3"

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"

  config.vm.network "private_network", ip: "192.168.50.10"

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "ansible/configuration.yml"
    ansible.galaxy_role_file = "ansible/requirements.yml"
    ansible.galaxy_roles_path = "ansible/galaxy.roles"
    ansible.sudo = true
    ansible.extra_vars = {
      from_vagrant: true,
      deploy_user: "deployer_test",
    }
  end

  config.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
  config.vm.network "forwarded_port", guest: 3306, host: 33060, auto_correct: true
end
