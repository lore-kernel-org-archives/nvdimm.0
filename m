Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4DE76212108E3
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 09:42:36 -0700 (PDT)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 13/18] fs: dedup file range to use a compare function
Date: Tue, 16 Apr 2019 11:41:49 -0500
Message-Id: <20190416164154.30390-14-rgoldwyn@suse.de>
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

With dax we cannot deal with readpage() etc. So, we create a
funciton callback to perform the file data comparison and pass
it to generic_remap_file_range_prep() so it can use iomap-based
functions.

This may not be the best way to solve this. Suggestions welcome.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ctree.h     |  9 ++++++++
 fs/btrfs/dax.c       |  7 +++++++
 fs/btrfs/ioctl.c     | 11 ++++++++--
 fs/dax.c             | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/file.c      |  2 +-
 fs/read_write.c      | 10 ++++-----
 fs/xfs/xfs_reflink.c |  2 +-
 include/linux/dax.h  |  2 ++
 include/linux/fs.h   |  7 ++++++-
 9 files changed, 98 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2b7bdabb44f8..d3d044125619 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3803,11 +3803,20 @@ int btree_readahead_hook(struct extent_buffer *eb, int err);
 ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to);
 ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from);
 vm_fault_t btrfs_dax_fault(struct vm_fault *vmf);
+int btrfs_dax_file_range_compare(struct inode *src, loff_t srcoff,
+		struct inode *dest, loff_t destoff, loff_t len,
+		bool *is_same);
 #else
 static inline ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from)
 {
 	return 0;
 }
+static inline int btrfs_dax_file_range_compare(struct inode *src, loff_t srcoff,
+		struct inode *dest, loff_t destoff, loff_t len,
+		bool *is_same)
+{
+	return 0;
+}
 #endif /* CONFIG_FS_DAX */
 
 static inline int is_fstree(u64 rootid)
diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
index de957d681e16..a29628b403b3 100644
--- a/fs/btrfs/dax.c
+++ b/fs/btrfs/dax.c
@@ -227,4 +227,11 @@ vm_fault_t btrfs_dax_fault(struct vm_fault *vmf)
 
 	return ret;
 }
+
+int btrfs_dax_file_range_compare(struct inode *src, loff_t srcoff,
+		struct inode *dest, loff_t destoff, loff_t len,
+		bool *is_same)
+{
+	return dax_file_range_compare(src, srcoff, dest, destoff, len, is_same, &btrfs_iomap_ops);
+}
 #endif /* CONFIG_FS_DAX */
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0138119cd9a3..cd590105bd78 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4000,8 +4000,15 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (ret < 0)
 		goto out_unlock;
 
-	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-					    len, remap_flags);
+	if (IS_DAX(file_inode(file_in)) && IS_DAX(file_inode(file_out)))
+		ret = generic_remap_file_range_prep(file_in, pos_in, file_out,
+				pos_out, len, remap_flags,
+				btrfs_dax_file_range_compare);
+	else
+		ret = generic_remap_file_range_prep(file_in, pos_in, file_out,
+				pos_out, len, remap_flags,
+				vfs_dedupe_file_range_compare);
+
 	if (ret < 0 || *len == 0)
 		goto out_unlock;
 
diff --git a/fs/dax.c b/fs/dax.c
index d5100cbe8bd2..abbe4a79f219 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1759,3 +1759,61 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 	return dax_insert_pfn_mkwrite(vmf, pfn, order);
 }
 EXPORT_SYMBOL_GPL(dax_finish_sync_fault);
