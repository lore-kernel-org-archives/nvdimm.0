Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ACF0881D31
 for <linux-nvdimm@lists.01.org>; Tue,  1 Nov 2016 14:22:13 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/11] dax: Rip out get_block based IO support
Date: Tue,  1 Nov 2016 22:06:21 +0100
Message-Id: <1478034381-19037-12-git-send-email-jack@suse.cz>
In-Reply-To: <1478034381-19037-1-git-send-email-jack@suse.cz>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

No one uses functions using the get_block callback anymore. Rip them
out.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c            | 315 ----------------------------------------------------
 include/linux/dax.h |  12 --
 2 files changed, 327 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 1fdf4c091371..380ca8547e35 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -116,168 +116,6 @@ struct page *read_dax_sector(struct block_device *bdev, sector_t n)
 	return page;
 }
 
-static bool buffer_written(struct buffer_head *bh)
-{
-	return buffer_mapped(bh) && !buffer_unwritten(bh);
-}
-
-static sector_t to_sector(const struct buffer_head *bh,
-		const struct inode *inode)
-{
-	sector_t sector = bh->b_blocknr << (inode->i_blkbits - 9);
-
-	return sector;
-}
-
-static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
-		      loff_t start, loff_t end, get_block_t get_block,
-		      struct buffer_head *bh)
-{
-	loff_t pos = start, max = start, bh_max = start;
-	bool hole = false;
-	struct block_device *bdev = NULL;
-	int rw = iov_iter_rw(iter), rc;
-	long map_len = 0;
-	struct blk_dax_ctl dax = {
-		.addr = ERR_PTR(-EIO),
-	};
-	unsigned blkbits = inode->i_blkbits;
-	sector_t file_blks = (i_size_read(inode) + (1 << blkbits) - 1)
-								>> blkbits;
-
-	if (rw == READ)
-		end = min(end, i_size_read(inode));
-
-	while (pos < end) {
-		size_t len;
-		if (pos == max) {
-			long page = pos >> PAGE_SHIFT;
-			sector_t block = page << (PAGE_SHIFT - blkbits);
-			unsigned first = pos - (block << blkbits);
-			long size;
-
-			if (pos == bh_max) {
-				bh->b_size = PAGE_ALIGN(end - pos);
-				bh->b_state = 0;
-				rc = get_block(inode, block, bh, rw == WRITE);
-				if (rc)
-					break;
-				bh_max = pos - first + bh->b_size;
-				bdev = bh->b_bdev;
-				/*
-				 * We allow uninitialized buffers for writes
-				 * beyond EOF as those cannot race with faults
-				 */
-				WARN_ON_ONCE(
-					(buffer_new(bh) && block < file_blks) ||
-					(rw == WRITE && buffer_unwritten(bh)));
-			} else {
-				unsigned done = bh->b_size -
-						(bh_max - (pos - first));
-				bh->b_blocknr += done >> blkbits;
-				bh->b_size -= done;
-			}
-
-			hole = rw == READ && !buffer_written(bh);
-			if (hole) {
-				size = bh->b_size - first;
-			} else {
-				dax_unmap_atomic(bdev, &dax);
-				dax.sector = to_sector(bh, inode);
-				dax.size = bh->b_size;
-				map_len = dax_map_atomic(bdev, &dax);
-				if (map_len < 0) {
-					rc = map_len;
-					break;
-				}
-				dax.addr += first;
-				size = map_len - first;
-			}
-			/*
-			 * pos + size is one past the last offset for IO,
-			 * so pos + size can overflow loff_t at extreme offsets.
-			 * Cast to u64 to catch this and get the true minimum.
-			 */
-			max = min_t(u64, pos + size, end);
-		}
-
-		if (iov_iter_rw(iter) == WRITE) {
-			len = copy_from_iter_pmem(dax.addr, max - pos, iter);
-		} else if (!hole)
-			len = copy_to_iter((void __force *) dax.addr, max - pos,
-					iter);
-		else
-			len = iov_iter_zero(max - pos, iter);
-
-		if (!len) {
-			rc = -EFAULT;
-			break;
-		}
-
-		pos += len;
-		if (!IS_ERR(dax.addr))
-			dax.addr += len;
-	}
-
-	dax_unmap_atomic(bdev, &dax);
-
-	return (pos == start) ? rc : pos - start;
-}
-
-/**
- * dax_do_io - Perform I/O to a DAX file
- * @iocb: The control block for this I/O
- * @inode: The file which the I/O is directed at
- * @iter: The addresses to do I/O from or to
- * @get_block: The filesystem method used to translate file offsets to blocks
- * @end_io: A filesystem callback for I/O completion
- * @flags: See below
- *
- * This function uses the same locking scheme as do_blockdev_direct_IO:
- * If @flags has DIO_LOCKING set, we assume that the i_mutex is held by the
- * caller for writes.  For reads, we take and release the i_mutex ourselves.
- * If DIO_LOCKING is not set, the filesystem takes care of its own locking.
- * As with do_blockdev_direct_IO(), we increment i_dio_count while the I/O
- * is in progress.
- */
-ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
-		  struct iov_iter *iter, get_block_t get_block,
-		  dio_iodone_t end_io, int flags)
-{
-	struct buffer_head bh;
-	ssize_t retval = -EINVAL;
-	loff_t pos = iocb->ki_pos;
-	loff_t end = pos + iov_iter_count(iter);
-
-	memset(&bh, 0, sizeof(bh));
-	bh.b_bdev = inode->i_sb->s_bdev;
-
-	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ)
-		inode_lock(inode);
-
-	/* Protects against truncate */
-	if (!(flags & DIO_SKIP_DIO_COUNT))
-		inode_dio_begin(inode);
-
-	retval = dax_io(inode, iter, pos, end, get_block, &bh);
-
-	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ)
-		inode_unlock(inode);
-
-	if (end_io) {
-		int err;
-
-		err = end_io(iocb, pos, retval, bh.b_private);
-		if (err)
-			retval = err;
-	}
-
-	if (!(flags & DIO_SKIP_DIO_COUNT))
-		inode_dio_end(inode);
-	return retval;
-}
-EXPORT_SYMBOL_GPL(dax_do_io);
-
 /*
  * DAX radix tree locking
  */
