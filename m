Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6767387345
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529435; cv=none; b=UJ0CrNTTCgSaSO4B5eIS5Y96OdEQTTLTNh+1xNSoQE+PHdBsr9g0aHwTYfj4+/MNIUvsa38QOupwvluNlKLOvRqsRo5QkAe4VU+TiOaugInYgfBlD+OJx1YQ7rUnrobHvFoytZ79EeEGnXIB13UKrhd4Xbpe6kJ6yC8WmZyBvlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529435; c=relaxed/simple;
	bh=bnNosoa4wdcuqFo/b0ROOHywKfUx7eAMgCsyxmkMAUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbawER5JL3AW7wTamU1jM4mxh9g1GVNQgvb5XwfKcrGhkHQTsbeRtiEykuH7fTT9wLJkUF4bMh6BIE+Hg4N/AXXVZUtcXLK6//wWxYEuX8EXdF1Q4kf/ikOaPl2P6ARJLWGuJknAIOiuynPzTdaiecR9GrYlZejFoS15S0N2UEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mgc3pFG1; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mgc3pFG1"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-134ac81c445so10218484c88.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529429; x=1780134229; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j6DG2kcCXKCP6QJoWNPoCD9fZeNb6P0SZLPXjdbQtmw=;
        b=mgc3pFG1nBU2uMrs4yZyjbQpQwy6LnBQ0Qia+4Hp3D/U4E5TQggYJPWqwhclelGCWL
         a0xZimUTwHKFTKAef6G4m9FrbOQO8Qkf9kcXERMBkhafdqQEMf5iCHW2H99294Sr+QDP
         lLdiFOBOMu1+W0V6aozMok2KILtmI99hhQ+psBnkg92NiamRIl8zg/KOmBHznF6zr4jl
         Gh/mUL10uvDp9s6BXm/OB5LSX5hYPVrd2CnOQ2GgibYcXJX3ehJzCRjRl/fDD23lL4so
         8UTF1haHcHY7TVwyj2I6h37Ga30+SeYaE7dn4lIcp3VrVosx0tJq26LNLBW/3zOkeDsx
         WPgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529429; x=1780134229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j6DG2kcCXKCP6QJoWNPoCD9fZeNb6P0SZLPXjdbQtmw=;
        b=J6GGBUu2MQbnB7+oiikE19PIcuVI7BmglAWDOtu9kUrTimSkr7Bmbou7rHXPt/f/Ui
         IufUY5UPUIq+dImhDrovmAnhBtSvkxMjKajULFVOXKNrw9oqjBJ23LlheyiWCaOvyCKX
         GbAbsuqGG9wxBt2Y4bLuiXFcgOunhiyUzfX6v4H8m4A1p5IkFjF/4ljY69JMTfPCMAjz
         f0g89PdlK8NPF5lIqh+CjB0/7Aeq5Rdc4Lhf+TvU78FplZFDohy+ilj83yd0uUWxJcqf
         Qpv4bBss+4lrCqew/SSBq5nm2BOwkFKIqwZzQ4VyfcSeugpegJUuHiRDmxt+ffje3lBP
         KdRw==
X-Gm-Message-State: AOJu0YwWRVz1TfqBUoFKAV3DSSH1VlJSndhsFgA8U+qQJkk1N88fd04x
	l++vcwkW0StcKakolde5jPecOsnBQoiJS7elOsxXcA1oUZgpdvZon+tM
X-Gm-Gg: Acq92OFDOtHWSVCKzIoE0F4WbvgVl3eh5pz6TVUAXncbltNnY1AcNp7pd3ORF0XKfK/
	2GoYAsKRLDtFcSAkM5VQn2uSojoNglCxMV/Szh6TWLgR8tZO3FGS+1qbmPHn6kfR9udGZWxphQy
	WMFpqobt40/a328bJXuxgL3pUgWhb+3JLYoU+/HdiUkXIOH6ODWT9atS425xjq6gMxhOReuQRzJ
	87ADEW+WE5anpFhKkw7sxV4UlQczrKTPsMHiu7z5NEqEDbeQpTM1rr+zaF82ThKJBgiT5IhYkPl
	BrTNNQDd6gRDG7Awd16Quekp2wkxUeE+qqPFbfyE7CB/fJ4p5v9lhBLYITiCiLGui4QF5OL0hkp
	IBGd27ZLQjVoRuJKw9SmR9wA8XkkC/4ejvaCU2EwZXTF97zbbKOh04MAR5rgw37T4yku0Rpq30q
	4pARixyhpzx3YFwAmRygIQhDgog9sGPkedhFeHLmpO+A0J9kjsEOJ0Z4kAgXptWN39FcLOqVd/W
	2gQ1fs=
