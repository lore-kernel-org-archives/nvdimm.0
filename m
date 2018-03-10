Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x242.google.com (mail-pl0-x242.google.com
 [IPv6:2607:f8b0:400e:c01::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8A4342263148F
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:00 -0800 (PST)
Received: by mail-pl0-x242.google.com with SMTP id f23-v6so7024249plr.10
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:19 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 52/83] Rebuild: file inode.
Date: Sat, 10 Mar 2018 10:18:33 -0800
Message-Id: <1520705944-6723-53-git-send-email-jix024@eng.ucsd.edu>
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

Rebuild file inode metadata and radix tree on read_inode.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/log.h     |   4 ++
 fs/nova/rebuild.c | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 128 insertions(+)

diff --git a/fs/nova/log.h b/fs/nova/log.h
index 87ce5f9..bdb85eb 100644
--- a/fs/nova/log.h
+++ b/fs/nova/log.h
@@ -385,6 +385,10 @@ int nova_inplace_update_write_entry(struct super_block *sb,
 int nova_append_file_write_entry(struct super_block *sb, struct nova_inode *pi,
 	struct inode *inode, struct nova_file_write_item *item,
 	struct nova_inode_update *update);
+int nova_assign_write_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih,
+	struct nova_file_write_entry *entry,
+	bool free);
 int nova_invalidate_dentries(struct super_block *sb,
 	struct nova_inode_update *update);
 int nova_inplace_update_dentry(struct super_block *sb,
diff --git a/fs/nova/rebuild.c b/fs/nova/rebuild.c
index 9a1327d..07cf6e3 100644
--- a/fs/nova/rebuild.c
+++ b/fs/nova/rebuild.c
@@ -156,6 +156,126 @@ static int nova_rebuild_inode_finish(struct super_block *sb,
 	return 0;
 }
 
+static void nova_rebuild_handle_write_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_inode_rebuild *reb,
+	struct nova_file_write_entry *entry)
+{
+	if (entry->num_pages != entry->invalid_pages) {
+		/*
+		 * The overlaped blocks are already freed.
+		 * Don't double free them, just re-assign the pointers.
+		 */
+		nova_assign_write_entry(sb, sih, entry, false);
+	}
+
+	if (entry->trans_id >= sih->trans_id) {
+		nova_rebuild_file_time_and_size(sb, reb,
+					entry->mtime, entry->mtime,
+					entry->size);
+		reb->trans_id = entry->trans_id;
+	}
+
+	/* Update sih->i_size for setattr apply operations */
+	sih->i_size = le64_to_cpu(reb->i_size);
+}
+
+static int nova_rebuild_file_inode_tree(struct super_block *sb,
+	struct nova_inode *pi, u64 pi_addr,
+	struct nova_inode_info_header *sih)
+{
+	struct nova_file_write_entry *entry = NULL;
+	struct nova_setattr_logentry *attr_entry = NULL;
+	struct nova_link_change_entry *link_change_entry = NULL;
+	struct nova_inode_rebuild rebuild, *reb;
+	unsigned int data_bits = blk_type_to_shift[sih->i_blk_type];
+	u64 ino = pi->nova_ino;
+	timing_t rebuild_time;
+	void *addr, *entryc = NULL;
+	u64 curr_p;
+	u8 type;
+	int ret;
+
+	NOVA_START_TIMING(rebuild_file_t, rebuild_time);
+	nova_dbg_verbose("Rebuild file inode %llu tree\n", ino);
+
+	reb = &rebuild;
+	ret = nova_rebuild_inode_start(sb, pi, sih, reb, pi_addr);
+	if (ret)
+		goto out;
+
+	curr_p = sih->log_head;
+	if (curr_p == 0 && sih->log_tail == 0)
+		goto out;
+
+//	nova_print_nova_log(sb, sih);
+
+	while (curr_p != sih->log_tail) {
+		if (goto_next_page(sb, curr_p)) {
+			sih->log_pages++;
+			curr_p = next_log_page(sb, curr_p);
+		}
+
+		if (curr_p == 0) {
+			nova_err(sb, "File inode %llu log is NULL!\n", ino);
+			ret = -EIO;
+			goto out;
+		}
+
+		addr = (void *)nova_get_block(sb, curr_p);
+
+		entryc = addr;
+
+		type = nova_get_entry_type(entryc);
+
+		switch (type) {
+		case SET_ATTR:
+			attr_entry = (struct nova_setattr_logentry *)entryc;
+			nova_apply_setattr_entry(sb, reb, sih, attr_entry);
+			sih->last_setattr = curr_p;
+			if (attr_entry->trans_id >= reb->trans_id) {
+				nova_rebuild_file_time_and_size(sb, reb,
+							attr_entry->mtime,
+							attr_entry->ctime,
+							attr_entry->size);
+				reb->trans_id = attr_entry->trans_id;
+			}
+
+			/* Update sih->i_size for setattr operation */
+			sih->i_size = le64_to_cpu(reb->i_size);
+			curr_p += sizeof(struct nova_setattr_logentry);
+			break;
+		case LINK_CHANGE:
+			link_change_entry =
+				(struct nova_link_change_entry *)entryc;
+			nova_apply_link_change_entry(sb, reb,
+						link_change_entry);
+			sih->last_link_change = curr_p;
+			curr_p += sizeof(struct nova_link_change_entry);
+			break;
+		case FILE_WRITE:
+			entry = (struct nova_file_write_entry *)addr;
+			nova_rebuild_handle_write_entry(sb, sih, reb,
+						entryc);
+			curr_p += sizeof(struct nova_file_write_entry);
+			break;
+		default:
+			nova_err(sb, "unknown type %d, 0x%llx\n", type, curr_p);
+			NOVA_ASSERT(0);
+			curr_p += sizeof(struct nova_file_write_entry);
+			break;
+		}
+
+	}
+
+	ret = nova_rebuild_inode_finish(sb, pi, sih, reb, curr_p);
+	sih->i_blocks = sih->log_pages + (sih->i_size >> data_bits);
+
+out:
+//	nova_print_inode_log_page(sb, inode);
+	NOVA_END_TIMING(rebuild_file_t, rebuild_time);
+	return ret;
+}
+
 /******************* Directory rebuild *********************/
 
 static inline void nova_rebuild_dir_time_and_size(struct super_block *sb,
@@ -360,12 +480,16 @@ int nova_rebuild_inode(struct super_block *sb, struct nova_inode_info *si,
 		/* Treat symlink files as normal files */
 		/* Fall through */
 	case S_IFREG:
+		nova_rebuild_file_inode_tree(sb, pi, pi_addr, sih);
 		break;
 	case S_IFDIR:
 		if (rebuild_dir)
 			nova_rebuild_dir_inode_tree(sb, pi, pi_addr, sih);
 		break;
 	default:
+		/* In case of special inode, walk the log */
+		if (pi->log_head)
+			nova_rebuild_file_inode_tree(sb, pi, pi_addr, sih);
 		sih->pi_addr = pi_addr;
 		break;
 	}
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
