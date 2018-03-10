Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x244.google.com (mail-pg0-x244.google.com
 [IPv6:2607:f8b0:400e:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 73A222258AEFC
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:09 -0800 (PST)
Received: by mail-pg0-x244.google.com with SMTP id l4so4831519pgp.11
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:28 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 10/83] Add superblock integrity check.
Date: Sat, 10 Mar 2018 10:17:51 -0800
Message-Id: <1520705944-6723-11-git-send-email-jix024@eng.ucsd.edu>
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

Repair broken primary superblock with redundant superblock.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/super.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/fs/nova/super.c b/fs/nova/super.c
index 552fe5d..e0e38ab 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -276,6 +276,21 @@ static bool nova_check_size(struct super_block *sb, unsigned long size)
 	return true;
 }
 
+static inline int nova_check_super_checksum(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	u32 crc = 0;
+
+	// Check CRC but skip c_sum, which is the 4 bytes at the beginning
+	crc = nova_crc32c(~0, (__u8 *)sbi->nova_sb + sizeof(__le32),
+			sizeof(struct nova_super_block) - sizeof(__le32));
+
+	if (sbi->nova_sb->s_sum == cpu_to_le32(crc))
+		return 0;
+	else
+		return 1;
+}
+
 static inline void nova_sync_super(struct super_block *sb)
 {
 	struct nova_sb_info *sbi = NOVA_SB(sb);
@@ -293,6 +308,34 @@ static inline void nova_sync_super(struct super_block *sb)
 	PERSISTENT_BARRIER();
 }
 
+/* Update checksum for the DRAM copy */
+static inline void nova_update_super_crc(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	u32 crc = 0;
+
+	sbi->nova_sb->s_wtime = cpu_to_le32(get_seconds());
+	sbi->nova_sb->s_sum = 0;
+	crc = nova_crc32c(~0, (__u8 *)sbi->nova_sb + sizeof(__le32),
+			sizeof(struct nova_super_block) - sizeof(__le32));
+	sbi->nova_sb->s_sum = cpu_to_le32(crc);
+}
+
+
+static inline void nova_update_mount_time(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	u64 mnt_write_time;
+
+	mnt_write_time = (get_seconds() & 0xFFFFFFFF);
+	mnt_write_time = mnt_write_time | (mnt_write_time << 32);
+
+	sbi->nova_sb->s_mtime = cpu_to_le64(mnt_write_time);
+	nova_update_super_crc(sb);
+
+	nova_sync_super(sb);
+}
+
 static struct nova_inode *nova_init(struct super_block *sb,
 				      unsigned long size)
 {
@@ -328,6 +371,7 @@ static struct nova_inode *nova_init(struct super_block *sb,
 	sbi->nova_sb->s_blocksize = cpu_to_le32(blocksize);
 	sbi->nova_sb->s_magic = cpu_to_le32(NOVA_SUPER_MAGIC);
 	sbi->nova_sb->s_epoch_id = 0;
+	nova_update_super_crc(sb);
 
 	nova_sync_super(sb);
 
@@ -369,6 +413,54 @@ static void nova_root_check(struct super_block *sb, struct nova_inode *root_pi)
 		nova_warn("root is not a directory!\n");
 }
 
+/* Check super block magic and checksum */
+static int nova_check_super(struct super_block *sb,
+	struct nova_super_block *ps)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	int rc;
+
+	rc = memcpy_mcsafe(sbi->nova_sb, ps,
+				sizeof(struct nova_super_block));
+
+	if (rc < 0)
+		return rc;
+
+	if (le32_to_cpu(sbi->nova_sb->s_magic) != NOVA_SUPER_MAGIC)
+		return -EIO;
+
+	if (nova_check_super_checksum(sb))
+		return -EIO;
+
+	return 0;
+}
+
+static int nova_check_integrity(struct super_block *sb)
+{
+	struct nova_super_block *super = nova_get_super(sb);
+	struct nova_super_block *super_redund;
+	int rc;
+
+	super_redund = nova_get_redund_super(sb);
+
+	/* Do sanity checks on the superblock */
+	rc = nova_check_super(sb, super);
+	if (rc < 0) {
+		rc = nova_check_super(sb, super_redund);
+		if (rc < 0) {
+			nova_err(sb, "Can't find a valid nova partition\n");
+			return rc;
+		} else {
+			nova_warn("Error in super block: try to repair it with the other copy\n");
+			memcpy_to_pmem_nocache((void *)super, (void *)super_redund,
+					sizeof(struct nova_super_block));
+			PERSISTENT_BARRIER();
+		}
+	}
+
+	return 0;
+}
+
 static int nova_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct nova_sb_info *sbi = NULL;
@@ -446,6 +538,13 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 		goto setup_sb;
 	}
 
+	if (nova_check_integrity(sb) < 0) {
+		retval = -EINVAL;
+		nova_dbg("Memory contains invalid nova %x:%x\n",
+			le32_to_cpu(sbi->nova_sb->s_magic), NOVA_SUPER_MAGIC);
+		goto out;
+	}
+
 	blocksize = le32_to_cpu(sbi->nova_sb->s_blocksize);
 	nova_set_blocksize(sb, blocksize);
 
@@ -482,6 +581,9 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 		goto out;
 	}
 
+	if (!(sb->s_flags & MS_RDONLY))
+		nova_update_mount_time(sb);
+
 	retval = 0;
 	return retval;
 
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
