Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5BC35CB6B
	for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 21:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769720707; cv=none; b=iPQCKWUg3Pl2rCPAYBqMz82sVsI9sm3HFFfqeriqsvP/0weeGFOTqFgbMVWjiu1yM4cbtXZ/aYVxLVTiqhlEhPUU4gfC2ZX77DqTSv1em7iudn6YsHSq0hjc0eoESvaKCjV0BbRVNGd5JElREDr7cidO6uoLyo57l127VIHReEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769720707; c=relaxed/simple;
	bh=AXe5PQvLdK8hxmdbrwIXi4vOiSDdinSnNnxoyEcMa4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piw+bC4/NZp1sO3Cb/gJO4BExVT+4/nsAhvlMDRNk4dsZvU9wYl5RPcWZ3SDVMS0FVAHzNq6DIXxyfqMC2ueqEngVDOf37SJSNy1nyhgxpgMMJOjma0qgivxXUTV3gYsrDKiFR9fKsMMKymCyMEnwG/tXyVMIcZJKQ4KUs1gFns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=aMjUviEJ; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="aMjUviEJ"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8c6d8751c88so150745785a.2
        for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 13:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720702; x=1770325502; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrqa+fxuwjNl7Vx5HUEIUV4yNFrGE6eFCuap5wTqfpc=;
        b=aMjUviEJlFjWLHsX2EOQ2zhcvpY3dqE+YkrscB7tyxo98psif3Vn/xFFod9GIwWVoG
         8ARZb4EI5/z9x1xXNNIL4bjCuAgp072H7qH/pi0TcyQOOPHfUFgLjG7wFodWuXC+rYYQ
         B1pjJbHWPz/uSSPjOjKPIo87xn7nISZFWpTyPLZnr3MOEGk2xV497IoU3LR08l9ddqXT
         5OSwk8FjcrpLXHKCY6A+WPYBTbyCz3GES3z8aNxj8WYGW5ehyjQwVjTslARNU2aIVKyV
         ZELmGfcPcmTdI8D7HXlJb2OD09XltXZSIZ0lWIK5LNMv9ZTzZFJWC793PBjaL89OCp/d
         oHaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720702; x=1770325502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lrqa+fxuwjNl7Vx5HUEIUV4yNFrGE6eFCuap5wTqfpc=;
        b=nJOqzTtWj5uR+qx4EusVAOvKoFUTHj12QSeydadh0iioDn1gFjYK4g+Fi5id10VOPy
         IgXmrSXKf87V5wSP1LCJQ17hl4RjWhjyy14P+eMvT3s2G7VSLDYj5rCBM2ARF8t8GgcL
         Tx+RIyTAIzpO6u+ZqEG1D/gh7Qd53Fiz3vvkkSuZqdD7/E4GdOfgJn+vJifPnh+A8Vpz
         bGmmu9M7FgGYMext3REUyRrv29upXr5vUSAW7naY/O8YWgJaKqYijrw0xmp4noeWAbRV
         95yH8OnE9wwR0bLEp2A4Pnanvyaf73t9xlxw37jGHuB+zQlktm5cbnJyBdMTmOQBCpvp
         XQpg==
X-Forwarded-Encrypted: i=1; AJvYcCVXuLKY0IVkLKqqIZwNE/roPQXKz3Qy4hUrzvfNJe3zKu5rOUE7apSExgH4EpKs7jBXTwCZDXY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpYl3/Ff8NfFxZmSHDEapWRkF3ZYkjBOnAuOWVd2iPtdhwjj+l
	Dsx7kd5G0qY2lpoPBlpAmHjS1iJRWuVmvrA86xaerp2bD08/Rf/Aa/vRJbrq/I1ZDVA=
X-Gm-Gg: AZuq6aIxAkJFBcdkIxpXEjCQnVzoHLIsCrDYpytVqt1m8H4t+14FyFKty1qmkjCc7wf
	ejMdK+7iEj6LD3dBENkT6lN1KlJ5JtT1bJkWiq2QxCE0C29LY6uiwt2pXIA6zMW1E4kD6EEzZPo
	JS3+qfw0YkNNKgUjHw2GkwAJvBRJDUKv9hMro1loZ+tnUoxm6ugh9h+dRtI2Tl9EQqLuh1aLw7H
	+9QDt+zWM1BxfZP+plkqPmW8F77gJvmb+oWO5tipq377S4dnMgmYwqcnAeN9Brgl/ZqHosE905B
	xmv9MnoODlVxPkDYIXx8tVDqfRWV0E1nRO6PvqM0J+5cSLGjjQm8+IsPLYPhUfoAsaMoFG4axZI
	DbZELf6W6Em4h3id9SN0G8UkNA7KRcv+32vjIbVOABLLnfrz/Ji6IpuVi9Q/0ZcCZKybB8ygi4P
	x66RqCd2H+qVc2hKJFWcTpgmesq307QiHYRHiErfR1FM3/z6XvsBq2v20OJHDxvk4Mff3/6iLEU
	jE=
