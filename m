Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C8C9521E1DAD9
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 00:46:49 -0700 (PDT)
Received: by mail-pf0-x242.google.com with SMTP id j68so790684pfc.2
 for <linux-nvdimm@lists.01.org>; Thu, 03 Aug 2017 00:49:01 -0700 (PDT)
From: Steven Swanson <swanson@eng.ucsd.edu>
Subject: [RFC 07/16] NOVA: File and directory operations
Date: Thu, 03 Aug 2017 00:48:58 -0700
Message-ID: <150174653826.104003.17977611280376142324.stgit@hn>
In-Reply-To: <150174646416.104003.14042713459553361884.stgit@hn>
References: <150174646416.104003.14042713459553361884.stgit@hn>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Steven Swanson <steven.swanson@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

To access file data via read(), Nova maintains a radix tree in DRAM for each
inode (nova_inode_info_header.tree) that maps file offsets to write log
entries.  For directories, the same tree maps a hash of filenames to their
corresponding dentry.

In both cases, the nova populates the tree when the file or directory is opened
by scanning its log.

Signed-off-by: Steven Swanson <swanson@cs.ucsd.edu>
---
 fs/nova/dir.c     |  760 +++++++++++++++++++++++++++++++++++++++++++
 fs/nova/file.c    |  943 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/namei.c   |  919 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/symlink.c |  153 +++++++++
 4 files changed, 2775 insertions(+)
 create mode 100644 fs/nova/dir.c
 create mode 100644 fs/nova/file.c
 create mode 100644 fs/nova/namei.c
 create mode 100644 fs/nova/symlink.c

