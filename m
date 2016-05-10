Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5C2B81A1F74
 for <linux-nvdimm@lists.01.org>; Tue, 10 May 2016 09:33:03 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v4 1/6] block: Add vfs_msg() interface
Date: Tue, 10 May 2016 10:23:52 -0600
Message-Id: <1462897437-16626-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
References: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com, jack@suse.cz, david@fromorbit.com, viro@zeniv.linux.org.uk
Cc: hch@infradead.org, tytso@mit.edu, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, axboe@fb.com, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation of moving DAX capability checks to the block layer
from filesystem code, add a VFS message interface that aligns with
filesystem's message format.

For instance, a vfs_msg() message followed by XFS messages in case
of a dax mount error may look like:

  VFS (pmem0p1): error: unaligned partition for dax
  XFS (pmem0p1): DAX unsupported by block device. Turning off DAX.
  XFS (pmem0p1): Mounting V5 Filesystem
   :

vfs_msg() is largely based on ext4_msg().

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@fb.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <boaz@plexistor.com>
---
 fs/block_dev.c         |   12 ++++++++++++
 include/linux/blkdev.h |   11 +++++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 20a2c02..7be17c4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -50,6 +50,18 @@ struct block_device *I_BDEV(struct inode *inode)
 }
 EXPORT_SYMBOL(I_BDEV);
 
+void __vfs_msg(struct super_block *sb, const char *prefix, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	printk_ratelimited("%sVFS (%s): %pV\n", prefix, sb->s_id, &vaf);
+	va_end(args);
+}
+
 static void bdev_write_inode(struct block_device *bdev)
 {
 	struct inode *inode = bdev->bd_inode;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 669e419..78c48ab 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -767,6 +767,17 @@ static inline void rq_flush_dcache_pages(struct request *rq)
 }
 #endif
 
+#ifdef CONFIG_PRINTK
+#define vfs_msg(sb, level, fmt, ...)				\
+	__vfs_msg(sb, level, fmt, ##__VA_ARGS__)
+#else
+#define vfs_msg(sb, level, fmt, ...)				\
+do {								\
+	no_printk(fmt, ##__VA_ARGS__);				\
+	__vfs_msg(sb, "", " ");					\
+} while (0)
+#endif
+
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 extern blk_qc_t generic_make_request(struct bio *bio);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
