Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F611428F2;
	Thu, 13 Jun 2024 08:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718268548; cv=none; b=dz8y3+dFXfiD1sFxwyklY5mqO6wWZ4489M4bj4RplbTrCye7zQzNhiQVBBUswlRNkHcPv+dxDtBjoq61hE1PQgoP/1CsjLRQeD/+kTOk6sHo04hwhSgXEwZqf3hvSwG11rRGyV/+ctuARkhHiUiCJ5623+uLeLPorT2cbARwCtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718268548; c=relaxed/simple;
	bh=BlQKMerwA89F/RkwnTZ6g2HUBDiUK7Q7iJvZm7kDq3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiaaLOG8AnqKWxafhwUtL4aYLX41MC87izqs/a0yhIWZajRx9giy4TzSPplEEu2iRfBTJ2Q7zfGg5PIeJQD6JkbegS2kn2KHt9MooLnkpaQ73782u1fXx+6PivND+ZampHjWeVkI+jSKzvrEivdyTiXwVLCcfElzr7PZpzkCP74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WfOVLHNE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WfOVLHNE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MkqWB307uYilO32w43UhOiqouC5dD/MHs5vGR6/rVlA=; b=WfOVLHNEY/NCiJE2oBgYCPd3tg
	OOMdttEU9jkmGntkWzb//pPfwDlK4TeqAacAW6AUgWoXEh4eN3PUxb1mcMIdRfaqHL8p0ZXFkgLUw
	CvoZ76+SbGEhavfS7uhoAQnplOZ93pxq4L7wIqYYc1S3YSmeA7RM2vkd+EB1BLrYDgtc1ucaI2tKO
	oWM+RV3avUPY3R66wWIeKsJIiutWYXvt0VfCMllTU1WA6z976fpll14oA5ztTgow9e6AH+F+QB4bn
	IZ+rAEOgxfWPEinmoNaHzjZTSHHHdxxcNPjL0AbC9pF8vTVAXdhFJSH7CqHNpA51Yyd4K+6zKGqnB
	ggUcvwSA==;
Received: from 2a02-8389-2341-5b80-034b-6bc2-b258-c831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:34b:6bc2:b258:c831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHg8k-0000000FnBe-1BuJ;
	Thu, 13 Jun 2024 08:49:02 +0000
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
	linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/12] block: factor out flag_{store,show} helper for integrity
Date: Thu, 13 Jun 2024 10:48:17 +0200
Message-ID: <20240613084839.1044015-8-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240613084839.1044015-1-hch@lst.de>
References: <20240613084839.1044015-1-hch@lst.de>
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
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-integrity.c | 53 +++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 24f04575096d39..24671d9f90a124 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -243,6 +243,28 @@ const char *blk_integrity_profile_name(struct blk_integrity *bi)
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
@@ -275,49 +297,26 @@ static ssize_t read_verify_store(struct device *dev,
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

