Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x244.google.com (mail-pl0-x244.google.com
 [IPv6:2607:f8b0:400e:c01::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82AAF2258AF15
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:48 -0800 (PST)
Received: by mail-pl0-x244.google.com with SMTP id m22-v6so7032557pls.5
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:07 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 42/83] Log operation: link change append.
Date: Sat, 10 Mar 2018 10:18:23 -0800
Message-Id: <1520705944-6723-43-git-send-email-jix024@eng.ucsd.edu>
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

NOVA appends link change entries to atomically update link count and ctime.
This occurs in link, unlink and rmdir.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/log.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/log.h |  3 +++
 2 files changed, 55 insertions(+)

diff --git a/fs/nova/log.c b/fs/nova/log.c
index f85b63e..4638ccf 100644
--- a/fs/nova/log.c
+++ b/fs/nova/log.c
@@ -51,6 +51,25 @@ static void nova_update_setattr_entry(struct inode *inode,
 	nova_persist_entry(entry);
 }
 
+static void nova_update_link_change_entry(struct inode *inode,
+	struct nova_link_change_entry *entry,
+	struct nova_log_entry_info *entry_info)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+
+	entry->entry_type	= LINK_CHANGE;
+	entry->epoch_id		= cpu_to_le64(entry_info->epoch_id);
+	entry->trans_id		= cpu_to_le64(entry_info->trans_id);
+	entry->invalid		= 0;
+	entry->links		= cpu_to_le16(inode->i_nlink);
+	entry->ctime		= cpu_to_le32(inode->i_ctime.tv_sec);
+	entry->flags		= cpu_to_le32(sih->i_flags);
+	entry->generation	= cpu_to_le32(inode->i_generation);
+
+	nova_persist_entry(entry);
+}
+
 static int nova_update_write_entry(struct super_block *sb,
 	struct nova_file_write_entry *entry,
 	struct nova_log_entry_info *entry_info)
@@ -150,6 +169,7 @@ static int nova_update_log_entry(struct super_block *sb, struct inode *inode,
 		nova_update_setattr_entry(inode, entry, entry_info);
 		break;
 	case LINK_CHANGE:
+		nova_update_link_change_entry(inode, entry, entry_info);
 		break;
 	default:
 		break;
@@ -230,6 +250,38 @@ static int nova_append_setattr_entry(struct super_block *sb,
 	return ret;
 }
 
+/* Returns new tail after append */
+int nova_append_link_change_entry(struct super_block *sb,
+	struct nova_inode *pi, struct inode *inode,
+	struct nova_inode_update *update, u64 *old_linkc, u64 epoch_id)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_log_entry_info entry_info;
+	int ret = 0;
+	timing_t append_time;
+
+	NOVA_START_TIMING(append_link_change_t, append_time);
+
+	entry_info.type = LINK_CHANGE;
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
+	*old_linkc = sih->last_link_change;
+	sih->last_link_change = entry_info.curr_p;
+	sih->trans_id++;
+out:
+	NOVA_END_TIMING(append_link_change_t, append_time);
+	return ret;
+}
+
 /*
  * Append a nova_file_write_entry to the current nova_inode_log_page.
  * blocknr and start_blk are pgoff.
diff --git a/fs/nova/log.h b/fs/nova/log.h
index db7a72e..f36f4a3 100644
--- a/fs/nova/log.h
+++ b/fs/nova/log.h
@@ -364,6 +364,9 @@ static inline int is_dir_init_entry(struct super_block *sb,
 }
 
 
+int nova_append_link_change_entry(struct super_block *sb,
+	struct nova_inode *pi, struct inode *inode,
+	struct nova_inode_update *update, u64 *old_linkc, u64 epoch_id);
 int nova_append_file_write_entry(struct super_block *sb, struct nova_inode *pi,
 	struct inode *inode, struct nova_file_write_item *item,
 	struct nova_inode_update *update);
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
