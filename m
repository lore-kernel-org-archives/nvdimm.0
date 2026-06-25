Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A667A3DA7E1
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386931; cv=none; b=hWWON/Ch+HQ8t/1x02M4bWyCJFkK3/meNsCxD0XI2V5jQHdn82uyOsl5pxek+kAL/HbDnB5Ja3amCpvrOmyMjbO9+ILH3ldyfcEm3WVq7GJEPLA4pUNn4NcsaOnM8Bdq6K6biRYRX4bmvTugzlnsuHrLL6vkZS+bKJNmuuT+uOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386931; c=relaxed/simple;
	bh=DNEGGTqD9Qtnu7zIcyEk4lDqT5ugLBupUZeNuqnkzM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ep3brE0eWshi0J7y1WyYbaaDatjnH7mT6LvT7f2JuTVnxE+XkYS57q+MpjBMkSJAIywzMGib7KR5ZeNkscPYW9D9RlGaF+FSXC6Rz2Ov9qUsK4heLPwRB0Y/yf8kYmbxMTW8FTH6XsB1LRSIkXalUxnzt3/vcOdmndu63ea0Ugg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cANIi+tl; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cANIi+tl"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-30c713f37c2so744867eec.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386927; x=1782991727; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y+qmW5UbgEOXrKmptse6uEAY142Q4aXdQiz/+96LeUc=;
        b=cANIi+tl2WPd80oPHIb26SAvVcTtSdy6agGgo7XKBgqdIq5bX8Ji4sC3iS1bCtmU9M
         Yei0/KqvmoTHtjyq7C6216zC654e5UlKWsjTKsw5D4+ni56ITMHBzmv4xM2zHLWomUJT
         GV+0RognvPD6bdyJXE9eZOJqufZjcpeRHj3pZr8RWPmy0sq8Ldp8HqJ2sV3F8ICRnoZN
         QDFzvtEW/lFGKFtn+6XJSfq6MOcL8cp+PyWAAqdieEZMZN/9EpFQFYIsmByoKoae1aMJ
         zaFpta5DZdX6duQVUrXC3TbWcaDGFo5ZnJ+TK7O8FuGM8WXOBk1XfCUBaVa6geD3UeWJ
         UHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386927; x=1782991727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y+qmW5UbgEOXrKmptse6uEAY142Q4aXdQiz/+96LeUc=;
        b=SDhP61F2I4qPdlHyb3+y/IC53GZenxNwOkzb9JXrLQqDDYjibgbm3M4pXLxWt0/mAA
         Eh7mCW9SQxXhbnCIhIh/KFAofAbHWTrCDm3jG+HgB1gDa2xlO75b5UqXJxQ5O4EuCIWi
         Rhm7HerKNsI6WMRw2bWALfIFK8VviBRGpg7+PfrzRa8+q35OV0vmhv2uCv4ZxXhIPIxK
         qvV9Z3m6lw85dqsrdqg2hk2aGRhYlqFQ23JrkDobR8aiTSmcWLTJy9QWZwJ1TjkMl/I7
         KnOu8N4IWC4E0nQuCShbgK5gGozvSKupG1tv+XivTeNViA2l930Jfymw1VttLeVay4lY
         NyLA==
X-Gm-Message-State: AOJu0YyCsGBwlyn+RdMLI19XHdfEalkpME2u3xUriUmflfzQE7xS9UgB
	tOzsISqy42NO+c0RFhj2A6i0RyxgjzfPntTsq4tfVbsKdrR2nzz1MybR3WSwRQ==
X-Gm-Gg: AfdE7cmuK2CD3ikxe9CDiuZbpdHgffUg2wvHOhczEYbdC44mzSfJnUgkhKys5Rpl9Np
	5z0MyM2InHa7JhX6AMV/yYc4EMJK5xBbbt1NfrTI4byfIQE41RlyDjwTCf6PS0S1DAGa7rfThIT
	d4E1Qy8blkTwS2heEItN1oYi5bKQCU2m/57QIR563jA3/3EHNq5WCPe0b4RiUK1E6xYAQ/sMXkr
	UaRhcWMueI6aAL6NYs6wqFvjaP387jVRvH0XkCI+c71tHx0TLLGOUGmyRa3x9DRPYi9Ms8ooSQL
	0qWl3lYVXMb/52cVUH41H9hiUkMmnPjcSp4LBQO8e3xJtu+ciSIameB8vB9qXVexGCZkFYaqRed
	PEaa94Vic3DzgWSJ/8V0mStjcTrKD0TmOMX7tfTQjbzIcCjevU0rg/y76FyRlAZVQIOOzZ1x0XQ
	/lcb7x30GNGMgKXYkSrkHkVENwbzqD+qaVeBESDWfeLnw7i2J7megTjuvvSYi2Qj85Li+9
