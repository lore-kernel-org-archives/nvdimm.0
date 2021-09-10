Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09BBF3FC3
	for <nvdimm@lists.linux.dev>; Fri, 10 Sep 2021 12:46:44 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66B256D;
	Fri, 10 Sep 2021 05:46:38 -0700 (PDT)
Received: from entos-ampere-02.shanghai.arm.com (entos-ampere-02.shanghai.arm.com [10.169.214.103])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 10A973F5A1;
	Fri, 10 Sep 2021 05:46:35 -0700 (PDT)
From: Jia He <justin.he@arm.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	David Hildenbrand <david@redhat.com>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH v2] device-dax: use fallback nid when numa node is invalid
Date: Fri, 10 Sep 2021 20:46:28 +0800
Message-Id: <20210910124628.6261-1-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Previously, numa_off was set unconditionally in dummy_numa_init()
even with a fake numa node. Then ACPI sets node id as NUMA_NO_NODE(-1)
after acpi_map_pxm_to_node() because it regards numa_off as turning
off the numa node. Hence dev_dax->target_node is NUMA_NO_NODE on
arm64 with fake numa case.

Without this patch, pmem can't be probed as RAM devices on arm64 if
SRAT table isn't present:
  $ndctl create-namespace -fe namespace0.0 --mode=devdax --map=dev -s 1g -a 64K
  kmem dax0.0: rejecting DAX region [mem 0x240400000-0x2bfffffff] with invalid node: -1
  kmem: probe of dax0.0 failed with error -22

This fixes it by using fallback memory_add_physaddr_to_nid() as nid.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Jia He <justin.he@arm.com>
---
v2: - rebase it based on David's "memory group" patch.
    - drop the changes in dev_dax_kmem_remove() since nid had been 
      removed in remove_memory().
 drivers/dax/kmem.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a37622060fff..e4836eb7539e 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -47,20 +47,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	unsigned long total_len = 0;
 	struct dax_kmem_data *data;
 	int i, rc, mapped = 0;
-	int numa_node;
-
-	/*
-	 * Ensure good NUMA information for the persistent memory.
-	 * Without this check, there is a risk that slow memory
-	 * could be mixed in a node with faster memory, causing
-	 * unavoidable performance issues.
-	 */
-	numa_node = dev_dax->target_node;
-	if (numa_node < 0) {
-		dev_warn(dev, "rejecting DAX region with invalid node: %d\n",
-				numa_node);
-		return -EINVAL;
-	}
+	int numa_node = dev_dax->target_node;
 
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
@@ -71,6 +58,22 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 					i, range.start, range.end);
 			continue;
 		}
+
+		/*
+		 * Ensure good NUMA information for the persistent memory.
+		 * Without this check, there is a risk but not fatal that slow
+		 * memory could be mixed in a node with faster memory, causing
+		 * unavoidable performance issues. Warn this and use fallback
+		 * node id.
+		 */
+		if (numa_node < 0) {
+			int new_node = memory_add_physaddr_to_nid(range.start);
+
+			dev_info(dev, "changing nid from %d to %d for DAX region [%#llx-%#llx]\n",
+				 numa_node, new_node, range.start, range.end);
+			numa_node = new_node;
+		}
+
 		total_len += range_len(&range);
 	}
 
-- 
2.17.1

