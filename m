Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3F738B14F
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529461; cv=none; b=nBei5gpPtPUbUmL14FfPMrFZR9vCfCVsMOemTsb1wCIZH/jWGD5YHWlBK69Tp7qPgBynnoxrfsf0t4FJwuuTGKlBTKEHkvaSPFQQcdRy5xi6mhlrWrVJppBw0l2lxleoEmkm67iFiuNA7K7pysszDCNSXrVENIDqRtmQ0nbBmgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529461; c=relaxed/simple;
	bh=8Jow8DG3d2WptgCMsc9FYVh7XS6QqwIucOECjDoRsOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S7Dy8qxeOr0Sjn3o/4owRx4e7J6Pu9cN09QvCJr2De7EuiDu7UI9HnIZDR6nQXutS38ZD0vWHg2a8OL5J6E+DWhqxHBfIMryEUk0HMnlaldTVO+tz/yTot9USnAi68qP7oJd4tD0+xTzvzdEpfCqej2j8mcgg8zsumN24X7CCLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FjAGvmpS; arc=none smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FjAGvmpS"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-132830d8281so2577560c88.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529457; x=1780134257; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1A+E8vTai+96KdZn19YhxgqouBodr4mZJg2tWaOKXWQ=;
        b=FjAGvmpS3WqbaOt5ynNpNM54nDkNiuxmo9puyQT5rhrlWFAmjxBBifFl3ciBtxNZ1F
         FAYsAm+vy8bVQcdjvLKK1I+1uQXqLBVwc4jnDYAX6SK0IvdZhAFtX8xQPTAMZZZH3cKA
         qMj2HzjqBsd5TaazuSj7lPCzVPHii7Qb2uaNRJvuLs9jDO4Nax0jpKSfKQSqht0ZNojG
         GNN5fODSbqCoN08DVxMPa0wJkQJgBXWRocqucdrnKX3L5p/fU6t0TpPslgs6kDwyFJ27
         A1GMr7018JQa1p1gM8HxGC1QxWxXb+GUlT5YGce6Z4Ag4DdYnEmpkNRnfk7+YG64uOba
         PQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529457; x=1780134257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1A+E8vTai+96KdZn19YhxgqouBodr4mZJg2tWaOKXWQ=;
        b=hfX8lc9FHMwqxufeHd/g0emH2QBFRVwai2dxxFkIz9xywNQL8BBGAJGfBJJGaKKEAm
         XrPRCYAtEXIMdqpqPOslqKm/48z+lDxIlQlwdOLu7mY1R3m4Noj6xyT02f7eVEZ7UQiP
         9ZZNhblXGlOXHRUWHWmHTS3yyHYZant1RJ72tq4/fMc6oADaIZWqBwDDKGDmZHIYgNf9
         e8SC36uY0D/bawAyLQ2nMypKXFszihYSYOd2tV3ljS3vsnvA1VCLex+JTIXiFKHAPfN5
         hFW6zzWyrmgX0H428JTmW1/bG7SMuI1RT9n65CWKTrNXgSBeSXnANv9+SDX4DVeHN1WN
         eFOQ==
X-Gm-Message-State: AOJu0Yx6UcwG+Ltb2/z18gM3DN50Jrzgpe4deNQKXT7UdZH0XzP7Nfva
	ahs/e//+6QU0k+/OOadddDeDUJQ5p+3G16ZGdntlDgw3GhFrDmNhQ9Fe
X-Gm-Gg: Acq92OFbTQ0HzqOzLnJc2ISIy//aTv9OyHvf6VmRsPZGcO3NWqOZn3aOGAPCF8nDvOh
	V5CMmPWQQ9enVElqjdOnCfKnytBnVOQLZasfUaUgEznLBdUz9UQCfu1DKaZlKWZvgDjBFi9+pMd
	qiPmFVTt3yIxGx7RFweMledptfR5nLH2e7nSewAx1CrLRvW3Fs1D6HPDJAsdJZPEBdwTO00vcPe
	61cfK7YGFC/JwsPNe/wsSXik3cge8cEHRD/cbR+J72vgbabas9D6fDm1gMqjhlqRVBmAppT1oHV
	syZLSd0FhkOEQej6Fip1TPKXlLDfskfLlpphO2wf2db4G/yhzfJMlM1T3Cd73JqQQYUa68Gg2lA
	4AeXpgDMtfzn9VuQUs9h3H7bvl90kbKGvoaR2m12EWQ7zuHaHFr3d6pMCaEhtuyzXEeuCI8OzYy
	/nka3/MHb77mgwgLYycXhJdJLli9A75hBMhhP1Wx/4ifIgl/0BlxWh7BEuyp26Htny1Japw68x1
	3zIgP4=
