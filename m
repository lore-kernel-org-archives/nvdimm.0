Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 395FD21EA15C8
 for <linux-nvdimm@lists.01.org>; Thu,  5 Oct 2017 18:52:53 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 4/8] ccan/list: add a list_add_after helper
Date: Thu,  5 Oct 2017 19:54:01 -0600
Message-Id: <20171006015405.29908-5-vishal.l.verma@intel.com>
In-Reply-To: <20171006015405.29908-1-vishal.l.verma@intel.com>
References: <20171006015405.29908-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for the error-inject command, add anew helper to
ccan/list for adding a list element in the middle of a list.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ccan/list/list.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/ccan/list/list.h b/ccan/list/list.h
index 4d1d34e..e6ecfa3 100644
--- a/ccan/list/list.h
+++ b/ccan/list/list.h
@@ -193,6 +193,38 @@ static inline void list_add_tail_(struct list_head *h,
 }
 
 /**
+ * list_add_after - add an entry after the given node in the linked list.
+ * @h: the list_head to add the node to
+ * @l: the list_node after which to add to
+ * @n: the list_node to add to the list.
+ *
+ * The list_node does not need to be initialized; it will be overwritten.
+ * Example:
+ *	struct child *child = malloc(sizeof(*child));
+ *
+ *	child->name = "geoffrey";
+ *	list_add_after(&parent->children, &child1->list, &child->list);
+ *	parent->num_children++;
+ */
+#define list_add_after(h, l, n) list_add_after_(h, l, n, LIST_LOC)
+static inline void list_add_after_(struct list_head *h,
+				   struct list_node *l,
+				   struct list_node *n,
+				   const char *abortstr)
+{
+	if (l->next == &h->n) {
+		/* l is the last element, this becomes a list_add_tail */
+		list_add_tail(h, n);
+		return;
+	}
+	n->next = l->next;
+	n->prev = l;
+	l->next->prev = n;
+	l->next = n;
+	(void)list_debug(h, abortstr);
+}
+
+/**
  * list_empty - is a list empty?
  * @h: the list_head
  *
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
