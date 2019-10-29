#                                                                                                                        
# Makefile for SSH Files
#

id_rsa id_rsa.pub:
	ssh-keygen -N "" -C "SCinet perfSONAR Ansible Account" -f id_rsa -q
TO_CLEAN += id_rsa id_rsa.pub



clean:
	rm -rf $(TO_CLEAN) *~
