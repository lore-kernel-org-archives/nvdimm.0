Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B27818C336;
	Wed,  5 Jun 2024 06:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569050; cv=none; b=K+WYtRM1zqMaHfYzxRXF20fE5PSehTn7Vkd13e5p1e7PxP+nPrHEfxg7+r5y2Oz69/1o6yJBFexDvFuy4hEd9iyPAQyGv4npOviSD23h1iMNUP+C1EQokMPWbW7fbIA3T/MJWctFmLbZxuFd/HBUuoBERypW9yHcrv9PgqFjFUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569050; c=relaxed/simple;
	bh=pI3bf3dJqIuqJhFMjtbWclPvYimUEcq1+ND0W/EbLKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4k9Uy02zYM8t3XcGf7LKjrRlawZBXPuHN7/AV/nK3FJy/TglR951JDYvzp7rSgzwdR5zTp9ibuKD8S0eQ5s4qQflFE5OGFIGFY9vwGnJFIr998No1bDkZEyJ51XLFWgbjsHGoajTkWIJk6VAI6F3IM2GEG9eMSN/nk7cjGXssY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VgHEsLmc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VgHEsLmc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VRqsmzSPX+ptDZscjhdtBL0MV6B8FyDyGhjgYc+fFkc=; b=VgHEsLmcF7yy/MjdQcLCYpmPV7
	sHHksxfOmZYQiEa8LqxWtQ2qz7hoUQBUxGtwSWLP39/ClER3lFVKEBx9A8YeSazVlz2go57So3Etp
	lQRtQag2vQwyLoayVXZrZ7y91SS4tFMhiDleI5bt5tjfWEsuc5uc+NUxb5pp1uUtDzntTMfMTnBaC
	Ot77CO4Uwy6EeaV4/Geo5ICeRlWJ4Tf3VVciKa8E5stXuEmi8k1WACXVCtGaQTdwqVjRCJTjYNSeT
	20cdbCyDqLCzQSTNmdmlwwQxmiMo6bIsneL0C8fSGtgb/qp+IzdeMDnZeX4XTm84QkdzyBgNNki4V
	jsfPxMOw==;
Received: from 2a02-8389-2341-5b80-5bcb-678a-c0a8-08fe.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5bcb:678a:c0a8:8fe] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEkAU-00000004mXb-2Xdl;
	Wed, 05 Jun 2024 06:30:43 +0000
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
Subject: [PATCH 03/12] block: remove the BIP_IP_CHECKSUM flag
Date: Wed,  5 Jun 2024 08:28:32 +0200
Message-ID: <20240605063031.3286655-4-hch@lst.de>
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

Remove the BIP_IP_CHECKSUM as sd can just look at the per-disk
checksum type instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c | 3 ---
 drivers/scsi/sd.c     | 6 +++---
 include/linux/bio.h   | 5 ++---
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 2e3e8e04961eae..43f112ec8b59fe 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -479,9 +479,6 @@ bool bio_integrity_prep(struct bio *bio)
 	bip->bip_flags |= BIP_BLOCK_INTEGRITY;
 	bip_set_seed(bip, bio->bi_iter.bi_sector);
 
-	if (bi->flags & BLK_INTEGRITY_IP_CHECKSUM)
-		bip->bip_flags |= BIP_IP_CHECKSUM;
-
 	/* Map it */
 	offset = offset_in_page(buf);
 	for (i = 0; i < nr_pages && len > 0; i++) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b477383ccc3b2a..e21b7df5c31b0d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -43,7 +43,7 @@
 #include <linux/idr.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
-#include <linux/blkdev.h>
+#include <linux/blk-integrity.h>
 #include <linux/blkpg.h>
 #include <linux/blk-pm.h>
 #include <linux/delay.h>
@@ -799,12 +799,12 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 					   unsigned int dix, unsigned int dif)
 {
 	struct request *rq = scsi_cmd_to_rq(scmd);
-	struct bio *bio = rq->bio;
+	struct blk_integrity *bi = &rq->q->integrity;
 	unsigned int prot_op = sd_prot_op(rq_data_dir(rq), dix, dif);
 	unsigned int protect = 0;
 
 	if (dix) {				/* DIX Type 0, 1, 2, 3 */
-		if (bio_integrity_flagged(bio, BIP_IP_CHECKSUM))
+		if (bi->flags & BLK_INTEGRITY_IP_CHECKSUM)
 			scmd->prot_flags |= SCSI_PROT_IP_CHECKSUM;
 		scmd->prot_flags |= SCSI_PROT_GUARD_CHECK;
 	}
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ec5dcf8635ac66..3295dd6021659b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -324,9 +324,8 @@ static inline void bio_next_folio(struct folio_iter *fi, struct bio *bio)
 enum bip_flags {
 	BIP_BLOCK_INTEGRITY	= 1 << 0, /* block layer owns integrity data */
 	BIP_MAPPED_INTEGRITY	= 1 << 1, /* ref tag has been remapped */
-	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
-	BIP_INTEGRITY_USER	= 1 << 5, /* Integrity payload is user address */
-	BIP_COPY_USER		= 1 << 6, /* Kernel bounce buffer in use */
+	BIP_INTEGRITY_USER	= 1 << 2, /* Integrity payload is user address */
+	BIP_COPY_USER		= 1 << 3, /* Kernel bounce buffer in use */
 };
 
 /*
-- 
2.43.0

