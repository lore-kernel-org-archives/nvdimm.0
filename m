Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 762601A1E96
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 09:42:47 -0700 (PDT)
Subject: [PATCH 12/14] libnvdimm,
 namespace: filter out of range labels in scan_labels()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Oct 2016 09:39:44 -0700
Message-ID: <147585838456.22349.11041036053134955923.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Short-circuit doomed-to-fail label validation attempts by skipping
labels that are outside the given region.  For example a DIMM that has
multiple PMEM regions will waste time attempting to create namespaces
only to find that the interleave-set-cookie does not validate, e.g.:

    nd_region region6: invalid cookie in label: 73e608dc-47b9-4b2a-b5c7-2d55a32e0c2

Similar to how we skip BLK labels when performing PMEM validation we can
skip out-of-range labels early.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 81451c74b01c..54babc3a80ca 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2013,10 +2013,11 @@ static int cmp_dpa(const void *a, const void *b)
 
 static struct device **scan_labels(struct nd_region *nd_region)
 {
-	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+	int i, count = 0;
 	struct device *dev, **devs = NULL;
 	struct nd_label_ent *label_ent, *e;
-	int i, count = 0;
+	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+	resource_size_t map_end = nd_mapping->start + nd_mapping->size - 1;
 
 	/* "safe" because create_namespace_pmem() might list_move() label_ent */
 	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
@@ -2033,6 +2034,10 @@ static struct device **scan_labels(struct nd_region *nd_region)
 		else
 			continue;
 
+		/* skip labels that describe extents outside of the region */
+		if (nd_label->dpa < nd_mapping->start || nd_label->dpa > map_end)
+			continue;
+
 		i = add_namespace_resource(nd_region, nd_label, devs, count);
 		if (i < 0)
 			goto err;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
