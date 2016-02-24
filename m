Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 24 Feb 2016 11:42:42 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [GIT PULL] dax-fixes for 4.5-rc6
Message-ID: <20160224184242.GA2858@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git dax-fixes

This fixes several issues with the current DAX code, including possible data
corruption and kernel OOPSes.  This also includes bugs with raw block devices
that never opt-in to DAX, so can affect existing applications and setups.

1) DAX is used by default on raw block devices that are capable of
supporting it.  This creates an issue because there are still uses of the
block device that use the page cache, and having one block device user
doing DAX I/O and another doing page cache I/O can lead to data corruption.

2) When S_DAX is set on an inode we assume that if there are pages attached
to the mapping (mapping->nrpages != 0), those pages are clean zero pages
that were used to service reads from holes.  This wasn't true in all cases.

3) ext4 online defrag combined with DAX I/O could lead to data corruption.

4) The DAX block/sector zeroing code needs a valid struct block_device,
which it wasn't always getting.  This could lead to a kernel OOPS.

5) The DAX writeback code needs a valid struct block_device, which it
wasn't always getting.  This could lead to a kernel OOPS.

6) The DAX writeback code needs to be called for sync(2) and syncfs(2).
This could lead to data loss.

I know DAX fixes have historically gone up through Andrew Morton's -mm tree,
but for some reason he's been silent on this series for the last few weeks.  I
think that the problems being fixed are important enough that we really
shouldn't wait until v4.6.

Please let me know if you'd like additional justification on why I think these
should be merged, or if you have any questions.

Thanks,
- Ross

----------------------------------------------------------------
Dan Williams (1):
  block: disable block device DAX by default

Ross Zwisler (4):
  ext2, ext4: only set S_DAX for regular inodes
  ext4: Online defrag not supported with DAX
  dax: give DAX clearing code correct bdev
  dax: move writeback calls into the filesystems

 block/Kconfig          | 13 +++++++++++++
 fs/block_dev.c         | 19 +++++++++++++++++--
 fs/dax.c               | 21 +++++++++++----------
 fs/ext2/inode.c        | 16 +++++++++++++---
 fs/ext4/inode.c        |  6 +++++-
 fs/ext4/ioctl.c        |  5 +++++
 fs/xfs/xfs_aops.c      |  6 +++++-
 fs/xfs/xfs_aops.h      |  1 +
 fs/xfs/xfs_bmap_util.c |  3 ++-
 include/linux/dax.h    |  8 +++++---
 mm/filemap.c           | 12 ++++--------
 11 files changed, 81 insertions(+), 29 deletions(-)

commit 1f20410488863337259f528b3210c464c72ee27c
Author: Ross Zwisler <ross.zwisler@linux.intel.com>
Date:   Sun Feb 7 00:19:13 2016 -0700

    dax: move writeback calls into the filesystems
    
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

commit dda4dcbdc9242eb600aa2d271d80bf7e1762aa63
Author: Ross Zwisler <ross.zwisler@linux.intel.com>
Date:   Fri Feb 5 22:07:04 2016 -0700

    dax: give DAX clearing code correct bdev
    
    dax_clear_blocks() needs a valid struct block_device and previously it was
    using inode->i_sb->s_bdev in all cases.  This is correct for normal inodes
    on mounted ext2, ext4 and XFS filesystems, but is incorrect for DAX raw
    block devices and for XFS real-time devices.
    
    Instead, rename dax_clear_blocks() to dax_clear_sectors(), and change its
    arguments to take a bdev and a sector instead of an inode and a block.
    This better reflects what the function does, and it allows the filesystem
    and raw block device code to pass in an appropriate struct block_device.
    
    Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
    Suggested-by: Dan Williams <dan.j.williams@intel.com>
    Reviewed-by: Jan Kara <jack@suse.cz>

commit 0e2dcfb5b46129c01738d610b7a4aa4165800d5e
Author: Ross Zwisler <ross.zwisler@linux.intel.com>
Date:   Sat Feb 13 21:44:27 2016 -0700

    ext4: Online defrag not supported with DAX
    
    Online defrag operations for ext4 are hard coded to use the page cache.
    See ext4_ioctl() -> ext4_move_extents() -> move_extent_per_page()
    
    When combined with DAX I/O, which circumvents the page cache, this can
    result in data corruption.  This was observed with xfstests ext4/307 and
    ext4/308.
    
    Fix this by only allowing online defrag for non-DAX files.
    
    Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
    Reviewed-by: Jan Kara <jack@suse.cz>

commit 10d08a7339df8a252c7365d8877c72acd2aed109
Author: Ross Zwisler <ross.zwisler@linux.intel.com>
Date:   Fri Feb 12 18:15:25 2016 -0700

    ext2, ext4: only set S_DAX for regular inodes
    
    When S_DAX is set on an inode we assume that if there are pages attached
    to the mapping (mapping->nrpages != 0), those pages are clean zero pages
    that were used to service reads from holes.  Any dirty data associated with
    the inode should be in the form of DAX exceptional entries
    (mapping->nrexceptional) that is written back via
    dax_writeback_mapping_range().
    
    With the current code, though, this isn't always true.  For example, ext2
    and ext4 directory inodes can have S_DAX set, but have their dirty data
    stored as dirty page cache entries.  For these types of inodes, having
    S_DAX set doesn't really make sense since their I/O doesn't actually happen
    through the DAX code path.
    
    Instead, only allow S_DAX to be set for regular inodes for ext2 and ext4.
    This allows us to have strict DAX vs non-DAX paths in the writeback code.
    
    Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
    Reviewed-by: Jan Kara <jack@suse.cz>

commit 67e8c633958de5c168ed857c94a4573cc0442c97
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Feb 12 13:08:47 2016 -0800

    block: disable block device DAX by default
    
    The recent *sync enabling discovered that we are inserting into the
    block_device pagecache counter to the expectations of the dirty data
    tracking for dax mappings.  This can lead to data corruption.
    
    We want to support DAX for block devices eventually, but it requires
    wider changes to properly manage the pagecache.
    
      [<ffffffff81576d93>] dump_stack+0x85/0xc2
      [<ffffffff812b9ee0>] dax_writeback_mapping_range+0x60/0xe0
      [<ffffffff812a1d4f>] blkdev_writepages+0x3f/0x50
      [<ffffffff811db011>] do_writepages+0x21/0x30
      [<ffffffff811cb6a6>] __filemap_fdatawrite_range+0xc6/0x100
      [<ffffffff811cb75a>] filemap_write_and_wait+0x4a/0xa0
      [<ffffffff812a15e0>] set_blocksize+0x70/0xd0
      [<ffffffff812a273d>] sb_set_blocksize+0x1d/0x50
      [<ffffffff8132ac9b>] ext4_fill_super+0x75b/0x3360
      [<ffffffff81583381>] ? vsnprintf+0x201/0x4c0
      [<ffffffff815836d9>] ? snprintf+0x49/0x60
      [<ffffffff81263010>] mount_bdev+0x180/0x1b0
      [<ffffffff8132a540>] ? ext4_calculate_overhead+0x370/0x370
      [<ffffffff8131ad95>] ext4_mount+0x15/0x20
      [<ffffffff81263908>] mount_fs+0x38/0x170
    
    Mark the support broken so its disabled by default, but otherwise still
    available for testing.
    
    Cc: Jan Kara <jack@suse.cz>
    Cc: Jens Axboe <axboe@fb.com>
    Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
    Cc: Al Viro <viro@ftp.linux.org.uk>
    Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
    Suggested-by: Dave Chinner <david@fromorbit.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
    Reviewed-by: Jan Kara <jack@suse.cz>
