Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 893CC1A1E53
 for <linux-nvdimm@lists.01.org>; Fri, 17 Jun 2016 09:36:00 -0700 (PDT)
Subject: [PATCH v3 3/3] block: remove ->driverfs_dev
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Jun 2016 09:34:49 -0700
Message-ID: <146618128983.31030.5935615517632155377.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146618127395.31030.11800447312061202344.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146618127395.31030.11800447312061202344.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-block@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, axboe@fb.com, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Now that all drivers that specify a ->driverfs_dev have been converted
to device_add_disk(), the pointer can be removed from struct gendisk.

Cc: Jens Axboe <axboe@fb.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/genhd.c         |    5 ++---
 drivers/nvdimm/bus.c  |    2 +-
 include/linux/genhd.h |    4 +---
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 932e70c113d0..a18d35390f1d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -800,10 +800,9 @@ void __init printk_all_partitions(void)
 			       , disk_name(disk, part->partno, name_buf),
 			       part->info ? part->info->uuid : "");
 			if (is_part0) {
-				if (disk->driverfs_dev != NULL &&
-				    disk->driverfs_dev->driver != NULL)
+				if (dev->parent && dev->parent->driver)
 					printk(" driver: %s\n",
-					      disk->driverfs_dev->driver->name);
+					      dev->parent->driver->name);
 				else
 					printk(" (driver?)\n");
 			} else
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index f085f8bceae8..5e4e5c772ea5 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -312,7 +312,7 @@ EXPORT_SYMBOL(__nd_driver_register);
 
 int nvdimm_revalidate_disk(struct gendisk *disk)
 {
-	struct device *dev = disk->driverfs_dev;
+	struct device *dev = disk_to_dev(disk)->parent;
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 	const char *pol = nd_region->ro ? "only" : "write";
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index df1dabbfd388..1dbf52f9c24b 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -205,7 +205,6 @@ struct gendisk {
 	void *private_data;
 
 	int flags;
-	struct device *driverfs_dev;  // FIXME: remove
 	struct kobject *slave_dir;
 
 	struct timer_rand_state *random;
@@ -417,8 +416,7 @@ extern void part_round_stats(int cpu, struct hd_struct *part);
 extern void device_add_disk(struct device *parent, struct gendisk *disk);
 static inline void add_disk(struct gendisk *disk)
 {
-	/* temporary while we convert callers to device_add_disk */
-	device_add_disk(disk->driverfs_dev, disk);
+	device_add_disk(NULL, disk);
 }
 
 extern void del_gendisk(struct gendisk *gp);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
