Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24135187BFD;
	Wed,  5 Jun 2024 06:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569076; cv=none; b=ceRDpWZX8xkYv9YMoHYzV8EIdxrHXehpO6HbZgwGB2Bxf5uyVuy9bdHpZW6zLxyVKKjGn+74pz0vbhVII18LvBUkE5v3braXplRNbeB0YW1kFP0kqCR/MGubaQHY5ard2SbT035KM5TqM0UIBy+vBEirfgUBy+4QjioAyQro/dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569076; c=relaxed/simple;
	bh=PZc3Uf6XszHMsA9S+Htr3A8jBEzS2+vDNm3J0D8LoNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ti3Gxm9HWMsSqKi02kDJBNC8KvqQMovCgFMH0oAUc1uF+3PIBCRh5nbskz/WnxW3fmiOLgHp0GL8PBw6NPzCmuBmllCZCaloBJoLXRAxb0n2+YqR0pZGXtzz76Yb8mUNG1ivKKfCa0N61aFIJYC9s1ZFm5UZsfqLpOz9MqTN4rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hRgqOcu6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hRgqOcu6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IZmo4GZrh826z/hz5q091wyMSoCSpvNw0ho2xw+v4ts=; b=hRgqOcu6Vek+ljMIrWXVQ7bFmD
	CL9Bk1Q6LYX6vhXdNfmEvaOn6BGCdPuLvRZqiPBxBp8cfKjt4NLvANQzNy2yj60L+9VeOZ+b6TO+g
	EUOrl3qT55QOVZQPUumcSI9JNHJ47n8hXxYhynehlNQubwqQRlmzYjwN7Y81AWBJjN1C4qsoxgP7c
	J5Oy3e31aAr44JEaZHIQFABzWM/FfWyQpiByd5Vvp3zMSdzFIoLJkxfP8Rqg8RcOUHVXc1RLibLrZ
	LlrwW7/HyDJgVgd1eY9dF9JA7uf9AWs80PfNrkH4TAgJQOuswYWXcg8l01F5LcHB/5JE8cGSau8G4
	+OlNlF7g==;
Received: from 2a02-8389-2341-5b80-5bcb-678a-c0a8-08fe.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5bcb:678a:c0a8:8fe] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEkAw-00000004mtf-0SD5;
	Wed, 05 Jun 2024 06:31:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 11/12] block: invert the BLK_INTEGRITY_{GENERATE,VERIFY} flags
Date: Wed,  5 Jun 2024 08:28:40 +0200
Message-ID: <20240605063031.3286655-12-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605063031.3286655-1-hch@lst.de>
References: <20240605063031.3286655-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Invert the flags so that user set values will be able to persist
revalidating the integrity information once we switch the integrity
information to queue_limits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c         |  4 ++--
 block/blk-integrity.c         | 19 ++++++++++---------
 include/linux/blk-integrity.h |  4 ++--
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 5966a65edcd10e..3d6f6a63888f2e 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -450,10 +450,10 @@ bool bio_integrity_prep(struct bio *bio)
 		return true;
 
 	if (bio_data_dir(bio) == READ) {
-		if (!(bi->flags & BLK_INTEGRITY_VERIFY))
+		if (bi->flags & BLK_INTEGRITY_NOVERIFY)
 			return true;
 	} else {
-		if (!(bi->flags & BLK_INTEGRITY_GENERATE))
+		if (bi->flags & BLK_INTEGRITY_NOGENERATE)
 			return true;
 	}
 
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index fbb0bd467eedbf..9a126c8d08f1d8 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -255,10 +255,11 @@ static ssize_t flag_store(struct device *dev, struct device_attribute *attr,
 	if (err)
 		return err;
 
+	/* the flags are inverted vs the values in the sysfs files */
 	if (val)
-		bi->flags |= flag;
-	else
 		bi->flags &= ~flag;
+	else
+		bi->flags |= flag;
 	return count;
 }
 
@@ -267,7 +268,9 @@ static ssize_t flag_show(struct device *dev, struct device_attribute *attr,
 {
 	struct blk_integrity *bi = dev_to_bi(dev);
 
-	return sysfs_emit(page, "%d\n", !!(bi->flags & flag));
+	return sysfs_emit(page, "%d\n",
+		(bi->csum_type != BLK_INTEGRITY_CSUM_NONE &&
+		 !(bi->flags & flag)));
 }
 
 static ssize_t format_show(struct device *dev, struct device_attribute *attr,
@@ -302,26 +305,26 @@ static ssize_t read_verify_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *page, size_t count)
 {
-	return flag_store(dev, attr, page, count, BLK_INTEGRITY_VERIFY);
+	return flag_store(dev, attr, page, count, BLK_INTEGRITY_NOVERIFY);
 }
 
 static ssize_t read_verify_show(struct device *dev,
 				struct device_attribute *attr, char *page)
 {
-	return flag_show(dev, attr, page, BLK_INTEGRITY_VERIFY);
+	return flag_show(dev, attr, page, BLK_INTEGRITY_NOVERIFY);
 }
 
 static ssize_t write_generate_store(struct device *dev,
 				    struct device_attribute *attr,
 				    const char *page, size_t count)
 {
-	return flag_store(dev, attr, page, count, BLK_INTEGRITY_GENERATE);
+	return flag_store(dev, attr, page, count, BLK_INTEGRITY_NOGENERATE);
 }
 
 static ssize_t write_generate_show(struct device *dev,
 				   struct device_attribute *attr, char *page)
 {
-	return flag_show(dev, attr, page, BLK_INTEGRITY_GENERATE);
+	return flag_show(dev, attr, page, BLK_INTEGRITY_NOGENERATE);
 }
 
 static ssize_t device_is_integrity_capable_show(struct device *dev,
@@ -373,8 +376,6 @@ void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template
 
 	bi->csum_type = template->csum_type;
 	bi->flags = template->flags;
-	if (bi->csum_type != BLK_INTEGRITY_CSUM_NONE)
-		bi->flags |= BLK_INTEGRITY_VERIFY | BLK_INTEGRITY_GENERATE;
 	bi->interval_exp = template->interval_exp ? :
 		ilog2(queue_logical_block_size(disk->queue));
 	bi->tuple_size = template->tuple_size;
diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
index dea0fdebc3bdc7..a4bf2c78776c06 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -7,8 +7,8 @@
 struct request;
 
 enum blk_integrity_flags {
-	BLK_INTEGRITY_VERIFY		= 1 << 0,
-	BLK_INTEGRITY_GENERATE		= 1 << 1,
+	BLK_INTEGRITY_NOVERIFY		= 1 << 0,
+	BLK_INTEGRITY_NOGENERATE	= 1 << 1,
 	BLK_INTEGRITY_DEVICE_CAPABLE	= 1 << 2,
 	BLK_INTEGRITY_REF_TAG		= 1 << 3,
 };
-- 
2.43.0

