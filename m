Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x242.google.com (mail-pl0-x242.google.com
 [IPv6:2607:f8b0:400e:c01::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F67922603AE2
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:46 -0800 (PST)
Received: by mail-pl0-x242.google.com with SMTP id 61-v6so7023789plf.3
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:05 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 40/83] Log operation: file write entry append.
Date: Sat, 10 Mar 2018 10:18:21 -0800
Message-Id: <1520705944-6723-41-git-send-email-jix024@eng.ucsd.edu>
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

NOVA performs writes by appending file write entries to the log.
A file write entry is the metadata of a write operation, and
contains pointers to the data blocks. A single write operation
may append multiple file write entries to the log, if the
allocator cannot provide enough contiguous data blocks.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/log.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/log.h |  3 +++
 2 files changed, 54 insertions(+)

diff --git a/fs/nova/log.c b/fs/nova/log.c
index 13f9597..437db26 100644
--- a/fs/nova/log.c
+++ b/fs/nova/log.c
@@ -20,6 +20,18 @@
 #include "inode.h"
 #include "log.h"
 
+static int nova_update_write_entry(struct super_block *sb,
+	struct nova_file_write_entry *entry,
+	struct nova_log_entry_info *entry_info)
+{
+	entry->epoch_id = cpu_to_le64(entry_info->epoch_id);
+	entry->trans_id = cpu_to_le64(entry_info->trans_id);
+	entry->mtime = cpu_to_le32(entry_info->time);
+	entry->size = cpu_to_le64(entry_info->file_size);
+	nova_persist_entry(entry);
+	return 0;
+}
+
 static int nova_update_old_dentry(struct super_block *sb,
 	struct inode *dir, struct nova_dentry *dentry,
 	struct nova_log_entry_info *entry_info)
@@ -91,6 +103,11 @@ static int nova_update_log_entry(struct super_block *sb, struct inode *inode,
 
 	switch (type) {
 	case FILE_WRITE:
+		if (entry_info->inplace)
+			nova_update_write_entry(sb, entry, entry_info);
+		else
+			memcpy_to_pmem_nocache(entry, entry_info->data,
+				sizeof(struct nova_file_write_entry));
 		break;
 	case DIR_LOG:
 		if (entry_info->inplace)
@@ -149,6 +166,40 @@ static int nova_append_log_entry(struct super_block *sb,
 	return 0;
 }
 
+/*
+ * Append a nova_file_write_entry to the current nova_inode_log_page.
+ * blocknr and start_blk are pgoff.
+ * We cannot update pi->log_tail here because a transaction may contain
+ * multiple entries.
+ */
+int nova_append_file_write_entry(struct super_block *sb, struct nova_inode *pi,
+	struct inode *inode, struct nova_file_write_item *item,
+	struct nova_inode_update *update)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_file_write_entry *data = &item->entry;
+	struct nova_log_entry_info entry_info;
+	timing_t append_time;
+	int ret;
+
+	NOVA_START_TIMING(append_file_entry_t, append_time);
+
+	entry_info.type = FILE_WRITE;
+	entry_info.update = update;
+	entry_info.data = data;
+	entry_info.epoch_id = data->epoch_id;
+	entry_info.trans_id = data->trans_id;
+	entry_info.inplace = 0;
+
+	ret = nova_append_log_entry(sb, pi, inode, sih, &entry_info);
+	if (ret)
+		nova_err(sb, "%s failed\n", __func__);
+
+	NOVA_END_TIMING(append_file_entry_t, append_time);
+	return ret;
+}
+
 int nova_append_dentry(struct super_block *sb, struct nova_inode *pi,
 	struct inode *dir, struct dentry *dentry, u64 ino,
 	unsigned short de_len, struct nova_inode_update *update,
diff --git a/fs/nova/log.h b/fs/nova/log.h
index 305e69b..db7a72e 100644
--- a/fs/nova/log.h
+++ b/fs/nova/log.h
@@ -364,6 +364,9 @@ static inline int is_dir_init_entry(struct super_block *sb,
 }
 
 
+int nova_append_file_write_entry(struct super_block *sb, struct nova_inode *pi,
+	struct inode *inode, struct nova_file_write_item *item,
+	struct nova_inode_update *update);
 int nova_append_dentry(struct super_block *sb, struct nova_inode *pi,
 	struct inode *dir, struct dentry *dentry, u64 ino,
 	unsigned short de_len, struct nova_inode_update *update,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
