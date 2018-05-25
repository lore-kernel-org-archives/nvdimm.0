Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2415A2096184C
 for <linux-nvdimm@lists.01.org>; Thu, 24 May 2018 19:55:24 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 5/7] dm: remove DM_TYPE_DAX_BIO_BASED dm_queue_mode
Date: Thu, 24 May 2018 20:55:16 -0600
Message-Id: <20180525025518.11405-6-ross.zwisler@linux.intel.com>
In-Reply-To: <20180525025518.11405-1-ross.zwisler@linux.intel.com>
References: <20180525025518.11405-1-ross.zwisler@linux.intel.com>
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
To: Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The DM_TYPE_DAX_BIO_BASED dm_queue_mode was introduced to prevent DM
devices that could possibly support DAX from transitioning into DM devices
that cannot support DAX.

For example, the following transition will currently fail:

 dm-linear: [fsdax pmem][fsdax pmem] => [fsdax pmem][fsdax raw]
	      DM_TYPE_DAX_BIO_BASED       DM_TYPE_BIO_BASED

but these will both succeed:

 dm-linear: [fsdax pmem][brd ramdisk] => [fsdax pmem][fsdax raw]
 		DM_TYPE_DAX_BASED        DM_TYPE_BIO_BASED

 dm-linear: [fsdax pmem][fsdax raw] => [fsdax pmem][fsdax pmem]
 		DM_TYPE_BIO_BASED        DM_TYPE_DAX_BIO_BASED

This seems arbitrary, as really the choice on whether to use DAX happens at
filesystem mount time.  There's no guarantee that the in the first case
(double fsdax pmem) we were using the dax mount option with our file
system.

Instead, get rid of DM_TYPE_DAX_BIO_BASED and all the special casing around
it, and instead make the request queue's QUEUE_FLAG_DAX be our one source
of truth.  If this is set, we can use DAX, and if not, not.  We keep this
up to date in table_load() as the table changes.  As with regular block
devices the filesystem will then know at mount time whether DAX is a
supported mount option or not.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/md/dm-ioctl.c         | 16 ++++++----------
 drivers/md/dm-table.c         | 25 ++++++++++---------------
 drivers/md/dm.c               |  2 --
 include/linux/device-mapper.h |  8 ++++++--
 4 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 5acf77de5945..d1f86d0bb2d0 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1292,15 +1292,6 @@ static int populate_table(struct dm_table *table,
 	return dm_table_complete(table);
 }
 
-static bool is_valid_type(enum dm_queue_mode cur, enum dm_queue_mode new)
-{
-	if (cur == new ||
-	    (cur == DM_TYPE_BIO_BASED && new == DM_TYPE_DAX_BIO_BASED))
-		return true;
-
-	return false;
-}
-
 static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	int r;
@@ -1343,12 +1334,17 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
 			DMWARN("unable to set up device queue for new table.");
 			goto err_unlock_md_type;
 		}
-	} else if (!is_valid_type(dm_get_md_type(md), dm_table_get_type(t))) {
+	} else if (dm_get_md_type(md) != dm_table_get_type(t)) {
 		DMWARN("can't change device type after initial table load.");
 		r = -EINVAL;
 		goto err_unlock_md_type;
 	}
 
+	if (dm_table_supports_dax(t))
+		blk_queue_flag_set(QUEUE_FLAG_DAX, md->queue);
+	else
+		blk_queue_flag_clear(QUEUE_FLAG_DAX, md->queue);
+
 	dm_unlock_md_type(md);
 
 	/* stage inactive table */
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 5bb994b012ca..ea5c4a1e6f5b 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -866,7 +866,6 @@ EXPORT_SYMBOL(dm_consume_args);
 static bool __table_type_bio_based(enum dm_queue_mode table_type)
 {
 	return (table_type == DM_TYPE_BIO_BASED ||
-		table_type == DM_TYPE_DAX_BIO_BASED ||
 		table_type == DM_TYPE_NVME_BIO_BASED);
 }
 
@@ -888,7 +887,7 @@ static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
 	return bdev_dax_supported(dev->bdev, PAGE_SIZE);
 }
 
