Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C3213777D;
	Thu, 13 Jun 2024 08:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718268554; cv=none; b=PjBCGw++OY/Jbx9R8i7eizDh7sfOk1esXSHm5qJbs2Xzj0latF77vKgVUHMk7ID+3618Lu9eNkQV/GWcYbPRkC/uPlt+wFwswrg0sBlx6tY76boPXWUSR8F833nGa6PzPcPSkZUy+9kDlItfS2SMt9nhSIQtbDfye/ta97wQ3hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718268554; c=relaxed/simple;
	bh=3exPUCi+/EMwTyBUUWevL8vomgI5Z1iHcLCKhyuuNXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiP4sXMMKZWOA/GMoJe5JuS+tAyjAf3wUcL+n1pJtVuFea7ziF5/2vlvbxeqkIyCR+tI2NsivYlT95R4OwAzhIZ9qLyJdAAOrxKg2Ms3MPT3JrftslAWIOrkvossFt48V5M87iQEJ+s6DlAbWnuqbSs2C4DjHcsp8/BH2oZGIWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tiIrbk7o; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tiIrbk7o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8PfoG5qTEAstoOabcoSjpYBwXPNcAMnJBPyc+pbMqJU=; b=tiIrbk7oHxoSl6ZApNv8fQocn1
	aJ0mHijmRlh0jvrQiGPLpcrk8fNDNpjNDX1D6t4OxV6oCEqLb8X02hxEc/RMniCzLoJb4xDfKPPER
	FmSr7ZhQXDcwPrGmJsMS2cq7YyIOp2i1ccIVjwARo8VX7aMtYnIRYj/ivMzvw5m65XmFXSUJgagcP
	JjOLPbtNeJ8bgyV6ctSyz7rbTbEdUbLhTpd8BjW8Zqw7pjUW3ugc9ep1weAsooLyi1H1zWYMHIXCI
	5T9FmOaeuJq1K5pgWxv+wkCP97zvBVOwl9EyllXwm6oXILU58sViC75XMCLv04tPuUZFjPrheO9Ob
	GUvKg1Cw==;
Received: from 2a02-8389-2341-5b80-034b-6bc2-b258-c831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:34b:6bc2:b258:c831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHg8p-0000000FnG1-2lkQ;
	Thu, 13 Jun 2024 08:49:08 +0000
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
Subject: [PATCH 09/12] block: don't require stable pages for non-PI metadata
Date: Thu, 13 Jun 2024 10:48:19 +0200
Message-ID: <20240613084839.1044015-10-hch@lst.de>
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

Non-PI metadata doesn't contain checksums and thus doesn't require
stable pages.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-integrity.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 58760a6d6b2209..1d2d371cd632d3 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -379,7 +379,8 @@ void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template
 	bi->tag_size = template->tag_size;
 	bi->pi_offset = template->pi_offset;
 
-	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, disk->queue);
+	if (bi->csum_type != BLK_INTEGRITY_CSUM_NONE)
+		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 	if (disk->queue->crypto_profile) {
@@ -404,7 +405,8 @@ void blk_integrity_unregister(struct gendisk *disk)
 	if (!bi->tuple_size)
 		return;
 
-	blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, disk->queue);
+	if (bi->csum_type != BLK_INTEGRITY_CSUM_NONE)
+		blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 	memset(bi, 0, sizeof(*bi));
 }
 EXPORT_SYMBOL(blk_integrity_unregister);
-- 
2.43.0

