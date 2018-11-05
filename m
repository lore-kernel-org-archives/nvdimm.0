Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAF402118B7A2
 for <linux-nvdimm@lists.01.org>; Mon,  5 Nov 2018 13:11:50 -0800 (PST)
Subject: [driver-core PATCH v5 2/9] async: Add support for queueing on
 specific NUMA node
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Mon, 05 Nov 2018 13:11:49 -0800
Message-ID: <154145230954.29224.13087735653265580553.stgit@ahduyck-desk1.jf.intel.com>
In-Reply-To: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
References: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
MIME-Version: 1.0
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
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: len.brown@intel.com, bvanassche@acm.org, linux-pm@vger.kernel.org, alexander.h.duyck@linux.intel.com, rafael@kernel.org, jiangshanlai@gmail.com, linux-nvdimm@lists.01.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

This patch introduces four new variants of the async_schedule_ functions
that allow scheduling on a specific NUMA node.

The first two functions are async_schedule_near and
async_schedule_near_domain which end up mapping to async_schedule and
async_schedule_domain but provide NUMA node specific functionality. They
replace the original functions which were moved to inline function
definitions that call the new functions while passing NUMA_NO_NODE.

The second two functions are async_schedule_dev and
async_schedule_dev_domain which provide NUMA specific functionality when
passing a device as the data member and that device has a NUMA node other
than NUMA_NO_NODE.

The main motivation behind this is to address the need to be able to
schedule device specific init work on specific NUMA nodes in order to
improve performance of memory initialization.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/async.h |   84 +++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/async.c        |   53 +++++++++++++++++--------------
 2 files changed, 110 insertions(+), 27 deletions(-)

diff --git a/include/linux/async.h b/include/linux/async.h
index 6b0226bdaadc..98a94e6e367d 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -14,6 +14,8 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/numa.h>
+#include <linux/device.h>
 
 typedef u64 async_cookie_t;
 typedef void (*async_func_t) (void *data, async_cookie_t cookie);
@@ -37,9 +39,85 @@ struct async_domain {
 	struct async_domain _name = { .pending = LIST_HEAD_INIT(_name.pending), \
 				      .registered = 0 }
 
-extern async_cookie_t async_schedule(async_func_t func, void *data);
-extern async_cookie_t async_schedule_domain(async_func_t func, void *data,
-					    struct async_domain *domain);
+async_cookie_t async_schedule_node(async_func_t func, void *data,
+				   int node);
+async_cookie_t async_schedule_node_domain(async_func_t func, void *data,
+					  int node,
+					  struct async_domain *domain);
+
+/**
+ * async_schedule - schedule a function for asynchronous execution
+ * @func: function to execute asynchronously
+ * @data: data pointer to pass to the function
+ *
+ * Returns an async_cookie_t that may be used for checkpointing later.
+ * Note: This function may be called from atomic or non-atomic contexts.
+ */
+static inline async_cookie_t async_schedule(async_func_t func, void *data)
+{
+	return async_schedule_node(func, data, NUMA_NO_NODE);
+}
+
+/**
+ * async_schedule_domain - schedule a function for asynchronous execution within a certain domain
+ * @func: function to execute asynchronously
+ * @data: data pointer to pass to the function
+ * @domain: the domain
+ *
+ * Returns an async_cookie_t that may be used for checkpointing later.
+ * @domain may be used in the async_synchronize_*_domain() functions to
+ * wait within a certain synchronization domain rather than globally.  A
+ * synchronization domain is specified via @domain.
+ * Note: This function may be called from atomic or non-atomic contexts.
+ */
+static inline async_cookie_t
+async_schedule_domain(async_func_t func, void *data,
+		      struct async_domain *domain)
+{
+	return async_schedule_node_domain(func, data, NUMA_NO_NODE, domain);
+}
+
+/**
+ * async_schedule_dev - A device specific version of async_schedule
+ * @func: function to execute asynchronously
+ * @dev: device argument to be passed to function
+ *
+ * Returns an async_cookie_t that may be used for checkpointing later.
+ * @dev is used as both the argument for the function and to provide NUMA
+ * context for where to run the function. By doing this we can try to
+ * provide for the best possible outcome by operating on the device on the
+ * CPUs closest to the device.
+ * Note: This function may be called from atomic or non-atomic contexts.
+ */
+static inline async_cookie_t
+async_schedule_dev(async_func_t func, struct device *dev)
+{
+	return async_schedule_node(func, dev, dev_to_node(dev));
+}
+
+/**
+ * async_schedule_dev_domain - A device specific version of async_schedule_domain
+ * @func: function to execute asynchronously
+ * @dev: device argument to be passed to function
+ * @domain: the domain
+ *
+ * Returns an async_cookie_t that may be used for checkpointing later.
+ * @dev is used as both the argument for the function and to provide NUMA
+ * context for where to run the function. By doing this we can try to
+ * provide for the best possible outcome by operating on the device on the
+ * CPUs closest to the device.
+ * @domain may be used in the async_synchronize_*_domain() functions to
+ * wait within a certain synchronization domain rather than globally.  A
+ * synchronization domain is specified via @domain.
+ * Note: This function may be called from atomic or non-atomic contexts.
+ */
+static inline async_cookie_t
+async_schedule_dev_domain(async_func_t func, struct device *dev,
+			  struct async_domain *domain)
+{
+	return async_schedule_node_domain(func, dev, dev_to_node(dev), domain);
+}
+
 void async_unregister_domain(struct async_domain *domain);
 extern void async_synchronize_full(void);
 extern void async_synchronize_full_domain(struct async_domain *domain);
diff --git a/kernel/async.c b/kernel/async.c
index a893d6170944..23cf67b4b4f8 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -149,7 +149,25 @@ static void async_run_entry_fn(struct work_struct *work)
 	wake_up(&async_done);
 }
 