X-Received: by 2002:a05:7022:61b:b0:12d:b205:c737 with SMTP id a92af1059eb24-1365f91bdb4mr2813147c88.17.1779529428944;
        Sat, 23 May 2026 02:43:48 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:43:48 -0700 (PDT)
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
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v10 07/31] cxl/region: Add DC DAX region support
Date: Sat, 23 May 2026 02:43:01 -0700
Message-ID: <9f0e0b3deeb1825ad113d7aebe7056dcf2bbc5f9.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

DC DAX regions must allow memory to be added or removed dynamically.
In addition to the quantity of memory available the,
location of the memory within a DC partition is dynamic, based on the
extents offered by a device.  CXL DAX regions must accommodate the
dynamic movement of this memory in the management of DAX regions and devices.

Introduce the concept of a dynamic DAX region. Introduce
create_dynamic_ram_a_region() sysfs entry to create such regions.
Special case DC-capable regions to create a 0 sized seed DAX device
to maintain compatibility which requires a default DAX device to hold a
region reference.

Indicate 0 byte available capacity until such time that capacity is
added.

Dynamic regions complicate the range mapping of dax devices.  There is no
known use case for range mapping on dynamic regions.  Avoid the
complication by preventing range mapping of dax devices on dynamic
regions.

Interleaving is deferred for now.  Add checks.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[anisa: rebase]
[anisa: change "sparse" naming conventions and to "dynamic"]
---
 Documentation/ABI/testing/sysfs-bus-cxl | 22 ++++++++---------
 drivers/cxl/core/core.h                 | 11 +++++++++
 drivers/cxl/core/port.c                 |  1 +
 drivers/cxl/core/region.c               | 33 +++++++++++++++++++++++--
 drivers/cxl/core/region_dax.c           |  6 +++++
 drivers/dax/bus.c                       | 10 ++++++++
 drivers/dax/bus.h                       |  1 +
 drivers/dax/cxl.c                       | 17 +++++++++++--
 8 files changed, 86 insertions(+), 15 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index c604c7ca6432..3080aef9ad67 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -434,20 +434,20 @@ Description:
 		interleave_granularity).
 
 
-What:		/sys/bus/cxl/devices/decoderX.Y/create_{pmem,ram}_region
-Date:		May, 2022, January, 2023
-KernelVersion:	v6.0 (pmem), v6.3 (ram)
+What:		/sys/bus/cxl/devices/decoderX.Y/create_{pmem,ram,dynamic_ram_a}_region
+Date:		May, 2022, January, 2023, May 2025
+KernelVersion:	v6.0 (pmem), v6.3 (ram), v6.16 (dynamic_ram_a)
 Contact:	linux-cxl@vger.kernel.org
 Description:
 		(RW) Write a string in the form 'regionZ' to start the process
-		of defining a new persistent, or volatile memory region
-		(interleave-set) within the decode range bounded by root decoder
-		'decoderX.Y'. The value written must match the current value
-		returned from reading this attribute. An atomic compare exchange
-		operation is done on write to assign the requested id to a
-		region and allocate the region-id for the next creation attempt.
-		EBUSY is returned if the region name written does not match the
-		current cached value.
+		of defining a new persistent, volatile, or dynamic RAM memory
+		region (interleave-set) within the decode range bounded by root
+		decoder 'decoderX.Y'. The value written must match the current
+		value returned from reading this attribute.  An atomic compare
+		exchange operation is done on write to assign the requested id
+		to a region and allocate the region-id for the next creation
+		attempt.  EBUSY is returned if the region name written does not
+		match the current cached value.
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/delete_region
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 82ca3a476708..8881cc9323e0 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -6,6 +6,7 @@
 
 #include <cxl/mailbox.h>
 #include <linux/rwsem.h>
