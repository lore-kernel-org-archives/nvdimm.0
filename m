Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 983FA211B6C32
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 21:21:45 -0800 (PST)
From: "Du, Fan" <fan.du@intel.com>
Subject: RE: [PATCH 4/4] dax: "Hotplug" persistent memory for use like
 normal RAM
Date: Thu, 17 Jan 2019 05:21:42 +0000
Message-ID: <5A90DA2E42F8AE43BC4A093BF06788482571FCB1@SHSMSX103.ccr.corp.intel.com>
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <20190116181905.12E102B4@viggo.jf.intel.com>
In-Reply-To: <20190116181905.12E102B4@viggo.jf.intel.com>
Content-Language: en-US
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
To: Dave Hansen <dave.hansen@linux.intel.com>, "dave@sr71.net" <dave@sr71.net>
Cc: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "mhocko@suse.com" <mhocko@suse.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "tiwai@suse.de" <tiwai@suse.de>, "zwisler@kernel.org" <zwisler@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "Wu, Fengguang  <fengguang.wu@intel.com>, baiyaowei@cmss.chinamobile.com" <baiyaowei@cmss.chinamobile.com>, "Huang," Ying" <ying.huang@intel.com>, "bhelgaas@google.com, " <bhelgaas@google.com>, akpm@linux-foundation.org" <akpm@linux-foundation.org>, "bp@suse.de" <bp@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

>-----Original Message-----
>From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf
>Of Dave Hansen
>Sent: Thursday, January 17, 2019 2:19 AM
>To: dave@sr71.net
>Cc: thomas.lendacky@amd.com; mhocko@suse.com;
>linux-nvdimm@lists.01.org; tiwai@suse.de; Dave Hansen
><dave.hansen@linux.intel.com>; Huang, Ying <ying.huang@intel.com>;
>linux-kernel@vger.kernel.org; linux-mm@kvack.org; bp@suse.de;
>baiyaowei@cmss.chinamobile.com; zwisler@kernel.org;
>bhelgaas@google.com; Wu, Fengguang <fengguang.wu@intel.com>;
>akpm@linux-foundation.org
>Subject: [PATCH 4/4] dax: "Hotplug" persistent memory for use like normal
>RAM
>
>
>From: Dave Hansen <dave.hansen@linux.intel.com>
>
>Currently, a persistent memory region is "owned" by a device driver,
>either the "Direct DAX" or "Filesystem DAX" drivers.  These drivers
>allow applications to explicitly use persistent memory, generally
>by being modified to use special, new libraries.
>
>However, this limits persistent memory use to applications which
>*have* been modified.  To make it more broadly usable, this driver
>"hotplugs" memory into the kernel, to be managed ad used just like
>normal RAM would be.
>
>To make this work, management software must remove the device from
>being controlled by the "Device DAX" infrastructure:
>
>	echo -n dax0.0 > /sys/bus/dax/drivers/device_dax/remove_id
>	echo -n dax0.0 > /sys/bus/dax/drivers/device_dax/unbind
>
>and then bind it to this new driver:
>
>	echo -n dax0.0 > /sys/bus/dax/drivers/kmem/new_id
>	echo -n dax0.0 > /sys/bus/dax/drivers/kmem/bind

Is there any plan to introduce additional mode, e.g. "kmem" in the userspace
ndctl tool to do the configuration?

