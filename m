Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4297F6D17
	for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 22:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RKU66AnJzLKhhgSWEHLOfZ4aIkidqzrddEWqP9yNa3s=; b=DlwowCHOstgFTHo1OasqvBBrRA
	Ln5Lnf/XerBeGqMUcmhKvtfbTCWtF7GYSUu6/OOKkAt4grh0hFRd5deBekspTSIWg8AjRZ2eeZKUD
	6NbxnpIf/ny+fShWjWFE6NSx57iAqpvB2STaOYmGxyb8gkLmyIU2giqEJ/wc7Q+0HvyHInp4oNX0U
	bQN6nQAoBsEQtyjaUCBNU3TPonPPX0fO9u+NSEcfBEKREBZlbiBhi12yjpAEzm6ia6MdWXUqfZHUV
	P/j52UBMOkCxN2xoIsyxrUw2HuJVLpC29l30Op1PLWCmJ9OOvtEigV+Jc9XvZfDpXkyxXLigTBOU0
	B5Qzou+A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mUyfw-004SvC-K7; Mon, 27 Sep 2021 22:00:40 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk,
	colyli@suse.de,
	kent.overstreet@gmail.com,
	kbusch@kernel.org,
	sagi@grimberg.me,
	vishal.l.verma@intel.com,
	dan.j.williams@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	konrad.wilk@oracle.com,
	roger.pau@citrix.com,
	boris.ostrovsky@oracle.com,
	jgross@suse.com,
	sstabellini@kernel.org,
	minchan@kernel.org,
	ngupta@vflare.org,
	senozhatsky@chromium.org
Cc: xen-devel@lists.xenproject.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 06/10] nvdimm/btt: add error handling support for add_disk()
Date: Mon, 27 Sep 2021 15:00:35 -0700
Message-Id: <20210927220039.1064193-7-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210927220039.1064193-1-mcgrof@kernel.org>
References: <20210927220039.1064193-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvdimm/btt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 23ee8c005db5..57b921c5fbb5 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1542,7 +1542,9 @@ static int btt_blk_init(struct btt *btt)
 	}
 
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
-	device_add_disk(&btt->nd_btt->dev, btt->btt_disk, NULL);
+	rc = device_add_disk(&btt->nd_btt->dev, btt->btt_disk, NULL);
+	if (rc)
+		goto out_cleanup_disk;
 
 	btt->nd_btt->size = btt->nlba * (u64)btt->sector_size;
 	nvdimm_check_and_set_ro(btt->btt_disk);
-- 
2.30.2

