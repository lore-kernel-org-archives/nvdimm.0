Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C636D33C7
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 11:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=f0NF498hDCrz75r99TeO+EjHW8Kl3t4Al355uemFwlc=; b=RVOdlleVMmPeGVGcENHOikaH2i
	7Mg7a3r5ZsNimKQNjNjUdz+dBEvY74g/2YuUfrhXXeY82u0nOJh5dqnSvZ7MjAkpeuzfafD4K8nrH
	nUhYYmYoW8+owYQfnl2namiS43Flj/gA7fD1HW2ssydHjwNvxfgQYFE9oh7yZzgr1yqUxVbFO1Qa4
	QG4EdejeAkiXorKBxaeO0u0z7IesuDHtskS2ha5fI6q/sdOuUZ3H+A9Ag3/1UiGxFCz9KduewFgBz
	H5faGUBrRUw8xfeUWUdQlveadnRzGWgx688uz514t7O7ywyCkE44R+rL3Iq4E6fy3KjUbvP932vA7
	vQ+9OTiw==;
Received: from [91.93.38.115] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nPjV0-006C3h-15; Thu, 03 Mar 2022 11:19:58 +0000
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
Subject: [PATCH 06/10] nvdimm-btt: use bvec_kmap_local in btt_rw_integrity
Date: Thu,  3 Mar 2022 14:19:01 +0300
Message-Id: <20220303111905.321089-7-hch@lst.de>
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
 drivers/nvdimm/btt.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index cbd994f7f1fe6..9613e54c7a675 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1163,17 +1163,15 @@ static int btt_rw_integrity(struct btt *btt, struct bio_integrity_payload *bip,
 		 */
 
 		cur_len = min(len, bv.bv_len);
-		mem = kmap_atomic(bv.bv_page);
+		mem = bvec_kmap_local(&bv);
 		if (rw)
-			ret = arena_write_bytes(arena, meta_nsoff,
-					mem + bv.bv_offset, cur_len,
+			ret = arena_write_bytes(arena, meta_nsoff, mem, cur_len,
 					NVDIMM_IO_ATOMIC);
 		else
-			ret = arena_read_bytes(arena, meta_nsoff,
-					mem + bv.bv_offset, cur_len,
+			ret = arena_read_bytes(arena, meta_nsoff, mem, cur_len,
 					NVDIMM_IO_ATOMIC);
 
-		kunmap_atomic(mem);
+		kunmap_local(mem);
 		if (ret)
 			return ret;
 
-- 
2.30.2

