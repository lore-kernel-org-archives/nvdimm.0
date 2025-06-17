Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863732E92CB
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165389; cv=none; b=JruyMYnSw2Lc2dGJhIRtrRaFCwkO7m9CIa5iDI1CDhMbPoynvW/vh/JgC9UYPcbSa3HNnlonzJkjw1cYO1Rt6nyixlVjbdY8mHFeBM5GYET4bnG7h3x9EIgRDnN0PF5ySMYW0zO3O/YSKa/k+XjjHz6zd4F7X7e5L816SjpPxWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165389; c=relaxed/simple;
	bh=mIrWpNY3jr87ltBidAAC2kpZd75P6DWpt/u3RX8/Wao=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=j/7KZuZxA2d+jwk7dEyWMtr5ZFphwmISZ3qAunjeBuhvH3W8Z33t61m6mnxIYEuhlsvokWsS48vwBXW9sjuIY9F7fnzY2HjRxy7hyNmN/h7xvqcOnsjqgftXzIvy3IOG6kZ/xtPKpYNlXcYHpfLST92XslykOFjXWaiLKnqSA5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KFj0Ye2a; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KFj0Ye2a"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250617130303epoutp01120c996df03b96f110b261ba4ff4ce2c~J1iTJfIvi0856908569epoutp01L
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:03:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250617130303epoutp01120c996df03b96f110b261ba4ff4ce2c~J1iTJfIvi0856908569epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165383;
	bh=+IghwJFzrfzaFCkHV9t1V3i+zbgCecRs/abfV4Se8Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFj0Ye2aLGyE88yhgZgBS/hikf8p6HMhU44SjtAj5v+ZtyfjxPvMwk7xdMtR+eLvv
	 mt2yxpCZxZ7nf9cuovLfp/hKsEwzNua0Ix15ERxb8tWayVe1uOW6gQ41/aRJv1mErE
	 BQnPTRlEIfiHpeDpZ6Ag96M55U2JOhu4UVbQIX7Q=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250617130303epcas5p1b90e6039c0c394a5641a8295757879d9~J1iSjuuvE2236322363epcas5p1z;
	Tue, 17 Jun 2025 13:03:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bM6Vb0CBvz3hhT4; Tue, 17 Jun
	2025 13:03:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250617124101epcas5p4d54f34ebc5161b7cb816e352d144d9a1~J1PDj3u6R3121831218epcas5p4v;
	Tue, 17 Jun 2025 12:41:01 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617124058epsmtip231eed9f93af987933af1e4b8fea6b9b5~J1PA9svjA2543925439epsmtip2p;
	Tue, 17 Jun 2025 12:40:58 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 19/20] cxl/pmem_region: Prep patch to accommodate
 pmem_region attributes
Date: Tue, 17 Jun 2025 18:09:43 +0530
Message-Id: <1997287019.101750165383025.JavaMail.epsvc@epcpadp2new>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617123944.78345-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617124101epcas5p4d54f34ebc5161b7cb816e352d144d9a1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124101epcas5p4d54f34ebc5161b7cb816e352d144d9a1
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124101epcas5p4d54f34ebc5161b7cb816e352d144d9a1@epcas5p4.samsung.com>

Created a separate file core/pmem_region.c along with CONFIG_PMEM_REGION
Moved pmem_region related code from core/region.c to core/pmem_region.c
For region label update, need to create device attribute, which calls
nvdimm exported function thus making pmem_region dependent on libnvdimm.
Because of this dependency of pmem region on libnvdimm, segregated pmem
region related code from core/region.c

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/Kconfig            |  12 ++
 drivers/cxl/core/Makefile      |   1 +
 drivers/cxl/core/core.h        |   8 +-
 drivers/cxl/core/pmem_region.c | 222 +++++++++++++++++++++++++++++++++
 drivers/cxl/core/port.c        |   2 +-
 drivers/cxl/core/region.c      | 217 ++------------------------------
 drivers/cxl/cxl.h              |  42 +++++--
 tools/testing/cxl/Kbuild       |   1 +
 8 files changed, 283 insertions(+), 222 deletions(-)
 create mode 100644 drivers/cxl/core/pmem_region.c

diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
index 876469e23f7a..f0cbb096bfe7 100644
--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -128,6 +128,18 @@ config CXL_REGION
 
 	  If unsure say 'y'
 
+config CXL_PMEM_REGION
+	bool "CXL: Pmem Region Support"
+	default CXL_BUS
+	depends on CXL_REGION
+	select LIBNVDIMM if CXL_BUS = y
+	help
+	  Enable the CXL core to enumerate and provision CXL pmem regions.
+	  A CXL pmem region need to update region label into LSA. For LSA
+	  updation/deletion libnvdimm is required.
+
+	  If unsure say 'y'
+
 config CXL_REGION_INVALIDATION_TEST
 	bool "CXL: Region Cache Management Bypass (TEST)"
 	depends on CXL_REGION
diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index 9259bcc6773c..0ef2f3dd6c13 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -16,3 +16,4 @@ cxl_core-y += pmu.o
 cxl_core-y += cdat.o
 cxl_core-$(CONFIG_TRACING) += trace.o
 cxl_core-$(CONFIG_CXL_REGION) += region.o
+cxl_core-$(CONFIG_CXL_PMEM_REGION) += pmem_region.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 800466f96a68..8111da17dfb4 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -22,7 +22,6 @@ void cxl_decoder_kill_region(struct cxl_endpoint_decoder *cxled);
 #define CXL_REGION_ATTR(x) (&dev_attr_##x.attr)
 #define CXL_REGION_TYPE(x) (&cxl_region_type)
 #define SET_CXL_REGION_ATTR(x) (&dev_attr_##x.attr),
-#define CXL_PMEM_REGION_TYPE(x) (&cxl_pmem_region_type)
 #define CXL_DAX_REGION_TYPE(x) (&cxl_dax_region_type)
 int cxl_region_init(void);
 void cxl_region_exit(void);
@@ -59,10 +58,15 @@ static inline void cxl_region_exit(void)
 #define CXL_REGION_ATTR(x) NULL
 #define CXL_REGION_TYPE(x) NULL
 #define SET_CXL_REGION_ATTR(x)
-#define CXL_PMEM_REGION_TYPE(x) NULL
 #define CXL_DAX_REGION_TYPE(x) NULL
 #endif
 
+#ifdef CONFIG_CXL_PMEM_REGION
+#define CXL_PMEM_REGION_TYPE (&cxl_pmem_region_type)
+#else
+#define CXL_PMEM_REGION_TYPE NULL
+#endif
+
 struct cxl_send_command;
 struct cxl_mem_query_commands;
 int cxl_query_cmd(struct cxl_memdev *cxlmd,
diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
new file mode 100644
index 000000000000..a29526c27d40
--- /dev/null
+++ b/drivers/cxl/core/pmem_region.c
@@ -0,0 +1,222 @@
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
+ * LIBNVDIMM, pmem region need updation of cxl region information into
+ * LSA. LIBNVDIMM dependency is only for pmem region, it is therefore
+ * need this separate file.
+ */
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
+	NULL,
+};
+
+const struct device_type cxl_pmem_region_type = {
+	.name = "cxl_pmem_region",
+	.release = cxl_pmem_region_release,
+	.groups = cxl_pmem_region_attribute_groups,
+};
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
+	guard(rwsem_read)(&cxl_region_rwsem);
+	if (p->state != CXL_CONFIG_COMMIT)
+		return -ENXIO;
+
+	struct cxl_pmem_region *cxlr_pmem __free(kfree) =
+		kzalloc(struct_size(cxlr_pmem, mapping, p->nr_targets), GFP_KERNEL);
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
+EXPORT_SYMBOL_NS_GPL(devm_cxl_add_pmem_region, "CXL");
+
+struct cxl_region *cxl_create_pmem_region(struct cxl_root_decoder *cxlrd,
+		struct cxl_decoder *cxld,
+		struct cxl_pmem_region_params *params, int id)
+{
+	int rc;
+
+	rc = memregion_alloc(GFP_KERNEL);
+	if (rc < 0)
+		return ERR_PTR(rc);
+
+	if (atomic_cmpxchg(&cxlrd->region_id, id, rc) != id) {
+		memregion_free(rc);
+		return ERR_PTR(-EBUSY);
+	}
+
+	return devm_cxl_pmem_add_region(cxlrd, cxld, params, id,
+			CXL_DECODER_PMEM, CXL_DECODER_HOSTONLYMEM);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_create_pmem_region, "CXL");
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 94d9322b8e38..7a26a4703180 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -59,7 +59,7 @@ static int cxl_device_id(const struct device *dev)
 		return CXL_DEVICE_NVDIMM_BRIDGE;
 	if (dev->type == &cxl_nvdimm_type)
 		return CXL_DEVICE_NVDIMM;
