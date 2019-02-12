Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9CA1C21A134A1
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 13:41:52 -0800 (PST)
Subject: [ndctl PATCH 5/8] ndctl/test: Update dax-dev to handle multiple
 e820 ranges
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Feb 2019 13:29:14 -0800
Message-ID: <155000695444.348282.5543592734851006870.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Establish a convention that the first, lowest-index, region on the e820
bus always enables in fsdax mode without need for an nd_pfn instance.
This is in preparation for a defining a collision test that requires
multiple section-mis-aligned regions defined by memmap=nn!ss.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/dax-dev.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/test/dax-dev.c b/test/dax-dev.c
index 0183b7af2052..49ccaa334e31 100644
--- a/test/dax-dev.c
+++ b/test/dax-dev.c
@@ -33,17 +33,28 @@ struct ndctl_namespace *ndctl_get_test_dev(struct ndctl_ctx *ctx)
 	struct ndctl_bus *bus;
 	struct ndctl_dax *dax;
 	struct ndctl_pfn *pfn;
-	struct ndctl_region *region;
 	struct ndctl_namespace *ndns;
 	enum ndctl_namespace_mode mode;
+	struct ndctl_region *region, *min = NULL;
 
 	bus = ndctl_bus_get_by_provider(ctx, "e820");
 	if (!bus)
 		goto out;
 
-	region = ndctl_region_get_first(bus);
-	if (!region)
+	ndctl_region_foreach(bus, region) {
+		if (!min) {
+			min = region;
+			continue;
+		}
+		if (ndctl_region_get_id(region) < ndctl_region_get_id(min))
+			min = region;
+	}
+	if (!min)
 		goto out;
+	region = min;
+
+	/* attempt to re-enable the region if a previous test disabled it */
+	ndctl_region_enable(region);
 
 	ndns = ndctl_namespace_get_first(region);
 	if (!ndns)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
