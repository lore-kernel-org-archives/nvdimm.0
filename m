Return-Path: <linux-ext4-owner@vger.kernel.org>
Subject: [PATCH v2 6/7] ext4: skip inode dirty when backing device is gone
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 Nov 2015 10:37:29 -0800
Message-ID: <20151125183729.12508.60473.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151125183656.12508.52212.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151125183656.12508.52212.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, linux-block@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Use SB_I_BDI_DEAD to prevent dirtying an inode after a del_gendisk()
event.

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
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/fs-writeback.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 023f6a1f23cd..33e8b24f78ab 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2005,6 +2005,9 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		flags &= ~I_DIRTY_TIME;
 	dirtytime = flags & I_DIRTY_TIME;
 
+	if (sb->s_iflags & SB_I_BDI_DEAD)
+		return;
+
 	/*
 	 * Paired with smp_mb() in __writeback_single_inode() for the
 	 * following lockless i_state test.  See there for details.

