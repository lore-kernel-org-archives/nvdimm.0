Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8F83FD2
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 19:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vzfFGe77MiDtDAcsNEd4FFV6XUqpkLp7v2/+XiGswys=; b=isst7bA45MsJEBHCIhkJx6Kczq
	YrMi78bLRt5qELgdWgY6H9Mgp+37YNSRQsfgXi4VM1MADrofBM9ydqTVaHxK/Mb9PPst7iuahgypW
	86DjV+a3MdG1nqOFP2e9R/7/LoExU5RNSDgYWGFgZgOsn7cQGQmZmFVdsFt4b04RdjQi64HPxJC2Y
	TblDGK95B8LHVKYy5XjvUnNc7qRElN1IbsJ8V/4QSvZhz1Hefy4ZsPtYLUyEbJYVsV0jlytxSkfZi
	zdJLho+9svAaFsXC7A1pCEYiKEfCX1LVke+8CZuMNuC9thfpCFfwoMaHUOqgBZMY2OR0ZgHbFRARA
	7BULMVAA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mJhMg-00D5Aq-W4; Fri, 27 Aug 2021 19:18:11 +0000
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
Subject: [PATCH 01/10] block/brd: add error handling support for add_disk()
Date: Fri, 27 Aug 2021 12:18:00 -0700
Message-Id: <20210827191809.3118103-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827191809.3118103-1-mcgrof@kernel.org>
References: <20210827191809.3118103-1-mcgrof@kernel.org>
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
 drivers/block/brd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 58ec167aa018..c2bf4946f4e3 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -372,6 +372,7 @@ static int brd_alloc(int i)
 	struct brd_device *brd;
 	struct gendisk *disk;
 	char buf[DISK_NAME_LEN];
+	int err = -ENOMEM;
 
 	brd = kzalloc(sizeof(*brd), GFP_KERNEL);
 	if (!brd)
@@ -410,14 +411,19 @@ static int brd_alloc(int i)
 	/* Tell the block layer that this is not a rotational device */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, disk->queue);
-	add_disk(disk);
+	err = add_disk(disk);
+	if (err)
+		goto out_cleanup_disk;
+
 	list_add_tail(&brd->brd_list, &brd_devices);
 
 	return 0;
 
+out_cleanup_disk:
+	blk_cleanup_disk(disk);
 out_free_dev:
 	kfree(brd);
-	return -ENOMEM;
+	return err;
 }
 
 static void brd_probe(dev_t dev)
-- 
2.30.2

