Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB136D17
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 00:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657843282; x=1689379282;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rFuYJU2RizqKHIoiSQcEsnIWX6Vqm+7jVfD6gBeg/Wc=;
  b=Z7ADAyWW5/8uG154Kjzz5E0eCl6w+BvAK/nt/H3Xb4x+2JbPqvFfXxPZ
   /hqTDa4Ix0++vHuikeP48OQbIzpraZm3XT3U9/Bcw6GXxYnQrQ42mlRfj
   Igpz8D/tdVvtD+Qyc/Nsj8Z2jRz3Rkup0VBFkfjfUV+GiUzuXCHWRhaCJ
   8YFl2BzC3hJa88+ewtBGQsqnS/Z6IgUCDbuZs8io8UdGrjN+EVSJ+KPKO
   2xRQfvtHVYj4PreoGKDi1XqzmZIo1WApaI8Oe9QeSBsOpajxgSDHEvyC3
   Cjm1lFAHFKZwmsfJ5uZlQvfpc7NP8iWI6XIJ24rt1Dfr2XrhU3g8zHQbX
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="268686786"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="268686786"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:01:18 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="685766185"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:01:17 -0700
Subject: [PATCH v2 06/28] cxl/hdm: Enumerate allocated DPA
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <bwidawsk@kernel.org>, hch@lst.de, nvdimm@lists.linux.dev,
 linux-pci@vger.kernel.org
Date: Thu, 14 Jul 2022 17:01:16 -0700
Message-ID: <165784327682.1758207.7914919426043855876.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for provisioning CXL regions, add accounting for the DPA
space consumed by existing regions / decoders. Recall, a CXL region is a
memory range comprised from one or more endpoint devices contributing a
mapping of their DPA into HPA space through a decoder.

Record the DPA ranges covered by committed decoders at initial probe of
endpoint ports relative to a per-device resource tree of the DPA type
(pmem or volatile-ram).

The cxl_dpa_rwsem semaphore is introduced to globally synchronize DPA
state across all endpoints and their decoders at once. The vast majority
of DPA operations are reads as region creation is expected to be as rare
as disk partitioning and volume creation. The device_lock() for this
synchronization is specifically avoided for concern of entangling with
sysfs attribute removal.

Co-developed-by: Ben Widawsky <bwidawsk@kernel.org>
Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/hdm.c |  143 ++++++++++++++++++++++++++++++++++++++++++++----
 drivers/cxl/cxl.h      |    2 +
 drivers/cxl/cxlmem.h   |   13 ++++
 3 files changed, 147 insertions(+), 11 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 650363d5272f..d4c17325001b 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -153,10 +153,105 @@ void cxl_dpa_debug(struct seq_file *file, struct cxl_dev_state *cxlds)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_dpa_debug, CXL);
 
+/*
+ * Must be called in a context that synchronizes against this decoder's
+ * port ->remove() callback (like an endpoint decoder sysfs attribute)
+ */
+static void __cxl_dpa_release(struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	struct resource *res = cxled->dpa_res;
+
+	lockdep_assert_held_write(&cxl_dpa_rwsem);
+
+	if (cxled->skip)
+		__release_region(&cxlds->dpa_res, res->start - cxled->skip,
+				 cxled->skip);
+	cxled->skip = 0;
+	__release_region(&cxlds->dpa_res, res->start, resource_size(res));
+	cxled->dpa_res = NULL;
+}
+
+static void cxl_dpa_release(void *cxled)
+{
+	down_write(&cxl_dpa_rwsem);
+	__cxl_dpa_release(cxled);
+	up_write(&cxl_dpa_rwsem);
+}
+
+static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
+			     resource_size_t base, resource_size_t len,
+			     resource_size_t skipped)
+{
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_port *port = cxled_to_port(cxled);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	struct device *dev = &port->dev;
+	struct resource *res;
+
+	lockdep_assert_held_write(&cxl_dpa_rwsem);
+
+	if (!len)
+		return 0;
+
+	if (cxled->dpa_res) {
+		dev_dbg(dev, "decoder%d.%d: existing allocation %pr assigned\n",
+			port->id, cxled->cxld.id, cxled->dpa_res);
+		return -EBUSY;
+	}
+
+	if (skipped) {
+		res = __request_region(&cxlds->dpa_res, base - skipped, skipped,
+				       dev_name(&cxled->cxld.dev), 0);
+		if (!res) {
+			dev_dbg(dev,
+				"decoder%d.%d: failed to reserve skipped space\n",
+				port->id, cxled->cxld.id);
+			return -EBUSY;
+		}
+	}
+	res = __request_region(&cxlds->dpa_res, base, len,
+			       dev_name(&cxled->cxld.dev), 0);
+	if (!res) {
+		dev_dbg(dev, "decoder%d.%d: failed to reserve allocation\n",
+			port->id, cxled->cxld.id);
+		if (skipped)
+			__release_region(&cxlds->dpa_res, base - skipped,
+					 skipped);
+		return -EBUSY;
+	}
+	cxled->dpa_res = res;
+	cxled->skip = skipped;
+
+	return 0;
+}
+
+static int devm_cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
+				resource_size_t base, resource_size_t len,
+				resource_size_t skipped)
+{
+	struct cxl_port *port = cxled_to_port(cxled);
+	int rc;
+
+	down_write(&cxl_dpa_rwsem);
+	rc = __cxl_dpa_reserve(cxled, base, len, skipped);
+	up_write(&cxl_dpa_rwsem);
+
+	if (rc)
+		return rc;
+
+	return devm_add_action_or_reset(&port->dev, cxl_dpa_release, cxled);
+}
+
 static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
