Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 796CC203BEA4C
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 12:24:35 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/5] radix tree test suite: add item_delete_rcu()
Date: Thu,  3 May 2018 13:24:28 -0600
Message-Id: <20180503192430.7582-4-ross.zwisler@linux.intel.com>
In-Reply-To: <20180503192430.7582-1-ross.zwisler@linux.intel.com>
References: <20180503192430.7582-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Currently the lifetime of "struct item" entries in the radix tree are not
controlled by RCU, but are instead deleted inline as they are removed from
the tree.

In the following patches we add a test which has threads iterating over
items pulled from the tree and verifying them in an
rcu_read_lock()/rcu_read_unlock() section.  This means that though an item
has been removed from the tree it could still be being worked on by other
threads until the RCU grace period expires.  So, we need to actually free
the "struct item" structures at the end of the grace period, just as we do
with "struct radix_tree_node" items.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 tools/testing/radix-tree/test.c | 19 +++++++++++++++++++
 tools/testing/radix-tree/test.h |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/tools/testing/radix-tree/test.c b/tools/testing/radix-tree/test.c
index 5978ab1f403d..def6015570b2 100644
--- a/tools/testing/radix-tree/test.c
+++ b/tools/testing/radix-tree/test.c
@@ -75,6 +75,25 @@ int item_delete(struct radix_tree_root *root, unsigned long index)
 	return 0;
 }
 
+static void item_free_rcu(struct rcu_head *head)
+{
+	struct item *item = container_of(head, struct item, rcu_head);
+
+	free(item);
+}
+
+int item_delete_rcu(struct radix_tree_root *root, unsigned long index)
+{
+	struct item *item = radix_tree_delete(root, index);
+
+	if (item) {
+		item_sanity(item, index);
+		call_rcu(&item->rcu_head, item_free_rcu);
+		return 1;
+	}
+	return 0;
+}
+
 void item_check_present(struct radix_tree_root *root, unsigned long index)
 {
 	struct item *item;
diff --git a/tools/testing/radix-tree/test.h b/tools/testing/radix-tree/test.h
index d9c031dbeb1a..8cf4a7a7f94c 100644
--- a/tools/testing/radix-tree/test.h
+++ b/tools/testing/radix-tree/test.h
@@ -5,6 +5,7 @@
 #include <linux/rcupdate.h>
 
 struct item {
+	struct rcu_head	rcu_head;
 	unsigned long index;
 	unsigned int order;
 };
@@ -15,6 +16,7 @@ int item_insert(struct radix_tree_root *root, unsigned long index);
 int item_insert_order(struct radix_tree_root *root, unsigned long index,
 			unsigned order);
 int item_delete(struct radix_tree_root *root, unsigned long index);
+int item_delete_rcu(struct radix_tree_root *root, unsigned long index);
 struct item *item_lookup(struct radix_tree_root *root, unsigned long index);
 
 void item_check_present(struct radix_tree_root *root, unsigned long index);
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
