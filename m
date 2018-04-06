Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF79C226FAA63
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 22:21:50 -0700 (PDT)
Received: by mail-pf0-x241.google.com with SMTP id y69so10161485pfb.5
 for <linux-nvdimm@lists.01.org>; Thu, 05 Apr 2018 22:21:50 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH v3 2/4] libnvdimm: Add device-tree based driver
Date: Fri,  6 Apr 2018 15:21:14 +1000
Message-Id: <20180406052116.31483-2-oohall@gmail.com>
In-Reply-To: <20180406052116.31483-1-oohall@gmail.com>
References: <20180406052116.31483-1-oohall@gmail.com>
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patch adds peliminary device-tree bindings for persistent memory
regions. The driver registers a libnvdimm bus for each pmem-region
node and each address range under the node is converted to a region
within that bus.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
v2: Made each bus have a separate node rather having a shared bus.
    Renamed to of_pmem rather than of_nvdimm.
    Changed log level of happy-path messages to debug.
v3: Replaced of_nd_region_* prefix with of_pmem_region_* to make
    the driver specific parts more distinct from the libnvdimm
    parts.
---
 MAINTAINERS              |   7 +++
 drivers/nvdimm/Kconfig   |  10 ++++
 drivers/nvdimm/Makefile  |   1 +
 drivers/nvdimm/of_pmem.c | 119 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 137 insertions(+)
 create mode 100644 drivers/nvdimm/of_pmem.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8133e97980f1..df240740ca78 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8014,6 +8014,13 @@ Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 S:	Supported
 F:	drivers/nvdimm/pmem*
 
+LIBNVDIMM: DEVICETREE BINDINGS
+M:	Oliver O'Halloran <oohall@gmail.com>
+L:	linux-nvdimm@lists.01.org
+Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
+S:	Supported
+F:	drivers/nvdimm/of_pmem.c
+
 LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
 M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-nvdimm@lists.01.org
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index a65f2e1d9f53..2d6862bf7436 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -102,4 +102,14 @@ config NVDIMM_DAX
 
 	  Select Y if unsure
 
+config OF_PMEM
+	tristate "Device-tree support for persistent memory regions"
+	depends on OF
+	default LIBNVDIMM
+	help
+	  Allows regions of persistent memory to be described in the
+	  device-tree.
+
+	  Select Y if unsure.
+
 endif
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index 70d5f3ad9909..e8847045dac0 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
 obj-$(CONFIG_ND_BTT) += nd_btt.o
 obj-$(CONFIG_ND_BLK) += nd_blk.o
 obj-$(CONFIG_X86_PMEM_LEGACY) += nd_e820.o
+obj-$(CONFIG_OF_PMEM) += of_pmem.o
 
 nd_pmem-y := pmem.o
 
diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
new file mode 100644
index 000000000000..85013bad35de
--- /dev/null
+++ b/drivers/nvdimm/of_pmem.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#define pr_fmt(fmt) "of_pmem: " fmt
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
+static const struct attribute_group *bus_attr_groups[] = {
+	&nvdimm_bus_attribute_group,
+	NULL,
+};
+
+struct of_pmem_private {
+	struct nvdimm_bus_descriptor bus_desc;
+	struct nvdimm_bus *bus;
+};
+
+static int of_pmem_region_probe(struct platform_device *pdev)
+{
+	struct of_pmem_private *priv;
+	struct device_node *np;
+	struct nvdimm_bus *bus;
+	bool is_volatile;
+	int i;
+
+	np = dev_of_node(&pdev->dev);
+	if (!np)
+		return -ENXIO;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->bus_desc.attr_groups = bus_attr_groups;
+	priv->bus_desc.provider_name = "of_pmem";
+	priv->bus_desc.module = THIS_MODULE;
+	priv->bus_desc.of_node = np;
+
+	priv->bus = bus = nvdimm_bus_register(&pdev->dev, &priv->bus_desc);
+	if (!bus) {
+		kfree(priv);
+		return -ENODEV;
+	}
+	platform_set_drvdata(pdev, priv);
+
+	is_volatile = !!of_find_property(np, "volatile", NULL);
+	dev_dbg(&pdev->dev, "Registering %s regions from %pOF\n",
+			is_volatile ? "volatile" : "non-volatile",  np);
+
+	for (i = 0; i < pdev->num_resources; i++) {
+		struct nd_region_desc ndr_desc;
+		struct nd_region *region;
+
+		/*
+		 * NB: libnvdimm copies the data from ndr_desc into it's own
+		 * structures so passing a stack pointer is fine.
+		 */
+		memset(&ndr_desc, 0, sizeof(ndr_desc));
+		ndr_desc.attr_groups = region_attr_groups;
+		ndr_desc.numa_node = of_node_to_nid(np);
+		ndr_desc.res = &pdev->resource[i];
+		ndr_desc.of_node = np;
+		set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
+
+		if (is_volatile)
+			region = nvdimm_volatile_region_create(bus, &ndr_desc);
+		else
+			region = nvdimm_pmem_region_create(bus, &ndr_desc);
+
+		if (!region)
+			dev_warn(&pdev->dev, "Unable to register region %pR from %pOF\n",
+					ndr_desc.res, np);
+		else
+			dev_dbg(&pdev->dev, "Registered region %pR from %pOF\n",
+					ndr_desc.res, np);
+	}
+
+	return 0;
+}
+
+static int of_pmem_region_remove(struct platform_device *pdev)
+{
+	struct of_pmem_private *priv = platform_get_drvdata(pdev);
+
+	nvdimm_bus_unregister(priv->bus);
+	kfree(priv);
+
+	return 0;
+}
+
+static const struct of_device_id of_pmem_region_match[] = {
+	{ .compatible = "pmem-region" },
+	{ },
+};
+
+static struct platform_driver of_pmem_region_driver = {
+	.probe = of_pmem_region_probe,
+	.remove = of_pmem_region_remove,
+	.driver = {
+		.name = "of_pmem",
+		.owner = THIS_MODULE,
+		.of_match_table = of_pmem_region_match,
+	},
+};
+
+module_platform_driver(of_pmem_region_driver);
+MODULE_DEVICE_TABLE(of, of_pmem_region_match);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("IBM Corporation");
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
