Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4703A66A8
	for <nvdimm@lists.linux.dev>; Tue, 22 Feb 2022 15:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dGQhQIoPlJnqAUJc5vnifIiGA4K4POjXLxE/uOxiIoI=; b=sbIZXXAIiSWc4J9AC0uUzCEZgE
	GMG40sphecLF+zJ9TgZC7QpQWNY4X6SKTT3/+29Z/ojTMZ2XeRjBVCxNEkRku2/IbDzEydM9dsIhH
	sZvZdW8mNY2eNTK9+4ZCzcuaiiXomF6TeNmJ4sC0k3/xsHt8Gnn8LUmG8Tzc0BVk28t7TJlhYXHAm
	UP3xQNnjfaOrs2ZSA6D6BZoAevyaOBvW/WgRJsI/QUi6LxsWuudhuYVVUNmc3ln0RcEIWOS5yGuWY
	qwUGdF3jRwL4KUK09Nqn0sMjjOK8RWXwkpOWiEY8v0eHQbGQk1jqpzR9iYbwBSixXPZHqNkteV/ao
	6uai2Qaw==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nMXSR-00APrX-8g; Tue, 22 Feb 2022 15:52:07 +0000
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
	linux-xtensa@linux-xtensa.org,
	linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [PATCH 03/10] zram: use memcpy_to_bvec in zram_bvec_read
Date: Tue, 22 Feb 2022 16:51:49 +0100
Message-Id: <20220222155156.597597-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222155156.597597-1-hch@lst.de>
References: <20220222155156.597597-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use the proper helper instead of open coding the copy.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/zram/zram_drv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a3a5e1e713268..14becdf2815df 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1331,12 +1331,10 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 		goto out;
 
 	if (is_partial_io(bvec)) {
-		void *dst = kmap_atomic(bvec->bv_page);
 		void *src = kmap_atomic(page);
 
-		memcpy(dst + bvec->bv_offset, src + offset, bvec->bv_len);
+		memcpy_to_bvec(bvec, src + offset);
 		kunmap_atomic(src);
-		kunmap_atomic(dst);
 	}
 out:
 	if (is_partial_io(bvec))
-- 
2.30.2

