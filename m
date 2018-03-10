Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x243.google.com (mail-pf0-x243.google.com
 [IPv6:2607:f8b0:400e:c00::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B926226462F8
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:17 -0800 (PST)
Received: by mail-pf0-x243.google.com with SMTP id a16so2614909pfn.9
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:36 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 66/83] Super: Add file write item cache.
Date: Sat, 10 Mar 2018 10:18:47 -0800
Message-Id: <1520705944-6723-67-git-send-email-jix024@eng.ucsd.edu>
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

nova_file_write_item combines a file write item with a list head.
NOVA uses a linked list of file write items to describe a write operation.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/super.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 fs/nova/super.h |  3 +++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/fs/nova/super.c b/fs/nova/super.c
index 0847e57..9710be8 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -55,6 +55,7 @@ static const struct export_operations nova_export_ops;
 
 static struct kmem_cache *nova_inode_cachep;
 static struct kmem_cache *nova_range_node_cachep;
+static struct kmem_cache *nova_file_write_item_cachep;
 
 
 /* FIXME: should the following variable be one per NOVA instance? */
@@ -791,6 +792,21 @@ inline void nova_free_inode_node(struct super_block *sb,
 	nova_free_range_node(node);
 }
 
+inline void nova_free_file_write_item(struct nova_file_write_item *item)
+{
+	kmem_cache_free(nova_file_write_item_cachep, item);
+}
+
+inline struct nova_file_write_item *
+nova_alloc_file_write_item(struct super_block *sb)
+{
+	struct nova_file_write_item *p;
+
+	p = (struct nova_file_write_item *)
+		kmem_cache_alloc(nova_file_write_item_cachep, GFP_NOFS);
+	return p;
+}
+
 inline struct nova_range_node *nova_alloc_range_node(struct super_block *sb)
 {
 	struct nova_range_node *p;
@@ -849,6 +865,18 @@ static int __init init_rangenode_cache(void)
 	return 0;
 }
 
+static int __init init_file_write_item_cache(void)
+{
+	nova_file_write_item_cachep = kmem_cache_create(
+					"nova_file_write_item_cache",
+					sizeof(struct nova_file_write_item),
+					0, (SLAB_RECLAIM_ACCOUNT |
+					SLAB_MEM_SPREAD), NULL);
+	if (nova_file_write_item_cachep == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
 static int __init init_inodecache(void)
 {
 	nova_inode_cachep = kmem_cache_create("nova_inode_cache",
@@ -875,6 +903,11 @@ static void destroy_rangenode_cache(void)
 	kmem_cache_destroy(nova_range_node_cachep);
 }
 
+static void destroy_file_write_item_cache(void)
+{
+	kmem_cache_destroy(nova_file_write_item_cachep);
+}
+
 
 /*
  * the super block writes are all done "on the fly", so the
@@ -974,14 +1007,21 @@ static int __init init_nova_fs(void)
 	if (rc)
 		goto out1;
 
-	rc = register_filesystem(&nova_fs_type);
+	rc = init_file_write_item_cache();
 	if (rc)
 		goto out2;
 
+	rc = register_filesystem(&nova_fs_type);
+	if (rc)
+		goto out3;
+
 out:
 	NOVA_END_TIMING(init_t, init_time);
 	return rc;
 
+out3:
+	destroy_file_write_item_cache();
+
 out2:
 	destroy_inodecache();
 
@@ -993,6 +1033,7 @@ static int __init init_nova_fs(void)
 static void __exit exit_nova_fs(void)
 {
 	unregister_filesystem(&nova_fs_type);
+	destroy_file_write_item_cache();
 	destroy_inodecache();
 	destroy_rangenode_cache();
 }
diff --git a/fs/nova/super.h b/fs/nova/super.h
index 56a840e..bcf9548 100644
--- a/fs/nova/super.h
+++ b/fs/nova/super.h
@@ -160,8 +160,11 @@ static inline struct nova_super_block *nova_get_super(struct super_block *sb)
 extern void nova_error_mng(struct super_block *sb, const char *fmt, ...);
 extern struct nova_range_node *nova_alloc_range_node(struct super_block *sb);
 extern inline struct nova_range_node *nova_alloc_inode_node(struct super_block *sb);
+extern struct nova_file_write_item *
+nova_alloc_file_write_item(struct super_block *sb);
 extern void nova_free_range_node(struct nova_range_node *node);
 extern inline void nova_free_inode_node(struct super_block *sb,
 	struct nova_range_node *node);
+void nova_free_file_write_item(struct nova_file_write_item *item);
 
 #endif
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
