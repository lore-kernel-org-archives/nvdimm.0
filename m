Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C6118F2DF;
	Wed,  5 Jun 2024 06:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569067; cv=none; b=Mjf9VmpHwiVj1fxmMYoX6EntmJIkeWeUTvnBivY7fZ02Ajkm1WTYG5mYn7KwKZqqSWxqk8HGHonAR54WEaWNKAM3NRiJybE/gf9TBcCsqt7UPAnegCjhPZhUBZwW3eDxTFcuTN0xMqJkCfK3afETsUoKmk1zhSDpKRCuclv264s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569067; c=relaxed/simple;
	bh=WlqHAaU2Gy19MGQG9vhUxy1D8yVSTODzhpSZof+5lmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4kWFRpdIF1N4Z8jsEha1kYKGaH0szlmJZ1Eevt+xgLGkzFm3cWVMBZVWqFurTBrxK5YCaNBqFmsu2enBSmWqm4GsTvecCSQE3OmL7GsNrKbo6vphLpFWmhTmkkLQ9JxEY3o8WQbTe7AU+ORGAbxsL+F/ets3oU2VgJLHfhOqWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fUO3q+xO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fUO3q+xO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1CbneON9b6Br3YJjkeUqlFpDr77Xqf/2UZTtp8OANsA=; b=fUO3q+xOY3K7V1lexmXWANZwHI
	EXLMSdNy4DnO92eK+Cm8NcwDHJu2fRlbRe/RT0heUBBD7tzC//h+/sz/owAbHO99VcaK38Ol5pmuQ
	hJPUJyPPGyrbqiUPB0dVTJqvGYr09dQRYjUb0kxxJhmUGOCTwRhkbBPPsDCXTZ+Mi9L3+AD6EPBb3
	PzmjtMtBw8reEnGhcEDOUBqG8A7JPVBz/9aufrtebHE0kno6LZVzDe5NI+smWbER8Ro3GuWlgY2W4
	JbhYtbYiULq6RV0f57D7uxL6C1vkMesyy5q/ji+BqeOlrT5LkOIAavvVoFfafbZc1xioe3p4PekFf
	fZyeLSyA==;
Received: from 2a02-8389-2341-5b80-5bcb-678a-c0a8-08fe.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5bcb:678a:c0a8:8fe] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEkAn-00000004mm4-3mML;
	Wed, 05 Jun 2024 06:31:02 +0000
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
Subject: [PATCH 08/12] block: don't pretend to generate/verify for non-PI metadata
Date: Wed,  5 Jun 2024 08:28:37 +0200
Message-ID: <20240605063031.3286655-9-hch@lst.de>
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

The kernel won't ever generate or verify non-PI metadata, so don't
set the flags and don't allow the user to modify them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-integrity.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index bb3cd1e0eeb58e..c2fcb8e659ed56 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -248,6 +248,9 @@ static ssize_t flag_store(struct device *dev, struct device_attribute *attr,
 	unsigned long val;
 	int err;
 
+	if (bi->csum_type == BLK_INTEGRITY_CSUM_NONE)
+		return -EINVAL;
+
 	err = kstrtoul(page, 10, &val);
 	if (err)
 		return err;
@@ -369,8 +372,9 @@ void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template
 	struct blk_integrity *bi = &disk->queue->integrity;
 
 	bi->csum_type = template->csum_type;
-	bi->flags = BLK_INTEGRITY_VERIFY | BLK_INTEGRITY_GENERATE |
-		template->flags;
+	bi->flags = template->flags;
+	if (bi->csum_type != BLK_INTEGRITY_CSUM_NONE)
+		bi->flags |= BLK_INTEGRITY_VERIFY | BLK_INTEGRITY_GENERATE;
 	bi->interval_exp = template->interval_exp ? :
 		ilog2(queue_logical_block_size(disk->queue));
 	bi->tuple_size = template->tuple_size;
-- 
2.43.0

