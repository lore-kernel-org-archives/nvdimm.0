Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D90BE211ADA31
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 20:04:22 -0800 (PST)
Subject: [ndctl PATCH] ndctl/init-labels: Fix label slot accounting per UEFI
 2.7
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Jan 2019 19:51:45 -0800
Message-ID: <154752430517.1624143.5852218139800007530.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Sujith Pandel <sujith_pandel@dell.com>
List-ID: <linux-nvdimm@lists.01.org>

Quoting from Linux kernel commit 9e694d9c18dd "libnvdimm, label: change
nvdimm_num_label_slots per UEFI 2.7":

    sizeof_namespace_index() fails when NVDIMM devices have the minimum
    1024 bytes label storage area.  nvdimm_num_label_slots() returns 3
    slots while the area is only big enough for 2 slots.

    Change nvdimm_num_label_slots() to calculate a number of label slots
    according to UEFI 2.7 spec.

Without this fix attempts to initialize labels on a small (1K) label
area results in the following:

libndctl: sizeof_namespace_index: nmem2: label area (1024) too small to host (128 byte) labels
libndctl: sizeof_namespace_index: nmem2: label area (1024) too small to host (256 byte) labels

Based on an original patch by Toshi Kani
Fixes: bdaec95463ca ("ndctl: introduce ndctl_dimm_{validate_labels,init_labels}")
Reported-by: Sujith Pandel <sujith_pandel@dell.com>
Link: https://github.com/pmem/ndctl/issues/78
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/dimm.c |   35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 79e2ca0aa5e2..beb67890a2df 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -66,9 +66,27 @@ static unsigned int sizeof_namespace_label(struct nvdimm_data *ndd)
 	return ndctl_dimm_sizeof_namespace_label(to_dimm(ndd));
 }
 
+static size_t __sizeof_namespace_index(u32 nslot)
+{
+	return ALIGN(sizeof(struct namespace_index) + DIV_ROUND_UP(nslot, 8),
+			NSINDEX_ALIGN);
+}
+
+static int __nvdimm_num_label_slots(struct nvdimm_data *ndd,
+		size_t index_size)
+{
+	return (ndd->config_size - index_size * 2) /
+		sizeof_namespace_label(ndd);
+}
+
 static int nvdimm_num_label_slots(struct nvdimm_data *ndd)
 {
-	return ndd->config_size / (sizeof_namespace_label(ndd) + 1);
+	u32 tmp_nslot, n;
+
+	tmp_nslot = ndd->config_size / sizeof_namespace_label(ndd);
+	n = __sizeof_namespace_index(tmp_nslot) / NSINDEX_ALIGN;
+
+	return __nvdimm_num_label_slots(ndd, NSINDEX_ALIGN * n);
 }
 
 static unsigned int sizeof_namespace_index(struct nvdimm_data *ndd)
@@ -78,18 +96,15 @@ static unsigned int sizeof_namespace_index(struct nvdimm_data *ndd)
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 
 	/*
-	 * The minimum index space is 512 bytes, with that amount of
-	 * index we can describe ~1400 labels which is less than a byte
-	 * of overhead per label.  Round up to a byte of overhead per
-	 * label and determine the size of the index region.  Yes, this
-	 * starts to waste space at larger config_sizes, but it's
-	 * unlikely we'll ever see anything but 128K.
+	 * Per UEFI 2.7, the minimum size of the Label Storage Area is
+	 * large enough to hold 2 index blocks and 2 labels.  The
+	 * minimum index block size is 256 bytes, and the minimum label
+	 * size is 256 bytes.
 	 */
 	nslot = nvdimm_num_label_slots(ndd);
 	space = ndd->config_size - nslot * sizeof_namespace_label(ndd);
-	size = ALIGN(sizeof(struct namespace_index) + DIV_ROUND_UP(nslot, 8),
-			NSINDEX_ALIGN) * 2;
-	if (size <= space)
+	size = __sizeof_namespace_index(nslot) * 2;
+	if (size <= space && nslot >= 2)
 		return size / 2;
 
 	err(ctx, "%s: label area (%ld) too small to host (%d byte) labels\n",

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
