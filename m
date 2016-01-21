Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/5] dax: never rely on bh.b_dev being set by get_block()
Date: Wed, 20 Jan 2016 20:36:44 -0700
Message-Id: <1453347408-22830-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1453347408-22830-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1453347408-22830-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Previously in DAX we assumed that calls to get_block() would set bh.b_bdev,
and we would then use that value even in error cases for debugging.  This
caused a NULL pointer dereference in __dax_dbg() which was fixed by a
previous commit, but that commit only changed the one place where we were
hitting an error.

Instead, update dax.c so that we always initialize bh.b_bdev as best we can
based on the information that DAX has.  get_block() may or may not update
to a new value, but this at least lets us get something helpful from
bh.b_bdev for error messages and not have to worry about whether it was set
by get_block() or not.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 0db21ea..cee9e1b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -246,6 +246,7 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
 	loff_t end = pos + iov_iter_count(iter);
 
 	memset(&bh, 0, sizeof(bh));
+	bh.b_bdev = inode->i_sb->s_bdev;
 
 	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ) {
 		struct address_space *mapping = inode->i_mapping;
@@ -582,6 +583,7 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	memset(&bh, 0, sizeof(bh));
 	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
+	bh.b_bdev = inode->i_sb->s_bdev;
 	bh.b_size = PAGE_SIZE;
 
  repeat:
@@ -1018,6 +1020,7 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 	BUG_ON((offset + length) > PAGE_CACHE_SIZE);
 
 	memset(&bh, 0, sizeof(bh));
+	bh.b_bdev = inode->i_sb->s_bdev;
 	bh.b_size = PAGE_CACHE_SIZE;
 	err = get_block(inode, index, &bh, 0);
 	if (err < 0)
-- 
2.5.0
