Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C35C14E2F7;
	Fri,  7 Jun 2024 05:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717739971; cv=none; b=rHVDIA38reWZbp4Jeirn681VrcVR0/IlsVKIqrcRGdaeQ2gFoaChOmVN2iU3wslU8VNfUutpGWneAH6EBHShnMPNaNhv0RLM3mUQSAyYyknjRXsplOy5ZQkK9Y3nWJB3H803VC0zfRJpqHnVvnrYvBUBDKP4iUp3NVW/yCdYsFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717739971; c=relaxed/simple;
	bh=XPUeEdxVSLiDhIkFOWY826E1Tq/r+Yw5KyiIESk9hqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+l7Znxl0xuPVvxlw7UHrMdcnTj4k5r1rASm1OPk+8nRIwysz9aocoA9vI+103Kn2+g2hkSPkIUqoY0JnsW5+Q15UR1B98vEMfKNXSAu+aUOjkb/KCCGYuek0sEDuWzribzEJ5OhVvRjgLDRuK420ZC/kPrBM+YNXRmYI5mXKkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yELZfjv1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yELZfjv1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=luAONBAN0nJiG2qd4IVk/ym6PD3j8Tq+GbpZg5S7V1o=; b=yELZfjv1eltWXl3DgoAtHJHHpn
	z5UclvIgckBzo4yhXi72sVg4NAAw5lgzTak5WT26YjNOwnTgYPsv2bJtS4Hn+a/YQC1r7051pXHMm
	z7qtt6eOlV5NaZuNgLt1EVo/rjY+n99HF9Q1ZJEx1AWz91xTIvXRlOkXagKn7YDBn9+FCLSt+pdMX
	dA/b4bNvpj0RDClPXPk0eYod2qRi+xrn7ungZUorPjKxMZ3K0Gq0PCjUOQSy8El559kLw9Xf7iMvg
	GrvhgquL/QZotsdTdK28dGrDjFLibZdjy+1F2TQZ6vSIu+h1FLq2PCFHjfKpkm0tN8IlOsi/xJUbV
	GDQUVtMg==;
Received: from [2001:4bb8:2dd:aa7c:2c19:fa33:48d4:a32f] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFSdI-0000000CZyr-2JmH;
	Fri, 07 Jun 2024 05:59:25 +0000
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
	Bart Van Assche <bvanassche@acm.org>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 02/11] block: remove the unused BIP_{CTRL,DISK}_NOCHECK flags
Date: Fri,  7 Jun 2024 07:58:56 +0200
Message-ID: <20240607055912.3586772-3-hch@lst.de>
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

Both flags are only checked, but never set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
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

