Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D76CB203BEA47
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 12:24:35 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 4/5] radix tree test suite: multi-order iteration race
Date: Thu,  3 May 2018 13:24:29 -0600
Message-Id: <20180503192430.7582-5-ross.zwisler@linux.intel.com>
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

Add a test which shows a race in the multi-order iteration code.  This test
reliably hits the race in under a second on my machine, and is the result
of a real bug report against kernel a production v4.15 based kernel
(4.15.6-300.fc27.x86_64).  With a real kernel this issue is hit when using
order 9 PMD DAX radix tree entries.

The race has to do with how we tear down multi-order sibling entries when
we are removing an item from the tree.  Remember that an order 2 entry
looks like this:

struct radix_tree_node.slots[] = [entry][sibling][sibling][sibling]

where 'entry' is in some slot in the struct radix_tree_node, and the three
slots following 'entry' contain sibling pointers which point back to
'entry.'

When we delete 'entry' from the tree, we call :
  radix_tree_delete()
    radix_tree_delete_item()
      __radix_tree_delete()
        replace_slot()

replace_slot() first removes the siblings in order from the first to the
last, then at then replaces 'entry' with NULL.  This means that for a brief
period of time we end up with one or more of the siblings removed, so:

struct radix_tree_node.slots[] = [entry][NULL][sibling][sibling]

This causes an issue if you have a reader iterating over the slots in the
tree via radix_tree_for_each_slot() while only under
rcu_read_lock()/rcu_read_unlock() protection.  This is a common case in
mm/filemap.c.

The issue is that when __radix_tree_next_slot() => skip_siblings() tries to
skip over the sibling entries in the slots, it currently does so with an
exact match on the slot directly preceding our current slot.  Normally this
works:
                                    V preceding slot
struct radix_tree_node.slots[] = [entry][sibling][sibling][sibling]
                                            ^ current slot

This lets you find the first sibling, and you skip them all in order.

But in the case where one of the siblings is NULL, that slot is skipped and
then our sibling detection is interrupted:

                                           V preceding slot
struct radix_tree_node.slots[] = [entry][NULL][sibling][sibling]
                                                  ^ current slot

This means that the sibling pointers aren't recognized since they point all
the way back to 'entry', so we think that they are normal internal radix
tree pointers.  This causes us to think we need to walk down to a struct
radix_tree_node starting at the address of 'entry'.

In a real running kernel this will crash the thread with a GP fault when
you try and dereference the slots in your broken node starting at 'entry'.

In the radix tree test suite this will be caught by the address sanitizer:

==27063==ERROR: AddressSanitizer: heap-buffer-overflow on address
0x60c0008ae400 at pc 0x00000040ce4f bp 0x7fa89b8fcad0 sp 0x7fa89b8fcac0
READ of size 8 at 0x60c0008ae400 thread T3
    #0 0x40ce4e in __radix_tree_next_slot /home/rzwisler/project/linux/tools/testing/radix-tree/radix-tree.c:1660
    #1 0x4022cc in radix_tree_next_slot linux/../../../../include/linux/radix-tree.h:567
    #2 0x4022cc in iterator_func /home/rzwisler/project/linux/tools/testing/radix-tree/multiorder.c:655
    #3 0x7fa8a088d50a in start_thread (/lib64/libpthread.so.0+0x750a)
    #4 0x7fa8a03bd16e in clone (/lib64/libc.so.6+0xf516e)

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 tools/testing/radix-tree/multiorder.c | 63 +++++++++++++++++++++++++++++++++++
 tools/testing/radix-tree/test.h       |  1 +
 2 files changed, 64 insertions(+)

diff --git a/tools/testing/radix-tree/multiorder.c b/tools/testing/radix-tree/multiorder.c
index 59245b3d587c..7bf405638b0b 100644
--- a/tools/testing/radix-tree/multiorder.c
+++ b/tools/testing/radix-tree/multiorder.c
@@ -16,6 +16,7 @@
 #include <linux/radix-tree.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
+#include <pthread.h>
 
 #include "test.h"
 
@@ -624,6 +625,67 @@ static void multiorder_account(void)
 	item_kill_tree(&tree);
 }
 
+bool stop_iteration = false;
+
+static void *creator_func(void *ptr)
+{
+	/* 'order' is set up to ensure we have sibling entries */
+	unsigned int order = RADIX_TREE_MAP_SHIFT - 1;
+	struct radix_tree_root *tree = ptr;
+	int i;
+
+	for (i = 0; i < 10000; i++) {
+		item_insert_order(tree, 0, order);
+		item_delete_rcu(tree, 0);
+	}
+
+	stop_iteration = true;
+	return NULL;
+}
+
+static void *iterator_func(void *ptr)
+{
+	struct radix_tree_root *tree = ptr;
+	struct radix_tree_iter iter;
+	struct item *item;
+	void **slot;
+
+	while (!stop_iteration) {
+		rcu_read_lock();
+		radix_tree_for_each_slot(slot, tree, &iter, 0) {
+			item = radix_tree_deref_slot(slot);
+
+			if (!item)
+				continue;
+			if (radix_tree_deref_retry(item)) {
+				slot = radix_tree_iter_retry(&iter);
+				continue;
+			}
+
+			item_sanity(item, iter.index);
+		}
+		rcu_read_unlock();
+	}
+	return NULL;
+}
+
+static void multiorder_iteration_race(void)
+{
+	const int num_threads = sysconf(_SC_NPROCESSORS_ONLN);
+	pthread_t worker_thread[num_threads];
+	RADIX_TREE(tree, GFP_KERNEL);
+	int i;
+
+	pthread_create(&worker_thread[0], NULL, &creator_func, &tree);
+	for (i = 1; i < num_threads; i++)
+		pthread_create(&worker_thread[i], NULL, &iterator_func, &tree);
+
+	for (i = 0; i < num_threads; i++)
+		pthread_join(worker_thread[i], NULL);
+
+	item_kill_tree(&tree);
+}
+
 void multiorder_checks(void)
 {
 	int i;
@@ -644,6 +706,7 @@ void multiorder_checks(void)
 	multiorder_join();
 	multiorder_split();
 	multiorder_account();
+	multiorder_iteration_race();
 
 	radix_tree_cpu_dead(0);
 }
diff --git a/tools/testing/radix-tree/test.h b/tools/testing/radix-tree/test.h
index 8cf4a7a7f94c..31f1d9b6f506 100644
--- a/tools/testing/radix-tree/test.h
+++ b/tools/testing/radix-tree/test.h
@@ -13,6 +13,7 @@ struct item {
 struct item *item_create(unsigned long index, unsigned int order);
 int __item_insert(struct radix_tree_root *root, struct item *item);
 int item_insert(struct radix_tree_root *root, unsigned long index);
+void item_sanity(struct item *item, unsigned long index);
 int item_insert_order(struct radix_tree_root *root, unsigned long index,
 			unsigned order);
 int item_delete(struct radix_tree_root *root, unsigned long index);
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
