#
# Makefile for SC Mesh
#


OUTPUT=scinet-mesh.json
TO_CLEAN_LIST=.to-clean

default: $(OUTPUT)


MESHES := $(shell find . -type d -name '*-mesh' -exec basename {} \;)

MESHES_JSON := $(MESHES:%=%.json)


%.json:
	$(MAKE) -C "$(basename $@)" "$@"
	echo $@ >> $(TO_CLEAN_LIST)
	cp "$(basename $@)/$@" $@
TO_CLEAN += $(MESHES_JSON)


$(OUTPUT): $(MESHES_JSON)
	jq --slurp 'reduce .[] as $$item ({}; . * $$item)' $(MESHES_JSON) > $@
TO_CLEAN += $(OUTPUT)


$(TO_CLEAN_LIST):
	touch $@
TO_CLEAN += $(TO_CLEAN_LIST)

clean: $(TO_CLEAN_LIST)
	for MESH in $(MESHES) ; \
	do \
		$(MAKE) -C $$MESH clean ; \
	done
	xargs -r rm -f < $(TO_CLEAN_LIST)
	rm -rf $(TO_CLEAN) *~