X-Received: by 2002:a05:701b:2617:b0:136:9b4a:21cf with SMTP id a92af1059eb24-1369b4a2c90mr242358c88.3.1779529457233;
        Sat, 23 May 2026 02:44:17 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:44:16 -0700 (PDT)
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
	Anisa Su <anisa.su@samsung.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v10 21/31] cxl + dax: Surface dax_resources on DCD Add Capacity events
Date: Sat, 23 May 2026 02:43:15 -0700
Message-ID: <9195bbfbed68420432eba01ebd5d50b2e284ccc0.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When an extent is accepted/released, the CXL driver must notify
the DAX driver to coordinate the management of resources. Define
the .notify callback to the cxl_dax region driver to enable
the coordination.

Define struct dax_resource, a sub-resource of a DC dax_region
representing the capacity of one dc_extent.

When the cxl side onlines a tag group during a DC Add event,
notify the DAX region to register a struct dax_resource for each
extent under the dax_region's resource tree.

The dax_resource model:

  * struct dax_resource (dax-private.h) — per-extent sub-resource of
    a DC dax_region: pointer back to its region, the kernel struct
    resource, the tag uuid, the per-allocation seq_num, and a use_cnt
    that lets a later commit refuse release of an in-use extent.
  * struct dev_dax_range gains a dax_resource back-pointer so a
    carved range remembers which extent it lives in.

For now, dax_resources live under the dax_region and remain inaccessible
to DAX devices. A later commit adds the support to specify a tag
when creating a DAX device, which then allows dax_resources to be
claimed by tag.

Release is handled in the following commit.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
[anisa：restructured from the original "Create resources on sparse DAX
 regions" commit】
---
 drivers/cxl/core/core.h   |  10 ++++
 drivers/cxl/core/extent.c |  33 ++++++++++-
 drivers/cxl/core/mbox.c   |  17 +++++-
 drivers/cxl/cxl.h         |   6 ++
 drivers/dax/bus.c         | 118 ++++++++++++++++++++++++++++++++++----
 drivers/dax/bus.h         |   3 +-
 drivers/dax/cxl.c         |  88 +++++++++++++++++++++++++++-
 drivers/dax/dax-private.h |  49 ++++++++++++++++
 drivers/dax/hmem/hmem.c   |   2 +-
 drivers/dax/pmem.c        |   2 +-
 10 files changed, 306 insertions(+), 22 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 02b36728c22d..c28e357c5817 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -72,6 +72,9 @@ int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
 bool cxl_tag_already_committed(const uuid_t *tag);
 int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent);
 int online_tag_group(struct cxl_dc_tag_group *group);
+void rm_tag_group(struct cxl_dc_tag_group *group);
+int cxlr_notify_extent(struct cxl_region *cxlr, enum dc_event event,
+		       struct cxl_dc_tag_group *group);
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
 				 const struct cxl_memdev *cxlmd, u64 dpa)
@@ -96,6 +99,13 @@ static inline bool cxl_tag_already_committed(const uuid_t *tag)
 {
 	return false;
 }
