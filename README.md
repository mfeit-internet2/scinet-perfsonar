# SCinet perfSONAR Deployment Workbench

This project contains infrastructure for running a mockup of the
SCinet perfSONAR deployment on VMs.

More to come...



## Setup

 * Add SSH public key to the `ssh/user-keys` directory, one per file.
   All of these will be authorized to log into the ansible account.

 * Update the list of DNOCs in `mesh/booth-mesh/dnocs.json` for the
   current year's NOC and DNOCs.

 * Populate `mesh/booth-mesh/booths-scinet/scinet-booths.csv` and
``mesh/booth-mesh/booths-scinet/scinet-vlans.csv` with data from the
intranet.  Note that this currently requires some hand massaging.
That will be remedied.

