Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C39E321E47D6C
 for <linux-nvdimm@lists.01.org>; Tue,  5 Sep 2017 15:33:27 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 5/9] ext4: ext4_change_inode_journal_flag error handling
Date: Tue,  5 Sep 2017 16:35:37 -0600
Message-Id: <20170905223541.20594-6-ross.zwisler@linux.intel.com>
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

Rework the error handling in ext4_change_inode_journal_flag() so that
multiple paths can re-use portions of the same cleanup code via gotos
instead of each path doing their own cleanup.  This will benefit later
patches that add more paths to this function that must be unwound on error.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
CC: stable@vger.kernel.org
---
 fs/ext4/inode.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 864fb94..d218991 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5953,11 +5953,8 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	if (val) {
 		down_write(&EXT4_I(inode)->i_mmap_sem);
 		err = filemap_write_and_wait(inode->i_mapping);
-		if (err < 0) {
-			up_write(&EXT4_I(inode)->i_mmap_sem);
-			ext4_inode_resume_unlocked_dio(inode);
-			return err;
-		}
+		if (err < 0)
+			goto out_unlock;
 	}
 
 	percpu_down_write(&sbi->s_journal_flag_rwsem);
@@ -5975,12 +5972,8 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		ext4_set_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
 	else {
 		err = jbd2_journal_flush(journal);
-		if (err < 0) {
-			jbd2_journal_unlock_updates(journal);
-			percpu_up_write(&sbi->s_journal_flag_rwsem);
-			ext4_inode_resume_unlocked_dio(inode);
-			return err;
-		}
+		if (err < 0)
+			goto out_journal_unlock;
 		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
 	}
 	ext4_set_aops(inode);
@@ -6009,6 +6002,15 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	ext4_std_error(inode->i_sb, err);
 
 	return err;
+
+out_journal_unlock:
+	jbd2_journal_unlock_updates(journal);
+	percpu_up_write(&sbi->s_journal_flag_rwsem);
+out_unlock:
+	if (val)
+		up_write(&EXT4_I(inode)->i_mmap_sem);
+	ext4_inode_resume_unlocked_dio(inode);
+	return err;
 }
 
 static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