-static async_cookie_t __async_schedule(async_func_t func, void *data, struct async_domain *domain)
+/**
+ * async_schedule_node_domain - NUMA specific version of async_schedule_domain
+ * @func: function to execute asynchronously
+ * @data: data pointer to pass to the function
+ * @node: NUMA node that we want to schedule this on or close to
+ * @domain: the domain
+ *
+ * Returns an async_cookie_t that may be used for checkpointing later.
+ * @domain may be used in the async_synchronize_*_domain() functions to
+ * wait within a certain synchronization domain rather than globally.  A
+ * synchronization domain is specified via @domain.  Note: This function
+ * may be called from atomic or non-atomic contexts.
+ *
+ * The node requested will be honored on a best effort basis. If the node
+ * has no CPUs associated with it then the work is distributed among all
+ * available CPUs.
+ */
+async_cookie_t async_schedule_node_domain(async_func_t func, void *data,
+					  int node, struct async_domain *domain)
 {
 	struct async_entry *entry;
 	unsigned long flags;
@@ -195,43 +213,30 @@ static async_cookie_t __async_schedule(async_func_t func, void *data, struct asy
 	current->flags |= PF_USED_ASYNC;
 
 	/* schedule for execution */
-	queue_work(system_unbound_wq, &entry->work);
+	queue_work_node(node, system_unbound_wq, &entry->work);
 
 	return newcookie;
 }
+EXPORT_SYMBOL_GPL(async_schedule_node_domain);
 
 /**
- * async_schedule - schedule a function for asynchronous execution
+ * async_schedule_node - NUMA specific version of async_schedule
  * @func: function to execute asynchronously
  * @data: data pointer to pass to the function
+ * @node: NUMA node that we want to schedule this on or close to
  *
  * Returns an async_cookie_t that may be used for checkpointing later.
  * Note: This function may be called from atomic or non-atomic contexts.
- */
-async_cookie_t async_schedule(async_func_t func, void *data)
-{
-	return __async_schedule(func, data, &async_dfl_domain);
-}
-EXPORT_SYMBOL_GPL(async_schedule);
-
-/**
- * async_schedule_domain - schedule a function for asynchronous execution within a certain domain
- * @func: function to execute asynchronously
- * @data: data pointer to pass to the function
- * @domain: the domain
  *
- * Returns an async_cookie_t that may be used for checkpointing later.
- * @domain may be used in the async_synchronize_*_domain() functions to
- * wait within a certain synchronization domain rather than globally.  A
- * synchronization domain is specified via @domain.  Note: This function
- * may be called from atomic or non-atomic contexts.
+ * The node requested will be honored on a best effort basis. If the node
+ * has no CPUs associated with it then the work is distributed among all
+ * available CPUs.
  */
-async_cookie_t async_schedule_domain(async_func_t func, void *data,
-				     struct async_domain *domain)
+async_cookie_t async_schedule_node(async_func_t func, void *data, int node)
 {
-	return __async_schedule(func, data, domain);
+	return async_schedule_node_domain(func, data, node, &async_dfl_domain);
 }
-EXPORT_SYMBOL_GPL(async_schedule_domain);
+EXPORT_SYMBOL_GPL(async_schedule_node);
 
 /**
  * async_synchronize_full - synchronize all asynchronous function calls

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
