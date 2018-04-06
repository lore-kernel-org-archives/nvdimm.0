Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A980C226FAA63
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 22:21:48 -0700 (PDT)
Received: by mail-pf0-x241.google.com with SMTP id f15so10157551pfn.0
 for <linux-nvdimm@lists.01.org>; Thu, 05 Apr 2018 22:21:48 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH v3 1/4] libnvdimm: Add of_node to region and bus descriptors
Date: Fri,  6 Apr 2018 15:21:13 +1000
Message-Id: <20180406052116.31483-1-oohall@gmail.com>
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

We want to be able to cross reference the region and bus devices
with the device tree node that they were spawned from. libNVDIMM
handles creating the actual devices for these internally, so we
need to pass in a pointer to the relevant node in the descriptor.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c         | 1 +
 drivers/nvdimm/region_devs.c | 1 +
 include/linux/libnvdimm.h    | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 78eabc3a1ab1..c6106914f396 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -358,6 +358,7 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 	nvdimm_bus->dev.release = nvdimm_bus_release;
 	nvdimm_bus->dev.groups = nd_desc->attr_groups;
 	nvdimm_bus->dev.bus = &nvdimm_bus_type;
+	nvdimm_bus->dev.of_node = nd_desc->of_node;
 	dev_set_name(&nvdimm_bus->dev, "ndbus%d", nvdimm_bus->id);
 	rc = device_register(&nvdimm_bus->dev);
 	if (rc) {
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 1593e1806b16..30d5dc8b9bb2 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1014,6 +1014,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	dev->parent = &nvdimm_bus->dev;
 	dev->type = dev_type;
 	dev->groups = ndr_desc->attr_groups;
+	dev->of_node = ndr_desc->of_node;
 	nd_region->ndr_size = resource_size(ndr_desc->res);
 	nd_region->ndr_start = ndr_desc->res->start;
 	nd_device_register(dev);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index ff855ed965fb..f61cb5050297 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -76,12 +76,14 @@ typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc);
 
+struct device_node;
 struct nvdimm_bus_descriptor {
 	const struct attribute_group **attr_groups;
 	unsigned long bus_dsm_mask;
 	unsigned long cmd_mask;
 	struct module *module;
 	char *provider_name;
+	struct device_node *of_node;
 	ndctl_fn ndctl;
 	int (*flush_probe)(struct nvdimm_bus_descriptor *nd_desc);
 	int (*clear_to_send)(struct nvdimm_bus_descriptor *nd_desc,
@@ -123,6 +125,7 @@ struct nd_region_desc {
 	int num_lanes;
 	int numa_node;
 	unsigned long flags;
+	struct device_node *of_node;
 };
 
 struct device;
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
