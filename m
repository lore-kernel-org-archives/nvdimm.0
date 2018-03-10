Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C603E22631463
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:50 -0800 (PST)
Received: by mail-pg0-x243.google.com with SMTP id m19so4837675pgn.1
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:09 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 44/83] Log operation: invalidate log entries
Date: Sat, 10 Mar 2018 10:18:25 -0800
Message-Id: <1520705944-6723-45-git-send-email-jix024@eng.ucsd.edu>
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

After new log entries are appended to the log, old log entries
can be marked invalid to faciliate garbage collection.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/log.c  | 160 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/log.h  |   4 ++
 fs/nova/nova.h |  12 +++++
 3 files changed, 176 insertions(+)

diff --git a/fs/nova/log.c b/fs/nova/log.c
index c8b7d2e..d150f2e 100644
--- a/fs/nova/log.c
+++ b/fs/nova/log.c
@@ -20,6 +20,88 @@
 #include "inode.h"
 #include "log.h"
 
+static int nova_execute_invalidate_reassign_logentry(struct super_block *sb,
+	void *entry, enum nova_entry_type type, int reassign,
+	unsigned int num_free)
+{
+	struct nova_file_write_entry *fw_entry;
+	int invalid = 0;
+
+	switch (type) {
+	case FILE_WRITE:
+		fw_entry = (struct nova_file_write_entry *)entry;
+		if (reassign)
+			fw_entry->reassigned = 1;
+		if (num_free)
+			fw_entry->invalid_pages += num_free;
+		if (fw_entry->invalid_pages == fw_entry->num_pages)
+			invalid = 1;
+		break;
+	case DIR_LOG:
+		if (reassign) {
+			((struct nova_dentry *)entry)->reassigned = 1;
+		} else {
+			((struct nova_dentry *)entry)->invalid = 1;
+			invalid = 1;
+		}
+		break;
+	case SET_ATTR:
+		((struct nova_setattr_logentry *)entry)->invalid = 1;
+		invalid = 1;
+		break;
+	case LINK_CHANGE:
+		((struct nova_link_change_entry *)entry)->invalid = 1;
+		invalid = 1;
+		break;
+	default:
+		break;
+	}
+
+	if (invalid) {
+		u64 addr = nova_get_addr_off(NOVA_SB(sb), entry);
+
+		nova_inc_page_invalid_entries(sb, addr);
+	}
+
+	nova_persist_entry(entry);
+	return 0;
+}
+
+static int nova_invalidate_reassign_logentry(struct super_block *sb,
+	void *entry, enum nova_entry_type type, int reassign,
+	unsigned int num_free)
+{
+	nova_execute_invalidate_reassign_logentry(sb, entry, type,
+						reassign, num_free);
+	return 0;
+}
+
+static int nova_invalidate_logentry(struct super_block *sb, void *entry,
+	enum nova_entry_type type, unsigned int num_free)
+{
+	return nova_invalidate_reassign_logentry(sb, entry, type, 0, num_free);
+}
+
+static int nova_reassign_logentry(struct super_block *sb, void *entry,
+	enum nova_entry_type type)
+{
+	return nova_invalidate_reassign_logentry(sb, entry, type, 1, 0);
+}
+
+static inline int nova_invalidate_write_entry(struct super_block *sb,
+	struct nova_file_write_entry *entry, int reassign,
+	unsigned int num_free)
+{
+	if (!entry)
+		return 0;
+
+	if (num_free == 0 && entry->reassigned == 1)
+		return 0;
+
+	return nova_invalidate_reassign_logentry(sb, entry, FILE_WRITE,
+							reassign, num_free);
+}
+
 static void nova_update_setattr_entry(struct inode *inode,
 	struct nova_setattr_logentry *entry,
 	struct nova_log_entry_info *entry_info)
@@ -279,6 +361,27 @@ static int nova_append_setattr_entry(struct super_block *sb,
 	return ret;
 }
 
+/* Invalidate old setattr entry */
+static int nova_invalidate_setattr_entry(struct super_block *sb,
+	u64 last_setattr)
+{
+	struct nova_setattr_logentry *old_entry;
+	void *addr;
+	int ret;
+
+	addr = (void *)nova_get_block(sb, last_setattr);
+	old_entry = (struct nova_setattr_logentry *)addr;
+
+	/* Do not invalidate setsize entries */
+	if (!old_entry_freeable(sb, old_entry->epoch_id) ||
+			(old_entry->attr & ATTR_SIZE))
+		return 0;
+
+	ret = nova_invalidate_logentry(sb, old_entry, SET_ATTR, 0);
+
+	return ret;
+}
+
 static int nova_can_inplace_update_setattr(struct super_block *sb,
 	struct nova_inode_info_header *sih, u64 epoch_id)
 {
@@ -358,9 +461,35 @@ int nova_handle_setattr_operation(struct super_block *sb, struct inode *inode,
 		nova_update_inode(sb, inode, pi, &update);
 	}
 
+	/* Invalidate old setattr entry */
+	if (last_setattr)
+		nova_invalidate_setattr_entry(sb, last_setattr);
+
 	return 0;
 }
 
