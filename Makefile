#                                                                                                                        
# Makefile for SC pS Test Environment
#

default: build

SUBDIRS=\
	ssh

build:
	for DIR in $(SUBDIRS) ; \
	do \
		$(MAKE) -C $$DIR ; \
	done
	false
	vagrant up --no-parallel


provision: id_rsa
	vagrant up --provision --no-parallel


ifndef SSH
  SSH=ansible
endif
login:
	vagrant ssh "$(SSH)" -c "sudo -i"


destroy:
	vagrant destroy -f


rebuild: destroy build


clean: destroy
	rm -rf $(TO_CLEAN) *~