+static inline void rm_tag_group(struct cxl_dc_tag_group *group) { }
+static inline int cxlr_notify_extent(struct cxl_region *cxlr,
+				     enum dc_event event,
+				     struct cxl_dc_tag_group *group)
+{
+	return 0;
+}
 static inline
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
 				     struct cxl_endpoint_decoder **cxled)
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 34babfe032d1..3fc4b7292664 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -63,7 +63,6 @@ static const struct attribute_group dc_extent_attribute_group = {
 
 __ATTRIBUTE_GROUPS(dc_extent_attribute);
 
-
 static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
 				 struct dc_extent *dc_extent)
 {
@@ -359,6 +358,36 @@ dc_extent_build(struct cxl_endpoint_decoder *cxled,
 	return dc_extent;
 }
 
+int cxlr_notify_extent(struct cxl_region *cxlr, enum dc_event event,
+		       struct cxl_dc_tag_group *group)
+{
+	struct device *dev = &cxlr->cxlr_dax->dev;
+	struct cxl_notify_data notify_data;
+	struct cxl_driver *driver;
+
+	dev_dbg(dev, "Trying notify: type %d tag %pUb\n", event, &group->uuid);
+
+	guard(device)(dev);
+
+	/*
+	 * The lack of a driver indicates a notification has failed.  No user
+	 * space coordination was possible.
+	 */
+	if (!dev->driver)
+		return 0;
+	driver = to_cxl_drv(dev->driver);
+	if (!driver->notify)
+		return 0;
+
+	notify_data = (struct cxl_notify_data) {
+		.event = event,
+		.group = group,
+	};
+
+	dev_dbg(dev, "Notify: type %d tag %pUb\n", event, &group->uuid);
+	return driver->notify(dev, &notify_data);
+}
+
 /*
  * Stage 4: insert @dc_extent into the pending tag group.  All extents in
  * one More-chain group share a UUID — enforced here as the group is
@@ -462,7 +491,7 @@ static void dc_extent_unregister(void *ext)
 	device_unregister(&dc_extent->dev);
 }
 
-static void rm_tag_group(struct cxl_dc_tag_group *group)
+void rm_tag_group(struct cxl_dc_tag_group *group)
 {
 	struct device *region_dev = &group->cxlr_dax->dev;
 	struct dc_extent *dc_extent;
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 85959dee35ea..8071c1ed1b36 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1558,8 +1558,21 @@ static int cxl_add_pending(struct cxl_memdev_state *mds)
 			list_for_each_entry_safe(pos, tmp, &group, list)
 				delete_extent_node(pos);
 		} else {
-			list_splice_tail_init(&group, &accepted);
-			total_accepted += group_cnt;
+			rc = cxlr_notify_extent(tag_group->cxlr_dax->cxlr,
+						DCD_ADD_CAPACITY, tag_group);
+			if (rc) {
+				/*
+				 * The dax-side notification failed; tear down the
+				 * tag group and drop the extents so we do not
+				 * mis-report acceptance to the device.
+				 */
+				rm_tag_group(tag_group);
+				list_for_each_entry_safe(pos, tmp, &group, list)
+					delete_extent_node(pos);
+			} else {
+				list_splice_tail_init(&group, &accepted);
+				total_accepted += group_cnt;
+			}
 		}
 
 		mds->add_ctx.group = NULL;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index a28e7b12a4a8..27e3046654e9 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -892,6 +892,11 @@ bool is_cxl_region(struct device *dev);
 
 extern const struct bus_type cxl_bus_type;
 
