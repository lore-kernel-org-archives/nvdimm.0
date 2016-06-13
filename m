Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 981A41A1E2E
 for <linux-nvdimm@lists.01.org>; Mon, 13 Jun 2016 15:32:13 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 1/6] genhd: Add GENHD_FL_DAX to gendisk flags
Date: Mon, 13 Jun 2016 16:21:32 -0600
Message-Id: <1465856497-19698-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
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
To: agk@redhat.com, snitzer@redhat.com, dan.j.williams@intel.com
Cc: axboe@kernel.dk, linux-s390@vger.kernel.org, linux-nvdimm@lists.01.org, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

Currently, presence of direct_access() in block_device_operations
indicates support of DAX on its block device.  Because
block_device_operations is instantiated with 'const', this DAX
capablity may not be enabled conditinally.

In preparation for supporting DAX to device-mapper devices, add
GENHD_FL_DAX to gendisk flags to indicate that this block device
supports DAX.  This will allow to set the DAX capability based on
how mapped device is composed.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <linux-s390@vger.kernel.org>
---
 drivers/block/brd.c          |    2 +-
 drivers/nvdimm/pmem.c        |    2 +-
 drivers/s390/block/dcssblk.c |    1 +
 include/linux/genhd.h        |    2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index c04bd9b..43a6765 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -518,7 +518,7 @@ static struct brd_device *brd_alloc(int i)
 	disk->fops		= &brd_fops;
 	disk->private_data	= brd;
 	disk->queue		= brd->brd_queue;
-	disk->flags		= GENHD_FL_EXT_DEVT;
+	disk->flags		= GENHD_FL_EXT_DEVT | GENHD_FL_DAX;
 	sprintf(disk->disk_name, "ram%d", i);
 	set_capacity(disk, rd_size * 2);
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 608fc44..3847449 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -295,7 +295,7 @@ static int pmem_attach_disk(struct device *dev,
 
 	disk->fops		= &pmem_fops;
 	disk->queue		= q;
-	disk->flags		= GENHD_FL_EXT_DEVT;
+	disk->flags		= GENHD_FL_EXT_DEVT | GENHD_FL_DAX;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	disk->driverfs_dev = dev;
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index bed53c4..60b1857 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -616,6 +616,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	dev_info->gd->queue = dev_info->dcssblk_queue;
 	dev_info->gd->private_data = dev_info;
 	dev_info->gd->driverfs_dev = &dev_info->dev;
+	dev_info->gd->flags = GENHD_FL_DAX;
 	blk_queue_make_request(dev_info->dcssblk_queue, dcssblk_make_request);
 	blk_queue_logical_block_size(dev_info->dcssblk_queue, 4096);
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 359a8e4..9dc3a3d 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -131,7 +131,7 @@ struct hd_struct {
 };
 
 #define GENHD_FL_REMOVABLE			1
-/* 2 is unused */
+#define GENHD_FL_DAX				2
 #define GENHD_FL_MEDIA_CHANGE_NOTIFY		4
 #define GENHD_FL_CD				8
 #define GENHD_FL_UP				16
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
