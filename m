Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5BDF381C2E
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jan 2017 18:09:03 -0800 (PST)
Subject: [ndctl PATCH] test, multi-pmem: check namespace deletion
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Jan 2017 18:04:57 -0800
Message-ID: <148427309710.29210.6139502982382358673.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The initial implementation of multi-pmem support neglected to enable
deletion of pmem namespaces. Add a test to check for this condition.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/multi-pmem.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/test/multi-pmem.c b/test/multi-pmem.c
index 8f76e02d2fd1..dd1269ced667 100644
--- a/test/multi-pmem.c
+++ b/test/multi-pmem.c
@@ -54,6 +54,28 @@ static void destroy_namespace(struct ndctl_namespace *ndns)
 	cmd_destroy_namespace(argc, argv, ctx);
 }
 
+/* Check that the namespace device is gone (if it wasn't the seed) */
+static int check_deleted(struct ndctl_region *region, const char *devname,
+		struct ndctl_test *test)
+{
+	struct ndctl_namespace *ndns;
+
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 10, 0)))
+		return 0;
+
+	ndctl_namespace_foreach(region, ndns) {
+		if (strcmp(devname, ndctl_namespace_get_devname(ndns)))
+			continue;
+		if (ndns == ndctl_region_get_namespace_seed(region))
+			continue;
+		fprintf(stderr, "mult-pmem: expected %s to be deleted\n",
+				devname);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
 static int do_multi_pmem(struct ndctl_ctx *ctx, struct ndctl_test *test)
 {
 	int i;
@@ -190,6 +212,9 @@ static int do_multi_pmem(struct ndctl_ctx *ctx, struct ndctl_test *test)
 					devname, blk_avail, blk_avail_orig);
 			return -ENXIO;
 		}
+
+		if (check_deleted(target, devname, test) != 0)
+			return -ENXIO;
 	}
 
 	ndns = namespaces[NUM_NAMESPACES - 1];
@@ -204,6 +229,9 @@ static int do_multi_pmem(struct ndctl_ctx *ctx, struct ndctl_test *test)
 		return -ENXIO;
 	}
 
+	if (check_deleted(target, devname, test) != 0)
+		return -ENXIO;
+
 	ndctl_bus_foreach(ctx, bus) {
 		if (strncmp(ndctl_bus_get_provider(bus), "nfit_test", 9) != 0)
 			continue;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
