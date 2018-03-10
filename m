Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 44BCE21ED1C42
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 22:57:58 -0800 (PST)
Subject: [PATCH v5 04/11] ext2, dax: introduce ext2_dax_aops
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Mar 2018 22:55:10 -0800
Message-ID: <152066491013.40260.6636252082600988714.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: jack@suse.cz, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

In preparation for the dax implementation to start associating dax pages
to inodes via page->mapping, we need to provide a 'struct
address_space_operations' instance for dax. Otherwise, direct-I/O
triggers incorrect page cache assumptions and warnings.

Cc: Jan Kara <jack@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/ext2.h  |    1 +
 fs/ext2/inode.c |   28 ++++++++++++++++++++--------
 fs/ext2/namei.c |   18 ++----------------
 3 files changed, 23 insertions(+), 24 deletions(-)

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
index 9b2ac55ac34f..09608f7e9e39 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -990,6 +990,13 @@ const struct address_space_operations ext2_nobh_aops = {
 	.error_remove_page	= generic_error_remove_page,
 };
 
+const struct address_space_operations ext2_dax_aops = {
+	.writepages		= ext2_writepages,
+	.direct_IO		= ext2_direct_IO,
+	.set_page_dirty		= dax_set_page_dirty,
+	.invalidatepage		= dax_invalidatepage,
+};
+
 /*
  * Probably it should be a library function... search for first non-zero word
  * or memcmp with zero_page, whatever is better for particular architecture.
@@ -1388,6 +1395,18 @@ void ext2_set_inode_flags(struct inode *inode)
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
@@ -1480,14 +1499,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
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

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
