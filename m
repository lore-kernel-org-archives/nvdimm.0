Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B77B538B
	for <nvdimm@lists.linux.dev>; Tue, 12 Jul 2022 19:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657652874; x=1689188874;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QwZrIyDCpVWkjA3BzG2YbvtgjL7PYMxHdM6l/VXwClA=;
  b=ltHoGrR32iBLfwTqGYYZNL0i+IUL3ufojKLwQH3GYr3l4b3StjxObMUH
   9xnNstEgHTN9MIONcsZQxkBXxTD8kNzwUOzMdxjtwA2keKd7DdRBvuRTI
   DYu3gw+egibg3LVvYh91icjKze8cyBDik5vXGPFiunHH5smXL6k/JhKNV
   d3wR0NGFR4MMNqMssfGH13me0RHsmP5Kg57FXlH6pwXndq0qpR4/6YCeE
   1bz6W7zx9P7sjlkVkUkTQW56lhBJ9O3oSgrA/PhuAkVymSrCnPiiC4yzI
   d+B7jW9aoViIDLd574xb2jpHtVaAvw3C/zbIcCKtKDDeFYSUUygLedIEv
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="282573297"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="282573297"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:07:53 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="595400555"
Received: from sheyting-mobl3.amr.corp.intel.com (HELO [192.168.1.117]) ([10.212.147.156])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:07:53 -0700
Subject: [ndctl PATCH 05/11] cxl/lib: Maintain decoders in id order
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Tue, 12 Jul 2022 12:07:52 -0700
Message-ID: <165765287277.435671.14320322485572083484.stgit@dwillia2-xfh>
In-Reply-To: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Given that decoder instance order is fundamental to the DPA translation
sequence for endpoint decoders, enforce that cxl_decoder_for_each() returns
decoders in instance order. Otherwise, they show up in readddir() order
which is not predictable.

Add a list_add_sorted() to generically handle inserting into a sorted list.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/lib/libcxl.c |    8 ++++++-
 util/list.h      |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index f36edcfc735a..e4c5d3819e88 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -19,6 +19,7 @@
 #include <ccan/short_types/short_types.h>
 
 #include <util/log.h>
+#include <util/list.h>
 #include <util/size.h>
 #include <util/sysfs.h>
 #include <util/bitmap.h>
@@ -908,6 +909,11 @@ cxl_endpoint_get_memdev(struct cxl_endpoint *endpoint)
 	return NULL;
 }
 
+static int decoder_id_cmp(struct cxl_decoder *d1, struct cxl_decoder *d2)
+{
+	return d1->id - d2->id;
+}
+
 static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 {
 	const char *devname = devpath_to_devname(cxldecoder_base);
@@ -1049,7 +1055,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 			return decoder_dup;
 		}
 
-	list_add(&port->decoders, &decoder->list);
+	list_add_sorted(&port->decoders, decoder, list, decoder_id_cmp);
 
 	free(path);
 	return decoder;
diff --git a/util/list.h b/util/list.h
index 1ea9c59b9f0c..c6584e3ec725 100644
--- a/util/list.h
+++ b/util/list.h
@@ -37,4 +37,65 @@ static inline void list_add_after_(struct list_head *h,
 	(void)list_debug(h, abortstr);
 }
 
+/**
+ * list_add_before - add an entry before the given node in the linked list.
+ * @h: the list_head to add the node to
+ * @l: the list_node before which to add to
+ * @n: the list_node to add to the list.
+ *
+ * The list_node does not need to be initialized; it will be overwritten.
+ * Example:
+ *	struct child *child = malloc(sizeof(*child));
+ *
+ *	child->name = "geoffrey";
+ *	list_add_before(&parent->children, &child1->list, &child->list);
+ *	parent->num_children++;
+ */
+#define list_add_before(h, l, n) list_add_before_(h, l, n, LIST_LOC)
+static inline void list_add_before_(struct list_head *h, struct list_node *l,
+				    struct list_node *n, const char *abortstr)
+{
+	if (l->prev == &h->n) {
+		/* l is the first element, this becomes a list_add */
+		list_add(h, n);
+		return;
+	}
+
+	n->next = l;
+	n->prev = l->prev;
+	l->prev->next = n;
+	l->prev = n;
+}
+
+#define list_add_sorted(head, n, node, cmp)                                    \
+	do {                                                                   \
+		struct list_head *__head = (head);                             \
+		typeof(n) __iter, __next;                                      \
+		typeof(n) __new = (n);                                         \
+                                                                               \
+		if (list_empty(__head)) {                                      \
+			list_add(__head, &__new->node);                        \
+			break;                                                 \
+		}                                                              \
+                                                                               \
+		list_for_each (__head, __iter, node) {                         \
+			if (cmp(__new, __iter) < 0) {                          \
+				list_add_before(__head, &__iter->node,         \
+						&__new->node);                 \
+				break;                                         \
+			}                                                      \
+			__next = list_next(__head, __iter, node);              \
+			if (!__next) {                                         \
+				list_add_after(__head, &__iter->node,          \
+					       &__new->node);                  \
+				break;                                         \
+			}                                                      \
+			if (cmp(__new, __next) < 0) {                          \
+				list_add_before(__head, &__next->node,         \
+						&__new->node);                 \
+				break;                                         \
+			}                                                      \
+		}                                                              \
+	} while (0)
+
 #endif /* _NDCTL_LIST_H_ */

