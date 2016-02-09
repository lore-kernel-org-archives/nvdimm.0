Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 9 Feb 2016 17:01:34 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] dax: move writeback calls into the filesystems
Message-ID: <20160209160134.GA12245@quack.suse.cz>
References: <1454829553-29499-1-git-send-email-ross.zwisler@linux.intel.com>
 <1454829553-29499-3-git-send-email-ross.zwisler@linux.intel.com>
 <CAPcyv4jT=yAb2_yLfMGqV1SdbQwoWQj7joroeJGAJAcjsMY_oQ@mail.gmail.com>
 <20160207215047.GJ31407@dastard>
 <CAPcyv4jNmdm-ATTBaLLLzBT+RXJ0YrxxXLYZ=T7xUgEJ8PaSKw@mail.gmail.com>
 <20160208201808.GK27429@dastard>
 <CAPcyv4iHi17pv_VC=WgEP4_GgN9OvSr8xbw1bvbEFMiQ83GbWw@mail.gmail.com>
 <20160209094353.GF9451@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20160209094353.GF9451@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, XFS Developers <xfs@oss.sgi.com>, jmoyer <jmoyer@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 09-02-16 10:43:53, Jan Kara wrote:
> On Mon 08-02-16 12:55:24, Dan Williams wrote:
> > On Mon, Feb 8, 2016 at 12:18 PM, Dave Chinner <david@fromorbit.com> wrote:
> > [..]
> > >> Setting aside the current block zeroing problem you seem to assuming
> > >> that DAX will always be faster and that may not be true at a media
> > >> level.  Waiting years for some applications to determine if DAX makes
> > >> sense for their use case seems completely reasonable.  In the meantime
> > >> the apps that are already making these changes want to know that a DAX
> > >> mapping request has not silently dropped backed to page cache.  They
> > >> also want to know if they successfully jumped through all the hoops to
> > >> get a larger than pte mapping.
> > >>
> > >> I agree it is useful to be able to force DAX on an unmodified
> > >> application to see what happens, and it follows that if those
> > >> applications want to run in that mode they will need functional
> > >> fsync()...
> > >>
> > >> I would feel better if we were talking about specific applications and
> > >> performance numbers to know if forcing DAX on application is a debug
> > >> facility or a production level capability.  You seem to have already
> > >> made that determination and I'm curious what I'm missing.
> > >
> > > I'm not setting any policy here at all.  This whole argument is
> > > based around the DAX mount option doing "global fs enable or
> > > silently turning it off" and the application not knowing about that.
> > >
> > > The whole point of having a persistent per-inode DAX flags is that
> > > it is a policy mechanism, not a policy.  The application can, if it
> > > is DAX aware, directly control whether DAX is used on a file or not.
> > > The application can even query and clear that persistent inode flag
> > > if it is configured not to (or cannot) use DAX.
> > >
> > > If the filesystem cannot support DAX, then we can error out attempts
> > > to set the DAX flag and then the app knows DAX is not available.
> > > i.e. the attempt to set policy failed. If the flag is set, then the
> > > inode will *always* use DAX - there is no "fall back to page cache"
> > > when DAX is enabled.
> > >
> > > If the applicaiton is not DAX aware, then the admin can control the
> > > DAX policy by manipulating these flags themselves, and hence control
> > > whether DAX is used by the application or not.
> > >
> > > If you think I'm dictating policy for DAX users and application,
> > > then you haven't understood anything I've previously said about why
> > > the DAX mount option needs to die before any of this is considered
> > > production ready. DAX is not an opaque "all or nothing" option. XFS
> > > will provide apps and admins with fine-grained, persistent,
> > > discoverable policy flags to allow admins and applications to set
> > > DAX policies however they see fit. This simply cannot be done if the
> > > only knob you have is a mount option that may or may not stick.
> > 
> > I agree the mount option needs to die, and I fully grok the reasoning.
> >   What I'm concerned with is that a system using fully-DAX-aware
> > applications is forced to incur the overhead of maintaining *sync
> > semantics, periodic sync(2) in particular,  even if it is not relying
> > on those semantics.
> 
> Let me somewhat correct this: IMO hard requirement is maintaining sync(2)
> semantics. Periodic writeback does not have any hard durability guarantees
> and we are free to ignore such requests in ->writepages() (that function
> has enough information in the writeback_control structure to differentiate
> between periodic writeback and data integrity sync) if we decide it is
> useful. Actually, we could do that even for 4.5.

