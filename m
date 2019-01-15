Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3578E2194D3B9
 for <linux-nvdimm@lists.01.org>; Tue, 15 Jan 2019 12:25:48 -0800 (PST)
Subject: [PATCH] libnvdimm/label: Clear 'updating' flag after label-set update
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Jan 2019 12:13:11 -0800
Message-ID: <154758319127.1865528.486579211628557163.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, Kelly Couch <kelly.j.couch@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The UEFI 2.7 specification sets expectations that the 'updating' flag is
eventually cleared. To date, the libnvdimm core has never adhered to
that protocol. The policy of the core matches the policy of other
multi-device info-block formats like MD-Software-RAID that expect
administrator intervention on inconsistent info-blocks, not automatic
invalidation.

However, some pre-boot environments may unfortunately attempt to "clean
up" the labels and invalidate a set when it fails to find at least one
"non-updating" label in the set. Clear the updating flag after set
updates to minimize the window of vulnerability to aggressive pre-boot
environments.

Ideally implementations would not write to the label area outside of
creating namespaces.

Note that this only minimizes the window, it does not close it as the
system can still crash while clearing the flag and the set can be
subsequently deleted / invalidated by the pre-boot environment.

Fixes: f524bf271a5c ("libnvdimm: write pmem label set")
Cc: <stable@vger.kernel.org>
Cc: Kelly Couch <kelly.j.couch@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index a11bf4e6b451..6d6e9a12150b 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -755,7 +755,7 @@ static const guid_t *to_abstraction_guid(enum nvdimm_claim_class claim_class,
 
 static int __pmem_label_update(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, struct nd_namespace_pmem *nspm,
-		int pos)
+		int pos, unsigned long flags)
 {
 	struct nd_namespace_common *ndns = &nspm->nsio.common;
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
@@ -796,7 +796,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	memcpy(nd_label->uuid, nspm->uuid, NSLABEL_UUID_LEN);
 	if (nspm->alt_name)
 		memcpy(nd_label->name, nspm->alt_name, NSLABEL_NAME_LEN);
-	nd_label->flags = __cpu_to_le32(NSLABEL_FLAG_UPDATING);
+	nd_label->flags = __cpu_to_le32(flags);
 	nd_label->nlabel = __cpu_to_le16(nd_region->ndr_mappings);
 	nd_label->position = __cpu_to_le16(pos);
 	nd_label->isetcookie = __cpu_to_le64(cookie);
@@ -1249,13 +1249,13 @@ static int del_labels(struct nd_mapping *nd_mapping, u8 *uuid)
 int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		struct nd_namespace_pmem *nspm, resource_size_t size)
 {
-	int i;
+	int i, rc;
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 		struct resource *res;
-		int rc, count = 0;
+		int count = 0;
 
 		if (size == 0) {
 			rc = del_labels(nd_mapping, nspm->uuid);
@@ -1273,7 +1273,20 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		if (rc < 0)
 			return rc;
 
-		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i);
+		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i,
+				NSLABEL_FLAG_UPDATING);
+		if (rc)
+			return rc;
+	}
+
+	if (size == 0)
+		return 0;
+
+	/* Clear the UPDATING flag per UEFI 2.7 expectations */
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+
+		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i, 0);
 		if (rc)
 			return rc;
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