-static bool dm_table_supports_dax(struct dm_table *t)
+bool dm_table_supports_dax(struct dm_table *t)
 {
 	struct dm_target *ti;
 	unsigned i;
@@ -907,6 +906,7 @@ static bool dm_table_supports_dax(struct dm_table *t)
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(dm_table_supports_dax);
 
 static bool dm_table_does_not_support_partial_completion(struct dm_table *t);
 
@@ -944,7 +944,6 @@ static int dm_table_determine_type(struct dm_table *t)
 			/* possibly upgrade to a variant of bio-based */
 			goto verify_bio_based;
 		}
-		BUG_ON(t->type == DM_TYPE_DAX_BIO_BASED);
 		BUG_ON(t->type == DM_TYPE_NVME_BIO_BASED);
 		goto verify_rq_based;
 	}
@@ -981,18 +980,14 @@ static int dm_table_determine_type(struct dm_table *t)
 verify_bio_based:
 		/* We must use this table as bio-based */
 		t->type = DM_TYPE_BIO_BASED;
-		if (dm_table_supports_dax(t) ||
-		    (list_empty(devices) && live_md_type == DM_TYPE_DAX_BIO_BASED)) {
-			t->type = DM_TYPE_DAX_BIO_BASED;
-		} else {
-			/* Check if upgrading to NVMe bio-based is valid or required */
-			tgt = dm_table_get_immutable_target(t);
-			if (tgt && !tgt->max_io_len && dm_table_does_not_support_partial_completion(t)) {
-				t->type = DM_TYPE_NVME_BIO_BASED;
-				goto verify_rq_based; /* must be stacked directly on NVMe (blk-mq) */
-			} else if (list_empty(devices) && live_md_type == DM_TYPE_NVME_BIO_BASED) {
-				t->type = DM_TYPE_NVME_BIO_BASED;
-			}
+
+		/* Check if upgrading to NVMe bio-based is valid or required */
+		tgt = dm_table_get_immutable_target(t);
+		if (tgt && !tgt->max_io_len && dm_table_does_not_support_partial_completion(t)) {
+			t->type = DM_TYPE_NVME_BIO_BASED;
+			goto verify_rq_based; /* must be stacked directly on NVMe (blk-mq) */
+		} else if (list_empty(devices) && live_md_type == DM_TYPE_NVME_BIO_BASED) {
+			t->type = DM_TYPE_NVME_BIO_BASED;
 		}
 		return 0;
 	}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9728433362d1..0ce06fa292fd 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2192,7 +2192,6 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 		}
 		break;
 	case DM_TYPE_BIO_BASED:
-	case DM_TYPE_DAX_BIO_BASED:
 		dm_init_normal_md_queue(md);
 		blk_queue_make_request(md->queue, dm_make_request);
 		break;
@@ -2910,7 +2909,6 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
 
 	switch (type) {
 	case DM_TYPE_BIO_BASED:
-	case DM_TYPE_DAX_BIO_BASED:
 	case DM_TYPE_NVME_BIO_BASED:
 		pool_size = max(dm_get_reserved_bio_based_ios(), min_pool_size);
 		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 31fef7c34185..cbf3d7e7ed33 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -27,8 +27,7 @@ enum dm_queue_mode {
 	DM_TYPE_BIO_BASED	 = 1,
 	DM_TYPE_REQUEST_BASED	 = 2,
 	DM_TYPE_MQ_REQUEST_BASED = 3,
-	DM_TYPE_DAX_BIO_BASED	 = 4,
-	DM_TYPE_NVME_BIO_BASED	 = 5,
+	DM_TYPE_NVME_BIO_BASED	 = 4,
 };
 
 typedef enum { STATUSTYPE_INFO, STATUSTYPE_TABLE } status_type_t;
@@ -460,6 +459,11 @@ void dm_table_add_target_callbacks(struct dm_table *t, struct dm_target_callback
  */
 void dm_table_set_type(struct dm_table *t, enum dm_queue_mode type);
 
+/*
+ * Check to see if this target type and all table devices support DAX.
+ */
+bool dm_table_supports_dax(struct dm_table *t);
+
 /*
  * Finally call this to make the table ready for use.
  */
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
