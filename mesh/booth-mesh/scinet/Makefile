#
# Makefile for SC Booth Data
#


OUTPUT=booths.json
default: $(OUTPUT)

%.json: %.csv Makefile
	sed -e '/^#/d' $< \
		| jq -R -s -f csv2json.jq > $@

JSONS=\
	scinet-booths.json \
	scinet-vlans.json

TO_CLEAN+=$(JSONS)


# Booth list for mesh without DNOCs
booths-phase-1a: vlans2booth.jq scinet-vlans.json
	jq -f vlans2booth.jq scinet-vlans.json > $@
TO_CLEAN += booths-phase-1a


# Add gateways
booths-phase-1: booths-phase-1a
	./calculate-gateways < $< > $@
TO_CLEAN += booths-phase-1



# DNOC list
booths-phase-2: booths2dnocs.jq scinet-booths.json
	jq -f booths2dnocs.jq scinet-booths.json > $@
TO_CLEAN += booths-phase-2

$(OUTPUT): booths-phase-1 booths-phase-2 Makefile
	jq --slurp '.[1] as $$dnocs | [ .[0][] | .dnoc = $$dnocs[.booth] ]' \
	booths-phase-1 booths-phase-2 \
	> $@
TO_CLEAN += $(OUTPUT)


TO_CLEAN += booth.json


build: mesh-list.json


clean:
	rm -rf $(TO_CLEAN) *~
