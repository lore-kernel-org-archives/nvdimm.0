Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7AD3DA5AC
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386943; cv=none; b=nH+3a1hhCkwdH1C/+77zZAZeMWkOjzjliPWMtRa5YunSnOs9cbdwPPCUyYfkxVrbnDUrmFsaVhcEIYfLlsZESQvA/M3Tv7m+gvXDgoxMn7OGFXikEkwH8t8CF8YXORVt7G741SiP8SdX4dRmTl6hQYiUZazI8pt78wkS45BSQeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386943; c=relaxed/simple;
	bh=tAi1h9FGQckixVb+wSTE+MwpxXo6sEEQjm+ZckqBZHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JBCDjxV4wMxhE501ibXJW3yfbNCSX3DZueZep294wYy/LY+ybLL162ny40rKp/Iyg7Ntm9irqafyxmuvM1rhEQfIbFULWQpqGRA1ueu9IjVjPxWnrH2G7ZT/3lZ8/dFrfbaDLajUfw9G0SYSm+yxc81TeIYMeSSLhKZ35lGYy6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W9MNxVeZ; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W9MNxVeZ"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-30bf854d5feso5234345eec.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386939; x=1782991739; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0l0bYz6IEDWlJCqyWOGt4k107SrhVylWJQSepQGd8qM=;
        b=W9MNxVeZSvb8D6ke/b5/wwPKVhZh0u8D2HZoO6WSg1HOaz82Opu+njUqM/TnVtFw/H
         Ak8YWBardaDY71d1mIeZknQk8tFDb3L844u5/ofAQsZnKhXLatCF6QXKU2WoqF4JVhro
         FA/13krtcwc4bN33xTx7/7F8PD7a50aDeIY2VlPBbac3zylrmV1bEyhWpguoZfOKP46N
         X+Yhag4oCX0vxujoGRgJfXfza+DezeOfZRcpNK648HPJZAWYEhZZ+3CU+srDJp1Cd+9r
         7LVEiFK6+KA/oile1g08iRZKmqLvREiuWtUmsvfFg0vHeqYToJdkE7Ld9O9lePBdyv8z
         K0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386939; x=1782991739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0l0bYz6IEDWlJCqyWOGt4k107SrhVylWJQSepQGd8qM=;
        b=EhjYZlR5eOjey+f3o2Sdm5P+ucnrMhS8F5BxGqwVS8HnaasrIYfhdoxghxh2smCezB
         888wbaUrvxFCQ2MQ8RS2MYWr+4uyGHRmpMk2GEIqf3kGh0nv6WNcsAZ3bPWp5VtZE184
         T6YlmrJAiTICToxjxzexd6CHcOnnXMlrHh6W/NTfDgCg+faE1w01Hh5gcD28h/FNp5Yb
         NKjoyGEJXHAyzm7TlDrlYjAWOKL/taGa8/KJBw4K4rb7RNp/E2lLOEfxFQspcv+TXfW8
         ogqxkJz9e0nUbLaPXNpBMXODFDo4FPWld5mFID13fsdolgRJh6twqNr3k+WicsQFmgrj
         faKg==
X-Gm-Message-State: AOJu0YyZEIQOi7Dhw/vIAGNEJjoJyeq+eJ4uUg9z73bz2WS7IUobfMJf
	IrirDbXVo5CZ+kjtmazAYsFqeZ5NS4X/iWkCWl3t1T/K4n2TeBr1F1gN
X-Gm-Gg: AfdE7cm3K4rvIpeCwPHd1gUSOF5QBrVr1DwJUr4UDSoH7/lStyflkDEEMuoY2Zn/y15
	Ei02pzfr4oTuQYrtdiBVbKGLRenOihiTko3pS4VQvVt4eErNUa3sZOLBAGoicH3KGatN2Ya1tcH
	75mHB9TnBmoTTkdxc+OcXR4N4S4+2L1pqmWd2y25sfaG3/mRwJvhAm5lcDMoCW3Rc1llZYHhuqS
	+glQc+7mCOZyAC/FJwfQNffA9s/LdUNq4cfhCPvae8svzg0X6Oxj8bux5mlZI4jda/Dbu+rC+GC
	NQA56ZvUZBImPZZDtv1zi/HTDFJci00j7lQU0sbde6yGT+3lnX7hK5e8fRBnDxsb9WHWOvwUiod
	FV76zsJi4U20HiYY3CDEcrsf5Ezlujh1a4LRGAh/tTgB0NK58r+yTpu5FkFaGApE8YRqie6sNgg
	4MHa6/jRayXYpKVJlaACRrghpse9uogmqjsuwpH66N89b8BJkfNkJphdhIugzbEfLJJVyO
