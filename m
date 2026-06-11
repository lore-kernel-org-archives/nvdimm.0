Received: from a11-75.smtp-out.amazonses.com (a11-75.smtp-out.amazonses.com [54.240.11.75])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4828279329
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 17:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781199123; cv=none; b=s6LSk5sk2pkM8R/HTHrm03UVRZbx9oKRWI+AUR6uiIt0q6OygvASRAksQsBiQ12TbffuspjNfbWPiEdCRJd3Hl71fi1JyZ9cBe3onC9CGk9ofLsDZNRoOOUvCjvqBm7n26r4ZfiQmN6KSxCWzHL1CA91greSABVSqN4A2uOUUpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781199123; c=relaxed/simple;
	bh=UAzWVek3tu6sgywKSqHRfmYJrqIv0Yci0ta0ml0mqCA=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=qgnVUX0sG16GgM2H4lw0VtSBQ4fNh3Yjk3gHHkudSV/+0WfBwRnWKXYymc78/8i+HRNsmpMjfz0MWRZsx2YZMZm19c/g5movQrIWl5+XYzboQEYaedgDQaJPXynMNsdmlZEtQS08YvOD9iaU4EvvJ4srgLXfkd/pu0FLsxlYZvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=BURweK7I; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=paA75gbx; arc=none smtp.client-ip=54.240.11.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="BURweK7I";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="paA75gbx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1781199119;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=UAzWVek3tu6sgywKSqHRfmYJrqIv0Yci0ta0ml0mqCA=;
	b=BURweK7Ice65J0AtPWxR4ZoaHPQ70nJMAvi3kb3v3wJElctAtEnWaLo2/SLn1OIh
	jGQQINtWN90EFUnzqFiLFW0Mj869icT3d6HcnnzkIWsljrLISt04jo6ZhVFxlGz2OFY
	HPyhg2gPgNQt2EYOCA/Q1PRxkBw0D+WKwQgNP6DY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1781199119;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=UAzWVek3tu6sgywKSqHRfmYJrqIv0Yci0ta0ml0mqCA=;
	b=paA75gbxhcrkGTwxD0+wYEcFx5FjLmLE1KiSBrZmBdED+6ugPV2EGrGwj1skoZGR
	p/An3fsOOVL0CeUUYpI/bpLan1/1kAdNQZEJX4FaWVuqdrpiBcPez+Dth7/5xJ+PgJb
	m0NtanJqP6to+fdSmxSCAceiSlt9S9nO5F1N9lNI=
Subject: [PATCH V5 2/9] dax/fsdev: fix multi-range offset in memory_failure
 handler
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
	=?UTF-8?Q?Richard_Cheng?= <icheng@nvidia.com>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Thu, 11 Jun 2026 17:31:59 +0000
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
 <20260611173152.65905-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc+cg0yoVG1CemRKmwUY66X4n2EQ==
Thread-Topic: [PATCH V5 2/9] dax/fsdev: fix multi-range offset in
 memory_failure handler
X-Wm-Sent-Timestamp: 1781199118
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019eb7bda506-6ba24207-b1c0-4eeb-9b04-61940cf3f80c-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.06.11-54.240.11.75

From: John Groves <John@Groves.net>

Fix memory_failure offset calculation for multi-range devices. The old code
subtracted ranges[0].range.start from the faulting PFN's physical address,
which produces an incorrect (inflated) logical offset when the PFN falls in
ranges[1] or beyond due to physical gaps between ranges. Add
fsdev_pfn_to_offset() to walk the range list and compute the correct
device-linear byte offset.

Walk the pagemap's own range array (pgmap->ranges[]) rather than
dev_dax->ranges[]. The pgmap copy is the immutable snapshot populated at
probe and is never mutated afterwards, whereas dev_dax->ranges[] can be
krealloc()'d by a concurrent sysfs mapping_store() (under dax_region_rwsem,
which this ->memory_failure callback does not hold). For dynamic devices the
two arrays are identical, so the reported offset is unchanged for the
multi-range case this targets.

Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")

Suggested-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/fsdev.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 188b2526bee45..2c5de3d80a618 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -135,11 +135,26 @@ static void fsdev_clear_ops(void *data)
  * The core mm code in free_zone_device_folio() handles the wake_up_var()
  * directly for this memory type.
  */
+static u64 fsdev_pfn_to_offset(struct dev_pagemap *pgmap, unsigned long pfn)
+{
+	phys_addr_t phys = PFN_PHYS(pfn);
+	u64 offset = 0;
+
+	for (int i = 0; i < pgmap->nr_range; i++) {
+		struct range *range = &pgmap->ranges[i];
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
+	u64 offset = fsdev_pfn_to_offset(pgmap, pfn);
 	u64 len = nr_pages << PAGE_SHIFT;
 
 	return dax_holder_notify_failure(dev_dax->dax_dev, offset,
-- 
2.53.0

