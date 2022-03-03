Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF1233C7
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 11:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UaLkM9d2e/Rtz8iJbPdrKJftE3tucWBaeY/oAyYvKbs=; b=q17kpGrSmWHzWFrYFzz3RSj0Ma
	ACac794xzvKoWj1VmHSwiQJtBODXCLZsUG4TdYCMYOtZKaQ0VI4dAsqq62XKOU98kJpXZaXxwTFeC
	YWfrjfy3HhAAARtX9VfXEnq/fN7SQ2cGN1rLTyNYkTYDLzRuIIFkMPuFMR2V+EL1wbI1RxbkzkGv7
	SLax6LCSra7cCIWU9nev7pADx/K3i9uvk28MABKSbMBVI/nIu6CH/FVEPHlyE06Rej0c9K9au8TFU
	ANUrN0F5Wj0Bb/BHwqgfA10nBUrawNqdngkWo4c1cAW5gW2GlJoup63gRdfA7vZ0vtXc29PQtvXb5
	mdM1M/bw==;
Received: from [91.93.38.115] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nPjUd-006Bvp-Ce; Thu, 03 Mar 2022 11:19:37 +0000
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
Subject: [PATCH 02/10] aoe: use bvec_kmap_local in bvcpy
Date: Thu,  3 Mar 2022 14:18:57 +0300
Message-Id: <20220303111905.321089-3-hch@lst.de>
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
 drivers/block/aoe/aoecmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index cc11f89a0928f..384073ef2323c 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1018,9 +1018,9 @@ bvcpy(struct sk_buff *skb, struct bio *bio, struct bvec_iter iter, long cnt)
 	iter.bi_size = cnt;
 
 	__bio_for_each_segment(bv, bio, iter, iter) {
-		char *p = kmap_atomic(bv.bv_page) + bv.bv_offset;
+		char *p = bvec_kmap_local(&bv);
 		skb_copy_bits(skb, soff, p, bv.bv_len);
-		kunmap_atomic(p);
+		kunmap_local(p);
 		soff += bv.bv_len;
 	}
 }
-- 
2.30.2

