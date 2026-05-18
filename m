Received: from a48-183.smtp-out.amazonses.com (a48-183.smtp-out.amazonses.com [54.240.48.183])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A553002B3
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 21:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.48.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140169; cv=none; b=gcVwnthRbC9MvHN6CDTW1GF0ju8woovxw7kRcqxVPUoGO8xBpcPiTPLMcmPfMGPVbeSqwyEZaasUXvm/+aJ3RmINOj0R6s/nlahcdW66d2TzrJnrG5/a5z71vd8AlJqRcr/+Azk8R5DctGQJizPxwAjhN0zY/flt1qWFYKNICQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140169; c=relaxed/simple;
	bh=+apKbo4axdJy1hnlLusmelkeXETm/alkbyM90MHfqxs=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=oXqDVN/uu4MWS2cXXm3Q2bRhIhbq72hGo0vnF0sDRXv3bSw//pbughWOiH0pf/FAg/fsokptlPuvqBzui4fgfcw6449nIlAVOhyzAGwogdrDzAfhWKUcTC/ODx+45vE3LeJCzOuGUfj0HXt6/6XNZ9GFPEfaXGyt2fgoiToClKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=LXQ1cTZp; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=aVH4LbjG; arc=none smtp.client-ip=54.240.48.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="LXQ1cTZp";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="aVH4LbjG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779140166;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=+apKbo4axdJy1hnlLusmelkeXETm/alkbyM90MHfqxs=;
	b=LXQ1cTZpaw401nwRhaWnBzmVMtKvrl6jIghADJlWkqOyn9syqbLNjuSGYqA1oy7a
	e+mHm1uMSkD0AMJJD+O9k2ig6oVaPUkKLoA8YoBOhxUnDQj7oyY4GVf4huUr4MdUe1P
	yXC9ZS/wMMb6ii+dmE9zYggOWwXcUaXWXTzGooNo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779140166;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=+apKbo4axdJy1hnlLusmelkeXETm/alkbyM90MHfqxs=;
	b=aVH4LbjGlsEXPA9GDXLTlPZpTBQ1xfVA0GSyF0Kvuq8WIf4YAkr/pOcXG47B5caH
	iW75OzovRm28Mx+MHyqs1reZfjpy7lbWaw+3bW88sTk1I8oLtCavtORj+bHY7YPrMRr
	U14mtjtFt+AC5LtzN8NhxyHzmvh8xOnPn2xRJnCs=
Subject: [PATCH 2/6] dax/fsdev: fix multi-range offset, vmemmap_shift leak,
 and probe error cleanup
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
Date: Mon, 18 May 2026 21:36:06 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019e3d03bba9-d27282f3-5552-4fa0-8326-981e4c13dace-000000@email.amazonses.com>
References: 
 <0100019e3d03bba9-d27282f3-5552-4fa0-8326-981e4c13dace-000000@email.amazonses.com> 
 <20260518213558.31264-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc5w41mkJXxS0+R8GcNdWTTpRlkwAAB+Bq
Thread-Topic: [PATCH 2/6] dax/fsdev: fix multi-range offset, vmemmap_shift
 leak, and probe error cleanup
X-Wm-Sent-Timestamp: 1779140165
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e3d0483a9-211ac8de-a468-41fd-b22c-57c4f7eed34c-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.18-54.240.48.183

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
index 73e3a8fbf416d..de7e6dee68386 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -133,11 +133,26 @@ static void fsdev_clear_ops(void *data)
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
@@ -206,6 +221,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 {
 	struct dax_device *dax_dev = dev_dax->dax_dev;
 	struct device *dev = &dev_dax->dev;
+	bool pgmap_allocated = false;
 	struct dev_pagemap *pgmap;
 	struct inode *inode;
 	u64 data_offset = 0;
@@ -220,6 +236,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		}
 
 		pgmap = dev_dax->pgmap;
+		pgmap->vmemmap_shift = 0;
 	} else {
 		size_t pgmap_size;
 
@@ -235,6 +252,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 
 		pgmap->nr_range = dev_dax->nr_range;
 		dev_dax->pgmap = pgmap;
+		pgmap_allocated = true;
 
 		for (i = 0; i < dev_dax->nr_range; i++) {
 			struct range *range = &dev_dax->ranges[i].range;
@@ -250,7 +268,8 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 					range_len(range), dev_name(dev))) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve range\n",
 				 i, range->start, range->end);
-			return -EBUSY;
+			rc = -EBUSY;
+			goto err_pgmap;
 		}
 	}
 
@@ -270,8 +289,10 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
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
@@ -283,7 +304,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	rc = devm_add_action_or_reset(dev, fsdev_clear_folio_state_action,
 				      dev_dax);
 	if (rc)
-		return rc;
+		goto err_pgmap;
 
 	/* Detect whether the data is at a non-zero offset into the memory */
 	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
@@ -305,23 +326,32 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
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

