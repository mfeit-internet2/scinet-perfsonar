#
# Makefile for SC Network Mesh
#

OUTPUT=net-mesh.json

ifndef NETWORK
NETWORK := $(shell [ -d /vagrant ] && echo "dev" || echo "scinet")
endif




default: $(OUTPUT)


clean:
	rm -rf $(TO_CLEAN) *~