X-Received: by 2002:a05:7300:372c:b0:30b:c0b4:db42 with SMTP id 5a478bee46e88-30c85a5cd27mr2738736eec.11.1782386926549;
        Thu, 25 Jun 2026 04:28:46 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:46 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v11 14/31] cxl/extent: Handle DC Add Capacity events
Date: Thu, 25 Jun 2026 04:04:51 -0700
Message-ID: <20260625112638.550691-15-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Replace the empty-response stub in handle_add_event() with the real
add pipeline.

DC Event Records can be grouped together with the 'More' flag. The
previous commit completed the set up for holding onto extents in
the pending list until receiving the last event record of the group,
marked by 'More'=0.

This commit fills in the logic for processing the pending list and
adds basic validation for extents before they are added to the
device model as a child of the cxlr_dax region. More complete
checks for tags/sequence numbers/alignment is added in subsequent commits.

For each tag that appears in the pending list:
1. Extract all extents in the pending list with that tag to a
local list.

2. The spec requires that shareable extents are ordered by
shared extent sequence number, which "instructs each host
on the relative order these extents must be placed in adjacent
virtual address space" (r4.0 Section 9.13.3 Figure 9-23
Shared Extent List Example). Otherwise, retain arrival order.

Thus the tag group is stable-sorted by shared_extn_seq; for non-sharable
extents every key is 0 and the stable sort preserves arrival
order.

Individual extents are checked for the following:
1. The extent's DPA range fully resolves to an endpoint decoder.

2. Doesn't overlap with a previously accepted extent.

3. Sequence number doesn't collide with others in the same
tag group

Upon passing these checks, extents are "onlined" together
as a tag group:
online_tag_group() registers a struct device per
dc_extent under cxlr_dax->dev so the dax layer can discover them
via device_for_each_child().

Once the pending list has been fully processed, send the
DC_ADD_RESPONSE.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
1. extent.c: add NULL check in dc_extent_release
2. extent.c: add NULL check for cxlr_dax in cxl_validate_extent
3. extent.c: change cxlr_add_extent to return 1 on success so
   cxl_add_pending() can differentiate between accepting a duplicate
   extent vs. a new one. Otherwise the accounting for total_accepted is
   will be off.
4. region_dax.c: init dc_extents xarray with XA_FLAGS_ALLOC1 flag.
   Otherwise if xa_alloc fails for an extent in online_tag_group, the id
   is invalid.
   put_device() calls dc_extent_release(), which clears id 0, which is
   not necessarrily the right extent to clear
5. mbox.c: cxl_add_pending() needs to delete_extent_node() before
   continuing if mds->add_ctx has no tag group
---
 drivers/cxl/core/Makefile     |   2 +-
 drivers/cxl/core/core.h       |  14 ++
 drivers/cxl/core/extent.c     | 411 ++++++++++++++++++++++++++++++++++
 drivers/cxl/core/mbox.c       | 163 +++++++++++++-
 drivers/cxl/core/region_dax.c |   3 +
 drivers/cxl/cxl.h             |  25 +++
 tools/testing/cxl/Kbuild      |   5 +-
 7 files changed, 614 insertions(+), 9 deletions(-)
 create mode 100644 drivers/cxl/core/extent.c

diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index ce7213818d3c..208917ad8aac 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -15,7 +15,7 @@ cxl_core-y += hdm.o
 cxl_core-y += pmu.o
 cxl_core-y += cdat.o
 cxl_core-$(CONFIG_TRACING) += trace.o
-cxl_core-$(CONFIG_CXL_REGION) += region.o region_pmem.o region_dax.o
+cxl_core-$(CONFIG_CXL_REGION) += region.o region_pmem.o region_dax.o extent.o
 cxl_core-$(CONFIG_CXL_MCE) += mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += features.o
 cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += edac.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 1e3f19d8c9a3..2c1df75ebbc5 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -63,12 +63,25 @@ u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 int devm_cxl_add_dax_region(struct cxl_region *cxlr);
 int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 
+int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
+		   u16 seq_num);
+int online_tag_group(struct cxl_dc_tag_group *group, bool skip_release);
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
 				 const struct cxl_memdev *cxlmd, u64 dpa)
 {
 	return ULLONG_MAX;
 }
+static inline int cxl_add_extent(struct cxl_memdev_state *mds,
+				 struct cxl_extent *extent, u16 seq_num)
+{
+	return 0;
+}
+static inline int online_tag_group(struct cxl_dc_tag_group *group,
+				   bool skip_release)
+{
+	return 0;
+}
 static inline
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
 				     struct cxl_endpoint_decoder **cxled)
