Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833373;
	b=DCM8arOLqzgO+SXzcpKPB2YPWAnCaRcqDjNU4qVEQLurReFPs0OEqWGFkZBMODscsj4L
	 HdeSTdo3UH6t3w4bTMW8zFj4MVovEc9S7QRANhNb0TdyX6RIGmkBFhhH//cPclPO4YBug
	 EaXdVLqvXN2Yk4wy2fDn8bD96LhS69+0k5onDBo40o0zrX+P8fF/a5tek1zJ9+c5eZ/lv
	 Vkjn0zGET5y1wKAC+nwEgLjtTTBUOIDBa0JnY6s0VwxklVWSOCcgP3lQSSxbTii28ea0r
	 cF7ilRxO2NI++pDI7LjdMxOaoLHeWL0pVy7yEvkvu3ZWEFYb+0KTFvY2jEVlDCnWdjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833373;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=LiupxorkNED37w7s3O1vTWml8ZZMZwfV1EExxGbrrEA=;
	b=0T1ursK1qU4cowu/l++kNtm22hjCozbWBjWNRnPKNZHAnUMiLXcDrVEFWGDBiU5vOKbN
	 xPQ4WFZjjNQ672gcTHUkHft2kuwpfMZM6rektvOyP8/DG3enKt/3J5mOyRDkhGHyXiFdA
	 B2pP9YsJb92uw9LV+xnhh31kbxwRjpDxM7uQywLRHOp+/g6NkjFOAILHh2UKWfrRUYrBo
	 kQq1eJXJE8q+XKBCfXox0e+JDrUPMFgi53LzOnJ6bWTGuJQN0ZN99DFDWaYwytY+Br0Rk
	 i3PAUdcm7sLrZQ/Dg2t8xqDOPplu6nuOEQ1fWIEygvakpkDaWiYOeiAKcoFizklgRig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OXWE9mL4;
	arc=none smtp.remote-ip=209.85.214.175
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E030606EEBB
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 23:02:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E030606EEBB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OXWE9mL4
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e946155442so11281355ad.3
        for <nvdimm@lists.linux.dev>; Wed, 04 Nov 2026 15:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833371; x=1794438171; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LiupxorkNED37w7s3O1vTWml8ZZMZwfV1EExxGbrrEA=;
        b=OXWE9mL4SU27jo3cduooka8QRzhi4sWxmjVgioKFYqxyPvgdreQCtir8tRbNYUeveP
         b9AsNb0gHKz7o3dk1eIJ2InZ6EZAqPVzNtFAAT8X+Z5J8AuOYkO/iF31AGc+FTIqhWH+
         J7xgjUsljL0oD31XhT3D9NRysb3JfUefAHvQWMVAVm8On/5O4BzzjBMqxdSJ/R6CkRKT
         aJ/zHVCDpDP91dQd+PPAjOnmDd7CwxBym40bz0+TT5cPwOIdeXFnkj7kMyAdzxvmAmws
         SjWf5UzAUp1GbfcUuWlMz34iFRn9HYEwlHRLInJDA556RwRKXkjtodtBduh5k7YWKKeQ
         l9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833371; x=1794438171;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LiupxorkNED37w7s3O1vTWml8ZZMZwfV1EExxGbrrEA=;
        b=i/0BcMjJhcgVJLJfAVnAiDyCcNh8KdGn6ifwOxd4aZyBqKCXanHGIAlsocRdVpFhnF
         eoFH5YSK8Y9i+Glpdfm1cm3WpxKaTNWLYW0NnfiTcYszbMfNc8QbsPqyZpIV2sMJ5GaP
         wlTLeucGKVTvP6KdJNvxlP0ftZiNzhoC7uEKQqQgvjPApU5A0P7+iLPq6ZvwHGUdkxqy
         wHWewPVWf8JZdY/Ji/GqzezcEZrYEBwxJLwLm1B2MHVKUx9U+I8wuTOAG4xN/o5ufmDW
         AhrAQ/4JNjfTO3XPU6PwqsPnV+3lCaLBap00+mB3LJoF0Ws/2OLCF/TFMrfu4XCZonf0
         BVuw==
X-Gm-Message-State: APuU4Z+wvMRREOndRFyjzoHMfApTAQafwiqSkhUWpRDzGdfMMOfg2sqf
	zXREYU4oqFQtvTmU1YWpUVFgV9JR5tBx3uhqOCnGgbRhjdvaAr9IKCvI
X-Gm-Gg: AYBFou3er4o//6BhWxdbOYdLNZFKqRKK9jyw9hV5ZMmOs99RXhF1n7mHI8f390CXzBy
	pFYklWIA6u30pC/qL561FCXgmzweu2koSb4UhE0AJzL2wuzvUzB8MP7dV3lR2oVZhBJcEvIoyCU
	7uoWonyUrBq1jIRNyBu6yIpx40eAlMNki2Pwv5A1zuyrERGUQHpZFZAEW63egEI2rO8+kcD4BSE
	CRleWXIEO4vmp6ppSlOs6mvYK8LvFO9e2ZprcOOX07WaJ+cTKrVlodPFw/0GCfyFBUUIjyPxkto
	VXD3N20G4JMbCaObQO8twli6MU+2ckR6h16siln3Vk31MWm9CakdVYc7KN+j1Jx0fkHeDR2AAXl
	QhNKXm2UNWHjP5KrsJV6E5iN/kkd56MMcFYL3xtESETvB1Qnm1oih6wpLFAQOfdNOzXxfuJDfRu
	0UdFUCB6Z/+/BKkC4tOJXwxdyxebE0Y8A20HVOMJSOa24LvqCSvBnt01HRUc5y5srJ1InoeiPjX
	DSHAi+s6iZm92aI+VfEsmTG13Ks9ZuxBArGiKhyMSDtsFBbQ6lgV3MqoRlrj/hi2Hdx6+AhPb/U
	YUzXmFG+/v31uC1iVGnFDJEXie2whw==
