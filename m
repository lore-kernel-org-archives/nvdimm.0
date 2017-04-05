Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7622421A6F107
 for <linux-nvdimm@lists.01.org>; Wed,  5 Apr 2017 12:40:17 -0700 (PDT)
Subject: [PATCH] ndctl: have daxdev-errors discover the ndbus
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 05 Apr 2017 12:40:16 -0700
Message-ID: <149142121625.9379.9247880188079374114.stgit@djiang5-desk3.ch.intel.com>
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

Implementation had static config and made assumption that the region in
nfit_test will be ndbus0. Adding code to discover the proper bus and also
pass onto daxdev-errors.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 test/daxdev-errors.c  |    9 +++++----
 test/daxdev-errors.sh |   11 ++++++++---
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/test/daxdev-errors.c b/test/daxdev-errors.c
index 687e593..d8d5324 100644
--- a/test/daxdev-errors.c
+++ b/test/daxdev-errors.c
@@ -234,7 +234,7 @@ static struct ndctl_dax * get_dax_region(struct ndctl_region *region)
 	return NULL;
 }
 
-static int test_daxdev_clear_error(void)
+static int test_daxdev_clear_error(const char *busname)
 {
 	int rc = 0, i;
 	struct ndctl_ctx *ctx;
@@ -277,8 +277,9 @@ static int test_daxdev_clear_error(void)
 
 	/* get badblocks */
 	if (snprintf(path, 256,
-			"/sys/devices/platform/%s/ndbus0/%s/badblocks",
+			"/sys/devices/platform/%s/%s/%s/badblocks",
 			NFIT_PROVIDER0,
+			busname,
 			ndctl_region_get_devname(region)) >= 256) {
 		fprintf(stderr, "%s: buffer too small!\n",
 				ndctl_region_get_devname(region));
@@ -343,7 +344,7 @@ int main(int argc, char *argv[])
 	int rc;
 	struct sigaction act;
 
-	if (argc < 1)
+	if (argc < 1 || argc > 3)
 		return -EINVAL;
 
 	memset(&act, 0, sizeof(act));
@@ -355,7 +356,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	rc = test_daxdev_clear_error();
+	rc = test_daxdev_clear_error(argv[1]);
 
 	return rc;
 }
diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index 1777210..ee07f81 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -5,6 +5,7 @@ NDCTL="../ndctl/ndctl"
 DAXCTL="../daxctl/daxctl"
 BUS="-b nfit_test.0"
 BUS1="-b nfit_test.1"
+json2var="s/[{}\",]//g; s/:/=/g"
 rc=77
 
 err() {
@@ -52,15 +53,19 @@ chardev=$(echo $json | jq ". | select(.mode == \"dax\") | .daxregion.devices[0].
 #    ]
 #  }
 
-read sector len < /sys/bus/platform/devices/nfit_test.0/ndbus0/region5/badblocks
+json1=$($NDCTL list $BUS)
+eval $(echo $json1 | sed -e "$json2var")
+
+echo "read /sys/bus/platform/devices/nfit_test.0/$dev/region5/badblocks"
+read sector len < /sys/bus/platform/devices/nfit_test.0/$dev/region5/badblocks
 echo "sector: $sector len: $len"
 
 # run the daxdev-errors test
 test -x ./daxdev-errors
-./daxdev-errors
+./daxdev-errors $dev
 
 # check badblocks, should be empty
-if read sector len < /sys/bus/platform/devices/nfit_test.0/ndbus0/region5/badblocks; then
+if read sector len < /sys/bus/platform/devices/nfit_test.0/$dev/region5/badblocks; then
 	echo "badblocks empty, expected"
 fi
 [ -n "$sector" ] && echo "fail: $LINENO" && exit 1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