X-Received: by 2002:a05:7300:4342:b0:30c:57ff:454e with SMTP id 5a478bee46e88-30c84dae817mr2447488eec.18.1782386939125;
        Thu, 25 Jun 2026 04:28:59 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:58 -0700 (PDT)
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
Subject: [PATCH v11 21/31] cxl + dax: Surface dax_resources on DCD Add Capacity events
Date: Thu, 25 Jun 2026 04:04:58 -0700
Message-ID: <20260625112638.550691-22-anisa.su@samsung.com>
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

When an extent is accepted/released, the CXL driver must notify
the DAX driver to coordinate the management of resources. Define
the .notify callback to the cxl_dax region driver to enable
the coordination.

Define struct dax_resource, a sub-resource of a DC dax_region
representing the capacity of one dc_extent.

When the cxl side onlines a tag group during a DC Add event, notify the
DAX region to register a struct dax_resource for each extent.  Surface
the group atomically: dax_region_add_resources() registers every
extent's dax_resource under one dax_region_rwsem and rolls the whole
set back on any failure, so a partial group (or one racing a concurrent
uuid_store claim) never lands in the region.

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

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
1. add the dax_resource set atomically via dax_region_add_resources()
   (all-or-none under dax_region_rwsem), instead of a per-extent walk
   that had to be removed again later.
---
 drivers/cxl/core/core.h   |  10 +++
 drivers/cxl/core/extent.c |  36 +++++++-
 drivers/cxl/core/mbox.c   |  18 ++++
 drivers/cxl/cxl.h         |   6 ++
 drivers/dax/bus.c         | 183 +++++++++++++++++++++++++++++++++++---
 drivers/dax/bus.h         |   3 +-
 drivers/dax/cxl.c         |  71 ++++++++++++++-
 drivers/dax/dax-private.h |  59 ++++++++++++
 drivers/dax/hmem/hmem.c   |   2 +-
 drivers/dax/pmem.c        |   2 +-
 10 files changed, 371 insertions(+), 19 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index ab75cc67c24d..1a2bc22ad3cc 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -70,6 +70,9 @@ int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent,
 bool cxl_tag_already_committed(const uuid_t *tag);
 int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent);
 int online_tag_group(struct cxl_dc_tag_group *group, bool skip_release);
+void rm_tag_group(struct cxl_dc_tag_group *group);
+int cxlr_notify_extent(struct cxl_region *cxlr, enum dc_event event,
+		       struct cxl_dc_tag_group *group);
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
 				 const struct cxl_memdev *cxlmd, u64 dpa)
@@ -95,6 +98,13 @@ static inline bool cxl_tag_already_committed(const uuid_t *tag)
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
index 69c993cdd558..59db1878b5e2 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -61,7 +61,6 @@ static const struct attribute_group dc_extent_attribute_group = {
 
 __ATTRIBUTE_GROUPS(dc_extent_attribute);
 
-
 static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
 				 struct dc_extent *dc_extent)
 {
@@ -142,7 +141,8 @@ static void dc_extent_release(struct device *dev)
 		return;
 
 	group = dc_extent->group;
-	cxled_release_extent(dc_extent->cxled, dc_extent);
+	if (!group->skip_device_release)
+		cxled_release_extent(dc_extent->cxled, dc_extent);
 	xa_erase(&group->cxlr_dax->dc_extents, dc_extent->dev.id);
 	xa_erase(&group->dc_extents, dc_extent->seq_num);
 	group->nr_extents--;
@@ -376,6 +376,36 @@ dc_extent_build(struct cxl_endpoint_decoder *cxled,
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
@@ -486,7 +516,7 @@ static void dc_extent_unregister(void *ext)
 	device_unregister(&dc_extent->dev);
 }
 
-static void rm_tag_group(struct cxl_dc_tag_group *group)
+void rm_tag_group(struct cxl_dc_tag_group *group)
 {
 	struct device *region_dev = &group->cxlr_dax->dev;
 	struct dc_extent *dc_extent;
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 0e6d6ad0390b..79258681d428 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1527,6 +1527,24 @@ static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
 		return rc;
 	}
 
+	rc = cxlr_notify_extent(tag_group->cxlr_dax->cxlr, DCD_ADD_CAPACITY,
+				tag_group);
+	if (rc) {
+		/*
+		 * The dax-side notification failed; tear down the tag group.
+		 * For a fresh add (!existing) the extents were never accepted —
+		 * they are omitted from the trailing Add-DC-Response — so
+		 * suppress the per-extent Release DC; the device never handed us
+		 * this capacity to release.  Recovered (existing) extents are
+		 * already accepted and cannot be re-notified, so release them
+		 * back to the device rather than leak the capacity.
+		 */
+		if (!existing)
+			tag_group->skip_device_release = true;
+		rm_tag_group(tag_group);
+		return rc;
+	}
+
 	return group_cnt;
 }
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index e82d8bf1388b..1bb861bb23fe 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -898,6 +898,11 @@ bool is_cxl_region(struct device *dev);
 
 extern const struct bus_type cxl_bus_type;
 
