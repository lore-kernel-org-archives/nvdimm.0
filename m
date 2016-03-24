Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 146471A1E2A
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 03:00:32 -0700 (PDT)
Date: Thu, 24 Mar 2016 06:00:54 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC v2] [PATCH 0/10] DAX page fault locking
Message-ID: <20160324100054.GA23915@linux.intel.com>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <20160321174103.GP23727@linux.intel.com>
 <20160323150939.GK4512@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160323150939.GK4512@quack.suse.cz>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, "Wilcox, Matthew R  <matthew.r.wilcox@intel.com>, NeilBrown <neilb@suse.com>, Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 23, 2016 at 04:09:39PM +0100, Jan Kara wrote:
> So when looking through the fixes I was wondering: Are really sibling
> entries worth it? Won't the result be simpler if we just used

I realised we could slightly simplify the pattern in each walker so they
don't have to explicitly care about sibling entries.  It ends up saving
64 bytes of text on my .config, so I think it's worth it:

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index f0f2f49..779025f 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -99,20 +99,19 @@ static inline unsigned get_sibling_offset(struct radix_tree_node *parent,
        return ptr - parent->slots;
 }
 
-static unsigned follow_sibling(struct radix_tree_node *parent,
+static unsigned rt_next_level(struct radix_tree_node *parent,
 				struct radix_tree_node **slot, unsigned offset)
 {
-	struct radix_tree_node *node = *slot;
-
-	if (!radix_tree_is_indirect_ptr(node))
-		return offset;
-
-	node = indirect_to_ptr(node);
-	if (!is_sibling_entry(parent, node))
-		return offset;
+	void **entry = rcu_dereference_raw(parent->slots[offset]);
+	if (radix_tree_is_indirect_ptr(entry)) {
+		uintptr_t siboff = entry - parent->slots;
+		if (siboff < RADIX_TREE_MAP_SIZE) {
+			offset = siboff;
+			entry = rcu_dereference_raw(parent->slots[offset]);
+		}
+	}
 
-	offset = (void **)node - parent->slots;
-	*slot = *(void **)node;
+	*slot = (void *)entry;
 	return offset;
 }
 
@@ -663,6 +662,8 @@ void *__radix_tree_lookup(struct radix_tree_root *root, unsigned long index,
 	shift = height * RADIX_TREE_MAP_SHIFT;
 
 	for (;;) {
+		unsigned offset;
+
 		if (!node)
 			return NULL;
 		if (node == RADIX_TREE_RETRY)
@@ -670,18 +671,14 @@ void *__radix_tree_lookup(struct radix_tree_root *root, unsigned long index,
 		if (!radix_tree_is_indirect_ptr(node))
 			break;
 		node = indirect_to_ptr(node);
-		if (is_sibling_entry(parent, node)) {
-			slot = (void **)node;
-			node = rcu_dereference_raw(*slot);
-			break;
-		}
 
 		BUG_ON(shift == 0);
 		shift -= RADIX_TREE_MAP_SHIFT;
 		BUG_ON(node->shift != shift);
 		parent = node;
-		slot = node->slots + ((index >> shift) & RADIX_TREE_MAP_MASK);
-		node = rcu_dereference_raw(*slot);
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		offset = rt_next_level(parent, &node, offset);
+		slot = parent->slots + offset;
 	}
 
 	if (nodep)
@@ -764,10 +761,9 @@ void *radix_tree_tag_set(struct radix_tree_root *root,
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 
 		slot = indirect_to_ptr(slot);
-		next = slot->slots[offset];
+		offset = rt_next_level(slot, &next, offset);
 		BUG_ON(!next);
 
-		offset = follow_sibling(slot, &next, offset);
 		if (!tag_get(slot, tag, offset))
 			tag_set(slot, tag, offset);
 		slot = next;
@@ -819,10 +815,9 @@ void *radix_tree_tag_clear(struct radix_tree_root *root,
 		BUG_ON(shift != slot->shift);
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 		node = slot;
-		slot = slot->slots[offset];
+		offset = rt_next_level(node, &slot, offset);
 		if (slot == NULL)
 			goto out;
-		offset = follow_sibling(node, &slot, offset);
 	}
 
 	if (slot == NULL)
@@ -892,11 +887,11 @@ int radix_tree_tag_get(struct radix_tree_root *root,
 
 		node = indirect_to_ptr(node);
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		next = rcu_dereference_raw(node->slots[offset]);
+		offset = rt_next_level(node, &next, offset);
+
 		if (!next)
 			return 0;
-
-		offset = follow_sibling(node, &next, offset);
+		/* RADIX_TREE_RETRY is OK here; the tag is still valid */
 		if (!tag_get(node, tag, offset))
 			return 0;
 		if (!radix_tree_is_indirect_ptr(next))
@@ -988,10 +983,9 @@ restart:
 				goto restart;
 		}
 
-		slot = rcu_dereference_raw(node->slots[offset]);
+		offset = rt_next_level(node, &slot, offset);
 		if ((slot == NULL) || (slot == RADIX_TREE_RETRY))
 			goto restart;
-		offset = follow_sibling(node, &slot, offset);
 		if (!radix_tree_is_indirect_ptr(slot))
 			break;
 		if (shift == 0)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
