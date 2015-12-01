Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH 3/3] writeback: fix false positive WARN in __mark_inode_dirty
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 01 Dec 2015 15:58:52 -0800
Message-ID: <20151201235852.36836.87208.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151201235836.36836.90416.stgit@dwillia2-desk3.jf.intel.com>
References: <20151201235836.36836.90416.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

This warning was added as a debugging aid way back in commit
500b067c5e6c "writeback: check for registered bdi in flusher add and
inode dirty" when we were switching over to per-bdi writeback.

Once the block device has been torn down it's no longer useful to
complain about unregistered bdi's.  Clear the writeback capability under
the the wb->list_lock(), so that __mark_inode_dirty has no opportunity
to race bdi_unregister() to this WARN() condition.

Alternatively we could just delete the warning...

Found this while testing block device remove from underneath an active
fs triggering traces like:

 WARNING: CPU: 6 PID: 2129 at fs/fs-writeback.c:2065 __mark_inode_dirty+0x261/0x350()
 bdi-block not registered
 [..]
 Call Trace:
  [<ffffffff81459f02>] dump_stack+0x44/0x62
  [<ffffffff810a1f32>] warn_slowpath_common+0x82/0xc0
  [<ffffffff810a1fcc>] warn_slowpath_fmt+0x5c/0x80
  [<ffffffff812830b1>] __mark_inode_dirty+0x261/0x350
  [<ffffffff8126d019>] generic_update_time+0x79/0xd0
  [<ffffffff8126d19d>] file_update_time+0xbd/0x110
  [<ffffffff812e4ab8>] ext4_dax_fault+0x68/0x110
  [<ffffffff811f7f3e>] __do_fault+0x4e/0xf0
  [<ffffffff811fc077>] handle_mm_fault+0x5e7/0x1b50
  [<ffffffff811fbae1>] ? handle_mm_fault+0x51/0x1b50
  [<ffffffff81068981>] __do_page_fault+0x191/0x3f0
  [<ffffffff81068caf>] trace_do_page_fault+0x4f/0x120
  [<ffffffff810630fa>] do_async_page_fault+0x1a/0xa0
  [<ffffffff819023f8>] async_page_fault+0x28/0x30

Cc: Jan Kara <jack@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@fb.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/backing-dev.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 8ed2ffd963c5..24e61acf74a7 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -343,10 +343,17 @@ static void wb_shutdown(struct bdi_writeback *wb)
 {
 	/* Make sure nobody queues further work */
 	spin_lock_bh(&wb->work_lock);
+
 	if (!test_and_clear_bit(WB_registered, &wb->state)) {
 		spin_unlock_bh(&wb->work_lock);
 		return;
 	}
+
+	/* tell __mark_inode_dirty that writeback is no longer possible */
+	spin_lock(&wb->list_lock);
+	wb->bdi->capabilities |= BDI_CAP_NO_WRITEBACK;
+	spin_unlock(&wb->list_lock);
+
 	spin_unlock_bh(&wb->work_lock);
 
 	/*

