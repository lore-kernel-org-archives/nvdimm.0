Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id B10F31A1DF1
 for <linux-nvdimm@lists.01.org>; Sun, 31 Jul 2016 11:17:37 -0700 (PDT)
Subject: [PATCH] block: fix bdi vs gendisk lifetime mismatch
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 31 Jul 2016 11:15:13 -0700
Message-ID: <146998891350.29275.1589003488607819550.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-block@vger.kernel.org, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The name for a bdi of a gendisk is derived from the gendisk's devt.
However, since the gendisk is destroyed before the bdi it leaves a
window where a new gendisk could dynamically reuse the same devt while a
bdi with the same name is still live.  Arrange for the bdi to hold a
reference against its "owner" disk device while it is registered.
Otherwise we can hit sysfs duplicate name collisions like the following:

 WARNING: CPU: 10 PID: 2078 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80
 sysfs: cannot create duplicate filename '/devices/virtual/bdi/259:1'

 Hardware name: HP ProLiant DL580 Gen8, BIOS P79 05/06/2015
  0000000000000286 0000000002c04ad5 ffff88006f24f970 ffffffff8134caec
  ffff88006f24f9c0 0000000000000000 ffff88006f24f9b0 ffffffff8108c351
  0000001f0000000c ffff88105d236000 ffff88105d1031e0 ffff8800357427f8
 Call Trace:
  [<ffffffff8134caec>] dump_stack+0x63/0x87
  [<ffffffff8108c351>] __warn+0xd1/0xf0
  [<ffffffff8108c3cf>] warn_slowpath_fmt+0x5f/0x80
  [<ffffffff812a0d34>] sysfs_warn_dup+0x64/0x80
  [<ffffffff812a0e1e>] sysfs_create_dir_ns+0x7e/0x90
  [<ffffffff8134faaa>] kobject_add_internal+0xaa/0x320
  [<ffffffff81358d4e>] ? vsnprintf+0x34e/0x4d0
  [<ffffffff8134ff55>] kobject_add+0x75/0xd0
  [<ffffffff816e66b2>] ? mutex_lock+0x12/0x2f
  [<ffffffff8148b0a5>] device_add+0x125/0x610
  [<ffffffff8148b788>] device_create_groups_vargs+0xd8/0x100
  [<ffffffff8148b7cc>] device_create_vargs+0x1c/0x20
  [<ffffffff811b775c>] bdi_register+0x8c/0x180
  [<ffffffff811b7877>] bdi_register_dev+0x27/0x30
  [<ffffffff813317f5>] add_disk+0x175/0x4a0

Cc: <stable@vger.kernel.org>
Reported-by: Yi Zhang <yizhan@redhat.com>
Tested-by: Yi Zhang <yizhan@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/genhd.c                    |    2 +-
 include/linux/backing-dev-defs.h |    1 +
 include/linux/backing-dev.h      |    1 +
 mm/backing-dev.c                 |   18 ++++++++++++++++++
 4 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3c9dede4e04f..f6f7ffcd4eab 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -614,7 +614,7 @@ void device_add_disk(struct device *parent, struct gendisk *disk)
 
 	/* Register BDI before referencing it from bdev */
 	bdi = &disk->queue->backing_dev_info;
-	bdi_register_dev(bdi, disk_devt(disk));
+	bdi_register_owner(bdi, disk_to_dev(disk));
 
 	blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 3f103076d0bf..c357f27d5483 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -163,6 +163,7 @@ struct backing_dev_info {
 	wait_queue_head_t wb_waitq;
 
 	struct device *dev;
+	struct device *owner;
 
 	struct timer_list laptop_mode_wb_timer;
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 491a91717788..43b93a947e61 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -24,6 +24,7 @@ __printf(3, 4)
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...);
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
+int bdi_register_owner(struct backing_dev_info *bdi, struct device *owner);
 void bdi_unregister(struct backing_dev_info *bdi);
 
 int __must_check bdi_setup_and_register(struct backing_dev_info *, char *);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index efe237742074..7b51cb7905be 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -825,6 +825,19 @@ int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev)
 }
 EXPORT_SYMBOL(bdi_register_dev);
 
+int bdi_register_owner(struct backing_dev_info *bdi, struct device *owner)
+{
+	int rc;
+
+	rc = bdi_register(bdi, NULL, "%u:%u", MAJOR(owner->devt),
+			MINOR(owner->devt));
+	if (rc)
+		return rc;
+	bdi->owner = owner;
+	get_device(owner);
+}
+EXPORT_SYMBOL(bdi_register_owner);
+
 /*
  * Remove bdi from bdi_list, and ensure that it is no longer visible
  */
@@ -849,6 +862,11 @@ void bdi_unregister(struct backing_dev_info *bdi)
 		device_unregister(bdi->dev);
 		bdi->dev = NULL;
 	}
+
+	if (bdi->owner) {
+		put_device(bdi->owner);
+		bdi->owner = NULL;
+	}
 }
 
 void bdi_exit(struct backing_dev_info *bdi)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
