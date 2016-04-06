# -*- mode: ruby -*-
#internet vi: set ft=ruby :
# Copy this file to Vagrantfile in the parent directory.

#require 'json'
require 'yaml'

def symbolize_keys(hash)
  hash.inject({}){|result, (key, value)|
    new_key = case key
                when String then key.to_sym
                else key
              end
    new_value = case value
                  when Hash then symbolize_keys(value)
                  else value
                end
    result[new_key] = new_value
    result
  }
end

dir = File.dirname(File.expand_path(__FILE__))

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

configValues = YAML.load_file("#{dir}/config.yaml")
hosts        = symbolize_keys(configValues['vagrantfile-local'])

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.forward_agent = true
  config.vbguest.auto_update = false

  #Hosts definition
  hosts.each do |name,cfg|

    config.vm.box = cfg[:box]
    config.vm.box_url = cfg[:box_url]

    config.vm.define name do |vm_config|

      if cfg[:hostname].to_s.strip.length != 0
        vm_config.vm.hostname = "#{cfg[:hostname]}"
      end

      if cfg[:network][:private_network].to_s != ''
        vm_config.vm.network :private_network, ip: "#{cfg[:network][:private_network]}"
      end

      cfg[:network][:forwarded_port].each do |i, port|
        if port[:guest] != '' && port[:host] != ''
          config.vm.network :forwarded_port, guest: port[:guest].to_i, host: port[:host].to_i
        end
      end

      vm_config.vm.provider :virtualbox do |vbox|
        vbox.name = "#{vm_config.vm.hostname}"
        vbox.memory = cfg[:memory]
      end
      config.vm.provision "shell", path: cfg[:provision_script], :args => cfg[:network][:private_network]

    end
  end

  config.vm.provision :hosts do |hosts|

    hosts.add_host '10.141.141.10' , [
      "mesos-master",
    ]
    hosts.add_host '10.141.141.11' , [
      "mesos-slave1",
    ]
    hosts.add_host '10.141.141.12' , [
      "mesos-slave2",
    ]
    hosts.add_host '10.141.141.13' , [
      "mesos-slave3",
    ]
  end

end

