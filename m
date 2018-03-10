Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x242.google.com (mail-pg0-x242.google.com
 [IPv6:2607:f8b0:400e:c05::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 26C9322603B0A
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:33 -0800 (PST)
Received: by mail-pg0-x242.google.com with SMTP id g12so4844245pgs.0
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:51 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 29/83] Add write_inode and dirty_inode routines.
Date: Sat, 10 Mar 2018 10:18:10 -0800
Message-Id: <1520705944-6723-30-git-send-email-jix024@eng.ucsd.edu>
In-Reply-To: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: coughlan@redhat.com, miklos@szeredi.hu, Andiry Xu <jix024@cs.ucsd.edu>, david@fromorbit.com, jack@suse.com, swanson@cs.ucsd.edu, swhiteho@redhat.com, andiry.xu@gmail.com
List-ID: <linux-nvdimm@lists.01.org>

From: Andiry Xu <jix024@cs.ucsd.edu>

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/inode.c | 33 +++++++++++++++++++++++++++++++++
 fs/nova/inode.h |  2 ++
 fs/nova/super.c |  2 ++
 3 files changed, 37 insertions(+)

diff --git a/fs/nova/inode.c b/fs/nova/inode.c
index a30b6aa..29d172a 100644
--- a/fs/nova/inode.c
+++ b/fs/nova/inode.c
@@ -489,6 +489,39 @@ int nova_free_inuse_inode(struct super_block *sb, unsigned long ino)
 	return ret;
 }
 
+int nova_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	/* write_inode should never be called because we always keep our inodes
+	 * clean. So let us know if write_inode ever gets called.
+	 */
+//	BUG();
+	return 0;
+}
+
+/*
+ * dirty_inode() is called from mark_inode_dirty_sync()
+ * usually dirty_inode should not be called because NOVA always keeps its inodes
+ * clean. Only exception is touch_atime which calls dirty_inode to update the
+ * i_atime field.
+ */
+void nova_dirty_inode(struct inode *inode, int flags)
+{
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_inode *pi;
+
+	pi = nova_get_block(sb, sih->pi_addr);
+
+	/* only i_atime should have changed if at all.
+	 * we can do in-place atomic update
+	 */
+	pi->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
+	nova_persist_inode(pi);
+	/* Relax atime persistency */
+	nova_flush_buffer(&pi->i_atime, sizeof(pi->i_atime), 0);
+}
+
 static ssize_t nova_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	/* DAX does not support direct IO */
diff --git a/fs/nova/inode.h b/fs/nova/inode.h
index e00b3b9..f9f5c14 100644
--- a/fs/nova/inode.h
+++ b/fs/nova/inode.h
@@ -229,5 +229,7 @@ int nova_get_inode_address(struct super_block *sb, u64 ino,
 struct inode *nova_iget(struct super_block *sb, unsigned long ino);
 inline int nova_insert_inodetree(struct nova_sb_info *sbi,
 	struct nova_range_node *new_node, int cpu);
+extern int nova_write_inode(struct inode *inode, struct writeback_control *wbc);
+extern void nova_dirty_inode(struct inode *inode, int flags);
 
 #endif
diff --git a/fs/nova/super.c b/fs/nova/super.c
index 69e4afc..c0427fd 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -861,6 +861,8 @@ static void destroy_rangenode_cache(void)
 static struct super_operations nova_sops = {
 	.alloc_inode	= nova_alloc_inode,
 	.destroy_inode	= nova_destroy_inode,
+	.write_inode	= nova_write_inode,
+	.dirty_inode	= nova_dirty_inode,
 	.put_super	= nova_put_super,
 	.statfs		= nova_statfs,
 	.remount_fs	= nova_remount,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