Attached is a version of Ross' patch that will work for sync(2) and
fsync(2) and we won't flush caches during periodic writeback. The patch is
only compile-tested. Ross?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--LQksG6bCIzRHxTLp
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-dax-move-writeback-calls-into-the-filesystems.patch"

>From f7280a34d235031c5dbf3f5a345c4b64e452f097 Mon Sep 17 00:00:00 2001
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Sun, 7 Feb 2016 00:19:13 -0700
Subject: [PATCH] dax: move writeback calls into the filesystems

Previously calls to dax_writeback_mapping_range() for all DAX filesystems
(ext2, ext4 & xfs) were centralized in filemap_write_and_wait_range().
dax_writeback_mapping_range() needs a struct block_device, and it used to
get that from inode->i_sb->s_bdev.  This is correct for normal inodes
mounted on ext2, ext4 and XFS filesystems, but is incorrect for DAX raw
block devices and for XFS real-time files.

Instead, call dax_writeback_mapping_range() directly from the filesystem
->writepages function so that it can supply us with a valid block
device. This also fixes DAX code to properly flush caches in response to
sync(2).

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/block_dev.c      | 13 ++++++++++++-
 fs/dax.c            | 12 +++++++-----
 fs/ext2/inode.c     |  8 ++++++++
 fs/ext4/fsync.c     |  1 -
 fs/ext4/inode.c     |  4 ++++
 fs/xfs/xfs_aops.c   |  5 +++++
 include/linux/dax.h |  7 +++++--
 mm/filemap.c        | 12 ++++--------
 8 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 39b3a174a425..271d38aa6cbb 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1693,13 +1693,24 @@ static int blkdev_releasepage(struct page *page, gfp_t wait)
 	return try_to_free_buffers(page);
 }
 
+static int blkdev_writepages(struct address_space *mapping,
+			     struct writeback_control *wbc)
+{
+	if (dax_mapping(mapping)) {
+		struct block_device *bdev = I_BDEV(mapping->host);
+
+		return dax_writeback_mapping_range(mapping, bdev, wbc);
+	}
+	return generic_writepages(mapping, wbc);
+}
+
 static const struct address_space_operations def_blk_aops = {
 	.readpage	= blkdev_readpage,
 	.readpages	= blkdev_readpages,
 	.writepage	= blkdev_writepage,
 	.write_begin	= blkdev_write_begin,
 	.write_end	= blkdev_write_end,
-	.writepages	= generic_writepages,
+	.writepages	= blkdev_writepages,
 	.releasepage	= blkdev_releasepage,
 	.direct_IO	= blkdev_direct_IO,
 	.is_dirty_writeback = buffer_check_dirty_writeback,
diff --git a/fs/dax.c b/fs/dax.c
index fc2e3141138b..2f4965214783 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -485,11 +485,10 @@ static int dax_writeback_one(struct block_device *bdev,
  * end]. This is required by data integrity operations to ensure file data is
  * on persistent storage prior to completion of the operation.
  */
-int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
-		loff_t end)
+int dax_writeback_mapping_range(struct address_space *mapping,
+		struct block_device *bdev, struct writeback_control *wbc)
 {
 	struct inode *inode = mapping->host;
-	struct block_device *bdev = inode->i_sb->s_bdev;
 	pgoff_t start_index, end_index, pmd_index;
 	pgoff_t indices[PAGEVEC_SIZE];
 	struct pagevec pvec;
@@ -500,8 +499,11 @@ int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
 	if (WARN_ON_ONCE(inode->i_blkbits != PAGE_SHIFT))
 		return -EIO;
 
-	start_index = start >> PAGE_CACHE_SHIFT;
-	end_index = end >> PAGE_CACHE_SHIFT;
+	if (!mapping->nrexceptional || wbc->sync_mode != WB_SYNC_ALL)
+		return 0;
+
+	start_index = wbc->range_start >> PAGE_CACHE_SHIFT;
+	end_index = wbc->range_end >> PAGE_CACHE_SHIFT;
 	pmd_index = DAX_PMD_INDEX(start_index);
 
 	rcu_read_lock();
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 338eefda70c6..ee05e945f40c 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -874,6 +874,14 @@ ext2_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 static int
 ext2_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
+#ifdef CONFIG_FS_DAX
+	if (dax_mapping(mapping)) {
+		return dax_writeback_mapping_range(mapping,
+						   mapping->host->i_sb->s_bdev,
+						   wbc);
+	}
+#endif
+
 	return mpage_writepages(mapping, wbc, ext2_get_block);
 }
 
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 8850254136ae..b7136227d0f8 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -83,7 +83,6 @@ static int ext4_sync_parent(struct inode *inode)
  * What we do is just kick off a commit and wait on it.  This will snapshot the
  * inode to disk.
  */
