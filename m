Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x242.google.com (mail-pg0-x242.google.com
 [IPv6:2607:f8b0:400e:c05::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E1102263148B
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:58 -0800 (PST)
Received: by mail-pg0-x242.google.com with SMTP id g12so4844525pgs.0
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:16 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 50/83] Inode: Add nova_evict_inode.
Date: Sat, 10 Mar 2018 10:18:31 -0800
Message-Id: <1520705944-6723-51-git-send-email-jix024@eng.ucsd.edu>
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

If the inode still have links, release the DRAM resource (radix tree, etc).
Otherwise reclaim data pages and log pages.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/inode.c | 257 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/nova/inode.h |   5 ++
 fs/nova/log.h   |   7 ++
 fs/nova/super.c |   1 +
 4 files changed, 269 insertions(+), 1 deletion(-)

diff --git a/fs/nova/inode.c b/fs/nova/inode.c
index 41417e3..17addd3 100644
--- a/fs/nova/inode.c
+++ b/fs/nova/inode.c
@@ -457,7 +457,7 @@ static int nova_alloc_unused_inode(struct super_block *sb, int cpuid,
 	return 0;
 }
 
-int nova_free_inuse_inode(struct super_block *sb, unsigned long ino)
+static int nova_free_inuse_inode(struct super_block *sb, unsigned long ino)
 {
 	struct nova_sb_info *sbi = NOVA_SB(sb);
 	struct inode_map *inode_map;
@@ -532,6 +532,261 @@ int nova_free_inuse_inode(struct super_block *sb, unsigned long ino)
 	return ret;
 }
 
+static int nova_free_inode(struct super_block *sb, struct nova_inode *pi,
+	struct nova_inode_info_header *sih)
+{
+	int err = 0;
+	timing_t free_time;
+
+	NOVA_START_TIMING(free_inode_t, free_time);
+
+	nova_free_inode_log(sb, pi, sih);
+
+	sih->log_pages = 0;
+	sih->i_mode = 0;
+	sih->pi_addr = 0;
+	sih->i_size = 0;
+	sih->i_blocks = 0;
+
+	err = nova_free_inuse_inode(sb, pi->nova_ino);
+
+	NOVA_END_TIMING(free_inode_t, free_time);
+	return err;
+}
+
+/*
+ * We do not really rely on this last blocknr
+ * because blocks can be allocated beyond file end
+ */
+static unsigned long nova_get_last_blocknr(struct super_block *sb,
+	struct nova_inode_info_header *sih)
+{
+	struct nova_inode *pi, fake_pi;
+	unsigned long last_blocknr;
+	unsigned int btype;
+	unsigned int data_bits;
+	int ret;
+
+	ret = nova_get_reference(sb, sih->pi_addr, &fake_pi,
+			(void **)&pi, sizeof(struct nova_inode));
+	if (ret) {
+		nova_dbg("%s: read pi @ 0x%lx failed\n",
+				__func__, sih->pi_addr);
+		btype = 0;
+	} else {
+		btype = sih->i_blk_type;
+	}
+
+	data_bits = blk_type_to_shift[btype];
+
+	if (sih->i_size == 0)
+		last_blocknr = 0;
+	else
+		last_blocknr = (sih->i_size - 1) >> data_bits;
+
+	return last_blocknr;
+}
+
+int nova_delete_file_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih, unsigned long start_blocknr,
+	unsigned long last_blocknr, bool delete_nvmm, bool delete_dead,
+	u64 epoch_id)
+{
+	struct nova_file_write_entry *entry;
+	struct nova_file_write_entry *old_entry = NULL;
+	unsigned long pgoff = start_blocknr;
+	unsigned long old_pgoff = 0;
+	unsigned int num_free = 0;
+	int freed = 0;
+	void *ret;
+	timing_t delete_time;
+
+	NOVA_START_TIMING(delete_file_tree_t, delete_time);
+
+	/* Handle EOF blocks */
+	do {
+		entry = radix_tree_lookup(&sih->tree, pgoff);
+		if (entry) {
+			ret = radix_tree_delete(&sih->tree, pgoff);
+			WARN_ON(!ret || ret != entry);
+			if (entry != old_entry) {
+				if (old_entry && delete_nvmm) {
+					nova_free_old_entry(sb, sih,
+							old_entry, old_pgoff,
+							num_free, delete_dead,
+							epoch_id);
+					freed += num_free;
+				}
+
+				old_entry = entry;
+				old_pgoff = pgoff;
+				num_free = 1;
+			} else {
+				num_free++;
+			}
+			pgoff++;
+		} else {
+			/* We are finding a hole. Jump to the next entry. */
+			entry = nova_find_next_entry(sb, sih, pgoff);
+			if (!entry)
+				break;
+
+			pgoff++;
+			pgoff = pgoff > entry->pgoff ? pgoff : entry->pgoff;
+		}
+	} while (1);
+
+	if (old_entry && delete_nvmm) {
+		nova_free_old_entry(sb, sih, old_entry, old_pgoff,
+					num_free, delete_dead, epoch_id);
+		freed += num_free;
+	}
+
+	nova_dbgv("Inode %lu: delete file tree from pgoff %lu to %lu, %d blocks freed\n",
+			sih->ino, start_blocknr, last_blocknr, freed);
+
+	NOVA_END_TIMING(delete_file_tree_t, delete_time);
+	return freed;
+}
+
+static int nova_free_dram_resource(struct super_block *sb,
+	struct nova_inode_info_header *sih)
+{
+	unsigned long last_blocknr;
+	int freed = 0;
+
+	if (sih->ino == 0)
+		return 0;
+
+	if (!(S_ISREG(sih->i_mode)) && !(S_ISDIR(sih->i_mode)))
+		return 0;
+
+	if (S_ISREG(sih->i_mode)) {
+		last_blocknr = nova_get_last_blocknr(sb, sih);
+		freed = nova_delete_file_tree(sb, sih, 0,
+					last_blocknr, false, false, 0);
+	} else {
+		nova_delete_dir_tree(sb, sih);
+		freed = 1;
+	}
+
+	return freed;
+}
+
+static int nova_free_inode_resource(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih)
+{
+	unsigned long last_blocknr;
+	int ret = 0;
+	int freed = 0;
+
+	pi->deleted = 1;
+
+	if (pi->valid) {
+		nova_dbg("%s: inode %lu still valid\n",
+				__func__, sih->ino);
+		pi->valid = 0;
+	}
+	nova_persist_inode(pi);
+
+	/* We need the log to free the blocks from the b-tree */
+	switch (__le16_to_cpu(pi->i_mode) & S_IFMT) {
+	case S_IFREG:
+		last_blocknr = nova_get_last_blocknr(sb, sih);
+		nova_dbgv("%s: file ino %lu\n", __func__, sih->ino);
+		freed = nova_delete_file_tree(sb, sih, 0,
+					last_blocknr, true, true, 0);
+		break;
+	case S_IFDIR:
+		nova_dbgv("%s: dir ino %lu\n", __func__, sih->ino);
+		nova_delete_dir_tree(sb, sih);
+		break;
+	case S_IFLNK:
+		/* Log will be freed later */
+		nova_dbgv("%s: symlink ino %lu\n",
+				__func__, sih->ino);
+		freed = nova_delete_file_tree(sb, sih, 0, 0,
+						true, true, 0);
+		break;
+	default:
+		nova_dbgv("%s: special ino %lu\n",
+				__func__, sih->ino);
+		break;
+	}
+
+	nova_dbg_verbose("%s: Freed %d\n", __func__, freed);
+	/* Then we can free the inode */
+	ret = nova_free_inode(sb, pi, sih);
+	if (ret)
+		nova_err(sb, "%s: free inode %lu failed\n",
+				__func__, sih->ino);
+
+	return ret;
+}
+
+void nova_evict_inode(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode *pi = nova_get_inode(sb, inode);
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	timing_t evict_time;
+	int destroy = 0;
+	int ret;
+
+	NOVA_START_TIMING(evict_inode_t, evict_time);
+	if (!sih) {
+		nova_err(sb, "%s: ino %lu sih is NULL!\n",
+				__func__, inode->i_ino);
+		NOVA_ASSERT(0);
+		goto out;
+	}
+
+	// pi can be NULL if the file has already been deleted, but a handle
+	// remains.
+	if (pi && pi->nova_ino != inode->i_ino) {
+		nova_err(sb, "%s: inode %lu ino does not match: %llu\n",
+				__func__, inode->i_ino, pi->nova_ino);
+		nova_dbg("inode size %llu, pi addr 0x%lx, pi head 0x%llx, tail 0x%llx, mode %u\n",
+				inode->i_size, sih->pi_addr, sih->log_head,
+				sih->log_tail, pi->i_mode);
+		nova_dbg("sih: ino %lu, inode size %lu, mode %u, inode mode %u\n",
+				sih->ino, sih->i_size,
+				sih->i_mode, inode->i_mode);
+		nova_print_inode_log(sb, inode);
+	}
+
+	nova_dbg_verbose("%s: %lu\n", __func__, inode->i_ino);
+	if (!inode->i_nlink && !is_bad_inode(inode)) {
+		if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+			goto out;
+
+		if (pi) {
+			ret = nova_free_inode_resource(sb, pi, sih);
+			if (ret)
+				goto out;
+		}
+
+		destroy = 1;
+		pi = NULL; /* we no longer own the nova_inode */
+
+		inode->i_mtime = inode->i_ctime = current_time(inode);
+		inode->i_size = 0;
+	}
+out:
+	if (destroy == 0) {
+		nova_dbgv("%s: destroying %lu\n", __func__, inode->i_ino);
+		nova_free_dram_resource(sb, sih);
+	}
+	/* TODO: Since we don't use page-cache, do we really need the following
+	 * call?
+	 */
+	truncate_inode_pages(&inode->i_data, 0);
+
+	clear_inode(inode);
+	NOVA_END_TIMING(evict_inode_t, evict_time);
+}
+
 /* Returns 0 on failure */
 u64 nova_new_nova_inode(struct super_block *sb, u64 *pi_addr)
 {
diff --git a/fs/nova/inode.h b/fs/nova/inode.h
index 6970872..62c8bdc 100644
--- a/fs/nova/inode.h
+++ b/fs/nova/inode.h
@@ -245,6 +245,11 @@ u64 nova_new_nova_inode(struct super_block *sb, u64 *pi_addr);
 struct inode *nova_new_vfs_inode(enum nova_new_inode_type type,
 	struct inode *dir, u64 pi_addr, u64 ino, umode_t mode,
 	size_t size, dev_t rdev, const struct qstr *qstr, u64 epoch_id);
+int nova_delete_file_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih, unsigned long start_blocknr,
+	unsigned long last_blocknr, bool delete_nvmm, bool delete_dead,
+	u64 epoch_id);
+extern void nova_evict_inode(struct inode *inode);
 extern int nova_write_inode(struct inode *inode, struct writeback_control *wbc);
 extern void nova_dirty_inode(struct inode *inode, int flags);
 
