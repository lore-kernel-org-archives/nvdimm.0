Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 775261A1E43
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 12:42:41 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 1/3] radix-tree: 'slot' can be NULL in
 radix_tree_next_slot()
Date: Mon, 15 Aug 2016 13:42:35 -0600
Message-Id: <20160815194237.25967-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20160815194237.25967-1-ross.zwisler@linux.intel.com>
References: <20160815194237.25967-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Konstantin Khlebnikov <koct9i@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <linux-nvdimm@lists.01.org>

There are four cases I can see where we could end up with a NULL 'slot' in
radix_tree_next_slot().  Yet radix_tree_next_slot() never actually checks
whether 'slot' is NULL.  It just happens that for the cases where 'slot' is
NULL, some other combination of factors prevents us from dereferencing it.

It would be very easy for someone to unwittingly change one of these
factors without realizing that we are implicitly depending on it to save us
from a NULL pointer dereference.

Add a comment documenting the things that allow 'slot' to be safely passed
as NULL to radix_tree_next_slot().

Here are details on the four cases:

1) radix_tree_iter_retry() via a non-tagged iteration like
radix_tree_for_each_slot().  In this case we currently aren't seeing a bug
because radix_tree_iter_retry() sets

	iter->next_index = iter->index;

which means that in in the else case in radix_tree_next_slot(), 'count' is
zero, so we skip over the while() loop and effectively just return NULL
without ever dereferencing 'slot'.

2) radix_tree_iter_retry() via tagged iteration like
radix_tree_for_each_tagged().  This case was giving us NULL pointer
dereferences in testing, and was fixed with this commit:

commit 3cb9185c6730 ("radix-tree: fix radix_tree_iter_retry() for tagged
iterators.")

This fix doesn't explicitly check for 'slot' being NULL, though, it works
around the NULL pointer dereference by instead zeroing iter->tags in
radix_tree_iter_retry(), which makes us bail out of the if() case in
radix_tree_next_slot() before we dereference 'slot'.

3) radix_tree_iter_next() via via a non-tagged iteration like
radix_tree_for_each_slot().  This currently happens in shmem_tag_pins()
and shmem_partial_swap_usage().

As with non-tagged iteration, 'count' in the else case of
radix_tree_next_slot() is zero, so we skip over the while() loop and
effectively just return NULL without ever dereferencing 'slot'.

4) radix_tree_iter_next() via tagged iteration like
radix_tree_for_each_tagged().  This happens in shmem_wait_for_pins().

radix_tree_iter_next() zeros out iter->tags, so we end up exiting
radix_tree_next_slot() here:

	if (flags & RADIX_TREE_ITER_TAGGED) {
		void *canon = slot;

		iter->tags >>= 1;
		if (unlikely(!iter->tags))
			return NULL;

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 include/linux/radix-tree.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index 4c45105..4613bf3 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -461,6 +461,14 @@ static inline struct radix_tree_node *entry_to_node(void *ptr)
  *
  * This function updates @iter->index in the case of a successful lookup.
  * For tagged lookup it also eats @iter->tags.
+ *
+ * There are several cases where 'slot' can be passed in as NULL to this
+ * function.  These cases result from the use of radix_tree_iter_next() or
+ * radix_tree_iter_retry().  In these cases we don't end up dereferencing
+ * 'slot' because either:
+ * a) we are doing tagged iteration and iter->tags has been set to 0, or
+ * b) we are doing non-tagged iteration, and iter->index and iter->next_index
+ *    have been set up so that radix_tree_chunk_size() returns 1 or 0.
  */
 static __always_inline void **
 radix_tree_next_slot(void **slot, struct radix_tree_iter *iter, unsigned flags)
-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