X-Received: by 2002:a05:620a:4591:b0:8c7:1af9:b868 with SMTP id af79cd13be357-8c9eb28d35cmr167526085a.36.1769720701558;
        Thu, 29 Jan 2026 13:05:01 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:05:01 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	terry.bowman@amd.com,
	john@jagalactic.com
Subject: [PATCH 6/9] cxl/core/region: move dax region device logic into dax_region.c
Date: Thu, 29 Jan 2026 16:04:39 -0500
Message-ID: <20260129210442.3951412-7-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the CXL DAX region device infrastructure from region.c into a
new dax_region.c file.

No functional changes.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/Makefile     |   1 +
 drivers/cxl/core/core.h       |   1 +
 drivers/cxl/core/dax_region.c | 113 ++++++++++++++++++++++++++++++++++
 drivers/cxl/core/region.c     | 102 ------------------------------
 4 files changed, 115 insertions(+), 102 deletions(-)
 create mode 100644 drivers/cxl/core/dax_region.c

diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index 23269c81fd44..36f284d7c500 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -17,6 +17,7 @@ cxl_core-y += cdat.o
 cxl_core-y += ras.o
 cxl_core-$(CONFIG_TRACING) += trace.o
 cxl_core-$(CONFIG_CXL_REGION) += region.o
+cxl_core-$(CONFIG_CXL_REGION) += dax_region.o
 cxl_core-$(CONFIG_CXL_REGION) += pmem_region.o
 cxl_core-$(CONFIG_CXL_MCE) += mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += features.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 26991de12d76..217dd708a2a6 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -43,6 +43,7 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port);
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
 u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
+int devm_cxl_add_dax_region(struct cxl_region *cxlr, enum dax_driver_type);
 int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 
 #else
diff --git a/drivers/cxl/core/dax_region.c b/drivers/cxl/core/dax_region.c
new file mode 100644
index 000000000000..0602db5f7248
--- /dev/null
+++ b/drivers/cxl/core/dax_region.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright(c) 2022 Intel Corporation. All rights reserved.
+ * Copyright(c) 2026 Meta Technologies Inc. All rights reserved.
+ */
+#include <linux/memory_hotplug.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <cxlmem.h>
+#include <cxl.h>
+#include "core.h"
+
+static void cxl_dax_region_release(struct device *dev)
+{
+	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
+
+	kfree(cxlr_dax);
+}
+
+static const struct attribute_group *cxl_dax_region_attribute_groups[] = {
+	&cxl_base_attribute_group,
+	NULL,
+};
+
+const struct device_type cxl_dax_region_type = {
+	.name = "cxl_dax_region",
+	.release = cxl_dax_region_release,
+	.groups = cxl_dax_region_attribute_groups,
+};
+
+static bool is_cxl_dax_region(struct device *dev)
+{
+	return dev->type == &cxl_dax_region_type;
+}
+
+struct cxl_dax_region *to_cxl_dax_region(struct device *dev)
+{
+	if (dev_WARN_ONCE(dev, !is_cxl_dax_region(dev),
+			  "not a cxl_dax_region device\n"))
+		return NULL;
+	return container_of(dev, struct cxl_dax_region, dev);
+}
+EXPORT_SYMBOL_NS_GPL(to_cxl_dax_region, "CXL");
+
+static struct lock_class_key cxl_dax_region_key;
+
+static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	struct cxl_dax_region *cxlr_dax;
+	struct device *dev;
+
+	guard(rwsem_read)(&cxl_rwsem.region);
+	if (p->state != CXL_CONFIG_COMMIT)
+		return ERR_PTR(-ENXIO);
+
+	cxlr_dax = kzalloc(sizeof(*cxlr_dax), GFP_KERNEL);
+	if (!cxlr_dax)
+		return ERR_PTR(-ENOMEM);
+
+	cxlr_dax->hpa_range.start = p->res->start;
+	cxlr_dax->hpa_range.end = p->res->end;
+
+	dev = &cxlr_dax->dev;
+	cxlr_dax->cxlr = cxlr;
+	device_initialize(dev);
+	lockdep_set_class(&dev->mutex, &cxl_dax_region_key);
+	device_set_pm_not_required(dev);
+	dev->parent = &cxlr->dev;
+	dev->bus = &cxl_bus_type;
+	dev->type = &cxl_dax_region_type;
+
+	return cxlr_dax;
+}
+
+static void cxlr_dax_unregister(void *_cxlr_dax)
+{
+	struct cxl_dax_region *cxlr_dax = _cxlr_dax;
+
+	device_unregister(&cxlr_dax->dev);
+}
+
+int devm_cxl_add_dax_region(struct cxl_region *cxlr,
+			    enum dax_driver_type dax_driver)
+{
+	struct cxl_dax_region *cxlr_dax;
+	struct device *dev;
+	int rc;
+
+	cxlr_dax = cxl_dax_region_alloc(cxlr);
+	if (IS_ERR(cxlr_dax))
+		return PTR_ERR(cxlr_dax);
+
+	cxlr_dax->online_type = mhp_get_default_online_type();
+	cxlr_dax->dax_driver = dax_driver;
+	dev = &cxlr_dax->dev;
+	rc = dev_set_name(dev, "dax_region%d", cxlr->id);
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
+	return devm_add_action_or_reset(&cxlr->dev, cxlr_dax_unregister,
+					cxlr_dax);
+err:
+	put_device(dev);
+	return rc;
+}
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index fc56f8f03805..61ec939c1462 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3196,108 +3196,6 @@ static int region_offset_to_dpa_result(struct cxl_region *cxlr, u64 offset,
 	return -ENXIO;
 }
 
