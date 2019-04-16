Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 88ADE212108E3
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 09:42:38 -0700 (PDT)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 14/18] dax: memcpy before zeroing range
Date: Tue, 16 Apr 2019 11:41:50 -0500
Message-Id: <20190416164154.30390-15-rgoldwyn@suse.de>
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
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
To: linux-btrfs@vger.kernel.org
Cc: kilobyte@angband.pl, jack@suse.cz, darrick.wong@oracle.com, nborisov@suse.com, linux-nvdimm@lists.01.org, david@fromorbit.com, dsterba@suse.cz, willy@infradead.org, linux-fsdevel@vger.kernel.org, hch@lst.de, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

However, this needed more iomap fields, so it was easier
to pass iomap and compute inside the function rather
than passing a log of arguments.

Note, there is subtle difference between iomap_sector and
dax_iomap_sector(). Can we replace dax_iomap_sector with
iomap_sector()? It would need pos & PAGE_MASK though or else
bdev_dax_pgoff() return -EINVAL.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/dax.c              | 14 ++++++++++----
 fs/iomap.c            |  9 +--------
 include/linux/dax.h   | 11 +++++------
 include/linux/iomap.h |  6 ++++++
 4 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index abbe4a79f219..af94909640ea 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1055,11 +1055,15 @@ static bool dax_range_is_aligned(struct block_device *bdev,
 	return true;
 }
 
-int __dax_zero_page_range(struct block_device *bdev,
-		struct dax_device *dax_dev, sector_t sector,
-		unsigned int offset, unsigned int size)
+int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
+			  unsigned int offset, unsigned int size)
 {
-	if (dax_range_is_aligned(bdev, offset, size)) {
+	sector_t sector = dax_iomap_sector(iomap, pos & PAGE_MASK);
+	struct block_device *bdev = iomap->bdev;
+	struct dax_device *dax_dev = iomap->dax_dev;
+
+	if (!(iomap->type == IOMAP_DAX_COW) &&
+	    dax_range_is_aligned(bdev, offset, size)) {
 		sector_t start_sector = sector + (offset >> 9);
 
 		return blkdev_issue_zeroout(bdev, start_sector,
@@ -1079,6 +1083,8 @@ int __dax_zero_page_range(struct block_device *bdev,
 			dax_read_unlock(id);
 			return rc;
 		}
+		if (iomap->type == IOMAP_DAX_COW)
+			memcpy(iomap->inline_data, kaddr, offset);
 		memset(kaddr + offset, 0, size);
 		dax_flush(dax_dev, kaddr + offset, size);
 		dax_read_unlock(id);
diff --git a/fs/iomap.c b/fs/iomap.c
index abdd18e404f8..90698c854883 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -98,12 +98,6 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
 	return written ? written : ret;
 }
 
-static sector_t
-iomap_sector(struct iomap *iomap, loff_t pos)
-{
-	return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
-}
-
 static struct iomap_page *
 iomap_page_create(struct inode *inode, struct page *page)
 {
@@ -990,8 +984,7 @@ static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
 static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
 		struct iomap *iomap)
 {
-	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev,
-			iomap_sector(iomap, pos & PAGE_MASK), offset, bytes);
+	return __dax_zero_page_range(iomap, pos, offset, bytes);
 }
 
 static loff_t
diff --git a/include/linux/dax.h b/include/linux/dax.h
index a11bc7b1f526..892c478d7073 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -9,6 +9,7 @@
 
 typedef unsigned long dax_entry_t;
 
+struct iomap;
 struct iomap_ops;
 struct dax_device;
 struct dax_operations {
@@ -161,13 +162,11 @@ int dax_file_range_compare(struct inode *src, loff_t srcoff, struct inode *dest,
                 loff_t destoff, loff_t len, bool *is_same, const struct iomap_ops *ops);
 
 #ifdef CONFIG_FS_DAX
-int __dax_zero_page_range(struct block_device *bdev,
-		struct dax_device *dax_dev, sector_t sector,
-		unsigned int offset, unsigned int length);
+int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
+		unsigned int offset, unsigned int size);
 #else
-static inline int __dax_zero_page_range(struct block_device *bdev,
-		struct dax_device *dax_dev, sector_t sector,
-		unsigned int offset, unsigned int length)
+static inline int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
+		unsigned int offset, unsigned int size)
 {
 	return -ENXIO;
 }
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 6e885c5a38a3..3a803566dea1 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -7,6 +7,7 @@
 #include <linux/mm.h>
 #include <linux/types.h>
 #include <linux/mm_types.h>
+#include <linux/blkdev.h>
 
 struct address_space;
 struct fiemap_extent_info;
@@ -120,6 +121,11 @@ static inline struct iomap_page *to_iomap_page(struct page *page)
 	return NULL;
 }
 
+static inline sector_t iomap_sector(struct iomap *iomap, loff_t pos)
+{
+	        return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
+}
+
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops);
 int iomap_readpage(struct page *page, const struct iomap_ops *ops);
-- 
2.16.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
