Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2EFA621F6A6FC
 for <linux-nvdimm@lists.01.org>; Mon, 26 Feb 2018 20:23:11 -0800 (PST)
Subject: [PATCH v4 03/12] ext2, dax: finish implementing dax_sem helpers
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Feb 2018 20:20:11 -0800
Message-ID: <151970521121.26729.7741760690622342144.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151970519370.26729.1011551137381425076.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151970519370.26729.1011551137381425076.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

dax_sem_{up,down}_write_sem() allow the ext2 dax semaphore to be compiled
out in the CONFIG_FS_DAX=n case. However there are still some open coded
uses of the semaphore. Add dax_sem_{up_read,down_read,_is_locked}()
helpers and convert all open-coded usages of the semaphore to the
helpers.

Cc: Jan Kara <jack@suse.com>
Cc: <stable@vger.kernel.org>
Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/ext2.h  |    6 ++++++
 fs/ext2/file.c  |    5 ++---
 fs/ext2/inode.c |    4 +---
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 032295e1d386..7ceb29733cdb 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -711,9 +711,15 @@ struct ext2_inode_info {
 #ifdef CONFIG_FS_DAX
 #define dax_sem_down_write(ext2_inode)	down_write(&(ext2_inode)->dax_sem)
 #define dax_sem_up_write(ext2_inode)	up_write(&(ext2_inode)->dax_sem)
+#define dax_sem_is_locked(ext2_inode)	rwsem_is_locked(&(ext2_inode)->dax_sem)
+#define dax_sem_down_read(ext2_inode)	down_read(&(ext2_inode)->dax_sem)
+#define dax_sem_up_read(ext2_inode)	up_read(&(ext2_inode)->dax_sem)
 #else
 #define dax_sem_down_write(ext2_inode)
 #define dax_sem_up_write(ext2_inode)
+#define dax_sem_is_locked(ext2_inode)	(true)
+#define dax_sem_down_read(ext2_inode)
+#define dax_sem_up_read(ext2_inode)
 #endif
 
 /*
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 09640220fda8..1c7ea1bcddde 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -91,18 +91,17 @@ static ssize_t ext2_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 static int ext2_dax_fault(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
-	struct ext2_inode_info *ei = EXT2_I(inode);
 	int ret;
 
 	if (vmf->flags & FAULT_FLAG_WRITE) {
 		sb_start_pagefault(inode->i_sb);
 		file_update_time(vmf->vma->vm_file);
 	}
-	down_read(&ei->dax_sem);
+	dax_sem_down_read(EXT2_I(inode));
 
 	ret = dax_iomap_fault(vmf, PE_SIZE_PTE, NULL, NULL, &ext2_iomap_ops);
 
-	up_read(&ei->dax_sem);
+	dax_sem_up_read(EXT2_I(inode));
 	if (vmf->flags & FAULT_FLAG_WRITE)
 		sb_end_pagefault(inode->i_sb);
 	return ret;
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 9b2ac55ac34f..e04295e99d90 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1187,9 +1187,7 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 	blocksize = inode->i_sb->s_blocksize;
 	iblock = (offset + blocksize-1) >> EXT2_BLOCK_SIZE_BITS(inode->i_sb);
 
-#ifdef CONFIG_FS_DAX
-	WARN_ON(!rwsem_is_locked(&ei->dax_sem));
-#endif
+	WARN_ON(!dax_sem_is_locked(ei));
 
 	n = ext2_block_to_path(inode, iblock, offsets, NULL);
 	if (n == 0)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
