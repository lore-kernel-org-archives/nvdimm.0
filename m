Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C521132C19;
	Wed,  6 Mar 2024 14:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709735265; cv=none; b=foqXfG3Sk3B4fVcznqGtGV4ASl/mK78FapuXvag5gcjhHDlA7++zeib0QspKsyGxsRp0ebHQETR7ffgbwnJBI6pGiYDouMOYY8ynhEHX4Li/+pKNvYpJMZj+ApcQnR6FP+eaw2NKZNa7/03S9s2F5eTsHKqVRJmTJ8oM0w9sMJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709735265; c=relaxed/simple;
	bh=614YWWBcjUJ3ICmUidzt8Fj67sVPO967RZWWNJf8fsg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jXXibbvWmdX4KPeC08ucBUymG5eZ87spEkPuhabqZI7MxOYy9xbNhDP2RD2YyFbwkhiq3B8jNML29koJItxSZ1qgqmjMf4Cm6ALly6aBeRvxiCpGT+iWBX2WiD0v/R+ThfCQqaKUZoMYsAkzZm0lopDxtRYZ2pKip/n0SElPLFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qKQDQtI2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qKQDQtI2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7yk1M9Fg4zS0yWFU4rLMGN3HCxIgnAEKMfH6m6EEUP4=; b=qKQDQtI268v7GKXbBap5hBsNIg
	/V3+K84GKBFdcnY64LwRIe8LFTEDruU/Qy/p8uJH8+Uzu+2w9TfHNRd1v7GRP45Qn/wiydVM5cgzw
	/P79Iv3qnP3vbHzD/5UA7LnDwMjElJ/eP81xF7Z3XqpIPswPDzlL/+0IyxoRFAFaadr125pu14I/P
	Bd9L5JAb52fbtsYF605IBMBMj0h23z/JzG/QiNWTdly+2qHgyjO+J0Uh1tloKLKIoUCtXuaCVbm+a
	Uv/xYdopO254j7UoPa8hvF6OwqWCAmp/+4wqp5+2GOfnAIwtaAqlJS4+ht+kCP/g9R6MD5kVdR5fi
	7TEclh6g==;
Received: from [66.60.99.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rhsFC-00000000ZYc-0aeO;
	Wed, 06 Mar 2024 14:27:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH 1/3] nvdimm: remove nd_integrity_init
Date: Wed,  6 Mar 2024 07:27:37 -0700
Message-Id: <20240306142739.237234-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240306142739.237234-1-hch@lst.de>
References: <20240306142739.237234-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

nd_integrity_init is only called from a single place.  Open code it
there, and use IS_ENABLED to remove the need for an extra stub.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvdimm/btt.c  | 12 ++++++++----
 drivers/nvdimm/core.c | 30 ------------------------------
 drivers/nvdimm/nd.h   |  1 -
 3 files changed, 8 insertions(+), 35 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 4d0c527e857678..8e855b4e3e383a 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -6,6 +6,7 @@
 #include <linux/highmem.h>
 #include <linux/debugfs.h>
 #include <linux/blkdev.h>
+#include <linux/blk-integrity.h>
 #include <linux/pagemap.h>
 #include <linux/module.h>
 #include <linux/device.h>
@@ -1514,10 +1515,13 @@ static int btt_blk_init(struct btt *btt)
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, btt->btt_disk->queue);
 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, btt->btt_disk->queue);
 
-	if (btt_meta_size(btt)) {
-		rc = nd_integrity_init(btt->btt_disk, btt_meta_size(btt));
-		if (rc)
-			goto out_cleanup_disk;
+	if (btt_meta_size(btt) && IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY)) {
+		struct blk_integrity bi = {
+			.tuple_size	= btt_meta_size(btt),
+			.tag_size	= btt_meta_size(btt),
+		};
+		blk_integrity_register(btt->btt_disk, &bi);
+		blk_queue_max_integrity_segments(btt->btt_disk->queue, 1);
 	}
 
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index d91799b71d23a3..2023a661bbb0b8 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -7,7 +7,6 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/blkdev.h>
-#include <linux/blk-integrity.h>
 #include <linux/device.h>
 #include <linux/ctype.h>
 #include <linux/ndctl.h>
@@ -508,35 +507,6 @@ int nvdimm_bus_add_badrange(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_add_badrange);
 
-#ifdef CONFIG_BLK_DEV_INTEGRITY
-int nd_integrity_init(struct gendisk *disk, unsigned long meta_size)
-{
-	struct blk_integrity bi;
-
-	if (meta_size == 0)
-		return 0;
-
-	memset(&bi, 0, sizeof(bi));
-
-	bi.tuple_size = meta_size;
-	bi.tag_size = meta_size;
-
-	blk_integrity_register(disk, &bi);
-	blk_queue_max_integrity_segments(disk->queue, 1);
-
-	return 0;
-}
-EXPORT_SYMBOL(nd_integrity_init);
-
-#else /* CONFIG_BLK_DEV_INTEGRITY */
-int nd_integrity_init(struct gendisk *disk, unsigned long meta_size)
-{
-	return 0;
-}
-EXPORT_SYMBOL(nd_integrity_init);
-
-#endif
-
 static __init int libnvdimm_init(void)
 {
 	int rc;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index ae2078eb6a6265..2dbb1dca17b534 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -489,7 +489,6 @@ enum nd_async_mode {
 	ND_ASYNC,
 };
 
-int nd_integrity_init(struct gendisk *disk, unsigned long meta_size);
 void wait_nvdimm_bus_probe_idle(struct device *dev);
 void nd_device_register(struct device *dev);
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode);
-- 
2.39.2

