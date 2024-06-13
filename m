Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC7B140383;
	Thu, 13 Jun 2024 08:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718268532; cv=none; b=JL+gJxeAeVAwEK06gkGlNiiKv/ECiqHqXVrGyo1bMQwZRA4pfsphsHHIN78nRzwGnGX3aaixcQfJINZMA+gLCRX4P9tW03Dyr25lML+epBJ0V+0jtIkiWy0W/+KmQ7Kvffym4LndmPLXuJGcD0K57L0zdDrBze91kWnAKSRqzJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718268532; c=relaxed/simple;
	bh=yY0uNbPQOrufhgaQFeATHZ7HMCnS3ncNTc56pLNjK4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTv6VqO8vLACAJ2f52CqaymoOJSjke4KOfjbmcE33wVmZmW/PsHpBhrr3n+vS3BpNfr/jgfTWoFL7Kqws+yws1NunRO1R9aF3DKOJNgbePPPiPcxrEbhnr/AiEUcZrra+D3lkPf3dU0BnB7oNeAxF/XwHStN5BOM/AjStoBzGwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I7LXmgpQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I7LXmgpQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ru6e7QlCJJG/gBR+o3ggbDTJvKsMm+SRm2m/B6Mvy6c=; b=I7LXmgpQPJq0TW6SDVCQG+b7jq
	gGB5H/z2MbKT4p1ezib//uSwoqZDdJ2wub196VzhGlmy2nfmJyw4mG6RgRJF7mSww+BnTf0lnzyGq
	aM1vSjmSSWZDLlH8lq58pYAQjQW34vNKg1v9NxJgv3SzbR04kw3WBv0D6qZHPJd8URhnI/99oy0/d
	EoOEh6gQQPIXxIcW3RcHK/lqMUPE2EgWJE4TVBXm7gbRZXAjnhp/vZ6F9h4spVcQMsTG42pry/IrO
	hMoMPs8/VeEOdBXk9FtTN7pivCxquv5pq2/Gcq/a994Bs3wX09UQO3GYMfLlOmaoS+a/EuaIlfnfe
	6yc1coPA==;
Received: from 2a02-8389-2341-5b80-034b-6bc2-b258-c831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:34b:6bc2:b258:c831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHg8S-0000000Fmzb-4BDW;
	Thu, 13 Jun 2024 08:48:45 +0000
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
Subject: [PATCH 01/12] block: initialize integrity buffer to zero before writing it to media
Date: Thu, 13 Jun 2024 10:48:11 +0200
Message-ID: <20240613084839.1044015-2-hch@lst.de>
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

Metadata added by bio_integrity_prep is using plain kmalloc, which leads
to random kernel memory being written media.  For PI metadata this is
limited to the app tag that isn't used by kernel generated metadata,
but for non-PI metadata the entire buffer leaks kernel memory.

Fix this by adding the __GFP_ZERO flag to allocations for writes.

Fixes: 7ba1ba12eeef ("block: Block layer data integrity support")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 2e3e8e04961eae..af7f71d16114de 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -432,6 +432,7 @@ bool bio_integrity_prep(struct bio *bio)
 	unsigned long start, end;
 	unsigned int len, nr_pages;
 	unsigned int bytes, offset, i;
+	gfp_t gfp = GFP_NOIO;
 
 	if (!bi)
 		return true;
@@ -454,11 +455,19 @@ bool bio_integrity_prep(struct bio *bio)
 		if (!bi->profile->generate_fn ||
 		    !(bi->flags & BLK_INTEGRITY_GENERATE))
 			return true;
+
+		/*
+		 * Zero the memory allocated to not leak uninitialized kernel
+		 * memory to disk.  For PI this only affects the app tag, but
+		 * for non-integrity metadata it affects the entire metadata
+		 * buffer.
+		 */
+		gfp |= __GFP_ZERO;
 	}
 
 	/* Allocate kernel buffer for protection data */
 	len = bio_integrity_bytes(bi, bio_sectors(bio));
-	buf = kmalloc(len, GFP_NOIO);
+	buf = kmalloc(len, gfp);
 	if (unlikely(buf == NULL)) {
 		printk(KERN_ERR "could not allocate integrity buffer\n");
 		goto err_end_io;
-- 
2.43.0

