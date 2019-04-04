Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F2E04211F2696
 for <linux-nvdimm@lists.01.org>; Thu,  4 Apr 2019 12:21:18 -0700 (PDT)
Subject: [RFC PATCH 2/5] lib/memregion: Uplevel the pmem "region" ida to a
 global allocator
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 04 Apr 2019 12:08:38 -0700
Message-ID: <155440491849.3190322.17551464505265122881.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for handling platform differentiated memory types beyond
persistent memory, uplevel the "region" identifier to a global number
space. This enables a device-dax instance to be registered to any memory
type with guaranteed unique names.

Cc: Keith Busch <keith.busch@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/Kconfig       |    1 +
 drivers/nvdimm/core.c        |    1 -
 drivers/nvdimm/nd-core.h     |    1 -
 drivers/nvdimm/region_devs.c |   13 ++++---------
 include/linux/memregion.h    |    6 ++++++
 lib/Kconfig                  |    6 ++++++
 lib/Makefile                 |    1 +
 lib/memregion.c              |   22 ++++++++++++++++++++++
 8 files changed, 40 insertions(+), 11 deletions(-)
 create mode 100644 include/linux/memregion.h
 create mode 100644 lib/memregion.c

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 5e27918e4624..bf26cc5f6d67 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -3,6 +3,7 @@ menuconfig LIBNVDIMM
 	depends on PHYS_ADDR_T_64BIT
 	depends on HAS_IOMEM
 	depends on BLK_DEV
+	select MEMREGION
 	help
 	  Generic support for non-volatile memory devices including
 	  ACPI-6-NFIT defined resources.  On platforms that define an
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index acce050856a8..75fe651d327d 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -463,7 +463,6 @@ static __exit void libnvdimm_exit(void)
 	nd_region_exit();
 	nvdimm_exit();
 	nvdimm_bus_exit();
-	nd_region_devs_exit();
 	nvdimm_devs_exit();
 }
 
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index e5ffd5733540..17561302dfec 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -133,7 +133,6 @@ struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
 int __init nvdimm_bus_init(void);
 void nvdimm_bus_exit(void);
 void nvdimm_devs_exit(void);
-void nd_region_devs_exit(void);
 void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 struct nd_region;
 void nd_region_create_ns_seed(struct nd_region *nd_region);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index b4ef7d9ff22e..eefdfd2565dd 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -11,6 +11,7 @@
  * General Public License for more details.
  */
 #include <linux/scatterlist.h>
+#include <linux/memregion.h>
 #include <linux/highmem.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -27,7 +28,6 @@
  */
 #include <linux/io-64-nonatomic-hi-lo.h>
 
-static DEFINE_IDA(region_ida);
 static DEFINE_PER_CPU(int, flush_idx);
 
 static int nvdimm_map_flush(struct device *dev, struct nvdimm *nvdimm, int dimm,
@@ -141,7 +141,7 @@ static void nd_region_release(struct device *dev)
 		put_device(&nvdimm->dev);
 	}
 	free_percpu(nd_region->lane);
-	ida_simple_remove(&region_ida, nd_region->id);
+	memregion_free(nd_region->id);
 	if (is_nd_blk(dev))
 		kfree(to_nd_blk_region(dev));
 	else
@@ -1036,7 +1036,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 
 	if (!region_buf)
 		return NULL;
-	nd_region->id = ida_simple_get(&region_ida, 0, 0, GFP_KERNEL);
+	nd_region->id = memregion_alloc();
 	if (nd_region->id < 0)
 		goto err_id;
 
@@ -1090,7 +1090,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	return nd_region;
 
  err_percpu:
-	ida_simple_remove(&region_ida, nd_region->id);
+	memregion_free(nd_region->id);
  err_id:
 	kfree(region_buf);
 	return NULL;
@@ -1237,8 +1237,3 @@ int nd_region_conflict(struct nd_region *nd_region, resource_size_t start,
 
 	return device_for_each_child(&nvdimm_bus->dev, &ctx, region_conflict);
 }
-
-void __exit nd_region_devs_exit(void)
-{
-	ida_destroy(&region_ida);
-}
diff --git a/include/linux/memregion.h b/include/linux/memregion.h
new file mode 100644
index 000000000000..99fa47793b49
--- /dev/null
+++ b/include/linux/memregion.h
@@ -0,0 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef _MEMREGION_H_
+#define _MEMREGION_H_
+int memregion_alloc(void);
+void memregion_free(int id);
+#endif /* _MEMREGION_H_ */
diff --git a/lib/Kconfig b/lib/Kconfig
index a9e56539bd11..0b765d9a1145 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -318,6 +318,12 @@ config DECOMPRESS_LZ4
 config GENERIC_ALLOCATOR
 	bool
 
+#
+# Generic IDA for memory regions
+#
+config MEMREGION
+	bool
+
 #
 # reed solomon support is select'ed if needed
 #
diff --git a/lib/Makefile b/lib/Makefile
index 3b08673e8881..6e237c4071af 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -122,6 +122,7 @@ obj-$(CONFIG_LIBCRC32C)	+= libcrc32c.o
 obj-$(CONFIG_CRC8)	+= crc8.o
 obj-$(CONFIG_XXHASH)	+= xxhash.o
 obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
+obj-$(CONFIG_MEMREGION) += memregion.o
 
 obj-$(CONFIG_842_COMPRESS) += 842/
 obj-$(CONFIG_842_DECOMPRESS) += 842/
diff --git a/lib/memregion.c b/lib/memregion.c
new file mode 100644
index 000000000000..21f5ff96c2eb
--- /dev/null
+++ b/lib/memregion.c
@@ -0,0 +1,22 @@
+#include <linux/idr.h>
+#include <linux/module.h>
+
+static DEFINE_IDA(region_ida);
+
+int memregion_alloc(void)
+{
+	return ida_simple_get(&region_ida, 0, 0, GFP_KERNEL);
+}
+EXPORT_SYMBOL(memregion_alloc);
+
+void memregion_free(int id)
+{
+	ida_simple_remove(&region_ida, id);
+}
+EXPORT_SYMBOL(memregion_free);
+
+static void __exit memregion_exit(void)
+{
+	ida_destroy(&region_ida);
+}
+module_exit(memregion_exit);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