+struct cxl_notify_data {
+	enum dc_event event;
+	struct cxl_dc_tag_group *group;
+};
+
 /*
  * Note, add_dport() is expressly for the cxl_port driver. TODO: investigate a
  * type-safe driver model where probe()/remove() take the type of object implied
@@ -910,6 +915,7 @@ struct cxl_driver {
 	void (*remove)(struct device *dev);
 	struct cxl_dport *(*add_dport)(struct cxl_port *port,
 				       struct device *dport_dev);
+	int (*notify)(struct device *dev, struct cxl_notify_data *notify_data);
 	struct device_driver drv;
 	int id;
 };
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 7356aaaffe57..9b5c03616b83 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -182,6 +182,138 @@ static bool is_dynamic(struct dax_region *dax_region)
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
+static int __dax_region_add_resource(struct dax_region *dax_region,
+				     struct device *device,
+				     resource_size_t start, resource_size_t length,
+				     const uuid_t *tag, u16 seq_num)
+{
+	struct dax_resource *dax_resource __free(kfree) =
+				kzalloc(sizeof(*dax_resource), GFP_KERNEL);
+	struct resource *new_resource;
+	int rc;
+
+	lockdep_assert_held_write(&dax_region_rwsem);
+
+	if (!dax_resource)
+		return -ENOMEM;
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
+
+int dax_region_add_resource(struct dax_region *dax_region,
+			    struct device *device,
+			    resource_size_t start, resource_size_t length,
+			    const uuid_t *tag, u16 seq_num)
+{
+	guard(rwsem_write)(&dax_region_rwsem);
+	return __dax_region_add_resource(dax_region, device, start, length,
+					 tag, seq_num);
+}
+EXPORT_SYMBOL_GPL(dax_region_add_resource);
+
+static int __dax_region_rm_resource(struct dax_region *dax_region,
+				    struct device *dev)
+{
+	struct dax_resource *dax_resource;
+
+	lockdep_assert_held_write(&dax_region_rwsem);
+
+	dax_resource = dev_get_drvdata(dev);
+	if (!dax_resource)
+		return 0;
+
+	if (dax_resource->use_cnt)
+		return -EBUSY;
+
+	/*
+	 * release the resource under dax_region_rwsem to avoid races with
+	 * users trying to use the extent
+	 */
+	__dax_release_resource(dax_resource);
+	dev_set_drvdata(dev, NULL);
+	return 0;
+}
+
+/**
+ * dax_region_add_resources - atomically add a set of dax_resources.
+ *
+ * Hold dax_region_rwsem across the whole set so the add cannot interleave
+ * with a concurrent claim (uuid_store) or removal.  On any failure, roll
+ * back the resources already added in this call, leaving the region
+ * unchanged.  Mirrors dax_region_rm_resources()'s all-or-none semantics.
+ */
+int dax_region_add_resources(struct dax_region *dax_region,
+			     const struct dax_resource_spec *specs,
+			     unsigned int n, const uuid_t *tag)
+{
+	unsigned int i;
+	int rc;
+
+	guard(rwsem_write)(&dax_region_rwsem);
+
+	for (i = 0; i < n; i++) {
+		rc = __dax_region_add_resource(dax_region, specs[i].device,
+					       specs[i].start, specs[i].length,
+					       tag, specs[i].seq_num);
+		if (rc) {
+			while (i-- > 0)
+				__dax_region_rm_resource(dax_region,
+							 specs[i].device);
+			return rc;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dax_region_add_resources);
+
 bool static_dev_dax(struct dev_dax *dev_dax)
 {
 	return is_static(dev_dax->region);
@@ -300,14 +432,25 @@ static struct device_attribute dev_attr_region_align =
 
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
@@ -448,15 +591,26 @@ EXPORT_SYMBOL_GPL(kill_dev_dax);
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
@@ -640,11 +794,14 @@ static void dax_region_unregister(void *region)
 
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
@@ -669,6 +826,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 	dax_region->align = align;
 	dax_region->dev = parent;
 	dax_region->target_node = target_node;
+	dax_region->dc_ops = dc_ops;
 	ida_init(&dax_region->ida);
 	dax_region->res = (struct resource) {
 		.start = range->start,
@@ -857,7 +1015,7 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
 }
 
 static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
-		resource_size_t size)
+		resource_size_t size, struct dax_resource *dax_resource)
 {
 	struct dax_region *dax_region = dev_dax->region;
 	struct resource *res = &dax_region->res;
@@ -898,6 +1056,7 @@ static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
 			.start = alloc->start,
 			.end = alloc->end,
 		},
+		.dax_resource = dax_resource,
 	};
 
 	dev_dbg(dev, "alloc range[%d]: %pa:%pa\n", dev_dax->nr_range - 1,
@@ -1071,7 +1230,7 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
 retry:
 	first = region_res->child;
 	if (!first)
-		return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc);
+		return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc, NULL);
 
 	rc = -ENOSPC;
 	for (res = first; res; res = res->sibling) {
@@ -1080,7 +1239,7 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
 		/* space at the beginning of the region */
 		if (res == first && res->start > dax_region->res.start) {
 			alloc = min(res->start - dax_region->res.start, to_alloc);
-			rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, alloc);
+			rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, alloc, NULL);
 			break;
 		}
 