+struct cxl_notify_data {
+	enum dc_event event;
+	struct cxl_dc_tag_group *group;
+};
+
 /*
  * Note, add_dport() is expressly for the cxl_port driver. TODO: investigate a
  * type-safe driver model where probe()/remove() take the type of object implied
@@ -904,6 +909,7 @@ struct cxl_driver {
 	void (*remove)(struct device *dev);
 	struct cxl_dport *(*add_dport)(struct cxl_port *port,
 				       struct device *dport_dev);
+	int (*notify)(struct device *dev, struct cxl_notify_data *notify_data);
 	struct device_driver drv;
 	int id;
 };
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index b0c2162b5e37..a6ee59f2d8a1 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -186,6 +186,73 @@ static bool is_dynamic(struct dax_region *dax_region)
 	return (dax_region->res.flags & IORESOURCE_DAX_DCD) != 0;
 }
 
+static void __dax_release_resource(struct dax_resource *dax_resource)
+{
+	struct dax_region *dax_region = dax_resource->region;
+
+	lockdep_assert_held_write(&dax_region_rwsem);
+	dev_dbg(dax_region->dev, "Extent release resource %pr\n",
+		dax_resource->res);
+	if (dax_resource->res)
+		__release_region(&dax_region->res, dax_resource->res->start,
+				 resource_size(dax_resource->res));
+	dax_resource->res = NULL;
+}
+
+static void dax_release_resource(void *res)
+{
+	struct dax_resource *dax_resource = res;
+
+	guard(rwsem_write)(&dax_region_rwsem);
+	__dax_release_resource(dax_resource);
+	kfree(dax_resource);
+}
+
+int dax_region_add_resource(struct dax_region *dax_region,
+			    struct device *device,
+			    resource_size_t start, resource_size_t length,
+			    const uuid_t *tag, u16 seq_num)
+{
+	struct resource *new_resource;
+	int rc;
+
+	struct dax_resource *dax_resource __free(kfree) =
+				kzalloc(sizeof(*dax_resource), GFP_KERNEL);
+	if (!dax_resource)
+		return -ENOMEM;
+
+	guard(rwsem_write)(&dax_region_rwsem);
+
+	dev_dbg(dax_region->dev, "DAX region resource %pr\n", &dax_region->res);
+	new_resource = __request_region(&dax_region->res, start, length, "extent", 0);
+	if (!new_resource) {
+		dev_err(dax_region->dev, "Failed to add region s:%pa l:%pa\n",
+			&start, &length);
+		return -ENOSPC;
+	}
+
+	dev_dbg(dax_region->dev, "add resource %pr\n", new_resource);
+	dax_resource->region = dax_region;
+	dax_resource->res = new_resource;
+	dax_resource->seq_num = seq_num;
+	if (tag)
+		uuid_copy(&dax_resource->uuid, tag);
+
+	/*
+	 * open code devm_add_action_or_reset() to avoid recursive write lock
+	 * of dax_region_rwsem in the error case.
+	 */
+	rc = devm_add_action(device, dax_release_resource, dax_resource);
+	if (rc) {
+		__dax_release_resource(dax_resource);
+		return rc;
+	}
+
+	dev_set_drvdata(device, no_free_ptr(dax_resource));
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dax_region_add_resource);
+
 bool static_dev_dax(struct dev_dax *dev_dax)
 {
 	return is_static(dev_dax->region);
@@ -304,14 +371,25 @@ static struct device_attribute dev_attr_region_align =
 
 static unsigned long long dax_region_avail_size(struct dax_region *dax_region)
 {
-	resource_size_t size = resource_size(&dax_region->res);
+	resource_size_t size;
 	struct resource *res;
 
 	lockdep_assert_held(&dax_region_rwsem);
 
-	if (is_dynamic(dax_region))
-		return 0;
+	if (is_dynamic(dax_region)) {
+		/*
+		 * Children of a dynamic region are extents, claimed
+		 * all-or-nothing: an extent's resource is either unclaimed (no
+		 * child) or fully consumed by exactly one dax device.
+		 */
+		size = 0;
+		for_each_dax_region_resource(dax_region, res)
+			if (!res->child)
+				size += resource_size(res);
+		return size;
+	}
 
+	size = resource_size(&dax_region->res);
 	for_each_dax_region_resource(dax_region, res)
 		size -= resource_size(res);
 	return size;
@@ -452,15 +530,26 @@ EXPORT_SYMBOL_GPL(kill_dev_dax);
 static void trim_dev_dax_range(struct dev_dax *dev_dax)
 {
 	int i = dev_dax->nr_range - 1;
-	struct range *range = &dev_dax->ranges[i].range;
+	struct dev_dax_range *dev_range = &dev_dax->ranges[i];
+	struct range *range = &dev_range->range;
 	struct dax_region *dax_region = dev_dax->region;
+	struct resource *res = &dax_region->res;
 
 	lockdep_assert_held_write(&dax_region_rwsem);
 	dev_dbg(&dev_dax->dev, "delete range[%d]: %#llx:%#llx\n", i,
 		(unsigned long long)range->start,
 		(unsigned long long)range->end);
 
-	__release_region(&dax_region->res, range->start, range_len(range));
+	if (dev_range->dax_resource) {
+		res = dev_range->dax_resource->res;
+		dev_dbg(&dev_dax->dev, "Trim dc extent %pr\n", res);
+	}
+
+	__release_region(res, range->start, range_len(range));
+
+	if (dev_range->dax_resource)
+		dev_range->dax_resource->use_cnt--;
+
 	if (--dev_dax->nr_range == 0) {
 		kfree(dev_dax->ranges);
 		dev_dax->ranges = NULL;
@@ -644,11 +733,14 @@ static void dax_region_unregister(void *region)
 
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct range *range, int target_node, unsigned int align,
-		unsigned long flags)
+		unsigned long flags, struct dax_dc_ops *dc_ops)
 {
 	struct dax_region *dax_region;
 	int rc;
 
+	if (!dc_ops && (flags & IORESOURCE_DAX_DCD))
+		return NULL;
+
 	/*
 	 * The DAX core assumes that it can store its private data in
 	 * parent->driver_data. This WARN is a reminder / safeguard for
@@ -673,6 +765,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 	dax_region->align = align;
 	dax_region->dev = parent;
 	dax_region->target_node = target_node;
+	dax_region->dc_ops = dc_ops;
 	ida_init(&dax_region->ida);
 	dax_region->res = (struct resource) {
 		.start = range->start,
@@ -861,7 +954,7 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
 }
 
 static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
-		resource_size_t size)
+		resource_size_t size, struct dax_resource *dax_resource)
 {
 	struct dax_region *dax_region = dev_dax->region;
 	struct resource *res = &dax_region->res;
@@ -902,6 +995,7 @@ static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
 			.start = alloc->start,
 			.end = alloc->end,
 		},
+		.dax_resource = dax_resource,
 	};
 
 	dev_dbg(dev, "alloc range[%d]: %pa:%pa\n", dev_dax->nr_range - 1,
@@ -1075,7 +1169,7 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
 retry:
 	first = region_res->child;
 	if (!first)
-		return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc);
+		return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc, NULL);
 
 	rc = -ENOSPC;
 	for (res = first; res; res = res->sibling) {
@@ -1084,7 +1178,7 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
 		/* space at the beginning of the region */
 		if (res == first && res->start > dax_region->res.start) {
 			alloc = min(res->start - dax_region->res.start, to_alloc);
-			rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, alloc);
+			rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, alloc, NULL);
 			break;
 		}
 
@@ -1104,7 +1198,7 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
 			rc = adjust_dev_dax_range(dev_dax, res, resource_size(res) + alloc);
 			break;
 		}
