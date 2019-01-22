Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [driver-core PATCH v10 4/9] workqueue: Provide queue_work_node to
 queue work near a given NUMA node
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Tue, 22 Jan 2019 10:39:26 -0800
Message-ID: <154818236651.18753.15266328569026759419.stgit@ahduyck-desk1.amr.corp.intel.com>
In-Reply-To: <154818223154.18753.12374915684623789884.stgit@ahduyck-desk1.amr.corp.intel.com>
References: <154818223154.18753.12374915684623789884.stgit@ahduyck-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: mcgrof@kernel.org, linux-nvdimm@lists.01.org, tj@kernel.org, akpm@linux-foundation.org, linux-pm@vger.kernel.org, jiangshanlai@gmail.com, rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz, zwisler@kernel.org, dan.j.williams@intel.com, dave.jiang@intel.com, bvanassche@acm.org, alexander.h.duyck@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

Provide a new function, queue_work_node, which is meant to schedule work on
a "random" CPU of the requested NUMA node. The main motivation for this is
to help assist asynchronous init to better improve boot times for devices
that are local to a specific node.

For now we just default to the first CPU that is in the intersection of the
cpumask of the node and the online cpumask. The only exception is if the
CPU is local to the node we will just use the current CPU. This should work
for our purposes as we are currently only using this for unbound work so
the CPU will be translated to a node anyway instead of being directly used.

As we are only using the first CPU to represent the NUMA node for now I am
limiting the scope of the function so that it can only be used with unbound
workqueues.

Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/workqueue.h |    2 +
 kernel/workqueue.c        |   84 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 60d673e15632..1f50c1e586e7 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -463,6 +463,8 @@ int workqueue_set_unbound_cpumask(cpumask_var_t cpumask);
 
 extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
 			struct work_struct *work);
+extern bool queue_work_node(int node, struct workqueue_struct *wq,
+			    struct work_struct *work);
 extern bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
 extern bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 392be4b252f6..d5a26e456f7a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1492,6 +1492,90 @@ bool queue_work_on(int cpu, struct workqueue_struct *wq,
 }
 EXPORT_SYMBOL(queue_work_on);
 
+/**
+ * workqueue_select_cpu_near - Select a CPU based on NUMA node
+ * @node: NUMA node ID that we want to select a CPU from
+ *
+ * This function will attempt to find a "random" cpu available on a given
+ * node. If there are no CPUs available on the given node it will return
+ * WORK_CPU_UNBOUND indicating that we should just schedule to any
+ * available CPU if we need to schedule this work.
+ */
+static int workqueue_select_cpu_near(int node)
+{
+	int cpu;
+
+	/* No point in doing this if NUMA isn't enabled for workqueues */
+	if (!wq_numa_enabled)
+		return WORK_CPU_UNBOUND;
+
+	/* Delay binding to CPU if node is not valid or online */
+	if (node < 0 || node >= MAX_NUMNODES || !node_online(node))
+		return WORK_CPU_UNBOUND;
+
+	/* Use local node/cpu if we are already there */
+	cpu = raw_smp_processor_id();
+	if (node == cpu_to_node(cpu))
+		return cpu;
+
+	/* Use "random" otherwise know as "first" online CPU of node */
+	cpu = cpumask_any_and(cpumask_of_node(node), cpu_online_mask);
+
+	/* If CPU is valid return that, otherwise just defer */
+	return cpu < nr_cpu_ids ? cpu : WORK_CPU_UNBOUND;
+}
+
+/**
+ * queue_work_node - queue work on a "random" cpu for a given NUMA node
+ * @node: NUMA node that we are targeting the work for
+ * @wq: workqueue to use
+ * @work: work to queue
+ *
+ * We queue the work to a "random" CPU within a given NUMA node. The basic
+ * idea here is to provide a way to somehow associate work with a given
+ * NUMA node.
+ *
+ * This function will only make a best effort attempt at getting this onto
+ * the right NUMA node. If no node is requested or the requested node is
+ * offline then we just fall back to standard queue_work behavior.
+ *
+ * Currently the "random" CPU ends up being the first available CPU in the
+ * intersection of cpu_online_mask and the cpumask of the node, unless we
+ * are running on the node. In that case we just use the current CPU.
+ *
+ * Return: %false if @work was already on a queue, %true otherwise.
+ */
+bool queue_work_node(int node, struct workqueue_struct *wq,
+		     struct work_struct *work)
+{
+	unsigned long flags;
+	bool ret = false;
+
+	/*
+	 * This current implementation is specific to unbound workqueues.
+	 * Specifically we only return the first available CPU for a given
+	 * node instead of cycling through individual CPUs within the node.
+	 *
+	 * If this is used with a per-cpu workqueue then the logic in
+	 * workqueue_select_cpu_near would need to be updated to allow for
+	 * some round robin type logic.
+	 */
+	WARN_ON_ONCE(!(wq->flags & WQ_UNBOUND));
+
+	local_irq_save(flags);
+
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
+		int cpu = workqueue_select_cpu_near(node);
+
+		__queue_work(cpu, wq, work);
+		ret = true;
+	}
+
+	local_irq_restore(flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(queue_work_node);
+
 void delayed_work_timer_fn(struct timer_list *t)
 {
 	struct delayed_work *dwork = from_timer(dwork, t, timer);
