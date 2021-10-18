Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8EB72
	for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 06:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+GpRwcejqsFdsx9C7nKyM7dyseCShfi+ROJEBwTAmCo=; b=UuY5U6VavAoepaIUdPGAkkCYO8
	NqZK2tiLksG8C9fGRS6//eOPwIpuBp7Q0VJPKP0hZFCjL3SbBguIAh7T3UHbvPwzdHJ1At7oAZxhp
	EX4jH4zCOW6TYM4G259rAPrwQnQrx2OR5+tSrgRvCJRdnQFE2kCvhzjpVrAlxrBHBcE1O6daKj3hX
	YGvm0ugSVFhnYO8ubfDf5bZ2hmmO7vmhDJ9G6+/WL8qnlzsT5kFeBQyXdE9rKh0XoS94cdXc/7h/R
	IYS39ZC4c0WdA1qJG1QcfCDPFL5pdSg7cgrhSkEgR+xwwiZXyXwUmn00q5DKBfkUJaOqd7jo93u4d
	LHYQ7eTg==;
Received: from 089144211028.atnat0020.highway.a1.net ([89.144.211.28] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mcLtC-00EHrp-NS; Mon, 18 Oct 2021 06:12:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev
Subject: [PATCH 1/2] nvdimm-blk: use bvec_kmap_local in nd_blk_rw_integrity
Date: Mon, 18 Oct 2021 08:12:43 +0200
Message-Id: <20211018061244.1816503-2-hch@lst.de>
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
 drivers/nvdimm/blk.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 088d3dd6f6fac..1e96b377a7979 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -89,10 +89,9 @@ static int nd_blk_rw_integrity(struct nd_namespace_blk *nsblk,
 		 */
 
 		cur_len = min(len, bv.bv_len);
-		iobuf = kmap_atomic(bv.bv_page);
-		err = ndbr->do_io(ndbr, dev_offset, iobuf + bv.bv_offset,
-				cur_len, rw);
-		kunmap_atomic(iobuf);
+		iobuf = bvec_kmap_local(&bv);
+		err = ndbr->do_io(ndbr, dev_offset, iobuf, cur_len, rw);
+		kunmap_local(iobuf);
 		if (err)
 			return err;
 
-- 
2.30.2