-		rc = alloc_dev_dax_range(dev_dax, res->end + 1, alloc);
+		rc = alloc_dev_dax_range(dev_dax, res->end + 1, alloc, NULL);
 		break;
 	}
 	if (rc)
@@ -1214,7 +1308,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 
 	to_alloc = range_len(&r);
 	if (alloc_is_aligned(dev_dax, to_alloc))
-		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
+		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc, NULL);
 	up_write(&dax_dev_rwsem);
 	up_write(&dax_region_rwsem);
 
@@ -1506,7 +1600,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	device_initialize(dev);
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
 
-	rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, data->size);
+	rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, data->size, NULL);
 	if (rc)
 		goto err_range;
 
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 6e739bfab932..7a115893a102 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -11,6 +11,7 @@ struct dev_dax;
 struct resource;
 struct dax_device;
 struct dax_region;
+struct dax_dc_ops;
 
 /* dax bus specific ioresource flags */
 #define IORESOURCE_DAX_STATIC BIT(0)
@@ -19,7 +20,7 @@ struct dax_region;
 
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct range *range, int target_node, unsigned int align,
-		unsigned long flags);
+		unsigned long flags, struct dax_dc_ops *dc_ops);
 
 struct dev_dax_data {
 	struct dax_region *dax_region;
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index f58fe992aa8d..690cf625e052 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -5,6 +5,84 @@
 
 #include "../cxl/cxl.h"
 #include "bus.h"
+#include "dax-private.h"
+
+static int __cxl_dax_add_resource(struct dax_region *dax_region,
+				  struct dc_extent *dc_extent)
+{
+	struct device *dev = &dc_extent->dev;
+	resource_size_t start, length;
+
+	start = dax_region->res.start + dc_extent->hpa_range.start;
+	length = range_len(&dc_extent->hpa_range);
+	return dax_region_add_resource(dax_region, dev, start, length,
+				       &dc_extent->group->uuid,
+				       dc_extent->seq_num);
+}
+
+static int cxl_dax_add_resource(struct device *dev, void *data)
+{
+	struct dax_region *dax_region = data;
+	struct dc_extent *dc_extent;
+
+	dc_extent = to_dc_extent(dev);
+	if (!dc_extent)
+		return 0;
+
+	dev_dbg(dax_region->dev, "Adding resource HPA %pra (%pUb)\n",
+		&dc_extent->hpa_range, &dc_extent->group->uuid);
+
+	return __cxl_dax_add_resource(dax_region, dc_extent);
+}
+
+static int cxl_dax_group_add(struct dax_region *dax_region,
+			     struct cxl_dc_tag_group *group)
+{
+	struct dc_extent *dc_extent;
+	unsigned long index;
+	int rc;
+
+	xa_for_each(&group->dc_extents, index, dc_extent) {
+		rc = __cxl_dax_add_resource(dax_region, dc_extent);
+		if (rc)
+			return rc;
+	}
+	return 0;
+}
+
+/*
+ * RELEASE is still a stub here — the atomic dax_region_rm_resources API
+ * and its wire-up land in the next commit.  An incoming RELEASE returns
+ * success and the cxl side proceeds to rm_tag_group(), which device-
+ * unregisters each dc_extent; the devm action armed by
+ * dax_region_add_resource() then tears down each dax_resource.
+ */
+static int cxl_dax_region_notify(struct device *dev,
+				 struct cxl_notify_data *notify_data)
+{
+	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
+	struct dax_region *dax_region = dev_get_drvdata(dev);
+	struct cxl_dc_tag_group *group = notify_data->group;
+
+	switch (notify_data->event) {
+	case DCD_ADD_CAPACITY:
+		return cxl_dax_group_add(dax_region, group);
+	case DCD_RELEASE_CAPACITY:
+		dev_dbg(&cxlr_dax->dev,
+			"DCD RELEASE notify (tag %pUb): no-op (stub)\n",
+			&group->uuid);
+		return 0;
+	case DCD_FORCED_CAPACITY_RELEASE:
+	default:
+		dev_err(&cxlr_dax->dev, "Unknown DC event %d\n",
+			notify_data->event);
+		return -ENXIO;
+	}
+}
+
+static struct dax_dc_ops dc_ops = {
+	.is_extent = is_dc_extent,
+};
 
 static int cxl_dax_region_probe(struct device *dev)
 {
@@ -25,15 +103,18 @@ static int cxl_dax_region_probe(struct device *dev)
 		flags = IORESOURCE_DAX_KMEM;
 
 	dax_region = alloc_dax_region(dev, cxlr->id, &cxlr_dax->hpa_range, nid,
-				      PMD_SIZE, flags);
+				      PMD_SIZE, flags, &dc_ops);
 	if (!dax_region)
 		return -ENOMEM;
 
-	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A)
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A) {
+		device_for_each_child(&cxlr_dax->dev, dax_region,
+				      cxl_dax_add_resource);
 		/* Add empty seed dax device */
 		dev_size = 0;
-	else
+	} else {
 		dev_size = range_len(&cxlr_dax->hpa_range);
+	}
 
 	data = (struct dev_dax_data) {
 		.dax_region = dax_region,
@@ -48,6 +129,7 @@ static int cxl_dax_region_probe(struct device *dev)
 static struct cxl_driver cxl_dax_region_driver = {
 	.name = "cxl_dax_region",
 	.probe = cxl_dax_region_probe,
+	.notify = cxl_dax_region_notify,
 	.id = CXL_DEVICE_DAX_REGION,
 	.drv = {
 		.suppress_bind_attrs = true,
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index ee8f3af8387f..f2ae5918f94d 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -8,6 +8,7 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 #include <linux/idr.h>
+#include <linux/uuid.h>
 
 /* private routines between core files */
 struct dax_device;
@@ -16,6 +17,14 @@ struct inode *dax_inode(struct dax_device *dax_dev);
 int dax_bus_init(void);
 void dax_bus_exit(void);
 
+/**
+ * struct dax_dc_ops - Operations for dc-backed regions
+ * @is_extent: return if the device is an extent
+ */
+struct dax_dc_ops {
+	bool (*is_extent)(struct device *dev);
+};
+
 /**
  * struct dax_region - mapping infrastructure for dax devices
  * @id: kernel-wide unique region for a memory range
@@ -27,6 +36,7 @@ void dax_bus_exit(void);
  * @res: resource tree to track instance allocations
  * @seed: allow userspace to find the first unbound seed device
  * @youngest: allow userspace to find the most recently created device
+ * @dc_ops: operations required for DC-backed regions
  */
 struct dax_region {
 	int id;
@@ -38,6 +48,7 @@ struct dax_region {
 	struct resource res;
 	struct device *seed;
 	struct device *youngest;
+	struct dax_dc_ops *dc_ops;
 };
 
 /**
@@ -57,11 +68,13 @@ struct dax_mapping {
  * @pgoff: page offset
  * @range: resource-span
  * @mapping: reference to the dax_mapping for this range
+ * @dax_resource: if not NULL; dax DC resource containing this range
  */
 struct dev_dax_range {
 	unsigned long pgoff;
 	struct range range;
 	struct dax_mapping *mapping;
+	struct dax_resource *dax_resource;
 };
 
 /**
@@ -105,6 +118,42 @@ struct dev_dax {
  */
 void run_dax(struct dax_device *dax_dev);
 
+/**
+ * struct dax_resource - For DC DAX regions; an active resource
+ * @region: dax_region this resources is in
+ * @res: resource
+ * @uuid: tag identifying the backing extent; zero uuid means untagged
+ * @seq_num: 1..n assembly-order index within the tag group; 0 for the
+ *	     untagged pool (uuid == 0).  For extents from a sharable
+ *	     CXL DC partition this is the device-stamped shared_extn_seq
+ *	     (CXL 3.1 Table 8-51).  For extents from a non-sharable
+ *	     partition the cxl layer fills it in event arrival order, so
+ *	     the dax layer can rely on a single 1..n dense invariant when
+ *	     it claims a tagged group in uuid_store().
+ * @use_cnt: count the number of uses of this resource
+ *
+ * Changes to the dax_region and the dax_resources within it are protected by
+ * dax_region_rwsem
+ *
+ * dax_resource's are not intended to be used outside the dax layer.
+ */
+struct dax_resource {
+	struct dax_region *region;
+	struct resource *res;
+	uuid_t uuid;
+	u16 seq_num;
+	unsigned int use_cnt;
+};
+
+/*
+ * Similar to run_dax() dax_region_add_resource() is exported but is not
+ * intended to be a generic operation outside the dax subsystem.  It is only
+ * generic between the dax layer and the dax drivers.
+ */
+int dax_region_add_resource(struct dax_region *dax_region, struct device *dev,
+			    resource_size_t start, resource_size_t length,
+			    const uuid_t *tag, u16 seq_num);
+
 static inline struct dev_dax *to_dev_dax(struct device *dev)
 {
 	return container_of(dev, struct dev_dax, dev);
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index af21f66bf872..be938c2a73f8 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -28,7 +28,7 @@ static int dax_hmem_probe(struct platform_device *pdev)
 
 	mri = dev->platform_data;
 	dax_region = alloc_dax_region(dev, pdev->id, &mri->range,
-				      mri->target_node, PMD_SIZE, flags);
+				      mri->target_node, PMD_SIZE, flags, NULL);
 	if (!dax_region)
 		return -ENOMEM;
 
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index bee93066a849..5b5be86768f3 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -53,7 +53,7 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
 	range.start += offset;
 	dax_region = alloc_dax_region(dev, region_id, &range,
 			nd_region->target_node, le32_to_cpu(pfn_sb->align),
-			IORESOURCE_DAX_STATIC);
+			IORESOURCE_DAX_STATIC, NULL);
 	if (!dax_region)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.43.0

