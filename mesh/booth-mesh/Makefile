#
# Makefile for SC Booth Mesh
#

OUTPUT=booth-mesh.json

# TODO: Switch to scinet for production
#BOOTH_SET=dev
BOOTH_SET=scinet

default: $(OUTPUT)


BOOTH_DIR=booths-$(BOOTH_SET)

$(BOOTH_DIR)/booths.json::
	$(MAKE) -C $(BOOTH_DIR) booths.json

booths.json: $(BOOTH_DIR)/booths.json
	rm -f $@
	cp $(BOOTH_DIR)/$@ $@

TO_CLEAN += booths.json


$(OUTPUT): build-mesh archives.json booths.json dnocs.json schedules.json tests.json
	./build-mesh > $@
MESHES += booth-mesh.json
TO_CLEAN += \
	addresses.json \
	groups.json \
	tasks.json \
	$(OUTPUT)


clean:
	$(MAKE) -C $(BOOTH_DIR) $@
	rm -rf $(TO_CLEAN) *~


todo:
	@fgrep -r "TODO:" . | fgrep -v 'fgrep -r "TODO:" .'
