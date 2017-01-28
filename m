Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 775AB82002
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:41:09 -0800 (PST)
Subject: [RFC PATCH 11/17] dm: add dax_operations support (producer)
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:37:03 -0800
Message-ID: <148559262335.11180.461652469893258568.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: snitzer@redhat.com, mawilcox@microsoft.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Setup a dax_inode to have the same lifetime as the dm block device and
add a ->direct_access() method that is equivalent to
dm_blk_direct_access(). Once fs/dax.c has been converted to use
dax_operations the old dm_blk_direct_access() will be removed.

This enabling is only for the top-level dm representation to upper
layers. Sub-sequent patches are needed to convert the bottom layer
interface to backing devices.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/Kconfig   |    1 +
 drivers/md/dm-core.h |    3 +++
 drivers/md/dm.c      |   42 +++++++++++++++++++++++++++++++++++++++---
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index b7767da50c26..1de8372d9459 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -200,6 +200,7 @@ config BLK_DEV_DM_BUILTIN
 config BLK_DEV_DM
 	tristate "Device mapper support"
 	select BLK_DEV_DM_BUILTIN
+	select DAX
 	---help---
 	  Device-mapper is a low level volume manager.  It works by allowing
 	  people to specify mappings for ranges of logical sectors.  Various
diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 40ceba1fe8be..f6eb8d8db646 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -24,6 +24,8 @@ struct dm_kobject_holder {
 	struct completion completion;
 };
 
+struct dax_inode;
+
 /*
  * DM core internal structure that used directly by dm.c and dm-rq.c
  * DM targets must _not_ deference a mapped_device to directly access its members!
@@ -58,6 +60,7 @@ struct mapped_device {
 	struct target_type *immutable_target_type;
 
 	struct gendisk *disk;
+	struct dax_inode *dax_inode;
 	char name[16];
 
 	void *interface_ptr;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index db934b1dba9d..1b3d9253e92c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -15,6 +15,7 @@
 #include <linux/blkpg.h>
 #include <linux/bio.h>
 #include <linux/mempool.h>
+#include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
 #include <linux/hdreg.h>
@@ -905,10 +906,10 @@ int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
 }
 EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
 
-static long dm_blk_direct_access(struct block_device *bdev, sector_t sector,
-				 void **kaddr, pfn_t *pfn, long size)
+static long __dm_direct_access(struct mapped_device *md, phys_addr_t dev_addr,
+			       void **kaddr, pfn_t *pfn, long size)
 {
-	struct mapped_device *md = bdev->bd_disk->private_data;
+	sector_t sector = dev_addr >> SECTOR_SHIFT;
 	struct dm_table *map;
 	struct dm_target *ti;
 	int srcu_idx;
@@ -932,6 +933,23 @@ static long dm_blk_direct_access(struct block_device *bdev, sector_t sector,
 	return min(ret, size);
 }
 
+static long dm_blk_direct_access(struct block_device *bdev, sector_t sector,
+				 void **kaddr, pfn_t *pfn, long size)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+
+	return __dm_direct_access(md, sector << SECTOR_SHIFT, kaddr, pfn, size);
+}
+
+static long dm_dax_direct_access(struct dax_inode *dax_inode,
+				 phys_addr_t dev_addr, void **kaddr, pfn_t *pfn,
+				 long size)
+{
+	struct mapped_device *md = dax_inode_get_private(dax_inode);
+
+	return __dm_direct_access(md, dev_addr, kaddr, pfn, size);
+}
+
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_PREFLUSH.
@@ -1376,6 +1394,7 @@ static int next_free_minor(int *minor)
 }
 
 static const struct block_device_operations dm_blk_dops;
+static const struct dax_operations dm_dax_ops;
 
 static void dm_wq_work(struct work_struct *work);
 
@@ -1423,6 +1442,12 @@ static void cleanup_mapped_device(struct mapped_device *md)
 	if (md->bs)
 		bioset_free(md->bs);
 
+	if (md->dax_inode) {
+		kill_dax_inode(md->dax_inode);
+		put_dax_inode(md->dax_inode);
+		md->dax_inode = NULL;
+	}
+
 	if (md->disk) {
 		spin_lock(&_minor_lock);
 		md->disk->private_data = NULL;
@@ -1450,6 +1475,7 @@ static void cleanup_mapped_device(struct mapped_device *md)
 static struct mapped_device *alloc_dev(int minor)
 {
 	int r, numa_node_id = dm_get_numa_node();
+	struct dax_inode *dax_inode;
 	struct mapped_device *md;
 	void *old_md;
 
@@ -1514,6 +1540,12 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
+
+	dax_inode = alloc_dax_inode(md, md->disk->disk_name, &dm_dax_ops);
+	if (!dax_inode)
+		goto bad;
+	md->dax_inode = dax_inode;
+
 	add_disk(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
@@ -2735,6 +2767,10 @@ static const struct block_device_operations dm_blk_dops = {
 	.owner = THIS_MODULE
 };
 
+static const struct dax_operations dm_dax_ops = {
+	.direct_access = dm_dax_direct_access,
+};
+
 /*
  * module hooks
  */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
