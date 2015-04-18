Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 05/21] nfit-test: manufactured NFITs for interface
 development
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Apr 2015 21:35:41 -0400
Message-ID: <20150418013541.25237.36797.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Manually create and register NFITs to describe 2 topologies.  Topology1
is an advanced plausible configuration for BLK/PMEM aliased NVDIMMs.
Topology2 is an example configuration for current platforms that only
ship with a persistent address range.

 Kernel provider "nfit_test.0" produces an NFIT with the following attributes:

                              (a)               (b)           DIMM   BLK-REGION
           +-------------------+--------+--------+--------+
 +------+  |       pm0.0       | blk2.0 | pm1.0  | blk2.1 |    0      region2
 | imc0 +--+- - - region0- - - +--------+        +--------+
 +--+---+  |       pm0.0       | blk3.0 | pm1.0  | blk3.1 |    1      region3
    |      +-------------------+--------v        v--------+
 +--+---+                               |                 |
 | cpu0 |                                     region1
 +--+---+                               |                 |
    |      +----------------------------^        ^--------+
 +--+---+  |           blk4.0           | pm1.0  | blk4.0 |    2      region4
 | imc1 +--+----------------------------|        +--------+
 +------+  |           blk5.0           | pm1.0  | blk5.0 |    3      region5
           +----------------------------+--------+--------+

 *) In this layout we have four dimms and two memory controllers in one
    socket.  Each unique interface ("block" or "pmem") to DPA space
    is identified by a region device with a dynamically assigned id.

 *) The first portion of dimm0 and dimm1 are interleaved as REGION0.
    A single "pmem" namespace is created in the REGION0-"spa"-range
    that spans dimm0 and dimm1 with a user-specified name of "pm0.0".
    Some of that interleaved "spa" range is reclaimed as "bdw"
    accessed space starting at offset (a) into each dimm.  In that
    reclaimed space we create two "bdw" "namespaces" from REGION2 and
    REGION3 where "blk2.0" and "blk3.0" are just human readable names
    that could be set to any user-desired name in the label.

 *) In the last portion of dimm0 and dimm1 we have an interleaved
    "spa" range, REGION1, that spans those two dimms as well as dimm2
    and dimm3.  Some of REGION1 allocated to a "pmem" namespace named
    "pm1.0" the rest is reclaimed in 4 "bdw" namespaces (for each
    dimm in the interleave set), "blk2.1", "blk3.1", "blk4.0", and
    "blk5.0".

 *) The portion of dimm2 and dimm3 that do not participate in the
    REGION1 interleaved "spa" range (i.e. the DPA address below
    offset (b) are also included in the "blk4.0" and "blk5.0"
    namespaces.  Note, that this example shows that "bdw" namespaces
    don't need to be contiguous in DPA-space.

 Kernel provider "nfit_test.1" produces an NFIT with the following attributes:

 region2
 +---------------------+
 |---------------------|
 ||       pm2.0       ||
 |---------------------|
 +---------------------+

 *) Describes a simple system-physical-address range with no backing
    dimm or interleave description.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/Kconfig          |   20 +
 drivers/block/nd/Makefile         |   16 +
 drivers/block/nd/nfit.h           |    9 
 drivers/block/nd/test/Makefile    |    5 
 drivers/block/nd/test/iomap.c     |  148 ++++++
 drivers/block/nd/test/nfit.c      |  930 +++++++++++++++++++++++++++++++++++++
 drivers/block/nd/test/nfit_test.h |   25 +
 7 files changed, 1153 insertions(+)
 create mode 100644 drivers/block/nd/test/Makefile
 create mode 100644 drivers/block/nd/test/iomap.c
 create mode 100644 drivers/block/nd/test/nfit.c
 create mode 100644 drivers/block/nd/test/nfit_test.h

diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
index 5fa74f124b3e..0106b3807202 100644
--- a/drivers/block/nd/Kconfig
+++ b/drivers/block/nd/Kconfig
@@ -41,4 +41,24 @@ config NFIT_ACPI
 	  register the platform-global NFIT blob with the core.  Also
 	  enables the core to craft ACPI._DSM messages for platform/dimm
 	  configuration.
+
+config NFIT_TEST
+	tristate "NFIT TEST: Manufactured NFIT for interface testing"
+	depends on DMA_CMA
+	depends on ND_CORE=m
+	depends on m
+	help
+	  For development purposes register a manufactured
+	  NFIT table to verify the resulting device model topology.
+	  Note, this module arranges for ioremap_cache() to be
+	  overridden locally to allow simulation of system-memory as an
+	  io-memory-resource.
+
+	  Note, this test expects to be able to find at least
+	  256MB of CMA space (CONFIG_CMA_SIZE_MBYTES) or it will fail to
+	  load.  Kconfig does not allow for numerical value
+	  dependencies, so we can only warn at runtime.
+
+	  Say N unless you are doing development of the 'nd' subsystem.
+
 endif
diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index 22701ab7dcae..c6bec0c185c5 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -1,3 +1,19 @@
+obj-$(CONFIG_NFIT_TEST) += test/
+
+ifdef CONFIG_NFIT_TEST
+# This obviously will cause symbol collisions if another
+# driver/sub-system attempts a similar mocked io-memory implementation.
+# When that happens we can either add a 'choice' kconfig option to
+# select one mocked instance at a time, or push for the linker to
+# include an option of the form "--wrap-prefix=<prefix>" to allow for
+# separate namespaces of mocked functions.
+ldflags-y += --wrap=ioremap_cache
+ldflags-y += --wrap=ioremap_nocache
+ldflags-y += --wrap=iounmap
+ldflags-y += --wrap=__request_region
+ldflags-y += --wrap=__release_region
+endif
+
 obj-$(CONFIG_ND_CORE) += nd.o
 obj-$(CONFIG_NFIT_ACPI) += nd_acpi.o
 
diff --git a/drivers/block/nd/nfit.h b/drivers/block/nd/nfit.h
index 72c317d04cb2..75b480f6ff03 100644
--- a/drivers/block/nd/nfit.h
+++ b/drivers/block/nd/nfit.h
@@ -123,6 +123,15 @@ struct nfit_mem {
 	__le16 reserved;
 } __packed;
 
+#define NFIT_DIMM_HANDLE(node, socket, imc, chan, dimm) \
+	(((node & 0xfff) << 16) | ((socket & 0xf) << 12) \
+	 | ((imc & 0xf) << 8) | ((chan & 0xf) << 4) | (dimm & 0xf))
+#define NFIT_DIMM_NODE(handle) ((handle) >> 16 & 0xfff)
+#define NFIT_DIMM_SOCKET(handle) ((handle) >> 12 & 0xf)
+#define NFIT_DIMM_CHAN(handle) ((handle) >> 8 & 0xf)
+#define NFIT_DIMM_IMC(handle) ((handle) >> 4 & 0xf)
+#define NFIT_DIMM_DIMM(handle) ((handle) & 0xf)
+
 /**
  * struct nfit_idt - Interleave description Table
  */
