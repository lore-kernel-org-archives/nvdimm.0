Received: from a11-4.smtp-out.amazonses.com (a11-4.smtp-out.amazonses.com [54.240.11.4])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6322428859
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 17:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781199143; cv=none; b=lSw0Nv1DpZ5WrZvLWNUf66dP2SDvkm7jXP9tPZIxqyhfPInE+qRvBMHMXLyOYgqztC6I3gLk6ZqxKnDiD7o3kXXIc6/cw59KtnJRrb/UF4MzTqLyGqiNUEpRJ4PEspdtxmf2cJiECCidjk+uczoPp27bs4wbxH7A58sYFdKYz68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781199143; c=relaxed/simple;
	bh=MhMzKoilIwQ87IE1zVJfJSRF5W/aWdHte5k/yQKLrgk=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=qAPRr2LR98SLEi70qoO7lavkiaTUpTHU7V4vFNfqvoW8jWJJ4nD501YyyehWC2LUSQCIWSm+VERTrDTBx4L8pwjPGgLNJy8tgyJt96ToKu7zMT0/3DU1Y2/bAJNvE5gs1shG0D6U5SUnNhKOlvX8TvCTd+vQcLb8FmMRpP9zKVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=SxD+MKT1; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=GZU14YFR; arc=none smtp.client-ip=54.240.11.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="SxD+MKT1";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="GZU14YFR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781199135;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=MhMzKoilIwQ87IE1zVJfJSRF5W/aWdHte5k/yQKLrgk=;
	b=SxD+MKT1XuKlexKy5yPrDavILcio1AG0cr+feG6Cm9asvEIuWTBGo0BDbaa48j+Y
	dzUqI/9GnZplVQWrngn9K9yPm8K5lwQMMdnw7e2oFxbHENzYPf2nkFIzNo0nsDApQV6
	qEqPYrAq5cvLGc4x82sB87A8qGy0Dtu/IaNbvX18=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781199135;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=MhMzKoilIwQ87IE1zVJfJSRF5W/aWdHte5k/yQKLrgk=;
	b=GZU14YFRJdhZuW5L8V575Z72PlEXT2GgzGBwAzh1J4pJEtgra1UwmLAhgrwIhF2/
	zdn9Y7UZusLUOOV2P6qpDcSVXh5w+RKE1Np1kTec5ndIEfAvcjYuE3V4AYHKhmoCSS5
	sSkFAfwEyz7g9px8j8QPHKgRx+ZWXBsuQxW5dBko=
Subject: [PATCH V5 4/9] dax/fsdev: don't leave a dangling dev_dax->pgmap on
 probe failure
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
Date: Thu, 11 Jun 2026 17:32:15 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com>
References: 
 <0100019eb7bcda4b-3f8edae9-d7a4-4bfa-aaea-fcef77fdbbc3-000000@email.amazonses.com> 
 <20260611173210.65966-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc+cg9hubkqEN8Q8i8MpASzo3sjg==
Thread-Topic: [PATCH V5 4/9] dax/fsdev: don't leave a dangling dev_dax->pgmap
 on probe failure
X-Wm-Sent-Timestamp: 1781199134
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019eb7bde24e-442d75b0-0dcc-416d-8f89-040ce73b183f-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.11-54.240.11.4

From: John Groves <John@Groves.net>

After the dynamic path set dev_dax->pgmap, any later probe failure left
dev_dax->pgmap dangling: devres frees the devm_kzalloc'd pgmap on probe
failure, and subsequent probe attempts would hit the "dynamic-dax with
pre-populated page map" check and fail permanently.

Factor pgmap acquisition out into fsdev_acquire_pgmap(), and defer the
dev_dax->pgmap assignment until probe can no longer fail. A failed probe
now never publishes the pointer at all, so there is nothing to unwind.
This also matches kill_dev_dax(), which already clears the dynamic pgmap
pointer on unbind: dev_dax->pgmap is now non-NULL only while the pgmap
is actually valid.

Refactor suggested by Dave Jiang.

Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/fsdev.c | 77 ++++++++++++++++++++++++++++-----------------
 1 file changed, 49 insertions(+), 28 deletions(-)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 52f46b3e245ea..cc097167ad2c7 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -219,47 +219,62 @@ static const struct file_operations fsdev_fops = {
 	.release = fsdev_release,
 };
 
