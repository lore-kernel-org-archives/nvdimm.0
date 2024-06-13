Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F8913D638;
	Thu, 13 Jun 2024 08:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718268545; cv=none; b=INYJ8+RwbU338eW5Aim5kOIt/dozD9bWO6ofWOIV128c4ry46TuLo+YAPzQOrW++PZz/G7Rc4WhD0n+8cgGFWsUqwqKqGhx+lStTKb30AeXVjkQHaQJBKn95EmB2tV6tdzGTTVG8YZKVgjZFK0bF1a1Dyar5nofHp99vuPhZjXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718268545; c=relaxed/simple;
	bh=F/1MQQShDSJD/gK5N087qOaFVu6MoKFEJeyGdkcOB8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fh57HWF4ZgvpUHBIkwZ7AIYn+VoJwVpz1xYzZv9eJVI7pm+RvgfzhkHUfC9R9QFkiVM/H96EAZjRm8s0rY5Khd3m3xzt7hu+O8FPgt9NVnXJxJxhU0aoNe9rPDZK+irsG8GkwkIq9QUbBZPFoMwU6wyVxIJL8FP7RyXHMtGNBWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a7W96mMd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a7W96mMd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nGuyiOBl2Ykuy06sJ8icqZroFJnpajRcLePB5KOCozE=; b=a7W96mMd/zBl3x3qK5ae2iE5mh
	dBVk1vNXaNs0MDmg9UOZhMMIKrC6JnQ6SRiVZbmcOy4NAAEx+ARH4L8Ip1VIRjbaf3Ft/k4U7ihep
	5CkeEKPoMmcpFfdCo5laEVxeskKQSFjwk1Jz+8iKSDgNSzR/PfpNuNfzPxSNMp1ucA7W47ZUXw5Jm
	83qC0kql2NHEklgzn1r+wboWzOBrvHUV6Mja0ZPlCNK+Pi/YbdLunhWrJ8D8HP4I88ffCV2Vh/P3x
	s3MXBV1D02jAZ9GIVCk80I6Kc1svMCD7UwegtJnTM/5xtCMNhHyFOuW/AvNGOfvW2yaVozvL0x2VH
	DRsgX6XQ==;
Received: from 2a02-8389-2341-5b80-034b-6bc2-b258-c831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:34b:6bc2:b258:c831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHg8h-0000000Fn9v-3LCS;
	Thu, 13 Jun 2024 08:49:00 +0000
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
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/12] block: remove the blk_flush_integrity call in blk_integrity_unregister
Date: Thu, 13 Jun 2024 10:48:16 +0200
Message-ID: <20240613084839.1044015-7-hch@lst.de>
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

Now that there are no indirect calls for PI processing there is no
way to dereference a NULL pointer here.  Additionally drivers now always
freeze the queue (or in case of stacking drivers use their internal
equivalent) around changing the integrity profile.

This is effectively a revert of commit 3df49967f6f1 ("block: flush the
integrity workqueue in blk_integrity_unregister").

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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

