Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEA734887E;
	Thu, 23 Apr 2026 17:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963748; cv=none; b=cmGqvcymsxhc6KL4d9gEHbLQWM/6uiqqdlLfmKnNG6PTw7HkAs/AeG/BPEQ4MxrlEwND2fjrOUOKPVVCDpnC5xioSUi/CmUs2hEMGdBTURUPqdIv3bTkXol/3sJSBZWlEyqFiZo0H4RumMNj2pgBWZDC+GsV/rdBRrZTsk6/qEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963748; c=relaxed/simple;
	bh=Qn6MYvgdwSzIYFQf9YGNVnk88xJZQABDn0RhGZYtM1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZJkKTIaUcKnJgo4X9fj2oQvt8+xY3+jVqd1aRDOLZRMm//xOPKlTza1ysGNX3PVhmkCss3ZGyTpxAB0pXj2gZpB8t5SM3RF9PGlXh5TykXu+Y3IHgyOMB99GKrPr6qEIe7wZP00Gx6lMh+N8SMwjFGFBqgSUzo1yxLISaF1QJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCCAC2BCB3;
	Thu, 23 Apr 2026 17:02:28 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: djbw@kernel.org,
	iweiny@kernel.org,
	pasha.tatashin@soleen.com,
	mclapinski@google.com,
	rppt@kernel.org,
	joao.m.martins@oracle.com,
	jic23@kernel.org,
	gourry@gourry.net,
	john@groves.net,
	rick.p.edgecombe@intel.com
Subject: [RFC PATCH 05/12] dax: Add dax_operations and supporting functions to device dax
Date: Thu, 23 Apr 2026 10:02:12 -0700
Message-ID: <20260423170219.281618-6-dave.jiang@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260423170219.281618-1-dave.jiang@intel.com>
References: <20260423170219.281618-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dax_direct_access() support is needed to provide PFN when KVM performs
an EPT exception on the guest memory faulting. Add dax_operations and
supporting functions to support dax_direct_access() for device dax.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/bus.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 97 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 92e79720befd..1ef447747876 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2017-2018 Intel Corporation. All rights reserved. */
 #include <linux/memremap.h>
+#include <linux/highmem.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
@@ -1441,6 +1442,101 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
 }
 EXPORT_SYMBOL_GPL(dax_pgoff_to_phys);
 
+static void dev_dax_write_dax(void *addr, struct page *page,
+			      unsigned int off, unsigned int len)
+{
+	while (len) {
+		void *mem = kmap_local_page(page);
+		unsigned int chunk = min_t(unsigned int, len, PAGE_SIZE - off);
+
+		memcpy_flushcache(addr, mem + off, chunk);
+		kunmap_local(mem);
+		len -= chunk;
+		off = 0;
+		page++;
+		addr += chunk;
+	}
+}
+
+static long __dev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
+				    long nr_pages, enum dax_access_mode mode,
+				    void **kaddr, unsigned long *pfn)
+{
+	struct dev_dax *dev_dax = dax_get_private(dax_dev);
+	size_t size = nr_pages << PAGE_SHIFT;
+	size_t offset = pgoff << PAGE_SHIFT;
+	void *virt_addr = dev_dax->virt_addr + offset;
+	unsigned long local_pfn;
+	phys_addr_t phys;
+
+	/* Only support DAX_ACCESS atm */
+	if (mode != DAX_ACCESS)
+		return -EINVAL;
+
+	if (!dev_dax || !dev_dax->virt_addr)
+		return -ENXIO;
+
+	if (nr_pages <= 0)
+		return -EINVAL;
+
+	if (offset >= dev_dax->cached_size)
+		return -ERANGE;
+
+	phys = dax_pgoff_to_phys(dev_dax, pgoff, size);
+	if (phys == -1) {
+		dev_dbg(&dev_dax->dev,
+			"invalid access: pgoff=%#lx, nr_pages=%ld\n",
+			pgoff, nr_pages);
+		return -ERANGE;
+	}
+
+	if (kaddr)
+		*kaddr = virt_addr;
+
+	local_pfn = PHYS_PFN(phys);
+	if (pfn)
+		*pfn = local_pfn;
+
+	/*
+	 * Use cached_size which was computed at probe time. The size cannot
+	 * change while the driver is bound (resize returns -EBUSY).
+	 */
+	return PHYS_PFN(min(size, dev_dax->cached_size - offset));
+}
+
+static int dev_dax_zero_page_range(struct dax_device *dax_dev,
+				   pgoff_t pgoff, size_t nr_pages)
+{
+	void *kaddr;
+
+	WARN_ONCE(nr_pages > 1, "%s: nr_pages > 1\n", __func__);
+	__dev_dax_direct_access(dax_dev, pgoff, nr_pages, DAX_ACCESS, &kaddr, NULL);
+	dev_dax_write_dax(kaddr, ZERO_PAGE(0), 0, PAGE_SIZE);
+	return 0;
+}
+
+static long dev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
+				  long nr_pages, enum dax_access_mode mode,
+				  void **kaddr, unsigned long *pfn)
+{
+	return __dev_dax_direct_access(dax_dev, pgoff, nr_pages, mode, kaddr,
+				       pfn);
+}
+
+static size_t dev_dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
+				     void *addr, size_t bytes,
+				     struct iov_iter *i)
+{
+	return _copy_from_iter_flushcache(addr, bytes, i);
+}
+
+
+static const struct dax_operations dev_dax_ops = {
+	.direct_access = dev_dax_direct_access,
+	.zero_page_range = dev_dax_zero_page_range,
+	.recovery_write = dev_dax_recovery_write,
+};
+
 static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 {
 	struct dax_region *dax_region = data->dax_region;
@@ -1500,7 +1596,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	 * No dax_operations since there is no access to this device outside of
 	 * mmap of the resulting character device.
 	 */
-	dax_dev = alloc_dax(dev_dax, NULL);
+	dax_dev = alloc_dax(dev_dax, &dev_dax_ops);
 	if (IS_ERR(dax_dev)) {
 		rc = PTR_ERR(dax_dev);
 		goto err_alloc_dax;
-- 
2.53.0

