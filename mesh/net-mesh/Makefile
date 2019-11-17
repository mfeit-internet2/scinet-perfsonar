#
# Makefile for SC Network Mesh
#

OUTPUT=net-mesh.json

ifndef NETWORK
NETWORK := $(shell [ -d /vagrant ] && echo "dev" || echo "scinet")
endif

SOURCE := $(NETWORK).json
OUTPUT := net-mesh.json

default: $(OUTPUT)


$(OUTPUT): $(SOURCE)
	rm -f $@
	cp $< $@
TO_CLEAN += $(OUTPUT)





clean:
	rm -rf $(TO_CLEAN) *~
