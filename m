Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 49DAC223522B6
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 19:56:52 -0800 (PST)
Subject: [PATCH v5 04/12] ext2,
 dax: define ext2_dax_*() infrastructure in all cases
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 01 Mar 2018 19:53:55 -0800
Message-ID: <151996283559.28483.2221179891176741624.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
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
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

In preparation for fixing S_DAX to be defined in the CONFIG_FS_DAX=n +
CONFIG_DEV_DAX=y case, move the definition of these routines outside of
the "#ifdef CONFIG_FS_DAX" guard. This is also a coding-style fix to
move all ifdef handling to header files rather than in the source. The
compiler will still be able to determine that all the related code can
be discarded in the CONFIG_FS_DAX=n case.

Cc: <stable@vger.kernel.org>
Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/file.c      |    8 --------
 include/linux/dax.h |   10 ++++++++--
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 1c7ea1bcddde..5ac98d074323 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -29,7 +29,6 @@
 #include "xattr.h"
 #include "acl.h"
 
-#ifdef CONFIG_FS_DAX
 static ssize_t ext2_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
@@ -128,9 +127,6 @@ static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
 	vma->vm_flags |= VM_MIXEDMAP;
 	return 0;
 }
-#else
-#define ext2_file_mmap	generic_file_mmap
-#endif
 
 /*
  * Called when filp is released. This happens when all file descriptors
@@ -162,19 +158,15 @@ int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 
 static ssize_t ext2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
-#ifdef CONFIG_FS_DAX
 	if (IS_DAX(iocb->ki_filp->f_mapping->host))
 		return ext2_dax_read_iter(iocb, to);
-#endif
 	return generic_file_read_iter(iocb, to);
 }
 
 static ssize_t ext2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
-#ifdef CONFIG_FS_DAX
 	if (IS_DAX(iocb->ki_filp->f_mapping->host))
 		return ext2_dax_write_iter(iocb, from);
-#endif
 	return generic_file_write_iter(iocb, from);
 }
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 0185ecdae135..47edbce4fc52 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -93,8 +93,6 @@ void dax_flush(struct dax_device *dax_dev, void *addr, size_t size);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
 
-ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
-		const struct iomap_ops *ops);
 int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
 		    pfn_t *pfnp, int *errp, const struct iomap_ops *ops);
 int dax_finish_sync_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
@@ -107,6 +105,8 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 int __dax_zero_page_range(struct block_device *bdev,
 		struct dax_device *dax_dev, sector_t sector,
 		unsigned int offset, unsigned int length);
+ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
+		const struct iomap_ops *ops);
 #else
 static inline int __dax_zero_page_range(struct block_device *bdev,
 		struct dax_device *dax_dev, sector_t sector,
@@ -114,6 +114,12 @@ static inline int __dax_zero_page_range(struct block_device *bdev,
 {
 	return -ENXIO;
 }
+
+static inline ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
+		const struct iomap_ops *ops)
+{
+	return -ENXIO;
+}
 #endif
 
 static inline bool dax_mapping(struct address_space *mapping)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