-			    int *target_map, void __iomem *hdm, int which)
+			    int *target_map, void __iomem *hdm, int which,
+			    u64 *dpa_base)
 {
-	u64 size, base;
+	struct cxl_endpoint_decoder *cxled = NULL;
+	u64 size, base, skip, dpa_size;
+	bool committed;
+	u32 remainder;
 	int i, rc;
 	u32 ctrl;
 	union {
@@ -164,11 +259,15 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 		unsigned char target_id[8];
 	} target_list;
 
+	if (is_endpoint_decoder(&cxld->dev))
+		cxled = to_cxl_endpoint_decoder(&cxld->dev);
+
 	ctrl = readl(hdm + CXL_HDM_DECODER0_CTRL_OFFSET(which));
 	base = ioread64_hi_lo(hdm + CXL_HDM_DECODER0_BASE_LOW_OFFSET(which));
 	size = ioread64_hi_lo(hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(which));
+	committed = !!(ctrl & CXL_HDM_DECODER0_CTRL_COMMITTED);
 
-	if (!(ctrl & CXL_HDM_DECODER0_CTRL_COMMITTED))
+	if (!committed)
 		size = 0;
 	if (base == U64_MAX || size == U64_MAX) {
 		dev_warn(&port->dev, "decoder%d.%d: Invalid resource range\n",
@@ -181,8 +280,8 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 		.end = base + size - 1,
 	};
 
-	/* switch decoders are always enabled if committed */
-	if (ctrl & CXL_HDM_DECODER0_CTRL_COMMITTED) {
+	/* decoders are enabled if committed */
+	if (committed) {
 		cxld->flags |= CXL_DECODER_F_ENABLE;
 		if (ctrl & CXL_HDM_DECODER0_CTRL_LOCK)
 			cxld->flags |= CXL_DECODER_F_LOCK;
@@ -211,14 +310,35 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 	if (rc)
 		return rc;
 
-	if (is_endpoint_decoder(&cxld->dev))
+	if (!cxled) {
+		target_list.value =
+			ioread64_hi_lo(hdm + CXL_HDM_DECODER0_TL_LOW(which));
+		for (i = 0; i < cxld->interleave_ways; i++)
+			target_map[i] = target_list.target_id[i];
+
 		return 0;
+	}
 
-	target_list.value =
-		ioread64_hi_lo(hdm + CXL_HDM_DECODER0_TL_LOW(which));
-	for (i = 0; i < cxld->interleave_ways; i++)
-		target_map[i] = target_list.target_id[i];
+	if (!committed)
+		return 0;
 
+	dpa_size = div_u64_rem(size, cxld->interleave_ways, &remainder);
+	if (remainder) {
+		dev_err(&port->dev,
+			"decoder%d.%d: invalid committed configuration size: %#llx ways: %d\n",
+			port->id, cxld->id, size, cxld->interleave_ways);
+		return -ENXIO;
+	}
+	skip = ioread64_hi_lo(hdm + CXL_HDM_DECODER0_SKIP_LOW(which));
+	rc = devm_cxl_dpa_reserve(cxled, *dpa_base + skip, dpa_size, skip);
+	if (rc) {
+		dev_err(&port->dev,
+			"decoder%d.%d: Failed to reserve DPA range %#llx - %#llx\n (%d)",
+			port->id, cxld->id, *dpa_base,
+			*dpa_base + dpa_size + skip - 1, rc);
+		return rc;
+	}
+	*dpa_base += dpa_size + skip;
 	return 0;
 }
 
@@ -231,6 +351,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
 	void __iomem *hdm = cxlhdm->regs.hdm_decoder;
 	struct cxl_port *port = cxlhdm->port;
 	int i, committed;
+	u64 dpa_base = 0;
 	u32 ctrl;
 
 	/*
@@ -277,7 +398,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
 			cxld = &cxlsd->cxld;
 		}
 
-		rc = init_hdm_decoder(port, cxld, target_map, hdm, i);
+		rc = init_hdm_decoder(port, cxld, target_map, hdm, i, &dpa_base);
 		if (rc) {
 			put_device(&cxld->dev);
 			return rc;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 7e1460d89296..d5e4cfac35ea 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -56,6 +56,8 @@
 #define   CXL_HDM_DECODER0_CTRL_TYPE BIT(12)
 #define CXL_HDM_DECODER0_TL_LOW(i) (0x20 * (i) + 0x24)
 #define CXL_HDM_DECODER0_TL_HIGH(i) (0x20 * (i) + 0x28)
+#define CXL_HDM_DECODER0_SKIP_LOW(i) CXL_HDM_DECODER0_TL_LOW(i)
+#define CXL_HDM_DECODER0_SKIP_HIGH(i) CXL_HDM_DECODER0_TL_HIGH(i)
 
 static inline int cxl_hdm_decoder_count(u32 cap_hdr)
 {
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index c6d6f57856cc..eee96016c3c7 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -50,6 +50,19 @@ static inline struct cxl_memdev *to_cxl_memdev(struct device *dev)
 	return container_of(dev, struct cxl_memdev, dev);
 }
 
+static inline struct cxl_port *cxled_to_port(struct cxl_endpoint_decoder *cxled)
+{
+	return to_cxl_port(cxled->cxld.dev.parent);
+}
+
+static inline struct cxl_memdev *
+cxled_to_memdev(struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_port *port = to_cxl_port(cxled->cxld.dev.parent);
+
+	return to_cxl_memdev(port->uport);
+}
+
 bool is_cxl_memdev(struct device *dev);
 static inline bool is_cxl_endpoint(struct cxl_port *port)
 {

