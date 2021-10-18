Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0096472
	for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 06:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3+FGJi6IM41D9JDLa5YOcSmHyG9/MU1048072vzODlc=; b=yQQ46UcRwV4BDZlkaPR0VGTRxp
	iaPKLOAPQgm4bBlWxUW1GX6JqY5nSb+zTKoHMy6C9dVYZRuCP3aLNLjjzyAACdSk0r2nQS14JWvvO
	izz0kMCO21CUoitWr0x4SDRCLVtrJEV17CThzClxNAXtsxr4hiO6ct1g8ITx6Erx++DCVzMY0jfXd
	DZfPjns5MDP+ffSJCIDjaTW9AbC9CSP7wGgVwmX7lQZ87F+U4IWAAV1Oz5k0PNHS8CexgZq/GpKuN
	hliFRFlcI7Cpiemsl0KekHq8xxpbu8pxG8OGsOmuzUWfTBGMjNtG7CJbXQVGtM1QkJ7HSrJ5MUdCv
	H4LozXEg==;
Received: from 089144211028.atnat0020.highway.a1.net ([89.144.211.28] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mcLtF-00EHsH-VW; Mon, 18 Oct 2021 06:12:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev
Subject: [PATCH 2/2] nvdimm-btt: use bvec_kmap_local in btt_rw_integrity
Date: Mon, 18 Oct 2021 08:12:44 +0200
Message-Id: <20211018061244.1816503-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211018061244.1816503-1-hch@lst.de>
References: <20211018061244.1816503-1-hch@lst.de>
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
index 92dec49522972..9c3871b713655 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1164,17 +1164,15 @@ static int btt_rw_integrity(struct btt *btt, struct bio_integrity_payload *bip,
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