@@ -164,6 +177,7 @@ long cxl_pci_get_latency(struct pci_dev *pdev);
 int cxl_pci_get_bandwidth(struct pci_dev *pdev, struct access_coordinate *c);
 int cxl_port_get_switch_dport_bandwidth(struct cxl_port *port,
 					struct access_coordinate *c);
+void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range);
 
 static inline struct device *port_to_host(struct cxl_port *port)
 {
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
new file mode 100644
index 000000000000..6e67e787d14d
--- /dev/null
+++ b/drivers/cxl/core/extent.c
@@ -0,0 +1,411 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  Copyright(c) 2024 Intel Corporation. All rights reserved. */
+
+#include <linux/device.h>
+#include <cxl.h>
+
+#include "core.h"
+
+
+static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
+				 struct dc_extent *dc_extent)
+{
+	struct cxl_memdev_state *mds = cxled_to_mds(cxled);
+	struct device *dev = &cxled->cxld.dev;
+
+	dev_dbg(dev, "Remove extent %pra (%pU)\n",
+		&dc_extent->dpa_range, &dc_extent->uuid);
+	memdev_release_extent(mds, &dc_extent->dpa_range);
+}
+
+static void free_tag_group(struct cxl_dc_tag_group *group)
+{
+	xa_destroy(&group->dc_extents);
+	/* Drop the pin taken in alloc_tag_group(). */
+	put_device(&group->cxlr_dax->dev);
+	kfree(group);
+}
+
+static void dc_extent_release(struct device *dev)
+{
+	struct dc_extent *dc_extent = to_dc_extent(dev);
+	struct cxl_dc_tag_group *group;
+
+	if (!dc_extent)
+		return;
+
+	group = dc_extent->group;
+	cxled_release_extent(dc_extent->cxled, dc_extent);
+	xa_erase(&group->cxlr_dax->dc_extents, dc_extent->dev.id);
+	xa_erase(&group->dc_extents, dc_extent->seq_num);
+	group->nr_extents--;
+	if (!group->nr_extents)
+		free_tag_group(group);
+	kfree(dc_extent);
+}
+
+static const struct device_type dc_extent_type = {
+	.name = "extent",
+	.release = dc_extent_release,
+};
+
+bool is_dc_extent(struct device *dev)
+{
+	return dev->type == &dc_extent_type;
+}
+EXPORT_SYMBOL_NS_GPL(is_dc_extent, "CXL");
+
+static struct cxl_dc_tag_group *
+alloc_tag_group(struct cxl_dax_region *cxlr_dax, uuid_t *uuid)
+{
+	struct cxl_dc_tag_group *group __free(kfree) =
+				kzalloc(sizeof(*group), GFP_KERNEL);
+	if (!group)
+		return ERR_PTR(-ENOMEM);
+
+	group->cxlr_dax = cxlr_dax;
+	uuid_copy(&group->uuid, uuid);
+	xa_init(&group->dc_extents);
+
+	/*
+	 * Pin cxlr_dax: it is used after cxl_rwsem.region is dropped, so a
+	 * refcount must keep it alive.  Released in free_tag_group().
+	 */
+	get_device(&cxlr_dax->dev);
+
+	return no_free_ptr(group);
+}
+
+/*
+ * Stage 1 of the add pipeline: pure, no allocation.  Resolve the extent
+ * to its region/endpoint decoder and ext_range, and verify the range
+ * fits in the resolved endpoint decoder's DPA resource.  Further
+ * per-extent invariants layer into this function in subsequent commits.
+ *
+ * Caller must hold cxl_rwsem.region for read (cxl_dpa_to_region()).
+ * On success, @out_cxled / @out_cxlr_dax / @out_ext_range carry the
+ * resolved handles consumed by the rest of the pipeline.
+ */
+static int cxl_validate_extent(struct cxl_memdev_state *mds,
+			       struct cxl_extent *extent,
+			       struct cxl_endpoint_decoder **out_cxled,
+			       struct cxl_dax_region **out_cxlr_dax,
+			       struct range *out_ext_range)
+{
+	u64 start_dpa = le64_to_cpu(extent->start_dpa);
+	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
+	struct cxl_endpoint_decoder *cxled;
+	struct cxl_region *cxlr;
+	struct range ext_range = (struct range) {
+		.start = start_dpa,
+		.end = start_dpa + le64_to_cpu(extent->length) - 1,
+	};
+	struct range ed_range;
+
+	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
+	if (!cxlr || !cxlr->cxlr_dax)
+		return -ENXIO;
+
+	ed_range = (struct range) {
+		.start = cxled->dpa_res->start,
+		.end = cxled->dpa_res->end,
+	};
+	if (!range_contains(&ed_range, &ext_range)) {
+		dev_err_ratelimited(&cxled->cxld.dev,
+				    "DC extent DPA %pra (%pU) is not fully in ED %pra\n",
+				    &ext_range, extent->uuid, &ed_range);
+		return -ENXIO;
+	}
+
+	*out_cxled = cxled;
+	*out_cxlr_dax = cxlr->cxlr_dax;
+	*out_ext_range = ext_range;
+	return 0;
+}
+
+enum cxl_extent_class {
+	CXL_EXT_NEW,
+	CXL_EXT_DUPLICATE,
+	CXL_EXT_OVERLAP,
+};
+
+/*
+ * Stage 2: classify @ext_range against extents already accepted on this
+ * cxlr_dax+cxled.  Walks cxlr_dax->dc_extents once: a stored extent that
+ * fully contains @ext_range means a duplicate accept (idempotent, fine);
+ * a stored extent that only overlaps means an inconsistent offer.
+ */
+static enum cxl_extent_class
+cxlr_dax_classify_extent(struct cxl_dax_region *cxlr_dax,
+			 struct cxl_endpoint_decoder *cxled,
+			 const struct range *ext_range)
+{
+	struct dc_extent *entry;
+	unsigned long i;
+
+	xa_for_each(&cxlr_dax->dc_extents, i, entry) {
+		if (entry->cxled != cxled)
+			continue;
+		if (range_contains(&entry->dpa_range, ext_range))
+			return CXL_EXT_DUPLICATE;
+		if (range_overlaps(&entry->dpa_range, ext_range))
+			return CXL_EXT_OVERLAP;
+	}
+	return CXL_EXT_NEW;
+}
+
+/*
+ * Stage 3: allocate and populate a dc_extent for an already-validated,
+ * already-classified-as-new @ext_range.  Only -ENOMEM can fail here.
+ */
+static struct dc_extent *
+dc_extent_build(struct cxl_endpoint_decoder *cxled,
+		struct cxl_dax_region *cxlr_dax,
+		struct cxl_extent *extent,
+		const struct range *ext_range, u16 seq_num)
+{
+	resource_size_t dpa_offset = ext_range->start - cxled->dpa_res->start;
+	resource_size_t hpa = cxled->cxld.hpa_range.start + dpa_offset;
+	struct dc_extent *dc_extent;
+
+	dc_extent = kzalloc(sizeof(*dc_extent), GFP_KERNEL);
+	if (!dc_extent)
+		return ERR_PTR(-ENOMEM);
+
+	dc_extent->cxled = cxled;
+	dc_extent->dpa_range = *ext_range;
+	dc_extent->hpa_range.start = hpa - cxlr_dax->hpa_range.start;
+	dc_extent->hpa_range.end = dc_extent->hpa_range.start +
+				   range_len(ext_range) - 1;
+	dc_extent->seq_num = seq_num;
+	import_uuid(&dc_extent->uuid, extent->uuid);
+	return dc_extent;
+}
+
+/*
+ * Stage 4: insert @dc_extent into the pending tag group.  All extents in
+ * one More-chain group share a UUID — enforced here as the group is
+ * either being created (first extent) or appended to.  On any failure
+ * the dc_extent is freed.
+ *
+ * Returns 1 on success to allow caller (cxl_add_extent) to distinguish
+ * between accepting a new extent, accepting a duplicate, or error.
+ */
+static int cxlr_add_extent(struct cxl_memdev_state *mds,
+			   struct cxl_dax_region *cxlr_dax,
+			   struct dc_extent *dc_extent)
+{
+	struct cxl_dc_tag_group **group = &mds->add_ctx.group;
+	int rc;
+
+	if (*group && !uuid_equal(&(*group)->uuid, &dc_extent->uuid)) {
+		kfree(dc_extent);
+		return -EINVAL;
+	}
+
+	if (!*group) {
+		dev_dbg(&cxlr_dax->dev, "Alloc new tag group\n");
+		*group = alloc_tag_group(cxlr_dax, &dc_extent->uuid);
+		if (IS_ERR(*group)) {
+			rc = PTR_ERR(*group);
+			*group = NULL;
+			kfree(dc_extent);
+			return rc;
+		}
+	} else {
+		dev_dbg(&cxlr_dax->dev, "Append dc_extent to tag group\n");
+	}
+
+	dc_extent->group = *group;
+
+	/*
+	 * Key by @seq_num so iteration order equals assembly order.  @seq_num
+	 * is a dense 0..n-1 index (see &struct dc_extent), so a collision
+	 * here signals a cxl-side validation gap.
+	 */
+	rc = xa_insert(&(*group)->dc_extents, dc_extent->seq_num,
+		       dc_extent, GFP_KERNEL);
+	if (rc) {
+		dev_WARN_ONCE(&cxlr_dax->dev, rc == -EBUSY,
+			"duplicate seq_num %u in tag %pUb\n",
+			dc_extent->seq_num, &dc_extent->uuid);
+		kfree(dc_extent);
+		return rc;
+	}
+
+	return 1;
+}
+
+/*
+ * Returns 1 for a successfully added extent, 0 for a duplicate extent,
+ * and <0 on error
+ */
+int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
+		   u16 seq_num)
+{
+	struct cxl_endpoint_decoder *cxled;
+	struct cxl_dax_region *cxlr_dax;
+	struct dc_extent *dc_extent;
+	struct range ext_range;
+	int rc;
+
+	guard(rwsem_read)(&cxl_rwsem.region);
+
+	rc = cxl_validate_extent(mds, extent, &cxled, &cxlr_dax, &ext_range);
+	if (rc)
+		return rc;
+
+	switch (cxlr_dax_classify_extent(cxlr_dax, cxled, &ext_range)) {
+	case CXL_EXT_DUPLICATE:
+		/*
+		 * Idempotent accept simplifies the dax-side scan for existing
+		 * extents on region creation; reply success without duplicating.
+		 */
+		dev_warn_ratelimited(&cxled->cxld.dev,
+				     "Extent %pra exists; accept again\n",
+				     &ext_range);
+		return 0;
+	case CXL_EXT_OVERLAP:
+		return -ENXIO;
+	case CXL_EXT_NEW:
+		break;
+	}
+
+	dc_extent = dc_extent_build(cxled, cxlr_dax, extent, &ext_range,
+				    seq_num);
+	if (IS_ERR(dc_extent))
+		return PTR_ERR(dc_extent);
+
+	dev_dbg(&cxled->cxld.dev, "Add extent %pra (%pU)\n",
+		&dc_extent->dpa_range, &dc_extent->uuid);
+
+	/* returns 1 on success, <0 error*/
+	return cxlr_add_extent(mds, cxlr_dax, dc_extent);
+}
+
+static void dc_extent_unregister(void *ext)
+{
+	struct dc_extent *dc_extent = ext;
+
+	dev_dbg(&dc_extent->dev, "DAX region rm extent HPA %pra\n",
+		&dc_extent->hpa_range);
+	device_unregister(&dc_extent->dev);
+}
+
+static void cleanup_pending_dc_extent(struct dc_extent *dc_extent)
+{
+	struct cxl_dc_tag_group *group = dc_extent->group;
+
+	if (!group->skip_device_release)
+		cxled_release_extent(dc_extent->cxled, dc_extent);
+	xa_erase(&group->dc_extents, dc_extent->seq_num);
+	group->nr_extents--;
+	if (!group->nr_extents)
+		free_tag_group(group);
+	kfree(dc_extent);
+}
+
+int online_tag_group(struct cxl_dc_tag_group *group, bool skip_release)
+{
+	struct cxl_dax_region *cxlr_dax = group->cxlr_dax;
+	struct dc_extent *dc_extent;
+	unsigned long index;
+	int rc = 0;
+
+	/*
+	 * Seed nr_extents with the full group size plus a +1 pin held by
+	 * this function.  The size counts every dc_extent that might
+	 * decrement nr_extents on cleanup; the pin keeps @group alive
+	 * across the body even if every dc_extent release fires inside
+	 * the loop (e.g. devm_add_action_or_reset failure on the only
+	 * pending extent).  The pin is dropped at the end of the function.
+	 */
+	xa_for_each(&group->dc_extents, index, dc_extent)
+		group->nr_extents++;
+	group->nr_extents++;
+
+	xa_for_each(&group->dc_extents, index, dc_extent) {
+		struct device *dev = &dc_extent->dev;
+		u32 id;
+
+		device_initialize(dev);
+		device_set_pm_not_required(dev);
+		dev->parent = &cxlr_dax->dev;
+		dev->type = &dc_extent_type;
+
+		rc = xa_alloc(&cxlr_dax->dc_extents, &id, dc_extent,
+			      xa_limit_32b, GFP_KERNEL);
+		/*
+		 * put_device() fires dc_extent_release().  On xa_alloc failure
+		 * dev->id is still its invalid init value (0), but the xarray is
+		 * declared XA_FLAGS_ALLOC1 so 0 is never a valid id and erasing
+		 * it cannot remove another extent.
+		 */
+		if (rc < 0) {
+			put_device(dev);
+			break;
+		}
+		dev->id = id;
+
+		rc = dev_set_name(dev, "extent%d.%d", cxlr_dax->cxlr->id,
+				  dev->id);
+		if (rc) {
+			xa_erase(&cxlr_dax->dc_extents, dev->id);
+			put_device(dev);
+			break;
+		}
+
+		rc = device_add(dev);
+		if (rc) {
+			xa_erase(&cxlr_dax->dc_extents, dev->id);
+			put_device(dev);
+			break;
+		}
+
+		dev_dbg(dev, "dc_extent HPA %pra (%pU)\n",
+			&dc_extent->hpa_range, &group->uuid);
+
+		rc = devm_add_action_or_reset(&cxlr_dax->dev,
+					      dc_extent_unregister, dc_extent);
+		if (rc)
+			break;
+	}
+
+	if (rc) {
+		/*
+		 * The group failed to online atomically, so none of it is
+		 * reported accepted in the Add-DC-Response.  When @skip_release
+		 * is set these extents were never accepted by this host (a
+		 * fresh Add-Capacity group), so suppress the per-extent Release
+		 * DC the teardown would otherwise emit.  Recovered extents
+		 * (already accepted on the device) leave it clear so the device
+		 * reclaims capacity the host cannot use.
+		 */
+		if (skip_release)
+			group->skip_device_release = true;
+
+		/*
+		 * Unwind every remaining dc_extent in the group.  The pin
+		 * above keeps @group alive across this walk.  Distinguish
+		 * onlined dc_extents (have a devm action) from pending ones
+		 * via devm_remove_action_nowarn(): a 0 return means the
+		 * action was installed and is now consumed, so we run the
+		 * unregister ourselves; -ENOENT means pending.
+		 */
+		xa_for_each(&group->dc_extents, index, dc_extent) {
+			int r = devm_remove_action_nowarn(&cxlr_dax->dev,
+							  dc_extent_unregister,
+							  dc_extent);
+			if (r == 0)
+				dc_extent_unregister(dc_extent);
+			else
+				cleanup_pending_dc_extent(dc_extent);
+		}
+	}
+
+	/* Drop the pin; if nothing else still references @group, free it. */
+	group->nr_extents--;
+	if (!group->nr_extents)
+		free_tag_group(group);
+	return rc;
+}
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 4e887b5cdc3e..08f51b8807c0 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -6,6 +6,7 @@
 #include <linux/mutex.h>
 #include <linux/unaligned.h>
 #include <linux/list.h>
