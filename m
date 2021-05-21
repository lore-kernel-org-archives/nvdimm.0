Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D462B6D2B
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 05:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=olD4OgK2KF5fFyq1tEltOxqBbYfQh1D4rklkKMzlmHs=; b=UD/0LEaV1cm5W5ZxlVCa7KhV95
	2qNjXUyoTdc8btZ/Qdd6o0HuvQDLaRzWE+FLgP+XrZ/tbaOGtBwgJv3OmslsL8h1V1RL0p0txxZ6E
	AYnz0FnLxIDWgJ4hDcEEqqIU9T+piJIyUj9dXaS0waDT4PZUL31f+FSuZpKVYXIZL6ie0bGqgxFNh
	cUgVv5K33KF5tY/PrA/QRYuQGZw4zPdQF8V7K5j1DKa9oOkBr+z9e24OZl9syUqNpJtXqz4s9mhFA
	hjfA5iD6ciKm7Otcab5vvxbjBB1VafIytWgz0BbYHICvTCasRZErbDo1EkPL+lf//390Mc3wbaafa
	8VYmzzCw==;
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy5P-00GqEo-26; Fri, 21 May 2021 05:52:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Jim Paris <jim@jtan.com>,
	Joshua Morris <josh.h.morris@us.ibm.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>,
	Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>,
	Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-block@vger.kernel.org,
	dm-devel@redhat.com,
	linux-m68k@lists.linux-m68k.org,
	linux-xtensa@linux-xtensa.org,
	drbd-dev@lists.linbit.com,
	linuxppc-dev@lists.ozlabs.org,
	linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-s390@vger.kernel.org
Subject: [PATCH 24/26] xpram: convert to blk_alloc_disk/blk_cleanup_disk
Date: Fri, 21 May 2021 07:51:14 +0200
Message-Id: <20210521055116.1053587-25-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210521055116.1053587-1-hch@lst.de>
References: <20210521055116.1053587-1-hch@lst.de>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Convert the xpram driver to use the blk_alloc_disk and blk_cleanup_disk
helpers to simplify gendisk and request_queue allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/s390/block/xpram.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index d1ed39162943..91ef710edfd2 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -56,7 +56,6 @@ typedef struct {
 static xpram_device_t xpram_devices[XPRAM_MAX_DEVS];
 static unsigned int xpram_sizes[XPRAM_MAX_DEVS];
 static struct gendisk *xpram_disks[XPRAM_MAX_DEVS];
-static struct request_queue *xpram_queues[XPRAM_MAX_DEVS];
 static unsigned int xpram_pages;
 static int xpram_devs;
 
@@ -341,17 +340,13 @@ static int __init xpram_setup_blkdev(void)
 	int i, rc = -ENOMEM;
 
 	for (i = 0; i < xpram_devs; i++) {
-		xpram_disks[i] = alloc_disk(1);
+		xpram_disks[i] = blk_alloc_disk(NUMA_NO_NODE);
 		if (!xpram_disks[i])
 			goto out;
-		xpram_queues[i] = blk_alloc_queue(NUMA_NO_NODE);
-		if (!xpram_queues[i]) {
-			put_disk(xpram_disks[i]);
-			goto out;
-		}
-		blk_queue_flag_set(QUEUE_FLAG_NONROT, xpram_queues[i]);
-		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, xpram_queues[i]);
-		blk_queue_logical_block_size(xpram_queues[i], 4096);
+		blk_queue_flag_set(QUEUE_FLAG_NONROT, xpram_disks[i]->queue);
+		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM,
+				xpram_disks[i]->queue);
+		blk_queue_logical_block_size(xpram_disks[i]->queue, 4096);
 	}
 
 	/*
@@ -373,9 +368,9 @@ static int __init xpram_setup_blkdev(void)
 		offset += xpram_devices[i].size;
 		disk->major = XPRAM_MAJOR;
 		disk->first_minor = i;
+		disk->minors = 1;
 		disk->fops = &xpram_devops;
 		disk->private_data = &xpram_devices[i];
-		disk->queue = xpram_queues[i];
 		sprintf(disk->disk_name, "slram%d", i);
 		set_capacity(disk, xpram_sizes[i] << 1);
 		add_disk(disk);
@@ -383,10 +378,8 @@ static int __init xpram_setup_blkdev(void)
 
 	return 0;
 out:
-	while (i--) {
-		blk_cleanup_queue(xpram_queues[i]);
-		put_disk(xpram_disks[i]);
-	}
+	while (i--)
+		blk_cleanup_disk(xpram_disks[i]);
 	return rc;
 }
 
@@ -434,8 +427,7 @@ static void __exit xpram_exit(void)
 	int i;
 	for (i = 0; i < xpram_devs; i++) {
 		del_gendisk(xpram_disks[i]);
-		blk_cleanup_queue(xpram_queues[i]);
-		put_disk(xpram_disks[i]);
+		blk_cleanup_disk(xpram_disks[i]);
 	}
 	unregister_blkdev(XPRAM_MAJOR, XPRAM_NAME);
 	platform_device_unregister(xpram_pdev);
-- 
2.30.2

