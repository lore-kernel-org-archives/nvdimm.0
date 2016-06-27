Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 291091A1E02
 for <linux-nvdimm@lists.01.org>; Mon, 27 Jun 2016 12:31:20 -0700 (PDT)
Subject: [PATCH v5 2/5] mmc: move 'parent' tracking to mmc_blk_data
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 27 Jun 2016 12:30:03 -0700
Message-ID: <146705580308.39775.10937037092465199137.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146705579255.39775.12551436695635245858.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146705579255.39775.12551436695635245858.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: axboe@fb.com
Cc: Ulf Hansson <ulf.hansson@linaro.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

In preparation for the removal of 'driverfs_dev' from 'struct gendisk',
carry this data in mmc_blk_data. It is used for registration of parent
disks and partitions.

Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/mmc/card/block.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 383184743f9a..d1733424bf6e 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -93,6 +93,7 @@ static DEFINE_SPINLOCK(mmc_blk_lock);
  */
 struct mmc_blk_data {
 	spinlock_t	lock;
+	struct device	*parent;
 	struct gendisk	*disk;
 	struct mmc_queue queue;
 	struct list_head part;
@@ -2270,7 +2271,7 @@ again:
 	md->disk->fops = &mmc_bdops;
 	md->disk->private_data = md;
 	md->disk->queue = md->queue.queue;
-	md->disk->driverfs_dev = parent;
+	md->parent = parent;
 	set_disk_ro(md->disk, md->read_only || default_ro);
 	md->disk->flags = GENHD_FL_EXT_DEVT;
 	if (area_type & (MMC_BLK_DATA_AREA_RPMB | MMC_BLK_DATA_AREA_BOOT))
@@ -2458,7 +2459,7 @@ static int mmc_add_disk(struct mmc_blk_data *md)
 	int ret;
 	struct mmc_card *card = md->queue.card;
 
-	add_disk(md->disk);
+	device_add_disk(md->parent, md->disk);
 	md->force_ro.show = force_ro_show;
 	md->force_ro.store = force_ro_store;
 	sysfs_attr_init(&md->force_ro.attr);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
