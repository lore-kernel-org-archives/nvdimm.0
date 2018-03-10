Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x243.google.com (mail-pl0-x243.google.com
 [IPv6:2607:f8b0:400e:c01::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5C96522603B11
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:47 -0800 (PST)
Received: by mail-pl0-x243.google.com with SMTP id m22-v6so7032535pls.5
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:06 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 41/83] Log operation: setattr entry append
Date: Sat, 10 Mar 2018 10:18:22 -0800
Message-Id: <1520705944-6723-42-git-send-email-jix024@eng.ucsd.edu>
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

NOVA appends a setattr entry to the log upon inode modification operations:
set size, chmod, etc.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/log.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/fs/nova/log.c b/fs/nova/log.c
index 437db26..f85b63e 100644
--- a/fs/nova/log.c
+++ b/fs/nova/log.c
@@ -20,6 +20,37 @@
 #include "inode.h"
 #include "log.h"
 
+static void nova_update_setattr_entry(struct inode *inode,
+	struct nova_setattr_logentry *entry,
+	struct nova_log_entry_info *entry_info)
+{
+	struct iattr *attr = entry_info->attr;
+	unsigned int ia_valid = attr->ia_valid, attr_mask;
+
+	/* These files are in the lowest byte */
+	attr_mask = ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_SIZE |
+			ATTR_ATIME | ATTR_MTIME | ATTR_CTIME;
+
+	entry->entry_type	= SET_ATTR;
+	entry->attr	= ia_valid & attr_mask;
+	entry->mode	= cpu_to_le16(inode->i_mode);
+	entry->uid	= cpu_to_le32(i_uid_read(inode));
+	entry->gid	= cpu_to_le32(i_gid_read(inode));
+	entry->atime	= cpu_to_le32(inode->i_atime.tv_sec);
+	entry->ctime	= cpu_to_le32(inode->i_ctime.tv_sec);
+	entry->mtime	= cpu_to_le32(inode->i_mtime.tv_sec);
+	entry->epoch_id = cpu_to_le64(entry_info->epoch_id);
+	entry->trans_id	= cpu_to_le64(entry_info->trans_id);
+	entry->invalid	= 0;
+
+	if (ia_valid & ATTR_SIZE)
+		entry->size = cpu_to_le64(attr->ia_size);
+	else
+		entry->size = cpu_to_le64(inode->i_size);
+
+	nova_persist_entry(entry);
+}
+
 static int nova_update_write_entry(struct super_block *sb,
 	struct nova_file_write_entry *entry,
 	struct nova_log_entry_info *entry_info)
@@ -116,6 +147,7 @@ static int nova_update_log_entry(struct super_block *sb, struct inode *inode,
 			nova_update_new_dentry(sb, inode, entry, entry_info);
 		break;
 	case SET_ATTR:
+		nova_update_setattr_entry(inode, entry, entry_info);
 		break;
 	case LINK_CHANGE:
 		break;
@@ -166,6 +198,38 @@ static int nova_append_log_entry(struct super_block *sb,
 	return 0;
 }
 
+/* Returns new tail after append */
+static int nova_append_setattr_entry(struct super_block *sb,
+	struct nova_inode *pi, struct inode *inode, struct iattr *attr,
+	struct nova_inode_update *update, u64 *last_setattr, u64 epoch_id)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_log_entry_info entry_info;
+	timing_t append_time;
+	int ret;
+
+	NOVA_START_TIMING(append_setattr_t, append_time);
+	entry_info.type = SET_ATTR;
+	entry_info.attr = attr;
+	entry_info.update = update;
+	entry_info.epoch_id = epoch_id;
+	entry_info.trans_id = sih->trans_id;
+
+	ret = nova_append_log_entry(sb, pi, inode, sih, &entry_info);
+	if (ret) {
+		nova_err(sb, "%s failed\n", __func__);
+		goto out;
+	}
+
+	*last_setattr = sih->last_setattr;
+	sih->last_setattr = entry_info.curr_p;
+
+out:
+	NOVA_END_TIMING(append_setattr_t, append_time);
+	return ret;
+}
+
 /*
  * Append a nova_file_write_entry to the current nova_inode_log_page.
  * blocknr and start_blk are pgoff.
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
