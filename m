Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436C613D8A3;
	Wed,  5 Jun 2024 06:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569048; cv=none; b=kGul5Lmtp/q5vgW3n9bvK/IRZB49JNFM5y5mHAp+sUxgcPyzHh/Depn4xKV4wcX1kJ+PncJpJBH92W8NTP7PMRYwxzZO8kpTuR6e4EZdb6Ea8f9bWJRnVWNz+RQN79ibCXLpqWCi7c0v7Meep+jhIgJlXGW/dNqZYMp+7NlxleQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569048; c=relaxed/simple;
	bh=qib/9xPCFetZ7Q4riYiYf3kXL5Ke7N2LBl+E7GOIs90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ej5hB/Xux8prp1P2lS6Jw7uR+rW7RR5KLP2XGbG+nCoFFmdlWrMet1QJS8wo7Lt8IqA29AJ2h6T73hW9likMt3q3W2FIviuaj5Qg4ea9IU4j+TwAQc0Pb9Q9YHHKjk82P7LU/j/4ybilsn/UR+IyR/nGQh0ubii0GKeg91RFh48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wby23bIg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wby23bIg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CVlPq2/3UP6xOrwmHdGKzgza9gCdhisKIqS2joU6Vdc=; b=wby23bIgt+gpOcykE+x7E5zAH1
	4SOSZ6qGbIw+SAm9RPPYbSJ3cMpgN8C9Xw2nBb15AGGPxesE3AH4Zlj2Q/Fqico4FPQaLskU6UeSE
	1qRzgHxjzREtYUKW4t5IHm9AnIjg1HSP47VI5L0MgOua2HA0Sj9W9jDuJe2vBOP+WOeDi3kgVAdcz
	xZHY7Q9/V8dT2ouI82RQ9pVKQL4MXT6mMmiPtybOBcF44cq0PZUQj82J8SGjbPqZMispYwWgvLpwt
	Ez2/psEty+jwbZA42CyycpNZ848JKYnTAWwMogkYQnSRVTdrgMFzfia4MTt/qX4kk4CiZ6hT1ggjZ
	nF2RNDhQ==;
Received: from 2a02-8389-2341-5b80-5bcb-678a-c0a8-08fe.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5bcb:678a:c0a8:8fe] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEkAR-00000004mVx-2c34;
	Wed, 05 Jun 2024 06:30:40 +0000
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
Subject: [PATCH 02/12] block: remove the unused BIP_{CTRL,DISK}_NOCHECK flags
Date: Wed,  5 Jun 2024 08:28:31 +0200
Message-ID: <20240605063031.3286655-3-hch@lst.de>
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

Both flags are only checked, but never set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c   | 14 +++-----------
 include/linux/bio.h |  2 --
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d957e29b17a98a..b477383ccc3b2a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -806,25 +806,17 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 	if (dix) {				/* DIX Type 0, 1, 2, 3 */
 		if (bio_integrity_flagged(bio, BIP_IP_CHECKSUM))
 			scmd->prot_flags |= SCSI_PROT_IP_CHECKSUM;
-
-		if (bio_integrity_flagged(bio, BIP_CTRL_NOCHECK) == false)
-			scmd->prot_flags |= SCSI_PROT_GUARD_CHECK;
+		scmd->prot_flags |= SCSI_PROT_GUARD_CHECK;
 	}
 
 	if (dif != T10_PI_TYPE3_PROTECTION) {	/* DIX/DIF Type 0, 1, 2 */
 		scmd->prot_flags |= SCSI_PROT_REF_INCREMENT;
-
-		if (bio_integrity_flagged(bio, BIP_CTRL_NOCHECK) == false)
-			scmd->prot_flags |= SCSI_PROT_REF_CHECK;
+		scmd->prot_flags |= SCSI_PROT_REF_CHECK;
 	}
 
 	if (dif) {				/* DIX/DIF Type 1, 2, 3 */
 		scmd->prot_flags |= SCSI_PROT_TRANSFER_PI;
-
-		if (bio_integrity_flagged(bio, BIP_DISK_NOCHECK))
-			protect = 3 << 5;	/* Disable target PI checking */
-		else
-			protect = 1 << 5;	/* Enable target PI checking */
+		protect = 1 << 5;	/* Enable target PI checking */
 	}
 
 	scsi_set_prot_op(scmd, prot_op);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d5379548d684e1..ec5dcf8635ac66 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -324,8 +324,6 @@ static inline void bio_next_folio(struct folio_iter *fi, struct bio *bio)
 enum bip_flags {
 	BIP_BLOCK_INTEGRITY	= 1 << 0, /* block layer owns integrity data */
 	BIP_MAPPED_INTEGRITY	= 1 << 1, /* ref tag has been remapped */
-	BIP_CTRL_NOCHECK	= 1 << 2, /* disable HBA integrity checking */
-	BIP_DISK_NOCHECK	= 1 << 3, /* disable disk integrity checking */
 	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
 	BIP_INTEGRITY_USER	= 1 << 5, /* Integrity payload is user address */
 	BIP_COPY_USER		= 1 << 6, /* Kernel bounce buffer in use */
-- 
2.43.0