+#include <cxlmem.h>
 
 extern const struct device_type cxl_nvdimm_bridge_type;
 extern const struct device_type cxl_nvdimm_type;
@@ -18,6 +19,15 @@ enum cxl_detach_mode {
 	DETACH_INVALIDATE,
 };
 
+static inline struct cxl_memdev_state *
+cxled_to_mds(struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+
+	return container_of(cxlds, struct cxl_memdev_state, cxlds);
+}
+
 #ifdef CONFIG_CXL_REGION
 
 struct cxl_region_context {
@@ -29,6 +39,7 @@ struct cxl_region_context {
 
 extern struct device_attribute dev_attr_create_pmem_region;
 extern struct device_attribute dev_attr_create_ram_region;
+extern struct device_attribute dev_attr_create_dynamic_ram_a_region;
 extern struct device_attribute dev_attr_delete_region;
 extern struct device_attribute dev_attr_region;
 extern const struct device_type cxl_pmem_region_type;
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index a7f71f36531f..2d33001dac26 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -337,6 +337,7 @@ static struct attribute *cxl_decoder_root_attrs[] = {
 	&dev_attr_qos_class.attr,
 	SET_CXL_REGION_ATTR(create_pmem_region)
 	SET_CXL_REGION_ATTR(create_ram_region)
+	SET_CXL_REGION_ATTR(create_dynamic_ram_a_region)
 	SET_CXL_REGION_ATTR(delete_region)
 	NULL,
 };
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index edc267c6cf77..7561bf3d8af8 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -493,6 +493,11 @@ static int set_interleave_ways(struct cxl_region *cxlr, int val)
 	int save, rc;
 	u8 iw;
 
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A && val != 1) {
+		dev_err(&cxlr->dev, "Interleaving and DCD not supported\n");
+		return -EINVAL;
+	}
+
 	rc = ways_to_eiw(val, &iw);
 	if (rc)
 		return rc;
@@ -2389,6 +2394,7 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
 	if (sysfs_streq(buf, "\n"))
 		rc = detach_target(cxlr, pos);
 	else {
+		struct cxl_endpoint_decoder *cxled;
 		struct device *dev;
 
 		dev = bus_find_device_by_name(&cxl_bus_type, NULL, buf);
@@ -2400,8 +2406,14 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
 			goto out;
 		}
 
-		rc = attach_target(cxlr, to_cxl_endpoint_decoder(dev), pos,
-				   TASK_INTERRUPTIBLE);
+		cxled = to_cxl_endpoint_decoder(dev);
+		if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A &&
+		    !cxl_dcd_supported(cxled_to_mds(cxled))) {
+			dev_dbg(dev, "DCD unsupported\n");
+			rc = -EINVAL;
+			goto out;
+		}
+		rc = attach_target(cxlr, cxled, pos, TASK_INTERRUPTIBLE);
 out:
 		put_device(dev);
 	}
