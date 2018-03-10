Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5DE5122603B11
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:35 -0800 (PST)
Received: by mail-pf0-x241.google.com with SMTP id u5so2617710pfh.6
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:54 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 31/83] Add new vfs inode allocation.
Date: Sat, 10 Mar 2018 10:18:12 -0800
Message-Id: <1520705944-6723-32-git-send-email-jix024@eng.ucsd.edu>
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

This routine allocates and initializes a new vfs inode, and setup
the attributes of corresponding NOVA inode and inode_info.
inode operations are missing now.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/inode.c | 144 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/nova/inode.h |   3 ++
 2 files changed, 146 insertions(+), 1 deletion(-)

diff --git a/fs/nova/inode.c b/fs/nova/inode.c
index e4b8960..15517cc 100644
--- a/fs/nova/inode.c
+++ b/fs/nova/inode.c
@@ -363,7 +363,49 @@ static inline int nova_search_inodetree(struct nova_sb_info *sbi,
 	return nova_find_range_node(sbi, tree, internal_ino, ret_node);
 }
 
-int nova_alloc_unused_inode(struct super_block *sb, int cpuid,
+static void nova_get_inode_flags(struct inode *inode, struct nova_inode *pi)
+{
+	unsigned int flags = inode->i_flags;
+	unsigned int nova_flags = le32_to_cpu(pi->i_flags);
+
+	nova_flags &= ~(FS_SYNC_FL | FS_APPEND_FL | FS_IMMUTABLE_FL |
+			 FS_NOATIME_FL | FS_DIRSYNC_FL);
+	if (flags & S_SYNC)
+		nova_flags |= FS_SYNC_FL;
+	if (flags & S_APPEND)
+		nova_flags |= FS_APPEND_FL;
+	if (flags & S_IMMUTABLE)
+		nova_flags |= FS_IMMUTABLE_FL;
+	if (flags & S_NOATIME)
+		nova_flags |= FS_NOATIME_FL;
+	if (flags & S_DIRSYNC)
+		nova_flags |= FS_DIRSYNC_FL;
+
+	pi->i_flags = cpu_to_le32(nova_flags);
+}
+
+static void nova_init_inode(struct inode *inode, struct nova_inode *pi)
+{
+	pi->i_mode = cpu_to_le16(inode->i_mode);
+	pi->i_uid = cpu_to_le32(i_uid_read(inode));
+	pi->i_gid = cpu_to_le32(i_gid_read(inode));
+	pi->i_links_count = cpu_to_le16(inode->i_nlink);
+	pi->i_size = cpu_to_le64(inode->i_size);
+	pi->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
+	pi->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
+	pi->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
+	pi->i_generation = cpu_to_le32(inode->i_generation);
+	pi->log_head = 0;
+	pi->log_tail = 0;
+	pi->deleted = 0;
+	pi->delete_epoch_id = 0;
+	nova_get_inode_flags(inode, pi);
+
+	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode))
+		pi->dev.rdev = cpu_to_le32(inode->i_rdev);
+}
+
+static int nova_alloc_unused_inode(struct super_block *sb, int cpuid,
 	unsigned long *ino)
 {
 	struct nova_sb_info *sbi = NOVA_SB(sb);
@@ -529,6 +571,106 @@ u64 nova_new_nova_inode(struct super_block *sb, u64 *pi_addr)
 	return ino;
 }
 
