Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7C6A321967BC4
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 22:32:55 -0700 (PDT)
Subject: [ndctl PATCH] test: update dpa-alloc for v1.2 labels
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 08 Jun 2017 22:27:38 -0700
Message-ID: <149698605827.12023.17205386042313262239.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The v1.2 specification changes the default label size from 128 to 256.
Account for this difference by initializing DEFAULT_AVAILABLE_SLOTS from
sysfs directly, rather than hard-coding.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/dpa-alloc.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/test/dpa-alloc.c b/test/dpa-alloc.c
index 9c80fa3fc8c9..d13cf5dde66f 100644
--- a/test/dpa-alloc.c
+++ b/test/dpa-alloc.c
@@ -38,7 +38,6 @@ static const char *NFIT_PROVIDER0 = "nfit_test.0";
 static const char *NFIT_PROVIDER1 = "nfit_test.1";
 #define SZ_4K 0x1000UL
 #define NUM_NAMESPACES 4
-#define DEFAULT_AVAILABLE_SLOTS 1015
 
 struct test_dpa_namespace {
 	struct ndctl_namespace *ndns;
@@ -48,8 +47,8 @@ struct test_dpa_namespace {
 
 static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 {
+	unsigned int default_available_slots, available_slots, i;
 	struct ndctl_region *region, *blk_region = NULL;
-	unsigned int available_slots, i;
 	struct ndctl_namespace *ndns;
 	struct ndctl_dimm *dimm;
 	unsigned long size;
@@ -110,13 +109,7 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 		return -ENXIO;
 	}
 
-	available_slots = ndctl_dimm_get_available_labels(dimm);
-	if (available_slots < DEFAULT_AVAILABLE_SLOTS) {
-		fprintf(stderr, "%s: expected %d\n",
-				ndctl_dimm_get_devname(dimm),
-				DEFAULT_AVAILABLE_SLOTS);
-		return -ENXIO;
-	}
+	default_available_slots = ndctl_dimm_get_available_labels(dimm);
 
 	/* grow namespaces */
 	for (i = 0; i < ARRAY_SIZE(namespaces); i++) {
@@ -151,10 +144,10 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 	}
 
 	available_slots = ndctl_dimm_get_available_labels(dimm);
-	if (available_slots != DEFAULT_AVAILABLE_SLOTS
+	if (available_slots != default_available_slots
 			- ARRAY_SIZE(namespaces)) {
 		fprintf(stderr, "expected %ld slots available\n",
-				DEFAULT_AVAILABLE_SLOTS
+				default_available_slots
 				- ARRAY_SIZE(namespaces));
 		return -ENOSPC;
 	}
@@ -278,7 +271,7 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 	}
 
 	available_slots = ndctl_dimm_get_available_labels(dimm);
-	if (available_slots != DEFAULT_AVAILABLE_SLOTS - 1) {
+	if (available_slots != default_available_slots - 1) {
 		fprintf(stderr, "mishandled slot count\n");
 		return -ENXIO;
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
