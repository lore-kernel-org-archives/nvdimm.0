Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v6 06/15] ext2, dax: introduce ext2_dax_aops
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Mar 2018 08:51:56 -0700
Message-ID: <152112911591.24669.7494781212673308769.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.com>, david@fromorbit.com, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz, ross.zwisler@linux.intel.comhch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for the dax implementation to start associating dax pages
to inodes via page->mapping, we need to provide a 'struct
address_space_operations' instance for dax. Otherwise, direct-I/O
triggers incorrect page cache assumptions and warnings.

Cc: Jan Kara <jack@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/ext2.h  |    1 +
 fs/ext2/inode.c |   43 +++++++++++++++++++++++++++----------------
 fs/ext2/namei.c |   18 ++----------------
 3 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 032295e1d386..cc40802ddfa8 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -814,6 +814,7 @@ extern const struct inode_operations ext2_file_inode_operations;
 extern const struct file_operations ext2_file_operations;
 
 /* inode.c */
+extern void ext2_set_file_ops(struct inode *inode);
 extern const struct address_space_operations ext2_aops;
 extern const struct address_space_operations ext2_nobh_aops;
 extern const struct iomap_ops ext2_iomap_ops;
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 9b2ac55ac34f..9590712f2f88 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -952,17 +952,16 @@ ext2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 static int
 ext2_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
-#ifdef CONFIG_FS_DAX
-	if (dax_mapping(mapping)) {
-		return dax_writeback_mapping_range(mapping,
-						   mapping->host->i_sb->s_bdev,
-						   wbc);
-	}
-#endif
-
 	return mpage_writepages(mapping, wbc, ext2_get_block);
 }
 
+static int
+ext2_dax_writepages(struct address_space *mapping, struct writeback_control *wbc)
+{
+	return dax_writeback_mapping_range(mapping,
+			mapping->host->i_sb->s_bdev, wbc);
+}
+
 const struct address_space_operations ext2_aops = {
 	.readpage		= ext2_readpage,
 	.readpages		= ext2_readpages,
@@ -990,6 +989,13 @@ const struct address_space_operations ext2_nobh_aops = {
 	.error_remove_page	= generic_error_remove_page,
 };
 
+const struct address_space_operations ext2_dax_aops = {
+	.direct_IO		= ext2_direct_IO,
+	.writepages		= ext2_dax_writepages,
+	.set_page_dirty		= noop_set_page_dirty,
+	.invalidatepage		= noop_invalidatepage,
+};
+
 /*
  * Probably it should be a library function... search for first non-zero word
  * or memcmp with zero_page, whatever is better for particular architecture.
@@ -1388,6 +1394,18 @@ void ext2_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_DAX;
 }
 
+void ext2_set_file_ops(struct inode *inode)
+{
+	inode->i_op = &ext2_file_inode_operations;
+	inode->i_fop = &ext2_file_operations;
+	if (IS_DAX(inode))
+		inode->i_mapping->a_ops = &ext2_dax_aops;
+	else if (test_opt(inode->i_sb, NOBH))
+		inode->i_mapping->a_ops = &ext2_nobh_aops;
+	else
+		inode->i_mapping->a_ops = &ext2_aops;
+}
+
 struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 {
 	struct ext2_inode_info *ei;
@@ -1480,14 +1498,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 		ei->i_data[n] = raw_inode->i_block[n];
 
 	if (S_ISREG(inode->i_mode)) {
-		inode->i_op = &ext2_file_inode_operations;
-		if (test_opt(inode->i_sb, NOBH)) {
-			inode->i_mapping->a_ops = &ext2_nobh_aops;
-			inode->i_fop = &ext2_file_operations;
-		} else {
-			inode->i_mapping->a_ops = &ext2_aops;
-			inode->i_fop = &ext2_file_operations;
-		}
+		ext2_set_file_ops(inode);
 	} else if (S_ISDIR(inode->i_mode)) {
 		inode->i_op = &ext2_dir_inode_operations;
 		inode->i_fop = &ext2_dir_operations;
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index e078075dc66f..55f7caadb093 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -107,14 +107,7 @@ static int ext2_create (struct inode * dir, struct dentry * dentry, umode_t mode
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
-	inode->i_op = &ext2_file_inode_operations;
-	if (test_opt(inode->i_sb, NOBH)) {
-		inode->i_mapping->a_ops = &ext2_nobh_aops;
-		inode->i_fop = &ext2_file_operations;
-	} else {
-		inode->i_mapping->a_ops = &ext2_aops;
-		inode->i_fop = &ext2_file_operations;
-	}
+	ext2_set_file_ops(inode);
 	mark_inode_dirty(inode);
 	return ext2_add_nondir(dentry, inode);
 }
@@ -125,14 +118,7 @@ static int ext2_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
-	inode->i_op = &ext2_file_inode_operations;
-	if (test_opt(inode->i_sb, NOBH)) {
-		inode->i_mapping->a_ops = &ext2_nobh_aops;
-		inode->i_fop = &ext2_file_operations;
-	} else {
-		inode->i_mapping->a_ops = &ext2_aops;
-		inode->i_fop = &ext2_file_operations;
-	}
+	ext2_set_file_ops(inode);
 	mark_inode_dirty(inode);
 	d_tmpfile(dentry, inode);
 	unlock_new_inode(inode);
