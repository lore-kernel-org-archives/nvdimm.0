Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E64014E2F7;
	Fri,  7 Jun 2024 05:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717739980; cv=none; b=L3y36CAVLAXa24HcH47TLfPvGnNWXX/59lvUr/cUuc34yV8vvYSxt97wnkY/KUPdQNtFsbVqo2+MKmJOlHlXWZfwq2br7weBpsLQXW0tF7VqJZBXv5CSdJAhsIH1ICPx7HJskUigCfJns39+NDKa+wWjpb4OtT1M3M74JCeyNtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717739980; c=relaxed/simple;
	bh=prMMtaDXppWsNw2oy/gt4Rw4ma5bbbddHPw6icKallg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rA4QDqtZg+nPYaRP0/aYs1gMM1/NbrOlLmUVZ09azM4SX69jn54NxKaQQYcZpZ7bBL058J4W/G8SwWI5l8DBy+U3ARuFXcIW/C2LLZRVikgPRUrA6wVDJ6wUoNvd8EuELr4E+2tZL5dRKkuiHNzaOyGwOc1xAye3pWu77KHGJcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AUioaVPJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AUioaVPJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3y4kwZJ7diC3CGoDBckXwl/3t6sgTYlN0/GBRH2YxJ8=; b=AUioaVPJApS177FNLesJ57PcWG
	RI6vYP2h0VHTCfX4vXCYTAsRPbfD24LVy+pFI5y1850BKzepNU1lNlHA6hYSNGputg5dkpltimXyy
	HVrnQhO/owHdXh+AzNUkTucdBzqdJEWNItpaQ62Jeu0w65H3mFewfVQHOH08Ry1WaqwPAr4OVGh9b
	8/sTPXSyjHRbsSTGnZjDftSFeFrDTXLKHNuRZFo0nYbG8hhONBM9P2dUyDHRUBpAsiOJk+0pZ4q/c
	+/s0GCX2gtRCapyYh8gdiN06rtiRiaI5gJ8lXwJjaw2T95+YTNGtIJRkuEha59jgHrr9rDQ9qiDtZ
	JafHjVmQ==;
Received: from [2001:4bb8:2dd:aa7c:2c19:fa33:48d4:a32f] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFSdT-0000000Ca0Z-29Fg;
	Fri, 07 Jun 2024 05:59:36 +0000
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
Subject: [PATCH 05/11] block: remove the blk_flush_integrity call in blk_integrity_unregister
Date: Fri,  7 Jun 2024 07:58:59 +0200
Message-ID: <20240607055912.3586772-6-hch@lst.de>
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
index 17d37badfbb8bc..24f04575096d39 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -401,8 +401,6 @@ void blk_integrity_unregister(struct gendisk *disk)
 	if (!bi->tuple_size)
 		return;
 
-	/* ensure all bios are off the integrity workqueue */
-	blk_flush_integrity();
 	blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 	memset(bi, 0, sizeof(*bi));
 }
-- 
2.43.0

