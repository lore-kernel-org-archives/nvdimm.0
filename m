Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F2D3816F4
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167913; cv=none; b=pEkzt1zMiMrwXNdzXRvDRfilYF83QxGQ4KNlr6gMtLH4SJMpTkWCAvRD3NmvNmPCOfLt3T7vriqWvsHUbESFQMwi0tGeez/jR+9+ri2LeWIsfPIF5jlXxwJTDylUIz7tbiWYudPYqqqcPZTxN/ApTjBqb/t6zaoz7pEttAd1fmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167913; c=relaxed/simple;
	bh=5tAtMy4WfvhEstME0Y+aQ2zHX5jFXZ6f7SDfuW8BbLg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=e7UAI6aylpLrR2GFIe1uzPH8nCGVx9ltl2D5vB0UG9DJo/p9AmEQ+sQPH/lNXFH0GXueHOwxAxHyR0dVvjbuiF8vuKfkGx/ZhxkFEeuNQrkdStHB+sjR83OOlS04oTfYtsoy/t7GcebEHpkcs5yLehLDzjZYnNBjPKOW7JpNUlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bosZZADq; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bosZZADq"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123113147epoutp02a45089533b0873bd7c435cbcc75b6768~NWNa7ojgF0069300693epoutp02k
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123113147epoutp02a45089533b0873bd7c435cbcc75b6768~NWNa7ojgF0069300693epoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167907;
	bh=x3MHNOcogxwkLb4okjjYI9s7EwXA49nWVIp97O0VH3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bosZZADqVV4EGQu5vQDchSjVAdt+xyqlh/id5X2OXYxFsKSHaqb9vJliZkiK3Pjr6
	 lLqRWE0o85OC57/ttM0S6Ia5Cgj2thHUxtJZI/JQGqvDfQPHMzaGsVc72CrdY5fwYt
	 q25jzTPW11sZJImxOe/j2z/xoc+UZT20xCZnctlk=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260123113147epcas5p131ff346215f8925b2aa0c81a53b3cee0~NWNasnvCz0962609626epcas5p1H;
	Fri, 23 Jan 2026 11:31:47 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.92]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dyG3j0w4lz6B9mB; Fri, 23 Jan
	2026 11:31:45 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260123113144epcas5p18477c68ede07c17a6c8461cf034eb3d1~NWNX90uV40266802668epcas5p1r;
	Fri, 23 Jan 2026 11:31:44 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113143epsmtip2b0cdf0fc901eb6c7757ec22782273dd6~NWNWyfCit2685626856epsmtip2W;
	Fri, 23 Jan 2026 11:31:43 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 14/18] cxl/pmem_region: Prep patch to accommodate
 pmem_region attributes
Date: Fri, 23 Jan 2026 17:01:08 +0530
Message-Id: <20260123113112.3488381-15-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113144epcas5p18477c68ede07c17a6c8461cf034eb3d1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113144epcas5p18477c68ede07c17a6c8461cf034eb3d1
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113144epcas5p18477c68ede07c17a6c8461cf034eb3d1@epcas5p1.samsung.com>

For region label update, need to create device attribute, which calls
nvdimm exported routine thus making pmem_region dependent on libnvdimm.
Because of this dependency of pmem region on libnvdimm, segregate pmem
region related code from core/region.c to core/pmem_region.c

This patch has no functionality change. Its just code movement from
core/region.c to core/pmem_region.c

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/Makefile      |   2 +-
 drivers/cxl/core/core.h        |  10 ++
 drivers/cxl/core/pmem_region.c | 201 +++++++++++++++++++++++++++++++++
 drivers/cxl/core/region.c      | 188 +-----------------------------
 tools/testing/cxl/Kbuild       |   2 +-
 5 files changed, 214 insertions(+), 189 deletions(-)
 create mode 100644 drivers/cxl/core/pmem_region.c

diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index 5ad8fef210b5..fe0fcab6d730 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -16,7 +16,7 @@ cxl_core-y += pmu.o
 cxl_core-y += cdat.o
 cxl_core-y += ras.o
 cxl_core-$(CONFIG_TRACING) += trace.o
