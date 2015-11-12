Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2] libnvdimm,
 e820: fix numa node for e820-type-12 pmem ranges
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Nov 2015 09:53:42 -0800
Message-ID: <20151112175215.2462.69420.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org, Boaz Harrosh <boaz@plexistor.com>, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Rather than punt on the numa node for these e820 ranges try to find a
better answer with memory_add_physaddr_to_nid() when it is available.

Cc: <stable@vger.kernel.org>
Reported-by: Boaz Harrosh <boaz@plexistor.com>
Tested-by: Boaz Harrosh <boaz@plexistor.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Only change from the original version is a compile fix for the
CONFIG_MEMORY_HOTPLUG=n case.

 drivers/nvdimm/e820.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
index 8282db2ef99e..b0045a505dc8 100644
--- a/drivers/nvdimm/e820.c
+++ b/drivers/nvdimm/e820.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2015, Intel Corporation.
  */
 #include <linux/platform_device.h>
+#include <linux/memory_hotplug.h>
 #include <linux/libnvdimm.h>
 #include <linux/module.h>
 
@@ -25,6 +26,18 @@ static int e820_pmem_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+static int e820_range_to_nid(resource_size_t addr)
+{
+	return memory_add_physaddr_to_nid(addr);
+}
+#else
+static int e820_range_to_nid(resource_size_t addr)
+{
+	return NUMA_NO_NODE;
+}
+#endif
+
 static int e820_pmem_probe(struct platform_device *pdev)
 {
 	static struct nvdimm_bus_descriptor nd_desc;
@@ -48,7 +61,7 @@ static int e820_pmem_probe(struct platform_device *pdev)
 		memset(&ndr_desc, 0, sizeof(ndr_desc));
 		ndr_desc.res = p;
 		ndr_desc.attr_groups = e820_pmem_region_attribute_groups;
-		ndr_desc.numa_node = NUMA_NO_NODE;
+		ndr_desc.numa_node = e820_range_to_nid(p->start);
 		set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
 		if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
 			goto err;

