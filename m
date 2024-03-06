Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886CE134406;
	Wed,  6 Mar 2024 14:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709735268; cv=none; b=g69NM4WTYq6jX9Bf/uuofRcehbJHGcNCOXnptgMwiBZpcrf3D+e3slhEScsFDP3B0wX2jFkZHGe900Tc/e4qs0bdrsOVdTR8o5S6Vw9qq7Ip132/YDc/jpFMZtUkWQm3cm18jC1Wd3N/RvTzLLiFWzP0JSSu1OLQQXrAmC7Dnd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709735268; c=relaxed/simple;
	bh=WKctsFuvD85D3fRuhGp6QYPq5a6g1pcdQ5RVJgdZ6ug=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EXLBe7ykZqDq2+TTDu5XuQNGxTUgZQH0LzmLgc0uwBS1yVyelrV0K3YCdP4YbMyY3jqfXuD7FzZ9UPLYS/HeUXIE7h+zm00w1UUGzKQMXgeIfU9sTofddpKKa4i4rMZo9N2KxxDyE55w6ItHhkqGJ68b+ZkXlSBACkTn+x3qSow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ROarDdF4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ROarDdF4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bBx9WnIjiiM48Ro1l0Aqdsfwar/iT/SNOe4p5i/wCH0=; b=ROarDdF4c2O7PInnKigIkM3beZ
	tTRm+hfXSPLlJ2G/XF+DdFdlsn0YghfqVQHg6jkhl087lOsQap2P3dZcAc8paNbeG0EqMF6VSu9Qj
	JBF1OnINlNj6/YrVNS4q5276YV1qf6Kp7odzC4e1SDgF6YJZSRmrMugl50AIpfI+VtmvQR1i11VaW
	15P//coD5mHxno6oT8Y/NlvGqbmuJv+JgqJLP5wH694vK1Pi7h4XDboslB4sRh7F/V7eeYATdYVHT
	1tbjw7NRldBRtb42NzOulTW27NceJBESnxf0n+cUsT1ly+bxyxguvZSI0d046mvPP/DHp2HzkAzTf
	Tv9Wfvhw==;
Received: from [66.60.99.14] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rhsFE-00000000ZZt-27Vq;
	Wed, 06 Mar 2024 14:27:44 +0000
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
Subject: [PATCH 3/3] dm-integrity: set max_integrity_segments in dm_integrity_io_hints
Date: Wed,  6 Mar 2024 07:27:39 -0700
Message-Id: <20240306142739.237234-4-hch@lst.de>
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

Set max_integrity_segments with the other queue limits instead
of updating it later.  This also uncovered that the driver is trying
to set the limit to UINT_MAX while max_integrity_segments is an
unsigned short, so fix it up to use USHRT_MAX instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index c5f03aab455256..a2e5cfe84565ae 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3419,6 +3419,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
 		limits->dma_alignment = limits->logical_block_size - 1;
 	}
+	limits->max_integrity_segments = USHRT_MAX;
 }
 
 static void calculate_journal_section_size(struct dm_integrity_c *ic)
@@ -3586,7 +3587,6 @@ static void dm_integrity_set(struct dm_target *ti, struct dm_integrity_c *ic)
 	bi.interval_exp = ic->sb->log2_sectors_per_block + SECTOR_SHIFT;
 
 	blk_integrity_register(disk, &bi);
-	blk_queue_max_integrity_segments(disk->queue, UINT_MAX);
 }
 
 static void dm_integrity_free_page_list(struct page_list *pl)
-- 
2.39.2

