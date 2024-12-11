Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9C8241F21
	for <nvdimm@lists.linux.dev>; Wed, 11 Dec 2024 03:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733888587; cv=none; b=oMMjr814Yls8+pY87FWf83X4U7K7Gfp7bB6Go5B6dxcHWApCoY2ow9O8eSRg91ccipJ2R2gOnemzcGz3m43taB1Qh19KuTtKQfSXwIqsJRiBnm832ZT0QvJlm0BTup50iiEJrwSBbj+ogROY8uHv3cv8ZJLRkxyCGZckomBq8m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733888587; c=relaxed/simple;
	bh=J/tvVJuNL06or+QiXL8+awc8Hb9sW2txHzjlyzHhbRA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ehX5FK4ZqsVZ+TqiJrmnhe9naY9ap3QciNYbuyfEKLOJllFfVCTqp6ITqkr5sn1/xOOTSqbsH9gv8vxZDn0bwjTPCZHOuhdS/VyC9tBdsJJkMAFcOSMsmIU0S0OXwfkVLzeqZCZq/XqZSbNy9uw0zSDEGO2Ipd+beGUmaG6vEQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SScq8HDp; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SScq8HDp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733888585; x=1765424585;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=J/tvVJuNL06or+QiXL8+awc8Hb9sW2txHzjlyzHhbRA=;
  b=SScq8HDpxhsrYFbzypnAKNg90Hhbnt7yTiln4M5+1uv5uFhC4TLJI9PT
   LyK3oJBdDCxNYAfpU/AAOTjFnJvPQSOoQYPDIL9f2HxxIY0gLQ2TY9adf
   Ful13e3nx8/Pt1KsBKg5FDd5d8isRPjW8nW3h0pQIhSCRKhxnJub1+kCi
   ZG+MrKmh5uJ6qPsg8nBETsNoDxVvjvXl6U6kLEfl3e7S/PGSF+CD4BLSg
   J6BuzB31H1aYdLL9hkUUT1CksQFITRky6JgDRxlZ/I+tWpiLNCFTyaaxD
   eLTJgUnwW5uK7sKPA7QY1GeMXqOlhZufDC7xq5d9kfot0ptWyE+jguHTW
   w==;
X-CSE-ConnectionGUID: sXtNrE0FTGS4/5ugYsOVmw==
X-CSE-MsgGUID: Mqh+f7UdQiOku4iciD1+Gw==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="34178165"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="34178165"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:43:05 -0800
X-CSE-ConnectionGUID: Zz8oSIDOSg+5nw9K9IuVfg==
X-CSE-MsgGUID: ULPNcDE8QPGyR+Wm19Cj7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="95504273"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO localhost) ([10.125.109.231])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:43:04 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 10 Dec 2024 21:42:33 -0600
Subject: [PATCH v8 18/21] cxl/region: Read existing extents on region
 creation
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241210-dcd-type2-upstream-v8-18-812852504400@intel.com>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
In-Reply-To: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-hardening@vger.kernel.org
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733888537; l=8589;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=J/tvVJuNL06or+QiXL8+awc8Hb9sW2txHzjlyzHhbRA=;
 b=aafI+rKzdW0mHuqneA06+j4ElsgGrGn0p5YLN7ykfgspkv263dbsYJKkLsXqSpmrBzuDGDjPV
 JoP0M/7j1bDBy7i6/cg+uwO17L3YpRfhhVxvbB38q+qU4l8dgMw4Ukp
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Dynamic capacity device extents may be left in an accepted state on a
device due to an unexpected host crash.  In this case it is expected
that the creation of a new region on top of a DC partition can read
those extents and surface them for continued use.

Once all endpoint decoders are part of a region and the region is being
realized, a read of the 'devices extent list' can reveal these
previously accepted extents.

CXL r3.1 specifies the mailbox call Get Dynamic Capacity Extent List for
this purpose.  The call returns all the extents for all dynamic capacity
partitions.  If the fabric manager is adding extents to any DCD
partition, the extent list for the recovered region may change.  In this
case the query must retry.  Upon retry the query could encounter extents
which were accepted on a previous list query.  Adding such extents is
ignored without error because they are entirely within a previous
accepted extent.  Instead warn on this case to allow for differentiating
bad devices from this normal condition.

