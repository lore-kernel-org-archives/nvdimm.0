Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 0/2] Add updated DAX locking to ext2
Date: Tue, 13 Oct 2015 16:25:35 -0600
Message-Id: <1444775137-23685-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The first patch in this series is a somewhat related bug fix.  The second patch
adds new locking to ext2 to isolate DAX faults (page faults, PMD faults, page
mkwrite and pfn mkwrite) from ext2 operations that modify a given inode's data
block allocations.

I've tested this using xfstests with DAX enabled and disabled and verified that
it compiles without errors with and without CONFIG_FS_DAX.

Changes from v1:
 - 'dax_sem' is now only present in struct ext2_inode_info if CONFIG_FS_DAX is
   defined.  This was done to help save space on low-memory machines that are a
   target audience of ext2. (Jan)

 - The locking order between ext2_inode_info->dax_sem and sb_start_pagefault
   was swapped to match the locking order in XFS.  This resulted in more
   open-coding of the various DAX fault routines, and once this is done in ext4
   we should be able to get rid of many (all?) the DAX fault handler wrappers
   that do locking for the filesystems. (Dave)

 - Warn if 'dax_sem' isn't properly held in __ext2_truncate_blocks. (Dan)

Ross Zwisler (2):
  dax: dax_pfn_mkwrite() truncate race check
  ext2: Add locking for DAX faults

 fs/dax.c        | 13 +++++++--
 fs/ext2/ext2.h  | 11 ++++++++
 fs/ext2/file.c  | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/ext2/inode.c | 10 +++++++
 fs/ext2/super.c |  3 +++
 5 files changed, 115 insertions(+), 6 deletions(-)

-- 
2.1.0

