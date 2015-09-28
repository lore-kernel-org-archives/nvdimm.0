Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 28 Sep 2015 20:12:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] dax: fix deadlock in __dax_fault
Message-ID: <20150928101214.GA19114@dastard>
References: <1443040800-5460-1-git-send-email-ross.zwisler@linux.intel.com>
 <20150924025225.GT3902@dastard>
 <20150924155029.GA6008@linux.intel.com>
 <20150925025357.GU3902@dastard>
 <20150926031745.GA560@linux.intel.com>
 <20150928005904.GY19114@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150928005904.GY19114@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 28, 2015 at 10:59:04AM +1000, Dave Chinner wrote:
> > Does this sound like a reasonable path forward for v4.3?  Dave, and Jan, can
> > you guys can provide guidance and code reviews for the XFS and ext4 bits?
> 
> IMO, it's way too much to get into 4.3. I'd much prefer we revert
> the bad changes in 4.3, and then work towards fixing this for the
> 4.4 merge window. If someone needs this for 4.3, then they can
> backport the 4.4 code to 4.3-stable.

FWIW, here's the first bit of making XFS clear blocks during
allocation. There's a couple of things I need to fix (e.g. moving
the zeroing out of the transaction context but still under the inode
allocation lock and hence atomic with the allocation), it needs to
be split into at least two patches (to split out the
xfs_imap_to_sector() helper), and there's another patch to remove
the complete_unwritten callbacks. I also need to do more audit and
validation on the handling of unwritten extents during get_blocks()
for write faults - the get_blocks() call in this case effectively
becomes an unwritten extent conversion call rather than an
allocation call, and I need to validate that it does what get_block
expects it to do. And that I haven't broken any of the other
get_blocks callers. So still lots to do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: Don't use unwritten extents for DAX

From: Dave Chinner <dchinner@redhat.com>

DAX has a page fault serialisation problem with block allocation.
Because it allows concurrent page faults and does not have a page
lock to serialise faults to the same page, it can get two concurrent
faults to the page that race.

When two read faults race, this isn't a huge problem as the data
underlying the page is not changing and so "detect and drop" works
just fine. The issues are to do with write faults.

When two write faults occur, we serialise block allocation in
get_blocks() so only one faul will allocate the extent. It will,
however, be marked as an unwritten extent, and that is where the
problem lies - the DAX fault code cannot differentiate between a
block that was just allocated and a block that was preallocated and
needs zeroing. The result is that both write faults end up zeroing
the block and attempting to convert it back to written.

The problem is that the first fault can zero and convert before the
second fault starts zeroing, resulting in the zeroing for the second
fault overwriting the data that the first fault wrote with zeros.
The second fault then attempts to convert the unwritten extent,
which is then a no-op because it's already written. Data loss occurs
as a result of this race.

Because there is no sane locking construct in the page fault code
that we can use for serialisation across the page faults, we need to
ensure block allocation and zeroing occurs atomically in the
filesystem. This means we can still take concurrent page faults and
the only time they will serialise is in the filesystem
mapping/allocation callback. The page fault code will always see
written, initialised extents, so we will be able to remove the
unwritten extent handling from the DAX code when all filesystems are
converted.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c  | 40 ++++++++++++++++++++++++----------------
 fs/xfs/xfs_aops.h  |  5 +++++
 fs/xfs/xfs_iomap.c | 38 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 50ab287..f645587 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -586,27 +586,35 @@ xfs_add_to_ioend(
 	ioend->io_size += bh->b_size;
 }
 
