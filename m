Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8629E154C11;
	Fri,  7 Jun 2024 05:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717739990; cv=none; b=FJw9PW4/FsDvdfpeEoY4ihNoWEHr1Wtku1uicpHDLTRp/HUFYh6SJpD5rK+sYKdeN3lB90JeyXle34SagUZJ5j4y373OrbwZjDudhBW7p3BSV7VhaSRjzbUta0j7venTjGGrazG1u973PzzCP/KXTSANjkTEADU/NAMNq0P2Zx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717739990; c=relaxed/simple;
	bh=hp3eNeUMh1pxS6BAROfgO9ro9BBWiz2V1CSKooAGAGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8iyhR/rJdXPGDwbKWDb8m7etC8pHb2Xg6PELHEX/y+e8Y2xoPAXRlw7WjvgD851IHLyvzBa6yjqHmZ49YOzhtSG4ufLqVjeMjXTGcqnKQmcjvMzgTLy3H8mLwIxXoDaLY3TQZoUAMsFa//pAdCJxDjE59bloM2UGVvsP97O/iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZOkZhSpD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZOkZhSpD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=S8SjXhZLDr/pH8RKp+nLJLU/M7LgpF4OFUEbQtiC2qo=; b=ZOkZhSpD/EsllME0C8HznqVHeX
	ZsbBr6Rd8fdEQiOpFa3qA/8FXKJORZa7B0ygTOmuG+CHonjE1nZw5t4/DmgZTiiUKqhfEbogifsoB
	jP1/YxdLSaubO+2gT5Iav5OR05x2SUcbIpirfkyB2Mj3zlnrSc1OPBYEECTzIuMTH4NnKftwdfl4Z
	6YKcoK0PasW/0NtUO3RnMXFxASRUkaQffsO87y4jpUmfa8i1974hynjMUdYTc71txse9cQrNJA4Jy
	So3EROEgzj7iQH17Vo25X1Q75VMA/UvyrGERMPf6f4Gd1xtUBgjFB0jRPCjcl0M+aEjC92MdJfTdv
	ISwTiZPw==;
Received: from [2001:4bb8:2dd:aa7c:2c19:fa33:48d4:a32f] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFSdd-0000000Ca79-1UUO;
	Fri, 07 Jun 2024 05:59:46 +0000
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
Subject: [PATCH 08/11] block: don't require stable pages for non-PI metadata
Date: Fri,  7 Jun 2024 07:59:02 +0200
Message-ID: <20240607055912.3586772-9-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240607055912.3586772-1-hch@lst.de>
References: <20240607055912.3586772-1-hch@lst.de>
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

