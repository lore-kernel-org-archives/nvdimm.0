Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x244.google.com (mail-pg0-x244.google.com
 [IPv6:2607:f8b0:400e:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2551320356887
 for <linux-nvdimm@lists.01.org>; Wed, 15 Nov 2017 09:47:51 -0800 (PST)
Received: by mail-pg0-x244.google.com with SMTP id r12so1766451pgu.10
 for <linux-nvdimm@lists.01.org>; Wed, 15 Nov 2017 09:51:59 -0800 (PST)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 2/3] libnvdimm: Add a device-tree interface
Date: Thu, 16 Nov 2017 04:51:30 +1100
Message-Id: <20171115175131.23631-2-oohall@gmail.com>
In-Reply-To: <20171115175131.23631-1-oohall@gmail.com>
References: <20171115175131.23631-1-oohall@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linuxppc-dev@lists.ozlabs.org
Cc: devicetree@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

A fairly bare-bones set of device-tree bindings so libnvdimm can be used
on powerpc and other device-tree based platforms.

Cc: devicetree@vger.kernel.org
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 .../devicetree/bindings/nvdimm/nvdimm-bus.txt      |  69 +++++++
 MAINTAINERS                                        |   8 +
 drivers/nvdimm/Kconfig                             |  10 +
 drivers/nvdimm/Makefile                            |   1 +
 drivers/nvdimm/of_nvdimm.c                         | 202 +++++++++++++++++++++
 5 files changed, 290 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/nvdimm/nvdimm-bus.txt
 create mode 100644 drivers/nvdimm/of_nvdimm.c

diff --git a/Documentation/devicetree/bindings/nvdimm/nvdimm-bus.txt b/Documentation/devicetree/bindings/nvdimm/nvdimm-bus.txt
new file mode 100644
index 000000000000..491e7c4900ed
--- /dev/null
+++ b/Documentation/devicetree/bindings/nvdimm/nvdimm-bus.txt
@@ -0,0 +1,69 @@
+Device-tree bindings for nonvolatile-memory / NVDIMMs
+-----------------------------------------------------
+
+Non-volatile DIMMs are memory modules used to provide (cacheable) main memory that
+retains its contents across power cycles. In more practical terms, they are kind
+of storage device where the contents can be accessed by the CPU directly,
+rather than indirectly via a storage controller or similar. This can provide
+substantial performance improvements for applications designed to take
+advantage of in-memory storage.
+
+This binding provides a way to describe memory regions that should be managed
+by an NVDIMM storage driver (libNVDIMM in Linux) and some of the associated
+metadata. The binding itself is split into two main parts: A container bus and
+its sub-nodes which describe which memory address ranges corresponding to
+NVDIMM backed memory.
+
+Bindings for the container bus:
+------------------------------
+
+Required properties:
+ - compatible = "nvdimm-bus";
+ - ranges;
+	A blank ranges property is required because the sub-nodes have
+	addresses in the system's physical address space.
+
+The use of a container bus is mainly to handle future expansion of the binding. For
+comparison the ACPI equivalent of this binding (NFIT) describes: Memory regions, DIMM
+control structures, Block mode DIMM control structures, interleave sets, and more. Some
+of these structures cross reference each other so everyone should be happier if we keep
+it relatively self contained.
+
+Bindings for the region nodes:
+-----------------------------
+
+Required properties:
+	- compatible = "nvdimm-persistent" or "nvdimm-volatile"
+
+		The "nvdimm-persistent" region type indicates that this memory region
+		is actually a persistent region. The volatile type is mainly useful
+		for testing and RAM disks that can persist across kexec.
+
+	- reg = <base, size>;
+		The reg property should only contain one address range.
+
+Optional properties:
+	- Any relevant NUMA assocativity properties for the target platform.
+
+A complete example:
+--------------------
+
+/ {
+	#size-cells = <1>;
+	#address-cells = <1>;
+
+	nonvolatile-memory {
+		compatible = "nonvolatile-memory";
+		ranges;
+
+		region@5000 {
+			compatible = "nvdimm-persistent";
+			reg = <0x5000 0x1000>;
+		};
+
+		region@6000 {
+			compatible = "nvdimm-volatile";
+			reg = <0x6000 0x1000>;
+		};
+	};
+};
diff --git a/MAINTAINERS b/MAINTAINERS
index 65eff7857ec3..0350bf5a94d2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7875,6 +7875,14 @@ Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 S:	Supported
 F:	drivers/nvdimm/pmem*
 
+LIBNVDIMM: DEVICETREE BINDINGS
+M:	Oliver O'Halloran <oohall@gmail.com>
+L:	linux-nvdimm@lists.01.org
+Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
+S:	Supported
+F:	drivers/nvdimm/of_nvdimm.c
+F:	Documentation/devicetree/bindings/nvdimm/nvdimm-bus.txt
+
 LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
 M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-nvdimm@lists.01.org
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 5bdd499b5f4f..72d147b55596 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -102,4 +102,14 @@ config NVDIMM_DAX
 
 	  Select Y if unsure
 
+config OF_NVDIMM
+	tristate "Device-tree support for NVDIMMs"
+	depends on OF
+	default LIBNVDIMM
+	help
+	  Allows byte addressable persistent memory regions to be described in the
+	  device-tree.
+
+	  Select Y if unsure.
+
 endif
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index ca6d325438a3..9029511a8486 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
 obj-$(CONFIG_ND_BTT) += nd_btt.o
 obj-$(CONFIG_ND_BLK) += nd_blk.o
 obj-$(CONFIG_X86_PMEM_LEGACY) += nd_e820.o
+obj-$(CONFIG_OF_NVDIMM) += of_nvdimm.o
 
 nd_pmem-y := pmem.o
 
diff --git a/drivers/nvdimm/of_nvdimm.c b/drivers/nvdimm/of_nvdimm.c
new file mode 100644
index 000000000000..765cbbae8bcb
--- /dev/null
+++ b/drivers/nvdimm/of_nvdimm.c
@@ -0,0 +1,202 @@
+/*
+ * Copyright 2017, IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
+ */
+
+#define pr_fmt(fmt) "of_nvdimm: " fmt
+
+#include <linux/of_platform.h>
+#include <linux/of_address.h>
+#include <linux/libnvdimm.h>
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <linux/slab.h>
+
+static const struct attribute_group *region_attr_groups[] = {
+	&nd_region_attribute_group,
+	&nd_device_attribute_group,
+	NULL,
+};
+
+static int of_nvdimm_add_byte(struct nvdimm_bus *bus, struct device_node *np)
+{
+	struct nd_region_desc ndr_desc;
+	struct resource temp_res;
+	struct nd_region *region;
+
+	/*
+	 * byte regions should only have one address range
+	 */
+	if (of_address_to_resource(np, 0, &temp_res)) {
+		pr_warn("Unable to parse reg[0] for %pOF\n", np);
+		return -ENXIO;
+	}
+
+	pr_debug("Found %pR for %pOF\n", &temp_res, np);
+
+	memset(&ndr_desc, 0, sizeof(ndr_desc));
+	ndr_desc.res = &temp_res;
+	ndr_desc.of_node = np;
+	ndr_desc.attr_groups = region_attr_groups;
+#ifdef CONFIG_NUMA
+	ndr_desc.numa_node = of_node_to_nid(np);
+#endif
+	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
+
+	if (of_device_is_compatible(np, "nvdimm-volatile"))
+		region = nvdimm_volatile_region_create(bus, &ndr_desc);
+	else
+		region = nvdimm_pmem_region_create(bus, &ndr_desc);
+
+	if (!region)
+		return -ENXIO;
+
+	return 0;
+}
+
+static const struct of_device_id of_nvdimm_dev_types[] = {
+	{ .compatible = "nvdimm-persistent", .data = of_nvdimm_add_byte },
+	{ .compatible = "nvdimm-volatile", .data = of_nvdimm_add_byte },
+	{ },
+};
+
+static void of_nvdimm_parse_one(struct nvdimm_bus *bus,
+		struct device_node *node)
+{
+	int (*parse_node)(struct nvdimm_bus *, struct device_node *);
+	const struct of_device_id *match;
+	int rc;
+
+	if (of_node_test_and_set_flag(node, OF_POPULATED)) {
+		pr_debug("%pOF already parsed, skipping\n", node);
+		return;
+	}
+
+	match = of_match_node(of_nvdimm_dev_types, node);
+	if (!match) {
+		pr_info("No compatible match for '%pOF'\n", node);
+		of_node_clear_flag(node, OF_POPULATED);
+		return;
+	}
+
+	of_node_get(node);
+	parse_node = match->data;
+	rc = parse_node(bus, node);
+
+	if (rc) {
+		of_node_clear_flag(node, OF_POPULATED);
+		of_node_put(node);
+	}
+
+	pr_debug("Parsed %pOF, rc = %d\n", node, rc);
+
+	return;
+}
+
+/*
+ * The nvdimm core refers to the bus descriptor structure at runtime
+ * so we need to keep it around. Note that that this is different to
+ * the other nd_*_desc types which are essentially containers for extra
+ * function parameters.
+ */
+struct of_nd_private {
+	struct nvdimm_bus_descriptor desc;
+	struct nvdimm_bus *bus;
+};
+
+static const struct attribute_group *bus_attr_groups[] = {
+	&nvdimm_bus_attribute_group,
+	NULL,
+};
+
+static int of_nvdimm_probe(struct platform_device *pdev)
+{
+	struct device_node *node, *child;
+	struct of_nd_private *priv;
+
+	node = dev_of_node(&pdev->dev);
+	if (!node)
+		return -ENXIO;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->desc.attr_groups = bus_attr_groups;
+	priv->desc.provider_name = "of_nvdimm";
+	priv->desc.module = THIS_MODULE;
+	priv->desc.of_node = node;
+
+	priv->bus = nvdimm_bus_register(&pdev->dev, &priv->desc);
+	if (!priv->bus)
+		goto err;
+
+	platform_set_drvdata(pdev, priv);
+
+	/* now walk the node bus and setup regions, etc */
+	for_each_available_child_of_node(node, child)
+		of_nvdimm_parse_one(priv->bus, child);
+
+	return 0;
+
+err:
+	nvdimm_bus_unregister(priv->bus);
+	kfree(priv);
+	return -ENXIO;
+}
+
+static int of_nvdimm_remove(struct platform_device *pdev)
+{
+	struct of_nd_private *priv = platform_get_drvdata(pdev);
+	struct device_node *node;
+
+	if (!priv)
+		return 0; /* possible? */
+
+	for_each_available_child_of_node(pdev->dev.of_node, node) {
+		if (!of_node_check_flag(node, OF_POPULATED))
+			continue;
+
+		of_node_clear_flag(node, OF_POPULATED);
+		of_node_put(node);
+		pr_debug("de-populating %s\n", node->full_name);
+	}
+
+	nvdimm_bus_unregister(priv->bus);
+	kfree(priv);
+
+	return 0;
+}
+
+static const struct of_device_id of_nvdimm_bus_match[] = {
+	{ .compatible = "nvdimm-bus" },
+	{ },
+};
+
+static const struct platform_driver of_nvdimm_driver = {
+	.probe = of_nvdimm_probe,
+	.remove = of_nvdimm_remove,
+	.driver = {
+		.name = "of_nvdimm",
+		.owner = THIS_MODULE,
+		.of_match_table = of_nvdimm_bus_match,
+	},
+};
+
+module_platform_driver(of_nvdimm_driver);
+MODULE_DEVICE_TABLE(of, of_nvdimm_bus_match);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("IBM Corporation");
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
