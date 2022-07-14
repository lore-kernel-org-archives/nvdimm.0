Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ECF6002
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 17:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657818144; x=1689354144;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eEjIKuScu5PsNnJ6b00Knr0ddNcwkSwfM5aF9xtCMgY=;
  b=LmhMzCOsYvbDheTAeg0JmQgZhfmz7ymf1OIAamkaBDHwTHXZkD/iNaJr
   jAw8qV06VuVS+T/hBVXBNpfmQBo1HB+ADuWlVuiY2uYORv5IlFbG97fjZ
   dKpzbjd2FSA3NlhgDbNd/X4ZY+V06s0Ze9t7I8rs5vW1F699qXTToQZyX
   s/NPMvxoL0RHbk3HNk5dY7XasEQ5PzMrp1YGsB5voUgwaVLNr8oNcPKux
   Wl+FXTGuA3deuYyYqYTTh4M7D3X1OhEeG6cO4M31uqITWs04YHn1W9KNK
   r0zmY6u1DBZN9esW4y9QsEax2XNgVdfTIs3za2C873u1Ptp8SsMuxY7Z8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286316722"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="286316722"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:17 -0700
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="685643981"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:16 -0700
Subject: [ndctl PATCH v2 05/12] ccan/list: Import latest list helpers
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Ira Weiny <ira.weiny@intel.com>, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Thu, 14 Jul 2022 10:02:15 -0700
Message-ID: <165781813572.1555691.15909358688944168922.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
References: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Pick up the definition of list_add_{before,after} and other updates from
ccan at commit 52b86922f846 ("ccan/base64: fix GCC warning.").

Reported-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ccan/list/list.h   |  258 +++++++++++++++++++++++++++++++++++++++++++++-------
 ndctl/lib/inject.c |    1 
 util/list.h        |   40 --------
 3 files changed, 222 insertions(+), 77 deletions(-)
 delete mode 100644 util/list.h