-STATIC void
-xfs_map_buffer(
+sector_t
+xfs_imap_to_sector(
 	struct inode		*inode,
-	struct buffer_head	*bh,
 	struct xfs_bmbt_irec	*imap,
 	xfs_off_t		offset)
 {
-	sector_t		bn;
-	struct xfs_mount	*m = XFS_I(inode)->i_mount;
-	xfs_off_t		iomap_offset = XFS_FSB_TO_B(m, imap->br_startoff);
-	xfs_daddr_t		iomap_bn = xfs_fsb_to_db(XFS_I(inode), imap->br_startblock);
+	struct xfs_mount	*mp = XFS_I(inode)->i_mount;
+	xfs_off_t		iomap_offset;
+	xfs_daddr_t		iomap_bn;
 
 	ASSERT(imap->br_startblock != HOLESTARTBLOCK);
 	ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
 
-	bn = (iomap_bn >> (inode->i_blkbits - BBSHIFT)) +
-	      ((offset - iomap_offset) >> inode->i_blkbits);
+	iomap_bn = xfs_fsb_to_db(XFS_I(inode), imap->br_startblock);
+	iomap_offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 
-	ASSERT(bn || XFS_IS_REALTIME_INODE(XFS_I(inode)));
+	return iomap_bn + BTOBB(offset - iomap_offset);
+}
 
-	bh->b_blocknr = bn;
+STATIC void
+xfs_map_buffer(
+	struct inode		*inode,
+	struct buffer_head	*bh,
+	struct xfs_bmbt_irec	*imap,
+	xfs_off_t		offset)
+{
+	bh->b_blocknr = xfs_imap_to_sector(inode, imap, offset) >>
+						(inode->i_blkbits - BBSHIFT);
+	ASSERT(bh->b_blocknr || XFS_IS_REALTIME_INODE(XFS_I(inode)));
 	set_buffer_mapped(bh);
 }
 
@@ -617,11 +625,7 @@ xfs_map_at_offset(
 	struct xfs_bmbt_irec	*imap,
 	xfs_off_t		offset)
 {
-	ASSERT(imap->br_startblock != HOLESTARTBLOCK);
-	ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
-
 	xfs_map_buffer(inode, bh, imap, offset);
-	set_buffer_mapped(bh);
 	clear_buffer_delay(bh);
 	clear_buffer_unwritten(bh);
 }
@@ -1396,7 +1400,8 @@ __xfs_get_blocks(
 	if (create &&
 	    (!nimaps ||
 	     (imap.br_startblock == HOLESTARTBLOCK ||
-	      imap.br_startblock == DELAYSTARTBLOCK))) {
+	      imap.br_startblock == DELAYSTARTBLOCK) ||
+	     (IS_DAX(inode) && ISUNWRITTEN(&imap)))) {
 		if (direct || xfs_get_extsz_hint(ip)) {
 			/*
 			 * Drop the ilock in preparation for starting the block
@@ -1441,6 +1446,9 @@ __xfs_get_blocks(
 		goto out_unlock;
 	}
 
+	if (IS_DAX(inode))
+		ASSERT(!ISUNWRITTEN(&imap));
+
 	/* trim mapping down to size requested */
 	if (direct || size > (1 << inode->i_blkbits))
 		xfs_map_trim_size(inode, iblock, bh_result,
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 86afd1a..ede1025 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -18,6 +18,8 @@
 #ifndef __XFS_AOPS_H__
 #define __XFS_AOPS_H__
 
+struct xfs_bmbt_irec;
+
 extern mempool_t *xfs_ioend_pool;
 
 /*
@@ -62,4 +64,7 @@ void	xfs_end_io_dax_write(struct buffer_head *bh, int uptodate);
 
 extern void xfs_count_page_state(struct page *, int *, int *);
 
+sector_t xfs_imap_to_sector(struct inode *inode, struct xfs_bmbt_irec *imap,
+			    xfs_off_t offset);
+
 #endif /* __XFS_AOPS_H__ */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1f86033..277cd82 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -131,6 +131,7 @@ xfs_iomap_write_direct(
 	uint		qblocks, resblks, resrtextents;
 	int		committed;
 	int		error;
+	int		bmapi_flags = XFS_BMAPI_PREALLOC;
 
 	error = xfs_qm_dqattach(ip, 0);
 	if (error)
@@ -196,13 +197,26 @@ xfs_iomap_write_direct(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
+	 * For DAX, we do not allocate unwritten extents, but instead we zero
+	 * the block before we commit the transaction. Hence if we are mapping
+	 * unwritten extents here, we need to convert them to written so that we
+	 * don't need an unwritten extent callback here.
+	 *
+	 * Block zeroing for DAX is effectively a memset operation and so should
+	 * not block on anything when we call it after the block allocation or
+	 * conversion before we commit the transaction.
+	 */
+	if (IS_DAX(VFS_I(ip)))
+		bmapi_flags = XFS_BMAPI_CONVERT;
+
+	/*
 	 * From this point onwards we overwrite the imap pointer that the
 	 * caller gave to us.
 	 */
 	xfs_bmap_init(&free_list, &firstfsb);
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-				XFS_BMAPI_PREALLOC, &firstfsb, 0,
+				bmapi_flags, &firstfsb, 0,
 				imap, &nimaps, &free_list);
 	if (error)
 		goto out_bmap_cancel;
@@ -213,6 +227,28 @@ xfs_iomap_write_direct(
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error)
 		goto out_bmap_cancel;
+
+	/* DAX needs to zero the entire allocated extent here */
+	if (IS_DAX(VFS_I(ip)) && nimaps) {
+		sector_t sector = xfs_imap_to_sector(VFS_I(ip), imap, offset);
+
+		ASSERT(!ISUNWRITTEN(imap));
+		ASSERT(nimaps == 1);
+		error = dax_clear_blocks(VFS_I(ip),
+				sector >> (VFS_I(ip)->i_blkbits - BBSHIFT),
+				XFS_FSB_TO_B(mp, imap->br_blockcount));
+		if (error) {
+			xfs_warn(mp,
+ "err %d, off/cnt %lld/%ld, sector %ld, bytes %lld, im.stblk %lld, im.stoff %lld, im.blkcnt %lld",
+				error, offset, count, 
+				xfs_imap_to_sector(VFS_I(ip), imap, offset),
+				XFS_FSB_TO_B(mp, imap->br_blockcount),
+				imap->br_startblock, imap->br_startoff,
+				imap->br_blockcount);
+			goto out_trans_cancel;
+		}
+	}
+
 	error = xfs_trans_commit(tp);
 	if (error)
 		goto out_unlock;
