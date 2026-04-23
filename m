Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369A0386C0A;
	Thu, 23 Apr 2026 17:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963744; cv=none; b=rX8aRA4DY0Yw/kf4rajuxQkGYa9YFy1FW1XR1f/mqjT8A5LnkeCTFJbQZQkSosiFe+jAJHFy6jlRQS78AsCw7Z6aG0yQUlBZVF4+1RJnyAn7Mo2NylU5XP1KlXZcgqqvWHKrr8U5ujwQ5UGrUsHqED6T/JL3Lqgm+LdqdhVC8vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963744; c=relaxed/simple;
	bh=3HHkPQzEYy3AVQxaCt9xTKxJeWlgn9OWlO/P7JsaLGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNBy8Jhc8lks2Ct9/i+GxefWiFecZ65CUvPZyuBWpbkQf3JP6HaNOBgC87uWhqzpp3zlIYj8XWVLZAvSrXVyqes1zr/43A9XHYQitQRjviE1uH5UZk+cjceqZD0Hy6uDK6attStgnsX8ez4nupHF7aqiQtF3p37JnaQ2LRTGkAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8AC5C2BCAF;
	Thu, 23 Apr 2026 17:02:23 +0000 (UTC)
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
Subject: [RFC PATCH 02/12] dax: Save the kva from memremap
Date: Thu, 23 Apr 2026 10:02:09 -0700
Message-ID: <20260423170219.281618-3-dave.jiang@intel.com>
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

This patch is partially taken from John Grove's famfs dax series.

Save the kva for memremap because we need direct_access() support.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/dax-private.h |  4 ++++
 drivers/dax/device.c      | 19 +++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index c6ae27c982f4..425a515905e5 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -69,6 +69,8 @@ struct dev_dax_range {
  * data while the device is activated in the driver.
  * @region: parent region
  * @dax_dev: core dax functionality
+ * @virt_addr: kva from memremap; used by fsdev_dax
+ * @cached_size: cached size of the memory range for quick access; used by fsdev_dax
  * @align: alignment of this instance
  * @target_node: effective numa node if dev_dax memory range is onlined
  * @dyn_id: is this a dynamic or statically created instance
@@ -83,6 +85,8 @@ struct dev_dax_range {
 struct dev_dax {
 	struct dax_region *region;
 	struct dax_device *dax_dev;
+	void *virt_addr;
+	u64 cached_size;
 	unsigned int align;
 	int target_node;
 	bool dyn_id;
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 62206bcb63a6..4ffa3ef60a57 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -370,6 +370,7 @@ static int dax_open(struct inode *inode, struct file *filp)
 	filp->f_sb_err = file_sample_sb_err(filp);
 	filp->private_data = dev_dax;
 	inode->i_flags = S_DAX;
+	inode->i_size = dev_dax->cached_size;
 
 	return 0;
 }
@@ -408,7 +409,9 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
 	struct device *dev = &dev_dax->dev;
 	struct dev_pagemap *pgmap;
 	struct inode *inode;
+	u64 data_offset = 0;
 	struct cdev *cdev;
+	u64 len = 0;
 	void *addr;
 	int rc, i;
 
@@ -451,6 +454,7 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
 					i, range->start, range->end);
 			return -EBUSY;
 		}
+		len += range_len(range);
 	}
 
 	pgmap->type = MEMORY_DEVICE_GENERIC;
@@ -461,6 +465,21 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
 
+	/* Detect whether the data is at a non-zero offset into the memory */
+	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
+		u64 phys = dev_dax->ranges[0].range.start;
+		u64 pgmap_phys = dev_dax->pgmap[0].range.start;
+
+		if (!WARN_ON(pgmap_phys > phys))
+			data_offset = phys - pgmap_phys;
+
+		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
+			 __func__, phys, pgmap_phys, data_offset);
+	}
+
+	dev_dax->virt_addr = addr + data_offset;
+	dev_dax->cached_size = len;
+
 	inode = dax_inode(dax_dev);
 	cdev = inode->i_cdev;
 	cdev_init(cdev, &dax_fops);
-- 
2.53.0

