Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BB6130AFE;
	Wed,  6 Mar 2024 14:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709735265; cv=none; b=mVbd+BKmyN+OIG+VGDO0ufFlEY4eZQ2pbmT/a1ASWW5CXdv4jEA/YMulopuxBsNcbL93C6yjBli0Xmt+qa+ncYFOUuH5MYnP/0joJuIHrqZlVyQDHXy/pPaxxgs+miHHSB3NYeQXHp6tOgDzoQN8Gs0b4u05DBcLseapaKT/PA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709735265; c=relaxed/simple;
	bh=UrWkOmZlhCVBmtB1cFvn97egQ0Ppz9yAVmuoxkGQllA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N3kGvxeDrMAa+RIdZlgbNF7dtoAVxIxVWSbEKFT/3+OMbEchaSEolrHEuDjBvmuS9UriNbFfI6mTOUERsGVEZd8UdXr3r7mmZblY76+hiH2Z8In8oBCnlCXU8ZfX7SdRmV36C1/k8Di1LIoWBhyqS3vHAnEVT0qGxpN5+e50zcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eXK5r8cj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eXK5r8cj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ChKw5yBvs8xJM9AlLiVgQQrnwuxqlKlAdHIEJ3JxQ5k=; b=eXK5r8cjZUtx80XXgx19F3a8am
	RlArqrEhuSQIrQlVY3zCSIbqjxR8TlXG8MBEvPZjHuvJHRW4rkKXqof+eO3ocmymW1WtxNKr32nef
	ZehiwSEArOURIxi9k4yrzNG7DMvJq3ikAhwVRQuB1aB0U+LctI7Ijy1ANNbnx5loLjH83dbocCuOy
	DIQtqTYQE/4kjBDtKoyaikxSCq6rkFakzpoVA33sBrivt4P0qDpSXTpV/nIhcnEb14wkZ3VQ8h+NY
	DX5aJN/VhaN2Ix4AwxmyZfIXCb3AfBDVJGXHW3u7EPQA1+O3A0Q2f9ig2IJPoDlVEmb7JhMnBW/1E
	001GdkKQ==;
Received: from [66.60.99.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rhsFC-00000000ZZD-47rj;
	Wed, 06 Mar 2024 14:27:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH 2/3] nvdimm/btt: always set max_integrity_segments
Date: Wed,  6 Mar 2024 07:27:38 -0700
Message-Id: <20240306142739.237234-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240306142739.237234-1-hch@lst.de>
References: <20240306142739.237234-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

max_integrity_segments is just a hardware/driver limit and can be safely
set even when integrity data is not supported.  Set it in the initial
queue_limits passed to blk_alloc_disk to simplify the driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvdimm/btt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 8e855b4e3e383a..1e5aedaf8c7bd9 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1500,6 +1500,7 @@ static int btt_blk_init(struct btt *btt)
 	struct queue_limits lim = {
 		.logical_block_size	= btt->sector_size,
 		.max_hw_sectors		= UINT_MAX,
+		.max_integrity_segments	= 1,
 	};
 	int rc;
 
@@ -1521,7 +1522,6 @@ static int btt_blk_init(struct btt *btt)
 			.tag_size	= btt_meta_size(btt),
 		};
 		blk_integrity_register(btt->btt_disk, &bi);
-		blk_queue_max_integrity_segments(btt->btt_disk->queue, 1);
 	}
 
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
-- 
2.39.2

