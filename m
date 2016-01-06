Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 1/4] block: prepare for del_gendisk_queue()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 05 Jan 2016 20:56:22 -0800
Message-ID: <20160106045622.38788.38771.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160106045616.38788.61076.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160106045616.38788.61076.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Refactor del_gendisk() into del_gendisk_start() and del_gendisk_end().
These are common helpers that will be shared bewtween del_gendisk() and
the to-be-introduced del_gendisk_queue().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/genhd.c |   41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e5cafa51567c..b1d1df42ba13 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -634,24 +634,14 @@ void add_disk(struct gendisk *disk)
 }
 EXPORT_SYMBOL(add_disk);
 
-void del_gendisk(struct gendisk *disk)
+static void del_gendisk_start(struct gendisk *disk)
 {
-	struct disk_part_iter piter;
-	struct hd_struct *part;
-
 	blk_integrity_del(disk);
 	disk_del_events(disk);
+}
 
-	/* invalidate stuff */
-	disk_part_iter_init(&piter, disk,
-			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
-	while ((part = disk_part_iter_next(&piter))) {
-		invalidate_partition(disk, part->partno);
-		delete_partition(disk, part->partno);
-	}
-	disk_part_iter_exit(&piter);
-
-	invalidate_partition(disk, 0);
+static void del_gendisk_end(struct gendisk *disk)
+{
 	set_capacity(disk, 0);
 	disk->flags &= ~GENHD_FL_UP;
 
@@ -670,6 +660,29 @@ void del_gendisk(struct gendisk *disk)
 	pm_runtime_set_memalloc_noio(disk_to_dev(disk), false);
 	device_del(disk_to_dev(disk));
 }
+
+#define for_each_part(part, piter) \
+	for (part = disk_part_iter_next(piter); part; \
+			part = disk_part_iter_next(piter))
+void del_gendisk(struct gendisk *disk)
+{
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+
+	del_gendisk_start(disk);
+
+	/* invalidate stuff */
+	disk_part_iter_init(&piter, disk,
+			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
+	for_each_part(part, &piter) {
+		invalidate_partition(disk, part->partno);
+		delete_partition(disk, part->partno);
+	}
+	disk_part_iter_exit(&piter);
+	invalidate_partition(disk, 0);
+
+	del_gendisk_end(disk);
+}
 EXPORT_SYMBOL(del_gendisk);
 
 /**

