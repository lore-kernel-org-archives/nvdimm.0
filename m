Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A301421AEB0A0
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 06:33:13 -0700 (PDT)
Date: Wed, 26 Jul 2017 09:35:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH][V2] dm,dax: Make sure dm_dax_flush() is called if device
 supports it
Message-ID: <20170726133509.GA5416@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: dm-devel@redhat.com, linux-nvdimm@lists.01.org
Cc: Mike Snitzer <snitzer@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Right now, dm_dax_flush() is not being called and I think it is not being
called becuase DAXDEV_WRITE_CACHE is not set on dm dax device.

If underlying dax device supports write cache, set DAXDEV_WRITE_CACHE on
dm dax device. This will get dm_dax_flush() being called.

Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/dax/super.c   |  6 ++++++
 drivers/md/dm-table.c | 35 +++++++++++++++++++++++++++++++++++
 include/linux/dax.h   |  1 +
 3 files changed, 42 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index ce9e563..938eb48 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -278,6 +278,12 @@ void dax_write_cache(struct dax_device *dax_dev, bool wc)
 }
 EXPORT_SYMBOL_GPL(dax_write_cache);
 
+bool dax_write_cache_enabled(struct dax_device *dax_dev)
+{
+	return test_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
+}
+EXPORT_SYMBOL_GPL(dax_write_cache_enabled);
+
 bool dax_alive(struct dax_device *dax_dev)
 {
 	lockdep_assert_held(&dax_srcu);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a39bcd9..28a4071 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -20,6 +20,7 @@
 #include <linux/atomic.h>
 #include <linux/blk-mq.h>
 #include <linux/mount.h>
+#include <linux/dax.h>
 
 #define DM_MSG_PREFIX "table"
 
@@ -1630,6 +1631,37 @@ static bool dm_table_supports_flush(struct dm_table *t, unsigned long flush)
 	return false;
 }
 
+static int device_dax_write_cache_enabled(struct dm_target *ti,
+					  struct dm_dev *dev, sector_t start,
+					  sector_t len, void *data)
+{
+	struct dax_device *dax_dev = dev->dax_dev;
+
+	if (!dax_dev)
+		return false;
+
+	if (dax_write_cache_enabled(dax_dev))
+		return true;
+	return false;
+}
+
+static int dm_table_supports_dax_write_cache(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned i;
+
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (ti->type->iterate_devices &&
+		    ti->type->iterate_devices(ti,
+				device_dax_write_cache_enabled, NULL))
+			return true;
+	}
+
+	return false;
+}
+
 static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
 			    sector_t start, sector_t len, void *data)
 {
@@ -1785,6 +1817,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	}
 	blk_queue_write_cache(q, wc, fua);
 
+	if (dm_table_supports_dax_write_cache(t))
+		dax_write_cache(t->md->dax_dev, true);
+
 	/* Ensure that all underlying devices are non-rotational. */
 	if (dm_table_all_devices_attribute(t, device_is_nonrot))
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 7948118..df97b7a 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -87,6 +87,7 @@ size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 void dax_flush(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t size);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
+bool dax_write_cache_enabled(struct dax_device *dax_dev);
 
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
