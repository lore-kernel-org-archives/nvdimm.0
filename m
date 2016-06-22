Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD3271A1E11
 for <linux-nvdimm@lists.01.org>; Wed, 22 Jun 2016 17:05:48 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 2/3] dm: add infrastructure for DAX support
Date: Wed, 22 Jun 2016 17:54:53 -0600
Message-Id: <1466639694-25394-3-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1466639694-25394-1-git-send-email-toshi.kani@hpe.com>
References: <1466639694-25394-1-git-send-email-toshi.kani@hpe.com>
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
To: snitzer@redhat.com, axboe@kernel.dk, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk, agk@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Change mapped device to implement direct_access function,
dm_blk_direct_access(), which calls a target direct_access function.
'struct target_type' is extended to have target direct_access interface.
This function limits direct accessible size to the dm_target's limit
with max_io_len().

Extend 'struct dm_target' to have dax_supported bit, which allows
dm-table to check if a dm-target supports DAX.

Add a new dm type, DM_TYPE_DAX_BIO_BASED, which indicates that mapped
device supports DAX and is bio based.  This new type is used to assure
that all target devices have DAX support and remain that way after
QUEUE_FLAG_DAX is set in mapped device.

At initial table load, QUEUE_FLAG_DAX is set to mapped device when setting
DM_TYPE_DAX_BIO_BASED to the type.  Any subsequent table load to the
mapped device must have the same type, or else it fails per the check in
table_load().

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/md/dm-table.c         |   23 ++++++++++++++++++++---
 drivers/md/dm.c               |   36 +++++++++++++++++++++++++++++++++++-
 drivers/md/dm.h               |    1 +
 include/linux/device-mapper.h |   16 ++++++++++++++++
 4 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 88f0174..aa14fc4 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -827,6 +827,12 @@ void dm_consume_args(struct dm_arg_set *as, unsigned num_args)
 }
 EXPORT_SYMBOL(dm_consume_args);
 