X-Received: by 2002:a17:902:f712:b0:2ed:a96:8a03 with SMTP id d9443c01a7336-2ed0a96a48cmr29059105ad.55.1793833370785;
        Wed, 04 Nov 2026 15:02:50 -0800 (PST)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed0908587dsm10999175ad.36.2026.11.04.15.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:02:50 -0800 (PST)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v1 06/14] cxl/extent: Handle DC Add Capacity events
Date: Thu,  5 Nov 2026 08:02:30 +0900
Message-ID: <20261104230445.66625-7-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104230445.66625-1-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Replace the refuse-all stub for Add Capacity chains in
handle_dcd_chain_event() with the real add pipeline.

DC Event Records can be grouped together with the 'More' flag. The
previous commit completed the set up for holding onto extents in
the pending list until receiving the last event record of the group,
marked by 'More'=0.

This commit fills in the logic for processing the pending list and
adds basic validation for extents before they are added to the
device model as a child of the cxlr_dax region. More complete
checks for tags/sequence numbers/alignment are added in subsequent
commits.

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

2. Doesn't overlap or repeat a previously accepted extent; the device
rejects a DPA range reported twice in an Add response (r4.0 Section
8.2.10.9.9.3, Invalid Physical Address).

A tag group is one allocation, and for sharable capacity the host
must accept all of it or none (r4.0 Section 8.2.10.9.9.3, otherwise
the device returns Invalid Extent List). So an extent failing any of
these checks drops its whole group.

Upon passing these checks, extents are "onlined" together as a
tag group:

online_tag_group() registers a tagged group as a tag_groupX.Y device
under cxlr_dax->dev and a struct device per dc_extent under it.

A single "untagged" device is registered under cxlr_dax when
accepting the first untagged extent. All future untagged extents
will be registered under it.

A group that fails to online is dropped from the Add response.

Once the pending list has been fully processed, send the
DC_ADD_RESPONSE.

Region teardown invalidates the region's cached lines and releases all
extents under it.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Co-developed-by: John Groves <John@Groves.net>
Signed-off-by: John Groves <John@Groves.net>
Co-developed-by: Anisa Su <anisa.su@samsung.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
---
 drivers/cxl/core/Makefile     |   2 +-
 drivers/cxl/core/core.h       |  33 +++
 drivers/cxl/core/extent.c     | 513 ++++++++++++++++++++++++++++++++++
 drivers/cxl/core/mbox.c       | 248 +++++++++++++++-
 drivers/cxl/core/region.c     |   2 +-
 drivers/cxl/core/region_dax.c |  78 +++++-
 drivers/cxl/cxl.h             |  87 ++++++
 drivers/cxl/cxlmem.h          |   2 +
 drivers/dax/bus.c             |  13 +
 tools/testing/cxl/Kbuild      |   5 +-
 10 files changed, 974 insertions(+), 9 deletions(-)
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
index 24fbb5718abc..759f2c47d765 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -40,6 +40,8 @@ int cxl_dc_mode_parse(const char *buf, bool *shareable, bool *read_only);
 
 #ifdef CONFIG_CXL_REGION
 
+int cxl_region_invalidate_memregion(struct cxl_region *cxlr);
+
 struct cxl_region_context {
 	struct cxl_endpoint_decoder *cxled;
 	struct range hpa_range;
@@ -75,12 +77,42 @@ int devm_cxl_add_dax_region(struct cxl_region *cxlr);
 int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 void kill_regions(struct cxl_root_decoder *cxlrd);
 
+int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
+		   u16 seq_num);
+int online_tag_group(struct cxl_dc_tag_group *group);
+bool rm_tag_group(struct cxl_dc_tag_group *group);
+void discard_tag_group(struct cxl_dc_tag_group *group);
+int cxl_dax_untagged_add(struct cxl_dax_region *cxlr_dax);
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
 				 const struct cxl_memdev *cxlmd, u64 dpa)
 {
 	return ULLONG_MAX;
 }
+
+static inline int cxl_add_extent(struct cxl_memdev_state *mds,
+				 struct cxl_extent *extent, u16 seq_num)
+{
+	return -ENXIO;
+}
+
+static inline int online_tag_group(struct cxl_dc_tag_group *group)
+{
+	return 0;
+}
+
+static inline bool rm_tag_group(struct cxl_dc_tag_group *group)
+{
+	return true;
+}
+
+static inline void discard_tag_group(struct cxl_dc_tag_group *group) { }
+
+static inline int cxl_dax_untagged_add(struct cxl_dax_region *cxlr_dax)
+{
+	return 0;
+}
+
 static inline
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
 				     struct cxl_endpoint_decoder **cxled)
@@ -182,6 +214,7 @@ long cxl_pci_get_latency(struct pci_dev *pdev);
 int cxl_pci_get_bandwidth(struct pci_dev *pdev, struct access_coordinate *c);
 int cxl_port_get_switch_dport_bandwidth(struct cxl_port *port,
 					struct access_coordinate *c);