-cxl_core-$(CONFIG_CXL_REGION) += region.o
+cxl_core-$(CONFIG_CXL_REGION) += region.o pmem_region.o
 cxl_core-$(CONFIG_CXL_MCE) += mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += features.o
 cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += edac.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 268f6d19ab9d..4eed243c0d7d 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -46,6 +46,8 @@ struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
 				     enum cxl_partition_mode mode, int id,
 				     struct cxl_pmem_region_params *pmem_params,
 				     struct cxl_endpoint_decoder *cxled);
+struct cxl_region *to_cxl_region(struct device *dev);
+int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
@@ -83,6 +85,14 @@ cxl_create_region(struct cxl_root_decoder *cxlrd,
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
+static inline struct cxl_region *to_cxl_region(struct device *dev)
+{
+	return NULL;
+}
+static inline int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
+{
+	return 0;
+}
 #define CXL_REGION_ATTR(x) NULL
 #define CXL_REGION_TYPE(x) NULL
 #define SET_CXL_REGION_ATTR(x)
diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
new file mode 100644
index 000000000000..dcaab59108fd
--- /dev/null
+++ b/drivers/cxl/core/pmem_region.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2020 Intel Corporation. */
+#include <linux/device.h>
+#include <linux/memregion.h>
+#include <cxlmem.h>
+#include <cxl.h>
+#include "core.h"
+
+/**
+ * DOC: cxl pmem region
+ *
+ * The core CXL PMEM region infrastructure supports persistent memory
+ * region creation using LIBNVDIMM subsystem. It has dependency on
+ * LIBNVDIMM, pmem region needs to update the cxl region information
+ * in the LSA.
+ */
+
+static void cxl_pmem_region_release(struct device *dev)
+{
+	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
+	int i;
+
+	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
+		struct cxl_memdev *cxlmd = cxlr_pmem->mapping[i].cxlmd;
+
+		put_device(&cxlmd->dev);
+	}
+
+	kfree(cxlr_pmem);
+}
+
+static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
+	&cxl_base_attribute_group,
+	NULL
+};
+
+const struct device_type cxl_pmem_region_type = {
+	.name = "cxl_pmem_region",
+	.release = cxl_pmem_region_release,
+	.groups = cxl_pmem_region_attribute_groups,
+};
+
+bool is_cxl_pmem_region(struct device *dev)
+{
+	return dev->type == &cxl_pmem_region_type;
+}
+EXPORT_SYMBOL_NS_GPL(is_cxl_pmem_region, "CXL");
+
+struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
+{
+	if (dev_WARN_ONCE(dev, !is_cxl_pmem_region(dev),
+			  "not a cxl_pmem_region device\n"))
+		return NULL;
+	return container_of(dev, struct cxl_pmem_region, dev);
+}
+EXPORT_SYMBOL_NS_GPL(to_cxl_pmem_region, "CXL");
+
+static struct lock_class_key cxl_pmem_region_key;
+
+static int cxl_pmem_region_alloc(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	struct cxl_nvdimm_bridge *cxl_nvb;
+	struct device *dev;
+	int i;
+
+	guard(rwsem_read)(&cxl_rwsem.region);
+	if (p->state != CXL_CONFIG_COMMIT)
+		return -ENXIO;
+
+	struct cxl_pmem_region *cxlr_pmem __free(kfree) =
+		kzalloc(struct_size(cxlr_pmem, mapping, p->nr_targets),
+			GFP_KERNEL);
+	if (!cxlr_pmem)
+		return -ENOMEM;
+
+	cxlr_pmem->hpa_range.start = p->res->start;
+	cxlr_pmem->hpa_range.end = p->res->end;
+
+	/* Snapshot the region configuration underneath the cxl_region_rwsem */
+	cxlr_pmem->nr_mappings = p->nr_targets;
+	for (i = 0; i < p->nr_targets; i++) {
+		struct cxl_endpoint_decoder *cxled = p->targets[i];
+		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
+
+		/*
+		 * Regions never span CXL root devices, so by definition the
+		 * bridge for one device is the same for all.
+		 */
+		if (i == 0) {
+			cxl_nvb = cxl_find_nvdimm_bridge(cxlmd->endpoint);
+			if (!cxl_nvb)
+				return -ENODEV;
+			cxlr->cxl_nvb = cxl_nvb;
+		}
+		m->cxlmd = cxlmd;
+		get_device(&cxlmd->dev);
+		m->start = cxled->dpa_res->start;
+		m->size = resource_size(cxled->dpa_res);
+		m->position = i;
+	}
+
+	dev = &cxlr_pmem->dev;
+	device_initialize(dev);
+	lockdep_set_class(&dev->mutex, &cxl_pmem_region_key);
+	device_set_pm_not_required(dev);
+	dev->parent = &cxlr->dev;
+	dev->bus = &cxl_bus_type;
+	dev->type = &cxl_pmem_region_type;
+	cxlr_pmem->cxlr = cxlr;
+	cxlr->cxlr_pmem = no_free_ptr(cxlr_pmem);
+
+	return 0;
+}
+
+static void cxlr_pmem_unregister(void *_cxlr_pmem)
+{
+	struct cxl_pmem_region *cxlr_pmem = _cxlr_pmem;
+	struct cxl_region *cxlr = cxlr_pmem->cxlr;
+	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
+
+	/*
+	 * Either the bridge is in ->remove() context under the device_lock(),
+	 * or cxlr_release_nvdimm() is cancelling the bridge's release action
+	 * for @cxlr_pmem and doing it itself (while manually holding the bridge
+	 * lock).
+	 */
+	device_lock_assert(&cxl_nvb->dev);
+	cxlr->cxlr_pmem = NULL;
+	cxlr_pmem->cxlr = NULL;
+	device_unregister(&cxlr_pmem->dev);
+}
+
+static void cxlr_release_nvdimm(void *_cxlr)
+{
+	struct cxl_region *cxlr = _cxlr;
+	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
+
+	scoped_guard(device, &cxl_nvb->dev) {
+		if (cxlr->cxlr_pmem)
+			devm_release_action(&cxl_nvb->dev, cxlr_pmem_unregister,
+					    cxlr->cxlr_pmem);
+	}
+	cxlr->cxl_nvb = NULL;
+	put_device(&cxl_nvb->dev);
+}
+
+/**
+ * devm_cxl_add_pmem_region() - add a cxl_region-to-nd_region bridge
+ * @cxlr: parent CXL region for this pmem region bridge device
+ *
+ * Return: 0 on success negative error code on failure.
+ */
+int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
+{
+	struct cxl_pmem_region *cxlr_pmem;
+	struct cxl_nvdimm_bridge *cxl_nvb;
+	struct device *dev;
+	int rc;
+
+	rc = cxl_pmem_region_alloc(cxlr);
+	if (rc)
+		return rc;
+	cxlr_pmem = cxlr->cxlr_pmem;
+	cxl_nvb = cxlr->cxl_nvb;
+
+	dev = &cxlr_pmem->dev;
+	rc = dev_set_name(dev, "pmem_region%d", cxlr->id);
+	if (rc)
+		goto err;
+
+	rc = device_add(dev);
+	if (rc)
+		goto err;
+
+	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
+		dev_name(dev));
+
+	scoped_guard(device, &cxl_nvb->dev) {
+		if (cxl_nvb->dev.driver)
+			rc = devm_add_action_or_reset(&cxl_nvb->dev,
+						      cxlr_pmem_unregister,
+						      cxlr_pmem);
+		else
+			rc = -ENXIO;
+	}
+
+	if (rc)
+		goto err_bridge;
+
+	/* @cxlr carries a reference on @cxl_nvb until cxlr_release_nvdimm */
+	return devm_add_action_or_reset(&cxlr->dev, cxlr_release_nvdimm, cxlr);
+
+err:
+	put_device(dev);
+err_bridge:
+	put_device(&cxl_nvb->dev);
+	cxlr->cxl_nvb = NULL;
+	return rc;
+}
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index e384eacc46ae..f9b3dd6cee50 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -38,8 +38,6 @@
  */
 static nodemask_t nodemask_region_seen = NODE_MASK_NONE;
 
