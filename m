Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C261A3164;
	Sun, 26 Oct 2025 15:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761493131; cv=none; b=sVlI0AMulOjESn6On3c2g+ZgUy+YffjzhpQINca5gggcKvsZcep+tX3kjCgKTKTzz9lAkRPQlNaPFd0A9bjrYPwucu7hSYhqqaeyJTAyXrcH0+BeUZiESNaux26aNXXP2BumE9mUMbjJMBXhIGP46/qGMugNhcNtzD/57ckyxwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761493131; c=relaxed/simple;
	bh=0/cnsH7xAiVrmnADoINuTekW7SsStZWq8o8tjQjx2sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hANFFpvoLzAoBSfnwU7dDArX9f8Y1KG9/c+y10Z3Gx2NCvYgAG5heUsiK0fuElFVgSfCE0vosI/EfMymodjleovlI6JMBDDh9uVsigt783ecK/6f+CjsSxj7Vuv5K0LVxf1yiTajgf+l6t6HPiPqj+0BVPwiEju5xtEi6dtZH1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uHgHLFgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uHgHLFgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8731DC4CEF1;
	Sun, 26 Oct 2025 15:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761493131;
	bh=0/cnsH7xAiVrmnADoINuTekW7SsStZWq8o8tjQjx2sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHgHLFgHn4lZ8j+vj14roI/mTCm6vNO+mSTBfj+0smw2v1UCCMmg7phf+YBWncG5L
	 KDJ9SJYlA5h77tBVHxGbSdGR8HovisEAelivLjT78OM+TS/CVKQsDGyT1F+agh8nfT
	 WzgJLAFeJFVimOOD9YV3KTv6kXgyqh7gZc244O/KtA8JkO2lj/N2U6b+VBDS2UOAlA
	 LikLT1p7Qn5BRPWeUcCgYhi5eQ7GDDppVtiP0+PITe4ZQFWcO405qxKMwiI9IqXkpA
	 uU9MxS/XtYbTKpxOskh2yoZQFZn7EmY1VenFltI4ZHCfJHz12mEt7YyJQOcsfYnPJJ
	 UTYQM0U1u8THQ==
From: Mike Rapoport <rppt@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: jane.chu@oracle.com,
	=?UTF-8?q?Micha=C5=82=20C=C5=82api=C5=84ski?= <mclapinski@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Tyler Hicks <code@tyhicks.com>,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [PATCH v3 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices
Date: Sun, 26 Oct 2025 17:38:41 +0200
Message-ID: <20251026153841.752061-2-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251026153841.752061-1-rppt@kernel.org>
References: <20251026153841.752061-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

There are use cases, for example virtual machine hosts, that create
"persistent" memory regions using memmap= option on x86 or dummy
pmem-region device tree nodes on DT based systems.

Both these options are inflexible because they create static regions and
the layout of the "persistent" memory cannot be adjusted without reboot
and sometimes they even require firmware update.

Add a ramdax driver that allows creation of DIMM devices on top of
E820_TYPE_PRAM regions and devicetree pmem-region nodes.

The DIMMs support label space management on the "device" and provide a
flexible way to access RAM using fsdax and devdax.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/Kconfig  |  19 +++
 drivers/nvdimm/Makefile |   1 +
 drivers/nvdimm/ramdax.c | 282 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 302 insertions(+)
 create mode 100644 drivers/nvdimm/ramdax.c

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index fde3e17c836c..44ab929a1ad5 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -97,6 +97,25 @@ config OF_PMEM
 
 	  Select Y if unsure.
 
+config RAMDAX
+	tristate "Support persistent memory interfaces on RAM carveouts"
+	depends on X86_PMEM_LEGACY || OF || COMPILE_TEST
+	default LIBNVDIMM
+	help
+	  Allows creation of DAX devices on RAM carveouts.
+
+	  Memory ranges that are manually specified by the
+	  'memmap=nn[KMG]!ss[KMG]' kernel command line or defined by dummy
+	  pmem-region device tree nodes would be managed by this driver as DIMM
+	  devices with support for dynamic layout of namespaces.
+	  The driver steals 128K in the end of the memmap range for the
+	  namespace management. This allows supporting up to 509 namespaces
+	  (see 'ndctl create-namespace --help').
+	  The driver should be force bound to e820_pmem or pmem-region platform
+	  devices using 'driver_override' device attribute.
+
+	  Select N if unsure.
+
 config NVDIMM_KEYS
 	def_bool y
 	depends on ENCRYPTED_KEYS
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index ba0296dca9db..8c268814936c 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_ND_BTT) += nd_btt.o
 obj-$(CONFIG_X86_PMEM_LEGACY) += nd_e820.o
 obj-$(CONFIG_OF_PMEM) += of_pmem.o
 obj-$(CONFIG_VIRTIO_PMEM) += virtio_pmem.o nd_virtio.o