+#include <linux/list_sort.h>
 #include <cxlpci.h>
 #include <cxlmem.h>
 #include <cxl.h>
@@ -1180,7 +1181,7 @@ static void delete_extent_node(struct cxl_extent_list_node *node)
 	kfree(node);
 }
 
-static void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range)
+void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range)
 {
 	struct device *dev = mds->cxlds.dev;
 	struct cxl_extent extent = {
@@ -1295,11 +1296,159 @@ static int add_to_pending_list(struct list_head *pending_list,
 }
 
 /*
- * Stub: stage extents on the pending list and reply with an empty
- * ADD_DC_RESPONSE on More=0 (refuse all).  A later commit replaces
- * the no-op tail with the real Add pipeline that surfaces a dax
- * device per accepted extent.
+ * Compare two extents by shared_extn_seq (ascending).  list_sort is
+ * stable, so extents with equal keys keep their arrival order from
+ * add_to_pending_list()'s list_add_tail().
  */
+static int extent_seq_compare(void *priv,
+			      const struct list_head *a,
+			      const struct list_head *b)
+{
+	const struct cxl_extent_list_node *ea =
+		list_entry(a, struct cxl_extent_list_node, list);
+	const struct cxl_extent_list_node *eb =
+		list_entry(b, struct cxl_extent_list_node, list);
+	u16 sa = le16_to_cpu(ea->extent->shared_extn_seq);
+	u16 sb = le16_to_cpu(eb->extent->shared_extn_seq);
+
+	if (sa < sb)
+		return -1;
+	if (sa > sb)
+		return 1;
+	return 0;
+}
+
+/*
+ * Move every pending extent whose tag matches @tag onto @group, preserving
+ * the order they appear in @pending.
+ */
+static void extract_tag_group(struct list_head *pending,
+			      const uuid_t *tag,
+			      struct list_head *group)
+{
+	struct cxl_extent_list_node *pos, *tmp;
+
+	list_for_each_entry_safe(pos, tmp, pending, list) {
+		uuid_t t;
+
+		import_uuid(&t, pos->extent->uuid);
+		if (uuid_equal(&t, tag))
+			list_move_tail(&pos->list, group);
+	}
+}
+
+/* Drop every node in @group, releasing its extent. */
+static void drop_extent_group(struct list_head *group)
+{
+	struct cxl_extent_list_node *pos, *tmp;
+
+	list_for_each_entry_safe(pos, tmp, group, list)
+		delete_extent_node(pos);
+}
+
+/*
+ * Realize a tag @group: add each extent via cxl_add_extent(), then online
+ * the resulting tag group.  Returns the number of accepted extents (>= 0)
+ * with @group left holding them for the caller to splice, or a negative
+ * errno on failure with @group untouched for the caller to drop.
+ */
+static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
+			     struct list_head *group, bool existing)
+{
+	struct device *dev = mds->cxlds.dev;
+	struct cxl_extent_list_node *pos, *tmp;
+	struct cxl_dc_tag_group *tag_group;
+	int group_cnt = 0;
+	int rc;
+
+	list_for_each_entry_safe(pos, tmp, group, list) {
+		/*
+		 * Pass the device-stamped 0-based shared_extn_seq through
+		 * unchanged as the dax-side @seq_num (0..n-1).
+		 */
+		u16 seq = le16_to_cpu(pos->extent->shared_extn_seq);
+
+		if (cxl_add_extent(mds, pos->extent, seq) < 0) {
+			dev_dbg(dev,
+				"Tag %pUb: failed to add extent DPA:%#llx LEN:%#llx\n",
+				tag,
+				le64_to_cpu(pos->extent->start_dpa),
+				le64_to_cpu(pos->extent->length));
+			delete_extent_node(pos);
+			continue;
+		}
+		group_cnt++;
+	}
+
+	tag_group = mds->add_ctx.group;
+	mds->add_ctx.group = NULL;
+	if (!tag_group)
+		return -ENXIO;
+
+	rc = online_tag_group(tag_group, !existing);
+	if (rc) {
+		dev_warn(dev, "Tag %pUb: failed to online tag group (%d)\n",
+			 tag, rc);
+		return rc;
+	}
+
+	return group_cnt;
+}
+
+/*
+ * Drive the pending Add-Capacity records through cxl_realize_group(),
+ * grouped by tag.  Per group: extract from pending, stable-sort by
+ * shared_extn_seq, realize the group, and on success move it onto the
+ * accepted list.  Validation gates layer onto this loop in later commits.
+ */
+static int cxl_add_pending(struct cxl_memdev_state *mds, bool existing)
+{
+	struct list_head *pending = &mds->add_ctx.pending_extents;
+	LIST_HEAD(accepted);
+	int total_accepted = 0;
+
+	while (!list_empty(pending)) {
+		LIST_HEAD(group);
+		uuid_t tag;
+		int cnt;
+
+		import_uuid(&tag,
+			list_first_entry(pending,
+					 struct cxl_extent_list_node,
+					 list)->extent->uuid);
+		extract_tag_group(pending, &tag, &group);
+
+		/*
+		 * Only a sharable allocation carries a meaningful per-extent
+		 * shared_extn_seq; order those by it.  For non-sharable groups,
+		 * the stable sort maintains arrival order.
+		 */
+		list_sort(NULL, &group, extent_seq_compare);
+
+		cnt = cxl_realize_group(mds, &tag, &group, existing);
+		if (cnt < 0) {
+			drop_extent_group(&group);
+			continue;
+		}
+
+		list_splice_tail_init(&group, &accepted);
+		total_accepted += cnt;
+	}
+
+	list_splice(&accepted, pending);
+
+	/*
+	 * Recovered (already-accepted) extents must not be re-reported in an
+	 * Add-DC-Response: the device rejects a DPA range already added by a
+	 * previous response (CXL r4.0 8.2.10.9.9.3, Invalid Physical Address).
+	 */
+	if (existing)
+		return 0;
+
+	return cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
+				    pending, total_accepted);
+}
+
 static int handle_add_event(struct cxl_memdev_state *mds,
 			    struct cxl_event_dcd *event)
 {
@@ -1337,8 +1486,8 @@ static int handle_add_event(struct cxl_memdev_state *mds,
 	ctx->armed = false;
 	cancel_delayed_work(&ctx->timeout_work);
 
-	rc = cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
-				  &mds->add_ctx.pending_extents, 0);
+	/* Fresh add events: extents are not yet accepted (not existing). */
+	rc = cxl_add_pending(mds, false);
 	clear_pending_extents(mds);
 	return rc;
 }
