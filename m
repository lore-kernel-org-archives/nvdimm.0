Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DAA2C98
	for <nvdimm@lists.linux.dev>; Wed,  3 Nov 2021 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=5/Oh1CS9h71CIsJQovdYgXMSqtjiHo7nIH5ykNGJtKs=; b=ynjSlN6AFWr6IdwjHSC6Q/CWRL
	+7F70cvZLbDS+Dmwx6n96R78bNWdSaN4Z1tcOcrrhLzx/XpjEjjp/TLpHSGH7unZM7mxi83Ig88Zo
	ifTakid922yfGkA6YGf/yoHcOXMtQQl3bLVN5XLx0ns7UAuh7/2DBEZQDD/NeKzClH4kX8kH6dbqm
	h6Kx01Wwfq2TTT2/fgiKfta6NDek+rrjbJG5WVdFxQBCMLjOOjlqP56N3lXswLEZebHaSqouB2ru0
	/UbGR985Qb9c5KwMp50T8qOEscMreqol4bEo5yUigigDNitjGKb0Z82NgGmGpo/A8EepRL76nVSCu
	twPVGz8w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1miJb2-005sm5-M8; Wed, 03 Nov 2021 16:58:44 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk,
	hch@lst.de,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	mcgrof@kernel.org
Cc: linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] nvdimm/btt: do not call del_gendisk() if not needed
Date: Wed,  3 Nov 2021 09:58:43 -0700
Message-Id: <20211103165843.1402142-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

del_gendisk() should not called if the disk has not been added. Fix this.

Fixes: 41cd8b70c37a ("libnvdimm, btt: add support for blk integrity")
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---

This v3 just makes it clear that this is just wrong regarless of the
kernel, and adds Christoph's Reviewed-by tag.

 drivers/nvdimm/btt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index f10a50ffa047..a62f23b945f1 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1537,7 +1537,6 @@ static int btt_blk_init(struct btt *btt)
 		int rc = nd_integrity_init(btt->btt_disk, btt_meta_size(btt));
 
 		if (rc) {
-			del_gendisk(btt->btt_disk);
 			blk_cleanup_disk(btt->btt_disk);
 			return rc;
 		}
-- 
2.33.0

