Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2093221E08175
 for <linux-nvdimm@lists.01.org>; Mon,  9 Apr 2018 13:10:12 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [ndctl PATCH 2/2] ndctl: fix some spelling mistakes
Date: Mon,  9 Apr 2018 14:09:20 -0600
Message-Id: <20180409200920.20177-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20180409200920.20177-1-ross.zwisler@linux.intel.com>
References: <20180409200920.20177-1-ross.zwisler@linux.intel.com>
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

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 Documentation/ndctl/ndctl-create-namespace.txt |  2 +-
 ccan/list/list.h                               | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
index 14c5409..29c55f5 100644
--- a/Documentation/ndctl/ndctl-create-namespace.txt
+++ b/Documentation/ndctl/ndctl-create-namespace.txt
@@ -42,7 +42,7 @@ OPTIONS
 -m::
 --mode=::
 	- "raw": expose the namespace capacity directly with
-	  limitations.  Neither a raw pmem namepace nor raw blk
+	  limitations.  Neither a raw pmem namespace nor raw blk
 	  namespace support sector atomicity by default (see "sector"
 	  mode below).  A raw pmem namespace may have limited to no dax
 	  support depending the kernel. In other words operations like
diff --git a/ccan/list/list.h b/ccan/list/list.h
index 4d1d34e..b4c2d75 100644
--- a/ccan/list/list.h
+++ b/ccan/list/list.h
@@ -540,20 +540,20 @@ static inline void list_prepend_list_(struct list_head *to,
 /**
  * list_for_each_off - iterate through a list of memory regions.
  * @h: the list_head
- * @i: the pointer to a memory region wich contains list node data.
+ * @i: the pointer to a memory region which contains list node data.
  * @off: offset(relative to @i) at which list node data resides.
  *
  * This is a low-level wrapper to iterate @i over the entire list, used to
- * implement all oher, more high-level, for-each constructs. It's a for loop,
+ * implement all other, more high-level, for-each constructs. It's a for loop,
  * so you can break and continue as normal.
  *
  * WARNING! Being the low-level macro that it is, this wrapper doesn't know
- * nor care about the type of @i. The only assumtion made is that @i points
+ * nor care about the type of @i. The only assumption made is that @i points
  * to a chunk of memory that at some @offset, relative to @i, contains a
  * properly filled `struct node_list' which in turn contains pointers to
- * memory chunks and it's turtles all the way down. Whith all that in mind
+ * memory chunks and it's turtles all the way down. With all that in mind
  * remember that given the wrong pointer/offset couple this macro will
- * happilly churn all you memory untill SEGFAULT stops it, in other words
+ * happily churn all you memory until SEGFAULT stops it, in other words
  * caveat emptor.
  *
  * It is worth mentioning that one of legitimate use-cases for that wrapper
@@ -577,7 +577,7 @@ static inline void list_prepend_list_(struct list_head *to,
  * list_for_each_safe_off - iterate through a list of memory regions, maybe
  * during deletion
  * @h: the list_head
- * @i: the pointer to a memory region wich contains list node data.
+ * @i: the pointer to a memory region which contains list node data.
  * @nxt: the structure containing the list_node
  * @off: offset(relative to @i) at which list node data resides.
  *
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
