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

      # TODO: Some of these provisions only need to be run once.
      host.vm.provision "#{name}-default-route", type: "shell", run: "always", inline: <<-SHELL

        set -e

        ip route del default
        ip route add default via "#{gateway}"
        echo "GATEWAY=#{gateway}" >> /etc/sysconfig/network-scripts/ifcfg-eth1
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

        ANSIBLE_USER=ansible

        id ansible > /dev/null 2>1  \
	    && userdel --remove "${ANSIBLE_USER}"
        useradd -c "Ansible" "${ANSIBLE_USER}"
	echo "ansible ALL= (ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${ANSIBLE_USER}"

	ANSIBLE_HOME=~ansible

	SSHDIR="${ANSIBLE_HOME}/.ssh"
	rm -rf "${SSHDIR}"
	mkdir -p "${SSHDIR}"
	cat /vagrant/ssh/*.pub > "${SSHDIR}/authorized_keys"

	# Batten down the SSH directory's hatches.
	chown -R ansible.ansible "${SSHDIR}"
	chmod 700 "${SSHDIR}"
	find "${SSHDIR}" -type f | xargs -r chmod 400


      SHELL

 
      # Controller-only setup

      if name == "ansible"

        host.vm.provision "ansible-controller", type: "shell", run: "always", inline: <<-SHELL

	  set -e

	  ANSIBLE_USER=ansible
	  ANSIBLE_HOME=~ansible

	  # EPEL has newer versions of a few things.  Use it.

	  # Determine the RHEL version without depending on lsb_release.
	  REDHAT_RELEASE_MAJOR=$(sed -e 's/^.* \([0-9.]\+\) .*$/\1/' /etc/redhat-release | awk -F. '{ print $1 }')
	  # TODO:  Remove vvv, fix ^^^
	  REDHAT_RELEASE_MAJOR=7

	  EPEL_OP=$(rpm -q --quiet epel-release && echo update || echo install)
	  yum -y "${EPEL_OP}" "https://dl.fedoraproject.org/pub/epel/epel-release-latest-${REDHAT_RELEASE_MAJOR}.noarch.rpm"


	  #
	  # Configure SSH
	  #

	  SSHDIR="${ANSIBLE_HOME}/.ssh"

	  # Our own keys
	  cp /vagrant/ssh/id_* "${SSHDIR}"

	  # Keys of friendly users
	  UKEYS=/vagrant/ssh/user_keys
	  for NEWUSER in $(cd "${UKEYS}" && ls)
	  do
	  	cat "${UKEYS}/${NEWUSER}" >> "${SSHDIR}/authorized_keys"
	  done

	  # Install the SSH config
	  cp /vagrant/ssh/config "${SSHDIR}/config"

	  # Batten down the SSH directory's hatches.
	  chown -R "${ANSIBLE_USER}.${ANSIBLE_USER}" "${SSHDIR}"
	  chmod 700 "${SSHDIR}"
	  find "${SSHDIR}" -type f | xargs -r chmod 400

	  #
	  # Install Ansible and provision everything
	  #

          yum -y install ansible git

	  cd "${ANSIBLE_HOME}"

	  # Install the playbook

	  PLAYBOOK=ansible-playbook-perfsonar
	  rm -rf ${PLAYBOOK}
	  git clone "https://github.com/perfsonar/${PLAYBOOK}.git"
	  PLAYBOOK=$(cd "${PLAYBOOK}" && pwd)
	  ( cd "${PLAYBOOK}" \
	      && ansible-galaxy install -r requirements.yml --ignore-errors )

	  # Install the inventory

	  # TODO: This should wind up in the ansible subdirectory as non-Git
	  INVENTORY="ansible-inventory-perfsonar-example"
	  rm -rf "${PLAYBOOK}/${INVENTORY}"
	  (cd "${PLAYBOOK}" && git clone "https://github.com/perfsonar/${INVENTORY}.git")
	  INVENTORY=$(cd "${PLAYBOOK}/${INVENTORY}/inventory" && pwd)

	  # Build and install the mesh configuration

	  yum -y install jq
	  make -C /vagrant/mesh clean
	  make -C /vagrant/mesh
	  cp /vagrant/mesh/sc-mesh ${PLAYBOOK}/files/mesh.json

	  # Make ansible own all of it

	  chown -R "${ANSIBLE_USER}.${ANSIBLE_USER}" "${PLAYBOOK}"

	  # Make sure Ansible can see everything and do the deed.

	  sudo -u "${ANSIBLE_USER}" ansible -i "${INVENTORY}" all -m ping

  	  ( cd "${PLAYBOOK}" \
	      && sudo -u "${ANSIBLE_USER}" ansible-playbook -i "${INVENTORY}" perfsonar.yml ) \
	      | tee "${HOME}/ansible.out"

        SHELL

      end  # If ansible

    end  # Config

  end  # hosts.each

end
