Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AF52E2663
	for <nvdimm@lists.linux.dev>; Sun, 27 Sep 2026 11:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790509697; cv=none; b=rlktDTk9KZewSVcvfYFabcl02X6EMaQf7Mxbj43PJZdTlodhf6GOQOneISefGVv+zNB7+eERMBHBuFptw4G9HwpCwgVY8LG1wfaEBWbP0oFh5cX6uTTueSe9qcszkHoKAbj+BfoWqzUWjRZW+sjW0l8Icql7JjiJfqmc4+Aq7GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790509697; c=relaxed/simple;
	bh=HBHV/62yI+JYrWhZqIWGO3sYDDSnF4jP43YHMK4BpBE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fOT95ro5vpl0yzE/0gYTuAU5Ylle11Cz9FpWMQKJEkXLMuV/fTwIXHMZEjVIIN1HqO+E1vwIbRXGEbi67Yu3IvjMyMaqHuv5BVh7gsAbrQNcWbuWFTtA/SuKVfh9ncHrTdOoFez7eLD5cSnZEgyvjabqoW72lE+cJf9wpBnCVDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=I9kXWnMU; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="I9kXWnMU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=pK
	ynHbLhG9X4po2DaLz7W43GvJJAM4U5tX5su9C/E9s=; b=I9kXWnMU4tgVBS5Hlu
	CsZNsZlxiW9/aGqWREVLEDHJ+tFbG8t9xiQmD+449382lpmo3rJz9m2i3wZh9a+i
	EekH2MCHqFL0izx2zVyXHcKmonemHUgGt1VNoa4ZvDn1EGZiWPgvHC1gf6G5Z2we
	hf8m5MtgjNkJN9uJrBwBBd7ds=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3X_VaArlq3UCPBA--.22802S2;
	Sun, 27 Sep 2026 19:47:39 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joao Martins <joao.m.martins@oracle.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>,
	stable@vger.kernel.org
Subject: [PATCH] dax/device: defer publishing the dynamic pgmap
Date: Sun, 27 Sep 2026 19:47:36 +0800
Message-Id: <20260927114736.1113965-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3X_VaArlq3UCPBA--.22802S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KF1kKr1rAr1fKrWkXr15CFg_yoW8WrW7pF
	WUWFyYkrWkAFnrXw1jvrW7uFyakwnFqw4xWry0gasa9r9xXw1jqry2gFWjva9xt348GF1j
	qrZFqryUWay2yF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piPrc3UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7xuf2Wq5AluR3gAA33

The dynamic device-dax probe path publishes its devm-allocated pgmap
before several operations that can still fail.  If one of them fails,
devres frees the pgmap while dev_dax->pgmap remains non-NULL.  A later
bind then fails the dynamic-dax invariant check and leaves the device
unusable until its region is recreated.

Defer assigning dev_dax->pgmap until the final devm action has been
installed and probe can no longer fail.  A failed probe then never
publishes the temporary pgmap.

Fixes: fc65c4eb0b2a ("device-dax: ensure dev_dax->pgmap is valid for dynamic devices")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/dax/device.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index d0c9b4e03b47..8cd8e05872c3 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -409,7 +409,6 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
 			return -ENOMEM;
 
 		pgmap->nr_range = dev_dax->nr_range;
-		dev_dax->pgmap = pgmap;
 
 		for (i = 0; i < dev_dax->nr_range; i++) {
 			struct range *range = &dev_dax->ranges[i].range;
@@ -450,7 +449,13 @@ static int dev_dax_probe(struct dev_dax *dev_dax)
 		return rc;
 
 	run_dax(dax_dev);
-	return devm_add_action_or_reset(dev, dev_dax_kill, dev_dax);
+	rc = devm_add_action_or_reset(dev, dev_dax_kill, dev_dax);
+	if (rc)
+		return rc;
+
+	/* Probe can no longer fail; expose the pgmap via dev_dax. */
+	dev_dax->pgmap = pgmap;
+	return 0;
 }
 
 static struct dax_device_driver device_dax_driver = {
-- 
2.34.1

