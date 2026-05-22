Received: from a11-79.smtp-out.amazonses.com (a11-79.smtp-out.amazonses.com [54.240.11.79])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D932FE056
	for <nvdimm@lists.linux.dev>; Fri, 22 May 2026 19:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779477539; cv=none; b=bzOwLLy9HU6P7AtXJraV/937Oyn4aqpJBSqG/2yAFsQkp1j5DtNozkFtiTow1aBTjZncA6vIqrEwRODMp4nimHqoN/rl2+8PCRbJ7eDpWGLkO7lQBEUBoR1A+6ocsLAtZ4Sp9GXIKgzxYJQLYz//5AqiBpEzbbfOSkh9l8HMM8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779477539; c=relaxed/simple;
	bh=HRsPIuAHGMysoIw6mDkAUoUM7WXvlfGtAZKwuGak0cU=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=MAMu/i7GmUmXTIpuJK6fqcdlfr/xrn9KeLL1bs92VWzriYyDHEmm24f+yQ3uHwBzvEY2BM981yqb6UsR2GhBLJyEezKLlReJG9oVHfJ4jonS61nTqb4SqqEesluZOLouo8jaL/80UzI0BQiHyVmK4S8YMPN06PTdePmkXKV6OKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=SiUsMHcz; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=WAhfpZCW; arc=none smtp.client-ip=54.240.11.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="SiUsMHcz";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="WAhfpZCW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779477536;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=HRsPIuAHGMysoIw6mDkAUoUM7WXvlfGtAZKwuGak0cU=;
	b=SiUsMHczR1nOld8kmHGfqsKqZmwj0VRYBFk1C2MR0JTc2+b5AVk5aBBbDPtzyUWH
	YKTTzWE961XhC++komvEwq27eyimc9cJrm67kWQ6V++Tg7cet6PoQnipdH9S5JwFBQA
	o42k9esT4J6lXg4cUO9n118qqVRhxoPJrZb1UfOQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779477536;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=HRsPIuAHGMysoIw6mDkAUoUM7WXvlfGtAZKwuGak0cU=;
	b=WAhfpZCWHc6tZbIFg2yUOu8K1kb7ildUpbhYvcFSZCxQR9EsBTjEx9jfzpZT5DQQ
	noAY4o2iHdk8ocdMRQS0NtX8S2Unk/BIIlTKVzLKuB0zB+nU9lcbSb7J2ninKjnSl4p
	AsnztA/GX55un5CZdrmKGISeXBw03Ho+7JR4yZcA=
Subject: [PATCH V2 2/7] dax/fsdev: fix multi-range offset, vmemmap_shift
 leak, and probe error cleanup
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?Christian_Brauner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>, 
	=?UTF-8?Q?Ira_Weiny?= <iweiny@kernel.org>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jic23@kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Fri, 22 May 2026 19:18:56 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
References: 
 <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com> 
 <20260522191851.79150-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc6h+7e4zSojcNRQ2wV9eJQr6w4gAABnU2
Thread-Topic: [PATCH V2 2/7] dax/fsdev: fix multi-range offset, vmemmap_shift
 leak, and probe error cleanup
X-Wm-Sent-Timestamp: 1779477535
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e51205fc2-9b729b27-3485-44a0-98b2-ea56189c192e-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.22-54.240.11.79

From: John Groves <John@Groves.net>

Three fixes for fsdev.c:

1. Fix memory_failure offset calculation for multi-range devices.
   The old code subtracted ranges[0].range.start from the faulting PFN's
   physical address, which produces an incorrect (inflated) logical offset
   when the PFN falls in ranges[1] or beyond due to physical gaps between
   ranges. Add fsdev_pfn_to_offset() to walk the range list and compute
   the correct device-linear byte offset.

2. Clear pgmap->vmemmap_shift for static DAX devices. When rebinding a
   static device from device_dax (which may set vmemmap_shift based on
   alignment) to fsdev_dax, the stale vmemmap_shift persists on the
   shared pgmap. Explicitly zero it before devm_memremap_pages() so the
   vmemmap is built for order-0 folios as fsdev requires.