Latch any errors to be bubbled up to ensure notification to the user
even if individual errors are rate limited or otherwise ignored.

The scan for existing extents races with the dax_cxl driver.  This is
synchronized through the region device lock.  Extents which are found
after the driver has loaded will surface through the normal notification
path while extents seen prior to the driver are read during driver load.

Based on an original patch by Navneet Singh.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/core/core.h   |   1 +
 drivers/cxl/core/mbox.c   | 108 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/core/region.c |  25 +++++++++++
 drivers/cxl/cxlmem.h      |  21 +++++++++
 4 files changed, 155 insertions(+)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index fb49d00e53861a252eb47db7a82415d724da6701..884f7bc459e2147e0aaa9ab4544dbff4a4cdee8f 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -21,6 +21,7 @@ cxled_to_mds(struct cxl_endpoint_decoder *cxled)
 	return container_of(cxlds, struct cxl_memdev_state, cxlds);
 }
 
+int cxl_process_extent_list(struct cxl_endpoint_decoder *cxled);
 int cxl_region_invalidate_memregion(struct cxl_region *cxlr);
 
 #ifdef CONFIG_CXL_REGION
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 5bce54da3bcfb934c0b7b0609fa7a961ee4854b7..e6789b59be1b361c1cfcb8d0e5b1ef64cd6555fd 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1692,6 +1692,114 @@ int cxl_dev_dynamic_capacity_identify(struct cxl_memdev_state *mds)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_dev_dynamic_capacity_identify, "CXL");
 
+/* Return -EAGAIN if the extent list changes while reading */
+static int __cxl_process_extent_list(struct cxl_endpoint_decoder *cxled)
+{
+	u32 current_index, total_read, total_expected, initial_gen_num;
+	struct cxl_memdev_state *mds = cxled_to_mds(cxled);
+	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
+	struct device *dev = mds->cxlds.dev;
+	struct cxl_mbox_cmd mbox_cmd;
+	u32 max_extent_count;
+	int latched_rc = 0;
+	bool first = true;
+
+	struct cxl_mbox_get_extent_out *extents __free(kvfree) =
+				kvmalloc(cxl_mbox->payload_size, GFP_KERNEL);
+	if (!extents)
+		return -ENOMEM;
+
+	total_read = 0;
+	current_index = 0;
+	total_expected = 0;
+	max_extent_count = (cxl_mbox->payload_size - sizeof(*extents)) /
+				sizeof(struct cxl_extent);
+	do {
+		struct cxl_mbox_get_extent_in get_extent;
+		u32 nr_returned, current_total, current_gen_num;
+		int rc;
+
+		get_extent = (struct cxl_mbox_get_extent_in) {
+			.extent_cnt = max(max_extent_count,
+					  total_expected - current_index),
+			.start_extent_index = cpu_to_le32(current_index),
+		};
+
+		mbox_cmd = (struct cxl_mbox_cmd) {
+			.opcode = CXL_MBOX_OP_GET_DC_EXTENT_LIST,
+			.payload_in = &get_extent,
+			.size_in = sizeof(get_extent),
+			.size_out = cxl_mbox->payload_size,
+			.payload_out = extents,
+			.min_out = 1,
+		};
+
+		rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
+		if (rc < 0)
+			return rc;
+
+		/* Save initial data */
+		if (first) {
+			total_expected = le32_to_cpu(extents->total_extent_count);
+			initial_gen_num = le32_to_cpu(extents->generation_num);
+			first = false;
+		}
+
+		nr_returned = le32_to_cpu(extents->returned_extent_count);
+		total_read += nr_returned;
+		current_total = le32_to_cpu(extents->total_extent_count);
+		current_gen_num = le32_to_cpu(extents->generation_num);
+
+		dev_dbg(dev, "Got extent list %d-%d of %d generation Num:%d\n",
+			current_index, total_read - 1, current_total, current_gen_num);
+
+		if (current_gen_num != initial_gen_num || total_expected != current_total) {
+			dev_warn(dev, "Extent list change detected; gen %u != %u : cnt %u != %u\n",
+				 current_gen_num, initial_gen_num,
+				 total_expected, current_total);
+			return -EAGAIN;
+		}
+
+		for (int i = 0; i < nr_returned ; i++) {
+			struct cxl_extent *extent = &extents->extent[i];
+
+			dev_dbg(dev, "Processing extent %d/%d\n",
+				current_index + i, total_expected);
+
+			rc = validate_add_extent(mds, extent);
+			if (rc)
+				latched_rc = rc;
+		}
+
+		current_index += nr_returned;
+	} while (total_expected > total_read);
+
+	return latched_rc;
+}
+
+/**
+ * cxl_process_extent_list() - Read existing extents
+ * @cxled: Endpoint decoder which is part of a region
+ *
+ * Issue the Get Dynamic Capacity Extent List command to the device
+ * and add existing extents if found.
+ *
+ * A retry of 10 is somewhat arbitrary, however, extent changes should be
+ * relatively rare while bringing up a region.  So 10 should be plenty.
+ */
+#define CXL_READ_EXTENT_LIST_RETRY 10
+int cxl_process_extent_list(struct cxl_endpoint_decoder *cxled)
+{
+	int retry = CXL_READ_EXTENT_LIST_RETRY;
+	int rc;
+
+	do {
+		rc = __cxl_process_extent_list(cxled);
+	} while (rc == -EAGAIN && retry--);
+
+	return rc;
+}
+
 static int add_dpa_res(struct device *dev, struct resource *parent,
 		       struct resource *res, resource_size_t start,
 		       resource_size_t size, const char *type)
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index f7e47a82fa2bd1b245081428fc515fb464993aa5..ca22ac14218191fde314dbbcef3d945ea62c67c9 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3191,6 +3191,26 @@ static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
 	return rc;
 }
 