+
+
+int dax_file_range_compare(struct inode *src, loff_t srcoff, struct inode *dest,
+		loff_t destoff, loff_t len, bool *is_same, const struct iomap_ops *ops)
+{
+	void *saddr, *daddr;
+	struct iomap s_iomap = {0};
+	struct iomap d_iomap = {0};
+	loff_t dstart, sstart;
+	bool same = true;
+	loff_t cmp_len, l;
+	int id, ret = 0;
+
+	id = dax_read_lock();
+	while (len) {
+		ret = ops->iomap_begin(src, srcoff, len, 0, &s_iomap);
+		if (ret < 0) {
+			if (ops->iomap_end)
+				ops->iomap_end(src, srcoff, len, ret, 0, &s_iomap);
+			return ret;
+		}
+		cmp_len = len;
+		if (cmp_len > s_iomap.offset + s_iomap.length - srcoff)
+			cmp_len = s_iomap.offset + s_iomap.length - srcoff;
+
+		ret = ops->iomap_begin(dest, destoff, cmp_len, 0, &d_iomap);
+		if (ret < 0) {
+			if (ops->iomap_end) {
+				ops->iomap_end(src, srcoff, len, ret, 0, &s_iomap);
+				ops->iomap_end(dest, destoff, len, ret, 0, &d_iomap);
+			}
+			return ret;
+		}
+		if (cmp_len > d_iomap.offset + d_iomap.length - destoff)
+			cmp_len = d_iomap.offset + d_iomap.length - destoff;
+
+
+		sstart = (get_start_sect(s_iomap.bdev) << 9) + s_iomap.addr + (srcoff - s_iomap.offset);
+		l = dax_direct_access(s_iomap.dax_dev, PHYS_PFN(sstart), PHYS_PFN(cmp_len), &saddr, NULL);
+		dstart = (get_start_sect(d_iomap.bdev) << 9) + d_iomap.addr + (destoff - d_iomap.offset);
+		l = dax_direct_access(d_iomap.dax_dev, PHYS_PFN(dstart), PHYS_PFN(cmp_len), &daddr, NULL);
+		same = !memcmp(saddr, daddr, cmp_len);
+		if (!same)
+			break;
+		len -= cmp_len;
+		srcoff += cmp_len;
+		destoff += cmp_len;
+
+		if (ops->iomap_end) {
+			ret = ops->iomap_end(src, srcoff, len, 0, 0, &s_iomap);
+			ret = ops->iomap_end(dest, destoff, len, 0, 0, &d_iomap);
+		}
+	}
+	dax_read_unlock(id);
+	*is_same = same;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dax_file_range_compare);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d640c5f8a85d..9d470306cfc3 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2558,7 +2558,7 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
 		goto out_unlock;
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-			&len, remap_flags);
+			&len, remap_flags, vfs_dedupe_file_range_compare);
 	if (ret < 0 || len == 0)
 		goto out_unlock;
 
diff --git a/fs/read_write.c b/fs/read_write.c
index 61b43ad7608e..ecc67740d0ff 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1778,7 +1778,7 @@ static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
  * Compare extents of two files to see if they are the same.
  * Caller must have locked both inodes to prevent write races.
  */
-static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
+int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 					 struct inode *dest, loff_t destoff,
 					 loff_t len, bool *is_same)
 {
@@ -1845,6 +1845,7 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 out_error:
 	return error;
 }
+EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
 
 /*
  * Check that the two inodes are eligible for cloning, the ranges make
@@ -1856,7 +1857,7 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
  */
 int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
-				  loff_t *len, unsigned int remap_flags)
+				  loff_t *len, unsigned int remap_flags, compare_range_t compare)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -1915,9 +1916,8 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	 */
 	if (remap_flags & REMAP_FILE_DEDUP) {
 		bool		is_same = false;
-
-		ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
-				inode_out, pos_out, *len, &is_same);
+		ret = compare(inode_in, pos_in,
+			inode_out, pos_out, *len, &is_same);
 		if (ret)
 			return ret;
 		if (!is_same)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 680ae7662a78..68e4257cebb0 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1350,7 +1350,7 @@ xfs_reflink_remap_prep(
 		goto out_unlock;
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-			len, remap_flags);
+			len, remap_flags, vfs_dedupe_file_range_compare);
 	if (ret < 0 || *len == 0)
 		goto out_unlock;
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 0dd316a74a29..a11bc7b1f526 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -157,6 +157,8 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
+int dax_file_range_compare(struct inode *src, loff_t srcoff, struct inode *dest,
+                loff_t destoff, loff_t len, bool *is_same, const struct iomap_ops *ops);
 
 #ifdef CONFIG_FS_DAX
 int __dax_zero_page_range(struct block_device *bdev,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dd28e7679089..b1aa2fc105ae 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1883,10 +1883,15 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *, rwf_t);
 extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
+extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
+					 struct inode *dest, loff_t destoff,
+					 loff_t len, bool *is_same);
+typedef int (compare_range_t)(struct inode *src, loff_t srcpos, struct inode *dest,
+		loff_t destpos, loff_t len, bool *is_same);
 extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 					 struct file *file_out, loff_t pos_out,
 					 loff_t *count,
-					 unsigned int remap_flags);
+					 unsigned int remap_flags, compare_range_t cmp);
 extern loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
 				  loff_t len, unsigned int remap_flags);
-- 
2.16.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
