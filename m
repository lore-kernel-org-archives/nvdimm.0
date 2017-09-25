Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B838D2095E513
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 16:11:19 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 6/7] mm, fs: introduce file_operations->post_mmap()
Date: Mon, 25 Sep 2017 17:14:03 -0600
Message-Id: <20170925231404.32723-7-ross.zwisler@linux.intel.com>
In-Reply-To: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When mappings are created the vma->vm_flags that they use vary based on
whether the inode being mapped is using DAX or not.  This setup happens in
XFS via mmap_region()=>call_mmap()=>xfs_file_mmap().

For us to be able to safely use the DAX per-inode flag we need to prevent
S_DAX transitions when any mappings are present, and we will do that by
looking at the address_space->i_mmap tree and returning -EBUSY if any
mappings are present.

Unfortunately at the time that the filesystem's file_operations->mmap()
entry point is called the mapping has not yet been added to the
address_space->i_mmap tree.  This means that at that point in time we
cannot determine whether or not the mapping will be set up to support DAX.

Fix this by adding a new file_operations entry called post_mmap() which is
called after the mapping has been added to the address_space->i_mmap tree.
This post_mmap() op now happens at a time when we can be sure whether the
mapping will use DAX or not, and we can set up the vma->vm_flags
appropriately.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/xfs/xfs_file.c  | 15 ++++++++++++++-
 include/linux/fs.h |  1 +
 mm/mmap.c          |  2 ++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 2816858..9d66aaa 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1087,9 +1087,21 @@ xfs_file_mmap(
 {
 	file_accessed(filp);
 	vma->vm_ops = &xfs_file_vm_ops;
+	return 0;
+}
+
+/* This call happens during mmap(), after the vma has been inserted into the
+ * inode->i_mapping->i_mmap tree.  At this point the decision on whether or
+ * not to use DAX for this mapping has been set and will not change for the
+ * duration of the mapping.
+ */
+STATIC void
+xfs_file_post_mmap(
+	struct file	*filp,
+	struct vm_area_struct *vma)
+{
 	if (IS_DAX(file_inode(filp)))
 		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
-	return 0;
 }
 
 const struct file_operations xfs_file_operations = {
@@ -1103,6 +1115,7 @@ const struct file_operations xfs_file_operations = {
 	.compat_ioctl	= xfs_file_compat_ioctl,
 #endif
 	.mmap		= xfs_file_mmap,
+	.post_mmap	= xfs_file_post_mmap,
 	.open		= xfs_file_open,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 339e737..7c06838 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1701,6 +1701,7 @@ struct file_operations {
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
+	void (*post_mmap) (struct file *, struct vm_area_struct *);
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *, fl_owner_t id);
 	int (*release) (struct inode *, struct file *);
diff --git a/mm/mmap.c b/mm/mmap.c
index 680506f..ee7458a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1711,6 +1711,8 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	/* Once vma denies write, undo our temporary denial count */
 	if (file) {
+		if (file->f_op->post_mmap)
+			file->f_op->post_mmap(file, vma);
 		if (vm_flags & VM_SHARED)
 			mapping_unmap_writable(file->f_mapping);
 		if (vm_flags & VM_DENYWRITE)
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
