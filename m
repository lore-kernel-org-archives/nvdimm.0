Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5CAC421DFC89E
 for <linux-nvdimm@lists.01.org>; Tue,  5 Sep 2017 15:33:28 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 6/9] ext4: safely transition S_DAX on journaling changes
Date: Tue,  5 Sep 2017 16:35:38 -0600
Message-Id: <20170905223541.20594-7-ross.zwisler@linux.intel.com>
In-Reply-To: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

The IOCTL path which switches the journaling mode for an inode is currently
unsafe because it doesn't properly do a writeback and invalidation on the
inode.  In XFS, for example, safe transitions of S_DAX are handled by
xfs_ioctl_setattr_dax_invalidate() which locks out page faults and I/O,
does a writeback via filemap_write_and_wait() and an invalidation via
invalidate_inode_pages2().

Without this in place we can see the following kernel warning when we try
and insert a DAX exceptional entry but find that a dirty page cache page is
still in the mapping->radix_tree:

 WARNING: CPU: 4 PID: 1052 at mm/filemap.c:262 __delete_from_page_cache+0x375/0x550
 Modules linked in: dax_pmem nd_pmem device_dax nd_btt nfit libnvdimm
 CPU: 4 PID: 1052 Comm: small Not tainted 4.13.0-rc6-00055-gac26931 #3
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.fc25 04/01/2014
 task: ffff88020ccd0000 task.stack: ffffc900021d4000
 RIP: 0010:__delete_from_page_cache+0x375/0x550
 RSP: 0000:ffffc900021d7b90 EFLAGS: 00010002
 RAX: 002fffc00001123d RBX: ffffffffffffffff RCX: ffff8801d9440d68
 RDX: 0000000000000000 RSI: ffffffff81fd5b84 RDI: ffffffff81f6f0e5
 RBP: ffffc900021d7be0 R08: 0000000000000000 R09: ffff8801f9938c70
 R10: 0000000000000021 R11: ffff8801f9938c91 R12: ffff8801d9440d70
 R13: ffffea0007fdda80 R14: 0000000000000001 R15: ffff8801d9440d68
 FS:  00007feacc041700(0000) GS:ffff880211800000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000010420000 CR3: 000000020cfd8000 CR4: 00000000000006e0
 Call Trace:
  dax_insert_mapping_entry+0x158/0x2c0
  dax_iomap_fault+0x1020/0x1bb0
  ext4_dax_huge_fault+0xc8/0x160
  ext4_dax_fault+0x10/0x20
  __do_fault+0x20/0x110
  __handle_mm_fault+0x97d/0x1120
  handle_mm_fault+0x188/0x2f0
  __do_page_fault+0x28f/0x590
  trace_do_page_fault+0x58/0x2c0
  do_async_page_fault+0x2c/0x90
  async_page_fault+0x28/0x30

I'm pretty sure we could make a test that shows userspace visible data
corruption as well in this scenario.

Make it safe to change the journaling mode and turn on or off S_DAX by
adding locking to properly lock out page faults (i_mmap_sem) and then doing
the writeback and invalidate.  I/O is already held off because all callers
of ext4_ioctl_setflags() hold the inode lock.

The locking for this new code is complex because of the following:

1) filemap_write_and_wait() eventually calls ext4_writepages(), which
acquires the sbi->s_journal_flag_rwsem.  This lock ranks above the
jbdw_handle which is eventually taken by ext4_journal_start().  This
essentially means that the writeback has to happen outside of the context
of an active journal handle (outside of ext4_journal_start() to
ext4_journal_stop().)

2) To lock out page faults we take a write lock on the ei->i_mmap_sem, and
this lock again ranks above the jbd2_handle taken by ext4_journal_start().
So, as with the writeback code in 1) above we have to take ei->i_mmap_sem
outside of the context of an active journal handle.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
CC: stable@vger.kernel.org
---
Please let me know if my "context of an active journal handle" terminology
makes sense, or if some other phrasing is more common.

I'll work on an xfstest which shows this data corruption.
---
 fs/ext4/inode.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d218991..facb5ae 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5949,13 +5949,15 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	 * fallocate or buffered writes in dioread_nolock mode covered by
 	 * dirty data which can be converted only after flushing the dirty
 	 * data (and journalled aops don't know how to handle these cases).
+	 *
+	 * Because the changes to our journaling mode may also modify S_DAX we
+	 * need to hold off I/O and page faults so we can write back any dirty
+	 * data and invalidate all mappings.
 	 */
-	if (val) {
-		down_write(&EXT4_I(inode)->i_mmap_sem);
-		err = filemap_write_and_wait(inode->i_mapping);
-		if (err < 0)
-			goto out_unlock;
-	}
+	down_write(&EXT4_I(inode)->i_mmap_sem);
+	err = filemap_write_and_wait(inode->i_mapping);
+	if (err < 0)
+		goto out_unlock;
 
 	percpu_down_write(&sbi->s_journal_flag_rwsem);
 	jbd2_journal_lock_updates(journal);
@@ -5976,6 +5978,11 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 			goto out_journal_unlock;
 		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
 	}
+
+	err = invalidate_inode_pages2(inode->i_mapping);
+	if (err < 0)
+		goto out_journal_unlock;
+
 	ext4_set_aops(inode);
 	/*
 	 * Update inode->i_flags after EXT4_INODE_JOURNAL_DATA was updated.
@@ -5986,8 +5993,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	jbd2_journal_unlock_updates(journal);
 	percpu_up_write(&sbi->s_journal_flag_rwsem);
 
-	if (val)
-		up_write(&EXT4_I(inode)->i_mmap_sem);
+	up_write(&EXT4_I(inode)->i_mmap_sem);
 	ext4_inode_resume_unlocked_dio(inode);
 
 	/* Finally we can mark the inode as dirty. */
@@ -6007,8 +6013,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	jbd2_journal_unlock_updates(journal);
 	percpu_up_write(&sbi->s_journal_flag_rwsem);
 out_unlock:
-	if (val)
-		up_write(&EXT4_I(inode)->i_mmap_sem);
+	up_write(&EXT4_I(inode)->i_mmap_sem);
 	ext4_inode_resume_unlocked_dio(inode);
 	return err;
 }
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
