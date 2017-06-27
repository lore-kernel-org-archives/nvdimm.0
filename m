Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E15321C8F622
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 03:27:34 -0700 (PDT)
Received: by mail-pf0-x241.google.com with SMTP id d5so4200515pfe.1
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 03:29:05 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [RFC 2/4] libnvdimm: Add a device-tree interface
Date: Tue, 27 Jun 2017 20:28:49 +1000
Message-Id: <20170627102851.15484-2-oohall@gmail.com>
In-Reply-To: <20170627102851.15484-1-oohall@gmail.com>
References: <20170627102851.15484-1-oohall@gmail.com>
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
on powerpc and other, less cool, device-tree based platforms.

Cc: devicetree@vger.kernel.org
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
The current bindings are essentially this:

nonvolatile-memory {
	compatible = "nonvolatile-memory", "special-memory";
	ranges;

	region@0 {
		compatible = "nvdimm,byte-addressable";
		reg = <0x0 0x1000>;
	};

	region@1000 {
		compatible = "nvdimm,byte-addressable";
		reg = <0x1000 0x1000>;
	};
};

To handle interleave sets, etc the plan was the add an extra property with the
interleave stride and a "mapping" property with <&DIMM, dimm-start-offset>
tuples for each dimm in the interleave set. Block MMIO regions can be added
with a different compatible type, but I'm not too concerned with them for
now.

Does this sound reasonable? Is there anything this scheme would make difficult?
---
 drivers/nvdimm/Kconfig     |  10 +++
 drivers/nvdimm/Makefile    |   1 +
 drivers/nvdimm/of_nvdimm.c | 209 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 220 insertions(+)
 create mode 100644 drivers/nvdimm/of_nvdimm.c

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
index 909554c3f955..622961f4849d 100644
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
index 000000000000..359808200feb
--- /dev/null
+++ b/drivers/nvdimm/of_nvdimm.c
@@ -0,0 +1,209 @@
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
+		pr_warn("Unable to parse reg[0] for %s\n", np->full_name);
+		return -ENXIO;
+	}
+
+	pr_debug("Found %pR for %s\n", &temp_res, np->full_name);
+
+	memset(&ndr_desc, 0, sizeof(ndr_desc));
+	ndr_desc.res = &temp_res;
+	ndr_desc.attr_groups = region_attr_groups;
+#ifdef CONFIG_NUMA
+	ndr_desc.numa_node = of_node_to_nid(np);
+#endif
+	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
+
+	region = nvdimm_pmem_region_create(bus, &ndr_desc);
+	if (!region)
+		return -ENXIO;
+
+	/*
+	 * Bind the region to the OF node we spawned it from. We
+	 * already bumped the node's refcount while walking the
+	 * bus.
+	 */
+	to_nd_region_dev(region)->of_node = np;
+
+	return 0;
+}
+
+/*
+ * 'data' is a pointer to the function that handles registering the device
+ * on the nvdimm bus.
+ */
+static struct of_device_id of_nvdimm_dev_types[] = {
+	{ .compatible = "nvdimm,byte-addressable", .data = of_nvdimm_add_byte },
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
+		pr_debug("%s already parsed, skipping\n",
+			node->full_name);
+		return;
+	}
+
+	match = of_match_node(of_nvdimm_dev_types, node);
+	if (!match) {
+		pr_info("No compatible match for '%s'\n",
+			node->full_name);
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
+	pr_debug("Parsed %s, rc = %d\n", node->full_name, rc);
+
+	return;
+}
+
+/*
+ * The nvdimm core refers to the bus descriptor structure at runtime
+ * so we need to keep it around. Note that this is different to region
+ * descriptors which can be stack allocated.
+ */
+struct of_nd_bus {
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
+	struct of_nd_bus *of_nd_bus;
+
+	node = dev_of_node(&pdev->dev);
+	if (!node)
+		return -ENXIO;
+
+	of_nd_bus = kzalloc(sizeof(*of_nd_bus), GFP_KERNEL);
+	if (!of_nd_bus)
+		return -ENOMEM;
+
+	of_nd_bus->desc.attr_groups = bus_attr_groups;
+	of_nd_bus->desc.provider_name = "of_nvdimm";
+	of_nd_bus->desc.module = THIS_MODULE;
+	of_nd_bus->bus = nvdimm_bus_register(&pdev->dev, &of_nd_bus->desc);
+	if (!of_nd_bus->bus)
+		goto err;
+
+	to_nvdimm_bus_dev(of_nd_bus->bus)->of_node = node;
+
+	/* now walk the node bus and setup regions, etc */
+        for_each_available_child_of_node(node, child)
+		of_nvdimm_parse_one(of_nd_bus->bus, child);
+
+	platform_set_drvdata(pdev, of_nd_bus);
+
+	return 0;
+
+err:
+	nvdimm_bus_unregister(of_nd_bus->bus);
+	kfree(of_nd_bus);
+	return -ENXIO;
+}
+
+static int of_nvdimm_remove(struct platform_device *pdev)
+{
+	struct of_nd_bus *bus = platform_get_drvdata(pdev);
+	struct device_node *node;
+
+	if (!bus)
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
+	nvdimm_bus_unregister(bus->bus);
+	kfree(bus);
+
+	return 0;
+}
+
+static const struct of_device_id of_nvdimm_bus_match[] = {
+	{ .compatible = "nonvolatile-memory" },
+	{ .compatible = "special-memory" },
+	{ },
+};
+
+static struct platform_driver of_nvdimm_driver = {
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
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
