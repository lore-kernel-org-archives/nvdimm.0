Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC5D18F2DF;
	Wed,  5 Jun 2024 06:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569061; cv=none; b=dFCVy7W6zzaekw4npoeUfeWhfKwoqKYyl9FVGFO5dm/oT0laTIc8eYH/uWgyEVU4NYqD0ILc9zsRFaZokycyswpBBMjqBfnPPdCjnt7YCqZeFKeYYBn6fJIV1ni8CsjelrhTsInpUn9JvRY5w3PRiVi/CaqFCvuMXZ7PPCgcZE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569061; c=relaxed/simple;
	bh=Z7SptR49ha1cG1y0NRFduqBgeqSo1nupmZRUNmZPzxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0Wb98UI2M+KGTLnfskxhRXoSxmBwh9eFMeXYV4jZ5XtVap9aXy/o0X9gEyJkJ9eqXgAtFnzmIRk3WTWCorGZ6vX31+9uxfG/z4E3MGTTSGtq2b8UUfy2dbvxH2hE5y3WOjsydrs6pJpLjd2J0Q5fbeGWgxJav7a/PAYIHjeN7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fD9OFdg8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fD9OFdg8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hID966GzAmGkJoW58zcCvS0V7nWIipRFGVluJmB6pqg=; b=fD9OFdg8asUtGJs3Yl97tl20kM
	76H9mvfSC2+JDLMmHCp/SkIhm0IT3yQlkOmWDmOoHw6QfiVtzoqcJtmVWcP5NpqW0dFcf5UB91geV
	Ld1uMksSFNocvJRxaJh7oCWU4BPxjNQq2fpAdxHgj/zVDZf5XSkscnmE3ffD61L6ODuE0C5r63jax
	Wtk5TzeTSNDbk33mRpBtKuWFNAb45Hmo860FEtxM9pUoaiVmrOh1h7w8uclHkw7lOhwt0oe/afvT6
	9NQszmc9FZghFaiSQdUl6avtv1APqN9GTU55dDhhYJ+Xd2mtGYfUUhgssSoW+90JGDxZq4NA/t5d8
	cSqDHcuw==;
Received: from 2a02-8389-2341-5b80-5bcb-678a-c0a8-08fe.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5bcb:678a:c0a8:8fe] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEkAh-00000004meA-2xA5;
	Wed, 05 Jun 2024 06:30:56 +0000
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
Subject: [PATCH 06/12] block: factor out flag_{store,show} helper for integrity
Date: Wed,  5 Jun 2024 08:28:35 +0200
Message-ID: <20240605063031.3286655-7-hch@lst.de>
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

Factor the duplicate code for the generate and verify attributes into
common helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-integrity.c | 53 +++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index e11b815c03c981..686b6adf0ea5c7 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -241,6 +241,28 @@ const char *blk_integrity_profile_name(struct blk_integrity *bi)
 }
 EXPORT_SYMBOL_GPL(blk_integrity_profile_name);
 
+static ssize_t flag_store(struct device *dev, struct device_attribute *attr,
+		const char *page, size_t count, unsigned char flag)
+{
+	struct blk_integrity *bi = dev_to_bi(dev);
+	char *p = (char *) page;
+	unsigned long val = simple_strtoul(p, &p, 10);
+
+	if (val)
+		bi->flags |= flag;
+	else
+		bi->flags &= ~flag;
+	return count;
+}
+
+static ssize_t flag_show(struct device *dev, struct device_attribute *attr,
+		char *page, unsigned char flag)
+{
+	struct blk_integrity *bi = dev_to_bi(dev);
+
+	return sysfs_emit(page, "%d\n", !!(bi->flags & flag));
+}
+
 static ssize_t format_show(struct device *dev, struct device_attribute *attr,
 			   char *page)
 {
@@ -273,49 +295,26 @@ static ssize_t read_verify_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *page, size_t count)
 {
-	struct blk_integrity *bi = dev_to_bi(dev);
-	char *p = (char *) page;
-	unsigned long val = simple_strtoul(p, &p, 10);
-
-	if (val)
-		bi->flags |= BLK_INTEGRITY_VERIFY;
-	else
-		bi->flags &= ~BLK_INTEGRITY_VERIFY;
-
-	return count;
+	return flag_store(dev, attr, page, count, BLK_INTEGRITY_VERIFY);
 }
 
 static ssize_t read_verify_show(struct device *dev,
 				struct device_attribute *attr, char *page)
 {
-	struct blk_integrity *bi = dev_to_bi(dev);
-
-	return sysfs_emit(page, "%d\n", !!(bi->flags & BLK_INTEGRITY_VERIFY));
+	return flag_show(dev, attr, page, BLK_INTEGRITY_VERIFY);
 }
 
 static ssize_t write_generate_store(struct device *dev,
 				    struct device_attribute *attr,
 				    const char *page, size_t count)
 {
-	struct blk_integrity *bi = dev_to_bi(dev);
-
-	char *p = (char *) page;
-	unsigned long val = simple_strtoul(p, &p, 10);
-
-	if (val)
-		bi->flags |= BLK_INTEGRITY_GENERATE;
-	else
-		bi->flags &= ~BLK_INTEGRITY_GENERATE;
-
-	return count;
+	return flag_store(dev, attr, page, count, BLK_INTEGRITY_GENERATE);
 }
 
 static ssize_t write_generate_show(struct device *dev,
 				   struct device_attribute *attr, char *page)
 {
-	struct blk_integrity *bi = dev_to_bi(dev);
-
-	return sysfs_emit(page, "%d\n", !!(bi->flags & BLK_INTEGRITY_GENERATE));
+	return flag_show(dev, attr, page, BLK_INTEGRITY_GENERATE);
 }
 
 static ssize_t device_is_integrity_capable_show(struct device *dev,
-- 
2.43.0