@@ -2750,6 +2762,7 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 	switch (mode) {
 	case CXL_PARTMODE_RAM:
 	case CXL_PARTMODE_PMEM:
+	case CXL_PARTMODE_DYNAMIC_RAM_A:
 		break;
 	default:
 		dev_err(&cxlrd->cxlsd.cxld.dev, "unsupported mode %d\n", mode);
@@ -2802,6 +2815,21 @@ static ssize_t create_ram_region_store(struct device *dev,
 }
 DEVICE_ATTR_RW(create_ram_region);
 
+static ssize_t create_dynamic_ram_a_region_show(struct device *dev,
+						struct device_attribute *attr,
+						char *buf)
+{
+	return __create_region_show(to_cxl_root_decoder(dev), buf);
+}
+
+static ssize_t create_dynamic_ram_a_region_store(struct device *dev,
+						 struct device_attribute *attr,
+						 const char *buf, size_t len)
+{
+	return create_region_store(dev, buf, len, CXL_PARTMODE_DYNAMIC_RAM_A);
+}
+DEVICE_ATTR_RW(create_dynamic_ram_a_region);
+
 static ssize_t region_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
@@ -4081,6 +4109,7 @@ static int cxl_region_probe(struct device *dev)
 
 		return devm_cxl_add_pmem_region(cxlr);
 	case CXL_PARTMODE_RAM:
+	case CXL_PARTMODE_DYNAMIC_RAM_A:
 		rc = devm_cxl_region_edac_register(cxlr);
 		if (rc)
 			dev_dbg(&cxlr->dev, "CXL EDAC registration for region_id=%d failed\n",
diff --git a/drivers/cxl/core/region_dax.c b/drivers/cxl/core/region_dax.c
index de04f78f6ad8..d6bf69155827 100644
--- a/drivers/cxl/core/region_dax.c
+++ b/drivers/cxl/core/region_dax.c
@@ -84,6 +84,12 @@ int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 	struct device *dev;
 	int rc;
 
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A &&
+	    cxlr->params.interleave_ways != 1) {
+		dev_err(&cxlr->dev, "Interleaving DC not supported\n");
+		return -EINVAL;
+	}
+
 	struct cxl_dax_region *cxlr_dax __free(put_cxl_dax_region) =
 		cxl_dax_region_alloc(cxlr);
 	if (IS_ERR(cxlr_dax))
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 95aee2a037fb..b0c2162b5e37 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -181,6 +181,11 @@ static bool is_static(struct dax_region *dax_region)
 	return (dax_region->res.flags & IORESOURCE_DAX_STATIC) != 0;
 }
 
+static bool is_dynamic(struct dax_region *dax_region)
+{
+	return (dax_region->res.flags & IORESOURCE_DAX_DCD) != 0;
+}
+
 bool static_dev_dax(struct dev_dax *dev_dax)
 {
 	return is_static(dev_dax->region);
@@ -304,6 +309,9 @@ static unsigned long long dax_region_avail_size(struct dax_region *dax_region)
 
 	lockdep_assert_held(&dax_region_rwsem);
 
+	if (is_dynamic(dax_region))
+		return 0;
+
 	for_each_dax_region_resource(dax_region, res)
 		size -= resource_size(res);
 	return size;
@@ -1389,6 +1397,8 @@ static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 		return 0;
 	if (a == &dev_attr_mapping.attr && is_static(dax_region))
 		return 0;
+	if (a == &dev_attr_mapping.attr && is_dynamic(dax_region))
+		return 0;
 	if ((a == &dev_attr_align.attr ||
 	     a == &dev_attr_size.attr) && is_static(dax_region))
 		return 0444;
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 5909171a4428..6e739bfab932 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -15,6 +15,7 @@ struct dax_region;
 /* dax bus specific ioresource flags */
 #define IORESOURCE_DAX_STATIC BIT(0)
 #define IORESOURCE_DAX_KMEM BIT(1)
+#define IORESOURCE_DAX_DCD BIT(2)
 
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct range *range, int target_node, unsigned int align,
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 3ab39b77843d..f58fe992aa8d 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -13,19 +13,32 @@ static int cxl_dax_region_probe(struct device *dev)
 	struct cxl_region *cxlr = cxlr_dax->cxlr;
 	struct dax_region *dax_region;
 	struct dev_dax_data data;
+	resource_size_t dev_size;
+	unsigned long flags;
 
 	if (nid == NUMA_NO_NODE)
 		nid = memory_add_physaddr_to_nid(cxlr_dax->hpa_range.start);
 
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A)
+		flags = IORESOURCE_DAX_DCD;
+	else
+		flags = IORESOURCE_DAX_KMEM;
+
 	dax_region = alloc_dax_region(dev, cxlr->id, &cxlr_dax->hpa_range, nid,
-				      PMD_SIZE, IORESOURCE_DAX_KMEM);
+				      PMD_SIZE, flags);
 	if (!dax_region)
 		return -ENOMEM;
 
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A)
+		/* Add empty seed dax device */
+		dev_size = 0;
+	else
+		dev_size = range_len(&cxlr_dax->hpa_range);
+
 	data = (struct dev_dax_data) {
 		.dax_region = dax_region,
 		.id = -1,
-		.size = range_len(&cxlr_dax->hpa_range),
+		.size = dev_size,
 		.memmap_on_memory = true,
 	};
 
-- 
2.43.0

