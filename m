Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 14/17] acpi: Add acpi_map_pxm_to_online_node()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jun 2015 05:37:33 -0400
Message-ID: <20150625093733.40066.13320.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, boaz@plexistor.com, toshi.kani@hp.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

From: Toshi Kani <toshi.kani@hp.com>

The kernel initializes CPU & memory's NUMA topology from ACPI
SRAT table.  Some other ACPI tables, such as NFIT and DMAR, also
contain proximity IDs for their device's NUMA topology.  This
information can be used to improve performance of these devices.

This patch introduces acpi_map_pxm_to_online_node(), which is
similar to acpi_map_pxm_to_node(), but always returns an online
node.  When the mapped node from a given proximity ID is offline,
it looks up the node distance table and returns the nearest
online node.

ACPI device drivers, which are called after the NUMA initialization
has completed in the kernel, can call this interface to obtain their
device NUMA topology from ACPI tables.  Such drivers do not have to
deal with offline nodes.  A node may be offline when a device
proximity ID is unique, SRAT memory entry does not exist, or NUMA is
disabled, ex. "numa=off" on x86.

This patch also moves the pxm range check from acpi_get_node() to
acpi_map_pxm_to_node().

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/numa.c  |   50 +++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/acpi.h |    5 +++++
 2 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 1333cbdc3ea2..acaa3b4ea504 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -29,6 +29,8 @@
 #include <linux/errno.h>
 #include <linux/acpi.h>
 #include <linux/numa.h>
+#include <linux/nodemask.h>
+#include <linux/topology.h>
 
 #define PREFIX "ACPI: "
 
@@ -70,7 +72,12 @@ static void __acpi_map_pxm_to_node(int pxm, int node)
 
 int acpi_map_pxm_to_node(int pxm)
 {
-	int node = pxm_to_node_map[pxm];
+	int node;
+
+	if (pxm < 0 || pxm >= MAX_PXM_DOMAINS)
+		return NUMA_NO_NODE;
+
+	node = pxm_to_node_map[pxm];
 
 	if (node == NUMA_NO_NODE) {
 		if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
@@ -83,6 +90,45 @@ int acpi_map_pxm_to_node(int pxm)
 	return node;
 }
 
+/**
+ * acpi_map_pxm_to_online_node - Map proximity ID to online node
+ * @pxm: ACPI proximity ID
+ *
+ * This is similar to acpi_map_pxm_to_node(), but always returns an online
+ * node.  When the mapped node from a given proximity ID is offline, it
+ * looks up the node distance table and returns the nearest online node.
+ *
+ * ACPI device drivers, which are called after the NUMA initialization has
+ * completed in the kernel, can call this interface to obtain their device
+ * NUMA topology from ACPI tables.  Such drivers do not have to deal with
+ * offline nodes.  A node may be offline when a device proximity ID is
+ * unique, SRAT memory entry does not exist, or NUMA is disabled, ex.
+ * "numa=off" on x86.
+ */
+int acpi_map_pxm_to_online_node(int pxm)
+{
+	int node, n, dist, min_dist;
+
+	node = acpi_map_pxm_to_node(pxm);
+
+	if (node == NUMA_NO_NODE)
+		node = 0;
+
+	if (!node_online(node)) {
+		min_dist = INT_MAX;
+		for_each_online_node(n) {
+			dist = node_distance(node, n);
+			if (dist < min_dist) {
+				min_dist = dist;
+				node = n;
+			}
+		}
+	}
+
+	return node;
+}
+EXPORT_SYMBOL(acpi_map_pxm_to_online_node);
+
 static void __init
 acpi_table_print_srat_entry(struct acpi_subtable_header *header)
 {
@@ -328,8 +374,6 @@ int acpi_get_node(acpi_handle handle)
 	int pxm;
 
 	pxm = acpi_get_pxm(handle);
-	if (pxm < 0 || pxm >= MAX_PXM_DOMAINS)
-		return NUMA_NO_NODE;
 
 	return acpi_map_pxm_to_node(pxm);
 }
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index e4da5e35e29c..1b3bbb11d11c 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -289,8 +289,13 @@ extern void acpi_dmi_osi_linux(int enable, const struct dmi_system_id *d);
 extern void acpi_osi_setup(char *str);
 
 #ifdef CONFIG_ACPI_NUMA
+int acpi_map_pxm_to_online_node(int pxm);
 int acpi_get_node(acpi_handle handle);
 #else
+static inline int acpi_map_pxm_to_online_node(int pxm)
+{
+	return 0;
+}
 static inline int acpi_get_node(acpi_handle handle)
 {
 	return 0;