diff --git a/drivers/block/nd/test/Makefile b/drivers/block/nd/test/Makefile
new file mode 100644
index 000000000000..c7f319cbd082
--- /dev/null
+++ b/drivers/block/nd/test/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_NFIT_TEST) += nfit_test.o
+obj-$(CONFIG_NFIT_TEST) += nfit_test_iomap.o
+
+nfit_test-y := nfit.o
+nfit_test_iomap-y := iomap.o
diff --git a/drivers/block/nd/test/iomap.c b/drivers/block/nd/test/iomap.c
new file mode 100644
index 000000000000..87e6a1255237
--- /dev/null
+++ b/drivers/block/nd/test/iomap.c
@@ -0,0 +1,148 @@
+/*
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/rculist.h>
+#include <linux/export.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/io.h>
+#include "nfit_test.h"
+
+static LIST_HEAD(iomap_head);
+
+static struct iomap_ops {
+	nfit_test_lookup_fn nfit_test_lookup;
+	struct list_head list;
+} iomap_ops;
+
+void nfit_test_setup(nfit_test_lookup_fn lookup)
+{
+	iomap_ops.nfit_test_lookup = lookup;
+	INIT_LIST_HEAD(&iomap_ops.list);
+	list_add_rcu(&iomap_ops.list, &iomap_head);
+}
+EXPORT_SYMBOL(nfit_test_setup);
+
+void nfit_test_teardown(void)
+{
+	list_del_rcu(&iomap_ops.list);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL(nfit_test_teardown);
+
+static struct nfit_test_resource *get_nfit_res(resource_size_t resource)
+{
+	struct iomap_ops *ops;
+
+	ops = list_first_or_null_rcu(&iomap_head, typeof(*ops), list);
+	if (ops)
+		return ops->nfit_test_lookup(resource);
+	return NULL;
+}
+
+void __iomem *__nfit_test_ioremap(resource_size_t offset, unsigned long size,
+		void __iomem *(*fallback_fn)(resource_size_t, unsigned long))
+{
+	struct nfit_test_resource *nfit_res;
+
+	rcu_read_lock();
+	nfit_res = get_nfit_res(offset);
+	rcu_read_unlock();
+	if (nfit_res)
+		return (void __iomem *) nfit_res->buf + offset
+			- nfit_res->res->start;
+	return fallback_fn(offset, size);
+}
+
+void __iomem *__wrap_ioremap_cache(resource_size_t offset, unsigned long size)
+{
+	return __nfit_test_ioremap(offset, size, ioremap_cache);
+}
+EXPORT_SYMBOL(__wrap_ioremap_cache);
+
+void __iomem *__wrap_ioremap_nocache(resource_size_t offset, unsigned long size)
+{
+	return __nfit_test_ioremap(offset, size, ioremap_nocache);
+}
+EXPORT_SYMBOL(__wrap_ioremap_nocache);
+
+void __wrap_iounmap(volatile void __iomem *addr)
+{
+	struct nfit_test_resource *nfit_res;
+
+	rcu_read_lock();
+	nfit_res = get_nfit_res((unsigned long) addr);
+	rcu_read_unlock();
+	if (nfit_res)
+		return;
+	return iounmap(addr);
+}
+EXPORT_SYMBOL(__wrap_iounmap);
+
+struct resource *__wrap___request_region(struct resource *parent,
+		resource_size_t start, resource_size_t n, const char *name,
+		int flags)
+{
+	struct nfit_test_resource *nfit_res;
+
+	if (parent == &iomem_resource) {
+		rcu_read_lock();
+		nfit_res = get_nfit_res(start);
+		rcu_read_unlock();
+		if (nfit_res) {
+			struct resource *res = nfit_res->res + 1;
+
+			if (start + n > nfit_res->res->start
+					+ resource_size(nfit_res->res)) {
+				pr_debug("%s: start: %llx n: %llx overflow: %pr\n",
+						__func__, start, n,
+						nfit_res->res);
+				return NULL;
+			}
+
+			res->start = start;
+			res->end = start + n - 1;
+			res->name = name;
+			res->flags = resource_type(parent);
+			res->flags |= IORESOURCE_BUSY | flags;
+			pr_debug("%s: %pr\n", __func__, res);
+			return res;
+		}
+	}
+	return __request_region(parent, start, n, name, flags);
+}
+EXPORT_SYMBOL(__wrap___request_region);
+
+void __wrap___release_region(struct resource *parent, resource_size_t start,
+				resource_size_t n)
+{
+	struct nfit_test_resource *nfit_res;
+
+	rcu_read_lock();
+	nfit_res = get_nfit_res(start);
+	if (nfit_res) {
+		struct resource *res = nfit_res->res + 1;
+
+		if (start != res->start || resource_size(res) != n)
+			pr_info("%s: start: %llx n: %llx mismatch: %pr\n",
+					__func__, start, n, res);
+		else
+			memset(res, 0, sizeof(*res));
+	}
+	rcu_read_unlock();
+	if (!nfit_res)
+		__release_region(parent, start, n);
+}
+EXPORT_SYMBOL(__wrap___release_region);
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/block/nd/test/nfit.c b/drivers/block/nd/test/nfit.c
new file mode 100644
index 000000000000..61227dec111a
--- /dev/null
+++ b/drivers/block/nd/test/nfit.c
@@ -0,0 +1,930 @@
+/*
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include "nfit_test.h"
+#include "../nfit.h"
+
+#include <asm-generic/io-64-nonatomic-lo-hi.h>
+
+/*
+ * Generate an NFIT table to describe the following topology:
+ *
+ * BUS0: Interleaved PMEM regions, and aliasing with BLK regions
+ *
+ *                     (a)                       (b)            DIMM   BLK-REGION
+ *           +----------+--------------+----------+---------+
+ * +------+  |  blk2.0  |     pm0.0    |  blk2.1  |  pm1.0  |    0      region2
+ * | imc0 +--+- - - - - region0 - - - -+----------+         +
+ * +--+---+  |  blk3.0  |     pm0.0    |  blk3.1  |  pm1.0  |    1      region3
+ *    |      +----------+--------------v----------v         v
+ * +--+---+                            |                    |
+ * | cpu0 |                                    region1
+ * +--+---+                            |                    |
+ *    |      +-------------------------^----------^         ^
+ * +--+---+  |                 blk4.0             |  pm1.0  |    2      region4
+ * | imc1 +--+-------------------------+----------+         +
+ * +------+  |                 blk5.0             |  pm1.0  |    3      region5
+ *           +-------------------------+----------+-+-------+
+ *
+ * *) In this layout we have four dimms and two memory controllers in one
+ *    socket.  Each unique interface (BLK or PMEM) to DPA space
+ *    is identified by a region device with a dynamically assigned id.
+ *
+ * *) The first portion of dimm0 and dimm1 are interleaved as REGION0.
+ *    A single PMEM namespace "pm0.0" is created using half of the
+ *    REGION0 SPA-range.  REGION0 spans dimm0 and dimm1.  PMEM namespace
+ *    allocate from from the bottom of a region.  The unallocated
+ *    portion of REGION0 aliases with REGION2 and REGION3.  That
+ *    unallacted capacity is reclaimed as BLK namespaces ("blk2.0" and
+ *    "blk3.0") starting at the base of each DIMM to offset (a) in those
+ *    DIMMs.  "pm0.0", "blk2.0" and "blk3.0" are free-form readable
+ *    names that can be assigned to a namespace.
+ *
+ * *) In the last portion of dimm0 and dimm1 we have an interleaved
+ *    SPA range, REGION1, that spans those two dimms as well as dimm2
+ *    and dimm3.  Some of REGION1 allocated to a PMEM namespace named
+ *    "pm1.0" the rest is reclaimed in 4 BLK namespaces (for each
+ *    dimm in the interleave set), "blk2.1", "blk3.1", "blk4.0", and
+ *    "blk5.0".
+ *
+ * *) The portion of dimm2 and dimm3 that do not participate in the
+ *    REGION1 interleaved SPA range (i.e. the DPA address below offset
+ *    (b) are also included in the "blk4.0" and "blk5.0" namespaces.
+ *    Note, that BLK namespaces need not be contiguous in DPA-space, and
+ *    can consume aliased capacity from multiple interleave sets.
+ *
+ * BUS1: Legacy NVDIMM (single contiguous range)
+ *
+ *  region2
+ * +---------------------+
+ * |---------------------|
+ * ||       pm2.0       ||
+ * |---------------------|
+ * +---------------------+
+ *
+ * *) A NFIT-table may describe a simple system-physical-address range
+ *    with no backing dimm or interleave description.
+ */
+enum {
+	NUM_PM  = 2,
+	NUM_DCR = 4,
+	NUM_BDW = NUM_DCR,
+	NUM_SPA = NUM_PM + NUM_DCR + NUM_BDW,
+	NUM_MEM = NUM_DCR + NUM_BDW + 2 /* spa0 iset */ + 4 /* spa1 iset */,
+	DIMM_SIZE = SZ_32M,
+	LABEL_SIZE = SZ_128K,
+	SPA0_SIZE = DIMM_SIZE,
+	SPA1_SIZE = DIMM_SIZE*2,
+	SPA2_SIZE = DIMM_SIZE,
+	BDW_SIZE = 64 << 8,
+	DCR_SIZE = 12,
+	NUM_NFITS = 2, /* permit testing multiple NFITs per system */
+};
+
+struct nfit_test_dcr {
+	__le64 bdw_addr;
+	__le32 bdw_status;
+	__u8 aperature[BDW_SIZE];
+};
+
+static u32 handle[NUM_DCR] = {
+	[0] = NFIT_DIMM_HANDLE(0, 0, 0, 0, 0),
+	[1] = NFIT_DIMM_HANDLE(0, 0, 0, 0, 1),
+	[2] = NFIT_DIMM_HANDLE(0, 0, 1, 0, 0),
+	[3] = NFIT_DIMM_HANDLE(0, 0, 1, 0, 1),
+};
+
+struct nfit_test {
+	struct nfit_bus_descriptor nfit_desc;
+	struct platform_device pdev;
+	struct list_head resources;
+	void __iomem *nfit_buf;
+	struct nd_bus *nd_bus;
+	dma_addr_t nfit_dma;
+	size_t nfit_size;
+	int num_dcr;
+	int num_pm;
+	void **dimm;
+	dma_addr_t *dimm_dma;
+	void **label;
+	dma_addr_t *label_dma;
+	void **spa_set;
+	dma_addr_t *spa_set_dma;
+	struct nfit_test_dcr **dcr;
+	dma_addr_t *dcr_dma;
+	int (*alloc)(struct nfit_test *t);
+	void (*setup)(struct nfit_test *t);
+};
+
+static struct nfit_test *to_nfit_test(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	return container_of(pdev, struct nfit_test, pdev);
+}
+
+static int nfit_test_ctl(struct nfit_bus_descriptor *nfit_desc,
+		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
+		unsigned int buf_len)
+{
+	return -ENOTTY;
+}
+
+static DEFINE_SPINLOCK(nfit_test_lock);
+static struct nfit_test *instances[NUM_NFITS];
+
+static void *alloc_coherent(struct nfit_test *t, size_t size, dma_addr_t *dma)
+{
+	struct device *dev = &t->pdev.dev;
+	struct resource *res = devm_kzalloc(dev, sizeof(*res) * 2, GFP_KERNEL);
+	void *buf = dmam_alloc_coherent(dev, size, dma, GFP_KERNEL);
+	struct nfit_test_resource *nfit_res = devm_kzalloc(dev,
+			sizeof(*nfit_res), GFP_KERNEL);
+
+	if (!res || !buf || !nfit_res)
+		return NULL;
+	INIT_LIST_HEAD(&nfit_res->list);
+	memset(buf, 0, size);
+	nfit_res->buf = buf;
+	nfit_res->res = res;
+	res->start = *dma;
+	res->end = *dma + size - 1;
+	res->name = "NFIT";
+	spin_lock(&nfit_test_lock);
+	list_add(&nfit_res->list, &t->resources);
+	spin_unlock(&nfit_test_lock);
+
+	return nfit_res->buf;
+}
+
+static struct nfit_test_resource *nfit_test_lookup(resource_size_t addr)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(instances); i++) {
+		struct nfit_test_resource *n, *nfit_res = NULL;
+		struct nfit_test *t = instances[i];
+
+		if (!t)
+			continue;
+		spin_lock(&nfit_test_lock);
+		list_for_each_entry(n, &t->resources, list) {
+			if (addr >= n->res->start && (addr < n->res->start
+						+ resource_size(n->res))) {
+				nfit_res = n;
+				break;
+			} else if (addr >= (unsigned long) n->buf
+					&& (addr < (unsigned long) n->buf
+						+ resource_size(n->res))) {
+				nfit_res = n;
+				break;
+			}
+		}
+		spin_unlock(&nfit_test_lock);
+		if (nfit_res)
+			return nfit_res;
+	}
+
+	return NULL;
+}
+
+static int nfit_test0_alloc(struct nfit_test *t)
+{
+	size_t nfit_size = sizeof(struct nfit)
+			+ sizeof(struct nfit_spa) * NUM_SPA
+			+ sizeof(struct nfit_mem) * NUM_MEM
+			+ sizeof(struct nfit_dcr) * NUM_DCR
+			+ sizeof(struct nfit_bdw) * NUM_BDW;
+	int i;
+
+	t->nfit_buf = (void __iomem *) alloc_coherent(t, nfit_size,
+			&t->nfit_dma);
+	if (!t->nfit_buf)
+		return -ENOMEM;
+	t->nfit_size = nfit_size;
+
+	t->spa_set[0] = alloc_coherent(t, SPA0_SIZE, &t->spa_set_dma[0]);
+	if (!t->spa_set[0])
+		return -ENOMEM;
+
+	t->spa_set[1] = alloc_coherent(t, SPA1_SIZE, &t->spa_set_dma[1]);
+	if (!t->spa_set[1])
+		return -ENOMEM;
+
+	for (i = 0; i < NUM_DCR; i++) {
+		t->dimm[i] = alloc_coherent(t, DIMM_SIZE, &t->dimm_dma[i]);
+		if (!t->dimm[i])
+			return -ENOMEM;
+
+		t->label[i] = alloc_coherent(t, LABEL_SIZE, &t->label_dma[i]);
+		if (!t->label[i])
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < NUM_DCR; i++) {
+		t->dcr[i] = alloc_coherent(t, LABEL_SIZE, &t->dcr_dma[i]);
+		if (!t->dcr[i])
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static u8 nfit_checksum(void *buf, size_t size)
+{
+	u8 sum, *data = buf;
+	size_t i;
+
+	for (sum = 0, i = 0; i < size; i++)
+		sum += data[i];
+	return 0 - sum;
+}
+
+static int nfit_test1_alloc(struct nfit_test *t)
+{
+	size_t nfit_size = sizeof(struct nfit) + sizeof(struct nfit_spa);
+
+	t->nfit_buf = (void __iomem *) alloc_coherent(t, nfit_size,
+			&t->nfit_dma);
+	if (!t->nfit_buf)
+		return -ENOMEM;
+	t->nfit_size = nfit_size;
+
+	t->spa_set[0] = alloc_coherent(t, SPA2_SIZE, &t->spa_set_dma[0]);
+	if (!t->spa_set[0])
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void nfit_test0_setup(struct nfit_test *t)
+{
+	struct nfit_bus_descriptor *nfit_desc;
+	void __iomem *nfit_buf = t->nfit_buf;
+	struct nfit_spa __iomem *nfit_spa;
+	struct nfit_dcr __iomem *nfit_dcr;
+	struct nfit_bdw __iomem *nfit_bdw;
+	struct nfit_mem __iomem *nfit_mem;
+	size_t size = t->nfit_size;
+	struct nfit __iomem *nfit;
+	unsigned int offset;
+
+	/* nfit header */
+	nfit = nfit_buf;
+	memcpy_toio(nfit->signature, "NFIT", 4);
+	writel(size, &nfit->length);
+	writeb(1, &nfit->revision);
+	memcpy_toio(nfit->oemid, "NDTEST", 6);
+	writew(0x1234, &nfit->oem_tbl_id);
+	writel(1, &nfit->oem_revision);
+	writel(0xabcd0000, &nfit->creator_id);
+	writel(1, &nfit->creator_revision);
+
+	/*
+	 * spa0 (interleave first half of dimm0 and dimm1, note storage
+	 * does not actually alias the related block-data-window
+	 * regions)
+	 */
+	nfit_spa = nfit_buf + sizeof(*nfit);
+	writew(NFIT_TABLE_SPA, &nfit_spa->type);
+	writew(sizeof(*nfit_spa), &nfit_spa->length);
+	memcpy_toio(&nfit_spa->type_uuid, &nfit_spa_uuid_pm, 16);
+	writew(0+1, &nfit_spa->spa_index);
+	writeq(t->spa_set_dma[0], &nfit_spa->spa_base);
+	writeq(SPA0_SIZE, &nfit_spa->spa_length);
+
+	/*
+	 * spa1 (interleave last half of the 4 DIMMS, note storage
+	 * does not actually alias the related block-data-window
+	 * regions)
+	 */
+	nfit_spa = nfit_buf + sizeof(*nfit) + sizeof(*nfit_spa);
+	writew(NFIT_TABLE_SPA, &nfit_spa->type);
+	writew(sizeof(*nfit_spa), &nfit_spa->length);
+	memcpy_toio(&nfit_spa->type_uuid, &nfit_spa_uuid_pm, 16);
+	writew(1+1, &nfit_spa->spa_index);
+	writeq(t->spa_set_dma[1], &nfit_spa->spa_base);
+	writeq(SPA1_SIZE, &nfit_spa->spa_length);
+
+	/* spa2 (dcr0) dimm0 */
+	nfit_spa = nfit_buf + sizeof(*nfit) + sizeof(*nfit_spa) * 2;
+	writew(NFIT_TABLE_SPA, &nfit_spa->type);
+	writew(sizeof(*nfit_spa), &nfit_spa->length);
+	memcpy_toio(&nfit_spa->type_uuid, &nfit_spa_uuid_dcr, 16);
+	writew(2+1, &nfit_spa->spa_index);
+	writeq(t->dcr_dma[0], &nfit_spa->spa_base);
+	writeq(DCR_SIZE, &nfit_spa->spa_length);
+
+	/* spa3 (dcr1) dimm1 */
+	nfit_spa = nfit_buf + sizeof(*nfit) + sizeof(*nfit_spa) * 3;
+	writew(NFIT_TABLE_SPA, &nfit_spa->type);
+	writew(sizeof(*nfit_spa), &nfit_spa->length);
+	memcpy_toio(&nfit_spa->type_uuid, &nfit_spa_uuid_dcr, 16);
+	writew(3+1, &nfit_spa->spa_index);
+	writeq(t->dcr_dma[1], &nfit_spa->spa_base);
+	writeq(DCR_SIZE, &nfit_spa->spa_length);
+
+	/* spa4 (dcr2) dimm2 */
+	nfit_spa = nfit_buf + sizeof(*nfit) + sizeof(*nfit_spa) * 4;
+	writew(NFIT_TABLE_SPA, &nfit_spa->type);
+	writew(sizeof(*nfit_spa), &nfit_spa->length);
+	memcpy_toio(&nfit_spa->type_uuid, &nfit_spa_uuid_dcr, 16);
+	writew(4+1, &nfit_spa->spa_index);
+	writeq(t->dcr_dma[2], &nfit_spa->spa_base);
+	writeq(DCR_SIZE, &nfit_spa->spa_length);
+
+	/* spa5 (dcr3) dimm3 */
+	nfit_spa = nfit_buf + sizeof(*nfit) + sizeof(*nfit_spa) * 5;
+	writew(NFIT_TABLE_SPA, &nfit_spa->type);
+	writew(sizeof(*nfit_spa), &nfit_spa->length);
+	memcpy_toio(&nfit_spa->type_uuid, &nfit_spa_uuid_dcr, 16);
+	writew(5+1, &nfit_spa->spa_index);
+	writeq(t->dcr_dma[3], &nfit_spa->spa_base);
+	writeq(DCR_SIZE, &nfit_spa->spa_length);
+
+	/* spa6 (bdw for dcr0) dimm0 */
+	nfit_spa = nfit_buf + sizeof(*nfit) + sizeof(*nfit_spa) * 6;
+	writew(NFIT_TABLE_SPA, &nfit_spa->type);
+	writew(sizeof(*nfit_spa), &nfit_spa->length);
+	memcpy_toio(&nfit_spa->type_uuid, &nfit_spa_uuid_bdw, 16);
+	writew(6+1, &nfit_spa->spa_index);
+	writeq(t->dimm_dma[0], &nfit_spa->spa_base);
+	writeq(DIMM_SIZE, &nfit_spa->spa_length);
+	dev_dbg(&t->pdev.dev, "%s: BDW0: %#llx:%#x\n", __func__,
+			(unsigned long long) t->dimm_dma[0], DIMM_SIZE);
+
+	/* spa7 (bdw for dcr1) dimm1 */
+	nfit_spa = nfit_buf + sizeof(*nfit) + sizeof(*nfit_spa) * 7;
+	writew(NFIT_TABLE_SPA, &nfit_spa->type);
+	writew(sizeof(*nfit_spa), &nfit_spa->length);
+	memcpy_toio(&nfit_spa->type_uuid, &nfit_spa_uuid_bdw, 16);
+	writew(7+1, &nfit_spa->spa_index);
+	writeq(t->dimm_dma[1], &nfit_spa->spa_base);
+	writeq(DIMM_SIZE, &nfit_spa->spa_length);
+	dev_dbg(&t->pdev.dev, "%s: BDW1: %#llx:%#x\n", __func__,
+			(unsigned long long) t->dimm_dma[1], DIMM_SIZE);
+
+	/* spa8 (bdw for dcr2) dimm2 */
+	nfit_spa = nfit_buf + sizeof(*nfit) + sizeof(*nfit_spa) * 8;
+	writew(NFIT_TABLE_SPA, &nfit_spa->type);
+	writew(sizeof(*nfit_spa), &nfit_spa->length);
+	memcpy_toio(&nfit_spa->type_uuid, &nfit_spa_uuid_bdw, 16);
+	writew(8+1, &nfit_spa->spa_index);
+	writeq(t->dimm_dma[2], &nfit_spa->spa_base);
+	writeq(DIMM_SIZE, &nfit_spa->spa_length);
+	dev_dbg(&t->pdev.dev, "%s: BDW2: %#llx:%#x\n", __func__,
+			(unsigned long long) t->dimm_dma[2], DIMM_SIZE);
+
+	/* spa9 (bdw for dcr3) dimm3 */
+	nfit_spa = nfit_buf + sizeof(*nfit) + sizeof(*nfit_spa) * 9;
+	writew(NFIT_TABLE_SPA, &nfit_spa->type);
+	writew(sizeof(*nfit_spa), &nfit_spa->length);
+	memcpy_toio(&nfit_spa->type_uuid, &nfit_spa_uuid_bdw, 16);
+	writew(9+1, &nfit_spa->spa_index);
+	writeq(t->dimm_dma[3], &nfit_spa->spa_base);
+	writeq(DIMM_SIZE, &nfit_spa->spa_length);
+	dev_dbg(&t->pdev.dev, "%s: BDW3: %#llx:%#x\n", __func__,
+			(unsigned long long) t->dimm_dma[3], DIMM_SIZE);
+
+	offset = sizeof(*nfit) + sizeof(*nfit_spa) * 10;
+	/* mem-region0 (spa0, dimm0) */
+	nfit_mem = nfit_buf + offset;
+	writew(NFIT_TABLE_MEM, &nfit_mem->type);
+	writew(sizeof(*nfit_mem), &nfit_mem->length);
+	writel(handle[0], &nfit_mem->nfit_handle);
+	writew(0, &nfit_mem->phys_id);
+	writew(0, &nfit_mem->region_id);
+	writew(0+1, &nfit_mem->spa_index);
+	writew(0+1, &nfit_mem->dcr_index);
+	writeq(SPA0_SIZE/2, &nfit_mem->region_len);
+	writeq(t->spa_set_dma[0], &nfit_mem->region_spa_offset);
+	writeq(0, &nfit_mem->region_dpa);
+	writew(0, &nfit_mem->idt_index);
+	writew(2, &nfit_mem->interleave_ways);
+
+	/* mem-region1 (spa0, dimm1) */
+	nfit_mem = nfit_buf + offset + sizeof(struct nfit_mem);
+	writew(NFIT_TABLE_MEM, &nfit_mem->type);
+	writew(sizeof(*nfit_mem), &nfit_mem->length);
+	writel(handle[1], &nfit_mem->nfit_handle);
+	writew(1, &nfit_mem->phys_id);
+	writew(0, &nfit_mem->region_id);
+	writew(0+1, &nfit_mem->spa_index);
+	writew(1+1, &nfit_mem->dcr_index);
+	writeq(SPA0_SIZE/2, &nfit_mem->region_len);
+	writeq(t->spa_set_dma[0] + SPA0_SIZE/2, &nfit_mem->region_spa_offset);
+	writeq(0, &nfit_mem->region_dpa);
+	writew(0, &nfit_mem->idt_index);
+	writew(2, &nfit_mem->interleave_ways);
+
+	/* mem-region2 (spa1, dimm0) */
+	nfit_mem = nfit_buf + offset + sizeof(struct nfit_mem) * 2;
+	writew(NFIT_TABLE_MEM, &nfit_mem->type);
+	writew(sizeof(*nfit_mem), &nfit_mem->length);
+	writel(handle[0], &nfit_mem->nfit_handle);
+	writew(0, &nfit_mem->phys_id);
+	writew(1, &nfit_mem->region_id);
+	writew(1+1, &nfit_mem->spa_index);
+	writew(0+1, &nfit_mem->dcr_index);
+	writeq(SPA1_SIZE/4, &nfit_mem->region_len);
+	writeq(t->spa_set_dma[1], &nfit_mem->region_spa_offset);
+	writeq(SPA0_SIZE/2, &nfit_mem->region_dpa);
+	writew(0, &nfit_mem->idt_index);
+	writew(4, &nfit_mem->interleave_ways);
+
+	/* mem-region3 (spa1, dimm1) */
+	nfit_mem = nfit_buf + offset + sizeof(struct nfit_mem) * 3;
+	writew(NFIT_TABLE_MEM, &nfit_mem->type);
+	writew(sizeof(*nfit_mem), &nfit_mem->length);
+	writel(handle[1], &nfit_mem->nfit_handle);
+	writew(1, &nfit_mem->phys_id);
+	writew(1, &nfit_mem->region_id);
+	writew(1+1, &nfit_mem->spa_index);
+	writew(1+1, &nfit_mem->dcr_index);
+	writeq(SPA1_SIZE/4, &nfit_mem->region_len);
+	writeq(t->spa_set_dma[1] + SPA1_SIZE/4, &nfit_mem->region_spa_offset);
+	writeq(SPA0_SIZE/2, &nfit_mem->region_dpa);
+	writew(0, &nfit_mem->idt_index);
+	writew(4, &nfit_mem->interleave_ways);
+
+	/* mem-region4 (spa1, dimm2) */
+	nfit_mem = nfit_buf + offset + sizeof(struct nfit_mem) * 4;
+	writew(NFIT_TABLE_MEM, &nfit_mem->type);
+	writew(sizeof(*nfit_mem), &nfit_mem->length);
+	writel(handle[2], &nfit_mem->nfit_handle);
+	writew(2, &nfit_mem->phys_id);
+	writew(0, &nfit_mem->region_id);
+	writew(1+1, &nfit_mem->spa_index);
+	writew(2+1, &nfit_mem->dcr_index);
+	writeq(SPA1_SIZE/4, &nfit_mem->region_len);
+	writeq(t->spa_set_dma[1] + 2*SPA1_SIZE/4, &nfit_mem->region_spa_offset);
+	writeq(SPA0_SIZE/2, &nfit_mem->region_dpa);
+	writew(0, &nfit_mem->idt_index);
+	writew(4, &nfit_mem->interleave_ways);
+
+	/* mem-region5 (spa1, dimm3) */
+	nfit_mem = nfit_buf + offset + sizeof(struct nfit_mem) * 5;
+	writew(NFIT_TABLE_MEM, &nfit_mem->type);
+	writew(sizeof(*nfit_mem), &nfit_mem->length);
+	writel(handle[3], &nfit_mem->nfit_handle);
+	writew(3, &nfit_mem->phys_id);
+	writew(0, &nfit_mem->region_id);
+	writew(1+1, &nfit_mem->spa_index);
+	writew(3+1, &nfit_mem->dcr_index);
+	writeq(SPA1_SIZE/4, &nfit_mem->region_len);
+	writeq(t->spa_set_dma[1] + 3*SPA1_SIZE/4, &nfit_mem->region_spa_offset);
+	writeq(SPA0_SIZE/2, &nfit_mem->region_dpa);
+	writew(0, &nfit_mem->idt_index);
+	writew(4, &nfit_mem->interleave_ways);
+
+	/* mem-region6 (spa/dcr0, dimm0) */
+	nfit_mem = nfit_buf + offset + sizeof(struct nfit_mem) * 6;
+	writew(NFIT_TABLE_MEM, &nfit_mem->type);
+	writew(sizeof(*nfit_mem), &nfit_mem->length);
+	writel(handle[0], &nfit_mem->nfit_handle);
+	writew(0, &nfit_mem->phys_id);
+	writew(0, &nfit_mem->region_id);
+	writew(2+1, &nfit_mem->spa_index);
+	writew(0+1, &nfit_mem->dcr_index);
+	writeq(0, &nfit_mem->region_len);
+	writeq(0, &nfit_mem->region_spa_offset);
+	writeq(0, &nfit_mem->region_dpa);
+	writew(0, &nfit_mem->idt_index);
+	writew(1, &nfit_mem->interleave_ways);
+
+	/* mem-region7 (spa/dcr1, dimm1) */
+	nfit_mem = nfit_buf + offset + sizeof(struct nfit_mem) * 7;
+	writew(NFIT_TABLE_MEM, &nfit_mem->type);
+	writew(sizeof(*nfit_mem), &nfit_mem->length);
+	writel(handle[1], &nfit_mem->nfit_handle);
+	writew(1, &nfit_mem->phys_id);
+	writew(0, &nfit_mem->region_id);
+	writew(3+1, &nfit_mem->spa_index);
+	writew(1+1, &nfit_mem->dcr_index);
+	writeq(0, &nfit_mem->region_len);
+	writeq(0, &nfit_mem->region_spa_offset);
+	writeq(0, &nfit_mem->region_dpa);
+	writew(0, &nfit_mem->idt_index);
+	writew(1, &nfit_mem->interleave_ways);
+
+	/* mem-region8 (spa/dcr2, dimm2) */
+	nfit_mem = nfit_buf + offset + sizeof(struct nfit_mem) * 8;
+	writew(NFIT_TABLE_MEM, &nfit_mem->type);
+	writew(sizeof(*nfit_mem), &nfit_mem->length);
+	writel(handle[2], &nfit_mem->nfit_handle);
+	writew(2, &nfit_mem->phys_id);
+	writew(0, &nfit_mem->region_id);
+	writew(4+1, &nfit_mem->spa_index);
+	writew(2+1, &nfit_mem->dcr_index);
+	writeq(0, &nfit_mem->region_len);
+	writeq(0, &nfit_mem->region_spa_offset);
+	writeq(0, &nfit_mem->region_dpa);
+	writew(0, &nfit_mem->idt_index);
+	writew(1, &nfit_mem->interleave_ways);
+
+	/* mem-region9 (spa/dcr3, dimm3) */
+	nfit_mem = nfit_buf + offset + sizeof(struct nfit_mem) * 9;
+	writew(NFIT_TABLE_MEM, &nfit_mem->type);
+	writew(sizeof(*nfit_mem), &nfit_mem->length);
+	writel(handle[3], &nfit_mem->nfit_handle);
+	writew(3, &nfit_mem->phys_id);
+	writew(0, &nfit_mem->region_id);
+	writew(5+1, &nfit_mem->spa_index);
+	writew(3+1, &nfit_mem->dcr_index);
+	writeq(0, &nfit_mem->region_len);
+	writeq(0, &nfit_mem->region_spa_offset);
+	writeq(0, &nfit_mem->region_dpa);
+	writew(0, &nfit_mem->idt_index);
+	writew(1, &nfit_mem->interleave_ways);
+
+	/* mem-region10 (spa/bdw0, dimm0) */
+	nfit_mem = nfit_buf + offset + sizeof(struct nfit_mem) * 10;
+	writew(NFIT_TABLE_MEM, &nfit_mem->type);
+	writew(sizeof(*nfit_mem), &nfit_mem->length);
+	writel(handle[0], &nfit_mem->nfit_handle);
+	writew(0, &nfit_mem->phys_id);
+	writew(0, &nfit_mem->region_id);
+	writew(6+1, &nfit_mem->spa_index);
+	writew(0+1, &nfit_mem->dcr_index);
+	writeq(0, &nfit_mem->region_len);
+	writeq(0, &nfit_mem->region_spa_offset);
+	writeq(0, &nfit_mem->region_dpa);
+	writew(0, &nfit_mem->idt_index);
+	writew(1, &nfit_mem->interleave_ways);
+
+	/* mem-region11 (spa/bdw1, dimm1) */
+	nfit_mem = nfit_buf + offset + sizeof(struct nfit_mem) * 11;
+	writew(NFIT_TABLE_MEM, &nfit_mem->type);
+	writew(sizeof(*nfit_mem), &nfit_mem->length);
+	writel(handle[1], &nfit_mem->nfit_handle);
+	writew(1, &nfit_mem->phys_id);
+	writew(0, &nfit_mem->region_id);
+	writew(7+1, &nfit_mem->spa_index);
+	writew(1+1, &nfit_mem->dcr_index);
+	writeq(0, &nfit_mem->region_len);
+	writeq(0, &nfit_mem->region_spa_offset);
+	writeq(0, &nfit_mem->region_dpa);
+	writew(0, &nfit_mem->idt_index);
+	writew(1, &nfit_mem->interleave_ways);
+
+	/* mem-region12 (spa/bdw2, dimm2) */
+	nfit_mem = nfit_buf + offset + sizeof(struct nfit_mem) * 12;
+	writew(NFIT_TABLE_MEM, &nfit_mem->type);
+	writew(sizeof(*nfit_mem), &nfit_mem->length);
+	writel(handle[2], &nfit_mem->nfit_handle);
+	writew(2, &nfit_mem->phys_id);
+	writew(0, &nfit_mem->region_id);
+	writew(8+1, &nfit_mem->spa_index);
+	writew(2+1, &nfit_mem->dcr_index);
+	writeq(0, &nfit_mem->region_len);
+	writeq(0, &nfit_mem->region_spa_offset);
+	writeq(0, &nfit_mem->region_dpa);
+	writew(0, &nfit_mem->idt_index);
+	writew(1, &nfit_mem->interleave_ways);
+
+	/* mem-region13 (spa/dcr3, dimm3) */
+	nfit_mem = nfit_buf + offset + sizeof(struct nfit_mem) * 13;
+	writew(NFIT_TABLE_MEM, &nfit_mem->type);
+	writew(sizeof(*nfit_mem), &nfit_mem->length);
+	writel(handle[3], &nfit_mem->nfit_handle);
+	writew(3, &nfit_mem->phys_id);
+	writew(0, &nfit_mem->region_id);
+	writew(9+1, &nfit_mem->spa_index);
+	writew(3+1, &nfit_mem->dcr_index);
+	writeq(0, &nfit_mem->region_len);
+	writeq(0, &nfit_mem->region_spa_offset);
+	writeq(0, &nfit_mem->region_dpa);
+	writew(0, &nfit_mem->idt_index);
+	writew(1, &nfit_mem->interleave_ways);
+
+	offset = offset + sizeof(struct nfit_mem) * 14;
+	/* dcr-descriptor0 */
+	nfit_dcr = nfit_buf + offset;
+	writew(NFIT_TABLE_DCR, &nfit_dcr->type);
+	writew(sizeof(struct nfit_dcr), &nfit_dcr->length);
+	writew(0+1, &nfit_dcr->dcr_index);
+	writew(0xabcd, &nfit_dcr->vendor_id);
+	writew(0, &nfit_dcr->device_id);
+	writew(1, &nfit_dcr->revision_id);
+	writel(~handle[0], &nfit_dcr->serial_number);
+	writew(1, &nfit_dcr->num_bcw);
+	writeq(DCR_SIZE, &nfit_dcr->bcw_size);
+	writeq(0, &nfit_dcr->cmd_offset);
+	writeq(8, &nfit_dcr->cmd_size);
+	writeq(8, &nfit_dcr->status_offset);
+	writeq(4, &nfit_dcr->status_size);
+
+	/* dcr-descriptor1 */
+	nfit_dcr = nfit_buf + offset + sizeof(struct nfit_dcr);
+	writew(NFIT_TABLE_DCR, &nfit_dcr->type);
+	writew(sizeof(struct nfit_dcr), &nfit_dcr->length);
+	writew(1+1, &nfit_dcr->dcr_index);
+	writew(0xabcd, &nfit_dcr->vendor_id);
+	writew(0, &nfit_dcr->device_id);
+	writew(1, &nfit_dcr->revision_id);
+	writel(~handle[1], &nfit_dcr->serial_number);
+	writew(1, &nfit_dcr->num_bcw);
+	writeq(DCR_SIZE, &nfit_dcr->bcw_size);
+	writeq(0, &nfit_dcr->cmd_offset);
+	writeq(8, &nfit_dcr->cmd_size);
+	writeq(8, &nfit_dcr->status_offset);
+	writeq(4, &nfit_dcr->status_size);
+
+	/* dcr-descriptor2 */
+	nfit_dcr = nfit_buf + offset + sizeof(struct nfit_dcr) * 2;
+	writew(NFIT_TABLE_DCR, &nfit_dcr->type);
+	writew(sizeof(struct nfit_dcr), &nfit_dcr->length);
+	writew(2+1, &nfit_dcr->dcr_index);
+	writew(0xabcd, &nfit_dcr->vendor_id);
+	writew(0, &nfit_dcr->device_id);
+	writew(1, &nfit_dcr->revision_id);
+	writel(~handle[2], &nfit_dcr->serial_number);
+	writew(1, &nfit_dcr->num_bcw);
+	writeq(DCR_SIZE, &nfit_dcr->bcw_size);
+	writeq(0, &nfit_dcr->cmd_offset);
+	writeq(8, &nfit_dcr->cmd_size);
+	writeq(8, &nfit_dcr->status_offset);
+	writeq(4, &nfit_dcr->status_size);
+
+	/* dcr-descriptor3 */
+	nfit_dcr = nfit_buf + offset + sizeof(struct nfit_dcr) * 3;
+	writew(NFIT_TABLE_DCR, &nfit_dcr->type);
+	writew(sizeof(struct nfit_dcr), &nfit_dcr->length);
+	writew(3+1, &nfit_dcr->dcr_index);
+	writew(0xabcd, &nfit_dcr->vendor_id);
+	writew(0, &nfit_dcr->device_id);
+	writew(1, &nfit_dcr->revision_id);
+	writel(~handle[3], &nfit_dcr->serial_number);
+	writew(1, &nfit_dcr->num_bcw);
+	writeq(DCR_SIZE, &nfit_dcr->bcw_size);
+	writeq(0, &nfit_dcr->cmd_offset);
+	writeq(8, &nfit_dcr->cmd_size);
+	writeq(8, &nfit_dcr->status_offset);
+	writeq(4, &nfit_dcr->status_size);
+
+	offset = offset + sizeof(struct nfit_dcr) * 4;
+	/* bdw0 (spa/dcr0, dimm0) */
+	nfit_bdw = nfit_buf + offset;
+	writew(NFIT_TABLE_BDW, &nfit_bdw->type);
+	writew(sizeof(struct nfit_bdw), &nfit_bdw->length);
+	writew(0+1, &nfit_bdw->dcr_index);
+	writew(1, &nfit_bdw->num_bdw);
+	writeq(0, &nfit_bdw->bdw_offset);
+	writeq(BDW_SIZE, &nfit_bdw->bdw_size);
+	writeq(DIMM_SIZE, &nfit_bdw->blk_capacity);
+	writeq(0, &nfit_bdw->blk_offset);
+
+	/* bdw1 (spa/dcr1, dimm1) */
+	nfit_bdw = nfit_buf + offset + sizeof(struct nfit_bdw);
+	writew(NFIT_TABLE_BDW, &nfit_bdw->type);
+	writew(sizeof(struct nfit_bdw), &nfit_bdw->length);
+	writew(1+1, &nfit_bdw->dcr_index);
+	writew(1, &nfit_bdw->num_bdw);
+	writeq(0, &nfit_bdw->bdw_offset);
+	writeq(BDW_SIZE, &nfit_bdw->bdw_size);
+	writeq(DIMM_SIZE, &nfit_bdw->blk_capacity);
+	writeq(0, &nfit_bdw->blk_offset);
+
+	/* bdw2 (spa/dcr2, dimm2) */
+	nfit_bdw = nfit_buf + offset + sizeof(struct nfit_bdw) * 2;
+	writew(NFIT_TABLE_BDW, &nfit_bdw->type);
+	writew(sizeof(struct nfit_bdw), &nfit_bdw->length);
+	writew(2+1, &nfit_bdw->dcr_index);
+	writew(1, &nfit_bdw->num_bdw);
+	writeq(0, &nfit_bdw->bdw_offset);
+	writeq(BDW_SIZE, &nfit_bdw->bdw_size);
+	writeq(DIMM_SIZE, &nfit_bdw->blk_capacity);
+	writeq(0, &nfit_bdw->blk_offset);
+
+	/* bdw3 (spa/dcr3, dimm3) */
+	nfit_bdw = nfit_buf + offset + sizeof(struct nfit_bdw) * 3;
+	writew(NFIT_TABLE_BDW, &nfit_bdw->type);
+	writew(sizeof(struct nfit_bdw), &nfit_bdw->length);
+	writew(3+1, &nfit_bdw->dcr_index);
+	writew(1, &nfit_bdw->num_bdw);
+	writeq(0, &nfit_bdw->bdw_offset);
+	writeq(BDW_SIZE, &nfit_bdw->bdw_size);
+	writeq(DIMM_SIZE, &nfit_bdw->blk_capacity);
+	writeq(0, &nfit_bdw->blk_offset);
+
+	writeb(nfit_checksum(nfit_buf, size), &nfit->checksum);
+
+	nfit_desc = &t->nfit_desc;
+	nfit_desc->nfit_ctl = nfit_test_ctl;
+}
+
+static void nfit_test1_setup(struct nfit_test *t)
+{
+	void __iomem *nfit_buf = t->nfit_buf;
+	struct nfit_spa __iomem *nfit_spa;
+	size_t size = t->nfit_size;
+	struct nfit __iomem *nfit;
+
+	/* nfit header */
+	nfit = nfit_buf;
+	memcpy_toio(nfit->signature, "NFIT", 4);
+	writel(size, &nfit->length);
+	writeb(1, &nfit->revision);
+	memcpy_toio(nfit->oemid, "NDTEST", 6);
+	writew(0x1234, &nfit->oem_tbl_id);
+	writel(1, &nfit->oem_revision);
+	writel(0xabcd0000, &nfit->creator_id);
+	writel(1, &nfit->creator_revision);
+
+	/* spa0 (flat range with no bdw aliasing) */
+	nfit_spa = nfit_buf + sizeof(*nfit);
+	writew(NFIT_TABLE_SPA, &nfit_spa->type);
+	writew(sizeof(*nfit_spa), &nfit_spa->length);
+	memcpy_toio(&nfit_spa->type_uuid, &nfit_spa_uuid_pm, 16);
+	writew(0+1, &nfit_spa->spa_index);
+	writeq(t->spa_set_dma[0], &nfit_spa->spa_base);
+	writeq(SPA2_SIZE, &nfit_spa->spa_length);
+
+	writeb(nfit_checksum(nfit_buf, size), &nfit->checksum);
+}
+
+static int nfit_test_probe(struct platform_device *pdev)
+{
+	struct nfit_bus_descriptor *nfit_desc;
+	struct device *dev = &pdev->dev;
+	struct nfit_test *nfit_test;
+	int rc;
+
+	nfit_test = to_nfit_test(&pdev->dev);
+	rc = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(64));
+	if (rc)
+		return rc;
+
+	/* common alloc */
+	if (nfit_test->num_dcr) {
+		int num = nfit_test->num_dcr;
+
+		nfit_test->dimm = devm_kcalloc(dev, num, sizeof(void *), GFP_KERNEL);
+		nfit_test->dimm_dma = devm_kcalloc(dev, num, sizeof(dma_addr_t), GFP_KERNEL);
+		nfit_test->label = devm_kcalloc(dev, num, sizeof(void *), GFP_KERNEL);
+		nfit_test->label_dma = devm_kcalloc(dev, num, sizeof(dma_addr_t), GFP_KERNEL);
+		nfit_test->dcr = devm_kcalloc(dev, num, sizeof(struct nfit_test_dcr *), GFP_KERNEL);
+		nfit_test->dcr_dma = devm_kcalloc(dev, num, sizeof(dma_addr_t), GFP_KERNEL);
+		if (nfit_test->dimm && nfit_test->dimm_dma && nfit_test->label
+				&& nfit_test->label_dma && nfit_test->dcr
+				&& nfit_test->dcr_dma)
+			/* pass */;
+		else
+			return -ENOMEM;
+	}
+
+	if (nfit_test->num_pm) {
+		int num = nfit_test->num_pm;
+
+		nfit_test->spa_set = devm_kcalloc(dev, num, sizeof(void *), GFP_KERNEL);
+		nfit_test->spa_set_dma = devm_kcalloc(dev, num,
+				sizeof(dma_addr_t), GFP_KERNEL);
+		if (nfit_test->spa_set && nfit_test->spa_set_dma)
+			/* pass */;
+		else
+			return -ENOMEM;
+	}
+
+	/* per-nfit specific alloc */
+	if (nfit_test->alloc(nfit_test))
+		return -ENOMEM;
+
+	nfit_test->setup(nfit_test);
+
+	nfit_desc = &nfit_test->nfit_desc;
+	nfit_desc->nfit_base = nfit_test->nfit_buf;
+	nfit_desc->nfit_size = nfit_test->nfit_size;
+
+	nfit_test->nd_bus = nfit_bus_register(&pdev->dev, nfit_desc);
+	if (!nfit_test->nd_bus)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int nfit_test_remove(struct platform_device *pdev)
+{
+	struct nfit_test *nfit_test = to_nfit_test(&pdev->dev);
+
+	nfit_bus_unregister(nfit_test->nd_bus);
+
+	return 0;
+}
+
+static void nfit_test_release(struct device *dev)
+{
+	struct nfit_test *nfit_test = to_nfit_test(dev);
+
+	kfree(nfit_test);
+}
+
+static const struct platform_device_id nfit_test_id[] = {
+	{ KBUILD_MODNAME },
+	{ },
+};
+
+static struct platform_driver nfit_test_driver = {
+	.probe = nfit_test_probe,
+	.remove = nfit_test_remove,
+	.driver = {
+		.name = KBUILD_MODNAME,
+	},
+	.id_table = nfit_test_id,
+};
+
+#ifdef CONFIG_CMA_SIZE_MBYTES
+#define CMA_SIZE_MBYTES CONFIG_CMA_SIZE_MBYTES
+#else
+#define CMA_SIZE_MBYTES 0
+#endif
+
+static __init int nfit_test_init(void)
+{
+	int rc, i;
+
+	if (CMA_SIZE_MBYTES < 584) {
+		pr_err("need CONFIG_CMA_SIZE_MBYTES >= 584 to load\n");
+		return -EINVAL;
+	}
+
+	nfit_test_setup(nfit_test_lookup);
+
+	for (i = 0; i < NUM_NFITS; i++) {
+		struct nfit_test *nfit_test;
+		struct platform_device *pdev;
+
+		nfit_test = kzalloc(sizeof(*nfit_test), GFP_KERNEL);
+		if (!nfit_test) {
+			rc = -ENOMEM;
+			goto err_register;
+		}
+		INIT_LIST_HEAD(&nfit_test->resources);
+		switch (i) {
+		case 0:
+			nfit_test->num_pm = NUM_PM;
+			nfit_test->num_dcr = NUM_DCR;
+			nfit_test->alloc = nfit_test0_alloc;
+			nfit_test->setup = nfit_test0_setup;
+			break;
+		case 1:
+			nfit_test->num_pm = 1;
+			nfit_test->alloc = nfit_test1_alloc;
+			nfit_test->setup = nfit_test1_setup;
+			break;
+		default:
+			rc = -EINVAL;
+			goto err_register;
+		}
+		pdev = &nfit_test->pdev;
+		pdev->name = KBUILD_MODNAME;
+		pdev->id = i;
+		pdev->dev.release = nfit_test_release;
+		rc = platform_device_register(pdev);
+		if (rc) {
+			put_device(&pdev->dev);
+			goto err_register;
+		}
+		instances[i] = nfit_test;
+	}
+
+	rc = platform_driver_register(&nfit_test_driver);
+	if (rc)
+		goto err_register;
+	return 0;
+
+ err_register:
+	for (i = 0; i < NUM_NFITS; i++)
+		if (instances[i])
+			platform_device_unregister(&instances[i]->pdev);
+	return rc;
+}
+
+static __exit void nfit_test_exit(void)
+{
+	int i;
+
+	nfit_test_teardown();
+	for (i = 0; i < NUM_NFITS; i++)
+		platform_device_unregister(&instances[i]->pdev);
+	platform_driver_unregister(&nfit_test_driver);
+}
+
+module_init(nfit_test_init);
+module_exit(nfit_test_exit);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Intel Corporation");
diff --git a/drivers/block/nd/test/nfit_test.h b/drivers/block/nd/test/nfit_test.h
new file mode 100644
index 000000000000..8a300c51b6bc
--- /dev/null
+++ b/drivers/block/nd/test/nfit_test.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __NFIT_TEST_H__
+#define __NFIT_TEST_H__
+
+struct nfit_test_resource {
+	struct list_head list;
+	struct resource *res;
+	void *buf;
+};
+
+typedef struct nfit_test_resource *(*nfit_test_lookup_fn)(resource_size_t);
+void nfit_test_setup(nfit_test_lookup_fn fn);
+void nfit_test_teardown(void);
+#endif