+static bool __table_type_bio_based(unsigned table_type)
+{
+	return (table_type == DM_TYPE_BIO_BASED ||
+		table_type == DM_TYPE_DAX_BIO_BASED);
+}
+
 static bool __table_type_request_based(unsigned table_type)
 {
 	return (table_type == DM_TYPE_REQUEST_BASED ||
@@ -842,7 +848,7 @@ EXPORT_SYMBOL_GPL(dm_table_set_type);
 static int dm_table_determine_type(struct dm_table *t)
 {
 	unsigned i;
-	unsigned bio_based = 0, request_based = 0, hybrid = 0;
+	unsigned bio_based = 0, request_based = 0, hybrid = 0, num_dax = 0;
 	bool verify_blk_mq = false;
 	struct dm_target *tgt;
 	struct dm_dev_internal *dd;
@@ -865,6 +871,9 @@ static int dm_table_determine_type(struct dm_table *t)
 		else
 			bio_based = 1;
 
+		if (tgt->dax_supported)
+			num_dax++;
+
 		if (bio_based && request_based) {
 			DMWARN("Inconsistent table: different target types"
 			       " can't be mixed up");
@@ -886,7 +895,10 @@ static int dm_table_determine_type(struct dm_table *t)
 
 	if (bio_based) {
 		/* We must use this table as bio-based */
-		t->type = DM_TYPE_BIO_BASED;
+		if (num_dax && num_dax == t->num_targets)
+			t->type = DM_TYPE_DAX_BIO_BASED;
+		else
+			t->type = DM_TYPE_BIO_BASED;
 		return 0;
 	}
 
@@ -979,6 +991,11 @@ struct dm_target *dm_table_get_wildcard_target(struct dm_table *t)
 	return NULL;
 }
 
+bool dm_table_bio_based(struct dm_table *t)
+{
+	return __table_type_bio_based(dm_table_get_type(t));
+}
+
 bool dm_table_request_based(struct dm_table *t)
 {
 	return __table_type_request_based(dm_table_get_type(t));
@@ -1001,7 +1018,7 @@ static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *
 		return -EINVAL;
 	}
 
-	if (type == DM_TYPE_BIO_BASED)
+	if (__table_type_bio_based(type))
 		for (i = 0; i < t->num_targets; i++) {
 			tgt = t->targets + i;
 			per_io_data_size = max(per_io_data_size, tgt->per_io_data_size);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2c907bc..17cd25a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -905,6 +905,34 @@ int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
 }
 EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
 
+static long dm_blk_direct_access(struct block_device *bdev, sector_t sector,
+				 void __pmem **kaddr, pfn_t *pfn, long size)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	struct dm_table *map;
+	struct dm_target *ti;
+	int srcu_idx;
+	long len, ret = -EIO;
+
+	map = dm_get_live_table(md, &srcu_idx);
+	if (!map)
+		return ret;
+
+	ti = dm_table_find_target(map, sector);
+	if (!dm_target_is_valid(ti))
+		goto out;
+
+	len = max_io_len(sector, ti) << SECTOR_SHIFT;
+	size = min(len, size);
+
+	if (ti->type->direct_access)
+		ret = ti->type->direct_access(ti, sector, kaddr, pfn, size);
+out:
+	dm_put_live_table(md, srcu_idx);
+
+	return min(ret, size);
+}
+
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_PREFLUSH.
@@ -1548,7 +1576,7 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 
 	if (md->bs) {
 		/* The md already has necessary mempools. */
-		if (dm_table_get_type(t) == DM_TYPE_BIO_BASED) {
+		if (dm_table_bio_based(t)) {
 			/*
 			 * Reload bioset because front_pad may have changed
 			 * because a different table was loaded.
@@ -1715,6 +1743,9 @@ void dm_set_md_type(struct mapped_device *md, unsigned type)
 {
 	BUG_ON(!mutex_is_locked(&md->type_lock));
 	md->type = type;
+
+	if (type == DM_TYPE_DAX_BIO_BASED)
+		queue_flag_set_unlocked(QUEUE_FLAG_DAX, md->queue);
 }
 
 unsigned dm_get_md_type(struct mapped_device *md)
@@ -1761,6 +1792,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 		}
 		break;
 	case DM_TYPE_BIO_BASED:
+	case DM_TYPE_DAX_BIO_BASED:
 		dm_init_normal_md_queue(md);
 		blk_queue_make_request(md->queue, dm_make_request);
 		/*
@@ -2465,6 +2497,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned t
 
 	switch (type) {
 	case DM_TYPE_BIO_BASED:
+	case DM_TYPE_DAX_BIO_BASED:
 		cachep = _io_cache;
 		pool_size = dm_get_reserved_bio_based_ios();
 		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
@@ -2641,6 +2674,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
 	.ioctl = dm_blk_ioctl,
+	.direct_access = dm_blk_direct_access,
 	.getgeo = dm_blk_getgeo,
 	.pr_ops = &dm_pr_ops,
 	.owner = THIS_MODULE
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 2e0e4a5..f0aad08 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -68,6 +68,7 @@ unsigned dm_table_get_type(struct dm_table *t);
 struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
 struct dm_target *dm_table_get_immutable_target(struct dm_table *t);
 struct dm_target *dm_table_get_wildcard_target(struct dm_table *t);
+bool dm_table_bio_based(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
 bool dm_table_all_blk_mq_devices(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 2ce3392..1f1a6de 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -26,6 +26,7 @@ struct bio_vec;
 #define DM_TYPE_BIO_BASED		1
 #define DM_TYPE_REQUEST_BASED		2
 #define DM_TYPE_MQ_REQUEST_BASED	3
+#define DM_TYPE_DAX_BIO_BASED		4
 
 typedef enum { STATUSTYPE_INFO, STATUSTYPE_TABLE } status_type_t;
 
@@ -124,6 +125,15 @@ typedef void (*dm_io_hints_fn) (struct dm_target *ti,
  */
 typedef int (*dm_busy_fn) (struct dm_target *ti);
 
+/*
+ * Returns:
+ *  < 0 : error
+ * >= 0 : the number of bytes accessible at the address
+ */
+typedef long (*dm_direct_access_fn) (struct dm_target *ti, sector_t sector,
+				     void __pmem **kaddr, pfn_t *pfn,
+				     long size);
+
 void dm_error(const char *message);
 
 struct dm_dev {
@@ -170,6 +180,7 @@ struct target_type {
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
+	dm_direct_access_fn direct_access;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
@@ -288,6 +299,11 @@ struct dm_target {
 	 * Set if this target does not return zeroes on discarded blocks.
 	 */
 	bool discard_zeroes_data_unsupported:1;
+
+	/*
+	 * Set if the target supports DAX (direct access).
+	 */
+	bool dax_supported:1;
 };
 
 /* Each target can link one of these into the table */
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
