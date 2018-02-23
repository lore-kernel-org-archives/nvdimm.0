Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5708321FD73D9
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 23:02:17 -0800 (PST)
Subject: [ndctl PATCH] ndctl, test: fix dpa-alloc for kernels with 4M min size
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Feb 2018 22:59:11 -0800
Message-ID: <151936915162.18166.5719880718484465492.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Now that ndctl is no longer using the kernel provided ndctl.h header,
and the minimum namespace size has been reduced on recent kernels, the
dpa-alloc test can no longer assume that ND_MIN_NAMESPACE_SIZE matches
what the kernel supports. Instead use a hard coded 4MB size that works
with all kernels.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/dpa-alloc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/test/dpa-alloc.c b/test/dpa-alloc.c
index 8bb7dd7408a1..9a9c6b64c504 100644
--- a/test/dpa-alloc.c
+++ b/test/dpa-alloc.c
@@ -25,13 +25,13 @@
 
 #include <test.h>
 #include <ndctl.h>
+#include <util/size.h>
 #include <linux/version.h>
 #include <ndctl/libndctl.h>
 #include <ccan/array_size/array_size.h>
 
 static const char *NFIT_PROVIDER0 = "nfit_test.0";
 static const char *NFIT_PROVIDER1 = "nfit_test.1";
-#define SZ_4K 0x1000UL
 #define NUM_NAMESPACES 4
 
 struct test_dpa_namespace {
@@ -40,6 +40,8 @@ struct test_dpa_namespace {
 	uuid_t uuid;
 } namespaces[NUM_NAMESPACES];
 
+#define MIN_SIZE SZ_4M
+
 static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 {
 	unsigned int default_available_slots, available_slots, i;
@@ -97,8 +99,7 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 	}
 	region = blk_region;
 
-	if (ndctl_region_get_available_size(region) / ND_MIN_NAMESPACE_SIZE
-			< NUM_NAMESPACES) {
+	if (ndctl_region_get_available_size(region) / MIN_SIZE < NUM_NAMESPACES) {
 		fprintf(stderr, "%s insufficient available_size\n",
 				ndctl_region_get_devname(region));
 		return -ENXIO;
@@ -119,7 +120,7 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 		uuid_generate_random(uuid);
 		ndctl_namespace_set_uuid(ndns, uuid);
 		ndctl_namespace_set_sector_size(ndns, 512);
-		ndctl_namespace_set_size(ndns, ND_MIN_NAMESPACE_SIZE);
+		ndctl_namespace_set_size(ndns, MIN_SIZE);
 		rc = ndctl_namespace_enable(ndns);
 		if (rc) {
 			fprintf(stderr, "failed to enable %s: %d\n",
@@ -129,7 +130,7 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 		ndctl_namespace_disable_invalidate(ndns);
 		rc = ndctl_namespace_set_size(ndns, SZ_4K);
 		if (rc) {
-			fprintf(stderr, "failed to init %s to size: %ld\n",
+			fprintf(stderr, "failed to init %s to size: %d\n",
 					ndctl_namespace_get_devname(ndns),
 					SZ_4K);
 			return rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
