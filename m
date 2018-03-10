Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x241.google.com (mail-pg0-x241.google.com
 [IPv6:2607:f8b0:400e:c05::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1954622603AF4
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:34 -0800 (PST)
Received: by mail-pg0-x241.google.com with SMTP id x2so695762pgo.9
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:52 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 30/83] New NOVA inode allocation.
Date: Sat, 10 Mar 2018 10:18:11 -0800
Message-Id: <1520705944-6723-31-git-send-email-jix024@eng.ucsd.edu>
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

Allocate the new inode in a round-robin way.
Extend the inode table if needed.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/inode.c | 40 ++++++++++++++++++++++++++++++++++++++++
 fs/nova/inode.h |  1 +
 2 files changed, 41 insertions(+)

diff --git a/fs/nova/inode.c b/fs/nova/inode.c
index 29d172a..e4b8960 100644
--- a/fs/nova/inode.c
+++ b/fs/nova/inode.c
@@ -489,6 +489,46 @@ int nova_free_inuse_inode(struct super_block *sb, unsigned long ino)
 	return ret;
 }
 
+/* Returns 0 on failure */
+u64 nova_new_nova_inode(struct super_block *sb, u64 *pi_addr)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct inode_map *inode_map;
+	unsigned long free_ino = 0;
+	int map_id;
+	u64 ino = 0;
+	int ret;
+	timing_t new_inode_time;
+
+	NOVA_START_TIMING(new_nova_inode_t, new_inode_time);
+	map_id = sbi->map_id;
+	sbi->map_id = (sbi->map_id + 1) % sbi->cpus;
+
+	inode_map = &sbi->inode_maps[map_id];
+
+	mutex_lock(&inode_map->inode_table_mutex);
+	ret = nova_alloc_unused_inode(sb, map_id, &free_ino);
+	if (ret) {
+		nova_dbg("%s: alloc inode number failed %d\n", __func__, ret);
+		mutex_unlock(&inode_map->inode_table_mutex);
+		return 0;
+	}
+
+	ret = nova_get_inode_address(sb, free_ino, pi_addr, 1);
+	if (ret) {
+		nova_dbg("%s: get inode address failed %d\n", __func__, ret);
+		mutex_unlock(&inode_map->inode_table_mutex);
+		return 0;
+	}
+
+	mutex_unlock(&inode_map->inode_table_mutex);
+
+	ino = free_ino;
+
+	NOVA_END_TIMING(new_nova_inode_t, new_inode_time);
+	return ino;
+}
+
 int nova_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	/* write_inode should never be called because we always keep our inodes
diff --git a/fs/nova/inode.h b/fs/nova/inode.h
index f9f5c14..fc1876c 100644
--- a/fs/nova/inode.h
+++ b/fs/nova/inode.h
@@ -229,6 +229,7 @@ int nova_get_inode_address(struct super_block *sb, u64 ino,
 struct inode *nova_iget(struct super_block *sb, unsigned long ino);
 inline int nova_insert_inodetree(struct nova_sb_info *sbi,
 	struct nova_range_node *new_node, int cpu);
+u64 nova_new_nova_inode(struct super_block *sb, u64 *pi_addr);
 extern int nova_write_inode(struct inode *inode, struct writeback_control *wbc);
 extern void nova_dirty_inode(struct inode *inode, int flags);
 
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
