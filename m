Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B6C721E95E14
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 07:27:21 -0700 (PDT)
Subject: [PATCH] libnvdimm, label: fix index block size calculation
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 30 Aug 2017 07:23:38 -0700
Message-ID: <150410301855.16610.7130434728218773988.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The old calculation assumed that the label space was 128k and the label
size is 128. With v1.2 labels where the label size is 256 this
calculation will return zero. We are saved by the fact that the
nsindex_size is always pre-initialized from a previous 128 byte
assumption and we are lucky that the index sizes turn out the same.

Fix this going forward in case we start encountering different
geometries of label areas besides 128k.

Since the label size can change from one call to the next, drop the
caching of nsindex_size.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c |   30 ++++++++++++++++--------------
 drivers/nvdimm/nd.h    |    2 +-
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 87796f840777..9c5f108910e3 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -45,12 +45,14 @@ unsigned sizeof_namespace_label(struct nvdimm_drvdata *ndd)
 	return ndd->nslabel_size;
 }
 
-size_t sizeof_namespace_index(struct nvdimm_drvdata *ndd)
+int nvdimm_num_label_slots(struct nvdimm_drvdata *ndd)
 {
-	u32 index_span;
+	return ndd->nsarea.config_size / (sizeof_namespace_label(ndd) + 1);
+}
 
-	if (ndd->nsindex_size)
-		return ndd->nsindex_size;
+size_t sizeof_namespace_index(struct nvdimm_drvdata *ndd)
+{
+	u32 nslot, space, size;
 
 	/*
 	 * The minimum index space is 512 bytes, with that amount of
@@ -60,16 +62,16 @@ size_t sizeof_namespace_index(struct nvdimm_drvdata *ndd)
 	 * starts to waste space at larger config_sizes, but it's
 	 * unlikely we'll ever see anything but 128K.
 	 */
-	index_span = ndd->nsarea.config_size / (sizeof_namespace_label(ndd) + 1);
-	index_span /= NSINDEX_ALIGN * 2;
-	ndd->nsindex_size = index_span * NSINDEX_ALIGN;
-
-	return ndd->nsindex_size;
-}
-
-int nvdimm_num_label_slots(struct nvdimm_drvdata *ndd)
-{
-	return ndd->nsarea.config_size / (sizeof_namespace_label(ndd) + 1);
+	nslot = nvdimm_num_label_slots(ndd);
+	space = ndd->nsarea.config_size - nslot * sizeof_namespace_label(ndd);
+	size = ALIGN(sizeof(struct nd_namespace_index) + DIV_ROUND_UP(nslot, 8),
+			NSINDEX_ALIGN) * 2;
+	if (size <= space)
+		return size / 2;
+
+	dev_err(ndd->dev, "label area (%d) too small to host (%d byte) labels\n",
+			ndd->nsarea.config_size, sizeof_namespace_label(ndd));
+	return 0;
 }
 
 static int __nd_label_validate(struct nvdimm_drvdata *ndd)
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 251c7e6d2588..023fc93e21a5 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -42,7 +42,7 @@ struct nd_poison {
 
 struct nvdimm_drvdata {
 	struct device *dev;
-	int nsindex_size, nslabel_size;
+	int nslabel_size;
 	struct nd_cmd_get_config_size nsarea;
 	void *data;
 	int ns_current, ns_next;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