+void memdev_release_group(struct cxl_dc_tag_group *group);
 
 static inline struct device *port_to_host(struct cxl_port *port)
 {
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
new file mode 100644
index 000000000000..8afb18e7ae5a
--- /dev/null
+++ b/drivers/cxl/core/extent.c
@@ -0,0 +1,513 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  Copyright(c) 2024 Intel Corporation. All rights reserved. */
+
+#include <linux/device.h>
+#include <cxl.h>
+
+#include "core.h"
+
+static struct cxl_dc_tag_group *to_dc_tag_group(struct device *dev)
+{
+	return container_of(dev, struct cxl_dc_tag_group, dev);
+}
+
+static void dc_tag_group_release(struct device *dev)
+{
+	struct cxl_dc_tag_group *group = to_dc_tag_group(dev);
+
+	xa_destroy(&group->dc_extents);
+	/* Drop the pin taken in alloc_tag_group(). */
+	put_device(&group->cxlr_dax->dev);
+	kfree(group);
+}
+
+static const struct device_type dc_tag_group_type = {
+	.name = "tag_group",
+	.release = dc_tag_group_release,
+};
+
+/* Last extent gone: drop the group's own reference, freeing it */
+static void free_tag_group(struct cxl_dc_tag_group *group)
+{
+	put_device(&group->dev);
+}
+
+/* A tagged group is a tag_groupX.Y device, parent of its extents */
+static int dc_tag_group_add(struct cxl_dc_tag_group *group)
+{
+	struct cxl_dax_region *cxlr_dax = group->cxlr_dax;
+	struct device *dev = &group->dev;
+	int id, rc;
+
+	id = ida_alloc(&cxlr_dax->tag_group_ida, GFP_KERNEL);
+	if (id < 0)
+		return id;
+	dev->id = id;
+
+	rc = dev_set_name(dev, "tag_group%d.%d", cxlr_dax->cxlr->id, id);
+	if (!rc)
+		rc = device_add(dev);
+	if (rc)
+		ida_free(&cxlr_dax->tag_group_ida, id);
+	return rc;
+}
+
+/* Called once the group's extents are gone; a no-op for untagged groups */
+static void dc_tag_group_del(struct cxl_dc_tag_group *group)
+{
+	if (!device_is_registered(&group->dev))
+		return;
+	device_del(&group->dev);
+	ida_free(&group->cxlr_dax->tag_group_ida, group->dev.id);
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
+	xa_erase(&group->cxlr_dax->dc_extents, dc_extent->dev.id);
+	xa_erase(&group->dc_extents, dc_extent->seq_num);
+	group->nr_extents--;
+	if (!group->nr_extents)
+		free_tag_group(group);
+	kfree_rcu(dc_extent, rcu);
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
+	struct cxl_dc_tag_group *group __free(kfree) = kzalloc_obj(*group);
+	if (!group)
+		return ERR_PTR(-ENOMEM);
+
+	group->cxlr_dax = cxlr_dax;
+	uuid_copy(&group->uuid, uuid);
+	xa_init(&group->dc_extents);
+
+	/*
+	 * Pin cxlr_dax: it is used after cxl_rwsem.region is dropped, so a
+	 * refcount must keep it alive until the group is freed.
+	 */
+	get_device(&cxlr_dax->dev);
+
+	/* Added by online_tag_group() for a tagged group, see dc_tag_group_add() */
+	device_initialize(&group->dev);
+	device_set_pm_not_required(&group->dev);
+	group->dev.parent = &cxlr_dax->dev;
+	group->dev.type = &dc_tag_group_type;
+
+	return no_free_ptr(group);
+}
+
+/*
+ * Stage 1 of the add pipeline: pure, no allocation.  Resolve the extent
+ * to its region/endpoint decoder and ext_range, and verify the range
+ * fits in the resolved endpoint decoder's DPA resource.
+ *
+ * Caller must hold cxl_rwsem.region and cxl_rwsem.dpa for read:
+ * cxl_dpa_to_region() walks every decoder's dpa_res.
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
+ * fully contains @ext_range means the device re-offered accepted capacity;
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
+	/* kfree_rcu() defers the free; hold RCU so entries stay live while walked */
+	guard(rcu)();
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
+	dc_extent = kzalloc_obj(*dc_extent);
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
+ * Returns 0 on success, <0 on error.
+ */
+static int cxlr_add_extent(struct cxl_memdev_state *mds,
+			   struct cxl_dax_region *cxlr_dax,
+			   struct dc_extent *dc_extent)
+{
+	struct cxl_dc_tag_group **group = &mds->dc_chain.group;
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
+			      "duplicate seq_num %u in tag %pUb\n",
+			      dc_extent->seq_num, &dc_extent->uuid);
+		kfree(dc_extent);
+		return rc;
+	}
+
+	return 0;
+}
+
+/*
+ * Returns 0 for a successfully added extent and <0 on error.
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
+	/* The caller holds both across the whole group, through online */
+	lockdep_assert_held(&cxl_rwsem.region);
+	lockdep_assert_held(&cxl_rwsem.dpa);
+
+	rc = cxl_validate_extent(mds, extent, &cxled, &cxlr_dax, &ext_range);
+	if (rc)
+		return rc;
+
+	switch (cxlr_dax_classify_extent(cxlr_dax, cxled, &ext_range)) {
+	case CXL_EXT_DUPLICATE:
+		/*
+		 * Never re-reported: the device rejects a DPA range already
+		 * added by a previous response (CXL r4.0 8.2.10.9.9.3).
+		 */
+		dev_warn_ratelimited(&cxled->cxld.dev,
+				     "Extent %pra already accepted; dropping group\n",
+				     &ext_range);
+		return -EEXIST;
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
+	return cxlr_add_extent(mds, cxlr_dax, dc_extent);
+}
+
+/* The group's device may already be visible: readers walk the xarray under RCU */
+static void cleanup_pending_dc_extent(struct dc_extent *dc_extent)
+{
+	struct cxl_dc_tag_group *group = dc_extent->group;
+
+	xa_erase(&group->dc_extents, dc_extent->seq_num);
+	group->nr_extents--;
+	if (!group->nr_extents)
+		free_tag_group(group);
+	kfree_rcu(dc_extent, rcu);
+}
+
+/*
+ * Drop a staged group that never went online: no dc_extent device exists
+ * yet, so there is nothing to unregister and nothing to tell the device.
+ */
+void discard_tag_group(struct cxl_dc_tag_group *group)
+{
+	struct dc_extent *dc_extent;
+	unsigned long index;
+
+	/* Seed and pin nr_extents as online_tag_group() would */
+	xa_for_each(&group->dc_extents, index, dc_extent)
+		group->nr_extents++;
+	group->nr_extents++;
+
+	xa_for_each(&group->dc_extents, index, dc_extent)
+		cleanup_pending_dc_extent(dc_extent);
+
+	group->nr_extents--;
+	if (!group->nr_extents)
+		free_tag_group(group);
+}
+
+/* Unregister every member; the group is freed with its last extent */
+static void unregister_tag_group(struct cxl_dc_tag_group *group)
+{
+	struct dc_extent *dc_extent;
+	unsigned long index;
+
+	/*
+	 * Pin @group across the walk: unregistering a dc_extent drops its
+	 * last reference and fires dc_extent_release(), which frees @group
+	 * on the final nr_extents decrement.  Without the pin the next
+	 * iteration's xa_find_after() dereferences a freed xarray.
+	 */
+	group->nr_extents++;
+	xa_for_each(&group->dc_extents, index, dc_extent) {
+		dev_dbg(&dc_extent->dev, "DAX region rm extent HPA %pra\n",
+			&dc_extent->hpa_range);
+		device_unregister(&dc_extent->dev);
+	}
+	dc_tag_group_del(group);
+	group->nr_extents--;
+	if (!group->nr_extents)
+		free_tag_group(group);
+}
+
+/*
+ * Region teardown, a devres action on the dax_region device: the host gives
+ * the group's capacity back to the device.  Flush the region's cached lines
+ * first; once the Release DC goes out the device may reassign the range.
+ * devres order puts the DAX devices created after the group ahead of it.
+ */
+static void dc_tag_group_teardown(void *_group)
+{
+	struct cxl_dc_tag_group *group = _group;
+
+	/* Exclude a release flush, which holds the lock for read */
+	guard(rwsem_write)(&cxl_rwsem.region);
+	cxl_region_invalidate_memregion(group->cxlr_dax->cxlr);
+	memdev_release_group(group);
+	unregister_tag_group(group);
+}
+
+/*
+ * Drop @group without telling the device anything: the caller has already
+ * decided what, if anything, the device is told about this capacity.
+ * Returns false when the dax region's unbind already owns the teardown.
+ */
+bool rm_tag_group(struct cxl_dc_tag_group *group)
+{
+	if (devm_remove_action_nowarn(&group->cxlr_dax->dev,
+				      dc_tag_group_teardown, group))
+		return false;
+	unregister_tag_group(group);
+	return true;
+}
+
+int online_tag_group(struct cxl_dc_tag_group *group)
+{
+	struct cxl_dax_region *cxlr_dax = group->cxlr_dax;
+	struct device *parent = &cxlr_dax->untagged;
+	struct dc_extent *dc_extent;
+	unsigned long index;
+	int rc = 0;
+
+	/*
+	 * Seed nr_extents with the full group size plus a +1 pin held by
+	 * this function.  The size counts every dc_extent that might
+	 * decrement nr_extents on cleanup; the pin keeps @group alive
+	 * across the body even if every dc_extent release fires in the
+	 * unwind (e.g. a devm_add_action() failure with a single extent).
+	 * The pin is dropped at the end of the function.
+	 */
+	xa_for_each(&group->dc_extents, index, dc_extent)
+		group->nr_extents++;
+	group->nr_extents++;
+
+	/* A tagged group parents its extents; untagged ones share @untagged */
+	if (!uuid_is_null(&group->uuid)) {
+		rc = dc_tag_group_add(group);
+		if (rc)
+			goto unwind;
+		parent = &group->dev;
+	} else {
+		rc = cxl_dax_untagged_add(cxlr_dax);
+		if (rc)
+			goto unwind;
+	}
+
+	xa_for_each(&group->dc_extents, index, dc_extent) {
+		struct device *dev = &dc_extent->dev;
+		u32 id;
+
+		device_initialize(dev);
+		device_set_pm_not_required(dev);
+		dev->parent = parent;
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
+			put_device(dev);
+			break;
+		}
+
+		rc = device_add(dev);
+		if (rc) {
+			put_device(dev);
+			break;
+		}
+
+		dev_dbg(dev, "dc_extent HPA %pra (%pU)\n",
+			&dc_extent->hpa_range, &group->uuid);
+	}
+
+	/* Give the capacity back when the region goes away */
+	if (!rc)
+		rc = devm_add_action(&cxlr_dax->dev, dc_tag_group_teardown, group);
+
+unwind:
+	if (rc) {
+		/*
+		 * Unwind every remaining dc_extent in the group.  The pin
+		 * above keeps @group alive across this walk.  Onlined
+		 * dc_extents are unregistered; pending ones were never
+		 * initialized as devices.
+		 */
+		xa_for_each(&group->dc_extents, index, dc_extent) {
+			if (device_is_registered(&dc_extent->dev))
+				device_unregister(&dc_extent->dev);
+			else
+				cleanup_pending_dc_extent(dc_extent);
+		}
+		dc_tag_group_del(group);
+	}
+
+	/* Drop the pin; if nothing else still references @group, free it. */
+	group->nr_extents--;
+	if (!group->nr_extents)
+		free_tag_group(group);
+	return rc;
+}
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index fea910e6c510..18044f216de5 100644
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
@@ -1201,6 +1202,84 @@ static void delete_extent_node(struct cxl_extent_list_node *node)
 	kfree(node);
 }
 
