Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C62187BD0;
	Wed,  5 Jun 2024 06:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569071; cv=none; b=ONm6S8bW+cYGy/7u++mlCJy3gAQPmVvHP0VgqwO9WP219j40+b9yx6wKFMzRRCYZ+MEeYWgtHcgC/5leVsvn3hrm9TSFn5wOZXTZ32BTfjtjyY/lmXocLBrzAnvdadaeB/i2gMci4zm5OvqZQRFXHG+L13mr+hpv19u+uZ1G0jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569071; c=relaxed/simple;
	bh=GL/WYC5cC5JIP60vEPdhjJ2pnld3S0OQKARLq75+bgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDae5xl32wU9/MqAWFyfaiQYKotY+Zz5cmtboDzxiJvMkLYRYtZWdrdQT9tA5VVx6lSixSGKahZRe+iTKHDRDnoInwqoVT8j7PYMJckoC+jVoQChKeHESFMNSZtDrhUKGr4ECwae6BBr80dcGk8A/oSYXkpW3P8pBe/lfc9pySo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F0PCoAjY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F0PCoAjY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZV3xGJ/03X7L9SJ8Q7G+pbM+wevUqYtpse3omH3JVW4=; b=F0PCoAjYGEJ8HWEO6thMDApPdO
	S6t6pN4e6H2CeU/Ho+IUz0RK/w5u3yueqM7sShetSC0ilt3OVBRwsxmJ2xYAPbA80qXjm0ctHeGli
	vdNBoQfSxRAlgWcT1JA251KKjptzGu5q1qNZ0VJKHPaUVYu7H2Wkn2gKfywgw9CHvhoH3axL5HsAT
	77MXUZ8b+fUjsa44qXlO7chmC3OoAQJMi/Q2MQedcEWrp+BXRxElkS1MquNQV7IQQo4uaIxRoE36i
	8VUKsXvXx4Q7HlSmB7riqDGoQ3xKmClvIc8MpDP3HurJRTAiWz0sZmCN7loaqT2LtjqRSYThk9Wlx
	t5N0xIRA==;
Received: from 2a02-8389-2341-5b80-5bcb-678a-c0a8-08fe.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5bcb:678a:c0a8:8fe] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEkAq-00000004mor-2ZOn;
	Wed, 05 Jun 2024 06:31:05 +0000
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
Subject: [PATCH 09/12] block: don't require stable pages for non-PI metadata
Date: Wed,  5 Jun 2024 08:28:38 +0200
Message-ID: <20240605063031.3286655-10-hch@lst.de>
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

Non-PI metadata doesn't contain checksums and thus doesn't require
stable pages.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-integrity.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index c2fcb8e659ed56..f07d44be6b2236 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -381,7 +381,8 @@ void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template
 	bi->tag_size = template->tag_size;
 	bi->pi_offset = template->pi_offset;
 
-	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, disk->queue);
+	if (bi->csum_type != BLK_INTEGRITY_CSUM_NONE)
+		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 	if (disk->queue->crypto_profile) {
@@ -406,7 +407,8 @@ void blk_integrity_unregister(struct gendisk *disk)
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

