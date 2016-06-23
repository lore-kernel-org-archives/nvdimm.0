From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 3/4] dm: add infrastructure for DAX support
Date: Thu, 23 Jun 2016 17:05:52 -0400
Message-ID: <1466715953-40692-4-git-send-email-snitzer@redhat.com>
References: <1466715953-40692-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1466715953-40692-1-git-send-email-snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, toshi.kani-ZPxbGqLxI0U@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

From: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>

Change mapped device to implement direct_access function,
dm_blk_direct_access(), which calls a target direct_access function.
'struct target_type' is extended to have target direct_access interface.
This function limits direct accessible size to the dm_target's limit
with max_io_len().

Add dm_table_supports_dax() to iterate all targets and associated block
devices to check for DAX support.  To add DAX support to a DM target the
target must only implement the direct_access function.

Add a new dm type, DM_TYPE_DAX_BIO_BASED, which indicates that mapped
device supports DAX and is bio based.  This new type is used to assure
that all target devices have DAX support and remain that way after
QUEUE_FLAG_DAX is set in mapped device.

At initial table load, QUEUE_FLAG_DAX is set to mapped device when setting
DM_TYPE_DAX_BIO_BASED to the type.  Any subsequent table load to the
mapped device must have the same type, or else it fails per the check in
table_load().

Signed-off-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Signed-off-by: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/md/dm-table.c         | 44 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm.c               | 38 +++++++++++++++++++++++++++++++++++--
 drivers/md/dm.h               |  1 +
 include/linux/device-mapper.h | 10 ++++++++++
 include/uapi/linux/dm-ioctl.h |  4 ++--
 5 files changed, 92 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 88f0174..ee6f37e 100644
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
@@ -839,6 +845,34 @@ void dm_table_set_type(struct dm_table *t, unsigned type)
 }
 EXPORT_SYMBOL_GPL(dm_table_set_type);
 
+static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
+			       sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && blk_queue_dax(q);
+}
+
+static bool dm_table_supports_dax(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned i = 0;
+
+	/* Ensure that all targets support DAX. */
+	while (i < dm_table_get_num_targets(t)) {
+		ti = dm_table_get_target(t, i++);
+
+		if (!ti->type->direct_access)
+			return false;
+
+		if (!ti->type->iterate_devices ||
+		    !ti->type->iterate_devices(ti, device_supports_dax, NULL))
+			return false;
+	}
+
+	return true;
+}
+
 static int dm_table_determine_type(struct dm_table *t)
 {
 	unsigned i;
@@ -853,6 +887,7 @@ static int dm_table_determine_type(struct dm_table *t)
 		/* target already set the table's type */
 		if (t->type == DM_TYPE_BIO_BASED)
 			return 0;
+		BUG_ON(t->type == DM_TYPE_DAX_BIO_BASED);
 		goto verify_rq_based;
 	}
 
@@ -887,6 +922,8 @@ static int dm_table_determine_type(struct dm_table *t)
 	if (bio_based) {
 		/* We must use this table as bio-based */
 		t->type = DM_TYPE_BIO_BASED;
+		if (dm_table_supports_dax(t))
+			t->type = DM_TYPE_DAX_BIO_BASED;
 		return 0;
 	}
 
@@ -979,6 +1016,11 @@ struct dm_target *dm_table_get_wildcard_target(struct dm_table *t)
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
@@ -1001,7 +1043,7 @@ static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *
 		return -EINVAL;
 	}
 
-	if (type == DM_TYPE_BIO_BASED)
+	if (__table_type_bio_based(type))
 		for (i = 0; i < t->num_targets; i++) {
 			tgt = t->targets + i;
 			per_io_data_size = max(per_io_data_size, tgt->per_io_data_size);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2c907bc..62f6c24 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -905,6 +905,33 @@ int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
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
+		goto out;
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
+	return min(ret, size);
+}
+
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_PREFLUSH.
@@ -1548,7 +1575,7 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 
 	if (md->bs) {
 		/* The md already has necessary mempools. */
-		if (dm_table_get_type(t) == DM_TYPE_BIO_BASED) {
+		if (dm_table_bio_based(t)) {
 			/*
 			 * Reload bioset because front_pad may have changed
 			 * because a different table was loaded.
@@ -1744,8 +1771,9 @@ EXPORT_SYMBOL_GPL(dm_get_queue_limits);
 int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 {
 	int r;
+	unsigned type = dm_get_md_type(md);
 
-	switch (dm_get_md_type(md)) {
+	switch (type) {
 	case DM_TYPE_REQUEST_BASED:
 		r = dm_old_init_request_queue(md);
 		if (r) {
@@ -1761,6 +1789,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 		}
 		break;
 	case DM_TYPE_BIO_BASED:
+	case DM_TYPE_DAX_BIO_BASED:
 		dm_init_normal_md_queue(md);
 		blk_queue_make_request(md->queue, dm_make_request);
 		/*
@@ -1769,6 +1798,9 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 		 */
 		bioset_free(md->queue->bio_split);
 		md->queue->bio_split = NULL;
+
+		if (type == DM_TYPE_DAX_BIO_BASED)
+			queue_flag_set_unlocked(QUEUE_FLAG_DAX, md->queue);
 		break;
 	}
 
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
index 2ce3392..b0db857 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -26,6 +26,7 @@ struct bio_vec;
 #define DM_TYPE_BIO_BASED		1
 #define DM_TYPE_REQUEST_BASED		2
 #define DM_TYPE_MQ_REQUEST_BASED	3
+#define DM_TYPE_DAX_BIO_BASED		4
 
 typedef enum { STATUSTYPE_INFO, STATUSTYPE_TABLE } status_type_t;
 
@@ -124,6 +125,14 @@ typedef void (*dm_io_hints_fn) (struct dm_target *ti,
  */
 typedef int (*dm_busy_fn) (struct dm_target *ti);
 
+/*
+ * Returns:
+ *  < 0 : error
+ * >= 0 : the number of bytes accessible at the address
+ */
+typedef long (*dm_direct_access_fn) (struct dm_target *ti, sector_t sector,
+				     void __pmem **kaddr, pfn_t *pfn, long size);
+
 void dm_error(const char *message);
 
 struct dm_dev {
@@ -170,6 +179,7 @@ struct target_type {
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
+	dm_direct_access_fn direct_access;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 30afd0a..4bf9f1e 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -267,9 +267,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	34
+#define DM_VERSION_MINOR	35
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2015-10-28)"
+#define DM_VERSION_EXTRA	"-ioctl (2016-06-23)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
-- 
2.7.4 (Apple Git-66)