+obj-$(CONFIG_RAMDAX) += ramdax.o
 
 nd_pmem-y := pmem.o
 
diff --git a/drivers/nvdimm/ramdax.c b/drivers/nvdimm/ramdax.c
new file mode 100644
index 000000000000..63cf05791829
--- /dev/null
+++ b/drivers/nvdimm/ramdax.c
@@ -0,0 +1,282 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2025, Mike Rapoport, Microsoft
+ *
+ * Based on e820 pmem driver:
+ * Copyright (c) 2015, Christoph Hellwig.
+ * Copyright (c) 2015, Intel Corporation.
+ */
+#include <linux/platform_device.h>
+#include <linux/memory_hotplug.h>
+#include <linux/libnvdimm.h>
+#include <linux/module.h>
+#include <linux/numa.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/of.h>
+
+#include <uapi/linux/ndctl.h>
+
+#define LABEL_AREA_SIZE	SZ_128K
+
+struct ramdax_dimm {
+	struct nvdimm *nvdimm;
+	void *label_area;
+};
+
+static void ramdax_remove(struct platform_device *pdev)
+{
+	struct nvdimm_bus *nvdimm_bus = platform_get_drvdata(pdev);
+
+	nvdimm_bus_unregister(nvdimm_bus);
+}
+
+static int ramdax_register_region(struct resource *res,
+		struct nvdimm *nvdimm,
+		struct nvdimm_bus *nvdimm_bus)
+{
+	struct nd_mapping_desc mapping;
+	struct nd_region_desc ndr_desc;
+	struct nd_interleave_set *nd_set;
+	int nid = phys_to_target_node(res->start);
+
+	nd_set = kzalloc(sizeof(*nd_set), GFP_KERNEL);
+	if (!nd_set)
+		return -ENOMEM;
+
+	nd_set->cookie1 = 0xcafebeefcafebeef;
+	nd_set->cookie2 = nd_set->cookie1;
+	nd_set->altcookie = nd_set->cookie1;
+
+	memset(&mapping, 0, sizeof(mapping));
+	mapping.nvdimm = nvdimm;
+	mapping.start = 0;
+	mapping.size = resource_size(res) - LABEL_AREA_SIZE;
+
+	memset(&ndr_desc, 0, sizeof(ndr_desc));
+	ndr_desc.res = res;
+	ndr_desc.numa_node = numa_map_to_online_node(nid);
+	ndr_desc.target_node = nid;
+	ndr_desc.num_mappings = 1;
+	ndr_desc.mapping = &mapping;
+	ndr_desc.nd_set = nd_set;
+
+	if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
+		goto err_free_nd_set;
+
+	return 0;
+
+err_free_nd_set:
+	kfree(nd_set);
+	return -ENXIO;
+}
+
+static int ramdax_register_dimm(struct resource *res, void *data)
+{
+	resource_size_t start = res->start;
+	resource_size_t size = resource_size(res);
+	unsigned long flags = 0, cmd_mask = 0;
+	struct nvdimm_bus *nvdimm_bus = data;
+	struct ramdax_dimm *dimm;
+	int err;
+
+	dimm = kzalloc(sizeof(*dimm), GFP_KERNEL);
+	if (!dimm)
+		return -ENOMEM;
+
+	dimm->label_area = memremap(start + size - LABEL_AREA_SIZE,
+				    LABEL_AREA_SIZE, MEMREMAP_WB);
+	if (!dimm->label_area) {
+		err = -ENOMEM;
+		goto err_free_dimm;
+	}
+
+	set_bit(NDD_LABELING, &flags);
+	set_bit(NDD_REGISTER_SYNC, &flags);
+	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
+	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
+	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
+	dimm->nvdimm = nvdimm_create(nvdimm_bus, dimm,
+				     /* dimm_attribute_groups */ NULL,
+				     flags, cmd_mask, 0, NULL);
+	if (!dimm->nvdimm) {
+		err = -ENOMEM;
+		goto err_unmap_label;
+	}
+
+	err = ramdax_register_region(res, dimm->nvdimm, nvdimm_bus);
+	if (err)
+		goto err_remove_nvdimm;
+
+	return 0;
+
+err_remove_nvdimm:
+	nvdimm_delete(dimm->nvdimm);
+err_unmap_label:
+	memunmap(dimm->label_area);
+err_free_dimm:
+	kfree(dimm);
+	return err;
+}
+
+static int ramdax_get_config_size(struct nvdimm *nvdimm, int buf_len,
+		struct nd_cmd_get_config_size *cmd)
+{
+	if (sizeof(*cmd) > buf_len)
+		return -EINVAL;
+
+	*cmd = (struct nd_cmd_get_config_size){
+		.status = 0,
+		.config_size = LABEL_AREA_SIZE,
+		.max_xfer = 8,
+	};
+
+	return 0;
+}
+
+static int ramdax_get_config_data(struct nvdimm *nvdimm, int buf_len,
+		struct nd_cmd_get_config_data_hdr *cmd)
+{
+	struct ramdax_dimm *dimm = nvdimm_provider_data(nvdimm);
+
+	if (sizeof(*cmd) > buf_len)
+		return -EINVAL;
+	if (struct_size(cmd, out_buf, cmd->in_length) > buf_len)
+		return -EINVAL;
+	if (cmd->in_offset + cmd->in_length > LABEL_AREA_SIZE)
+		return -EINVAL;
+
+	memcpy(cmd->out_buf, dimm->label_area + cmd->in_offset, cmd->in_length);
+
+	return 0;
+}
+
+static int ramdax_set_config_data(struct nvdimm *nvdimm, int buf_len,
+		struct nd_cmd_set_config_hdr *cmd)
+{
+	struct ramdax_dimm *dimm = nvdimm_provider_data(nvdimm);
+
+	if (sizeof(*cmd) > buf_len)
+		return -EINVAL;
+	if (struct_size(cmd, in_buf, cmd->in_length) > buf_len)
+		return -EINVAL;
+	if (cmd->in_offset + cmd->in_length > LABEL_AREA_SIZE)
+		return -EINVAL;
+
+	memcpy(dimm->label_area + cmd->in_offset, cmd->in_buf, cmd->in_length);
+
+	return 0;
+}
+
+static int ramdax_nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd,
+		void *buf, unsigned int buf_len)
+{
+	unsigned long cmd_mask = nvdimm_cmd_mask(nvdimm);
+
+	if (!test_bit(cmd, &cmd_mask))
+		return -ENOTTY;
+
+	switch (cmd) {
+	case ND_CMD_GET_CONFIG_SIZE:
+		return ramdax_get_config_size(nvdimm, buf_len, buf);
+	case ND_CMD_GET_CONFIG_DATA:
+		return ramdax_get_config_data(nvdimm, buf_len, buf);
+	case ND_CMD_SET_CONFIG_DATA:
+		return ramdax_set_config_data(nvdimm, buf_len, buf);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int ramdax_ctl(struct nvdimm_bus_descriptor *nd_desc,
+		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
+		unsigned int buf_len, int *cmd_rc)
+{
+	/*
+	 * No firmware response to translate, let the transport error
+	 * code take precedence.
+	 */
+	*cmd_rc = 0;
+
+	if (!nvdimm)
+		return -ENOTTY;
+	return ramdax_nvdimm_ctl(nvdimm, cmd, buf, buf_len);
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id ramdax_of_matches[] = {
+	{ .compatible = "pmem-region", },
+	{ },
+};
+#endif
+
+static int ramdax_probe_of(struct platform_device *pdev,
+		struct nvdimm_bus *bus, struct device_node *np)
+{
+	int err;
+
+	if (!of_match_node(ramdax_of_matches, np))
+		return -ENODEV;
+
+	for (int i = 0; i < pdev->num_resources; i++) {
+		err = ramdax_register_dimm(&pdev->resource[i], bus);
+		if (err)
+			goto err_unregister;
+	}
+
+	return 0;
+
+err_unregister:
+	/*
+	 * FIXME: should we unregister the dimms that were registered
+	 * successfully
+	 */
+	return err;
+}
+
+static int ramdax_probe(struct platform_device *pdev)
+{
+	static struct nvdimm_bus_descriptor nd_desc;
+	struct device *dev = &pdev->dev;
+	struct nvdimm_bus *nvdimm_bus;
+	struct device_node *np;
+	int rc = -ENXIO;
+
+	nd_desc.provider_name = "ramdax";
+	nd_desc.module = THIS_MODULE;
+	nd_desc.ndctl = ramdax_ctl;
+	nvdimm_bus = nvdimm_bus_register(dev, &nd_desc);
+	if (!nvdimm_bus)
+		goto err;
+
+	np = dev_of_node(&pdev->dev);
+	if (np)
+		rc = ramdax_probe_of(pdev, nvdimm_bus, np);
+	else
+		rc = walk_iomem_res_desc(IORES_DESC_PERSISTENT_MEMORY_LEGACY,
+					 IORESOURCE_MEM, 0, -1, nvdimm_bus,
+					 ramdax_register_dimm);
+	if (rc)
+		goto err;
+
+	platform_set_drvdata(pdev, nvdimm_bus);
+
+	return 0;
+err:
+	nvdimm_bus_unregister(nvdimm_bus);
+	return rc;
+}
+
+static struct platform_driver ramdax_driver = {
+	.probe = ramdax_probe,
+	.remove = ramdax_remove,
+	.driver = {
+		.name = "ramdax",
+	},
+};
+
+module_platform_driver(ramdax_driver);
+
+MODULE_DESCRIPTION("NVDIMM support for e820 type-12 memory and OF pmem-region");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Microsoft Corporation");
-- 
2.50.1

