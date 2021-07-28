Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6153481
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 08:22:46 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16686101E;
	Wed, 28 Jul 2021 01:22:40 -0700 (PDT)
Received: from entos-ampere-02.shanghai.arm.com (entos-ampere-02.shanghai.arm.com [10.169.214.103])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B71EC3F73D;
	Wed, 28 Jul 2021 01:22:37 -0700 (PDT)
From: Jia He <justin.he@arm.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	nd@arm.com,
	Jia He <justin.he@arm.com>
Subject: [PATCH] device-dax: use fallback nid when numa_node is invalid
Date: Wed, 28 Jul 2021 16:22:26 +0800
Message-Id: <20210728082226.22161-2-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210728082226.22161-1-justin.he@arm.com>
References: <20210728082226.22161-1-justin.he@arm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Previously, numa_off was set unconditionally in dummy_numa_init()
even with a fake numa node. Then ACPI set node id as NUMA_NO_NODE(-1)
after acpi_map_pxm_to_node() because it regards numa_off as turning
off the numa node. Hence dev_dax->target_node is NUMA_NO_NODE on
arm64 with fake numa.

Without this patch, pmem can't be probed as a RAM device on arm64 if
SRAT table isn't present:
  $ndctl create-namespace -fe namespace0.0 --mode=devdax --map=dev -s 1g -a 64K
  kmem dax0.0: rejecting DAX region [mem 0x240400000-0x2bfffffff] with invalid node: -1
  kmem: probe of dax0.0 failed with error -22

This fixes it by using fallback memory_add_physaddr_to_nid() as nid.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Jia He <justin.he@arm.com>
---
 drivers/dax/kmem.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index ac231cc36359..749674909e51 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -46,20 +46,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	struct dax_kmem_data *data;
 	int rc = -ENOMEM;
 	int i, mapped = 0;
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
+	int numa_node = dev_dax->target_node, new_node;
 
 	data = kzalloc(struct_size(data, res, dev_dax->nr_range), GFP_KERNEL);
 	if (!data)
@@ -104,6 +91,20 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		 */
 		res->flags = IORESOURCE_SYSTEM_RAM;
 
+		/*
+		 * Ensure good NUMA information for the persistent memory.
+		 * Without this check, there is a risk but not fatal that slow
+		 * memory could be mixed in a node with faster memory, causing
+		 * unavoidable performance issues. Furthermore, fallback node
+		 * id can be used when numa_node is invalid.
+		 */
+		if (numa_node < 0) {
+			new_node = memory_add_physaddr_to_nid(range.start);
+			dev_info(dev, "changing nid from %d to %d for DAX region %pR\n",
+				numa_node, new_node, res);
+			numa_node = new_node;
+		}
+
 		/*
 		 * Ensure that future kexec'd kernels will not treat
 		 * this as RAM automatically.
@@ -141,6 +142,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 	int i, success = 0;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	int numa_node = dev_dax->target_node;
 
 	/*
 	 * We have one shot for removing memory, if some memory blocks were not
@@ -156,8 +158,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 		if (rc)
 			continue;
 
-		rc = remove_memory(dev_dax->target_node, range.start,
-				range_len(&range));
+		if (numa_node < 0)
+			numa_node = memory_add_physaddr_to_nid(range.start);
+
+		rc = remove_memory(numa_node, range.start, range_len(&range));
 		if (rc == 0) {
 			release_resource(data->res[i]);
 			kfree(data->res[i]);
-- 
2.17.1

