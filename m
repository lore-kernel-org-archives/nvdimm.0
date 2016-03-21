Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9CA431A1FC2
 for <linux-nvdimm@lists.01.org>; Mon, 21 Mar 2016 06:22:54 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 02/10] radix-tree: make 'indirect' bit available to exception
 entries.
Date: Mon, 21 Mar 2016 14:22:47 +0100
Message-Id: <1458566575-28063-3-git-send-email-jack@suse.cz>
In-Reply-To: <1458566575-28063-1-git-send-email-jack@suse.cz>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

From: NeilBrown <neilb@suse.com>

A pointer to a radix_tree_node will always have the 'exception'
bit cleared, so if the exception bit is set the value cannot
be an indirect pointer.  Thus it is safe to make the 'indirect bit'
available to store extra information in exception entries.

This patch adds a 'PTR_MASK' and a value is only treated as
an indirect (pointer) entry the 2 ls-bits are '01'.

The change in radix-tree.c ensures the stored value still looks like an
indirect pointer, and saves a load as well.

We could swap the two bits and so keep all the exectional bits contigious.
But I have other plans for that bit....

Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/radix-tree.h | 11 +++++++++--
 lib/radix-tree.c           |  2 +-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index d08d6ec3bf53..2bc8c5829441 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -41,8 +41,13 @@
  * Indirect pointer in fact is also used to tag the last pointer of a node
  * when it is shrunk, before we rcu free the node. See shrink code for
  * details.
+ *
+ * To allow an exception entry to only lose one bit, we ignore
+ * the INDIRECT bit when the exception bit is set.  So an entry is
+ * indirect if the least significant 2 bits are 01.
  */
 #define RADIX_TREE_INDIRECT_PTR		1
+#define RADIX_TREE_INDIRECT_MASK	3
 /*
  * A common use of the radix tree is to store pointers to struct pages;
  * but shmem/tmpfs needs also to store swap entries in the same tree:
@@ -54,7 +59,8 @@
 
 static inline int radix_tree_is_indirect_ptr(void *ptr)
 {
-	return (int)((unsigned long)ptr & RADIX_TREE_INDIRECT_PTR);
+	return ((unsigned long)ptr & RADIX_TREE_INDIRECT_MASK)
+		== RADIX_TREE_INDIRECT_PTR;
 }
 
 /*** radix-tree API starts here ***/
@@ -222,7 +228,8 @@ static inline void *radix_tree_deref_slot_protected(void **pslot,
  */
 static inline int radix_tree_deref_retry(void *arg)
 {
-	return unlikely((unsigned long)arg & RADIX_TREE_INDIRECT_PTR);
+	return unlikely(((unsigned long)arg & RADIX_TREE_INDIRECT_MASK)
+			== RADIX_TREE_INDIRECT_PTR);
 }
 
 /**
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 1624c4117961..c6af1a445b67 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1412,7 +1412,7 @@ static inline void radix_tree_shrink(struct radix_tree_root *root)
 		 * to force callers to retry.
 		 */
 		if (root->height == 0)
-			*((unsigned long *)&to_free->slots[0]) |=
+			*((unsigned long *)&to_free->slots[0]) =
 						RADIX_TREE_INDIRECT_PTR;
 
 		radix_tree_node_free(to_free);
-- 
2.6.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