@@ -920,105 +758,6 @@ static int dax_insert_mapping(struct address_space *mapping,
 }
 
 /**
- * dax_fault - handle a page fault on a DAX file
- * @vma: The virtual memory area where the fault occurred
- * @vmf: The description of the fault
- * @get_block: The filesystem method used to translate file offsets to blocks
- *
- * When a page fault occurs, filesystems may call this helper in their
- * fault handler for DAX files. dax_fault() assumes the caller has done all
- * the necessary locking for the page fault to proceed successfully.
- */
-int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
-			get_block_t get_block)
-{
-	struct file *file = vma->vm_file;
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
-	void *entry;
-	struct buffer_head bh;
-	unsigned long vaddr = (unsigned long)vmf->virtual_address;
-	unsigned blkbits = inode->i_blkbits;
-	sector_t block;
-	pgoff_t size;
-	int error;
-	int major = 0;
-
-	/*
-	 * Check whether offset isn't beyond end of file now. Caller is supposed
-	 * to hold locks serializing us with truncate / punch hole so this is
-	 * a reliable test.
-	 */
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (vmf->pgoff >= size)
-		return VM_FAULT_SIGBUS;
-
-	memset(&bh, 0, sizeof(bh));
-	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
-	bh.b_bdev = inode->i_sb->s_bdev;
-	bh.b_size = PAGE_SIZE;
-
-	entry = grab_mapping_entry(mapping, vmf->pgoff, 0);
-	if (IS_ERR(entry)) {
-		error = PTR_ERR(entry);
-		goto out;
-	}
-
-	error = get_block(inode, block, &bh, 0);
-	if (!error && (bh.b_size < PAGE_SIZE))
-		error = -EIO;		/* fs corruption? */
-	if (error)
-		goto unlock_entry;
-
-	if (vmf->cow_page) {
-		struct page *new_page = vmf->cow_page;
-		if (buffer_written(&bh))
-			error = copy_user_dax(bh.b_bdev, to_sector(&bh, inode),
-					bh.b_size, new_page, vaddr);
-		else
-			clear_user_highpage(new_page, vaddr);
-		if (error)
-			goto unlock_entry;
-		if (!radix_tree_exceptional_entry(entry)) {
-			vmf->page = entry;
-			return VM_FAULT_LOCKED;
-		}
-		vmf->entry = entry;
-		return VM_FAULT_DAX_LOCKED;
-	}
-
-	if (!buffer_mapped(&bh)) {
-		if (vmf->flags & FAULT_FLAG_WRITE) {
-			error = get_block(inode, block, &bh, 1);
-			count_vm_event(PGMAJFAULT);
-			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
-			major = VM_FAULT_MAJOR;
-			if (!error && (bh.b_size < PAGE_SIZE))
-				error = -EIO;
-			if (error)
-				goto unlock_entry;
-		} else {
-			return dax_load_hole(mapping, entry, vmf);
-		}
-	}
-
-	/* Filesystem should not return unwritten buffers to us! */
-	WARN_ON_ONCE(buffer_unwritten(&bh) || buffer_new(&bh));
-	error = dax_insert_mapping(mapping, bh.b_bdev, to_sector(&bh, inode),
-			bh.b_size, &entry, vma, vmf);
- unlock_entry:
-	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
- out:
-	if (error == -ENOMEM)
-		return VM_FAULT_OOM | major;
-	/* -EBUSY is fine, somebody else faulted on the same PTE */
-	if ((error < 0) && (error != -EBUSY))
-		return VM_FAULT_SIGBUS | major;
-	return VM_FAULT_NOPAGE | major;
-}
-EXPORT_SYMBOL_GPL(dax_fault);
-
-/**
  * dax_pfn_mkwrite - handle first write to DAX page
  * @vma: The virtual memory area where the fault occurred
  * @vmf: The description of the fault
@@ -1078,60 +817,6 @@ int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL_GPL(__dax_zero_page_range);
 
-/**
- * dax_zero_page_range - zero a range within a page of a DAX file
- * @inode: The file being truncated
- * @from: The file offset that is being truncated to
- * @length: The number of bytes to zero
- * @get_block: The filesystem method used to translate file offsets to blocks
- *
- * This function can be called by a filesystem when it is zeroing part of a
- * page in a DAX file.  This is intended for hole-punch operations.  If
- * you are truncating a file, the helper function dax_truncate_page() may be
- * more convenient.
- */
-int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
-							get_block_t get_block)
-{
-	struct buffer_head bh;
-	pgoff_t index = from >> PAGE_SHIFT;
-	unsigned offset = from & (PAGE_SIZE-1);
-	int err;
-
-	/* Block boundary? Nothing to do */
-	if (!length)
-		return 0;
-	if (WARN_ON_ONCE((offset + length) > PAGE_SIZE))
-		return -EINVAL;
-
-	memset(&bh, 0, sizeof(bh));
-	bh.b_bdev = inode->i_sb->s_bdev;
-	bh.b_size = PAGE_SIZE;
-	err = get_block(inode, index, &bh, 0);
-	if (err < 0 || !buffer_written(&bh))
-		return err;
-
-	return __dax_zero_page_range(bh.b_bdev, to_sector(&bh, inode),
-			offset, length);
-}
-EXPORT_SYMBOL_GPL(dax_zero_page_range);
-
-/**
- * dax_truncate_page - handle a partial page being truncated in a DAX file
- * @inode: The file being truncated
- * @from: The file offset that is being truncated to
- * @get_block: The filesystem method used to translate file offsets to blocks
- *
- * Similar to block_truncate_page(), this function can be called by a
- * filesystem when it is truncating a DAX file to handle the partial page.
- */
-int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
-{
-	unsigned length = PAGE_ALIGN(from) - from;
-	return dax_zero_page_range(inode, from, length, get_block);
-}
-EXPORT_SYMBOL_GPL(dax_truncate_page);
-
 #ifdef CONFIG_FS_IOMAP
 static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 8d1a5c47945f..0afade8bd3d7 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -38,13 +38,8 @@ static inline void *dax_radix_locked_entry(sector_t sector, unsigned long flags)
 
 ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		struct iomap_ops *ops);
-ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *,
-		  get_block_t, dio_iodone_t, int flags);
-int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
-int dax_truncate_page(struct inode *, loff_t from, get_block_t);
 int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			struct iomap_ops *ops);
-int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 void dax_wake_mapping_entry_waiter(struct address_space *mapping,
 		pgoff_t index, void *entry, bool wake_all);
@@ -73,12 +68,6 @@ static inline int __dax_zero_page_range(struct block_device *bdev,
 }
 #endif
 
-static inline int dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
-				pmd_t *pmd, unsigned int flags, get_block_t gb)
-{
-	return VM_FAULT_FALLBACK;
-}
-
 #ifdef CONFIG_FS_DAX_PMD
 static inline unsigned int dax_radix_order(void *entry)
 {
@@ -101,7 +90,6 @@ static inline int dax_iomap_pmd_fault(struct vm_area_struct *vma,
 }
 #endif
 int dax_pfn_mkwrite(struct vm_area_struct *, struct vm_fault *);
-#define dax_mkwrite(vma, vmf, gb)	dax_fault(vma, vmf, gb)
 
 static inline bool vma_is_dax(struct vm_area_struct *vma)
 {
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
