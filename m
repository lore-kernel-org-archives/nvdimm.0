Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7092CA2
	for <nvdimm@lists.linux.dev>; Fri, 15 Oct 2021 23:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RKU66AnJzLKhhgSWEHLOfZ4aIkidqzrddEWqP9yNa3s=; b=UugAONMm6/wnZ05Z4bZ9yyKh6X
	KFV4rfmmnHgothVOIuV/TFKkY1zNfOQBPL40cl4mER4xCUNxb2kIwEVMH6FLMJx6LKFtVgONty1oN
	dd7CTQ1YT6LhT1cPhh7gSo5vwFx8mn4XGoXURPXq9roHayZCz6yjgwG5FrlmZNL/NOdsBYUyLts2B
	sOytoWSq1Fhn1N0j8GABu++u+OMc++l8EodzqQk5+nEtN9wK4dpOCeiQHOZb285rkxlJE17nVdwOd
	ih74ELEhzbUwySf+C/0rLdDXm4hUhncMAhRqDJAtUJ0f2Nh7q5dpKI8TT3TfLGIqfXNtkbm7ijxSn
	GCFn5W/A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mbWzt-009C33-3r; Fri, 15 Oct 2021 23:52:21 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk,
	geoff@infradead.org,
	mpe@ellerman.id.au,
	benh@kernel.crashing.org,
	paulus@samba.org,
	jim@jtan.com,
	minchan@kernel.org,
	ngupta@vflare.org,
	senozhatsky@chromium.org,
	richard@nod.at,
	miquel.raynal@bootlin.com,
	vigneshr@ti.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me
Cc: linux-block@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-mtd@lists.infradead.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 05/13] nvdimm/btt: add error handling support for add_disk()
Date: Fri, 15 Oct 2021 16:52:11 -0700
Message-Id: <20211015235219.2191207-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015235219.2191207-1-mcgrof@kernel.org>
References: <20211015235219.2191207-1-mcgrof@kernel.org>
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