-	if (dev->type == CXL_PMEM_REGION_TYPE())
+	if (dev->type == CXL_PMEM_REGION_TYPE)
 		return CXL_DEVICE_PMEM_REGION;
 	if (dev->type == CXL_DAX_REGION_TYPE())
 		return CXL_DEVICE_DAX_REGION;
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 8990e3c3474d..e817d3f2d2df 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -30,8 +30,6 @@
  * 3. Decoder targets
  */
 
-static struct cxl_region *to_cxl_region(struct device *dev);
-
 #define __ACCESS_ATTR_RO(_level, _name) {				\
 	.attr	= { .name = __stringify(_name), .mode = 0444 },		\
 	.show	= _name##_access##_level##_show,			\
@@ -2312,7 +2310,7 @@ bool is_cxl_region(struct device *dev)
 }
 EXPORT_SYMBOL_NS_GPL(is_cxl_region, "CXL");
 
-static struct cxl_region *to_cxl_region(struct device *dev)
+struct cxl_region *to_cxl_region(struct device *dev)
 {
 	if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
 			  "not a cxl_region device\n"))
@@ -2320,6 +2318,7 @@ static struct cxl_region *to_cxl_region(struct device *dev)
 
 	return container_of(dev, struct cxl_region, dev);
 }
+EXPORT_SYMBOL_NS_GPL(to_cxl_region, "CXL");
 
 static void unregister_region(void *_cxlr)
 {
@@ -2633,7 +2632,7 @@ static ssize_t commit_region(struct cxl_region *cxlr)
 	return 0;
 }
 
-static struct cxl_region *
+struct cxl_region *
 devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd,
 		struct cxl_decoder *cxld,
 		struct cxl_pmem_region_params *params, int id,
@@ -2709,26 +2708,7 @@ devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd,
 	put_device(dev);
 	return ERR_PTR(rc);
 }
-
-struct cxl_region *cxl_create_pmem_region(struct cxl_root_decoder *cxlrd,
-		struct cxl_decoder *cxld,
-		struct cxl_pmem_region_params *params, int id)
-{
-	int rc;
-
-	rc = memregion_alloc(GFP_KERNEL);
-	if (rc < 0)
-		return ERR_PTR(rc);
-
-	if (atomic_cmpxchg(&cxlrd->region_id, id, rc) != id) {
-		memregion_free(rc);
-		return ERR_PTR(-EBUSY);
-	}
-
-	return devm_cxl_pmem_add_region(cxlrd, cxld, params, id,
-			CXL_DECODER_PMEM, CXL_DECODER_HOSTONLYMEM);
-}
-EXPORT_SYMBOL_NS_GPL(cxl_create_pmem_region, "CXL");
+EXPORT_SYMBOL_NS_GPL(devm_cxl_pmem_add_region, "CXL");
 
 static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
 					  enum cxl_decoder_mode mode, int id)