diff --git a/fs/nova/log.h b/fs/nova/log.h
index f5149f7..87ce5f9 100644
--- a/fs/nova/log.h
+++ b/fs/nova/log.h
@@ -364,6 +364,13 @@ static inline int is_dir_init_entry(struct super_block *sb,
 }
 
 
+unsigned int nova_free_old_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih,
+	struct nova_file_write_entry *entry,
+	unsigned long pgoff, unsigned int num_free,
+	bool delete_dead, u64 epoch_id);
+struct nova_file_write_entry *nova_find_next_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih, pgoff_t pgoff);
 int nova_handle_setattr_operation(struct super_block *sb, struct inode *inode,
 	struct nova_inode *pi, unsigned int ia_valid, struct iattr *attr,
 	u64 epoch_id);
diff --git a/fs/nova/super.c b/fs/nova/super.c
index 1e67062..daf3270 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -884,6 +884,7 @@ static struct super_operations nova_sops = {
 	.destroy_inode	= nova_destroy_inode,
 	.write_inode	= nova_write_inode,
 	.dirty_inode	= nova_dirty_inode,
+	.evict_inode	= nova_evict_inode,
 	.put_super	= nova_put_super,
 	.statfs		= nova_statfs,
 	.remount_fs	= nova_remount,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