-static struct cxl_region *to_cxl_region(struct device *dev);
-
 #define __ACCESS_ATTR_RO(_level, _name) {				\
 	.attr	= { .name = __stringify(_name), .mode = 0444 },		\
 	.show	= _name##_access##_level##_show,			\
@@ -2429,7 +2427,7 @@ bool is_cxl_region(struct device *dev)
 }
 EXPORT_SYMBOL_NS_GPL(is_cxl_region, "CXL");
 
-static struct cxl_region *to_cxl_region(struct device *dev)
+struct cxl_region *to_cxl_region(struct device *dev)
 {
 	if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
 			  "not a cxl_region device\n"))
@@ -2866,46 +2864,6 @@ static ssize_t delete_region_store(struct device *dev,
 }
 DEVICE_ATTR_WO(delete_region);
 
-static void cxl_pmem_region_release(struct device *dev)
-{
-	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
-	int i;
-
-	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
-		struct cxl_memdev *cxlmd = cxlr_pmem->mapping[i].cxlmd;
-
-		put_device(&cxlmd->dev);
-	}
-
-	kfree(cxlr_pmem);
-}
-
-static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
-	&cxl_base_attribute_group,
-	NULL,
-};
-
-const struct device_type cxl_pmem_region_type = {
-	.name = "cxl_pmem_region",
-	.release = cxl_pmem_region_release,
-	.groups = cxl_pmem_region_attribute_groups,
-};
-
-bool is_cxl_pmem_region(struct device *dev)
-{
-	return dev->type == &cxl_pmem_region_type;
-}
-EXPORT_SYMBOL_NS_GPL(is_cxl_pmem_region, "CXL");
-
-struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
-{
-	if (dev_WARN_ONCE(dev, !is_cxl_pmem_region(dev),
-			  "not a cxl_pmem_region device\n"))
-		return NULL;
-	return container_of(dev, struct cxl_pmem_region, dev);
-}
-EXPORT_SYMBOL_NS_GPL(to_cxl_pmem_region, "CXL");
-
 struct cxl_poison_context {
 	struct cxl_port *port;
 	int part;
@@ -3337,64 +3295,6 @@ static int region_offset_to_dpa_result(struct cxl_region *cxlr, u64 offset,
 	return -ENXIO;
 }
 
-static struct lock_class_key cxl_pmem_region_key;
-
-static int cxl_pmem_region_alloc(struct cxl_region *cxlr)
-{
-	struct cxl_region_params *p = &cxlr->params;
-	struct cxl_nvdimm_bridge *cxl_nvb;
-	struct device *dev;
-	int i;
-
-	guard(rwsem_read)(&cxl_rwsem.region);
-	if (p->state != CXL_CONFIG_COMMIT)
-		return -ENXIO;
-
-	struct cxl_pmem_region *cxlr_pmem __free(kfree) =
-		kzalloc(struct_size(cxlr_pmem, mapping, p->nr_targets), GFP_KERNEL);
-	if (!cxlr_pmem)
-		return -ENOMEM;
-
-	cxlr_pmem->hpa_range.start = p->res->start;
-	cxlr_pmem->hpa_range.end = p->res->end;
-
-	/* Snapshot the region configuration underneath the cxl_rwsem.region */
-	cxlr_pmem->nr_mappings = p->nr_targets;
-	for (i = 0; i < p->nr_targets; i++) {
-		struct cxl_endpoint_decoder *cxled = p->targets[i];
-		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
-		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
-
-		/*
-		 * Regions never span CXL root devices, so by definition the
-		 * bridge for one device is the same for all.
-		 */
-		if (i == 0) {
-			cxl_nvb = cxl_find_nvdimm_bridge(cxlmd->endpoint);
-			if (!cxl_nvb)
-				return -ENODEV;
-			cxlr->cxl_nvb = cxl_nvb;
-		}
-		m->cxlmd = cxlmd;
-		get_device(&cxlmd->dev);
-		m->start = cxled->dpa_res->start;
-		m->size = resource_size(cxled->dpa_res);
-		m->position = i;
-	}
-
-	dev = &cxlr_pmem->dev;
-	device_initialize(dev);
-	lockdep_set_class(&dev->mutex, &cxl_pmem_region_key);
-	device_set_pm_not_required(dev);
-	dev->parent = &cxlr->dev;
-	dev->bus = &cxl_bus_type;
-	dev->type = &cxl_pmem_region_type;
-	cxlr_pmem->cxlr = cxlr;
-	cxlr->cxlr_pmem = no_free_ptr(cxlr_pmem);
-
-	return 0;
-}
-
 static void cxl_dax_region_release(struct device *dev)
 {
 	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
@@ -3458,92 +3358,6 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
 	return cxlr_dax;
 }
 
-static void cxlr_pmem_unregister(void *_cxlr_pmem)
-{
-	struct cxl_pmem_region *cxlr_pmem = _cxlr_pmem;
-	struct cxl_region *cxlr = cxlr_pmem->cxlr;
-	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
-
-	/*
-	 * Either the bridge is in ->remove() context under the device_lock(),
-	 * or cxlr_release_nvdimm() is cancelling the bridge's release action
-	 * for @cxlr_pmem and doing it itself (while manually holding the bridge
-	 * lock).
-	 */
-	device_lock_assert(&cxl_nvb->dev);
-	cxlr->cxlr_pmem = NULL;
-	cxlr_pmem->cxlr = NULL;
-	device_unregister(&cxlr_pmem->dev);
-}
-
-static void cxlr_release_nvdimm(void *_cxlr)
-{
-	struct cxl_region *cxlr = _cxlr;
-	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
-
-	scoped_guard(device, &cxl_nvb->dev) {
-		if (cxlr->cxlr_pmem)
-			devm_release_action(&cxl_nvb->dev, cxlr_pmem_unregister,
-					    cxlr->cxlr_pmem);
-	}
-	cxlr->cxl_nvb = NULL;
-	put_device(&cxl_nvb->dev);
-}
-
-/**
- * devm_cxl_add_pmem_region() - add a cxl_region-to-nd_region bridge
- * @cxlr: parent CXL region for this pmem region bridge device
- *
- * Return: 0 on success negative error code on failure.
- */
-static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
-{
-	struct cxl_pmem_region *cxlr_pmem;
-	struct cxl_nvdimm_bridge *cxl_nvb;
-	struct device *dev;
-	int rc;
-
-	rc = cxl_pmem_region_alloc(cxlr);
-	if (rc)
-		return rc;
-	cxlr_pmem = cxlr->cxlr_pmem;
-	cxl_nvb = cxlr->cxl_nvb;
-
-	dev = &cxlr_pmem->dev;
-	rc = dev_set_name(dev, "pmem_region%d", cxlr->id);
-	if (rc)
-		goto err;
-
-	rc = device_add(dev);
-	if (rc)
-		goto err;
-
-	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
-		dev_name(dev));
-
-	scoped_guard(device, &cxl_nvb->dev) {
-		if (cxl_nvb->dev.driver)
-			rc = devm_add_action_or_reset(&cxl_nvb->dev,
-						      cxlr_pmem_unregister,
-						      cxlr_pmem);
-		else
-			rc = -ENXIO;
-	}
-
-	if (rc)
-		goto err_bridge;
-
-	/* @cxlr carries a reference on @cxl_nvb until cxlr_release_nvdimm */
-	return devm_add_action_or_reset(&cxlr->dev, cxlr_release_nvdimm, cxlr);
-
-err:
-	put_device(dev);
-err_bridge:
-	put_device(&cxl_nvb->dev);
-	cxlr->cxl_nvb = NULL;
-	return rc;
-}
-
 static void cxlr_dax_unregister(void *_cxlr_dax)
 {
 	struct cxl_dax_region *cxlr_dax = _cxlr_dax;
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 0e151d0572d1..ad2496b38fdd 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -59,7 +59,7 @@ cxl_core-y += $(CXL_CORE_SRC)/pmu.o
 cxl_core-y += $(CXL_CORE_SRC)/cdat.o
 cxl_core-y += $(CXL_CORE_SRC)/ras.o
 cxl_core-$(CONFIG_TRACING) += $(CXL_CORE_SRC)/trace.o
-cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o
+cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o $(CXL_CORE_SRC)/pmem_region.o
 cxl_core-$(CONFIG_CXL_MCE) += $(CXL_CORE_SRC)/mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += $(CXL_CORE_SRC)/features.o
 cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += $(CXL_CORE_SRC)/edac.o
-- 
2.34.1

