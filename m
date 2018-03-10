Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x244.google.com (mail-pl0-x244.google.com
 [IPv6:2607:f8b0:400e:c01::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 813502258AEF8
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:14 -0800 (PST)
Received: by mail-pl0-x244.google.com with SMTP id m22-v6so7032124pls.5
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:33 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 14/83] Add range node kmem cache.
Date: Sat, 10 Mar 2018 10:17:55 -0800
Message-Id: <1520705944-6723-15-git-send-email-jix024@eng.ucsd.edu>
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

Range node specifies a range of [start, end]. and is managed by a red-black tree.
NOVA uses range node to manage NVM allocator and inodes being used.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/nova.h  |  8 ++++++++
 fs/nova/super.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 fs/nova/super.h |  2 ++
 3 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index ba7ffca..e0e85fb 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -301,6 +301,14 @@ static inline u64 nova_get_epoch_id(struct super_block *sb)
 }
 
 #include "inode.h"
+
+/* A node in the RB tree representing a range of pages */
+struct nova_range_node {
+	struct rb_node node;
+	unsigned long range_low;
+	unsigned long range_high;
+};
+
 #include "bbuild.h"
 
 /* ====================================================== */
diff --git a/fs/nova/super.c b/fs/nova/super.c
index f41cc04..aec1cd3 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -52,6 +52,7 @@ MODULE_PARM_DESC(nova_dbgmask, "Control debugging output");
 static struct super_operations nova_sops;
 
 static struct kmem_cache *nova_inode_cachep;
+static struct kmem_cache *nova_range_node_cachep;
 
 
 /* FIXME: should the following variable be one per NOVA instance? */
@@ -686,6 +687,20 @@ static void nova_put_super(struct super_block *sb)
 	sb->s_fs_info = NULL;
 }
 
+inline void nova_free_range_node(struct nova_range_node *node)
+{
+	kmem_cache_free(nova_range_node_cachep, node);
+}
+
+inline struct nova_range_node *nova_alloc_range_node(struct super_block *sb)
+{
+	struct nova_range_node *p;
+
+	p = (struct nova_range_node *)
+		kmem_cache_zalloc(nova_range_node_cachep, GFP_NOFS);
+	return p;
+}
+
 static struct inode *nova_alloc_inode(struct super_block *sb)
 {
 	struct nova_inode_info *vi;
@@ -719,6 +734,17 @@ static void init_once(void *foo)
 	inode_init_once(&vi->vfs_inode);
 }
 
+static int __init init_rangenode_cache(void)
+{
+	nova_range_node_cachep = kmem_cache_create("nova_range_node_cache",
+					sizeof(struct nova_range_node),
+					0, (SLAB_RECLAIM_ACCOUNT |
+					SLAB_MEM_SPREAD), NULL);
+	if (nova_range_node_cachep == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
 static int __init init_inodecache(void)
 {
 	nova_inode_cachep = kmem_cache_create("nova_inode_cache",
@@ -740,6 +766,11 @@ static void destroy_inodecache(void)
 	kmem_cache_destroy(nova_inode_cachep);
 }
 
+static void destroy_rangenode_cache(void)
+{
+	kmem_cache_destroy(nova_range_node_cachep);
+}
+
 
 /*
  * the super block writes are all done "on the fly", so the
@@ -781,20 +812,27 @@ static int __init init_nova_fs(void)
 	nova_info("Arch new instructions support: CLWB %s\n",
 			support_clwb ? "YES" : "NO");
 
-	rc = init_inodecache();
+	rc = init_rangenode_cache();
 	if (rc)
 		goto out;
 
-	rc = register_filesystem(&nova_fs_type);
+	rc = init_inodecache();
 	if (rc)
 		goto out1;
 
+	rc = register_filesystem(&nova_fs_type);
+	if (rc)
+		goto out2;
+
 out:
 	NOVA_END_TIMING(init_t, init_time);
 	return rc;
 
-out1:
+out2:
 	destroy_inodecache();
+
+out1:
+	destroy_rangenode_cache();
 	goto out;
 }
 
@@ -802,6 +840,7 @@ static void __exit exit_nova_fs(void)
 {
 	unregister_filesystem(&nova_fs_type);
 	destroy_inodecache();
+	destroy_rangenode_cache();
 }
 
 MODULE_AUTHOR("Andiry Xu <jix024@cs.ucsd.edu>");
diff --git a/fs/nova/super.h b/fs/nova/super.h
index cb53908..b478080 100644
--- a/fs/nova/super.h
+++ b/fs/nova/super.h
@@ -145,5 +145,7 @@ static inline struct nova_super_block *nova_get_super(struct super_block *sb)
 }
 
 extern void nova_error_mng(struct super_block *sb, const char *fmt, ...);
+extern struct nova_range_node *nova_alloc_range_node(struct super_block *sb);
+extern void nova_free_range_node(struct nova_range_node *node);
 
 #endif
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
