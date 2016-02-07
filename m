Return-Path: <owner-linux-mm@kvack.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/2] DAX bdev fixes - move flushing calls to FS
Date: Sun,  7 Feb 2016 00:19:11 -0700
Message-Id: <1454829553-29499-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, xfs@oss.sgi.com
List-ID: <linux-nvdimm@lists.01.org>

The first patch in the series just adds a bdev argument to
dax_clear_blocks(), and should be relatively straightforward.

The second patch is slightly more controversial.  During testing of raw block
devices + DAX I noticed that the struct block_device that we were using for DAX
operations was incorrect.  For the fault handlers, etc. we can just get the
correct bdev via get_block(), which is passed in as a function pointer, but for
the flushing code we don't have access to get_block().  This is also an issue
for XFS real-time devices, whenever we get those working.

In short, somehow we need to get dax_writeback_mapping_range() a valid bdev.
Right now it is called via filemap_write_and_wait_range(), which can't provide
either the bdev nor a get_block() function pointer.  So, our options seem to
be:

  a) Move the calls to dax_writeback_mapping_range() into the filesystems.
  This is implemented by patch 2 in this series.

  b) Keep the calls to dax_writeback_mapping_range() in the mm code, and
  provide a generic way to ask a filesystem for an inode's bdev.  I did a
  version of this using a superblock operation here:

  https://lkml.org/lkml/2016/2/2/941

It has been noted that we may need to expand the coverage of our DAX
flushing code to include support for the sync() and syncfs() userspace
calls.  This is still under discussion, but if we do end up needing to add
support for sync(), I don't think that it is v4.5 material for the reasons
stated here:

https://lkml.org/lkml/2016/2/4/962

I think that for v4.5 we either need patch 2 of this series, or the
get_bdev() patch listed in for solution b) above.

Ross Zwisler (2):
  dax: pass bdev argument to dax_clear_blocks()
  dax: move writeback calls into the filesystems

 fs/block_dev.c         |  7 +++++++
 fs/dax.c               |  9 ++++-----
 fs/ext2/file.c         | 10 ++++++++++
 fs/ext2/inode.c        |  5 +++--
 fs/ext4/fsync.c        | 10 +++++++++-
 fs/xfs/xfs_aops.c      |  2 +-
 fs/xfs/xfs_aops.h      |  1 +
 fs/xfs/xfs_bmap_util.c |  4 +++-
 fs/xfs/xfs_file.c      | 12 ++++++++++--
 include/linux/dax.h    |  7 ++++---
 mm/filemap.c           |  6 ------
 11 files changed, 52 insertions(+), 21 deletions(-)

-- 
2.5.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