>After this, there will be a number of new memory sections visible
>in sysfs that can be onlined, or that may get onlined by existing
>udev-initiated memory hotplug rules.
>
>Note: this inherits any existing NUMA information for the newly-
>added memory from the persistent memory device that came from the
>firmware.  On Intel platforms, the firmware has guarantees that
>require each socket's persistent memory to be in a separate
>memory-only NUMA node.  That means that this patch is not expected
>to create NUMA nodes, but will simply hotplug memory into existing
>nodes.
>
>There is currently some metadata at the beginning of pmem regions.
>The section-size memory hotplug restrictions, plus this small
>reserved area can cause the "loss" of a section or two of capacity.
>This should be fixable in follow-on patches.  But, as a first step,
>losing 256MB of memory (worst case) out of hundreds of gigabytes
>is a good tradeoff vs. the required code to fix this up precisely.
>
>Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
>Cc: Dan Williams <dan.j.williams@intel.com>
>Cc: Dave Jiang <dave.jiang@intel.com>
>Cc: Ross Zwisler <zwisler@kernel.org>
>Cc: Vishal Verma <vishal.l.verma@intel.com>
>Cc: Tom Lendacky <thomas.lendacky@amd.com>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: Michal Hocko <mhocko@suse.com>
>Cc: linux-nvdimm@lists.01.org
>Cc: linux-kernel@vger.kernel.org
>Cc: linux-mm@kvack.org
>Cc: Huang Ying <ying.huang@intel.com>
>Cc: Fengguang Wu <fengguang.wu@intel.com>
>Cc: Borislav Petkov <bp@suse.de>
>Cc: Bjorn Helgaas <bhelgaas@google.com>
>Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
>Cc: Takashi Iwai <tiwai@suse.de>
>---
>
> b/drivers/dax/Kconfig  |    5 ++
> b/drivers/dax/Makefile |    1
> b/drivers/dax/kmem.c   |   93
>+++++++++++++++++++++++++++++++++++++++++++++++++
> 3 files changed, 99 insertions(+)
>
>diff -puN drivers/dax/Kconfig~dax-kmem-try-4 drivers/dax/Kconfig
>--- a/drivers/dax/Kconfig~dax-kmem-try-4	2019-01-08 09:54:44.051694874
>-0800
>+++ b/drivers/dax/Kconfig	2019-01-08 09:54:44.056694874 -0800
>@@ -32,6 +32,11 @@ config DEV_DAX_PMEM
>
> 	  Say M if unsure
>
>+config DEV_DAX_KMEM
>+	def_bool y
>+	depends on DEV_DAX_PMEM   # Needs DEV_DAX_PMEM infrastructure
>+	depends on MEMORY_HOTPLUG # for add_memory() and friends
>+
> config DEV_DAX_PMEM_COMPAT
> 	tristate "PMEM DAX: support the deprecated /sys/class/dax interface"
> 	depends on DEV_DAX_PMEM
>diff -puN /dev/null drivers/dax/kmem.c
>--- /dev/null	2018-12-03 08:41:47.355756491 -0800
>+++ b/drivers/dax/kmem.c	2019-01-08 09:54:44.056694874 -0800
>@@ -0,0 +1,93 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/* Copyright(c) 2016-2018 Intel Corporation. All rights reserved. */
>+#include <linux/memremap.h>
>+#include <linux/pagemap.h>
>+#include <linux/memory.h>
>+#include <linux/module.h>
>+#include <linux/device.h>
>+#include <linux/pfn_t.h>
>+#include <linux/slab.h>
>+#include <linux/dax.h>
>+#include <linux/fs.h>
>+#include <linux/mm.h>
>+#include <linux/mman.h>
>+#include "dax-private.h"
>+#include "bus.h"
>+
>+int dev_dax_kmem_probe(struct device *dev)
>+{
>+	struct dev_dax *dev_dax = to_dev_dax(dev);
>+	struct resource *res = &dev_dax->region->res;
>+	resource_size_t kmem_start;
>+	resource_size_t kmem_size;
>+	struct resource *new_res;
>+	int numa_node;
>+	int rc;
>+
>+	/* Hotplug starting at the beginning of the next block: */
>+	kmem_start = ALIGN(res->start, memory_block_size_bytes());
>+
>+	kmem_size = resource_size(res);
>+	/* Adjust the size down to compensate for moving up kmem_start: */
>+        kmem_size -= kmem_start - res->start;
>+	/* Align the size down to cover only complete blocks: */
>+	kmem_size &= ~(memory_block_size_bytes() - 1);
>+
>+	new_res = devm_request_mem_region(dev, kmem_start, kmem_size,
>+					  dev_name(dev));
>+
>+	if (!new_res) {
>+		printk("could not reserve region %016llx -> %016llx\n",
>+				kmem_start, kmem_start+kmem_size);
>+		return -EBUSY;
>+	}
>+
>+	/*
>+	 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
>+	 * so that add_memory() can add a child resource.
>+	 */
>+	new_res->flags = IORESOURCE_SYSTEM_RAM;
>+	new_res->name = dev_name(dev);
>+
>+	numa_node = dev_dax->target_node;
>+	if (numa_node < 0) {
>+		pr_warn_once("bad numa_node: %d, forcing to 0\n", numa_node);
>+		numa_node = 0;
>+	}
>+
>+	rc = add_memory(numa_node, new_res->start, resource_size(new_res));
>+	if (rc)
>+		return rc;
>+
>+	return 0;
>+}
>+EXPORT_SYMBOL_GPL(dev_dax_kmem_probe);
>+
>+static int dev_dax_kmem_remove(struct device *dev)
>+{
>+	/* Assume that hot-remove will fail for now */
>+	return -EBUSY;
>+}
>+
>+static struct dax_device_driver device_dax_kmem_driver = {
>+	.drv = {
>+		.probe = dev_dax_kmem_probe,
>+		.remove = dev_dax_kmem_remove,
>+	},
>+};
>+
>+static int __init dax_kmem_init(void)
>+{
>+	return dax_driver_register(&device_dax_kmem_driver);
>+}
>+
>+static void __exit dax_kmem_exit(void)
>+{
>+	dax_driver_unregister(&device_dax_kmem_driver);
>+}
>+
>+MODULE_AUTHOR("Intel Corporation");
>+MODULE_LICENSE("GPL v2");
>+module_init(dax_kmem_init);
>+module_exit(dax_kmem_exit);
>+MODULE_ALIAS_DAX_DEVICE(0);
>diff -puN drivers/dax/Makefile~dax-kmem-try-4 drivers/dax/Makefile
>--- a/drivers/dax/Makefile~dax-kmem-try-4	2019-01-08 09:54:44.053694874
>-0800
>+++ b/drivers/dax/Makefile	2019-01-08 09:54:44.056694874 -0800
>@@ -1,6 +1,7 @@
> # SPDX-License-Identifier: GPL-2.0
> obj-$(CONFIG_DAX) += dax.o
> obj-$(CONFIG_DEV_DAX) += device_dax.o
>+obj-$(CONFIG_DEV_DAX_KMEM) += kmem.o
>
> dax-y := super.o
> dax-y += bus.o
>_
>_______________________________________________
>Linux-nvdimm mailing list
>Linux-nvdimm@lists.01.org
>https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
