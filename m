Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A25091A1E89
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 07:21:31 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 2/2] libnvdimm: use generic iostat interfaces
Date: Wed, 19 Oct 2016 08:19:44 -0600
Message-Id: <1476886784-24644-3-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1476886784-24644-1-git-send-email-toshi.kani@hpe.com>
References: <1476886784-24644-1-git-send-email-toshi.kani@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: akpm@linux-foundation.org, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

nd_iostat_start() and nd_iostat_end() implement the same functionality
that generic_start_io_acct() and generic_end_io_acct() already provide.

Change nd_iostat_start() and nd_iostat_end() to call the generic iostat
interfaces.  There is no change in the nd interfaces.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/nvdimm/core.c |   29 -----------------------------
 drivers/nvdimm/nd.h   |   11 +++++++++--
 2 files changed, 9 insertions(+), 31 deletions(-)

diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 7ceba08..9303cfe 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -317,35 +317,6 @@ ssize_t nd_sector_size_store(struct device *dev, const char *buf,
 	}
 }
 
-void __nd_iostat_start(struct bio *bio, unsigned long *start)
-{
-	struct gendisk *disk = bio->bi_bdev->bd_disk;
-	const int rw = bio_data_dir(bio);
-	int cpu = part_stat_lock();
-
-	*start = jiffies;
-	part_round_stats(cpu, &disk->part0);
-	part_stat_inc(cpu, &disk->part0, ios[rw]);
-	part_stat_add(cpu, &disk->part0, sectors[rw], bio_sectors(bio));
-	part_inc_in_flight(&disk->part0, rw);
-	part_stat_unlock();
-}
-EXPORT_SYMBOL(__nd_iostat_start);
-
-void nd_iostat_end(struct bio *bio, unsigned long start)
-{
-	struct gendisk *disk = bio->bi_bdev->bd_disk;
-	unsigned long duration = jiffies - start;
-	const int rw = bio_data_dir(bio);
-	int cpu = part_stat_lock();
-
-	part_stat_add(cpu, &disk->part0, ticks[rw], duration);
-	part_round_stats(cpu, &disk->part0);
-	part_dec_in_flight(&disk->part0, rw);
-	part_stat_unlock();
-}
-EXPORT_SYMBOL(nd_iostat_end);
-
 static ssize_t commands_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index d3b2fca..065abf1 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -377,10 +377,17 @@ static inline bool nd_iostat_start(struct bio *bio, unsigned long *start)
 	if (!blk_queue_io_stat(disk->queue))
 		return false;
 
-	__nd_iostat_start(bio, start);
+	*start = jiffies;
+	generic_start_io_acct(bio_data_dir(bio),
+			      bio_sectors(bio), &disk->part0);
 	return true;
 }
-void nd_iostat_end(struct bio *bio, unsigned long start);
+static inline void nd_iostat_end(struct bio *bio, unsigned long start)
+{
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
+
+	generic_end_io_acct(bio_data_dir(bio), &disk->part0, start);
+}
 static inline bool is_bad_pmem(struct badblocks *bb, sector_t sector,
 		unsigned int len)
 {
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