@@ -1100,7 +1259,7 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
 			rc = adjust_dev_dax_range(dev_dax, res, resource_size(res) + alloc);
 			break;
 		}
-		rc = alloc_dev_dax_range(dev_dax, res->end + 1, alloc);
+		rc = alloc_dev_dax_range(dev_dax, res->end + 1, alloc, NULL);
 		break;
 	}
 	if (rc)
@@ -1210,7 +1369,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 
 	to_alloc = range_len(&r);
 	if (alloc_is_aligned(dev_dax, to_alloc))
-		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
+		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc, NULL);
 	up_write(&dax_dev_rwsem);
 	up_write(&dax_region_rwsem);
 
@@ -1498,7 +1657,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
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
index cedd974c2d0c..5d33be342d42 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -5,6 +5,74 @@
 
 #include "../cxl/cxl.h"
 #include "bus.h"
+#include "dax-private.h"
+
+static int cxl_dax_group_add(struct dax_region *dax_region,
+			     struct cxl_dc_tag_group *group)
+{
+	struct dax_resource_spec *specs;
+	struct dc_extent *dc_extent;
+	unsigned long index;
+	unsigned int n = 0;
+	int rc;
+
+	if (!group->nr_extents)
+		return 0;
+
+	specs = kmalloc_array(group->nr_extents, sizeof(*specs), GFP_KERNEL);
+	if (!specs)
+		return -ENOMEM;
+
+	xa_for_each(&group->dc_extents, index, dc_extent) {
+		if (n == group->nr_extents)
+			break;
+		specs[n++] = (struct dax_resource_spec) {
+			.device = &dc_extent->dev,
+			.start = dax_region->res.start + dc_extent->hpa_range.start,
+			.length = range_len(&dc_extent->hpa_range),
+			.seq_num = dc_extent->seq_num,
+		};
+	}
+
+	/* Atomic all-or-none add, mirroring cxl_dax_group_rm(). */
+	rc = dax_region_add_resources(dax_region, specs, n, &group->uuid);
+	kfree(specs);
+	return rc;
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
@@ -25,7 +93,7 @@ static int cxl_dax_region_probe(struct device *dev)
 		flags = IORESOURCE_DAX_KMEM;
 
 	dax_region = alloc_dax_region(dev, cxlr->id, &cxlr_dax->hpa_range, nid,
-				      PMD_SIZE, flags);
+				      PMD_SIZE, flags, &dc_ops);
 	if (!dax_region)
 		return -ENOMEM;
 
@@ -48,6 +116,7 @@ static int cxl_dax_region_probe(struct device *dev)
 static struct cxl_driver cxl_dax_region_driver = {
 	.name = "cxl_dax_region",
 	.probe = cxl_dax_region_probe,
+	.notify = cxl_dax_region_notify,
 	.id = CXL_DEVICE_DAX_REGION,
 	.drv = {
 		.suppress_bind_attrs = true,
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 81e4af49e39c..8d98fc9adb4b 100644
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
@@ -106,6 +119,52 @@ struct dev_dax {
  */
 void run_dax(struct dax_device *dax_dev);
 
+/**
+ * struct dax_resource - For DC DAX regions; an active resource
+ * @region: dax_region this resources is in
+ * @res: resource
+ * @uuid: tag identifying the backing extent; zero uuid means untagged
+ * @seq_num: dense 0..n-1 assembly-order index within the tag group.  The
+ *	     cxl layer assigns it in assembly order — the device-stamped
+ *	     0..n-1 shared_extn_seq (CXL r4.0 Table 8-230) for a sharable
+ *	     partition, or event arrival order otherwise — so the dax layer
+ *	     can rely on a single 0..n-1 dense invariant when it claims a
+ *	     tagged group in uuid_store().
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
+/* One resource to add as part of an atomic dax_region_add_resources() set. */
+struct dax_resource_spec {
+	struct device *device;
+	resource_size_t start;
+	resource_size_t length;
+	u16 seq_num;
+};
+int dax_region_add_resources(struct dax_region *dax_region,
+			     const struct dax_resource_spec *specs,
+			     unsigned int n, const uuid_t *tag);
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