3. Clear dev_dax->pgmap on probe failure for dynamic devices. After the
   dynamic path sets dev_dax->pgmap, if a later probe step fails, devres
   frees the devm_kzalloc'd pgmap but leaves dev_dax->pgmap dangling.
   Subsequent probe attempts would hit the "dynamic-dax with pre-populated
   page map" check and fail permanently. Use a goto cleanup to NULL
   dev_dax->pgmap on error.

Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/fsdev.c | 50 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 10 deletions(-)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 188b2526bee45..42aac7e952516 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -135,11 +135,26 @@ static void fsdev_clear_ops(void *data)
  * The core mm code in free_zone_device_folio() handles the wake_up_var()
  * directly for this memory type.
  */
+static u64 fsdev_pfn_to_offset(struct dev_dax *dev_dax, unsigned long pfn)
+{
+	phys_addr_t phys = PFN_PHYS(pfn);
+	u64 offset = 0;
+
+	for (int i = 0; i < dev_dax->nr_range; i++) {
+		struct range *range = &dev_dax->ranges[i].range;
+
+		if (phys >= range->start && phys <= range->end)
+			return offset + (phys - range->start);
+		offset += range_len(range);
+	}
+	return -1ULL;
+}
+
 static int fsdev_pagemap_memory_failure(struct dev_pagemap *pgmap,
 		unsigned long pfn, unsigned long nr_pages, int mf_flags)
 {
 	struct dev_dax *dev_dax = pgmap->owner;
-	u64 offset = PFN_PHYS(pfn) - dev_dax->ranges[0].range.start;
+	u64 offset = fsdev_pfn_to_offset(dev_dax, pfn);
 	u64 len = nr_pages << PAGE_SHIFT;
 
 	return dax_holder_notify_failure(dev_dax->dax_dev, offset,
@@ -208,6 +223,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 {
 	struct dax_device *dax_dev = dev_dax->dax_dev;
 	struct device *dev = &dev_dax->dev;
+	bool pgmap_allocated = false;
 	struct dev_pagemap *pgmap;
 	struct inode *inode;
 	u64 data_offset = 0;
@@ -222,6 +238,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		}
 
 		pgmap = dev_dax->pgmap;
+		pgmap->vmemmap_shift = 0;
 	} else {
 		size_t pgmap_size;
 
@@ -237,6 +254,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 
 		pgmap->nr_range = dev_dax->nr_range;
 		dev_dax->pgmap = pgmap;
+		pgmap_allocated = true;
 
 		for (i = 0; i < dev_dax->nr_range; i++) {
 			struct range *range = &dev_dax->ranges[i].range;
@@ -252,7 +270,8 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 					range_len(range), dev_name(dev))) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve range\n",
 				 i, range->start, range->end);
-			return -EBUSY;
+			rc = -EBUSY;
+			goto err_pgmap;
 		}
 	}
 
@@ -272,8 +291,10 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	pgmap->owner = dev_dax;
 
 	addr = devm_memremap_pages(dev, pgmap);
-	if (IS_ERR(addr))
-		return PTR_ERR(addr);
+	if (IS_ERR(addr)) {
+		rc = PTR_ERR(addr);
+		goto err_pgmap;
+	}
 
 	/*
 	 * Clear any stale compound folio state left over from a previous
@@ -285,7 +306,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	rc = devm_add_action_or_reset(dev, fsdev_clear_folio_state_action,
 				      dev_dax);
 	if (rc)
-		return rc;
+		goto err_pgmap;
 
 	/* Detect whether the data is at a non-zero offset into the memory */
 	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
@@ -307,23 +328,32 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	cdev_set_parent(cdev, &dev->kobj);
 	rc = cdev_add(cdev, dev->devt, 1);
 	if (rc)
-		return rc;
+		goto err_pgmap;
 
 	rc = devm_add_action_or_reset(dev, fsdev_cdev_del, cdev);
 	if (rc)
-		return rc;
+		goto err_pgmap;
 
 	/* Set the dax operations for fs-dax access path */
 	rc = dax_set_ops(dax_dev, &dev_dax_ops);
 	if (rc)
-		return rc;
+		goto err_pgmap;
 
 	rc = devm_add_action_or_reset(dev, fsdev_clear_ops, dev_dax);
 	if (rc)
-		return rc;
+		goto err_pgmap;
 
 	run_dax(dax_dev);
-	return devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
+	rc = devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
+	if (rc)
+		goto err_pgmap;
+
+	return 0;
+
+err_pgmap:
+	if (pgmap_allocated)
+		dev_dax->pgmap = NULL;
+	return rc;
 }
 
 static struct dax_device_driver fsdev_dax_driver = {
-- 
2.53.0

