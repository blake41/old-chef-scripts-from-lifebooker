# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "lucid64"

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :hostonly, "33.33.13.37"

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port 2812, 2812
  config.vm.forward_port 8080, 8080

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"


  # config.vm.provision :chef_solo do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { :mysql_password => "foo" }
  # end

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "apt"
    chef.add_recipe "vim"
    chef.add_recipe "monit"
    chef.add_recipe "mmonit"
    chef.add_recipe "openssl"
    #chef.add_recipe "mysql"
    chef.json = {
      :monit => {
        :services => ["resque_pool", "apache2", "memcached", "redis"],
        :workers => [{:name => "loot", :path => "/lifebooker", :type => "-y serial", :number => 3, :start => 1}, {:name => "search", :path => "/search", :type => nil, :number => 2, :start => 4}],
        :base_path => "/var/www/bb",
        :environment => "staging"
      },
      :mysql => {:server_root_password => "blake_admin"}
    }
  end
end
