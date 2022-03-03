Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A7433C7
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 11:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dqHSTa5nX0hxYK3KYYVcQs7zhdjSLCR3fiKudpXZiV4=; b=Pllje23oI7gKtOYg1/Im2uld14
	YiK+VQQ83xUEpBKZhxadR55eyks86GETAhyuy2eReyxklCCnmTPEAcoR4JPImPzXobOxxBZsd/Rup
	uoVPrUQ9M4HId0fA6B8PrwP7ljDm3tCg+LZucJSavE0crc05wpe7mYT6yLv0gLpRBXSFBzIs1Mu6i
	N4GxNEmjxvNkfeLI0U7nbus0rZudT+ShhqrlKnuZkrx7D3v2KODNlYaKYFjZeZejbjc/67P6vEYqp
	/aMq7sfBA+CFFR2WItLpK7ci5WI21oNMZCqgkDJOrvp/wEeAUOnZ9F+hZBMZ571GNU87SlCFiTHoB
	G4btDG2Q==;
Received: from [91.93.38.115] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nPjUq-006C0F-1x; Thu, 03 Mar 2022 11:19:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Justin Sanders <justin@coraid.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Denis Efremov <efremov@linux.com>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Coly Li <colyli@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	linux-xtensa@linux-xtensa.org,
	linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [PATCH 04/10] zram: use memcpy_from_bvec in zram_bvec_write
Date: Thu,  3 Mar 2022 14:18:59 +0300
Message-Id: <20220303111905.321089-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220303111905.321089-1-hch@lst.de>
References: <20220303111905.321089-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use memcpy_from_bvec instead of open coding the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/block/zram/zram_drv.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 14becdf2815df..e9474b02012de 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1465,7 +1465,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
 {
 	int ret;
 	struct page *page = NULL;
-	void *src;
 	struct bio_vec vec;
 
 	vec = *bvec;
@@ -1483,11 +1482,9 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
 		if (ret)
 			goto out;
 
-		src = kmap_atomic(bvec->bv_page);
 		dst = kmap_atomic(page);
-		memcpy(dst + offset, src + bvec->bv_offset, bvec->bv_len);
+		memcpy_from_bvec(dst + offset, bvec);
 		kunmap_atomic(dst);
-		kunmap_atomic(src);
 
 		vec.bv_page = page;
 		vec.bv_len = PAGE_SIZE;
-- 
2.30.2

