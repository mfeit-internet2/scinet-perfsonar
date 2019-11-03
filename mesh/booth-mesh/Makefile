#
# Makefile for SC Booth Mesh
#

OUTPUT=booth-mesh.json

ifndef BOOTH_DIR
BOOTH_DIR := $(shell [ -d /vagrant ] && echo "dev" || echo "scinet")
endif

default: $(OUTPUT)


$(BOOTH_DIR)/booths.json::
	$(MAKE) -C $(BOOTH_DIR) booths.json

booths.json: $(BOOTH_DIR)/booths.json
	rm -f $@
	cp $(BOOTH_DIR)/$@ $@
TO_CLEAN += booths.json

dnocs.json: $(BOOTH_DIR)/dnocs.json
	rm -f $@
	cp $(BOOTH_DIR)/$@ $@
TO_CLEAN += dnocs.json


$(OUTPUT): build-mesh archives.json booths.json dnocs.json schedules.json tests.json
	./build-mesh > $@
MESHES += booth-mesh.json
TO_CLEAN += \
	addresses.json \
	groups.json \
	tasks.json \
	$(OUTPUT)


clean:
	$(MAKE) -C dev $@
	$(MAKE) -C scinet $@
	rm -rf $(TO_CLEAN) *~


todo:
	@fgrep -r "TODO:" . | fgrep -v 'fgrep -r "TODO:" .'