diff --git a/fs/nova/dir.c b/fs/nova/dir.c
new file mode 100644
index 000000000000..47e89088a69b
--- /dev/null
+++ b/fs/nova/dir.c
@@ -0,0 +1,760 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * File operations for directories.
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ * Copyright 2012-2013 Intel Corporation
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+#include "nova.h"
+#include "inode.h"
+
+#define DT2IF(dt) (((dt) << 12) & S_IFMT)
+#define IF2DT(sif) (((sif) & S_IFMT) >> 12)
+
+struct nova_dentry *nova_find_dentry(struct super_block *sb,
+	struct nova_inode *pi, struct inode *inode, const char *name,
+	unsigned long name_len)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_dentry *direntry;
+	unsigned long hash;
+
+	hash = BKDRHash(name, name_len);
+	direntry = radix_tree_lookup(&sih->tree, hash);
+
+	return direntry;
+}
+
+int nova_insert_dir_radix_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih, const char *name,
+	int namelen, struct nova_dentry *direntry)
+{
+	unsigned long hash;
+	int ret;
+
+	hash = BKDRHash(name, namelen);
+	nova_dbgv("%s: insert %s hash %lu\n", __func__, name, hash);
+
+	/* FIXME: hash collision ignored here */
+	ret = radix_tree_insert(&sih->tree, hash, direntry);
+	if (ret)
+		nova_dbg("%s ERROR %d: %s\n", __func__, ret, name);
+
+	return ret;
+}
+
+static int nova_check_dentry_match(struct super_block *sb,
+	struct nova_dentry *dentry, const char *name, int namelen)
+{
+	if (dentry->name_len != namelen)
+		return -EINVAL;
+
+	return strncmp(dentry->name, name, namelen);
+}
+
+int nova_remove_dir_radix_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih, const char *name, int namelen,
+	int replay, struct nova_dentry **create_dentry)
+{
+	struct nova_dentry *entry;
+	struct nova_dentry *entryc, entry_copy;
+	unsigned long hash;
+
+	hash = BKDRHash(name, namelen);
+	entry = radix_tree_delete(&sih->tree, hash);
+
+	if (replay == 0) {
+		if (!entry) {
+			nova_dbg("%s ERROR: %s, length %d, hash %lu\n",
+					__func__, name, namelen, hash);
+			return -EINVAL;
+		}
+
+		if (metadata_csum == 0)
+			entryc = entry;
+		else {
+			entryc = &entry_copy;
+			if (!nova_verify_entry_csum(sb, entry, entryc))
+				return -EINVAL;
+		}
+
+		if (entryc->ino == 0 || entryc->invalid ||
+		    nova_check_dentry_match(sb, entryc, name, namelen)) {
+			nova_dbg("%s dentry not match: %s, length %d, hash %lu\n",
+				 __func__, name, namelen, hash);
+			/* for debug information, still allow access to nvmm */
+			nova_dbg("dentry: type %d, inode %llu, name %s, namelen %u, rec len %u\n",
+				 entry->entry_type, le64_to_cpu(entry->ino),
+				 entry->name, entry->name_len,
+				 le16_to_cpu(entry->de_len));
+			return -EINVAL;
+		}
+
+		if (create_dentry)
+			*create_dentry = entry;
+	}
+
+	return 0;
+}
+
+void nova_delete_dir_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih)
+{
+	struct nova_dentry *direntry;
+	struct nova_dentry *direntryc, entry_copy;
+	unsigned long pos = 0;
+	struct nova_dentry *entries[FREE_BATCH];
+	timing_t delete_time;
+	int nr_entries;
+	int i;
+	void *ret;
+
+	NOVA_START_TIMING(delete_dir_tree_t, delete_time);
+
+	direntryc = (metadata_csum == 0) ? direntry : &entry_copy;
+	do {
+		nr_entries = radix_tree_gang_lookup(&sih->tree,
+					(void **)entries, pos, FREE_BATCH);
+		for (i = 0; i < nr_entries; i++) {
+			direntry = entries[i];
+			BUG_ON(!direntry);
+
+			if (metadata_csum == 0)
+				direntryc = direntry;
+			else if (!nova_verify_entry_csum(sb, direntry,
+								direntryc))
+				return;
+
+			pos = BKDRHash(direntryc->name, direntryc->name_len);
+			ret = radix_tree_delete(&sih->tree, pos);
+			if (!ret || ret != direntry) {
+				nova_err(sb, "dentry: type %d, inode %llu, name %s, namelen %u, rec len %u\n",
+					direntry->entry_type,
+					le64_to_cpu(direntry->ino),
+					direntry->name, direntry->name_len,
+					le16_to_cpu(direntry->de_len));
+				if (!ret)
+					nova_dbg("ret is NULL\n");
+			}
+		}
+		pos++;
+	} while (nr_entries == FREE_BATCH);
+
+	NOVA_END_TIMING(delete_dir_tree_t, delete_time);
+}
+
+/* ========================= Entry operations ============================= */
+
+static unsigned int nova_init_dentry(struct super_block *sb,
+	struct nova_dentry *de_entry, u64 self_ino, u64 parent_ino,
+	u64 epoch_id)
+{
+	void *start = de_entry;
+	struct nova_inode_log_page *curr_page = start;
+	unsigned int length;
+	unsigned short de_len;
+
+	de_len = NOVA_DIR_LOG_REC_LEN(1);
+	memset(de_entry, 0, de_len);
+	de_entry->entry_type = DIR_LOG;
+	de_entry->epoch_id = epoch_id;
+	de_entry->trans_id = 0;
+	de_entry->ino = cpu_to_le64(self_ino);
+	de_entry->name_len = 1;
+	de_entry->de_len = cpu_to_le16(de_len);
+	de_entry->mtime = timespec_trunc(current_kernel_time(),
+					 sb->s_time_gran).tv_sec;
+
+	de_entry->links_count = 1;
+	strncpy(de_entry->name, ".\0", 2);
+	nova_update_entry_csum(de_entry);
+
+	length = de_len;
+
+	de_entry = (struct nova_dentry *)((char *)de_entry + length);
+	de_len = NOVA_DIR_LOG_REC_LEN(2);
+	memset(de_entry, 0, de_len);
+	de_entry->entry_type = DIR_LOG;
+	de_entry->epoch_id = epoch_id;
+	de_entry->trans_id = 0;
+	de_entry->ino = cpu_to_le64(parent_ino);
+	de_entry->name_len = 2;
+	de_entry->de_len = cpu_to_le16(de_len);
+	de_entry->mtime = timespec_trunc(current_kernel_time(),
+					 sb->s_time_gran).tv_sec;
+
+	de_entry->links_count = 2;
+	strncpy(de_entry->name, "..\0", 3);
+	nova_update_entry_csum(de_entry);
+	length += de_len;
+
+	nova_set_page_num_entries(sb, curr_page, 2, 1);
+
+	nova_flush_buffer(start, length, 0);
+	return length;
+}
+
+/* Append . and .. entries
+ *
+ * TODO: why is epoch_id a parameter when we pass in the sb?
+ */
+int nova_append_dir_init_entries(struct super_block *sb,
+	struct nova_inode *pi, u64 self_ino, u64 parent_ino, u64 epoch_id)
+{
+	struct nova_inode_info_header sih;
+	struct nova_inode *alter_pi;
+	u64 alter_pi_addr = 0;
+	int allocated;
+	int ret;
+	u64 new_block;
+	unsigned int length;
+	struct nova_dentry *de_entry;
+
+	sih.ino = self_ino;
+	sih.i_blk_type = NOVA_DEFAULT_BLOCK_TYPE;
+
+	allocated = nova_allocate_inode_log_pages(sb, &sih, 1, &new_block,
+							ANY_CPU, 0);
+	if (allocated != 1) {
+		nova_err(sb, "ERROR: no inode log page available\n");
+		return -ENOMEM;
+	}
+
+	nova_memunlock_inode(sb, pi);
+
+	pi->log_tail = pi->log_head = new_block;
+
+	de_entry = (struct nova_dentry *)nova_get_block(sb, new_block);
+
+	length = nova_init_dentry(sb, de_entry, self_ino, parent_ino, epoch_id);
+
+	nova_update_tail(pi, new_block + length);
+
+	nova_memlock_inode(sb, pi);
+
+	if (metadata_csum == 0)
+		return 0;
+
+	allocated = nova_allocate_inode_log_pages(sb, &sih, 1, &new_block,
+							ANY_CPU, 1);
+	if (allocated != 1) {
+		nova_err(sb, "ERROR: no inode log page available\n");
+		return -ENOMEM;
+	}
+	nova_memunlock_inode(sb, pi);
+	pi->alter_log_tail = pi->alter_log_head = new_block;
+
+	de_entry = (struct nova_dentry *)nova_get_block(sb, new_block);
+
+	length = nova_init_dentry(sb, de_entry, self_ino, parent_ino, epoch_id);
+
+	nova_update_alter_tail(pi, new_block + length);
+	nova_update_alter_pages(sb, pi, pi->log_head,
+						pi->alter_log_head);
+	nova_update_inode_checksum(pi);
+	nova_flush_buffer(pi, sizeof(struct nova_inode), 0);
+	nova_memlock_inode(sb, pi);
+
+	/* Get alternate inode address */
+	ret = nova_get_alter_inode_address(sb, self_ino, &alter_pi_addr);
+	if (ret)
+		return ret;
+
+	alter_pi = (struct nova_inode *)nova_get_block(sb, alter_pi_addr);
+	if (!alter_pi)
+		return -EINVAL;
+
+	nova_memunlock_inode(sb, alter_pi);
+	memcpy_to_pmem_nocache(alter_pi, pi, sizeof(struct nova_inode));
+	nova_memlock_inode(sb, alter_pi);
+
+	return 0;
+}
+
+/* adds a directory entry pointing to the inode. assumes the inode has
+ * already been logged for consistency
+ */
+int nova_add_dentry(struct dentry *dentry, u64 ino, int inc_link,
+	struct nova_inode_update *update, u64 epoch_id)
+{
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct super_block *sb = dir->i_sb;
+	struct nova_inode_info *si = NOVA_I(dir);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_inode *pidir;
+	const char *name = dentry->d_name.name;
+	int namelen = dentry->d_name.len;
+	struct nova_dentry *direntry;
+	unsigned short loglen;
+	int ret;
+	u64 curr_entry;
+	timing_t add_dentry_time;
+
+	nova_dbg_verbose("%s: dir %lu new inode %llu\n",
+				__func__, dir->i_ino, ino);
+	nova_dbg_verbose("%s: %s %d\n", __func__, name, namelen);
+	NOVA_START_TIMING(add_dentry_t, add_dentry_time);
+	if (namelen == 0)
+		return -EINVAL;
+
+	pidir = nova_get_inode(sb, dir);
+
+	/*
+	 * XXX shouldn't update any times until successful
+	 * completion of syscall, but too many callers depend
+	 * on this.
+	 */
+	dir->i_mtime = dir->i_ctime = current_time(dir);
+
+	loglen = NOVA_DIR_LOG_REC_LEN(namelen);
+	ret = nova_append_dentry(sb, pidir, dir, dentry,
+				ino, loglen, update,
+				inc_link, epoch_id);
+
+	if (ret) {
+		nova_dbg("%s: append dir entry failure\n", __func__);
+		return ret;
+	}
+
+	curr_entry = update->curr_entry;
+	direntry = (struct nova_dentry *)nova_get_block(sb, curr_entry);
+	sih->last_dentry = curr_entry;
+	ret = nova_insert_dir_radix_tree(sb, sih, name, namelen, direntry);
+
+	sih->trans_id++;
+	NOVA_END_TIMING(add_dentry_t, add_dentry_time);
+	return ret;
+}
+
+static int nova_can_inplace_update_dentry(struct super_block *sb,
+	struct nova_dentry *dentry, u64 epoch_id)
+{
+	struct nova_dentry *dentryc, entry_copy;
+
+	if (metadata_csum == 0)
+		dentryc = dentry;
+	else {
+		dentryc = &entry_copy;
+		if (!nova_verify_entry_csum(sb, dentry, dentryc))
+			return 0;
+	}
+
+	if (dentry && dentryc->epoch_id == epoch_id)
+		return 1;
+
+	return 0;
+}
+
+static int nova_inplace_update_dentry(struct super_block *sb,
+	struct inode *dir, struct nova_dentry *dentry, int link_change,
+	u64 epoch_id)
+{
+	struct nova_inode_info *si = NOVA_I(dir);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_log_entry_info entry_info;
+
+	entry_info.type = DIR_LOG;
+	entry_info.link_change = link_change;
+	entry_info.epoch_id = epoch_id;
+	entry_info.trans_id = sih->trans_id;
+	entry_info.inplace = 1;
+
+	return nova_inplace_update_log_entry(sb, dir, dentry,
+					&entry_info);
+}
+
+/* removes a directory entry pointing to the inode. assumes the inode has
+ * already been logged for consistency
+ */
+int nova_remove_dentry(struct dentry *dentry, int dec_link,
+	struct nova_inode_update *update, u64 epoch_id)
+{
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct super_block *sb = dir->i_sb;
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode_info *si = NOVA_I(dir);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_inode *pidir;
+	struct qstr *entry = &dentry->d_name;
+	struct nova_dentry *old_dentry = NULL;
+	unsigned short loglen;
+	int ret;
+	u64 curr_entry;
+	timing_t remove_dentry_time;
+
+	NOVA_START_TIMING(remove_dentry_t, remove_dentry_time);
+
+	update->create_dentry = NULL;
+	update->delete_dentry = NULL;
+
+	if (!dentry->d_name.len) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = nova_remove_dir_radix_tree(sb, sih, entry->name, entry->len, 0,
+					&old_dentry);
+
+	if (ret)
+		goto out;
+
+	pidir = nova_get_inode(sb, dir);
+
+	dir->i_mtime = dir->i_ctime = current_time(dir);
+
+	if (nova_can_inplace_update_dentry(sb, old_dentry, epoch_id)) {
+		nova_inplace_update_dentry(sb, dir, old_dentry,
+						dec_link, epoch_id);
+		curr_entry = nova_get_addr_off(sbi, old_dentry);
+
+		sih->last_dentry = curr_entry;
+		/* Leave create/delete_dentry to NULL
+		 * Do not change tail/alter_tail if used as input
+		 */
+		if (update->tail == 0) {
+			update->tail = sih->log_tail;
+			update->alter_tail = sih->alter_log_tail;
+		}
+		sih->trans_id++;
+		goto out;
+	}
+
+	loglen = NOVA_DIR_LOG_REC_LEN(entry->len);
+	ret = nova_append_dentry(sb, pidir, dir, dentry,
+				0, loglen, update,
+				dec_link, epoch_id);
+
+	if (ret) {
+		nova_dbg("%s: append dir entry failure\n", __func__);
+		goto out;
+	}
+
+	update->create_dentry = old_dentry;
+	curr_entry = update->curr_entry;
+	update->delete_dentry = (struct nova_dentry *)nova_get_block(sb,
+						curr_entry);
+	sih->last_dentry = curr_entry;
+	sih->trans_id++;
+out:
+	NOVA_END_TIMING(remove_dentry_t, remove_dentry_time);
+	return ret;
+}
+
+/* Create dentry and delete dentry must be invalidated together */
+int nova_invalidate_dentries(struct super_block *sb,
+	struct nova_inode_update *update)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_dentry *create_dentry;
+	struct nova_dentry *create_dentryc, entry_copy;
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
+	if (metadata_csum == 0)
+		create_dentryc = create_dentry;
+	else {
+		create_dentryc = &entry_copy;
+		if (!nova_verify_entry_csum(sb, create_dentry, create_dentryc))
+			return 0;
+	}
+
+	if (!old_entry_freeable(sb, create_dentryc->epoch_id))
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
+static int nova_readdir_slow(struct file *file, struct dir_context *ctx)
+{
+	struct inode *inode = file_inode(file);
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode *pidir;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_inode *child_pi;
+	struct nova_dentry *entry;
+	struct nova_dentry *entryc, entry_copy;
+	struct nova_dentry *entries[FREE_BATCH];
+	int nr_entries;
+	u64 pi_addr;
+	unsigned long pos = 0;
+	ino_t ino;
+	int i;
+	int ret;
+	timing_t readdir_time;
+
+	NOVA_START_TIMING(readdir_t, readdir_time);
+	pidir = nova_get_inode(sb, inode);
+	nova_dbgv("%s: ino %llu, size %llu, pos %llu\n",
+			__func__, (u64)inode->i_ino,
+			pidir->i_size, ctx->pos);
+
+	if (!sih) {
+		nova_dbg("%s: inode %lu sih does not exist!\n",
+				__func__, inode->i_ino);
+		ctx->pos = READDIR_END;
+		return 0;
+	}
+
+	pos = ctx->pos;
+	if (pos == READDIR_END)
+		goto out;
+
+	entryc = (metadata_csum == 0) ? entry : &entry_copy;
+
+	do {
+		nr_entries = radix_tree_gang_lookup(&sih->tree,
+					(void **)entries, pos, FREE_BATCH);
+		for (i = 0; i < nr_entries; i++) {
+			entry = entries[i];
+
+			if (metadata_csum == 0)
+				entryc = entry;
+			else if (!nova_verify_entry_csum(sb, entry, entryc))
+				return -EIO;
+
+			pos = BKDRHash(entryc->name, entryc->name_len);
+			ino = __le64_to_cpu(entryc->ino);
+			if (ino == 0)
+				continue;
+
+			ret = nova_get_inode_address(sb, ino, 0, &pi_addr,
+						     0, 0);
+
+			if (ret) {
+				nova_dbg("%s: get child inode %lu address failed %d\n",
+					 __func__, ino, ret);
+				ctx->pos = READDIR_END;
+				return ret;
+			}
+
+			child_pi = nova_get_block(sb, pi_addr);
+			nova_dbgv("ctx: ino %llu, name %s, name_len %u, de_len %u, csum 0x%x\n",
+				(u64)ino, entry->name, entry->name_len,
+				entry->de_len, entry->csum);
+			if (!dir_emit(ctx, entryc->name, entryc->name_len,
+				ino, IF2DT(le16_to_cpu(child_pi->i_mode)))) {
+				nova_dbgv("Here: pos %llu\n", ctx->pos);
+				return 0;
+			}
+			ctx->pos = pos + 1;
+		}
+		pos++;
+	} while (nr_entries == FREE_BATCH);
+
+out:
+	NOVA_END_TIMING(readdir_t, readdir_time);
+	return 0;
+}
+
+static u64 nova_find_next_dentry_addr(struct super_block *sb,
+	struct nova_inode_info_header *sih, u64 pos)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_file_write_entry *entry = NULL;
+	struct nova_file_write_entry *entries[1];
+	int nr_entries;
+	u64 addr = 0;
+
+	nr_entries = radix_tree_gang_lookup(&sih->tree,
+					(void **)entries, pos, 1);
+	if (nr_entries == 1) {
+		entry = entries[0];
+		addr = nova_get_addr_off(sbi, entry);
+	}
+
+	return addr;
+}
+
+static int nova_readdir_fast(struct file *file, struct dir_context *ctx)
+{
+	struct inode *inode = file_inode(file);
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode *pidir;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_inode *child_pi;
+	struct nova_inode *prev_child_pi = NULL;
+	struct nova_dentry *entry = NULL;
+	struct nova_dentry *entryc, entry_copy;
+	struct nova_dentry *prev_entry = NULL;
+	struct nova_dentry *prev_entryc, prev_entry_copy;
+	unsigned short de_len;
+	u64 pi_addr;
+	unsigned long pos = 0;
+	ino_t ino;
+	void *addr;
+	u64 curr_p;
+	u8 type;
+	int ret;
+	timing_t readdir_time;
+
+	NOVA_START_TIMING(readdir_t, readdir_time);
+	pidir = nova_get_inode(sb, inode);
+	nova_dbgv("%s: ino %llu, size %llu, pos 0x%llx\n",
+			__func__, (u64)inode->i_ino,
+			pidir->i_size, ctx->pos);
+
+	if (sih->log_head == 0) {
+		nova_err(sb, "Dir %lu log is NULL!\n", inode->i_ino);
+		BUG();
+		return -EINVAL;
+	}
+
+	pos = ctx->pos;
+
+	if (pos == 0)
+		curr_p = sih->log_head;
+	else if (pos == READDIR_END)
+		goto out;
+	else {
+		curr_p = nova_find_next_dentry_addr(sb, sih, pos);
+		if (curr_p == 0)
+			goto out;
+	}
+
+	entryc = (metadata_csum == 0) ? entry : &entry_copy;
+	prev_entryc = (metadata_csum == 0) ? prev_entry : &prev_entry_copy;
+
+	while (curr_p != sih->log_tail) {
+		if (goto_next_page(sb, curr_p))
+			curr_p = next_log_page(sb, curr_p);
+
+
+		if (curr_p == 0) {
+			nova_err(sb, "Dir %lu log is NULL!\n", inode->i_ino);
+			BUG();
+			return -EINVAL;
+		}
+
+		addr = (void *)nova_get_block(sb, curr_p);
+		type = nova_get_entry_type(addr);
+		switch (type) {
+		case SET_ATTR:
+			curr_p += sizeof(struct nova_setattr_logentry);
+			continue;
+		case LINK_CHANGE:
+			curr_p += sizeof(struct nova_link_change_entry);
+			continue;
+		case DIR_LOG:
+			break;
+		default:
+			nova_dbg("%s: unknown type %d, 0x%llx\n",
+				 __func__, type, curr_p);
+			BUG();
+			return -EINVAL;
+		}
+
+		entry = (struct nova_dentry *)nova_get_block(sb, curr_p);
+		nova_dbgv("curr_p: 0x%llx, type %d, ino %llu, name %s, namelen %u, rec len %u\n",
+			  curr_p, entry->entry_type, le64_to_cpu(entry->ino),
+			  entry->name, entry->name_len,
+			  le16_to_cpu(entry->de_len));
+
+		if (metadata_csum == 0)
+			entryc = entry;
+		else if (!nova_verify_entry_csum(sb, entry, entryc))
+			return -EIO;
+
+		de_len = le16_to_cpu(entryc->de_len);
+		if (entryc->ino > 0 && entryc->invalid == 0
+					&& entryc->reassigned == 0) {
+			ino = __le64_to_cpu(entryc->ino);
+			pos = BKDRHash(entryc->name, entryc->name_len);
+
+			ret = nova_get_inode_address(sb, ino, 0,
+						     &pi_addr, 0, 0);
+			if (ret) {
+				nova_dbg("%s: get child inode %lu address failed %d\n",
+					 __func__, ino, ret);
+				ctx->pos = READDIR_END;
+				return ret;
+			}
+
+			child_pi = nova_get_block(sb, pi_addr);
+			nova_dbgv("ctx: ino %llu, name %s, name_len %u, de_len %u\n",
+				(u64)ino, entry->name, entry->name_len,
+				entry->de_len);
+			if (prev_entry && !dir_emit(ctx, prev_entryc->name,
+				prev_entryc->name_len, ino,
+				IF2DT(le16_to_cpu(prev_child_pi->i_mode)))) {
+				nova_dbgv("Here: pos %llu\n", ctx->pos);
+				return 0;
+			}
+			prev_entry = entry;
+
+			if (metadata_csum == 0)
+				prev_entryc = prev_entry;
+			else
+				memcpy(prev_entryc, entryc,
+						sizeof(struct nova_dentry));
+
+			prev_child_pi = child_pi;
+		}
+		ctx->pos = pos;
+		curr_p += de_len;
+	}
+
+	if (prev_entry && !dir_emit(ctx, prev_entryc->name,
+			prev_entryc->name_len, ino,
+			IF2DT(le16_to_cpu(prev_child_pi->i_mode))))
+		return 0;
+
+	ctx->pos = READDIR_END;
+out:
+	NOVA_END_TIMING(readdir_t, readdir_time);
+	nova_dbgv("%s return\n", __func__);
+	return 0;
+}
+
+static int nova_readdir(struct file *file, struct dir_context *ctx)
+{
+	struct inode *inode = file_inode(file);
+	struct super_block *sb = inode->i_sb;
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	if (sbi->mount_snapshot == 0)
+		return nova_readdir_fast(file, ctx);
+	else
+		return nova_readdir_slow(file, ctx);
+}
+
+const struct file_operations nova_dir_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= generic_read_dir,
+	.iterate	= nova_readdir,
+	.fsync		= noop_fsync,
+	.unlocked_ioctl = nova_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= nova_compat_ioctl,
+#endif
+};
diff --git a/fs/nova/file.c b/fs/nova/file.c
new file mode 100644
index 000000000000..51b2114796df
--- /dev/null
+++ b/fs/nova/file.c
@@ -0,0 +1,943 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * File operations for files.
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ * Copyright 2012-2013 Intel Corporation
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/slab.h>
+#include <linux/uio.h>
+#include <linux/uaccess.h>
+#include <linux/falloc.h>
+#include <asm/mman.h>
+#include "nova.h"
+#include "inode.h"
+
+
+static inline int nova_can_set_blocksize_hint(struct inode *inode,
+	struct nova_inode *pi, loff_t new_size)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+
+	/* Currently, we don't deallocate data blocks till the file is deleted.
+	 * So no changing blocksize hints once allocation is done.
+	 */
+	if (sih->i_size > 0)
+		return 0;
+	return 1;
+}
+
+int nova_set_blocksize_hint(struct super_block *sb, struct inode *inode,
+	struct nova_inode *pi, loff_t new_size)
+{
+	unsigned short block_type;
+
+	if (!nova_can_set_blocksize_hint(inode, pi, new_size))
+		return 0;
+
+	if (new_size >= 0x40000000) {   /* 1G */
+		block_type = NOVA_BLOCK_TYPE_1G;
+		goto hint_set;
+	}
+
+	if (new_size >= 0x200000) {     /* 2M */
+		block_type = NOVA_BLOCK_TYPE_2M;
+		goto hint_set;
+	}
+
+	/* defaulting to 4K */
+	block_type = NOVA_BLOCK_TYPE_4K;
+
+hint_set:
+	nova_dbg_verbose(
+		"Hint: new_size 0x%llx, i_size 0x%llx\n",
+		new_size, pi->i_size);
+	nova_dbg_verbose("Setting the hint to 0x%x\n", block_type);
+	nova_memunlock_inode(sb, pi);
+	pi->i_blk_type = block_type;
+	nova_memlock_inode(sb, pi);
+	return 0;
+}
+
+static loff_t nova_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	int retval;
+
+	if (origin != SEEK_DATA && origin != SEEK_HOLE)
+		return generic_file_llseek(file, offset, origin);
+
+	inode_lock(inode);
+	switch (origin) {
+	case SEEK_DATA:
+		retval = nova_find_region(inode, &offset, 0);
+		if (retval) {
+			inode_unlock(inode);
+			return retval;
+		}
+		break;
+	case SEEK_HOLE:
+		retval = nova_find_region(inode, &offset, 1);
+		if (retval) {
+			inode_unlock(inode);
+			return retval;
+		}
+		break;
+	}
+
+	if ((offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) ||
+	    offset > inode->i_sb->s_maxbytes) {
+		inode_unlock(inode);
+		return -ENXIO;
+	}
+
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		file->f_version = 0;
+	}
+
+	inode_unlock(inode);
+	return offset;
+}
+
+/* This function is called by both msync() and fsync().
+ * TODO: Check if we can avoid calling nova_flush_buffer() for fsync. We use
+ * movnti to write data to files, so we may want to avoid doing unnecessary
+ * nova_flush_buffer() on fsync()
+ */
+static int nova_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	unsigned long start_pgoff, end_pgoff;
+	int ret = 0;
+	timing_t fsync_time;
+
+	NOVA_START_TIMING(fsync_t, fsync_time);
+
+	if (datasync)
+		NOVA_STATS_ADD(fdatasync, 1);
+
+	/* No need to flush if the file is not mmaped */
+	if (!mapping_mapped(mapping))
+		goto persist;
+
+	start_pgoff = start >> PAGE_SHIFT;
+	end_pgoff = (end + 1) >> PAGE_SHIFT;
+	nova_dbgv("%s: msync pgoff range %lu to %lu\n",
+			__func__, start_pgoff, end_pgoff);
+
+	/*
+	 * Set csum and parity.
+	 * We do not protect data integrity during mmap, but we have to
+	 * update csum here since msync clears dirty bit.
+	 */
+	nova_reset_mapping_csum_parity(sb, inode, mapping,
+					start_pgoff, end_pgoff);
+
+	ret = generic_file_fsync(file, start, end, datasync);
+
+persist:
+	PERSISTENT_BARRIER();
+	NOVA_END_TIMING(fsync_t, fsync_time);
+
+	return ret;
+}
+
+/* This callback is called when a file is closed */
+static int nova_flush(struct file *file, fl_owner_t id)
+{
+	PERSISTENT_BARRIER();
+	return 0;
+}
+
+static int nova_open(struct inode *inode, struct file *filp)
+{
+	return generic_file_open(inode, filp);
+}
+
+static long nova_fallocate(struct file *file, int mode, loff_t offset,
+	loff_t len)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_inode *pi;
+	struct nova_file_write_entry *entry;
+	struct nova_file_write_entry *entryc, entry_copy;
+	struct nova_file_write_entry entry_data;
+	struct nova_inode_update update;
+	unsigned long start_blk, num_blocks, ent_blks = 0;
+	unsigned long total_blocks = 0;
+	unsigned long blocknr = 0;
+	unsigned long blockoff;
+	unsigned int data_bits;
+	loff_t new_size;
+	long ret = 0;
+	int inplace = 0;
+	int blocksize_mask;
+	int allocated = 0;
+	bool update_log = false;
+	timing_t fallocate_time;
+	u64 begin_tail = 0;
+	u64 epoch_id;
+	u32 time;
+
+	/*
+	 * Fallocate does not make much sence for CoW,
+	 * but we still support it for DAX-mmap purpose.
+	 */
+
+	/* We only support the FALLOC_FL_KEEP_SIZE mode */
+	if (mode & ~FALLOC_FL_KEEP_SIZE)
+		return -EOPNOTSUPP;
+
+	if (S_ISDIR(inode->i_mode))
+		return -ENODEV;
+
+	new_size = len + offset;
+	if (!(mode & FALLOC_FL_KEEP_SIZE) && new_size > inode->i_size) {
+		ret = inode_newsize_ok(inode, new_size);
+		if (ret)
+			return ret;
+	} else {
+		new_size = inode->i_size;
+	}
+
+	nova_dbgv("%s: inode %lu, offset %lld, count %lld, mode 0x%x\n",
+			__func__, inode->i_ino,	offset, len, mode);
+
+	NOVA_START_TIMING(fallocate_t, fallocate_time);
+	inode_lock(inode);
+
+	pi = nova_get_inode(sb, inode);
+	if (!pi) {
+		ret = -EACCES;
+		goto out;
+	}
+
+	inode->i_mtime = inode->i_ctime = current_time(inode);
+	time = current_time(inode).tv_sec;
+
+	blocksize_mask = sb->s_blocksize - 1;
+	start_blk = offset >> sb->s_blocksize_bits;
+	blockoff = offset & blocksize_mask;
+	num_blocks = (blockoff + len + blocksize_mask) >> sb->s_blocksize_bits;
+
+	epoch_id = nova_get_epoch_id(sb);
+	update.tail = sih->log_tail;
+	update.alter_tail = sih->alter_log_tail;
+	while (num_blocks > 0) {
+		ent_blks = nova_check_existing_entry(sb, inode, num_blocks,
+						start_blk, &entry, &entry_copy,
+						1, epoch_id, &inplace, 1);
+
+		entryc = (metadata_csum == 0) ? entry : &entry_copy;
+
+		if (entry && inplace) {
+			if (entryc->size < new_size) {
+				/* Update existing entry */
+				nova_memunlock_range(sb, entry, CACHELINE_SIZE);
+				entry->size = new_size;
+				nova_update_entry_csum(entry);
+				nova_update_alter_entry(sb, entry);
+				nova_memlock_range(sb, entry, CACHELINE_SIZE);
+			}
+			allocated = ent_blks;
+			goto next;
+		}
+
+		/* Allocate zeroed blocks to fill hole */
+		allocated = nova_new_data_blocks(sb, sih, &blocknr, start_blk,
+				 ent_blks, ALLOC_INIT_ZERO, ANY_CPU,
+				 ALLOC_FROM_HEAD);
+		nova_dbgv("%s: alloc %d blocks @ %lu\n", __func__,
+						allocated, blocknr);
+
+		if (allocated <= 0) {
+			nova_dbg("%s alloc %lu blocks failed!, %d\n",
+						__func__, ent_blks, allocated);
+			ret = allocated;
+			goto out;
+		}
+
+		/* Handle hole fill write */
+		nova_init_file_write_entry(sb, sih, &entry_data, epoch_id,
+					start_blk, allocated, blocknr,
+					time, new_size);
+
+		ret = nova_append_file_write_entry(sb, pi, inode,
+					&entry_data, &update);
+		if (ret) {
+			nova_dbg("%s: append inode entry failed\n", __func__);
+			ret = -ENOSPC;
+			goto out;
+		}
+
+		entry = nova_get_block(sb, update.curr_entry);
+		nova_reset_csum_parity_range(sb, sih, entry, start_blk,
+					start_blk + allocated, 1, 0);
+
+		update_log = true;
+		if (begin_tail == 0)
+			begin_tail = update.curr_entry;
+
+		total_blocks += allocated;
+next:
+		num_blocks -= allocated;
+		start_blk += allocated;
+	}
+
+	data_bits = blk_type_to_shift[sih->i_blk_type];
+	sih->i_blocks += (total_blocks << (data_bits - sb->s_blocksize_bits));
+
+	inode->i_blocks = sih->i_blocks;
+
+	if (update_log) {
+		sih->log_tail = update.tail;
+		sih->alter_log_tail = update.alter_tail;
+
+		nova_memunlock_inode(sb, pi);
+		nova_update_tail(pi, update.tail);
+		if (metadata_csum)
+			nova_update_alter_tail(pi, update.alter_tail);
+		nova_memlock_inode(sb, pi);
+
+		/* Update file tree */
+		ret = nova_reassign_file_tree(sb, sih, begin_tail);
+		if (ret)
+			goto out;
+
+	}
+
+	nova_dbgv("blocks: %lu, %lu\n", inode->i_blocks, sih->i_blocks);
+
+	if (ret || (mode & FALLOC_FL_KEEP_SIZE)) {
+		nova_memunlock_inode(sb, pi);
+		pi->i_flags |= cpu_to_le32(NOVA_EOFBLOCKS_FL);
+		nova_memlock_inode(sb, pi);
+	}
+
+	if (!(mode & FALLOC_FL_KEEP_SIZE) && new_size > inode->i_size) {
+		inode->i_size = new_size;
+		sih->i_size = new_size;
+	}
+
+	nova_memunlock_inode(sb, pi);
+	nova_update_inode_checksum(pi);
+	nova_update_alter_inode(sb, inode, pi);
+	nova_memlock_inode(sb, pi);
+
+	sih->trans_id++;
+out:
+	if (ret < 0)
+		nova_cleanup_incomplete_write(sb, sih, blocknr, allocated,
+						begin_tail, update.tail);
+
+	inode_unlock(inode);
+	NOVA_END_TIMING(fallocate_t, fallocate_time);
+	return ret;
+}
+
+static int nova_iomap_begin_nolock(struct inode *inode, loff_t offset,
+	loff_t length, unsigned int flags, struct iomap *iomap)
+{
+	return nova_iomap_begin(inode, offset, length, flags, iomap, false);
+}
+
+static struct iomap_ops nova_iomap_ops_nolock = {
+	.iomap_begin	= nova_iomap_begin_nolock,
+	.iomap_end	= nova_iomap_end,
+};
+
+static ssize_t nova_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	ssize_t ret;
+	timing_t read_iter_time;
+
+	if (!iov_iter_count(to))
+		return 0;
+
+	NOVA_START_TIMING(read_iter_t, read_iter_time);
+	inode_lock_shared(inode);
+	ret = dax_iomap_rw(iocb, to, &nova_iomap_ops_nolock);
+	inode_unlock_shared(inode);
+
+	file_accessed(iocb->ki_filp);
+	NOVA_END_TIMING(read_iter_t, read_iter_time);
+	return ret;
+}
+
+static int nova_update_iter_csum_parity(struct super_block *sb,
+	struct inode *inode, loff_t offset, size_t count)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	unsigned long start_pgoff, end_pgoff;
+	loff_t end;
+
+	if (data_csum == 0 && data_parity == 0)
+		return 0;
+
+	end = offset + count;
+
+	start_pgoff = offset >> sb->s_blocksize_bits;
+	end_pgoff = end >> sb->s_blocksize_bits;
+	if (end & (nova_inode_blk_size(sih) - 1))
+		end_pgoff++;
+
+	nova_reset_csum_parity_range(sb, sih, NULL, start_pgoff,
+			end_pgoff, 0, 0);
+
+	return 0;
+}
+
+static ssize_t nova_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	struct super_block *sb = inode->i_sb;
+	loff_t offset;
+	size_t count;
+	ssize_t ret;
+	timing_t write_iter_time;
+
+	NOVA_START_TIMING(write_iter_t, write_iter_time);
+	inode_lock(inode);
+	ret = generic_write_checks(iocb, from);
+	if (ret <= 0)
+		goto out_unlock;
+
+	ret = file_remove_privs(file);
+	if (ret)
+		goto out_unlock;
+
+	ret = file_update_time(file);
+	if (ret)
+		goto out_unlock;
+
+	count = iov_iter_count(from);
+	offset = iocb->ki_pos;
+
+	ret = dax_iomap_rw(iocb, from, &nova_iomap_ops_nolock);
+	if (ret > 0 && iocb->ki_pos > i_size_read(inode)) {
+		i_size_write(inode, iocb->ki_pos);
+		mark_inode_dirty(inode);
+	}
+
+	nova_update_iter_csum_parity(sb, inode, offset, count);
+
+out_unlock:
+	inode_unlock(inode);
+	if (ret > 0)
+		ret = generic_write_sync(iocb, ret);
+	NOVA_END_TIMING(write_iter_t, write_iter_time);
+	return ret;
+}
+
+static ssize_t
+do_dax_mapping_read(struct file *filp, char __user *buf,
+	size_t len, loff_t *ppos)
+{
+	struct inode *inode = filp->f_mapping->host;
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_file_write_entry *entry;
+	struct nova_file_write_entry *entryc, entry_copy;
+	pgoff_t index, end_index;
+	unsigned long offset;
+	loff_t isize, pos;
+	size_t copied = 0, error = 0;
+	timing_t memcpy_time;
+
+	pos = *ppos;
+	index = pos >> PAGE_SHIFT;
+	offset = pos & ~PAGE_MASK;
+
+	if (!access_ok(VERIFY_WRITE, buf, len)) {
+		error = -EFAULT;
+		goto out;
+	}
+
+	isize = i_size_read(inode);
+	if (!isize)
+		goto out;
+
+	nova_dbgv("%s: inode %lu, offset %lld, count %lu, size %lld\n",
+		__func__, inode->i_ino,	pos, len, isize);
+
+	if (len > isize - pos)
+		len = isize - pos;
+
+	if (len <= 0)
+		goto out;
+
+	entryc = (metadata_csum == 0) ? entry : &entry_copy;
+
+	end_index = (isize - 1) >> PAGE_SHIFT;
+	do {
+		unsigned long nr, left;
+		unsigned long nvmm;
+		void *dax_mem = NULL;
+		int zero = 0;
+
+		/* nr is the maximum number of bytes to copy from this page */
+		if (index >= end_index) {
+			if (index > end_index)
+				goto out;
+			nr = ((isize - 1) & ~PAGE_MASK) + 1;
+			if (nr <= offset)
+				goto out;
+		}
+
+		entry = nova_get_write_entry(sb, sih, index);
+		if (unlikely(entry == NULL)) {
+			nova_dbgv("Required extent not found: pgoff %lu, inode size %lld\n",
+				index, isize);
+			nr = PAGE_SIZE;
+			zero = 1;
+			goto memcpy;
+		}
+
+		if (metadata_csum == 0)
+			entryc = entry;
+		else if (!nova_verify_entry_csum(sb, entry, entryc))
+			return -EIO;
+
+		/* Find contiguous blocks */
+		if (index < entryc->pgoff ||
+			index - entryc->pgoff >= entryc->num_pages) {
+			nova_err(sb, "%s ERROR: %lu, entry pgoff %llu, num %u, blocknr %llu\n",
+				__func__, index, entry->pgoff,
+				entry->num_pages, entry->block >> PAGE_SHIFT);
+			return -EINVAL;
+		}
+		if (entryc->reassigned == 0) {
+			nr = (entryc->num_pages - (index - entryc->pgoff))
+				* PAGE_SIZE;
+		} else {
+			nr = PAGE_SIZE;
+		}
+
+		nvmm = get_nvmm(sb, sih, entryc, index);
+		dax_mem = nova_get_block(sb, (nvmm << PAGE_SHIFT));
+
+memcpy:
+		nr = nr - offset;
+		if (nr > len - copied)
+			nr = len - copied;
+
+		if ((!zero) && (data_csum > 0)) {
+			if (nova_find_pgoff_in_vma(inode, index))
+				goto skip_verify;
+
+			if (!nova_verify_data_csum(sb, sih, nvmm, offset, nr)) {
+				nova_err(sb, "%s: nova data checksum and recovery fail! inode %lu, offset %lu, entry pgoff %lu, %u pages, pgoff %lu\n",
+					 __func__, inode->i_ino, offset,
+					 entry->pgoff, entry->num_pages, index);
+				error = -EIO;
+				goto out;
+			}
+		}
+skip_verify:
+		NOVA_START_TIMING(memcpy_r_nvmm_t, memcpy_time);
+
+		if (!zero)
+			left = __copy_to_user(buf + copied,
+						dax_mem + offset, nr);
+		else
+			left = __clear_user(buf + copied, nr);
+
+		NOVA_END_TIMING(memcpy_r_nvmm_t, memcpy_time);
+
+		if (left) {
+			nova_dbg("%s ERROR!: bytes %lu, left %lu\n",
+				__func__, nr, left);
+			error = -EFAULT;
+			goto out;
+		}
+
+		copied += (nr - left);
+		offset += (nr - left);
+		index += offset >> PAGE_SHIFT;
+		offset &= ~PAGE_MASK;
+	} while (copied < len);
+
+out:
+	*ppos = pos + copied;
+	if (filp)
+		file_accessed(filp);
+
+	NOVA_STATS_ADD(read_bytes, copied);
+
+	nova_dbgv("%s returned %zu\n", __func__, copied);
+	return copied ? copied : error;
+}
+
+/*
+ * Wrappers. We need to use the rcu read lock to avoid
+ * concurrent truncate operation. No problem for write because we held
+ * lock.
+ */
+static ssize_t nova_dax_file_read(struct file *filp, char __user *buf,
+			    size_t len, loff_t *ppos)
+{
+	struct inode *inode = filp->f_mapping->host;
+	ssize_t res;
+	timing_t dax_read_time;
+
+	NOVA_START_TIMING(dax_read_t, dax_read_time);
+	inode_lock_shared(inode);
+	res = do_dax_mapping_read(filp, buf, len, ppos);
+	inode_unlock_shared(inode);
+	NOVA_END_TIMING(dax_read_t, dax_read_time);
+	return res;
+}
+
+static ssize_t nova_cow_file_write(struct file *filp,
+	const char __user *buf,	size_t len, loff_t *ppos)
+{
+	struct address_space *mapping = filp->f_mapping;
+	struct inode	*inode = mapping->host;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode *pi, inode_copy;
+	struct nova_file_write_entry entry_data;
+	struct nova_inode_update update;
+	ssize_t	    written = 0;
+	loff_t pos;
+	size_t count, offset, copied;
+	unsigned long start_blk, num_blocks;
+	unsigned long total_blocks;
+	unsigned long blocknr = 0;
+	unsigned int data_bits;
+	int allocated = 0;
+	void *kmem;
+	u64 file_size;
+	size_t bytes;
+	long status = 0;
+	timing_t cow_write_time, memcpy_time;
+	unsigned long step = 0;
+	ssize_t ret;
+	u64 begin_tail = 0;
+	int try_inplace = 0;
+	u64 epoch_id;
+	u32 time;
+
+
+	if (len == 0)
+		return 0;
+
+	NOVA_START_TIMING(cow_write_t, cow_write_time);
+
+	sb_start_write(inode->i_sb);
+	inode_lock(inode);
+
+	if (!access_ok(VERIFY_READ, buf, len)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	pos = *ppos;
+
+	if (filp->f_flags & O_APPEND)
+		pos = i_size_read(inode);
+
+	count = len;
+
+	pi = nova_get_block(sb, sih->pi_addr);
+
+	/* nova_inode tail pointer will be updated and we make sure all other
+	 * inode fields are good before checksumming the whole structure
+	 */
+	if (nova_check_inode_integrity(sb, sih->ino, sih->pi_addr,
+			sih->alter_pi_addr, &inode_copy, 0) < 0) {
+		ret = -EIO;
+		goto out;
+	}
+
+	offset = pos & (sb->s_blocksize - 1);
+	num_blocks = ((count + offset - 1) >> sb->s_blocksize_bits) + 1;
+	total_blocks = num_blocks;
+	start_blk = pos >> sb->s_blocksize_bits;
+
+	if (nova_check_overlap_vmas(sb, sih, start_blk, num_blocks)) {
+		nova_dbgv("COW write overlaps with vma: inode %lu, pgoff %lu, %lu blocks\n",
+				inode->i_ino, start_blk, num_blocks);
+		NOVA_STATS_ADD(cow_overlap_mmap, 1);
+		try_inplace = 1;
+		ret = -EACCES;
+		goto out;
+	}
+
+	/* offset in the actual block size block */
+
+	ret = file_remove_privs(filp);
+	if (ret)
+		goto out;
+
+	inode->i_ctime = inode->i_mtime = current_time(inode);
+	time = current_time(inode).tv_sec;
+
+	nova_dbgv("%s: inode %lu, offset %lld, count %lu\n",
+			__func__, inode->i_ino,	pos, count);
+
+	epoch_id = nova_get_epoch_id(sb);
+	update.tail = sih->log_tail;
+	update.alter_tail = sih->alter_log_tail;
+	while (num_blocks > 0) {
+		offset = pos & (nova_inode_blk_size(sih) - 1);
+		start_blk = pos >> sb->s_blocksize_bits;
+
+		/* don't zero-out the allocated blocks */
+		allocated = nova_new_data_blocks(sb, sih, &blocknr, start_blk,
+				 num_blocks, ALLOC_NO_INIT, ANY_CPU,
+				 ALLOC_FROM_HEAD);
+
+		nova_dbg_verbose("%s: alloc %d blocks @ %lu\n", __func__,
+						allocated, blocknr);
+
+		if (allocated <= 0) {
+			nova_dbg("%s alloc blocks failed %d\n", __func__,
+								allocated);
+			ret = allocated;
+			goto out;
+		}
+
+		step++;
+		bytes = sb->s_blocksize * allocated - offset;
+		if (bytes > count)
+			bytes = count;
+
+		kmem = nova_get_block(inode->i_sb,
+			     nova_get_block_off(sb, blocknr, sih->i_blk_type));
+
+		if (offset || ((offset + bytes) & (PAGE_SIZE - 1)) != 0)  {
+			ret = nova_handle_head_tail_blocks(sb, inode, pos,
+							   bytes, kmem);
+			if (ret)
+				goto out;
+		}
+		/* Now copy from user buf */
+		//		nova_dbg("Write: %p\n", kmem);
+		NOVA_START_TIMING(memcpy_w_nvmm_t, memcpy_time);
+		nova_memunlock_range(sb, kmem + offset, bytes);
+		copied = bytes - memcpy_to_pmem_nocache(kmem + offset,
+						buf, bytes);
+		nova_memlock_range(sb, kmem + offset, bytes);
+		NOVA_END_TIMING(memcpy_w_nvmm_t, memcpy_time);
+
+		if (data_csum > 0 || data_parity > 0) {
+			ret = nova_protect_file_data(sb, inode, pos, bytes,
+							buf, blocknr, false);
+			if (ret)
+				goto out;
+		}
+
+		if (pos + copied > inode->i_size)
+			file_size = cpu_to_le64(pos + copied);
+		else
+			file_size = cpu_to_le64(inode->i_size);
+
+		nova_init_file_write_entry(sb, sih, &entry_data, epoch_id,
+					start_blk, allocated, blocknr, time,
+					file_size);
+
+		ret = nova_append_file_write_entry(sb, pi, inode,
+					&entry_data, &update);
+		if (ret) {
+			nova_dbg("%s: append inode entry failed\n", __func__);
+			ret = -ENOSPC;
+			goto out;
+		}
+
+		nova_dbgv("Write: %p, %lu\n", kmem, copied);
+		if (copied > 0) {
+			status = copied;
+			written += copied;
+			pos += copied;
+			buf += copied;
+			count -= copied;
+			num_blocks -= allocated;
+		}
+		if (unlikely(copied != bytes)) {
+			nova_dbg("%s ERROR!: %p, bytes %lu, copied %lu\n",
+				__func__, kmem, bytes, copied);
+			if (status >= 0)
+				status = -EFAULT;
+		}
+		if (status < 0)
+			break;
+
+		if (begin_tail == 0)
+			begin_tail = update.curr_entry;
+	}
+
+	data_bits = blk_type_to_shift[sih->i_blk_type];
+	sih->i_blocks += (total_blocks << (data_bits - sb->s_blocksize_bits));
+
+	nova_memunlock_inode(sb, pi);
+	nova_update_inode(sb, inode, pi, &update, 1);
+	nova_memlock_inode(sb, pi);
+
+	/* Free the overlap blocks after the write is committed */
+	ret = nova_reassign_file_tree(sb, sih, begin_tail);
+	if (ret)
+		goto out;
+
+	inode->i_blocks = sih->i_blocks;
+
+	ret = written;
+	NOVA_STATS_ADD(cow_write_breaks, step);
+	nova_dbgv("blocks: %lu, %lu\n", inode->i_blocks, sih->i_blocks);
+
+	*ppos = pos;
+	if (pos > inode->i_size) {
+		i_size_write(inode, pos);
+		sih->i_size = pos;
+	}
+
+	sih->trans_id++;
+out:
+	if (ret < 0)
+		nova_cleanup_incomplete_write(sb, sih, blocknr, allocated,
+						begin_tail, update.tail);
+
+	inode_unlock(inode);
+	sb_end_write(inode->i_sb);
+	NOVA_END_TIMING(cow_write_t, cow_write_time);
+	NOVA_STATS_ADD(cow_write_bytes, written);
+
+	if (try_inplace)
+		return nova_inplace_file_write(filp, buf, len, ppos);
+
+	return ret;
+}
+
+static ssize_t nova_dax_file_write(struct file *filp, const char __user *buf,
+	size_t len, loff_t *ppos)
+{
+	if (inplace_data_updates)
+		return nova_inplace_file_write(filp, buf, len, ppos);
+	else
+		return nova_cow_file_write(filp, buf, len, ppos);
+}
+
+static int nova_dax_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct inode *inode = file->f_mapping->host;
+
+	file_accessed(file);
+
+	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+
+	vma->vm_ops = &nova_dax_vm_ops;
+
+	nova_insert_write_vma(vma);
+
+	nova_dbg_mmap4k("[%s:%d] inode %lu, MMAP 4KPAGE vm_start(0x%lx), vm_end(0x%lx), vm pgoff %lu, %lu blocks, vm_flags(0x%lx), vm_page_prot(0x%lx)\n",
+			__func__, __LINE__,
+			inode->i_ino, vma->vm_start, vma->vm_end,
+			vma->vm_pgoff,
+			(vma->vm_end - vma->vm_start) >> PAGE_SHIFT,
+			vma->vm_flags,
+			pgprot_val(vma->vm_page_prot));
+
+	return 0;
+}
+
+const struct file_operations nova_dax_file_operations = {
+	.llseek			= nova_llseek,
+	.read			= nova_dax_file_read,
+	.write			= nova_dax_file_write,
+	.read_iter		= nova_dax_read_iter,
+	.write_iter		= nova_dax_write_iter,
+	.mmap			= nova_dax_file_mmap,
+	.open			= nova_open,
+	.fsync			= nova_fsync,
+	.flush			= nova_flush,
+	.unlocked_ioctl		= nova_ioctl,
+	.fallocate		= nova_fallocate,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl		= nova_compat_ioctl,
+#endif
+};
+
+
+static ssize_t nova_wrap_rw_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	struct file *filp = iocb->ki_filp;
+	ssize_t ret = -EIO;
+	ssize_t written = 0;
+	unsigned long seg;
+	unsigned long nr_segs = iter->nr_segs;
+	const struct iovec *iv = iter->iov;
+
+	nova_dbgv("%s %s: %lu segs\n", __func__,
+			iov_iter_rw(iter) == READ ? "read" : "write",
+			nr_segs);
+	iv = iter->iov;
+	for (seg = 0; seg < nr_segs; seg++) {
+		if (iov_iter_rw(iter) == READ) {
+			ret = nova_dax_file_read(filp, iv->iov_base,
+					iv->iov_len, &iocb->ki_pos);
+		} else if (iov_iter_rw(iter) == WRITE) {
+			ret = nova_dax_file_write(filp, iv->iov_base,
+					iv->iov_len, &iocb->ki_pos);
+		}
+		if (ret < 0)
+			goto err;
+
+		if (iter->count > iv->iov_len)
+			iter->count -= iv->iov_len;
+		else
+			iter->count = 0;
+
+		written += ret;
+		iter->nr_segs--;
+		iv++;
+	}
+	ret = written;
+err:
+	return ret;
+}
+
+
+/* Wrap read/write_iter for DP, CoW and WP */
+const struct file_operations nova_wrap_file_operations = {
+	.llseek			= nova_llseek,
+	.read			= nova_dax_file_read,
+	.write			= nova_dax_file_write,
+	.read_iter		= nova_wrap_rw_iter,
+	.write_iter		= nova_wrap_rw_iter,
+	.mmap			= nova_dax_file_mmap,
+	.open			= nova_open,
+	.fsync			= nova_fsync,
+	.flush			= nova_flush,
+	.unlocked_ioctl		= nova_ioctl,
+	.fallocate		= nova_fallocate,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl		= nova_compat_ioctl,
+#endif
+};
+
+const struct inode_operations nova_file_inode_operations = {
+	.setattr	= nova_notify_change,
+	.getattr	= nova_getattr,
+	.get_acl	= NULL,
+};
diff --git a/fs/nova/namei.c b/fs/nova/namei.c
new file mode 100644
index 000000000000..59776338008d
--- /dev/null
+++ b/fs/nova/namei.c
@@ -0,0 +1,919 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Inode operations for directories.
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ * Copyright 2012-2013 Intel Corporation
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+#include "nova.h"
+#include "journal.h"
+#include "inode.h"
+
+static ino_t nova_inode_by_name(struct inode *dir, struct qstr *entry,
+				 struct nova_dentry **res_entry)
+{
+	struct super_block *sb = dir->i_sb;
+	struct nova_dentry *direntry;
+	struct nova_dentry *direntryc, entry_copy;
+
+	direntry = nova_find_dentry(sb, NULL, dir,
+					entry->name, entry->len);
+	if (direntry == NULL)
+		return 0;
+
+	if (metadata_csum == 0)
+		direntryc = direntry;
+	else {
+		direntryc = &entry_copy;
+		if (!nova_verify_entry_csum(sb, direntry, direntryc))
+			return 0;
+	}
+
+	*res_entry = direntry;
+	return direntryc->ino;
+}
+
+static struct dentry *nova_lookup(struct inode *dir, struct dentry *dentry,
+				   unsigned int flags)
+{
+	struct inode *inode = NULL;
+	struct nova_dentry *de;
+	ino_t ino;
+	timing_t lookup_time;
+
+	NOVA_START_TIMING(lookup_t, lookup_time);
+	if (dentry->d_name.len > NOVA_NAME_LEN) {
+		nova_dbg("%s: namelen %u exceeds limit\n",
+			__func__, dentry->d_name.len);
+		return ERR_PTR(-ENAMETOOLONG);
+	}
+
+	nova_dbg_verbose("%s: %s\n", __func__, dentry->d_name.name);
+	ino = nova_inode_by_name(dir, &dentry->d_name, &de);
+	nova_dbg_verbose("%s: ino %lu\n", __func__, ino);
+	if (ino) {
+		inode = nova_iget(dir->i_sb, ino);
+		if (inode == ERR_PTR(-ESTALE) || inode == ERR_PTR(-ENOMEM)
+				|| inode == ERR_PTR(-EACCES)) {
+			nova_err(dir->i_sb,
+				  "%s: get inode failed: %lu\n",
+				  __func__, (unsigned long)ino);
+			return ERR_PTR(-EIO);
+		}
+	}
+
+	NOVA_END_TIMING(lookup_t, lookup_time);
+	return d_splice_alias(inode, dentry);
+}
+
+static void nova_lite_transaction_for_new_inode(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode *pidir, struct inode *inode,
+	struct inode *dir, struct nova_inode_update *update)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	int cpu;
+	u64 journal_tail;
+	timing_t trans_time;
+
+	NOVA_START_TIMING(create_trans_t, trans_time);
+
+	cpu = smp_processor_id();
+	spin_lock(&sbi->journal_locks[cpu]);
+	nova_memunlock_journal(sb);
+
+	// If you change what's required to create a new inode, you need to
+	// update this functions so the changes will be roll back on failure.
+	journal_tail = nova_create_inode_transaction(sb, inode, dir, cpu, 1, 0);
+
+	nova_update_inode(sb, dir, pidir, update, 0);
+
+	pi->valid = 1;
+	nova_update_inode_checksum(pi);
+	PERSISTENT_BARRIER();
+
+	nova_commit_lite_transaction(sb, journal_tail, cpu);
+	nova_memlock_journal(sb);
+	spin_unlock(&sbi->journal_locks[cpu]);
+
+	if (metadata_csum) {
+		nova_memunlock_inode(sb, pi);
+		nova_update_alter_inode(sb, inode, pi);
+		nova_update_alter_inode(sb, dir, pidir);
+		nova_memlock_inode(sb, pi);
+	}
+	NOVA_END_TIMING(create_trans_t, trans_time);
+}
+
+/* Returns new tail after append */
+/*
+ * By the time this is called, we already have created
+ * the directory cache entry for the new file, but it
+ * is so far negative - it has no inode.
+ *
+ * If the create succeeds, we fill in the inode information
+ * with d_instantiate().
+ */
+static int nova_create(struct inode *dir, struct dentry *dentry, umode_t mode,
+			bool excl)
+{
+	struct inode *inode = NULL;
+	int err = PTR_ERR(inode);
+	struct super_block *sb = dir->i_sb;
+	struct nova_inode *pidir, *pi;
+	struct nova_inode_update update;
+	u64 pi_addr = 0;
+	u64 ino, epoch_id;
+	timing_t create_time;
+
+	NOVA_START_TIMING(create_t, create_time);
+
+	pidir = nova_get_inode(sb, dir);
+	if (!pidir)
+		goto out_err;
+
+	epoch_id = nova_get_epoch_id(sb);
+	ino = nova_new_nova_inode(sb, &pi_addr);
+	if (ino == 0)
+		goto out_err;
+
+	update.tail = 0;
+	update.alter_tail = 0;
+	err = nova_add_dentry(dentry, ino, 0, &update, epoch_id);
+	if (err)
+		goto out_err;
+
+	nova_dbgv("%s: %s\n", __func__, dentry->d_name.name);
+	nova_dbgv("%s: inode %llu, dir %lu\n", __func__, ino, dir->i_ino);
+	inode = nova_new_vfs_inode(TYPE_CREATE, dir, pi_addr, ino, mode,
+					0, 0, &dentry->d_name, epoch_id);
+	if (IS_ERR(inode))
+		goto out_err;
+
+	d_instantiate(dentry, inode);
+	unlock_new_inode(inode);
+
+	pi = nova_get_block(sb, pi_addr);
+	nova_lite_transaction_for_new_inode(sb, pi, pidir, inode, dir,
+						&update);
+	NOVA_END_TIMING(create_t, create_time);
+	return err;
+out_err:
+	nova_err(sb, "%s return %d\n", __func__, err);
+	NOVA_END_TIMING(create_t, create_time);
+	return err;
+}
+
+static int nova_mknod(struct inode *dir, struct dentry *dentry, umode_t mode,
+		       dev_t rdev)
+{
+	struct inode *inode = NULL;
+	int err = PTR_ERR(inode);
+	struct super_block *sb = dir->i_sb;
+	u64 pi_addr = 0;
+	struct nova_inode *pidir, *pi;
+	struct nova_inode_update update;
+	u64 ino;
+	u64 epoch_id;
+	timing_t mknod_time;
+
+	NOVA_START_TIMING(mknod_t, mknod_time);
+
+	pidir = nova_get_inode(sb, dir);
+	if (!pidir)
+		goto out_err;
+
+	epoch_id = nova_get_epoch_id(sb);
+	ino = nova_new_nova_inode(sb, &pi_addr);
+	if (ino == 0)
+		goto out_err;
+
+	nova_dbgv("%s: %s\n", __func__, dentry->d_name.name);
+	nova_dbgv("%s: inode %llu, dir %lu\n", __func__, ino, dir->i_ino);
+
+	update.tail = 0;
+	update.alter_tail = 0;
+	err = nova_add_dentry(dentry, ino, 0, &update, epoch_id);
+	if (err)
+		goto out_err;
+
+	inode = nova_new_vfs_inode(TYPE_MKNOD, dir, pi_addr, ino, mode,
+					0, rdev, &dentry->d_name, epoch_id);
+	if (IS_ERR(inode))
+		goto out_err;
+
+	d_instantiate(dentry, inode);
+	unlock_new_inode(inode);
+
+	pi = nova_get_block(sb, pi_addr);
+	nova_lite_transaction_for_new_inode(sb, pi, pidir, inode, dir,
+						&update);
+	NOVA_END_TIMING(mknod_t, mknod_time);
+	return err;
+out_err:
+	nova_err(sb, "%s return %d\n", __func__, err);
+	NOVA_END_TIMING(mknod_t, mknod_time);
+	return err;
+}
+
+static int nova_symlink(struct inode *dir, struct dentry *dentry,
+			 const char *symname)
+{
+	struct super_block *sb = dir->i_sb;
+	int err = -ENAMETOOLONG;
+	unsigned int len = strlen(symname);
+	struct inode *inode;
+	struct nova_inode_info *si;
+	struct nova_inode_info_header *sih;
+	u64 pi_addr = 0;
+	struct nova_inode *pidir, *pi;
+	struct nova_inode_update update;
+	u64 ino;
+	u64 epoch_id;
+	timing_t symlink_time;
+
+	NOVA_START_TIMING(symlink_t, symlink_time);
+	if (len + 1 > sb->s_blocksize)
+		goto out;
+
+	pidir = nova_get_inode(sb, dir);
+	if (!pidir)
+		goto out_fail;
+
+	epoch_id = nova_get_epoch_id(sb);
+	ino = nova_new_nova_inode(sb, &pi_addr);
+	if (ino == 0)
+		goto out_fail;
+
+	nova_dbgv("%s: name %s, symname %s\n", __func__,
+				dentry->d_name.name, symname);
+	nova_dbgv("%s: inode %llu, dir %lu\n", __func__, ino, dir->i_ino);
+
+	update.tail = 0;
+	update.alter_tail = 0;
+	err = nova_add_dentry(dentry, ino, 0, &update, epoch_id);
+	if (err)
+		goto out_fail;
+
+	inode = nova_new_vfs_inode(TYPE_SYMLINK, dir, pi_addr, ino,
+					S_IFLNK|0777, len, 0,
+					&dentry->d_name, epoch_id);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto out_fail;
+	}
+
+	pi = nova_get_inode(sb, inode);
+
+	si = NOVA_I(inode);
+	sih = &si->header;
+
+	err = nova_block_symlink(sb, pi, inode, symname, len, epoch_id);
+	if (err)
+		goto out_fail;
+
+	d_instantiate(dentry, inode);
+	unlock_new_inode(inode);
+
+	nova_lite_transaction_for_new_inode(sb, pi, pidir, inode, dir,
+					&update);
+out:
+	NOVA_END_TIMING(symlink_t, symlink_time);
+	return err;
+
+out_fail:
+	nova_err(sb, "%s return %d\n", __func__, err);
+	goto out;
+}
+
+static void nova_lite_transaction_for_time_and_link(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode *pidir, struct inode *inode,
+	struct inode *dir, struct nova_inode_update *update,
+	struct nova_inode_update *update_dir, int invalidate, u64 epoch_id)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	u64 journal_tail;
+	int cpu;
+	timing_t trans_time;
+
+	NOVA_START_TIMING(link_trans_t, trans_time);
+
+	cpu = smp_processor_id();
+	spin_lock(&sbi->journal_locks[cpu]);
+	nova_memunlock_journal(sb);
+
+	// If you change what's required to create a new inode, you need to
+	// update this functions so the changes will be roll back on failure.
+	journal_tail = nova_create_inode_transaction(sb, inode, dir, cpu,
+						0, invalidate);
+
+	if (invalidate) {
+		pi->valid = 0;
+		pi->delete_epoch_id = epoch_id;
+	}
+	nova_update_inode(sb, inode, pi, update, 0);
+
+	nova_update_inode(sb, dir, pidir, update_dir, 0);
+
+	PERSISTENT_BARRIER();
+
+	nova_commit_lite_transaction(sb, journal_tail, cpu);
+	nova_memlock_journal(sb);
+	spin_unlock(&sbi->journal_locks[cpu]);
+
+	if (metadata_csum) {
+		nova_memunlock_inode(sb, pi);
+		nova_update_alter_inode(sb, inode, pi);
+		nova_update_alter_inode(sb, dir, pidir);
+		nova_memlock_inode(sb, pi);
+	}
+
+	NOVA_END_TIMING(link_trans_t, trans_time);
+}
+
+static int nova_link(struct dentry *dest_dentry, struct inode *dir,
+		      struct dentry *dentry)
+{
+	struct super_block *sb = dir->i_sb;
+	struct inode *inode = dest_dentry->d_inode;
+	struct nova_inode *pi = nova_get_inode(sb, inode);
+	struct nova_inode *pidir;
+	struct nova_inode_update update_dir;
+	struct nova_inode_update update;
+	u64 old_linkc = 0;
+	u64 epoch_id;
+	int err = -ENOMEM;
+	timing_t link_time;
+
+	NOVA_START_TIMING(link_t, link_time);
+	if (inode->i_nlink >= NOVA_LINK_MAX) {
+		err = -EMLINK;
+		goto out;
+	}
+
+	pidir = nova_get_inode(sb, dir);
+	if (!pidir) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	ihold(inode);
+	epoch_id = nova_get_epoch_id(sb);
+
+	nova_dbgv("%s: name %s, dest %s\n", __func__,
+			dentry->d_name.name, dest_dentry->d_name.name);
+	nova_dbgv("%s: inode %lu, dir %lu\n", __func__,
+			inode->i_ino, dir->i_ino);
+
+	update_dir.tail = 0;
+	update_dir.alter_tail = 0;
+	err = nova_add_dentry(dentry, inode->i_ino, 0, &update_dir, epoch_id);
+	if (err) {
+		iput(inode);
+		goto out;
+	}
+
+	inode->i_ctime = current_time(inode);
+	inc_nlink(inode);
+
+	update.tail = 0;
+	update.alter_tail = 0;
+	err = nova_append_link_change_entry(sb, pi, inode, &update,
+						&old_linkc, epoch_id);
+	if (err) {
+		iput(inode);
+		goto out;
+	}
+
+	d_instantiate(dentry, inode);
+	nova_lite_transaction_for_time_and_link(sb, pi, pidir, inode, dir,
+					&update, &update_dir, 0, epoch_id);
+
+	nova_invalidate_link_change_entry(sb, old_linkc);
+
+out:
+	NOVA_END_TIMING(link_t, link_time);
+	return err;
+}
+
+static int nova_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = dir->i_sb;
+	int retval = -ENOMEM;
+	struct nova_inode *pi = nova_get_inode(sb, inode);
+	struct nova_inode *pidir;
+	struct nova_inode_update update_dir;
+	struct nova_inode_update update;
+	u64 old_linkc = 0;
+	u64 epoch_id;
+	int invalidate = 0;
+	timing_t unlink_time;
+
+	NOVA_START_TIMING(unlink_t, unlink_time);
+
+	pidir = nova_get_inode(sb, dir);
+	if (!pidir)
+		goto out;
+
+	epoch_id = nova_get_epoch_id(sb);
+	nova_dbgv("%s: %s\n", __func__, dentry->d_name.name);
+	nova_dbgv("%s: inode %lu, dir %lu\n", __func__,
+				inode->i_ino, dir->i_ino);
+
+	update_dir.tail = 0;
+	update_dir.alter_tail = 0;
+	retval = nova_remove_dentry(dentry, 0, &update_dir, epoch_id);
+	if (retval)
+		goto out;
+
+	inode->i_ctime = dir->i_ctime;
+
+	if (inode->i_nlink == 1)
+		invalidate = 1;
+
+	if (inode->i_nlink)
+		drop_nlink(inode);
+
+	update.tail = 0;
+	update.alter_tail = 0;
+	retval = nova_append_link_change_entry(sb, pi, inode, &update,
+						&old_linkc, epoch_id);
+	if (retval)
+		goto out;
+
+	nova_lite_transaction_for_time_and_link(sb, pi, pidir, inode, dir,
+				&update, &update_dir, invalidate, epoch_id);
+
+	nova_invalidate_link_change_entry(sb, old_linkc);
+	nova_invalidate_dentries(sb, &update_dir);
+
+	NOVA_END_TIMING(unlink_t, unlink_time);
+	return 0;
+out:
+	nova_err(sb, "%s return %d\n", __func__, retval);
+	NOVA_END_TIMING(unlink_t, unlink_time);
+	return retval;
+}
+
+static int nova_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
+{
+	struct super_block *sb = dir->i_sb;
+	struct inode *inode;
+	struct nova_inode *pidir, *pi;
+	struct nova_inode_info *si, *sidir;
+	struct nova_inode_info_header *sih = NULL;
+	struct nova_inode_update update;
+	u64 pi_addr = 0;
+	u64 ino;
+	u64 epoch_id;
+	int err = -EMLINK;
+	timing_t mkdir_time;
+
+	NOVA_START_TIMING(mkdir_t, mkdir_time);
+	if (dir->i_nlink >= NOVA_LINK_MAX)
+		goto out;
+
+	ino = nova_new_nova_inode(sb, &pi_addr);
+	if (ino == 0)
+		goto out_err;
+
+	epoch_id = nova_get_epoch_id(sb);
+	nova_dbgv("%s: name %s\n", __func__, dentry->d_name.name);
+	nova_dbgv("%s: inode %llu, dir %lu, link %d\n", __func__,
+				ino, dir->i_ino, dir->i_nlink);
+
+	update.tail = 0;
+	update.alter_tail = 0;
+	err = nova_add_dentry(dentry, ino, 1, &update, epoch_id);
+	if (err) {
+		nova_dbg("failed to add dir entry\n");
+		goto out_err;
+	}
+
+	inode = nova_new_vfs_inode(TYPE_MKDIR, dir, pi_addr, ino,
+					S_IFDIR | mode, sb->s_blocksize,
+					0, &dentry->d_name, epoch_id);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto out_err;
+	}
+
+	pi = nova_get_inode(sb, inode);
+	nova_append_dir_init_entries(sb, pi, inode->i_ino, dir->i_ino,
+					epoch_id);
+
+	/* Build the dir tree */
+	si = NOVA_I(inode);
+	sih = &si->header;
+	nova_rebuild_dir_inode_tree(sb, pi, pi_addr, sih);
+
+	pidir = nova_get_inode(sb, dir);
+	sidir = NOVA_I(dir);
+	sih = &si->header;
+	dir->i_blocks = sih->i_blocks;
+	inc_nlink(dir);
+	d_instantiate(dentry, inode);
+	unlock_new_inode(inode);
+
+	nova_lite_transaction_for_new_inode(sb, pi, pidir, inode, dir,
+					&update);
+out:
+	NOVA_END_TIMING(mkdir_t, mkdir_time);
+	return err;
+
+out_err:
+//	clear_nlink(inode);
+	nova_err(sb, "%s return %d\n", __func__, err);
+	goto out;
+}
+
+/*
+ * routine to check that the specified directory is empty (for rmdir)
+ */
+static int nova_empty_dir(struct inode *inode)
+{
+	struct super_block *sb;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_dentry *entry;
+	struct nova_dentry *entryc, entry_copy;
+	unsigned long pos = 0;
+	struct nova_dentry *entries[4];
+	int nr_entries;
+	int i;
+
+	sb = inode->i_sb;
+	nr_entries = radix_tree_gang_lookup(&sih->tree,
+					(void **)entries, pos, 4);
+	if (nr_entries > 2)
+		return 0;
+
+	entryc = (metadata_csum == 0) ? entry : &entry_copy;
+
+	for (i = 0; i < nr_entries; i++) {
+		entry = entries[i];
+
+		if (metadata_csum == 0)
+			entryc = entry;
+		else if (!nova_verify_entry_csum(sb, entry, entryc))
+			return 0;
+
+		if (!is_dir_init_entry(sb, entryc))
+			return 0;
+	}
+
+	return 1;
+}
+
+static int nova_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	struct nova_dentry *de;
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode *pi = nova_get_inode(sb, inode), *pidir;
+	struct nova_inode_update update_dir;
+	struct nova_inode_update update;
+	u64 old_linkc = 0;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	int err = -ENOTEMPTY;
+	u64 epoch_id;
+	timing_t rmdir_time;
+
+	NOVA_START_TIMING(rmdir_t, rmdir_time);
+	if (!inode)
+		return -ENOENT;
+
+	nova_dbgv("%s: name %s\n", __func__, dentry->d_name.name);
+	pidir = nova_get_inode(sb, dir);
+	if (!pidir)
+		return -EINVAL;
+
+	if (nova_inode_by_name(dir, &dentry->d_name, &de) == 0)
+		return -ENOENT;
+
+	if (!nova_empty_dir(inode))
+		return err;
+
+	nova_dbgv("%s: inode %lu, dir %lu, link %d\n", __func__,
+				inode->i_ino, dir->i_ino, dir->i_nlink);
+
+	if (inode->i_nlink != 2)
+		nova_dbg("empty directory %lu has nlink!=2 (%d), dir %lu",
+				inode->i_ino, inode->i_nlink, dir->i_ino);
+
+	epoch_id = nova_get_epoch_id(sb);
+
+	update_dir.tail = 0;
+	update_dir.alter_tail = 0;
+	err = nova_remove_dentry(dentry, -1, &update_dir, epoch_id);
+	if (err)
+		goto end_rmdir;
+
+	/*inode->i_version++; */
+	clear_nlink(inode);
+	inode->i_ctime = dir->i_ctime;
+
+	if (dir->i_nlink)
+		drop_nlink(dir);
+
+	nova_delete_dir_tree(sb, sih);
+
+	update.tail = 0;
+	update.alter_tail = 0;
+	err = nova_append_link_change_entry(sb, pi, inode, &update,
+						&old_linkc, epoch_id);
+	if (err)
+		goto end_rmdir;
+
+	nova_lite_transaction_for_time_and_link(sb, pi, pidir, inode, dir,
+					&update, &update_dir, 1, epoch_id);
+
+	nova_invalidate_link_change_entry(sb, old_linkc);
+	nova_invalidate_dentries(sb, &update_dir);
+
+	NOVA_END_TIMING(rmdir_t, rmdir_time);
+	return err;
+
+end_rmdir:
+	nova_err(sb, "%s return %d\n", __func__, err);
+	NOVA_END_TIMING(rmdir_t, rmdir_time);
+	return err;
+}
+
+static int nova_rename(struct inode *old_dir,
+			struct dentry *old_dentry,
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
+{
+	struct inode *old_inode = old_dentry->d_inode;
+	struct inode *new_inode = new_dentry->d_inode;
+	struct super_block *sb = old_inode->i_sb;
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode *old_pi = NULL, *new_pi = NULL;
+	struct nova_inode *new_pidir = NULL, *old_pidir = NULL;
+	struct nova_dentry *father_entry = NULL;
+	struct nova_dentry *father_entryc, entry_copy;
+	char *head_addr = NULL;
+	int invalidate_new_inode = 0;
+	struct nova_inode_update update_dir_new;
+	struct nova_inode_update update_dir_old;
+	struct nova_inode_update update_new;
+	struct nova_inode_update update_old;
+	u64 old_linkc1 = 0, old_linkc2 = 0;
+	int err = -ENOENT;
+	int inc_link = 0, dec_link = 0;
+	int cpu;
+	int change_parent = 0;
+	u64 journal_tail;
+	u64 epoch_id;
+	timing_t rename_time;
+
+	nova_dbgv("%s: rename %s to %s,\n", __func__,
+			old_dentry->d_name.name, new_dentry->d_name.name);
+	nova_dbgv("%s: %s inode %lu, old dir %lu, new dir %lu, new inode %lu\n",
+			__func__, S_ISDIR(old_inode->i_mode) ? "dir" : "normal",
+			old_inode->i_ino, old_dir->i_ino, new_dir->i_ino,
+			new_inode ? new_inode->i_ino : 0);
+
+	if (flags & ~RENAME_NOREPLACE)
+		return -EINVAL;
+
+	NOVA_START_TIMING(rename_t, rename_time);
+
+	if (new_inode) {
+		err = -ENOTEMPTY;
+		if (S_ISDIR(old_inode->i_mode) && !nova_empty_dir(new_inode))
+			goto out;
+	} else {
+		if (S_ISDIR(old_inode->i_mode)) {
+			err = -EMLINK;
+			if (new_dir->i_nlink >= NOVA_LINK_MAX)
+				goto out;
+		}
+	}
+
+	if (S_ISDIR(old_inode->i_mode)) {
+		dec_link = -1;
+		if (!new_inode)
+			inc_link = 1;
+		/*
+		 * Tricky for in-place update:
+		 * New dentry is always after renamed dentry, so we have to
+		 * make sure new dentry has the correct links count
+		 * to workaround the rebuild nlink issue.
+		 */
+		if (old_dir == new_dir) {
+			inc_link--;
+			if (inc_link == 0)
+				dec_link = 0;
+		}
+	}
+
+	epoch_id = nova_get_epoch_id(sb);
+	new_pidir = nova_get_inode(sb, new_dir);
+	old_pidir = nova_get_inode(sb, old_dir);
+
+	old_pi = nova_get_inode(sb, old_inode);
+	old_inode->i_ctime = current_time(old_inode);
+	update_old.tail = 0;
+	update_old.alter_tail = 0;
+	err = nova_append_link_change_entry(sb, old_pi, old_inode,
+					&update_old, &old_linkc1, epoch_id);
+	if (err)
+		goto out;
+
+	if (S_ISDIR(old_inode->i_mode) && old_dir != new_dir) {
+		/* My father is changed. Update .. entry */
+		/* For simplicity, we use in-place update and journal it */
+		change_parent = 1;
+		head_addr = (char *)nova_get_block(sb, old_pi->log_head);
+		father_entry = (struct nova_dentry *)(head_addr +
+					NOVA_DIR_LOG_REC_LEN(1));
+
+		if (metadata_csum == 0)
+			father_entryc = father_entry;
+		else {
+			father_entryc = &entry_copy;
+			if (!nova_verify_entry_csum(sb, father_entry,
+							father_entryc)) {
+				err = -EIO;
+				goto out;
+			}
+		}
+
+		if (le64_to_cpu(father_entryc->ino) != old_dir->i_ino)
+			nova_err(sb, "%s: dir %lu parent should be %lu, but actually %lu\n",
+				__func__,
+				old_inode->i_ino, old_dir->i_ino,
+				le64_to_cpu(father_entry->ino));
+	}
+
+	update_dir_new.tail = 0;
+	update_dir_new.alter_tail = 0;
+	if (new_inode) {
+		/* First remove the old entry in the new directory */
+		err = nova_remove_dentry(new_dentry, 0, &update_dir_new,
+					epoch_id);
+		if (err)
+			goto out;
+	}
+
+	/* link into the new directory. */
+	err = nova_add_dentry(new_dentry, old_inode->i_ino,
+				inc_link, &update_dir_new, epoch_id);
+	if (err)
+		goto out;
+
+	if (inc_link > 0)
+		inc_nlink(new_dir);
+
+	update_dir_old.tail = 0;
+	update_dir_old.alter_tail = 0;
+	if (old_dir == new_dir) {
+		update_dir_old.tail = update_dir_new.tail;
+		update_dir_old.alter_tail = update_dir_new.alter_tail;
+	}
+
+	err = nova_remove_dentry(old_dentry, dec_link, &update_dir_old,
+					epoch_id);
+	if (err)
+		goto out;
+
+	if (dec_link < 0)
+		drop_nlink(old_dir);
+
+	if (new_inode) {
+		new_pi = nova_get_inode(sb, new_inode);
+		new_inode->i_ctime = current_time(new_inode);
+
+		if (S_ISDIR(old_inode->i_mode)) {
+			if (new_inode->i_nlink)
+				drop_nlink(new_inode);
+		}
+		if (new_inode->i_nlink)
+			drop_nlink(new_inode);
+
+		update_new.tail = 0;
+		update_new.alter_tail = 0;
+		err = nova_append_link_change_entry(sb, new_pi, new_inode,
+						&update_new, &old_linkc2,
+						epoch_id);
+		if (err)
+			goto out;
+	}
+
+	cpu = smp_processor_id();
+	spin_lock(&sbi->journal_locks[cpu]);
+	nova_memunlock_journal(sb);
+	if (new_inode && new_inode->i_nlink == 0)
+		invalidate_new_inode = 1;
+	journal_tail = nova_create_rename_transaction(sb, old_inode, old_dir,
+				new_inode,
+				old_dir != new_dir ? new_dir : NULL,
+				father_entry,
+				invalidate_new_inode,
+				cpu);
+
+	nova_update_inode(sb, old_inode, old_pi, &update_old, 0);
+	nova_update_inode(sb, old_dir, old_pidir, &update_dir_old, 0);
+
+	if (old_pidir != new_pidir)
+		nova_update_inode(sb, new_dir, new_pidir, &update_dir_new, 0);
+
+	if (change_parent && father_entry) {
+		father_entry->ino = cpu_to_le64(new_dir->i_ino);
+		nova_update_entry_csum(father_entry);
+		nova_update_alter_entry(sb, father_entry);
+	}
+
+	if (new_inode) {
+		if (invalidate_new_inode) {
+			new_pi->valid = 0;
+			new_pi->delete_epoch_id = epoch_id;
+		}
+		nova_update_inode(sb, new_inode, new_pi, &update_new, 0);
+	}
+
+	PERSISTENT_BARRIER();
+
+	nova_commit_lite_transaction(sb, journal_tail, cpu);
+	nova_memlock_journal(sb);
+	spin_unlock(&sbi->journal_locks[cpu]);
+
+	nova_memunlock_inode(sb, old_pi);
+	nova_update_alter_inode(sb, old_inode, old_pi);
+	nova_update_alter_inode(sb, old_dir, old_pidir);
+	if (old_dir != new_dir)
+		nova_update_alter_inode(sb, new_dir, new_pidir);
+	if (new_inode)
+		nova_update_alter_inode(sb, new_inode, new_pi);
+	nova_memlock_inode(sb, old_pi);
+
+	nova_invalidate_link_change_entry(sb, old_linkc1);
+	nova_invalidate_link_change_entry(sb, old_linkc2);
+	if (new_inode)
+		nova_invalidate_dentries(sb, &update_dir_new);
+	nova_invalidate_dentries(sb, &update_dir_old);
+
+	NOVA_END_TIMING(rename_t, rename_time);
+	return 0;
+out:
+	nova_err(sb, "%s return %d\n", __func__, err);
+	NOVA_END_TIMING(rename_t, rename_time);
+	return err;
+}
+
+struct dentry *nova_get_parent(struct dentry *child)
+{
+	struct inode *inode;
+	struct qstr dotdot = QSTR_INIT("..", 2);
+	struct nova_dentry *de = NULL;
+	ino_t ino;
+
+	nova_inode_by_name(child->d_inode, &dotdot, &de);
+	if (!de)
+		return ERR_PTR(-ENOENT);
+
+	/* FIXME: can de->ino be avoided by using the return value of
+	 * nova_inode_by_name()?
+	 */
+	ino = le64_to_cpu(de->ino);
+
+	if (ino)
+		inode = nova_iget(child->d_inode->i_sb, ino);
+	else
+		return ERR_PTR(-ENOENT);
+
+	return d_obtain_alias(inode);
+}
+
+const struct inode_operations nova_dir_inode_operations = {
+	.create		= nova_create,
+	.lookup		= nova_lookup,
+	.link		= nova_link,
+	.unlink		= nova_unlink,
+	.symlink	= nova_symlink,
+	.mkdir		= nova_mkdir,
+	.rmdir		= nova_rmdir,
+	.mknod		= nova_mknod,
+	.rename		= nova_rename,
+	.setattr	= nova_notify_change,
+	.get_acl	= NULL,
+};
+
+const struct inode_operations nova_special_inode_operations = {
+	.setattr	= nova_notify_change,
+	.get_acl	= NULL,
+};
diff --git a/fs/nova/symlink.c b/fs/nova/symlink.c
new file mode 100644
index 000000000000..b0e5e898a41b
--- /dev/null
+++ b/fs/nova/symlink.c
@@ -0,0 +1,153 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Symlink operations
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ * Copyright 2012-2013 Intel Corporation
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/version.h>
+#include "nova.h"
+#include "inode.h"
+
+int nova_block_symlink(struct super_block *sb, struct nova_inode *pi,
+	struct inode *inode, const char *symname, int len, u64 epoch_id)
+{
+	struct nova_file_write_entry entry_data;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_inode_update update;
+	unsigned long name_blocknr = 0;
+	int allocated;
+	u64 block;
+	char *blockp;
+	u32 time;
+	int ret;
+
+	update.tail = sih->log_tail;
+	update.alter_tail = sih->alter_log_tail;
+
+	allocated = nova_new_data_blocks(sb, sih, &name_blocknr, 0, 1,
+				 ALLOC_INIT_ZERO, ANY_CPU, ALLOC_FROM_TAIL);
+	if (allocated != 1 || name_blocknr == 0) {
+		ret = allocated;
+		return ret;
+	}
+
+	/* First copy name to name block */
+	block = nova_get_block_off(sb, name_blocknr, NOVA_BLOCK_TYPE_4K);
+	blockp = (char *)nova_get_block(sb, block);
+
+	nova_memunlock_block(sb, blockp);
+	memcpy_to_pmem_nocache(blockp, symname, len);
+	blockp[len] = '\0';
+	nova_memlock_block(sb, blockp);
+
+	/* Apply a write entry to the log page */
+	time = current_time(inode).tv_sec;
+	nova_init_file_write_entry(sb, sih, &entry_data, epoch_id, 0, 1,
+					name_blocknr, time, len + 1);
+
+	ret = nova_append_file_write_entry(sb, pi, inode, &entry_data, &update);
+	if (ret) {
+		nova_dbg("%s: append file write entry failed %d\n",
+					__func__, ret);
+		nova_free_data_blocks(sb, sih, name_blocknr, 1);
+		return ret;
+	}
+
+	nova_memunlock_inode(sb, pi);
+	nova_update_inode(sb, inode, pi, &update, 1);
+	nova_memlock_inode(sb, pi);
+	sih->trans_id++;
+
+	return 0;
+}
+
+/* FIXME: Temporary workaround */
+static int nova_readlink_copy(char __user *buffer, int buflen, const char *link)
+{
+	int len = PTR_ERR(link);
+
+	if (IS_ERR(link))
+		goto out;
+
+	len = strlen(link);
+	if (len > (unsigned int) buflen)
+		len = buflen;
+	if (copy_to_user(buffer, link, len))
+		len = -EFAULT;
+out:
+	return len;
+}
+
+static int nova_readlink(struct dentry *dentry, char __user *buffer, int buflen)
+{
+	struct nova_file_write_entry *entry;
+	struct nova_file_write_entry *entryc, entry_copy;
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	char *blockp;
+
+	entry = (struct nova_file_write_entry *)nova_get_block(sb,
+							sih->log_head);
+
+	if (metadata_csum == 0)
+		entryc = entry;
+	else {
+		entryc = &entry_copy;
+		if (!nova_verify_entry_csum(sb, entry, entryc))
+			return -EIO;
+	}
+
+	blockp = (char *)nova_get_block(sb, BLOCK_OFF(entryc->block));
+
+	return nova_readlink_copy(buffer, buflen, blockp);
+}
+
+static const char *nova_get_link(struct dentry *dentry, struct inode *inode,
+	struct delayed_call *done)
+{
+	struct nova_file_write_entry *entry;
+	struct nova_file_write_entry *entryc, entry_copy;
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	char *blockp;
+
+	entry = (struct nova_file_write_entry *)nova_get_block(sb,
+							sih->log_head);
+	if (metadata_csum == 0)
+		entryc = entry;
+	else {
+		entryc = &entry_copy;
+		if (!nova_verify_entry_csum(sb, entry, entryc))
+			return NULL;
+	}
+
+	blockp = (char *)nova_get_block(sb, BLOCK_OFF(entryc->block));
+
+	return blockp;
+}
+
+const struct inode_operations nova_symlink_inode_operations = {
+	.readlink	= nova_readlink,
+	.get_link	= nova_get_link,
+	.setattr	= nova_notify_change,
+};

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
