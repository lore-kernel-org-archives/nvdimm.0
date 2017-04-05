Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64DBE203BF05E
 for <linux-nvdimm@lists.01.org>; Wed,  5 Apr 2017 15:48:13 -0700 (PDT)
Subject: [PATCH v2] ndctl: have daxdev-errors discover the ndbus
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 05 Apr 2017 15:48:12 -0700
Message-ID: <149143249281.26583.1760450815293833834.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Implementation had static config and made assumption that the bus and region
in nfit_test will be static. Adding code to discover the proper bus, region,
and also pass onto daxdev-errors.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 0 files changed

diff --git a/test/daxdev-errors.c b/test/daxdev-errors.c
index 687e593..321f942 100644
--- a/test/daxdev-errors.c
+++ b/test/daxdev-errors.c
@@ -234,7 +234,8 @@ static struct ndctl_dax * get_dax_region(struct ndctl_region *region)
 	return NULL;
 }
 
-static int test_daxdev_clear_error(void)
+static int test_daxdev_clear_error(const char *bus_name,
+		const char *region_name)
 {
 	int rc = 0, i;
 	struct ndctl_ctx *ctx;
@@ -264,10 +265,12 @@ static int test_daxdev_clear_error(void)
 	}
 
 	ndctl_region_foreach(bus, region) {
-		/* find the dax region */
-		dax = get_dax_region(region);
-		if (dax)
+		if (strncmp(region_name,
+				ndctl_region_get_devname(region), 256) == 0) {
+			/* find the dax region */
+			dax = get_dax_region(region);
 			break;
+		}
 	}
 
 	if (!dax) {
@@ -277,8 +280,9 @@ static int test_daxdev_clear_error(void)
 
 	/* get badblocks */
 	if (snprintf(path, 256,
-			"/sys/devices/platform/%s/ndbus0/%s/badblocks",
+			"/sys/devices/platform/%s/%s/%s/badblocks",
 			NFIT_PROVIDER0,
+			bus_name,
 			ndctl_region_get_devname(region)) >= 256) {
 		fprintf(stderr, "%s: buffer too small!\n",
 				ndctl_region_get_devname(region));
@@ -343,7 +347,7 @@ int main(int argc, char *argv[])
 	int rc;
 	struct sigaction act;
 
-	if (argc < 1)
+	if (argc < 1 || argc > 4)
 		return -EINVAL;
 
 	memset(&act, 0, sizeof(act));
@@ -355,7 +359,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	rc = test_daxdev_clear_error();
+	rc = test_daxdev_clear_error(argv[1], argv[2]);
 
 	return rc;
 }
diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index 1777210..88e4457 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -5,6 +5,7 @@ NDCTL="../ndctl/ndctl"
 DAXCTL="../daxctl/daxctl"
 BUS="-b nfit_test.0"
 BUS1="-b nfit_test.1"
+json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 
 err() {
@@ -33,34 +34,42 @@ $NDCTL disable-region $BUS all
 $NDCTL zero-labels $BUS all
 $NDCTL enable-region $BUS all
 
-json=$($NDCTL create-namespace $BUS -t pmem -m dax -a 4096)
+query=". | sort_by(.available_size) | reverse | .[0].dev"
+region=$($NDCTL list $BUS -t pmem -Ri | jq -r "$query")
+
+json=$($NDCTL create-namespace $BUS -r $region -t pmem -m dax -a 4096)
 chardev=$(echo $json | jq ". | select(.mode == \"dax\") | .daxregion.devices[0].chardev")
 
-#  "dev":"namespace5.0",
+#{
+#  "dev":"namespace6.0",
 #  "mode":"dax",
-#  "size":64475136,
-#  "uuid":"068776fa-50e6-4c27-b99a-4b1e710c627c",
+#  "size":64004096,
+#  "uuid":"83a925dd-42b5-4ac6-8588-6a50bfc0c001",
 #  "daxregion":{
-#    "id":5,
-#    "size":64475136,
+#    "id":6,
+#    "size":64004096,
 #    "align":4096,
 #    "devices":[
 #      {
-#        "chardev":"dax5.0",
-#        "size":64475136
+#        "chardev":"dax6.0",
+#        "size":64004096
 #      }
 #    ]
 #  }
+#}
+
+json1=$($NDCTL list $BUS)
+eval $(echo $json1 | sed -e "$json2var")
 
-read sector len < /sys/bus/platform/devices/nfit_test.0/ndbus0/region5/badblocks
+read sector len < /sys/bus/platform/devices/nfit_test.0/$dev/$region/badblocks
 echo "sector: $sector len: $len"
 
 # run the daxdev-errors test
 test -x ./daxdev-errors
-./daxdev-errors
+./daxdev-errors $dev $region
 
 # check badblocks, should be empty
-if read sector len < /sys/bus/platform/devices/nfit_test.0/ndbus0/region5/badblocks; then
+if read sector len < /sys/bus/platform/devices/nfit_test.0/$dev/$region/badblocks; then
 	echo "badblocks empty, expected"
 fi
 [ -n "$sector" ] && echo "fail: $LINENO" && exit 1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