-static void cxl_dax_region_release(struct device *dev)
-{
-	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
-
-	kfree(cxlr_dax);
-}
-
-static const struct attribute_group *cxl_dax_region_attribute_groups[] = {
-	&cxl_base_attribute_group,
-	NULL,
-};
-
-const struct device_type cxl_dax_region_type = {
-	.name = "cxl_dax_region",
-	.release = cxl_dax_region_release,
-	.groups = cxl_dax_region_attribute_groups,
-};
-
-static bool is_cxl_dax_region(struct device *dev)
-{
-	return dev->type == &cxl_dax_region_type;
-}
-
-struct cxl_dax_region *to_cxl_dax_region(struct device *dev)
-{
-	if (dev_WARN_ONCE(dev, !is_cxl_dax_region(dev),
-			  "not a cxl_dax_region device\n"))
-		return NULL;
-	return container_of(dev, struct cxl_dax_region, dev);
-}
-EXPORT_SYMBOL_NS_GPL(to_cxl_dax_region, "CXL");
-
-static struct lock_class_key cxl_dax_region_key;
-
-static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
-{
-	struct cxl_region_params *p = &cxlr->params;
-	struct cxl_dax_region *cxlr_dax;
-	struct device *dev;
-
-	guard(rwsem_read)(&cxl_rwsem.region);
-	if (p->state != CXL_CONFIG_COMMIT)
-		return ERR_PTR(-ENXIO);
-
-	cxlr_dax = kzalloc(sizeof(*cxlr_dax), GFP_KERNEL);
-	if (!cxlr_dax)
-		return ERR_PTR(-ENOMEM);
-
-	cxlr_dax->hpa_range.start = p->res->start;
-	cxlr_dax->hpa_range.end = p->res->end;
-
-	dev = &cxlr_dax->dev;
-	cxlr_dax->cxlr = cxlr;
-	device_initialize(dev);
-	lockdep_set_class(&dev->mutex, &cxl_dax_region_key);
-	device_set_pm_not_required(dev);
-	dev->parent = &cxlr->dev;
-	dev->bus = &cxl_bus_type;
-	dev->type = &cxl_dax_region_type;
-
-	return cxlr_dax;
-}
-
-static void cxlr_dax_unregister(void *_cxlr_dax)
-{
-	struct cxl_dax_region *cxlr_dax = _cxlr_dax;
-
-	device_unregister(&cxlr_dax->dev);
-}
-
-static int devm_cxl_add_dax_region(struct cxl_region *cxlr,
-				   enum dax_driver_type dax_driver)
-{
-	struct cxl_dax_region *cxlr_dax;
-	struct device *dev;
-	int rc;
-
-	cxlr_dax = cxl_dax_region_alloc(cxlr);
-	if (IS_ERR(cxlr_dax))
-		return PTR_ERR(cxlr_dax);
-
-	cxlr_dax->online_type = mhp_get_default_online_type();
-	cxlr_dax->dax_driver = dax_driver;
-	dev = &cxlr_dax->dev;
-	rc = dev_set_name(dev, "dax_region%d", cxlr->id);
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
-	return devm_add_action_or_reset(&cxlr->dev, cxlr_dax_unregister,
-					cxlr_dax);
-err:
-	put_device(dev);
-	return rc;
-}
-
 static int match_decoder_by_range(struct device *dev, const void *data)
 {
 	const struct range *r1, *r2 = data;
-- 
2.52.0