diff --git a/ccan/list/list.h b/ccan/list/list.h
index 3ebd1b23dc0f..15f5fb7b34eb 100644
--- a/ccan/list/list.h
+++ b/ccan/list/list.h
@@ -95,8 +95,8 @@ struct list_node *list_check_node(const struct list_node *n,
 #define list_debug(h, loc) list_check((h), loc)
 #define list_debug_node(n, loc) list_check_node((n), loc)
 #else
-#define list_debug(h, loc) (h)
-#define list_debug_node(n, loc) (n)
+#define list_debug(h, loc) ((void)loc, h)
+#define list_debug_node(n, loc) ((void)loc, n)
 #endif
 
 /**
@@ -111,7 +111,7 @@ struct list_node *list_check_node(const struct list_node *n,
  * Example:
  *	static struct list_head my_list = LIST_HEAD_INIT(my_list);
  */
-#define LIST_HEAD_INIT(name) { { &name.n, &name.n } }
+#define LIST_HEAD_INIT(name) { { &(name).n, &(name).n } }
 
 /**
  * LIST_HEAD - define and initialize an empty list_head
@@ -145,6 +145,48 @@ static inline void list_head_init(struct list_head *h)
 	h->n.next = h->n.prev = &h->n;
 }
 
+/**
+ * list_node_init - initialize a list_node
+ * @n: the list_node to link to itself.
+ *
+ * You don't need to use this normally!  But it lets you list_del(@n)
+ * safely.
+ */
+static inline void list_node_init(struct list_node *n)
+{
+	n->next = n->prev = n;
+}
+
+/**
+ * list_add_after - add an entry after an existing node in a linked list
+ * @h: the list_head to add the node to (for debugging)
+ * @p: the existing list_node to add the node after
+ * @n: the new list_node to add to the list.
+ *
+ * The existing list_node must already be a member of the list.
+ * The new list_node does not need to be initialized; it will be overwritten.
+ *
+ * Example:
+ *	struct child c1, c2, c3;
+ *	LIST_HEAD(h);
+ *
+ *	list_add_tail(&h, &c1.list);
+ *	list_add_tail(&h, &c3.list);
+ *	list_add_after(&h, &c1.list, &c2.list);
+ */
+#define list_add_after(h, p, n) list_add_after_(h, p, n, LIST_LOC)
+static inline void list_add_after_(struct list_head *h,
+				   struct list_node *p,
+				   struct list_node *n,
+				   const char *abortstr)
+{
+	n->next = p->next;
+	n->prev = p;
+	p->next->prev = n;
+	p->next = n;
+	(void)list_debug(h, abortstr);
+}
+
 /**
  * list_add - add an entry at the start of a linked list.
  * @h: the list_head to add the node to
@@ -163,10 +205,34 @@ static inline void list_add_(struct list_head *h,
 			     struct list_node *n,
 			     const char *abortstr)
 {
-	n->next = h->n.next;
-	n->prev = &h->n;
-	h->n.next->prev = n;
-	h->n.next = n;
+	list_add_after_(h, &h->n, n, abortstr);
+}
+
+/**
+ * list_add_before - add an entry before an existing node in a linked list
+ * @h: the list_head to add the node to (for debugging)
+ * @p: the existing list_node to add the node before
+ * @n: the new list_node to add to the list.
+ *
+ * The existing list_node must already be a member of the list.
+ * The new list_node does not need to be initialized; it will be overwritten.
+ *
+ * Example:
+ *	list_head_init(&h);
+ *	list_add_tail(&h, &c1.list);
+ *	list_add_tail(&h, &c3.list);
+ *	list_add_before(&h, &c3.list, &c2.list);
+ */
+#define list_add_before(h, p, n) list_add_before_(h, p, n, LIST_LOC)
+static inline void list_add_before_(struct list_head *h,
+				    struct list_node *p,
+				    struct list_node *n,
+				    const char *abortstr)
+{
+	n->next = p;
+	n->prev = p->prev;
+	p->prev->next = n;
+	p->prev = n;
 	(void)list_debug(h, abortstr);
 }
 
@@ -185,11 +251,7 @@ static inline void list_add_tail_(struct list_head *h,
 				  struct list_node *n,
 				  const char *abortstr)
 {
-	n->next = &h->n;
-	n->prev = h->n.prev;
-	h->n.prev->next = n;
-	h->n.prev = n;
-	(void)list_debug(h, abortstr);
+	list_add_before_(h, &h->n, n, abortstr);
 }
 
 /**
@@ -229,6 +291,21 @@ static inline bool list_empty_nodebug(const struct list_head *h)
 }
 #endif
 
+/**
+ * list_empty_nocheck - is a list empty?
+ * @h: the list_head
+ *
+ * If the list is empty, returns true. This doesn't perform any
+ * debug check for list consistency, so it can be called without
+ * locks, racing with the list being modified. This is ok for
+ * checks where an incorrect result is not an issue (optimized
+ * bail out path for example).
+ */
+static inline bool list_empty_nocheck(const struct list_head *h)
+{
+	return h->n.next == &h->n;
+}
+
 /**
  * list_del - delete an entry from an (unknown) linked list.
  * @n: the list_node to delete from the list.
@@ -237,7 +314,7 @@ static inline bool list_empty_nodebug(const struct list_head *h)
  * another list, but not deleted again.
  *
  * See also:
- *	list_del_from()
+ *	list_del_from(), list_del_init()
  *
  * Example:
  *	list_del(&child->list);
@@ -255,6 +332,27 @@ static inline void list_del_(struct list_node *n, const char* abortstr)
 #endif
 }
 
+/**
+ * list_del_init - delete a node, and reset it so it can be deleted again.
+ * @n: the list_node to be deleted.
+ *
+ * list_del(@n) or list_del_init() again after this will be safe,
+ * which can be useful in some cases.
+ *
+ * See also:
+ *	list_del_from(), list_del()
+ *
+ * Example:
+ *	list_del_init(&child->list);
+ *	parent->num_children--;
+ */
+#define list_del_init(n) list_del_init_(n, LIST_LOC)
+static inline void list_del_init_(struct list_node *n, const char *abortstr)
+{
+	list_del_(n, abortstr);
+	list_node_init(n);
+}
+
 /**
  * list_del_from - delete an entry from a known linked list.
  * @h: the list_head the node is in.
@@ -285,6 +383,39 @@ static inline void list_del_from(struct list_head *h, struct list_node *n)
 	list_del(n);
 }
 
+/**
+ * list_swap - swap out an entry from an (unknown) linked list for a new one.
+ * @o: the list_node to replace from the list.
+ * @n: the list_node to insert in place of the old one.
+ *
+ * Note that this leaves @o in an undefined state; it can be added to
+ * another list, but not deleted/swapped again.
+ *
+ * See also:
+ *	list_del()
+ *
+ * Example:
+ *	struct child x1, x2;
+ *	LIST_HEAD(xh);
+ *
+ *	list_add(&xh, &x1.list);
+ *	list_swap(&x1.list, &x2.list);
+ */
+#define list_swap(o, n) list_swap_(o, n, LIST_LOC)
+static inline void list_swap_(struct list_node *o,
+			      struct list_node *n,
+			      const char* abortstr)
+{
+	(void)list_debug_node(o, abortstr);
+	*n = *o;
+	n->next->prev = n;
+	n->prev->next = n;
+#ifdef CCAN_LIST_DEBUG
+	/* Catch use-after-del. */
+	o->next = o->prev = NULL;
+#endif
+}
+
 /**
  * list_entry - convert a list_node back into the structure containing it.
  * @n: the list_node
@@ -406,9 +537,29 @@ static inline const void *list_tail_(const struct list_head *h, size_t off)
  *		printf("Name: %s\n", child->name);
  */
 #define list_for_each_rev(h, i, member)					\
-	for (i = container_of_var(list_debug(h,	LIST_LOC)->n.prev, i, member); \
-	     &i->member != &(h)->n;					\
-	     i = container_of_var(i->member.prev, i, member))
+	list_for_each_rev_off(h, i, list_off_var_(i, member))
+
+/**
+ * list_for_each_rev_safe - iterate through a list backwards,
+ * maybe during deletion
+ * @h: the list_head
+ * @i: the structure containing the list_node
+ * @nxt: the structure containing the list_node
+ * @member: the list_node member of the structure
+ *
+ * This is a convenient wrapper to iterate @i over the entire list backwards.
+ * It's a for loop, so you can break and continue as normal.  The extra
+ * variable * @nxt is used to hold the next element, so you can delete @i
+ * from the list.
+ *
+ * Example:
+ *	struct child *next;
+ *	list_for_each_rev_safe(&parent->children, child, next, list) {
+ *		printf("Name: %s\n", child->name);
+ *	}
+ */
+#define list_for_each_rev_safe(h, i, nxt, member)			\
+	list_for_each_rev_safe_off(h, i, nxt, list_off_var_(i, member))
 
 /**
  * list_for_each_safe - iterate through a list, maybe during deletion
@@ -422,7 +573,6 @@ static inline const void *list_tail_(const struct list_head *h, size_t off)
  * @nxt is used to hold the next element, so you can delete @i from the list.
  *
  * Example:
- *	struct child *next;
  *	list_for_each_safe(&parent->children, child, next, list) {
  *		list_del(&child->list);
  *		parent->num_children--;
@@ -537,10 +687,28 @@ static inline void list_prepend_list_(struct list_head *to,
 	list_head_init(from);
 }
 
+/* internal macros, do not use directly */
+#define list_for_each_off_dir_(h, i, off, dir)				\
+	for (i = list_node_to_off_(list_debug(h, LIST_LOC)->n.dir,	\
+				   (off));				\
+	list_node_from_off_((void *)i, (off)) != &(h)->n;		\
+	i = list_node_to_off_(list_node_from_off_((void *)i, (off))->dir, \
+			      (off)))
+
+#define list_for_each_safe_off_dir_(h, i, nxt, off, dir)		\
+	for (i = list_node_to_off_(list_debug(h, LIST_LOC)->n.dir,	\
+				   (off)),				\
+	nxt = list_node_to_off_(list_node_from_off_(i, (off))->dir,	\
+				(off));					\
+	list_node_from_off_(i, (off)) != &(h)->n;			\
+	i = nxt,							\
+	nxt = list_node_to_off_(list_node_from_off_(i, (off))->dir,	\
+				(off)))
+
 /**
  * list_for_each_off - iterate through a list of memory regions.
  * @h: the list_head
- * @i: the pointer to a memory region wich contains list node data.
+ * @i: the pointer to a memory region which contains list node data.
  * @off: offset(relative to @i) at which list node data resides.
  *
  * This is a low-level wrapper to iterate @i over the entire list, used to
@@ -548,12 +716,12 @@ static inline void list_prepend_list_(struct list_head *to,
  * so you can break and continue as normal.
  *
  * WARNING! Being the low-level macro that it is, this wrapper doesn't know
- * nor care about the type of @i. The only assumtion made is that @i points
+ * nor care about the type of @i. The only assumption made is that @i points
  * to a chunk of memory that at some @offset, relative to @i, contains a
- * properly filled `struct node_list' which in turn contains pointers to
- * memory chunks and it's turtles all the way down. Whith all that in mind
+ * properly filled `struct list_node' which in turn contains pointers to
+ * memory chunks and it's turtles all the way down. With all that in mind
  * remember that given the wrong pointer/offset couple this macro will
- * happilly churn all you memory untill SEGFAULT stops it, in other words
+ * happily churn all you memory until SEGFAULT stops it, in other words
  * caveat emptor.
  *
  * It is worth mentioning that one of legitimate use-cases for that wrapper
@@ -567,17 +735,24 @@ static inline void list_prepend_list_(struct list_head *to,
  *		printf("Name: %s\n", child->name);
  */
 #define list_for_each_off(h, i, off)                                    \
-	for (i = list_node_to_off_(list_debug(h, LIST_LOC)->n.next,	\
-				   (off));				\
-       list_node_from_off_((void *)i, (off)) != &(h)->n;                \
-       i = list_node_to_off_(list_node_from_off_((void *)i, (off))->next, \
-                             (off)))
+	list_for_each_off_dir_((h),(i),(off),next)
+
+/**
+ * list_for_each_rev_off - iterate through a list of memory regions backwards
+ * @h: the list_head
+ * @i: the pointer to a memory region which contains list node data.
+ * @off: offset(relative to @i) at which list node data resides.
+ *
+ * See list_for_each_off for details
+ */
+#define list_for_each_rev_off(h, i, off)                                    \
+	list_for_each_off_dir_((h),(i),(off),prev)
 
 /**
  * list_for_each_safe_off - iterate through a list of memory regions, maybe
  * during deletion
  * @h: the list_head
- * @i: the pointer to a memory region wich contains list node data.
+ * @i: the pointer to a memory region which contains list node data.
  * @nxt: the structure containing the list_node
  * @off: offset(relative to @i) at which list node data resides.
  *
@@ -590,15 +765,26 @@ static inline void list_prepend_list_(struct list_head *to,
  *		printf("Name: %s\n", child->name);
  */
 #define list_for_each_safe_off(h, i, nxt, off)                          \
-	for (i = list_node_to_off_(list_debug(h, LIST_LOC)->n.next,	\
-				   (off)),				\
-         nxt = list_node_to_off_(list_node_from_off_(i, (off))->next,   \
-                                 (off));                                \
-       list_node_from_off_(i, (off)) != &(h)->n;                        \
-       i = nxt,                                                         \
-         nxt = list_node_to_off_(list_node_from_off_(i, (off))->next,   \
-                                 (off)))
+	list_for_each_safe_off_dir_((h),(i),(nxt),(off),next)
 
+/**
+ * list_for_each_rev_safe_off - iterate backwards through a list of
+ * memory regions, maybe during deletion
+ * @h: the list_head
+ * @i: the pointer to a memory region which contains list node data.
+ * @nxt: the structure containing the list_node
+ * @off: offset(relative to @i) at which list node data resides.
+ *
+ * For details see `list_for_each_rev_off' and `list_for_each_rev_safe'
+ * descriptions.
+ *
+ * Example:
+ *	list_for_each_rev_safe_off(&parent->children, child,
+ *		next, offsetof(struct child, list))
+ *		printf("Name: %s\n", child->name);
+ */
+#define list_for_each_rev_safe_off(h, i, nxt, off)                      \
+	list_for_each_safe_off_dir_((h),(i),(nxt),(off),prev)
 
 /* Other -off variants. */
 #define list_entry_off(n, type, off)		\
diff --git a/ndctl/lib/inject.c b/ndctl/lib/inject.c
index d61c02c176e2..3486ffefc40a 100644
--- a/ndctl/lib/inject.c
+++ b/ndctl/lib/inject.c
@@ -2,7 +2,6 @@
 // Copyright (C) 2014-2020, Intel Corporation. All rights reserved.
 #include <stdlib.h>
 #include <limits.h>
-#include <util/list.h>
 #include <util/size.h>
 #include <ndctl/libndctl.h>
 #include <ccan/list/list.h>
diff --git a/util/list.h b/util/list.h
deleted file mode 100644
index 1ea9c59b9f0c..000000000000
--- a/util/list.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2015-2020 Intel Corporation. All rights reserved. */
-#ifndef _NDCTL_LIST_H_
-#define _NDCTL_LIST_H_
-
-#include <ccan/list/list.h>
-
-/**
- * list_add_after - add an entry after the given node in the linked list.
- * @h: the list_head to add the node to
- * @l: the list_node after which to add to
- * @n: the list_node to add to the list.
- *
- * The list_node does not need to be initialized; it will be overwritten.
- * Example:
- *	struct child *child = malloc(sizeof(*child));
- *
- *	child->name = "geoffrey";
- *	list_add_after(&parent->children, &child1->list, &child->list);
- *	parent->num_children++;
- */
-#define list_add_after(h, l, n) list_add_after_(h, l, n, LIST_LOC)
-static inline void list_add_after_(struct list_head *h,
-				   struct list_node *l,
-				   struct list_node *n,
-				   const char *abortstr)
-{
-	if (l->next == &h->n) {
-		/* l is the last element, this becomes a list_add_tail */
-		list_add_tail(h, n);
-		return;
-	}
-	n->next = l->next;
-	n->prev = l;
-	l->next->prev = n;
-	l->next = n;
-	(void)list_debug(h, abortstr);
-}
-
-#endif /* _NDCTL_LIST_H_ */

