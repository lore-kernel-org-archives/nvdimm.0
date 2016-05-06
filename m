Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9658F1A1F7C
 for <linux-nvdimm@lists.01.org>; Thu,  5 May 2016 17:38:57 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 2/5] block: Add bdev_supports_dax() for dax mount checks
Date: Thu,  5 May 2016 18:29:53 -0600
Message-Id: <1462494596-20938-3-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1462494596-20938-1-git-send-email-toshi.kani@hpe.com>
References: <1462494596-20938-1-git-send-email-toshi.kani@hpe.com>
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
Cc: hch@infradead.org, tytso@mit.edu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, axboe@fb.com, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

DAX imposes additional requirements to a device.  Add
bdev_supports_dax() which performs all the precondition checks
necessary for filesystem to mount the device with dax option.

Also add a new check to verify if a partition is aligned by 4KB.
When a partition is unaligned, any dax read/write access fails,
except for metadata update.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
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
 fs/block_dev.c         |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    1 +
 2 files changed, 43 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7be17c4..e51a2c3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -509,6 +509,48 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
 }
 EXPORT_SYMBOL_GPL(bdev_direct_access);
 
+/**
+ * bdev_supports_dax() - Check if the block device supports DAX
+ * @sb: The superblock of the device
+ * @blocksize: The block size of the device
+ *
+ * Return: negative errno if unsupported, 0 if supported.
+ */
+int bdev_supports_dax(struct super_block *sb, int blocksize)
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
+EXPORT_SYMBOL_GPL(bdev_supports_dax);
+
 /*
  * pseudo-fs
  */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 78c48ab..6a792aa 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1688,6 +1688,7 @@ extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
 extern long bdev_direct_access(struct block_device *, struct blk_dax_ctl *);
+extern int bdev_supports_dax(struct super_block *, int);
 #else /* CONFIG_BLOCK */
 
 struct block_device;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