@@ -2842,46 +2822,6 @@ static ssize_t delete_region_store(struct device *dev,
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
 	enum cxl_decoder_mode mode;
@@ -3146,64 +3086,6 @@ u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 	return hpa;
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
-	guard(rwsem_read)(&cxl_region_rwsem);
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
-	/* Snapshot the region configuration underneath the cxl_region_rwsem */
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
@@ -3273,92 +3155,6 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
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
@@ -3646,7 +3442,10 @@ static int cxl_region_probe(struct device *dev)
 
 	switch (cxlr->mode) {
 	case CXL_DECODER_PMEM:
-		return devm_cxl_add_pmem_region(cxlr);
+		if (IS_ENABLED(CONFIG_CXL_PMEM_REGION))
+			return devm_cxl_add_pmem_region(cxlr);
+		else
+			return -EINVAL;
 	case CXL_DECODER_RAM:
 		/*
 		 * The region can not be manged by CXL if any portion of
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 2c6a782d0941..c6cd0c8d78a1 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -828,6 +828,7 @@ int cxl_dvsec_rr_decode(struct cxl_dev_state *cxlds,
 			struct cxl_endpoint_dvsec_info *info);
 
 bool is_cxl_region(struct device *dev);
+struct cxl_region *to_cxl_region(struct device *dev);
 
 extern struct bus_type cxl_bus_type;
 
@@ -874,11 +875,37 @@ void cxl_region_discovery(struct cxl_port *port);
 struct cxl_root_decoder *cxl_find_root_decoder(struct cxl_port *port);
 
 #ifdef CONFIG_CXL_REGION
-bool is_cxl_pmem_region(struct device *dev);
-struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
 int cxl_add_to_region(struct cxl_port *root,
 		      struct cxl_endpoint_decoder *cxled);
 struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
+struct cxl_region *devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd,
+		struct cxl_decoder *cxld,
+		struct cxl_pmem_region_params *params, int id,
+		enum cxl_decoder_mode mode, enum cxl_decoder_type type);
+#else
+static inline int cxl_add_to_region(struct cxl_port *root,
+				    struct cxl_endpoint_decoder *cxled)
+{
+	return 0;
+}
+static inline struct cxl_dax_region *to_cxl_dax_region(struct device *dev)
+{
+	return NULL;
+}
+static inline struct cxl_region *
+	devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd,
+		struct cxl_decoder *cxld,
+		struct cxl_pmem_region_params *params, int id,
+		enum cxl_decoder_mode mode, enum cxl_decoder_type type)
+{
+	return NULL;
+}
+#endif
+
+#ifdef CONFIG_CXL_PMEM_REGION
+bool is_cxl_pmem_region(struct device *dev);
+struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
+int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 struct cxl_region *cxl_create_pmem_region(struct cxl_root_decoder *cxlrd,
 		struct cxl_decoder *cxld,
 		struct cxl_pmem_region_params *params, int id);
@@ -891,17 +918,12 @@ static inline struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
 {
 	return NULL;
 }
-static inline int cxl_add_to_region(struct cxl_port *root,
-				    struct cxl_endpoint_decoder *cxled)
+static inline int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
 {
 	return 0;
 }
-static inline struct cxl_dax_region *to_cxl_dax_region(struct device *dev)
-{
-	return NULL;
-}
-static inline struct cxl_region *cxl_create_pmem_region(
-		struct cxl_root_decoder *cxlrd,
+static inline struct cxl_region *
+	cxl_create_pmem_region(struct cxl_root_decoder *cxlrd,
 		struct cxl_decoder *cxld,
 		struct cxl_pmem_region_params *params, int id)
 {
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index b1256fee3567..91f3a9076413 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -63,6 +63,7 @@ cxl_core-y += $(CXL_CORE_SRC)/pmu.o
 cxl_core-y += $(CXL_CORE_SRC)/cdat.o
 cxl_core-$(CONFIG_TRACING) += $(CXL_CORE_SRC)/trace.o
 cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o
+cxl_core-$(CONFIG_CXL_PMEM_REGION) += $(CXL_CORE_SRC)/pmem_region.o
 cxl_core-y += config_check.o
 cxl_core-y += cxl_core_test.o
 cxl_core-y += cxl_core_exports.o
-- 
2.34.1