+struct inode *nova_new_vfs_inode(enum nova_new_inode_type type,
+	struct inode *dir, u64 pi_addr, u64 ino, umode_t mode,
+	size_t size, dev_t rdev, const struct qstr *qstr, u64 epoch_id)
+{
+	struct super_block *sb;
+	struct nova_sb_info *sbi;
+	struct inode *inode;
+	struct nova_inode *diri = NULL;
+	struct nova_inode_info *si;
+	struct nova_inode_info_header *sih = NULL;
+	struct nova_inode *pi;
+	int errval;
+	timing_t new_inode_time;
+
+	NOVA_START_TIMING(new_vfs_inode_t, new_inode_time);
+	sb = dir->i_sb;
+	sbi = (struct nova_sb_info *)sb->s_fs_info;
+	inode = new_inode(sb);
+	if (!inode) {
+		errval = -ENOMEM;
+		goto fail2;
+	}
+
+	inode_init_owner(inode, dir, mode);
+	inode->i_blocks = inode->i_size = 0;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
+
+	inode->i_generation = atomic_add_return(1, &sbi->next_generation);
+	inode->i_size = size;
+
+	diri = nova_get_inode(sb, dir);
+	if (!diri) {
+		errval = -EACCES;
+		goto fail1;
+	}
+
+	pi = (struct nova_inode *)nova_get_block(sb, pi_addr);
+	nova_dbg_verbose("%s: allocating inode %llu @ 0x%llx\n",
+					__func__, ino, pi_addr);
+
+	/* chosen inode is in ino */
+	inode->i_ino = ino;
+
+	switch (type) {
+	case TYPE_CREATE:
+		inode->i_mapping->a_ops = &nova_aops_dax;
+		break;
+	case TYPE_MKNOD:
+		init_special_inode(inode, mode, rdev);
+		break;
+	case TYPE_SYMLINK:
+		inode->i_mapping->a_ops = &nova_aops_dax;
+		break;
+	case TYPE_MKDIR:
+		inode->i_mapping->a_ops = &nova_aops_dax;
+		set_nlink(inode, 2);
+		break;
+	default:
+		nova_dbg("Unknown new inode type %d\n", type);
+		break;
+	}
+
+	/*
+	 * Pi is part of the dir log so no transaction is needed,
+	 * but we need to flush to NVMM.
+	 */
+	pi->i_blk_type = NOVA_DEFAULT_BLOCK_TYPE;
+	pi->i_flags = nova_mask_flags(mode, diri->i_flags);
+	pi->nova_ino = ino;
+	pi->i_create_time = current_time(inode).tv_sec;
+	pi->create_epoch_id = epoch_id;
+	nova_init_inode(inode, pi);
+
+	si = NOVA_I(inode);
+	sih = &si->header;
+	nova_init_header(sb, sih, inode->i_mode);
+	sih->pi_addr = pi_addr;
+	sih->ino = ino;
+	sih->i_blk_type = NOVA_DEFAULT_BLOCK_TYPE;
+
+	nova_set_inode_flags(inode, pi, le32_to_cpu(pi->i_flags));
+	sih->i_flags = le32_to_cpu(pi->i_flags);
+
+	if (insert_inode_locked(inode) < 0) {
+		nova_err(sb, "nova_new_inode failed ino %lx\n", inode->i_ino);
+		errval = -EINVAL;
+		goto fail1;
+	}
+
+	nova_flush_buffer(pi, NOVA_INODE_SIZE, 0);
+	NOVA_END_TIMING(new_vfs_inode_t, new_inode_time);
+	return inode;
+fail1:
+	make_bad_inode(inode);
+	iput(inode);
+fail2:
+	NOVA_END_TIMING(new_vfs_inode_t, new_inode_time);
+	return ERR_PTR(errval);
+}
+
 int nova_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	/* write_inode should never be called because we always keep our inodes
diff --git a/fs/nova/inode.h b/fs/nova/inode.h
index fc1876c..943f77f 100644
--- a/fs/nova/inode.h
+++ b/fs/nova/inode.h
@@ -230,6 +230,9 @@ struct inode *nova_iget(struct super_block *sb, unsigned long ino);
 inline int nova_insert_inodetree(struct nova_sb_info *sbi,
 	struct nova_range_node *new_node, int cpu);
 u64 nova_new_nova_inode(struct super_block *sb, u64 *pi_addr);
+struct inode *nova_new_vfs_inode(enum nova_new_inode_type type,
+	struct inode *dir, u64 pi_addr, u64 ino, umode_t mode,
+	size_t size, dev_t rdev, const struct qstr *qstr, u64 epoch_id);
 extern int nova_write_inode(struct inode *inode, struct writeback_control *wbc);
 extern void nova_dirty_inode(struct inode *inode, int flags);
 
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