-
 int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 83bc8bfb3bea..19989c12187a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2450,6 +2450,10 @@ static int ext4_writepages(struct address_space *mapping,
 
 	trace_ext4_writepages(inode, wbc);
 
+	if (dax_mapping(mapping))
+		return dax_writeback_mapping_range(mapping, inode->i_sb->s_bdev,
+						   wbc);
+
 	/*
 	 * No pages to write? This is mainly a kludge to avoid starting
 	 * a transaction for special inodes like journal inode on last iput()
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 379c089fb051..fd0839278442 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1208,6 +1208,11 @@ xfs_vm_writepages(
 	struct writeback_control *wbc)
 {
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
+	if (dax_mapping(mapping)) {
+		return dax_writeback_mapping_range(mapping,
+				xfs_find_bdev_for_inode(mapping->host), wbc);
+	}
+
 	return generic_writepages(mapping, wbc);
 }
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 818e45078929..05d7d043d3bd 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -52,6 +52,9 @@ static inline bool dax_mapping(struct address_space *mapping)
 {
 	return mapping->host && IS_DAX(mapping->host);
 }
-int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
-		loff_t end);
+
+struct writeback_control;
+
+int dax_writeback_mapping_range(struct address_space *mapping,
+		struct block_device *bdev, struct writeback_control *wbc);
 #endif
diff --git a/mm/filemap.c b/mm/filemap.c
index bc943867d68c..af3eec1a8c5e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -446,7 +446,8 @@ int filemap_write_and_wait(struct address_space *mapping)
 {
 	int err = 0;
 
-	if (mapping->nrpages) {
+	if ((!dax_mapping(mapping) && mapping->nrpages) ||
+	    (dax_mapping(mapping) && mapping->nrexceptional)) {
 		err = filemap_fdatawrite(mapping);
 		/*
 		 * Even if the above returned error, the pages may be
@@ -482,13 +483,8 @@ int filemap_write_and_wait_range(struct address_space *mapping,
 {
 	int err = 0;
 
-	if (dax_mapping(mapping) && mapping->nrexceptional) {
-		err = dax_writeback_mapping_range(mapping, lstart, lend);
-		if (err)
-			return err;
-	}
-
-	if (mapping->nrpages) {
+	if ((!dax_mapping(mapping) && mapping->nrpages) ||
+	    (dax_mapping(mapping) && mapping->nrexceptional)) {
 		err = __filemap_fdatawrite_range(mapping, lstart, lend,
 						 WB_SYNC_ALL);
 		/* See comment of filemap_write_and_wait() */
-- 
2.6.2


--LQksG6bCIzRHxTLp--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
