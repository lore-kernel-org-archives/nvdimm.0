Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C1FA220945C0D
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 22:02:37 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 2/5] ext4: prevent data corruption with journaling + DAX
Date: Mon, 11 Sep 2017 23:05:23 -0600
Message-Id: <20170912050526.7627-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
References: <20170912050526.7627-1-ross.zwisler@linux.intel.com>
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
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

The current code has the potential for data corruption when changing an
inode's journaling mode, as that can result in a subsequent unsafe change
in S_DAX.

I've captured an instance of this data corruption in the following fstest:

https://patchwork.kernel.org/patch/9948377/

Prevent this data corruption from happening by disallowing changes to the
journaling mode if the '-o dax' mount option was used.  This means that for
a given filesystem we could have a mix of inodes using either DAX or
data journaling, but whatever state the inodes are in will be held for the
duration of the mount.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |  5 -----
 fs/ext4/ioctl.c | 16 +++++++++++++---
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e963508..3207333 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5971,11 +5971,6 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		ext4_clear_inode_flag(inode, EXT4_INODE_JOURNAL_DATA);
 	}
 	ext4_set_aops(inode);
-	/*
-	 * Update inode->i_flags after EXT4_INODE_JOURNAL_DATA was updated.
-	 * E.g. S_DAX may get cleared / set.
-	 */
-	ext4_set_inode_flags(inode);
 
 	jbd2_journal_unlock_updates(journal);
 	percpu_up_write(&sbi->s_journal_flag_rwsem);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index afb66d4..b0b754b 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -290,10 +290,20 @@ static int ext4_ioctl_setflags(struct inode *inode,
 	if (err)
 		goto flags_out;
 
-	if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
+	if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL)) {
+		/*
+		 * Changes to the journaling mode can cause unsafe changes to
+		 * S_DAX if we are using the DAX mount option.
+		 */
+		if (test_opt(inode->i_sb, DAX)) {
+			err = -EBUSY;
+			goto flags_out;
+		}
+
 		err = ext4_change_inode_journal_flag(inode, jflag);
-	if (err)
-		goto flags_out;
+		if (err)
+			goto flags_out;
+	}
 	if (migrate) {
 		if (flags & EXT4_EXTENTS_FL)
 			err = ext4_ext_migrate(inode);
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
