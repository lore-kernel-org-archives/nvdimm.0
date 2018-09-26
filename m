Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2638321157438
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 14:51:39 -0700 (PDT)
Subject: [RFC workqueue/driver-core PATCH 1/5] workqueue: Provide
 queue_work_near to queue work near a given NUMA node
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 26 Sep 2018 14:51:38 -0700
Message-ID: <20180926215138.13512.33146.stgit@localhost.localdomain>
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

This patch provides a new function queue_work_near which is meant to
schedule work on the nearest unbound CPU to the requested NUMA node. The
main motivation for this is to help assist asynchronous init to better
improve boot times for devices that are local to a specific node.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/workqueue.h |    2 +
 kernel/workqueue.c        |  129 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 129 insertions(+), 2 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 60d673e15632..1f9f0a65437b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -463,6 +463,8 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 
 extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
 			struct work_struct *work);
+extern bool queue_work_near(int node, struct workqueue_struct *wq,
+			    struct work_struct *work);
 extern bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
 extern bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0280deac392e..a971d3c4096e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -49,6 +49,7 @@
 #include <linux/uaccess.h>
 #include <linux/sched/isolation.h>
 #include <linux/nmi.h>
+#include <linux/device.h>
 
 #include "workqueue_internal.h"
 
@@ -1332,8 +1333,9 @@ static bool is_chained_work(struct workqueue_struct *wq)
  * by wq_unbound_cpumask.  Otherwise, round robin among the allowed ones to
  * avoid perturbing sensitive tasks.
  */
-static int wq_select_unbound_cpu(int cpu)
+static int wq_select_unbound_cpu(void)
 {
+	int cpu = raw_smp_processor_id();
 	static bool printed_dbg_warning;
 	int new_cpu;
 
@@ -1385,7 +1387,7 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 		return;
 retry:
 	if (req_cpu == WORK_CPU_UNBOUND)
-		cpu = wq_select_unbound_cpu(raw_smp_processor_id());
+		cpu = wq_select_unbound_cpu();
 
 	/* pwq which will be used unless @work is executing elsewhere */
 	if (!(wq->flags & WQ_UNBOUND))
@@ -1492,6 +1494,129 @@ bool queue_work_on(int cpu, struct workqueue_struct *wq,
 }
 EXPORT_SYMBOL(queue_work_on);
 
+/**
+ * workqueue_select_unbound_cpu_near - Select an unbound CPU based on NUMA node
+ * @node: NUMA node ID that we want to bind a CPU from
+ *
+ * This function will attempt to find a "random" cpu available to the unbound
+ * workqueues on a given node. If there are no CPUs available on the given
+ * node it will return WORK_CPU_UNBOUND indicating that we should just
+ * schedule to any available CPU if we need to schedule this work.
+ */
+static int workqueue_select_unbound_cpu_near(int node)
+{
+	const struct cpumask *wq_cpumask, *node_cpumask;
+	int cpu;
+
+	/* No point in doing this if NUMA isn't enabled for workqueues */
+	if (!wq_numa_enabled)
+		return WORK_CPU_UNBOUND;
+
+	/* delay binding to CPU if node is not valid or online */
+	if (node < 0 || node >= MAX_NUMNODES || !node_online(node))
+		return WORK_CPU_UNBOUND;
+
+	/* If wq_unbound_cpumask is empty then just use cpu_online_mask */
+	wq_cpumask = cpumask_empty(wq_unbound_cpumask) ? cpu_online_mask :
+							 wq_unbound_cpumask;
+
+	/*
+	 * If node has no CPUs, or no CPUs in the unbound cpumask then we
+	 * need to try and find the nearest node that does have CPUs in the
+	 * unbound cpumask.
+	 */
+	if (!nr_cpus_node(node) ||
+	    !cpumask_intersects(cpumask_of_node(node), wq_cpumask)) {
+		int min_val = INT_MAX, best_node = NUMA_NO_NODE;
+		int this_node, val;
+
+		for_each_online_node(this_node) {
+			if (this_node == node)
+				continue;
+
+			val = node_distance(node, this_node);
+			if (min_val < val)
+				continue;
+
+			if (!nr_cpus_node(this_node) ||
+			    !cpumask_intersects(cpumask_of_node(this_node),
+						wq_cpumask))
+				continue;
+
+			best_node = this_node;
+			min_val = val;
+		}
+
+		/* If we failed to find a close node just defer */
+		if (best_node == NUMA_NO_NODE)
+			return WORK_CPU_UNBOUND;
+
+		/* update node to reflect optimal value */
+		node = best_node;
+	}
+
+
+	/* Use local node/cpu if we are already there */
+	cpu = raw_smp_processor_id();
+	if (node == cpu_to_node(cpu) &&
+	    cpumask_test_cpu(cpu, wq_unbound_cpumask))
+		return cpu;
+
+	/*
+	 * Reuse the same value as wq_select_unbound_cpu above to prevent
+	 * us from mapping the same CPU each time. The impact to
+	 * wq_select_unbound_cpu should be minimal since the above function
+	 * only uses it when it has to load balance on remote CPUs similar
+	 * to what I am doing here.
+	 */
+	cpu = __this_cpu_read(wq_rr_cpu_last);
+	node_cpumask = cpumask_of_node(node);
+	cpu = cpumask_next_and(cpu, wq_cpumask, node_cpumask);
+	if (unlikely(cpu >= nr_cpu_ids)) {
+		cpu = cpumask_first_and(wq_cpumask, node_cpumask);
+		if (unlikely(cpu >= nr_cpu_ids))
+			return WORK_CPU_UNBOUND;
+	}
+	__this_cpu_write(wq_rr_cpu_last, cpu);
+
+	return cpu;
+}
+
+/**
+ * queue_work_near - queue work on the nearest unbound cpu to a given NUMA node
+ * @node: NUMA node that we are targeting the work for
+ * @wq: workqueue to use
+ * @work: work to queue
+ *
+ * We queue the work to a specific CPU based on a given NUMA node, the
+ * caller must ensure it can't go away.
+ *
+ * This function will only make a best effort attempt at getting this onto
+ * the right NUMA node. If no node is requested or the requested node is
+ * offline then we just fall back to standard queue_work behavior.
+ *
+ * Return: %false if @work was already on a queue, %true otherwise.
+ */
+bool queue_work_near(int node, struct workqueue_struct *wq,
+		     struct work_struct *work)
+{
+	unsigned long flags;
+	bool ret = false;
+
+	local_irq_save(flags);
+
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
+		int cpu = workqueue_select_unbound_cpu_near(node);
+
+		__queue_work(cpu, wq, work);
+		ret = true;
+	}
+
+	local_irq_restore(flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(queue_work_near);
+
 void delayed_work_timer_fn(struct timer_list *t)
 {
 	struct delayed_work *dwork = from_timer(dwork, t, timer);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
