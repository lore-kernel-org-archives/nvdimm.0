Return-Path: <linux-ext4-owner@vger.kernel.org>
Subject: [PATCH] ext4: drop file_update_time from ext4_dax_fault
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Nov 2015 16:18:13 -0800
Message-ID: <20151120001813.27997.41722.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Ted Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

Neither the filemap_fault() nor the xfs dax fault path is updating time.
This call leads to the following WARN() when the block device has been
torn down:

 WARNING: CPU: 0 PID: 2133 at fs/fs-writeback.c:2065 __mark_inode_dirty+0x261/0x350()
 bdi-block not registered
 [..]
 Call Trace:
  [<ffffffff81459f62>] dump_stack+0x44/0x62
  [<ffffffff810a2052>] warn_slowpath_common+0x82/0xc0
  [<ffffffff810a20ec>] warn_slowpath_fmt+0x5c/0x80
  [<ffffffff812831a1>] __mark_inode_dirty+0x261/0x350
  [<ffffffff8126d109>] generic_update_time+0x79/0xd0
  [<ffffffff8126d28d>] file_update_time+0xbd/0x110
  [<ffffffff812e4bc8>] ext4_dax_fault+0x68/0x110
  [<ffffffff811f816e>] __do_fault+0x4e/0xf0
  [<ffffffff811fc2a7>] handle_mm_fault+0x5e7/0x1b50
  [<ffffffff811fbd11>] ? handle_mm_fault+0x51/0x1b50
  [<ffffffff810689c1>] __do_page_fault+0x191/0x3f0
  [<ffffffff81068cef>] trace_do_page_fault+0x4f/0x120
  [<ffffffff8106314a>] do_async_page_fault+0x1a/0xa0
  [<ffffffff81902678>] async_page_fault+0x28/0x30

Cc: Jan Kara <jack@suse.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext4/file.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 113837e7ba98..76854dd6dd7d 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -214,7 +214,6 @@ static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	if (write) {
 		sb_start_pagefault(sb);
-		file_update_time(vma->vm_file);
 		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
 						EXT4_DATA_TRANS_BLOCKS(sb));
 	}
@@ -245,7 +244,6 @@ static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 
 	if (write) {
 		sb_start_pagefault(sb);
-		file_update_time(vma->vm_file);
 		handle = ext4_journal_start_sb(sb, EXT4_HT_WRITE_PAGE,
 				ext4_chunk_trans_blocks(inode,
 							PMD_SIZE / PAGE_SIZE));

