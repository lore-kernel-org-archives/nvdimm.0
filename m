Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D670B18F2CA;
	Wed,  5 Jun 2024 06:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569056; cv=none; b=mlKJEM7eb0cleUvXZS33uHbe07xQrpGzBTTjICiXoswG0ULIfrUC10b9gpqc5pUbAEtOaFoK7LbPKT6OM3Kz27R8ecNkzZ+/ixTfe6zdvk1JlkI5b/Fm/hx0auzUxu+JHUzNfKo3/Aol8vY3Zvb5yOkCpI2MSU1b0bsI99HSXqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569056; c=relaxed/simple;
	bh=AEn53m6eZXlMyaUdBMxrfHtfODRbnzvSjCArsYR4y48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qu9wt6PgDbDzkw+7ck5sFJGNUbjz899vZAj2B5piTacISUJXDWpyV38JlSPRMghr+5Zq8g/Eg1iNV17bdKLPMhEYh/HkMtz4AEWqAFzcrcmz0zbnGrcn+NJdPp5vWGZDHGkygbYIMOW5Ixjxm08WUT/N1hxabMz29v1ozQT+Sqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jxJ5RpUW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jxJ5RpUW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9Iknt65J8IoGgWlf8Jkj5epH4ik0Y7ILQuQDCN9Yr5o=; b=jxJ5RpUWqiAr/XCCprUskgUvmB
	G0KTbpAA4CAoywKLAakwglpIcCvgZHmoaZ/0QgDz1/WjTqNak/biyF9KvxsOBeq4Z74pOjiSIMIBF
	ExEl+FqXXl818TxIu56W+WaVRcEqLKdfwLTFZIwKjbKNhN8Rh/aBrDUupuPAbstreSbeBFxgGTbYa
	/MaNhiPk4iMSgJcXt+fD1X+u8UlLHUnvZvZOueqeIETpo0LWZfXlFuYDKHL07JpLtiJEb/P5RK6Gv
	YOw8V2iAzLcrfKA23kMJy9Adk9NhnKESeMp5C38r/08TXCUch+/BAr2mw0W6vP+x3wVJU2rpw1cDw
	qpfr4gLw==;
Received: from 2a02-8389-2341-5b80-5bcb-678a-c0a8-08fe.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5bcb:678a:c0a8:8fe] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEkAb-00000004maW-0azi;
	Wed, 05 Jun 2024 06:30:49 +0000
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
Subject: [PATCH 05/12] block: remove the blk_flush_integrity call in blk_integrity_unregister
Date: Wed,  5 Jun 2024 08:28:34 +0200
Message-ID: <20240605063031.3286655-6-hch@lst.de>
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

Now that there are no indirect calls for PI processing there is no
way to dereference a NULL pointer here.  Additionally drivers now always
freeze the queue (or in case of stacking drivers use their internal
equivalent) around changing the integrity profile.

This is effectively a revert of commit 3df49967f6f1 ("block: flush the
integrity workqueue in blk_integrity_unregister").

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-integrity.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 4767603b443990..e11b815c03c981 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -399,8 +399,6 @@ void blk_integrity_unregister(struct gendisk *disk)
 	if (!bi->tuple_size)
 		return;
 
-	/* ensure all bios are off the integrity workqueue */
-	blk_flush_integrity();
 	blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 	memset(bi, 0, sizeof(*bi));
 }
-- 
2.43.0

