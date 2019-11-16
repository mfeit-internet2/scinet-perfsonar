#
# SC19 perfSONAR Deployment Test Boxes
#


hosts = [

      [ "publisher", "163.253.37.215" ],
      [ "archive",   "163.253.37.216" ],
      [ "maddash",   "163.253.37.217" ],
      [ "noc",       "163.253.37.218" ],
      [ "dnoc1",     "163.253.37.219" ],
      [ "dnoc2",     "163.253.37.220" ],

      # This is built last so it can provision the others
      [ "ansible",   "163.253.37.214" ]
]

gateway = "163.253.37.193"

etc_hosts = hosts.map { |host, ip| "#{ip} #{host}" }.join("\n")


Vagrant.configure("2") do |config|

  # The default E1000 has a security vulerability.
  config.vm.provider "virtualbox" do |vbox|
    vbox.default_nic_type = "82543GC"
  end

  hosts.each do |name, ip|

    config.vm.define name do |host|

      host.vm.provider "virtualbox" do |vb|
        vb.cpus = 2
        vb.memory = 4096
        # Don't need the guest extensions on this host.
        if Vagrant.has_plugin?("vagrant-vbguest")
          config.vbguest.auto_update = false
        end
      end

      host.vm.box = "centos/7"
      host.vm.hostname = name

      host.vm.network "public_network", bridge: "p3p1", ip: ip


      # Set the default route

      # NOTE: This contains configuration specific to the Internet2
      # perfSONAR development farm.

      # TODO: Some of these provisions only need to be run once.
      host.vm.provision "#{name}-default-route", type: "shell", run: "always", inline: <<-SHELL

        set -e

	# TODO: REMOVE THESE
        #ip route del default
        #ip route add default via "#{gateway}"

        echo "GATEWAY=#{gateway}" >> /etc/sysconfig/network-scripts/ifcfg-eth1

	# Make sure DHCP interfaces don't add their own defaults

	for FILE in $(egrep -le '^BOOTPROTO=.?dhcp.?' /etc/sysconfig/network-scripts/ifcfg-* \
	    | egrep -ve '\.bak$')              
	do
	    sed -i -e '/^DEFROUTE=/d' "${FILE}"
	    echo "DEFROUTE=no" >> "${FILE}"
	done


	systemctl restart network

      SHELL


      # Fill the hosts file

      host.vm.provision "#{name}-hosts", type: "shell", run: "always", inline: <<-SHELL

        set -e

        fgrep localhost /etc/hosts > /etc/hosts.build
        echo "#{etc_hosts}" >> /etc/hosts.build
	mv -f /etc/hosts.build /etc/hosts

      SHELL

 
      # Account and system setup

      host.vm.provision "#{name}-ansible-user", type: "shell", run: "always", inline: <<-SHELL

        set -e

        cd /vagrant
	./build-ansible-account ./ssh/id_rsa.pub

      SHELL

 
      # Controller-only setup

      if name == "ansible"

        host.vm.provision "ansible-controller", type: "shell", run: "always", inline: <<-SHELL

	  set -e

	  cd /vagrant
	  ./provision-controller

        SHELL

      end  # If ansible

    end  # Config

  end  # hosts.each

end
