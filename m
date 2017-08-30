Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2DE2F21E95DE0
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 19:15:29 -0700 (PDT)
Subject: [ndctl PATCH v2 09/10] ndctl: fix namespace index block size
 calculation
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 19:11:46 -0700
Message-ID: <150405910608.22171.177987736957743487.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150405905872.22171.7217183939530397385.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150405905872.22171.7217183939530397385.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The old calculation assumed that the label space was 128k and the label
size is 128. With v1.2 labels where the label size is 512 this
calculation will return zero. We were previously saved by the fact that
the nsindex_size is always pre-initialized from a previous 128 byte
assumption and we are lucky that the index sizes turn out the same.
However the new 'autolabel' code checked the size without it having been
initialized by a previous call where nslabel_size was 128.

Fix this going forward in case we start encountering different
geometries of label areas besides 128k.

Since the label size can change from one call to the next, drop the
caching of nsindex_size.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/dimm.c    |   34 +++++++++++++++++++---------------
 ndctl/lib/private.h |    1 -
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 49cf7cb9be6f..46eaf736988a 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -65,12 +65,16 @@ static unsigned int sizeof_namespace_label(struct nvdimm_data *ndd)
 	return ndctl_dimm_sizeof_namespace_label(to_dimm(ndd));
 }
 
-static unsigned int sizeof_namespace_index(struct nvdimm_data *ndd)
+static int nvdimm_num_label_slots(struct nvdimm_data *ndd)
 {
-	u32 index_span;
+	return ndd->config_size / (sizeof_namespace_label(ndd) + 1);
+}
 
-	if (ndd->nsindex_size)
-		return ndd->nsindex_size;
+static unsigned int sizeof_namespace_index(struct nvdimm_data *ndd)
+{
+	u32 nslot, space, size;
+	struct ndctl_dimm *dimm = to_dimm(ndd);
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 
 	/*
 	 * The minimum index space is 512 bytes, with that amount of
@@ -80,16 +84,17 @@ static unsigned int sizeof_namespace_index(struct nvdimm_data *ndd)
 	 * starts to waste space at larger config_sizes, but it's
 	 * unlikely we'll ever see anything but 128K.
 	 */
-	index_span = ndd->config_size / (sizeof_namespace_label(ndd) + 1);
-	index_span /= NSINDEX_ALIGN * 2;
-	ndd->nsindex_size = index_span * NSINDEX_ALIGN;
-
-	return ndd->nsindex_size;
-}
-
-static int nvdimm_num_label_slots(struct nvdimm_data *ndd)
-{
-	return ndd->config_size / (sizeof_namespace_label(ndd) + 1);
+	nslot = nvdimm_num_label_slots(ndd);
+	space = ndd->config_size - nslot * sizeof_namespace_label(ndd);
+	size = ALIGN(sizeof(struct namespace_index) + ALIGN(nslot, 8) / 8,
+			NSINDEX_ALIGN) * 2;
+	if (size <= space)
+		return size / 2;
+
+	err(ctx, "%s: label area (%ld) too small to host (%d byte) labels\n",
+			ndctl_dimm_get_devname(dimm), ndd->config_size,
+			sizeof_namespace_label(ndd));
+	return 0;
 }
 
 static struct namespace_index *to_namespace_index(struct nvdimm_data *ndd,
@@ -356,7 +361,6 @@ static void init_ndd(struct nvdimm_data *ndd, struct ndctl_cmd *cmd_read)
 	ndctl_cmd_ref(cmd_read);
 	ndd->data = cmd_read->iter.total_buf;
 	ndd->config_size = cmd_read->iter.total_xfer;
-	ndd->nsindex_size = 0;
 	ndd->ns_current = -1;
 	ndd->ns_next = -1;
 }
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index cfea5f75fcde..83a8067812f7 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -39,7 +39,6 @@ struct nvdimm_data {
 	void *data;
 	unsigned long config_size;
 	size_t nslabel_size;
-	int nsindex_size;
 	int ns_current, ns_next;
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