-static int fsdev_dax_probe(struct dev_dax *dev_dax)
+/*
+ * Acquire the dev_pagemap for probe: the static (pre-populated) one if
+ * present, or a devm-allocated one for the dynamic case. Note that
+ * dev_dax->pgmap is not set here; fsdev_dax_probe() sets it only once
+ * probe succeeds, so a failed probe never leaves a dangling pointer
+ * to a devres-freed pgmap.
+ */
+static struct dev_pagemap *fsdev_acquire_pgmap(struct dev_dax *dev_dax)
 {
-	struct dax_device *dax_dev = dev_dax->dax_dev;
 	struct device *dev = &dev_dax->dev;
 	struct dev_pagemap *pgmap;
-	struct inode *inode;
-	u64 data_offset = 0;
-	struct cdev *cdev;
-	void *addr;
-	int rc, i;
+	size_t pgmap_size;
 
 	if (static_dev_dax(dev_dax)) {
 		if (dev_dax->nr_range > 1) {
-			dev_warn(dev, "static pgmap / multi-range device conflict\n");
-			return -EINVAL;
+			dev_warn(dev,
+				 "static pgmap / multi-range device conflict\n");
+			return ERR_PTR(-EINVAL);
 		}
 
 		pgmap = dev_dax->pgmap;
 		pgmap->vmemmap_shift = 0;
-	} else {
-		size_t pgmap_size;
+		return pgmap;
+	}
 
-		if (dev_dax->pgmap) {
-			dev_warn(dev, "dynamic-dax with pre-populated page map\n");
-			return -EINVAL;
-		}
+	if (dev_dax->pgmap) {
+		dev_warn(dev, "dynamic-dax with pre-populated page map\n");
+		return ERR_PTR(-EINVAL);
+	}
 
-		pgmap_size = struct_size(pgmap, ranges, dev_dax->nr_range - 1);
-		pgmap = devm_kzalloc(dev, pgmap_size, GFP_KERNEL);
-		if (!pgmap)
-			return -ENOMEM;
+	pgmap_size = struct_size(pgmap, ranges, dev_dax->nr_range - 1);
+	pgmap = devm_kzalloc(dev, pgmap_size, GFP_KERNEL);
+	if (!pgmap)
+		return ERR_PTR(-ENOMEM);
 
-		pgmap->nr_range = dev_dax->nr_range;
-		dev_dax->pgmap = pgmap;
+	pgmap->nr_range = dev_dax->nr_range;
+	for (int i = 0; i < dev_dax->nr_range; i++)
+		pgmap->ranges[i] = dev_dax->ranges[i].range;
 
-		for (i = 0; i < dev_dax->nr_range; i++) {
-			struct range *range = &dev_dax->ranges[i].range;
+	return pgmap;
+}
 
-			pgmap->ranges[i] = *range;
-		}
-	}
+static int fsdev_dax_probe(struct dev_dax *dev_dax)
+{
+	struct dax_device *dax_dev = dev_dax->dax_dev;
+	struct device *dev = &dev_dax->dev;
+	struct dev_pagemap *pgmap;
+	struct inode *inode;
+	u64 data_offset = 0;
+	struct cdev *cdev;
+	void *addr;
+	int rc, i;
+
+	pgmap = fsdev_acquire_pgmap(dev_dax);
+	if (IS_ERR(pgmap))
+		return PTR_ERR(pgmap);
 
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range *range = &dev_dax->ranges[i].range;
@@ -306,7 +321,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	/* Detect whether the data is at a non-zero offset into the memory */
 	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
 		u64 phys = dev_dax->ranges[0].range.start;
-		u64 pgmap_phys = dev_dax->pgmap[0].range.start;
+		u64 pgmap_phys = pgmap[0].range.start;
 
 		if (!WARN_ON(pgmap_phys > phys))
 			data_offset = phys - pgmap_phys;
@@ -339,7 +354,13 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		return rc;
 
 	run_dax(dax_dev);
-	return devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
+	rc = devm_add_action_or_reset(dev, fsdev_kill, dev_dax);
+	if (rc)
+		return rc;
+
+	/* Probe can no longer fail; expose the pgmap via dev_dax */
+	dev_dax->pgmap = pgmap;
+	return 0;
 }
 
 static struct dax_device_driver fsdev_dax_driver = {
-- 
2.53.0

