Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2FC0E1A1F74
 for <linux-nvdimm@lists.01.org>; Tue, 10 May 2016 09:33:04 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v4 2/6] block: Add bdev_dax_supported() for dax mount checks
Date: Tue, 10 May 2016 10:23:53 -0600
Message-Id: <1462897437-16626-3-git-send-email-toshi.kani@hpe.com>
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

DAX imposes additional requirements to a device.  Add
bdev_dax_supported() which performs all the precondition checks
necessary for filesystem to mount the device with dax option.

Also add a new check to verify if a partition is aligned by 4KB.
When a partition is unaligned, any dax read/write access fails,
except for metadata update.

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
 fs/block_dev.c         |   45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    1 +
 2 files changed, 46 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7be17c4..db55638 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -509,6 +509,51 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
 }
 EXPORT_SYMBOL_GPL(bdev_direct_access);
 
+/**
+ * bdev_dax_supported() - Check if the device supports dax for filesystem
+ * @sb: The superblock of the device
+ * @blocksize: The block size of the device
+ *
+ * This is a library function for filesystems to check if the block device
+ * can be mounted with dax option.
+ *
+ * Return: negative errno if unsupported, 0 if supported.
+ */
+int bdev_dax_supported(struct super_block *sb, int blocksize)
+{
+	struct blk_dax_ctl dax = {
+		.sector = 0,
+		.size = PAGE_SIZE,
+	};
+	int err;
+
+	if (blocksize != PAGE_SIZE) {
+		vfs_msg(sb, KERN_ERR, "error: unsupported blocksize for dax");
+		return -EINVAL;
+	}
+
+	err = bdev_direct_access(sb->s_bdev, &dax);
+	if (err < 0) {
+		switch (err) {
+		case -EOPNOTSUPP:
+			vfs_msg(sb, KERN_ERR,
+				"error: device does not support dax");
+			break;
+		case -EINVAL:
+			vfs_msg(sb, KERN_ERR,
+				"error: unaligned partition for dax");
+			break;
+		default:
+			vfs_msg(sb, KERN_ERR,
+				"error: dax access failed (%d)", err);
+		}
+		return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(bdev_dax_supported);
+
 /*
  * pseudo-fs
  */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 78c48ab..71231a5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1688,6 +1688,7 @@ extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
 extern long bdev_direct_access(struct block_device *, struct blk_dax_ctl *);
+extern int bdev_dax_supported(struct super_block *, int);
 #else /* CONFIG_BLOCK */
 
 struct block_device;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
