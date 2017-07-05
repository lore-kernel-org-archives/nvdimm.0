Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 17D6320958969
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 13:53:32 -0700 (PDT)
Subject: [ndctl PATCH 2/6] ndctl, test: unit test new pmem sector_size support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 05 Jul 2017 13:48:45 -0700
Message-ID: <149928772549.25150.18177511817820531741.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149928771519.25150.13314997328838983545.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149928771519.25150.13314997328838983545.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Expand test/libndctl to validate the new support in 4.13 for specifying
a sector_size for pmem namespaces.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |   59 +++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 15 deletions(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 0f67d548ca48..e1c8ee9aabf8 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -247,21 +247,22 @@ struct namespace {
 	uuid_t uuid;
 	int do_configure;
 	int check_alt_name;
-	int num_sector_sizes;
 	int ro;
+	int num_sector_sizes;
 	unsigned long *sector_sizes;
 };
 
 static uuid_t null_uuid;
-static unsigned long blk_sector_sizes[7] = { 512, 520, 528, 4096, 4104, 4160, 4224, };
-static unsigned long pmem_sector_sizes[1] = { 0 };
+static unsigned long blk_sector_sizes[] = { 512, 520, 528, 4096, 4104, 4160, 4224, };
+static unsigned long pmem_sector_sizes[] = { 512, 4096 };
 
 static struct namespace namespace0_pmem0 = {
 	0, "namespace_pmem", &btt_settings, &pfn_settings, &dax_settings, SZ_18M,
 	{ 1, 1, 1, 1,
 	  1, 1, 1, 1,
 	  1, 1, 1, 1,
-	  1, 1, 1, 1, }, 1, 1, 1, 0, pmem_sector_sizes,
+	  1, 1, 1, 1, }, 1, 1, 0,
+	ARRAY_SIZE(pmem_sector_sizes), pmem_sector_sizes,
 };
 
 static struct namespace namespace1_pmem0 = {
@@ -269,7 +270,8 @@ static struct namespace namespace1_pmem0 = {
 	{ 2, 2, 2, 2,
 	  2, 2, 2, 2,
 	  2, 2, 2, 2,
-	  2, 2, 2, 2, }, 1, 1, 1, 0, pmem_sector_sizes,
+	  2, 2, 2, 2, }, 1, 1, 0,
+	ARRAY_SIZE(pmem_sector_sizes), pmem_sector_sizes,
 };
 
 static struct namespace namespace2_blk0 = {
@@ -277,7 +279,8 @@ static struct namespace namespace2_blk0 = {
 	{ 3, 3, 3, 3,
 	  3, 3, 3, 3,
 	  3, 3, 3, 3,
-	  3, 3, 3, 3, }, 1, 1, 7, 0, blk_sector_sizes,
+	  3, 3, 3, 3, }, 1, 1, 0,
+	ARRAY_SIZE(blk_sector_sizes), blk_sector_sizes,
 };
 
 static struct namespace namespace2_blk1 = {
@@ -285,7 +288,8 @@ static struct namespace namespace2_blk1 = {
 	{ 4, 4, 4, 4,
 	  4, 4, 4, 4,
 	  4, 4, 4, 4,
-	  4, 4, 4, 4, }, 1, 1, 7, 0, blk_sector_sizes,
+	  4, 4, 4, 4, }, 1, 1, 0,
+	ARRAY_SIZE(blk_sector_sizes), blk_sector_sizes,
 };
 
 static struct namespace namespace3_blk0 = {
@@ -293,7 +297,8 @@ static struct namespace namespace3_blk0 = {
 	{ 5, 5, 5, 5,
 	  5, 5, 5, 5,
 	  5, 5, 5, 5,
-	  5, 5, 5, 5, }, 1, 1, 7, 0, blk_sector_sizes,
+	  5, 5, 5, 5, }, 1, 1, 0,
+	ARRAY_SIZE(blk_sector_sizes), blk_sector_sizes,
 };
 
 static struct namespace namespace3_blk1 = {
@@ -301,7 +306,8 @@ static struct namespace namespace3_blk1 = {
 	{ 6, 6, 6, 6,
 	  6, 6, 6, 6,
 	  6, 6, 6, 6,
-	  6, 6, 6, 6, }, 1, 1, 7, 0, blk_sector_sizes,
+	  6, 6, 6, 6, }, 1, 1, 0,
+	ARRAY_SIZE(blk_sector_sizes), blk_sector_sizes,
 };
 
 static struct namespace namespace4_blk0 = {
@@ -309,7 +315,8 @@ static struct namespace namespace4_blk0 = {
 	{ 7, 7, 7, 7,
 	  7, 7, 7, 7,
 	  7, 7, 7, 7,
-	  7, 7, 7, 7, }, 1, 1, 7, 0, blk_sector_sizes,
+	  7, 7, 7, 7, }, 1, 1, 0,
+	ARRAY_SIZE(blk_sector_sizes), blk_sector_sizes,
 };
 
 static struct namespace namespace5_blk0 = {
@@ -317,7 +324,8 @@ static struct namespace namespace5_blk0 = {
 	{ 8, 8, 8, 8,
 	  8, 8, 8, 8,
 	  8, 8, 8, 8,
-	  8, 8, 8, 8, }, 1, 1, 7, 0, blk_sector_sizes,
+	  8, 8, 8, 8, }, 1, 1, 0,
+	ARRAY_SIZE(blk_sector_sizes), blk_sector_sizes,
 };
 
 static struct region regions0[] = {
@@ -1619,6 +1627,8 @@ static int validate_bdev(const char *devname, struct ndctl_btt *btt,
 static int check_namespaces(struct ndctl_region *region,
 		struct namespace **namespaces, enum ns_mode mode)
 {
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
+	struct ndctl_test *test = ndctl_get_private_data(ctx);
 	struct ndctl_bus *bus = ndctl_region_get_bus(region);
 	struct ndctl_namespace **ndns_save;
 	struct namespace *namespace;
@@ -1636,8 +1646,10 @@ static int check_namespaces(struct ndctl_region *region,
  retry:
 	ndns_save = NULL;
 	for (i = 0; (namespace = namespaces[i]); i++) {
-		struct ndctl_namespace *ndns;
 		uuid_t uu;
+		struct ndctl_namespace *ndns;
+		unsigned long _sizes[] = { 0 }, *sector_sizes = _sizes;
+		int num_sector_sizes = (int) ARRAY_SIZE(_sizes);
 
 		snprintf(devname, sizeof(devname), "namespace%d.%d",
 				ndctl_region_get_id(region), namespace->id);
@@ -1648,7 +1660,15 @@ static int check_namespaces(struct ndctl_region *region,
 			break;
 		}
 
-		for (j = 0; j < namespace->num_sector_sizes; j++) {
+		if (ndctl_region_get_type(region) == ND_DEVICE_REGION_PMEM
+				&& !ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0)))
+			/* pass, no sector_size support for pmem prior to 4.13 */;
+		else {
+			num_sector_sizes = namespace->num_sector_sizes;
+			sector_sizes = namespace->sector_sizes;
+		}
+
+		for (j = 0; j < num_sector_sizes; j++) {
 			struct btt *btt_s = NULL;
 			struct pfn *pfn_s = NULL;
 			struct dax *dax_s = NULL;
@@ -1657,7 +1677,7 @@ static int check_namespaces(struct ndctl_region *region,
 			struct ndctl_dax *dax = NULL;
 
 			rc = configure_namespace(region, ndns, namespace,
-					namespace->sector_sizes[j], mode);
+					sector_sizes[j], mode);
 			if (rc < 0) {
 				fprintf(stderr, "%s: failed to configure namespace\n",
 						devname);
@@ -1735,6 +1755,15 @@ static int check_namespaces(struct ndctl_region *region,
 				break;
 			}
 
+			if (sector_sizes[j] && sector_sizes[j]
+					!= ndctl_namespace_get_sector_size(ndns)) {
+				fprintf(stderr, "%s: expected lbasize: %#lx got: %#x\n",
+						devname, sector_sizes[j],
+						ndctl_namespace_get_sector_size(ndns));
+				rc = -ENXIO;
+				break;
+			}
+
 			ndctl_namespace_get_uuid(ndns, uu);
 			if (uuid_compare(uu, namespace->uuid) != 0) {
 				char expect[40], actual[40];
@@ -1812,7 +1841,7 @@ static int check_namespaces(struct ndctl_region *region,
 			 * If this is the last sector size being tested, don't disable
 			 * the namespace
 			 */
-			if (j == namespace->num_sector_sizes - 1)
+			if (j == num_sector_sizes - 1)
 				break;
 
 			/*

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
