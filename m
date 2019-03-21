Return-Path: <owner-linux-mm@kvack.org>
From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH 1/5] node: Define and export memory migration path
Date: Thu, 21 Mar 2019 14:01:53 -0600
Message-Id: <20190321200157.29678-2-keith.busch@intel.com>
In-Reply-To: <20190321200157.29678-1-keith.busch@intel.com>
References: <20190321200157.29678-1-keith.busch@intel.com>
Sender: owner-linux-mm@kvack.org
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org
Cc: Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Prepare for the kernel to auto-migrate pages to other memory nodes with a
user defined node migration table. A user may create a single target for
each NUMA node to enable the kernel to do NUMA page migrations instead
of simply reclaiming colder pages. A node with no target is a "terminal
node", so reclaim acts normally there.  The migration target does not
fundamentally _need_ to be a single node, but this implementation starts
there to limit complexity.

If you consider the migration path as a graph, cycles (loops) in the graph
are disallowed.  This avoids wasting resources by constantly migrating
(A->B, B->A, A->B ...).  The expectation is that cycles will never be
allowed.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 Documentation/ABI/stable/sysfs-devices-node | 11 ++++-
 drivers/base/node.c                         | 73 +++++++++++++++++++++++++++++
 include/linux/node.h                        |  6 +++
 3 files changed, 89 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
index 3e90e1f3bf0a..7439e1845e5d 100644
--- a/Documentation/ABI/stable/sysfs-devices-node
+++ b/Documentation/ABI/stable/sysfs-devices-node
@@ -90,4 +90,13 @@ Date:		December 2009
 Contact:	Lee Schermerhorn <lee.schermerhorn@hp.com>
 Description:
 		The node's huge page size control/query attributes.
-		See Documentation/admin-guide/mm/hugetlbpage.rst
\ No newline at end of file
+		See Documentation/admin-guide/mm/hugetlbpage.rst
+
+What:		/sys/devices/system/node/nodeX/migration_path
+Data		March 2019
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Defines which node the kernel should attempt to migrate this
+		node's pages to when this node requires memory reclaim. A
+		negative value means this is a terminal node and memory can not
+		be reclaimed through kernel managed migration.
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 86d6cd92ce3d..20a90905555f 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -59,6 +59,10 @@ static inline ssize_t node_read_cpulist(struct device *dev,
 static DEVICE_ATTR(cpumap,  S_IRUGO, node_read_cpumask, NULL);
 static DEVICE_ATTR(cpulist, S_IRUGO, node_read_cpulist, NULL);
 
+#define TERMINAL_NODE -1
+static int node_migration[MAX_NUMNODES] = {[0 ...  MAX_NUMNODES - 1] = TERMINAL_NODE};
+static DEFINE_SPINLOCK(node_migration_lock);
+
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 static ssize_t node_read_meminfo(struct device *dev,
 			struct device_attribute *attr, char *buf)
@@ -233,6 +237,74 @@ static ssize_t node_read_distance(struct device *dev,
 }
 static DEVICE_ATTR(distance, S_IRUGO, node_read_distance, NULL);
 
+static ssize_t migration_path_show(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	return sprintf(buf, "%d\n", node_migration[dev->id]);
+}
+
+static ssize_t migration_path_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	int i, err, nid = dev->id;
+	nodemask_t visited = NODE_MASK_NONE;
+	long next;
+
+	err = kstrtol(buf, 0, &next);
+	if (err)
+		return -EINVAL;
+
+	if (next < 0) {
+		spin_lock(&node_migration_lock);
+		WRITE_ONCE(node_migration[nid], TERMINAL_NODE);
+		spin_unlock(&node_migration_lock);
+		return count;
+	}
+	if (next > MAX_NUMNODES || !node_online(next))
+		return -EINVAL;
+
+	/*
+	 * Follow the entire migration path from 'nid' through the point where
+	 * we hit a TERMINAL_NODE.
+	 *
+	 * Don't allow looped migration cycles in the path.
+	 */
+	node_set(nid, visited);
+	spin_lock(&node_migration_lock);
+	for (i = next; node_migration[i] != TERMINAL_NODE;
+	     i = node_migration[i]) {
+		/* Fail if we have visited this node already */
+		if (node_test_and_set(i, visited)) {
+			spin_unlock(&node_migration_lock);
+			return -EINVAL;
+		}
+	}
+	WRITE_ONCE(node_migration[nid], next);
+	spin_unlock(&node_migration_lock);
+
+	return count;
+}
+static DEVICE_ATTR_RW(migration_path);
+
+/**
+ * next_migration_node() - Get the next node in the migration path
+ * @current_node: The starting node to lookup the next node
+ *
+ * @returns: node id for next memory node in the migration path hierarchy from
+ * 	     @current_node; -1 if @current_node is terminal or its migration
+ * 	     node is not online.
+ */
+int next_migration_node(int current_node)
+{
+	int nid = READ_ONCE(node_migration[current_node]);
+
+	if (nid >= 0 && node_online(nid))
+		return nid;
+	return TERMINAL_NODE;
+}
+
 static struct attribute *node_dev_attrs[] = {
 	&dev_attr_cpumap.attr,
 	&dev_attr_cpulist.attr,
@@ -240,6 +312,7 @@ static struct attribute *node_dev_attrs[] = {
 	&dev_attr_numastat.attr,
 	&dev_attr_distance.attr,
 	&dev_attr_vmstat.attr,
+	&dev_attr_migration_path.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(node_dev);
diff --git a/include/linux/node.h b/include/linux/node.h
index 257bb3d6d014..af46c7a8b94f 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -67,6 +67,7 @@ static inline int register_one_node(int nid)
 	return error;
 }
 
+extern int next_migration_node(int current_node);
 extern void unregister_one_node(int nid);
 extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
@@ -115,6 +116,11 @@ static inline void register_hugetlbfs_with_node(node_registration_func_t reg,
 						node_registration_func_t unreg)
 {
 }
+
+static inline int next_migration_node(int current_node)
+{
+	return -1;
+}
 #endif
 
 #define to_node(device) container_of(device, struct node, dev)
-- 
2.14.4
