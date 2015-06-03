Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 1/3] acpi: Fix acpi_map_pxm_to_node() to handle numa_off
Date: Tue,  2 Jun 2015 18:26:50 -0600
Message-Id: <1433291212-23367-2-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1433291212-23367-1-git-send-email-toshi.kani@hp.com>
References: <1433291212-23367-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, dan.j.williams@intel.com
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

When numa_off is set, NUMA is turned off and node 0 is the only
valid node on the system.  The kernel skips parsing ACPI SRAT
table in this case.

Change acpi_map_pxm_to_node() to always return 0 when numa_off
is set.  Also move the range check of a proximity ID from
acpi_get_node() to acpi_map_pxm_to_node() after the numa_off
check.  This keeps the interfaces to return 0 regardless of
proximity ID values.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/numa.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 1333cbdc..4898082 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -70,7 +70,15 @@ static void __acpi_map_pxm_to_node(int pxm, int node)
 
 int acpi_map_pxm_to_node(int pxm)
 {
-	int node = pxm_to_node_map[pxm];
+	int node;
+
+	if (numa_off)
+		return 0;
+
+	if (pxm < 0 || pxm >= MAX_PXM_DOMAINS)
+		return NUMA_NO_NODE;
+
+	node = pxm_to_node_map[pxm];
 
 	if (node == NUMA_NO_NODE) {
 		if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
@@ -328,8 +336,6 @@ int acpi_get_node(acpi_handle handle)
 	int pxm;
 
 	pxm = acpi_get_pxm(handle);
-	if (pxm < 0 || pxm >= MAX_PXM_DOMAINS)
-		return NUMA_NO_NODE;
 
 	return acpi_map_pxm_to_node(pxm);
 }
