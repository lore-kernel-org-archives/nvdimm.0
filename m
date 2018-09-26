Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B16F21157438
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 14:51:44 -0700 (PDT)
Subject: [RFC workqueue/driver-core PATCH 2/5] async: Add support for
 queueing on specific NUMA node
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 26 Sep 2018 14:51:43 -0700
Message-ID: <20180926215143.13512.56522.stgit@localhost.localdomain>
In-Reply-To: <20180926214433.13512.30289.stgit@localhost.localdomain>
References: <20180926214433.13512.30289.stgit@localhost.localdomain>
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
To: linux-nvdimm@lists.01.org, gregkh@linuxfoundation.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org, akpm@linux-foundation.org
Cc: len.brown@intel.com, rafael@kernel.org, jiangshanlai@gmail.com, pavel@ucw.cz, zwisler@kernel.org
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
 include/linux/async.h |   27 +++++++++++++++++++--
 kernel/async.c        |   62 ++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 69 insertions(+), 20 deletions(-)

diff --git a/include/linux/async.h b/include/linux/async.h
index 6b0226bdaadc..abf3ee9102df 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -14,6 +14,9 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/numa.h>
+
+struct device;
 
 typedef u64 async_cookie_t;
 typedef void (*async_func_t) (void *data, async_cookie_t cookie);
@@ -37,9 +40,27 @@ struct async_domain {
 	struct async_domain _name = { .pending = LIST_HEAD_INIT(_name.pending), \
 				      .registered = 0 }
 
-extern async_cookie_t async_schedule(async_func_t func, void *data);
-extern async_cookie_t async_schedule_domain(async_func_t func, void *data,
-					    struct async_domain *domain);
+async_cookie_t async_schedule_near(async_func_t func, void *data,
+				   int node);
+async_cookie_t async_schedule_near_domain(async_func_t func, void *data,
+					  int node,
+					  struct async_domain *domain);
+
+static inline async_cookie_t async_schedule(async_func_t func, void *data)
+{
+	return async_schedule_near(func, data, NUMA_NO_NODE);
+}
+
+static inline async_cookie_t
+async_schedule_domain(async_func_t func, void *data,
+		      struct async_domain *domain)
+{
+	return async_schedule_near_domain(func, data, NUMA_NO_NODE, domain);
+}
+
+async_cookie_t async_schedule_dev(async_func_t func, struct device *dev);
+async_cookie_t async_schedule_dev_domain(async_func_t func, struct device *dev,
+					 struct async_domain *domain);
 void async_unregister_domain(struct async_domain *domain);
 extern void async_synchronize_full(void);
 extern void async_synchronize_full_domain(struct async_domain *domain);
diff --git a/kernel/async.c b/kernel/async.c
index a893d6170944..13fcf222b89a 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -56,6 +56,7 @@ synchronization with the async_synchronize_full() function, before returning
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <linux/device.h>
 
 #include "workqueue_internal.h"
 
@@ -149,7 +150,21 @@ static void async_run_entry_fn(struct work_struct *work)
 	wake_up(&async_done);
 }
 
-static async_cookie_t __async_schedule(async_func_t func, void *data, struct async_domain *domain)
+/**
+ * async_schedule_near_domain - schedule a function for asynchronous execution within a certain domain
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
+ */
+async_cookie_t async_schedule_near_domain(async_func_t func, void *data,
+					  int node, struct async_domain *domain)
 {
 	struct async_entry *entry;
 	unsigned long flags;
@@ -195,43 +210,56 @@ static async_cookie_t __async_schedule(async_func_t func, void *data, struct asy
 	current->flags |= PF_USED_ASYNC;
 
 	/* schedule for execution */
-	queue_work(system_unbound_wq, &entry->work);
+	queue_work_near(node, system_unbound_wq, &entry->work);
 
 	return newcookie;
 }
+EXPORT_SYMBOL_GPL(async_schedule_near_domain);
 
 /**
- * async_schedule - schedule a function for asynchronous execution
+ * async_schedule_near - schedule a function for asynchronous execution
  * @func: function to execute asynchronously
  * @data: data pointer to pass to the function
+ * @node: NUMA node that we want to schedule this on or close to
  *
  * Returns an async_cookie_t that may be used for checkpointing later.
  * Note: This function may be called from atomic or non-atomic contexts.
  */
-async_cookie_t async_schedule(async_func_t func, void *data)
+async_cookie_t async_schedule_near(async_func_t func, void *data, int node)
 {
-	return __async_schedule(func, data, &async_dfl_domain);
+	return async_schedule_near_domain(func, data, node, &async_dfl_domain);
 }
-EXPORT_SYMBOL_GPL(async_schedule);
+EXPORT_SYMBOL_GPL(async_schedule_near);
 
 /**
- * async_schedule_domain - schedule a function for asynchronous execution within a certain domain
+ * async_schedule_dev_domain - schedule a function for asynchronous execution within a certain domain
  * @func: function to execute asynchronously
- * @data: data pointer to pass to the function
+ * @dev: device that we are scheduling this work for
  * @domain: the domain
  *
- * Returns an async_cookie_t that may be used for checkpointing later.
- * @domain may be used in the async_synchronize_*_domain() functions to
- * wait within a certain synchronization domain rather than globally.  A
- * synchronization domain is specified via @domain.  Note: This function
- * may be called from atomic or non-atomic contexts.
+ * Device specific version of async_schedule_near_domain that provides some
+ * NUMA awareness based on the device node.
+ */
+async_cookie_t async_schedule_dev_domain(async_func_t func, struct device *dev,
+					 struct async_domain *domain)
+{
+	return async_schedule_near_domain(func, dev, dev_to_node(dev), domain);
+}
+EXPORT_SYMBOL_GPL(async_schedule_dev_domain);
+
+/**
+ * async_schedule_dev - schedule a function for asynchronous execution
+ * @func: function to execute asynchronously
+ * @dev: device that we are scheduling this work for
+ *
+ * Device specific version of async_schedule_near that provides some NUMA
+ * awareness based on the device node.
  */
-async_cookie_t async_schedule_domain(async_func_t func, void *data,
-				     struct async_domain *domain)
+async_cookie_t async_schedule_dev(async_func_t func, struct device *dev)
 {
-	return __async_schedule(func, data, domain);
+	return async_schedule_dev_domain(func, dev, &async_dfl_domain);
 }
-EXPORT_SYMBOL_GPL(async_schedule_domain);
+EXPORT_SYMBOL_GPL(async_schedule_dev);
 
 /**
  * async_synchronize_full - synchronize all asynchronous function calls

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