+/* Invalidate old link change entry */
+int nova_invalidate_link_change_entry(struct super_block *sb,
+	u64 old_link_change)
+{
+	struct nova_link_change_entry *old_entry;
+	void *addr;
+	int ret;
+
+	if (old_link_change == 0)
+		return 0;
+
+	addr = (void *)nova_get_block(sb, old_link_change);
+	old_entry = (struct nova_link_change_entry *)addr;
+
+	if (!old_entry_freeable(sb, old_entry->epoch_id))
+		return 0;
+
+	ret = nova_invalidate_logentry(sb, old_entry, LINK_CHANGE, 0);
+
+	return ret;
+}
+
 static int nova_can_inplace_update_lcentry(struct super_block *sb,
 	struct nova_inode_info_header *sih, u64 epoch_id)
 {
@@ -481,6 +610,37 @@ int nova_append_file_write_entry(struct super_block *sb, struct nova_inode *pi,
 	return ret;
 }
 
+/* Create dentry and delete dentry must be invalidated together */
+int nova_invalidate_dentries(struct super_block *sb,
+	struct nova_inode_update *update)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_dentry *create_dentry;
+	struct nova_dentry *delete_dentry;
+	u64 create_curr, delete_curr;
+	int ret;
+
+	create_dentry = update->create_dentry;
+	delete_dentry = update->delete_dentry;
+
+	if (!create_dentry)
+		return 0;
+
+	nova_reassign_logentry(sb, create_dentry, DIR_LOG);
+
+	if (!old_entry_freeable(sb, create_dentry->epoch_id))
+		return 0;
+
+	create_curr = nova_get_addr_off(sbi, create_dentry);
+	delete_curr = nova_get_addr_off(sbi, delete_dentry);
+
+	nova_invalidate_logentry(sb, create_dentry, DIR_LOG, 0);
+
+	ret = nova_invalidate_logentry(sb, delete_dentry, DIR_LOG, 0);
+
+	return ret;
+}
+
 int nova_inplace_update_dentry(struct super_block *sb,
 	struct inode *dir, struct nova_dentry *dentry, int link_change,
 	u64 epoch_id)
diff --git a/fs/nova/log.h b/fs/nova/log.h
index 74891b3..2548083 100644
--- a/fs/nova/log.h
+++ b/fs/nova/log.h
@@ -367,6 +367,8 @@ static inline int is_dir_init_entry(struct super_block *sb,
 int nova_handle_setattr_operation(struct super_block *sb, struct inode *inode,
 	struct nova_inode *pi, unsigned int ia_valid, struct iattr *attr,
 	u64 epoch_id);
+int nova_invalidate_link_change_entry(struct super_block *sb,
+	u64 old_link_change);
 int nova_append_link_change_entry(struct super_block *sb,
 	struct nova_inode *pi, struct inode *inode,
 	struct nova_inode_update *update, u64 *old_linkc, u64 epoch_id);
@@ -376,6 +378,8 @@ int nova_inplace_update_write_entry(struct super_block *sb,
 int nova_append_file_write_entry(struct super_block *sb, struct nova_inode *pi,
 	struct inode *inode, struct nova_file_write_item *item,
 	struct nova_inode_update *update);
+int nova_invalidate_dentries(struct super_block *sb,
+	struct nova_inode_update *update);
 int nova_inplace_update_dentry(struct super_block *sb,
 	struct inode *dir, struct nova_dentry *dentry, int link_change,
 	u64 epoch_id);
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index 03c4991..6cf3c33 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -328,6 +328,18 @@ struct inode_map {
 	int			freed;
 };
 
+
+/* Old entry is freeable if it is appended after the latest snapshot */
+static inline int old_entry_freeable(struct super_block *sb, u64 epoch_id)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	if (epoch_id == sbi->s_epoch_id)
+		return 1;
+
+	return 0;
+}
+
 #include "balloc.h"
 
 static inline unsigned long
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
