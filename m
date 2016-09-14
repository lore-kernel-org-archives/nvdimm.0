From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 12/12] ext2: use iomap to implement DAX
Date: Wed, 14 Sep 2016 12:01:31 +0200
Message-ID: <1473847291-18913-13-git-send-email-hch@lst.de>
References: <1473847291-18913-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1473847291-18913-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/ext2/ext2.h  |  1 +
 fs/ext2/file.c  | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++------
 fs/ext2/inode.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 124 insertions(+), 12 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 06af2f9..37e2be7 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -814,6 +814,7 @@ extern const struct file_operations ext2_file_operations;
 /* inode.c */
 extern const struct address_space_operations ext2_aops;
 extern const struct address_space_operations ext2_nobh_aops;
+extern struct iomap_ops ext2_iomap_ops;
 
 /* namei.c */
 extern const struct inode_operations ext2_dir_inode_operations;
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 5efeefe..e089e1c 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -22,11 +22,59 @@
 #include <linux/pagemap.h>
 #include <linux/dax.h>
 #include <linux/quotaops.h>
+#include <linux/iomap.h>
+#include <linux/uio.h>
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
 
 #ifdef CONFIG_FS_DAX
+static ssize_t ext2_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	ssize_t ret;
+
+	if (!iov_iter_count(to))
+		return 0; /* skip atime */
+
+	inode_lock_shared(inode);
+	ret = iomap_dax_rw(iocb, to, &ext2_iomap_ops);
+	inode_unlock_shared(inode);
+
+	file_accessed(iocb->ki_filp);
+	return ret;
+}
+
+static ssize_t ext2_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	ssize_t ret;
+
+	inode_lock(inode);
+	ret = generic_write_checks(iocb, from);
+	if (ret <= 0)
+		goto out_unlock;
+	ret = file_remove_privs(file);
+	if (ret)
+		goto out_unlock;
+	ret = file_update_time(file);
+	if (ret)
+		goto out_unlock;
+
+	ret = iomap_dax_rw(iocb, from, &ext2_iomap_ops);
+	if (ret > 0 && iocb->ki_pos > i_size_read(inode)) {
+		i_size_write(inode, iocb->ki_pos);
+		mark_inode_dirty(inode);
+	}
+
+out_unlock:
+	inode_unlock(inode);
+	if (ret > 0)
+		ret = generic_write_sync(iocb, ret);
+	return ret;
+}
+
 /*
  * The lock ordering for ext2 DAX fault paths is:
  *
@@ -51,7 +99,7 @@ static int ext2_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	}
 	down_read(&ei->dax_sem);
 
-	ret = dax_fault(vma, vmf, ext2_get_block);
+	ret = iomap_dax_fault(vma, vmf, &ext2_iomap_ops);
 
 	up_read(&ei->dax_sem);
 	if (vmf->flags & FAULT_FLAG_WRITE)
@@ -156,14 +204,24 @@ int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	return ret;
 }
 
-/*
- * We have mostly NULL's here: the current defaults are ok for
- * the ext2 filesystem.
- */
+static ssize_t ext2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	if (IS_DAX(iocb->ki_filp->f_mapping->host))
+		return ext2_dax_read_iter(iocb, to);
+	return generic_file_read_iter(iocb, to);
+}
+
+static ssize_t ext2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	if (IS_DAX(iocb->ki_filp->f_mapping->host))
+		return ext2_dax_write_iter(iocb, from);
+	return generic_file_write_iter(iocb, from);
+}
+
 const struct file_operations ext2_file_operations = {
 	.llseek		= generic_file_llseek,
-	.read_iter	= generic_file_read_iter,
-	.write_iter	= generic_file_write_iter,
+	.read_iter	= ext2_file_read_iter,
+	.write_iter	= ext2_file_write_iter,
 	.unlocked_ioctl = ext2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 2a69ab2..aae5f61 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -32,6 +32,7 @@
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
 #include <linux/fiemap.h>
+#include <linux/iomap.h>
 #include <linux/namei.h>
 #include <linux/uio.h>
 #include "ext2.h"
@@ -787,6 +788,59 @@ int ext2_get_block(struct inode *inode, sector_t iblock,
 
 }
 
+#ifdef CONFIG_FS_DAX
+static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+		unsigned flags, struct iomap *iomap)
+{
+	unsigned int blkbits = inode->i_blkbits;
+	unsigned long first_block = offset >> blkbits;
+	unsigned long max_blocks = (length + (1 << blkbits) - 1) >> blkbits;
+	bool new = false, boundary = false;
+	u32 bno;
+	int ret;
+
+	ret = ext2_get_blocks(inode, first_block, max_blocks,
+			&bno, &new, &boundary, flags & IOMAP_WRITE);
+	if (ret < 0)
+		return ret;
+
+	iomap->flags = 0;
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->offset = first_block << blkbits;
+
+	if (ret == 0) {
+		iomap->type = IOMAP_HOLE;
+		iomap->blkno = IOMAP_NULL_BLOCK;
+		iomap->length = 1 << blkbits;
+	} else {
+		iomap->type = IOMAP_MAPPED;
+		iomap->blkno = (sector_t)bno << (blkbits - 9);
+		iomap->length = (u64)ret << blkbits;
+		iomap->flags |= IOMAP_F_MERGED;
+	}
+
+	if (new)
+		iomap->flags |= IOMAP_F_NEW;
+	return 0;
+}
+
+static int
+ext2_iomap_end(struct inode *inode, loff_t offset, loff_t length,
+		ssize_t written, unsigned flags, struct iomap *iomap)
+{
+	if (iomap->type == IOMAP_MAPPED &&
+	    written < length &&
+	    (flags & IOMAP_WRITE))
+		ext2_write_failed(inode->i_mapping, offset + length);
+	return 0;
+}
+
+struct iomap_ops ext2_iomap_ops = {
+	.iomap_begin		= ext2_iomap_begin,
+	.iomap_end		= ext2_iomap_end,
+};
+#endif /* CONFIG_FS_DAX */
+
 int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		u64 start, u64 len)
 {
@@ -872,11 +926,10 @@ ext2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	loff_t offset = iocb->ki_pos;
 	ssize_t ret;
 
-	if (IS_DAX(inode))
-		ret = dax_do_io(iocb, inode, iter, ext2_get_block, NULL,
-				DIO_LOCKING);
-	else
-		ret = blockdev_direct_IO(iocb, inode, iter, ext2_get_block);
+	if (WARN_ON_ONCE(IS_DAX(inode)))
+		return -EIO;
+
+	ret = blockdev_direct_IO(iocb, inode, iter, ext2_get_block);
 	if (ret < 0 && iov_iter_rw(iter) == WRITE)
 		ext2_write_failed(mapping, offset + count);
 	return ret;
-- 
2.1.4