+static int cxlr_add_existing_extents(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	int i, latched_rc = 0;
+
+	for (i = 0; i < p->nr_targets; i++) {
+		struct device *dev = &p->targets[i]->cxld.dev;
+		int rc;
+
+		rc = cxl_process_extent_list(p->targets[i]);
+		if (rc) {
+			dev_err(dev, "Existing extent processing failed %d\n",
+				rc);
+			latched_rc = rc;
+		}
+	}
+
+	return latched_rc;
+}
+
 static void cxlr_dax_unregister(void *_cxlr_dax)
 {
 	struct cxl_dax_region *cxlr_dax = _cxlr_dax;
@@ -3225,6 +3245,11 @@ static int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
 		dev_name(dev));
 
+	if (cxlr->mode == CXL_REGION_DC)
+		if (cxlr_add_existing_extents(cxlr))
+			dev_err(&cxlr->dev, "Existing extent processing failed %d\n",
+				rc);
+
 	return devm_add_action_or_reset(&cxlr->dev, cxlr_dax_unregister,
 					cxlr_dax);
 err:
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 73dee28bbd803a8f78686e833f8ef3492ca94e66..e7b9bd5bb4a96b0cdeb4bcf9c3b7ca1499d1cddd 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -627,6 +627,27 @@ struct cxl_mbox_dc_response {
 	} __packed extent_list[];
 } __packed;
 
+/*
+ * Get Dynamic Capacity Extent List; Input Payload
+ * CXL rev 3.1 section 8.2.9.9.9.2; Table 8-166
+ */
+struct cxl_mbox_get_extent_in {
+	__le32 extent_cnt;
+	__le32 start_extent_index;
+} __packed;
+
+/*
+ * Get Dynamic Capacity Extent List; Output Payload
+ * CXL rev 3.1 section 8.2.9.9.9.2; Table 8-167
+ */
+struct cxl_mbox_get_extent_out {
+	__le32 returned_extent_count;
+	__le32 total_extent_count;
+	__le32 generation_num;
+	u8 rsvd[4];
+	struct cxl_extent extent[];
+} __packed;
+
 struct cxl_mbox_get_supported_logs {
 	__le16 entries;
 	u8 rsvd[6];

-- 
2.47.1

