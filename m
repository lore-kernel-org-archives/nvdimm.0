Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C831220C2A5A
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 20:11:18 -0700 (PDT)
Subject: [PATCH] acpi, numa: fix pxm to online numa node associations
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Mar 2018 20:08:37 -0700
Message-ID: <152116964416.8343.514895686858363582.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Toshi Kani <toshi.kani@hp.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Commit 99759869faf1 "acpi: Add acpi_map_pxm_to_online_node()" added
support for mapping a given proximity to its nearest, by SLIT distance,
online node. However, it sometimes returns unexpected results due to the
fact that it switches from comparing the PXM node to the last node that
was closer than the current max.

    for_each_online_node(n) {
            dist = node_distance(node, n);
            if (dist < min_dist) {
                    min_dist = dist;
                    node = n;	<---- from this point we're using the
				      wrong node for node_distance()


Fixes: 99759869faf1 ("acpi: Add acpi_map_pxm_to_online_node()")
Cc: <stable@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Rafael, I can take this through the nvdimm tree with your ack. I have a
few other nvdimm fixes pending for 4.16.

 drivers/acpi/numa.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 8ccaae3550d2..85167603b9c9 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -103,25 +103,27 @@ int acpi_map_pxm_to_node(int pxm)
  */
 int acpi_map_pxm_to_online_node(int pxm)
 {
-	int node, n, dist, min_dist;
+	int node, min_node;
 
 	node = acpi_map_pxm_to_node(pxm);
 
 	if (node == NUMA_NO_NODE)
 		node = 0;
 
+	min_node = node;
 	if (!node_online(node)) {
-		min_dist = INT_MAX;
+		int min_dist = INT_MAX, dist, n;
+
 		for_each_online_node(n) {
 			dist = node_distance(node, n);
 			if (dist < min_dist) {
 				min_dist = dist;
-				node = n;
+				min_node = n;
 			}
 		}
 	}
 
-	return node;
+	return min_node;
 }
 EXPORT_SYMBOL(acpi_map_pxm_to_online_node);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