diff --git a/drivers/cxl/core/region_dax.c b/drivers/cxl/core/region_dax.c
index 3865961c4301..70b086d50451 100644
--- a/drivers/cxl/core/region_dax.c
+++ b/drivers/cxl/core/region_dax.c
@@ -13,6 +13,7 @@ static void cxl_dax_region_release(struct device *dev)
 {
 	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
 
+	xa_destroy(&cxlr_dax->dc_extents);
 	kfree(cxlr_dax);
 }
 
@@ -57,11 +58,13 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
 	if (!cxlr_dax)
 		return ERR_PTR(-ENOMEM);
 
+	xa_init_flags(&cxlr_dax->dc_extents, XA_FLAGS_ALLOC1);
 	cxlr_dax->hpa_range.start = p->res->start;
 	cxlr_dax->hpa_range.end = p->res->end;
 
 	dev = &cxlr_dax->dev;
 	cxlr_dax->cxlr = cxlr;
+	cxlr->cxlr_dax = cxlr_dax;
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &cxl_dax_region_key);
 	device_set_pm_not_required(dev);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 367c3d9e2147..aae7eecd191a 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -495,6 +495,7 @@ struct cxl_region_params {
  * @type: Endpoint decoder target type
  * @cxl_nvb: nvdimm bridge for coordinating @cxlr_pmem setup / shutdown
  * @cxlr_pmem: (for pmem regions) cached copy of the nvdimm bridge
+ * @cxlr_dax: (for DC regions) cached copy of CXL DAX bridge
  * @flags: Region state flags
  * @params: active + config params for the region
  * @coord: QoS access coordinates for the region
@@ -510,6 +511,7 @@ struct cxl_region {
 	enum cxl_decoder_type type;
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct cxl_pmem_region *cxlr_pmem;
+	struct cxl_dax_region *cxlr_dax;
 	unsigned long flags;
 	struct cxl_region_params params;
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
@@ -568,6 +570,15 @@ struct cxl_dax_region {
 	struct device dev;
 	struct cxl_region *cxlr;
 	struct range hpa_range;
+	/*
+	 * dc_extents is keyed by an allocator-assigned u32 (see
+	 * online_tag_group()).  Tag groups have no first-class identity in
+	 * this xarray; siblings within a tag find each other via
+	 * dc_extent->group.  Tag-uniqueness lookup is a linear xa_for_each
+	 * walk, adequate at the bounded per-region extent counts the
+	 * driver handles.
+	 */
+	struct xarray dc_extents;
 };
 
 /**
@@ -587,14 +598,28 @@ struct cxl_dax_region {
  *		allocations.
  * @nr_extents: live count of dc_extents in the group; the group is freed
  *		when the last dc_extent device is released.
+ * @skip_device_release: tear the group down without sending a Release DC
+ *		command to the device.  Set when rejecting a group whose
+ *		extents this host never accepted, so they are omitted from the
+ *		Add-DC-Response rather than released — a Release DC would tell
+ *		the device to free capacity it never handed us.
  */
 struct cxl_dc_tag_group {
 	struct cxl_dax_region *cxlr_dax;
 	uuid_t uuid;
 	struct xarray dc_extents;
 	unsigned int nr_extents;
+	bool skip_device_release;
 };
 
+bool is_dc_extent(struct device *dev);
+static inline struct dc_extent *to_dc_extent(struct device *dev)
+{
+	if (!is_dc_extent(dev))
+		return NULL;
+	return container_of(dev, struct dc_extent, dev);
+}
+
 /**
  * struct cxl_port - logical collection of upstream port devices and
  *		     downstream port devices to construct a CXL memory
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 2be1df80fcc9..8941cf187462 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -63,7 +63,10 @@ cxl_core-y += $(CXL_CORE_SRC)/hdm.o
 cxl_core-y += $(CXL_CORE_SRC)/pmu.o
 cxl_core-y += $(CXL_CORE_SRC)/cdat.o
 cxl_core-$(CONFIG_TRACING) += $(CXL_CORE_SRC)/trace.o
-cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o $(CXL_CORE_SRC)/region_pmem.o $(CXL_CORE_SRC)/region_dax.o
+cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o \
+				 $(CXL_CORE_SRC)/region_pmem.o \
+				 $(CXL_CORE_SRC)/region_dax.o \
+				 $(CXL_CORE_SRC)/extent.o
 cxl_core-$(CONFIG_CXL_MCE) += $(CXL_CORE_SRC)/mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += $(CXL_CORE_SRC)/features.o
 cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += $(CXL_CORE_SRC)/edac.o
-- 
2.43.0

