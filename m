Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [RFC PATCH v2 1/3] dm: enable dax_operations for dm-snapshot
Date: Wed, 21 Nov 2018 11:27:00 +0800
Message-Id: <20181121032702.3048-2-yehs2007@zoho.com>
In-Reply-To: <20181121032702.3048-1-yehs2007@zoho.com>
References: <20181121032702.3048-1-yehs2007@zoho.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dan.j.williams@intel.com, willy@infradead.org, zwisler@kernel.org, jack@suse.cz, dave.jiang@intel.com, vishal.l.verma@intel.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, chengnt@lenovo.com, Huaisheng Ye <yehs1@lenovo.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

Reconstruct origin_dax_direct_access and expand functions
origin_dax_copy_to/from_iter for DAX operations of dm-snapshot.

Here is the call trace of origin_dax_copy_to_iter,
origin_dax_copy_to_iter will callin dm-linear (-real) for further
dax_operation.

[518597.924019] Call Trace:
[518597.927320]  dump_stack+0x65/0x7e
[518597.931592]  origin_dax_copy_to_iter+0x51/0x78 [dm_snapshot]
[518597.938494]  dm_dax_copy_to_iter+0x86/0xc5 [dm_mod]
[518597.944519]  dax_copy_to_iter+0x27/0x29
[518597.949371]  dax_iomap_actor+0x264/0x326
[518597.954308]  ? trace_event_raw_event_dax_pmd_load_hole_class+0xd0/0xd0
[518597.962159]  iomap_apply+0xc7/0x128
[518597.966609]  ? trace_event_raw_event_dax_pmd_load_hole_class+0xd0/0xd0
[518597.974447]  dax_iomap_rw+0x66/0xa8
[518597.978893]  ? trace_event_raw_event_dax_pmd_load_hole_class+0xd0/0xd0
[518597.986741]  ext2_file_read_iter+0x4f/0x83 [ext2]
[518597.992552]  __vfs_read+0x130/0x168
[518597.997001]  vfs_read+0x92/0x146
[518598.001155]  ksys_read+0x4f/0xa5
[518598.005308]  __x64_sys_read+0x16/0x18
[518598.009942]  do_syscall_64+0x88/0x15f
[518598.014575]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/md/dm-snap.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index ae4b33d..714e26f 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -19,6 +19,7 @@
 #include <linux/vmalloc.h>
 #include <linux/log2.h>
 #include <linux/dm-kcopyd.h>
+#include <linux/dax.h>
 
 #include "dm.h"
 
@@ -2316,13 +2317,57 @@ static int origin_map(struct dm_target *ti, struct bio *bio)
 	return do_origin(o->dev, bio);
 }
 
+#if IS_ENABLED(CONFIG_DAX_DRIVER)
 static long origin_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
-	DMWARN("device does not support dax.");
-	return -EIO;
+	long ret = 0;
+	struct dm_origin *o = ti->private;
+	struct block_device *bdev = o->dev->bdev;
+	struct dax_device *dax_dev = o->dev->dax_dev;
+	sector_t sector = pgoff * PAGE_SECTORS;
+
+	ret = bdev_dax_pgoff(bdev, sector, nr_pages * PAGE_SIZE, &pgoff);
+	if (ret)
+		return ret;
+
+	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
+}
+
+static size_t origin_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i)
+{
+	struct dm_origin *o = ti->private;
+	struct block_device *bdev = o->dev->bdev;
+	struct dax_device *dax_dev = o->dev->dax_dev;
+	sector_t sector = pgoff * PAGE_SECTORS;
+
+	if (bdev_dax_pgoff(bdev, sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
+		return 0;
+
+	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
 }
 
+static size_t origin_dax_copy_to_iter(struct dm_target *ti, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i)
+{
+	struct dm_origin *o = ti->private;
+	struct block_device *bdev = o->dev->bdev;
+	struct dax_device *dax_dev = o->dev->dax_dev;
+	sector_t sector = pgoff * PAGE_SECTORS;
+
+	if (bdev_dax_pgoff(bdev, sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
+		return 0;
+
+	return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
+}
+
+#else
+#define origin_dax_direct_access NULL
+#define origin_dax_copy_from_iter NULL
+#define origin_dax_copy_to_iter NULL
+#endif
+
 /*
  * Set the target "max_io_len" field to the minimum of all the snapshots'
  * chunk sizes.
@@ -2383,6 +2428,8 @@ static int origin_iterate_devices(struct dm_target *ti,
 	.status  = origin_status,
 	.iterate_devices = origin_iterate_devices,
 	.direct_access = origin_dax_direct_access,
+	.dax_copy_to_iter = origin_dax_copy_to_iter,
+	.dax_copy_from_iter = origin_dax_copy_from_iter,
 };
 
 static struct target_type snapshot_target = {
-- 
1.8.3.1
