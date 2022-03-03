Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E33F33C7
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9LmFtcgb40JuUqIFxAg6N2ciwS2XlpmGEkX88V9dA/4=; b=cyEyOWbBSKHt7zZgnBMQeyhZmY
	GRrNUMR1Ail8shG/vV4JSi23yHq2lyquEbZa3SPOCsB11vdUeF0JniSn/v/jVfam3l9vq5t6WYS1b
	Jg9O9UUy+m5LWCQK3pNUY8Exr5MzS2lYG4CVlk3b5GiC17EA48ll7i1WqNZbzGdFdISliqac2Dg1w
	UNg2ATUjIcWikV/cyYq4GzjWCrPoe1JeTLIn9Oimp7ikGJHW0v5wV7TsYjDRj6cCpWGh73TqPAqK2
	IqwIoF6ijPqaIx6tBZT6QmcfdOL2XpKIz3kPkxJnChwR4XF+f+O9z/pdzOMxoPqir44zpTM6aeahd
	yW6Tn8FQ==;
Received: from [91.93.38.115] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nPjV7-006C6F-GQ; Thu, 03 Mar 2022 11:20:06 +0000
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
Subject: [PATCH 07/10] bcache: use bvec_kmap_local in bio_csum
Date: Thu,  3 Mar 2022 14:19:02 +0300
Message-Id: <20220303111905.321089-8-hch@lst.de>
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

Using local kmaps slightly reduces the chances to stray writes, and
the bvec interface cleans up the code a little bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/request.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 6869e010475a3..fdd0194f84dd0 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -44,10 +44,10 @@ static void bio_csum(struct bio *bio, struct bkey *k)
 	uint64_t csum = 0;
 
 	bio_for_each_segment(bv, bio, iter) {
-		void *d = kmap(bv.bv_page) + bv.bv_offset;
+		void *d = bvec_kmap_local(&bv);
 
 		csum = crc64_be(csum, d, bv.bv_len);
-		kunmap(bv.bv_page);
+		kunmap_local(d);
 	}
 
 	k->ptr[KEY_PTRS(k)] = csum & (~0ULL >> 1);
-- 
2.30.2

