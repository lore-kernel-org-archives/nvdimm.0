Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 4A9FE1A1E2B
 for <linux-nvdimm@lists.01.org>; Wed,  3 Aug 2016 16:25:51 -0700 (PDT)
Subject: [ndctl PATCH 4/4] test: skip 4.7+ tests on older kernels
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 03 Aug 2016 16:23:27 -0700
Message-ID: <147026660708.11162.11639119845161817556.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147026658649.11162.4510254495491443980.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147026658649.11162.4510254495491443980.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add ndctl_test_attempt() guards on tests that will fail on 4.6 and older
kernels.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/dax-errors.sh |    9 +++++++
 test/device-dax.sh |   10 +++++++
 test/libndctl.c    |   70 ++++++++++++++++++++++++++++++++--------------------
 3 files changed, 62 insertions(+), 27 deletions(-)

diff --git a/test/dax-errors.sh b/test/dax-errors.sh
index 2a498f11e089..a383b14fcd5e 100755
--- a/test/dax-errors.sh
+++ b/test/dax-errors.sh
@@ -23,6 +23,15 @@ err() {
 	exit $rc
 }
 
+eval $(uname -r | awk -F. '{print "maj="$1 ";" "min="$2}')
+if [ $maj -lt 4 ]; then
+	echo "kernel $maj.$min lacks dax error handling"
+	exit $rc
+elif [ $maj -eq 4 -a $min -lt 7 ]; then
+	echo "kernel $maj.$min lacks dax error handling"
+	exit $rc
+fi
+
 set -e
 mkdir -p $MNT
 trap 'err $LINENO' ERR
diff --git a/test/device-dax.sh b/test/device-dax.sh
index f24a350b2806..6bc724fe7c95 100755
--- a/test/device-dax.sh
+++ b/test/device-dax.sh
@@ -1,6 +1,7 @@
 #!/bin/bash
 NDCTL="../ndctl/ndctl"
 json2var="s/[{}\",]//g; s/:/=/g; s/\]//g"
+rc=77
 
 err() {
 	rc=$?
@@ -8,6 +9,15 @@ err() {
 	exit $rc
 }
 
+eval $(uname -r | awk -F. '{print "maj="$1 ";" "min="$2}')
+if [ $maj -lt 4 ]; then
+	echo "kernel $maj.$min lacks device-dax"
+	exit $rc
+elif [ $maj -eq 4 -a $min -lt 7 ]; then
+	echo "kernel $maj.$min lacks device-dax"
+	exit $rc
+fi
+
 set -e -x
 trap 'err $LINENO' ERR
 
diff --git a/test/libndctl.c b/test/libndctl.c
index 011d905f7fb4..684235d65eac 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2251,6 +2251,11 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	};
 	unsigned int i, rc = 0;
 
+	/* the kernel did not start emulating smart data until 4.7 */
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0)))
+		dimm_commands &= ~((1 << ND_CMD_SMART)
+				| (1 << ND_CMD_SMART_THRESHOLD));
+
 	/* Check DIMM commands */
 	check_cmds = __check_dimm_cmds;
 	for (i = 0; i < BITS_PER_LONG; i++) {
@@ -2365,35 +2370,44 @@ static int check_dimms(struct ndctl_bus *bus, struct dimm *dimms, int n,
 			return -ENXIO;
 		}
 
-		if (ndctl_dimm_get_formats(dimm) != dimms[i].formats) {
-			fprintf(stderr, "dimm%d expected formats: %d got: %d\n",
-					i, dimms[i].formats,
-					ndctl_dimm_get_formats(dimm));
-			return -ENXIO;
-		}
-		for (j = 0; j < dimms[i].formats; j++) {
-			if (ndctl_dimm_get_formatN(dimm, j) != dimms[i].format[j]) {
-				fprintf(stderr, "dimm%d expected format[%d]: %d got: %d\n",
-						i, j, dimms[i].format[j],
-						ndctl_dimm_get_formatN(dimm, j));
+		if (ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0))) {
+			if (ndctl_dimm_get_formats(dimm) != dimms[i].formats) {
+				fprintf(stderr, "dimm%d expected formats: %d got: %d\n",
+						i, dimms[i].formats,
+						ndctl_dimm_get_formats(dimm));
 				return -ENXIO;
 			}
+			for (j = 0; j < dimms[i].formats; j++) {
+				if (ndctl_dimm_get_formatN(dimm, j) != dimms[i].format[j]) {
+					fprintf(stderr,
+						"dimm%d expected format[%d]: %d got: %d\n",
+							i, j, dimms[i].format[j],
+							ndctl_dimm_get_formatN(dimm, j));
+					return -ENXIO;
+				}
+			}
 		}
 
-		if (ndctl_dimm_get_subsystem_vendor(dimm)
-				!= dimms[i].subsystem_vendor) {
-			fprintf(stderr, "dimm%d expected subsystem vendor: %d got: %d\n",
-					i, dimms[i].subsystem_vendor,
-					ndctl_dimm_get_subsystem_vendor(dimm));
-			return -ENXIO;
+		if (ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0))) {
+			if (ndctl_dimm_get_subsystem_vendor(dimm)
+					!= dimms[i].subsystem_vendor) {
+				fprintf(stderr,
+					"dimm%d expected subsystem vendor: %d got: %d\n",
+						i, dimms[i].subsystem_vendor,
+						ndctl_dimm_get_subsystem_vendor(dimm));
+				return -ENXIO;
+			}
 		}
 
-		if (ndctl_dimm_get_manufacturing_date(dimm)
-				!= dimms[i].manufacturing_date) {
-			fprintf(stderr, "dimm%d expected manufacturing date: %d got: %d\n",
-					i, dimms[i].manufacturing_date,
-					ndctl_dimm_get_manufacturing_date(dimm));
-			return -ENXIO;
+		if (ndctl_test_attempt(test, KERNEL_VERSION(4, 8, 0))) {
+			if (ndctl_dimm_get_manufacturing_date(dimm)
+					!= dimms[i].manufacturing_date) {
+				fprintf(stderr,
+					"dimm%d expected manufacturing date: %d got: %d\n",
+						i, dimms[i].manufacturing_date,
+						ndctl_dimm_get_manufacturing_date(dimm));
+				return -ENXIO;
+			}
 		}
 
 		rc = check_commands(bus, dimm, bus_commands, dimm_commands, test);
@@ -2455,10 +2469,12 @@ static int do_test0(struct ndctl_ctx *ctx, struct ndctl_test *test)
 	ndctl_region_foreach(bus, region)
 		ndctl_region_enable(region);
 
-	rc = check_regions(bus, regions0, ARRAY_SIZE(regions0), DAX);
-	if (rc)
-		return rc;
-	reset_bus(bus);
+	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0))) {
+		rc = check_regions(bus, regions0, ARRAY_SIZE(regions0), DAX);
+		if (rc)
+			return rc;
+		reset_bus(bus);
+	}
 	rc = check_regions(bus, regions0, ARRAY_SIZE(regions0), PFN);
 	if (rc)
 		return rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