+/* Drop every node in @group, releasing its extent. */
+static void drop_extent_group(struct list_head *group)
+{
+	struct cxl_extent_list_node *pos, *tmp;
+
+	list_for_each_entry_safe(pos, tmp, group, list)
+		delete_extent_node(pos);
+}
+
+/* Queue @r for a Release DC command */
+static int stage_release_ack(struct list_head *acks, const struct range *r)
+{
+	struct cxl_extent_list_node *node = kzalloc_obj(*node);
+	struct cxl_extent *extent;
+
+	if (!node)
+		return -ENOMEM;
+	extent = kzalloc_obj(*extent);
+	if (!extent) {
+		kfree(node);
+		return -ENOMEM;
+	}
+
+	extent->start_dpa = cpu_to_le64(r->start);
+	extent->length = cpu_to_le64(range_len(r));
+	node->extent = extent;
+	list_add_tail(&node->list, acks);
+	return 0;
+}
+
+/*
+ * Queue every member of @group on @acks.  Returns the number queued, or
+ * -ENOMEM with nothing queued.
+ */
+static int stage_group_release(struct cxl_dc_tag_group *group,
+			       struct list_head *acks)
+{
+	struct dc_extent *dc_extent;
+	LIST_HEAD(members);
+	unsigned long idx;
+	int cnt = 0, rc;
+
+	xa_for_each(&group->dc_extents, idx, dc_extent) {
+		rc = stage_release_ack(&members, &dc_extent->dpa_range);
+		if (rc) {
+			drop_extent_group(&members);
+			return rc;
+		}
+		cnt++;
+	}
+
+	list_splice_tail(&members, acks);
+	return cnt;
+}
+
+/* Give @group's capacity back to the device with a Release DC response */
+void memdev_release_group(struct cxl_dc_tag_group *group)
+{
+	unsigned long idx = 0;
+	struct dc_extent *dc_extent = xa_find(&group->dc_extents, &idx,
+					      ULONG_MAX, XA_PRESENT);
+	struct cxl_memdev_state *mds;
+	LIST_HEAD(acks);
+	int cnt;
+
+	if (!dc_extent)
+		return;
+	/* A DC region is not interleaved: every member shares one memdev */
+	mds = cxled_to_mds(dc_extent->cxled);
+
+	cnt = stage_group_release(group, &acks);
+	if (cnt < 0 ||
+	    cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC, &acks, cnt))
+		dev_dbg(mds->cxlds.dev, "Failed to release tag %pUb\n",
+			&group->uuid);
+	drop_extent_group(&acks);
+}
+
 static void clear_pending_extents(void *_mds)
 {
 	struct cxl_memdev_state *mds = _mds;
@@ -1208,6 +1287,7 @@ static void clear_pending_extents(void *_mds)
 
 	list_for_each_entry_safe(pos, tmp, &mds->dc_chain.pending_extents, list)
 		delete_extent_node(pos);
+	mds->dc_chain.group = NULL;
 }
 
 /*
@@ -1315,6 +1395,168 @@ static int stage_pending_extent(struct list_head *pending,
 	return 0;
 }
 
+/*
+ * Compare two extents by shared_extn_seq (ascending).  list_sort is
+ * stable, so extents with equal keys keep their arrival order from
+ * stage_pending_extent()'s list_add_tail().
+ */
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
+/*
+ * Realize a tag @group: assign each extent its dax-side @seq_num and add it
+ * via cxl_add_extent(), then online the resulting tag group.  Returns the
+ * number of accepted extents (>= 0) with @group left holding them for the
+ * caller to splice, or a negative errno on failure with @group untouched for
+ * the caller to drop.
+ */
+static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
+			     struct list_head *group)
+{
+	struct device *dev = mds->cxlds.dev;
+	struct cxl_extent_list_node *pos;
+	struct cxl_dc_tag_group *tag_group;
+	int group_cnt = 0;
+	u16 seq_num;
+	int rc;
+
+	lockdep_assert_held(&cxl_rwsem.region);
+	lockdep_assert_held(&cxl_rwsem.dpa);
+
+	/* Each extent gets a dense dax-side seq_num, 0..n-1 */
+	seq_num = -1;
+	list_for_each_entry(pos, group, list) {
+		seq_num++;
+		rc = cxl_add_extent(mds, pos->extent, seq_num);
+		if (rc < 0) {
+			dev_dbg(dev,
+				"Tag %pUb: dropping group, failed to add extent DPA:%#llx LEN:%#llx\n",
+				tag,
+				le64_to_cpu(pos->extent->start_dpa),
+				le64_to_cpu(pos->extent->length));
+			goto err_discard;
+		}
+		group_cnt++;
+	}
+
+	tag_group = mds->dc_chain.group;
+	mds->dc_chain.group = NULL;
+	rc = online_tag_group(tag_group);
+	if (rc) {
+		dev_warn(dev, "Tag %pUb: failed to online tag group (%d)\n",
+			 tag, rc);
+		return rc;
+	}
+
+	return group_cnt;
+
+err_discard:
+	/*
+	 * A tag group is one allocation and sharable capacity must be
+	 * accepted all or none (CXL r4.0 8.2.10.9.9.3): unstage what was
+	 * built before the failing extent.
+	 */
+	tag_group = mds->dc_chain.group;
+	mds->dc_chain.group = NULL;
+	if (tag_group)
+		discard_tag_group(tag_group);
+	return rc;
+}
+
+/*
+ * Drive the pending Add-Capacity records through cxl_realize_group() one
+ * tag group at a time, moving each group that realizes onto the accepted
+ * list.
+ */
+static int cxl_add_pending(struct cxl_memdev_state *mds,
+			   struct list_head *pending)
+{
+	LIST_HEAD(accepted);
+	int total_accepted = 0;
+
+	/*
+	 * Held across validation, add and online so that cxlr_dax_unpublish()
+	 * excludes a whole flush; cxl_dpa_to_region() also walks every dpa_res.
+	 */
+	guard(rwsem_read)(&cxl_rwsem.region);
+	guard(rwsem_read)(&cxl_rwsem.dpa);
+
+	while (!list_empty(pending)) {
+		struct cxl_extent_list_node *first;
+		LIST_HEAD(group);
+		uuid_t tag;
+		int cnt;
+
+		first = list_first_entry(pending, struct cxl_extent_list_node,
+					 list);
+		import_uuid(&tag, first->extent->uuid);
+		/*
+		 * A null tag carries no allocation identity: surface each
+		 * untagged extent as its own single-extent group rather than
+		 * coalescing all untagged extents together.
+		 */
+		if (uuid_is_null(&tag))
+			list_move_tail(&first->list, &group);
+		else
+			extract_tag_group(pending, &tag, &group);
+
+		/*
+		 * Only a sharable allocation carries a meaningful per-extent
+		 * shared_extn_seq; order those by it.  For non-sharable groups,
+		 * the stable sort maintains arrival order.
+		 */
+		list_sort(NULL, &group, extent_seq_compare);
+
+		cnt = cxl_realize_group(mds, &tag, &group);
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
+	return cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
+				    pending, total_accepted);
+}
+
 static int handle_dcd_chain_event(struct cxl_memdev_state *mds,
 				  struct cxl_event_dcd *event)
 {
@@ -1359,11 +1601,9 @@ static int handle_dcd_chain_event(struct cxl_memdev_state *mds,
 	chain->armed = false;
 	cancel_delayed_work(&chain->timeout_work);
 
-	/* Nothing is tracked yet: refuse every add, acknowledge every release */
 	if (event->event_type == DCD_ADD_CAPACITY)
-		rc = cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
-					  &chain->pending_extents, 0);
-	else
+		rc = cxl_add_pending(mds, &chain->pending_extents);
+	else	/* Nothing is tracked yet: acknowledge every release */
 		rc = cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC,
 					  &chain->pending_extents,
 					  list_count_nodes(&chain->pending_extents));
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index fc9139ce358f..1b7031b2f159 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -224,7 +224,7 @@ static struct cxl_region_ref *cxl_rr_load(struct cxl_port *port,
 	return xa_load(&port->regions, (unsigned long)cxlr);
 }
 
