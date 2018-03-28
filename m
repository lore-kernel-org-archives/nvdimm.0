Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F66521F85E90
 for <linux-nvdimm@lists.01.org>; Wed, 28 Mar 2018 13:08:53 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] ndctl, label: change nvdimm_num_label_slots per UEFI 2.7
Date: Wed, 28 Mar 2018 14:15:12 -0600
Message-Id: <20180328201512.5688-1-toshi.kani@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

sizeof_namespace_index() fails when NVDIMM devices have the minimum
1024 bytes label storage area.  nvdimm_num_label_slots() returns 3
slots while the area is only big enough for 2 slots.

Change nvdimm_num_label_slots() to calculate a number of label slots
according to UEFI 2.7 spec.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/dimm.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index b3e032e..6b78a4b 100644
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
+			sizeof_namespace_label(ndd);
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
@@ -78,18 +96,14 @@ static unsigned int sizeof_namespace_index(struct nvdimm_data *ndd)
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 
 	/*
-	 * The minimum index space is 512 bytes, with that amount of
-	 * index we can describe ~1400 labels which is less than a byte
-	 * of overhead per label.  Round up to a byte of overhead per
-	 * label and determine the size of the index region.  Yes, this
-	 * starts to waste space at larger config_sizes, but it's
-	 * unlikely we'll ever see anything but 128K.
+	 * Per UEFI 2.7, the minimum size of the Label Storage Area is large
+	 * enough to hold 2 index blocks and 2 labels.  The minimum index
+	 * block size is 256 bytes, and the minimum label size is 256 bytes.
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