-static int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
+int cxl_region_invalidate_memregion(struct cxl_region *cxlr)
 {
 	if (!cpu_cache_has_invalidate_memregion()) {
 		if (IS_ENABLED(CONFIG_CXL_REGION_INVALIDATION_TEST)) {
diff --git a/drivers/cxl/core/region_dax.c b/drivers/cxl/core/region_dax.c
index 47c9c52a3902..790176a8aadd 100644
--- a/drivers/cxl/core/region_dax.c
+++ b/drivers/cxl/core/region_dax.c
@@ -13,6 +13,8 @@ static void cxl_dax_region_release(struct device *dev)
 {
 	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
 
+	xa_destroy(&cxlr_dax->dc_extents);
+	ida_destroy(&cxlr_dax->tag_group_ida);
 	kfree(cxlr_dax);
 }
 
@@ -27,6 +29,20 @@ const struct device_type cxl_dax_region_type = {
 	.groups = cxl_dax_region_attribute_groups,
 };
 
+static void cxl_dax_untagged_release(struct device *dev)
+{
+	struct cxl_dax_region *cxlr_dax =
+		container_of(dev, struct cxl_dax_region, untagged);
+
+	/* Drop the pin taken in cxl_dax_region_alloc(). */
+	put_device(&cxlr_dax->dev);
+}
+
+static const struct device_type cxl_dax_untagged_type = {
+	.name = "untagged",
+	.release = cxl_dax_untagged_release,
+};
+
 static bool is_cxl_dax_region(struct device *dev)
 {
 	return dev->type == &cxl_dax_region_type;
@@ -49,7 +65,8 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
 	struct cxl_dax_region *cxlr_dax;
 	struct device *dev;
 
-	guard(rwsem_read)(&cxl_rwsem.region);
+	/* Publishes cxlr->cxlr_dax, which the event paths read under the read lock */
+	guard(rwsem_write)(&cxl_rwsem.region);
 	if (p->state != CXL_CONFIG_COMMIT)
 		return ERR_PTR(-ENXIO);
 
@@ -57,11 +74,14 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
 	if (!cxlr_dax)
 		return ERR_PTR(-ENOMEM);
 
+	xa_init_flags(&cxlr_dax->dc_extents, XA_FLAGS_ALLOC1);
+	ida_init(&cxlr_dax->tag_group_ida);
 	cxlr_dax->hpa_range.start = p->res->start;
 	cxlr_dax->hpa_range.end = p->res->end;
 
 	dev = &cxlr_dax->dev;
 	cxlr_dax->cxlr = cxlr;
+	cxlr->cxlr_dax = cxlr_dax;
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &cxl_dax_region_key);
 	device_set_pm_not_required(dev);
@@ -69,16 +89,70 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
 	dev->bus = &cxl_bus_type;
 	dev->type = &cxl_dax_region_type;
 
+	/* Parent of the untagged extents, see cxl_dax_untagged_add() */
+	dev = &cxlr_dax->untagged;
+	device_initialize(dev);
+	device_set_pm_not_required(dev);
+	dev->parent = &cxlr_dax->dev;
+	dev->type = &cxl_dax_untagged_type;
+	get_device(&cxlr_dax->dev);
+
 	return cxlr_dax;
 }
 
+/*
+ * Clearing cxlr->cxlr_dax here cannot race an Add or Release event.
+ * Event paths find cxlr_dax through cxl_dpa_to_region() and use it with
+ * cxl_rwsem.region held for read, from resolving an extent through
+ * onlining its group.  Taking the write lock waits those paths out, and
+ * later lookups find NULL, so the teardown that follows sees no events.
+ */
+static void cxlr_dax_unpublish(struct cxl_dax_region *cxlr_dax)
+{
+	guard(rwsem_write)(&cxl_rwsem.region);
+	cxlr_dax->cxlr->cxlr_dax = NULL;
+}
+
 static void cxlr_dax_unregister(void *_cxlr_dax)
 {
 	struct cxl_dax_region *cxlr_dax = _cxlr_dax;
 
+	cxlr_dax_unpublish(cxlr_dax);
+	/* Unbind first: the driver's teardown empties untagged and the groups */
+	device_release_driver(&cxlr_dax->dev);
+	if (device_is_registered(&cxlr_dax->untagged))
+		device_del(&cxlr_dax->untagged);
+	put_device(&cxlr_dax->untagged);
 	device_unregister(&cxlr_dax->dev);
 }
 
+/*
+ * The dax_region's driver may probe, and its extent scan run, before
+ * devm_cxl_add_dax_region() returns, so the untagged device is registered
+ * on first use instead.  Callers are serialized by the memdev's
+ * dc_chain.lock; a DC region has a single memdev behind it.
+ */
+int cxl_dax_untagged_add(struct cxl_dax_region *cxlr_dax)
+{
+	struct device *dev = &cxlr_dax->untagged;
+	int rc;
+
+	if (device_is_registered(dev))
+		return 0;
+
+	rc = dev_set_name(dev, "untagged");
+	if (rc)
+		return rc;
+	return device_add(dev);
+}
+
+DEFINE_FREE(unpublish_cxl_dax_region, struct cxl_dax_region *,
+	if (!IS_ERR_OR_NULL(_T)) {
+		cxlr_dax_unpublish(_T);
+		put_device(&_T->untagged);
+		put_device(&_T->dev);
+	})
+
 int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 {
 	struct device *dev;
@@ -90,7 +164,7 @@ int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 		return -EINVAL;
 	}
 
-	struct cxl_dax_region *cxlr_dax __free(put_cxl_dax_region) =
+	struct cxl_dax_region *cxlr_dax __free(unpublish_cxl_dax_region) =
 		cxl_dax_region_alloc(cxlr);
 	if (IS_ERR(cxlr_dax))
 		return PTR_ERR(cxlr_dax);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 64138e1768a1..f7d7749d704c 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -325,6 +325,42 @@ enum cxl_decoder_state {
 	CXL_DECODER_STATE_AUTO_STAGED,
 };
 
+struct cxl_dc_tag_group;
+
+/**
+ * struct dc_extent - A single dynamic-capacity extent surfaced to the host.
+ *
+ * One per device-stamped extent.  Multiple dc_extents that share a tag
+ * (see &struct cxl_dc_tag_group) form a single logical allocation, but
+ * each dc_extent has its own HPA range.
+ *
+ * @dev: device representing this extent; child of its tag_groupX.Y
+ *	device, or of the dax_region's untagged device for a null tag.
+ * @group: tag group that this extent belongs to; shared across siblings.
+ * @cxled: endpoint decoder backing the DPA range.
+ * @dpa_range: DPA range this extent covers within @cxled.
+ * @hpa_range: HPA range that @dpa_range decodes to, relative to
+ *	       cxlr_dax->hpa_range.start.
+ * @uuid: tag uuid (matches @group->uuid).
+ * @seq_num: 0..n-1 assembly-order index within the tag group.  For a
+ *	     sharable partition the order follows the shared_extn_seq given
+ *	     by the device; for a non-sharable partition, where
+ *	     shared_extn_seq is reserved, the order is the order in which
+ *	     extents arrive.  Either way @seq_num forms a dense range 0..n-1.
+ * @rcu: rcu_head for the kfree_rcu() deferred free in dc_extent_release(),
+ *	 so RCU readers walking the tag group's extents finish safely.
+ */
+struct dc_extent {
+	struct device dev;
+	struct cxl_dc_tag_group *group;
+	struct cxl_endpoint_decoder *cxled;
+	struct range dpa_range;
+	struct range hpa_range;
+	uuid_t uuid;
+	u16 seq_num;
+	struct rcu_head rcu;
+};
+
 /**
  * struct cxl_endpoint_decoder - Endpoint  / SPA to DPA decoder
  * @cxld: base cxl_decoder_object
@@ -490,6 +526,7 @@ struct cxl_region_params {
  * @type: Endpoint decoder target type
  * @cxl_nvb: nvdimm bridge for coordinating @cxlr_pmem setup / shutdown
  * @cxlr_pmem: (for pmem regions) cached copy of the nvdimm bridge
+ * @cxlr_dax: the region's cxl_dax_region while it is registered, else NULL
  * @flags: Region state flags
  * @shareable: (for DC regions) backing partitions must be shareable
  * @read_only: (for DC regions) backing partitions must be read-only
@@ -508,6 +545,7 @@ struct cxl_region {
 	enum cxl_decoder_type type;
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct cxl_pmem_region *cxlr_pmem;
+	struct cxl_dax_region *cxlr_dax;
 	unsigned long flags;
 	bool shareable;
 	bool read_only;
@@ -570,8 +608,57 @@ struct cxl_dax_region {
 	struct device dev;
 	struct cxl_region *cxlr;
 	struct range hpa_range;
+	/*
+	 * dc_extents is keyed by an allocator-assigned u32 (see
+	 * online_tag_group()).  Tag groups have no first-class identity in
+	 * this xarray; siblings within a tag find each other via
+	 * dc_extent->group.
+	 */
+	struct xarray dc_extents;
+	/* ids for the tag_groupX.Y devices registered under this region */
+	struct ida tag_group_ida;
+	/* parent of the extentX.Y devices of untagged allocations */
+	struct device untagged;
 };
 
+/**
+ * struct cxl_dc_tag_group - A tagged dynamic-capacity allocation.
+ *
+ * Container for the &struct dc_extent siblings that share a tag.  A
+ * tagged group is a tag_groupX.Y device under the dax_region and the
+ * parent of its extentX.Y devices; untagged extents, each a group of
+ * one, sit under the region's untagged device instead.  The group
+ * exists to keep tag-scoped invariants (atomic add, atomic release,
+ * ordered carve by seq_num) in one place.
+ *
+ * @dev: device representing a tagged group; child of cxlr_dax->dev.
+ *	Holds the group's memory: the last dc_extent release drops the
+ *	final reference.  Never registered for an untagged group.
+ * @cxlr_dax: back reference to parent region device.
+ * @uuid: tag identifying this allocation; same across all member dc_extents.
+ * @dc_extents: xarray of &struct dc_extent in this group, indexed by the
+ *		dc_extent's @seq_num (0..n-1, dense).  See &struct dc_extent
+ *		for how seq_num is sourced for sharable vs non-sharable
+ *		allocations.
+ * @nr_extents: live count of dc_extents in the group; the group is freed
+ *		when the last dc_extent device is released.
+ */
+struct cxl_dc_tag_group {
+	struct device dev;
+	struct cxl_dax_region *cxlr_dax;
+	uuid_t uuid;
+	struct xarray dc_extents;
+	unsigned int nr_extents;
+};
+
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
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 52c936ec15a9..73f01efc0172 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -433,6 +433,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
  * struct cxl_dc_event_chain - staged Dynamic Capacity event chain
  * @pending_extents: extents received so far; flushed when the chain
  *		     closes (More=0)
+ * @group: tag group being assembled from an Add Capacity chain
  * @timeout_work: watchdog that fires if a chain is opened with
  *		  CXL_DCD_EVENT_MORE but the closing record never arrives
  * @lock: serialises updates to the chain state against the watchdog
@@ -454,6 +455,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
  */
 struct cxl_dc_event_chain {
 	struct list_head pending_extents;
+	struct cxl_dc_tag_group *group;
 	struct delayed_work timeout_work;
 	struct mutex lock;	/* chain state, against the watchdog */
 	bool armed;
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index d8cc1c012f46..7d28aedfd2f7 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -539,6 +539,8 @@ static int alloc_dev_dax_id(struct dev_dax *dev_dax)
 	return id;
 }
 
+static bool is_dev_dax(struct device *dev);
+
 static ssize_t delete_store(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t len)
 {
@@ -555,6 +557,12 @@ static ssize_t delete_store(struct device *dev, struct device_attribute *attr,
 	if (!victim)
 		return -ENXIO;
 
+	/* Tag groups and the untagged device are children of the region too */
+	if (!is_dev_dax(victim)) {
+		put_device(victim);
+		return -EINVAL;
+	}
+
 	device_lock(dev);
 	device_lock(victim);
 	dev_dax = to_dev_dax(victim);
@@ -1443,6 +1451,11 @@ static const struct device_type dev_dax_type = {
 	.groups = dax_attribute_groups,
 };
 
+static bool is_dev_dax(struct device *dev)
+{
+	return dev->type == &dev_dax_type;
+}
+
 /* see "strong" declaration in tools/testing/nvdimm/dax-dev.c */
 __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
 			      unsigned long size)
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index e49ce644b4b1..f1ab25872e76 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -67,7 +67,10 @@ cxl_core-y += $(CXL_CORE_SRC)/hdm.o
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

