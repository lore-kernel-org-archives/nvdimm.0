Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC3933D7
	for <nvdimm@lists.linux.dev>; Thu, 24 Nov 2022 18:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669314939; x=1700850939;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pjy1etOc3BGrYMlXLL8hAZpDhT/9g6D6kzZa7Wi4J08=;
  b=frbEmX5gloipTiK5olaomJiDHIQPu52gu5s/8ZGLRlGfG5nrjkfaVl6V
   0Po8fkETQ8+hDE+b/ifbJQp6kWNbwkBdJNllcK7h511mh4ujBd1aPkRbC
   70tBwPTd3Vx9JewAALVARE3hesH0ugTt7waPbiipad51Sxz4Wz1tf07bh
   EO0bc19ZwlkP///iIklbaLSwbznDtIK3W7GPgYhZl3/DW/q57YLuHSNuz
   LgGijmMjrH11DyJVTMfxLcTW65WDV1A8ZzQZV20rElU95ByOGyLvZLXkt
   DAanINxI2zIgvVv22qTTPAEcXZcM3CJklM1UpXUtd8H30AY/SEACOQeB+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313050459"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="313050459"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 10:35:38 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="816926025"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="816926025"
Received: from aglevin-mobl3.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.65.252])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 10:35:38 -0800
Subject: [PATCH v4 11/12] tools/testing/cxl: Add an RCH topology
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: rrichter@amd.com, terry.bowman@amd.com, bhelgaas@google.com,
 dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 24 Nov 2022 10:35:38 -0800
Message-ID: <166931493816.2104015.8749844490243672146.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In an RCH topology a CXL host-bridge as Root Complex Integrated Endpoint
the represents the memory expander. Unlike a VH topology there is no
CXL/PCIE Root Port that host the endpoint. The CXL subsystem maps this
as the CXL root object (ACPI0017 on ACPI based systems) targeting the
host-bridge as a dport, per usual, but then that dport directly hosts
the endpoint port.

Mock up that configuration with a 4th host-bridge that has a 'cxl_rcd'
device instance as its immediate child.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/cxl/test/cxl.c |  151 +++++++++++++++++++++++++++++++++++++++---
 tools/testing/cxl/test/mem.c |   37 ++++++++++
 2 files changed, 176 insertions(+), 12 deletions(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 1823c61d7ba3..b1c362090b92 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -13,9 +13,11 @@
 
 #define NR_CXL_HOST_BRIDGES 2
 #define NR_CXL_SINGLE_HOST 1
+#define NR_CXL_RCH 1
 #define NR_CXL_ROOT_PORTS 2
 #define NR_CXL_SWITCH_PORTS 2
 #define NR_CXL_PORT_DECODERS 8
+#define NR_BRIDGES (NR_CXL_HOST_BRIDGES + NR_CXL_SINGLE_HOST + NR_CXL_RCH)
 
 static struct platform_device *cxl_acpi;
 static struct platform_device *cxl_host_bridge[NR_CXL_HOST_BRIDGES];
@@ -35,6 +37,8 @@ static struct platform_device *cxl_swd_single[NR_MEM_SINGLE];
 struct platform_device *cxl_mem[NR_MEM_MULTI];
 struct platform_device *cxl_mem_single[NR_MEM_SINGLE];
 
+static struct platform_device *cxl_rch[NR_CXL_RCH];
+static struct platform_device *cxl_rcd[NR_CXL_RCH];
 
 static inline bool is_multi_bridge(struct device *dev)
 {
@@ -57,7 +61,7 @@ static inline bool is_single_bridge(struct device *dev)
 }
 
 static struct acpi_device acpi0017_mock;
-static struct acpi_device host_bridge[NR_CXL_HOST_BRIDGES + NR_CXL_SINGLE_HOST] = {
+static struct acpi_device host_bridge[NR_BRIDGES] = {
 	[0] = {
 		.handle = &host_bridge[0],
 	},
@@ -67,7 +71,9 @@ static struct acpi_device host_bridge[NR_CXL_HOST_BRIDGES + NR_CXL_SINGLE_HOST]
 	[2] = {
 		.handle = &host_bridge[2],
 	},
-
+	[3] = {
+		.handle = &host_bridge[3],
+	},
 };
 
 static bool is_mock_dev(struct device *dev)
@@ -80,6 +86,9 @@ static bool is_mock_dev(struct device *dev)
 	for (i = 0; i < ARRAY_SIZE(cxl_mem_single); i++)
 		if (dev == &cxl_mem_single[i]->dev)
 			return true;
+	for (i = 0; i < ARRAY_SIZE(cxl_rcd); i++)
+		if (dev == &cxl_rcd[i]->dev)
+			return true;
 	if (dev == &cxl_acpi->dev)
 		return true;
 	return false;
@@ -101,7 +110,7 @@ static bool is_mock_adev(struct acpi_device *adev)
 
 static struct {
 	struct acpi_table_cedt cedt;
-	struct acpi_cedt_chbs chbs[NR_CXL_HOST_BRIDGES + NR_CXL_SINGLE_HOST];
+	struct acpi_cedt_chbs chbs[NR_BRIDGES];
 	struct {
 		struct acpi_cedt_cfmws cfmws;
 		u32 target[1];
@@ -122,6 +131,10 @@ static struct {
 		struct acpi_cedt_cfmws cfmws;
 		u32 target[1];
 	} cfmws4;
+	struct {
+		struct acpi_cedt_cfmws cfmws;
+		u32 target[1];
+	} cfmws5;
 } __packed mock_cedt = {
 	.cedt = {
 		.header = {
@@ -154,6 +167,14 @@ static struct {
 		.uid = 2,
 		.cxl_version = ACPI_CEDT_CHBS_VERSION_CXL20,
 	},
+	.chbs[3] = {
+		.header = {
+			.type = ACPI_CEDT_TYPE_CHBS,
+			.length = sizeof(mock_cedt.chbs[0]),
+		},
+		.uid = 3,
+		.cxl_version = ACPI_CEDT_CHBS_VERSION_CXL11,
+	},
 	.cfmws0 = {
 		.cfmws = {
 			.header = {
@@ -229,6 +250,21 @@ static struct {
 		},
 		.target = { 2 },
 	},
+	.cfmws5 = {
+		.cfmws = {
+			.header = {
+				.type = ACPI_CEDT_TYPE_CFMWS,
+				.length = sizeof(mock_cedt.cfmws5),
+			},
+			.interleave_ways = 0,
+			.granularity = 4,
+			.restrictions = ACPI_CEDT_CFMWS_RESTRICT_TYPE3 |
+					ACPI_CEDT_CFMWS_RESTRICT_VOLATILE,
+			.qtg_id = 5,
+			.window_size = SZ_256M,
+		},
+		.target = { 3 },
+	},
 };
 
 struct acpi_cedt_cfmws *mock_cfmws[] = {
@@ -237,6 +273,7 @@ struct acpi_cedt_cfmws *mock_cfmws[] = {
 	[2] = &mock_cedt.cfmws2.cfmws,
 	[3] = &mock_cedt.cfmws3.cfmws,
 	[4] = &mock_cedt.cfmws4.cfmws,
+	[5] = &mock_cedt.cfmws5.cfmws,
 };
 
 struct cxl_mock_res {
@@ -262,11 +299,11 @@ static void depopulate_all_mock_resources(void)
 	mutex_unlock(&mock_res_lock);
 }
 
-static struct cxl_mock_res *alloc_mock_res(resource_size_t size)
+static struct cxl_mock_res *alloc_mock_res(resource_size_t size, int align)
 {
 	struct cxl_mock_res *res = kzalloc(sizeof(*res), GFP_KERNEL);
 	struct genpool_data_align data = {
-		.align = SZ_256M,
+		.align = align,
 	};
 	unsigned long phys;
 
@@ -301,7 +338,7 @@ static int populate_cedt(void)
 		else
 			size = ACPI_CEDT_CHBS_LENGTH_CXL11;
 
-		res = alloc_mock_res(size);
+		res = alloc_mock_res(size, size);
 		if (!res)
 			return -ENOMEM;
 		chbs->base = res->range.start;
@@ -311,7 +348,7 @@ static int populate_cedt(void)
 	for (i = 0; i < ARRAY_SIZE(mock_cfmws); i++) {
 		struct acpi_cedt_cfmws *window = mock_cfmws[i];
 
-		res = alloc_mock_res(window->window_size);
+		res = alloc_mock_res(window->window_size, SZ_256M);
 		if (!res)
 			return -ENOMEM;
 		window->base_hpa = res->range.start;
@@ -330,6 +367,10 @@ static bool is_mock_bridge(struct device *dev)
 	for (i = 0; i < ARRAY_SIZE(cxl_hb_single); i++)
 		if (dev == &cxl_hb_single[i]->dev)
 			return true;
+	for (i = 0; i < ARRAY_SIZE(cxl_rch); i++)
+		if (dev == &cxl_rch[i]->dev)
+			return true;
+
 	return false;
 }
 
@@ -439,7 +480,7 @@ mock_acpi_evaluate_integer(acpi_handle handle, acpi_string pathname,
 	return AE_OK;
 }
 
-static struct pci_bus mock_pci_bus[NR_CXL_HOST_BRIDGES + NR_CXL_SINGLE_HOST];
+static struct pci_bus mock_pci_bus[NR_BRIDGES];
 static struct acpi_pci_root mock_pci_root[ARRAY_SIZE(mock_pci_bus)] = {
 	[0] = {
 		.bus = &mock_pci_bus[0],
@@ -450,7 +491,9 @@ static struct acpi_pci_root mock_pci_root[ARRAY_SIZE(mock_pci_bus)] = {
 	[2] = {
 		.bus = &mock_pci_bus[2],
 	},
-
+	[3] = {
+		.bus = &mock_pci_bus[3],
+	},
 };
 
 static bool is_mock_bus(struct pci_bus *bus)
@@ -736,6 +779,87 @@ static void mock_companion(struct acpi_device *adev, struct device *dev)
 #define SZ_512G (SZ_64G * 8)
 #endif
 
+static __init int cxl_rch_init(void)
+{
+	int rc, i;
+
+	for (i = 0; i < ARRAY_SIZE(cxl_rch); i++) {
+		int idx = NR_CXL_HOST_BRIDGES + NR_CXL_SINGLE_HOST + i;
+		struct acpi_device *adev = &host_bridge[idx];
+		struct platform_device *pdev;
+
+		pdev = platform_device_alloc("cxl_host_bridge", idx);
+		if (!pdev)
+			goto err_bridge;
+
+		mock_companion(adev, &pdev->dev);
+		rc = platform_device_add(pdev);
+		if (rc) {
+			platform_device_put(pdev);
+			goto err_bridge;
+		}
+
+		cxl_rch[i] = pdev;
+		mock_pci_bus[idx].bridge = &pdev->dev;
+		rc = sysfs_create_link(&pdev->dev.kobj, &pdev->dev.kobj,
+				       "firmware_node");
+		if (rc)
+			goto err_bridge;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(cxl_rcd); i++) {
+		int idx = NR_MEM_MULTI + NR_MEM_SINGLE + i;
+		struct platform_device *rch = cxl_rch[i];
+		struct platform_device *pdev;
+
+		pdev = platform_device_alloc("cxl_rcd", idx);
+		if (!pdev)
+			goto err_mem;
+		pdev->dev.parent = &rch->dev;
+		set_dev_node(&pdev->dev, i % 2);
+
+		rc = platform_device_add(pdev);
+		if (rc) {
+			platform_device_put(pdev);
+			goto err_mem;
+		}
+		cxl_rcd[i] = pdev;
+	}
+
+	return 0;
+
+err_mem:
+	for (i = ARRAY_SIZE(cxl_rcd) - 1; i >= 0; i--)
+		platform_device_unregister(cxl_rcd[i]);
+err_bridge:
+	for (i = ARRAY_SIZE(cxl_rch) - 1; i >= 0; i--) {
+		struct platform_device *pdev = cxl_rch[i];
+
+		if (!pdev)
+			continue;
+		sysfs_remove_link(&pdev->dev.kobj, "firmware_node");
+		platform_device_unregister(cxl_rch[i]);
+	}
+
+	return rc;
+}
+
+static void cxl_rch_exit(void)
+{
+	int i;
+
+	for (i = ARRAY_SIZE(cxl_rcd) - 1; i >= 0; i--)
+		platform_device_unregister(cxl_rcd[i]);
+	for (i = ARRAY_SIZE(cxl_rch) - 1; i >= 0; i--) {
+		struct platform_device *pdev = cxl_rch[i];
+
+		if (!pdev)
+			continue;
+		sysfs_remove_link(&pdev->dev.kobj, "firmware_node");
+		platform_device_unregister(cxl_rch[i]);
+	}
+}
+
 static __init int cxl_single_init(void)
 {
 	int i, rc;
@@ -1008,9 +1132,13 @@ static __init int cxl_test_init(void)
 	if (rc)
 		goto err_mem;
 
+	rc = cxl_rch_init();
+	if (rc)
+		goto err_single;
+
 	cxl_acpi = platform_device_alloc("cxl_acpi", 0);
 	if (!cxl_acpi)
-		goto err_single;
+		goto err_rch;
 
 	mock_companion(&acpi0017_mock, &cxl_acpi->dev);
 	acpi0017_mock.dev.bus = &platform_bus_type;
@@ -1023,6 +1151,8 @@ static __init int cxl_test_init(void)
 
 err_add:
 	platform_device_put(cxl_acpi);
+err_rch:
+	cxl_rch_exit();
 err_single:
 	cxl_single_exit();
 err_mem:
@@ -1060,6 +1190,7 @@ static __exit void cxl_test_exit(void)
 	int i;
 
 	platform_device_unregister(cxl_acpi);
+	cxl_rch_exit();
 	cxl_single_exit();
 	for (i = ARRAY_SIZE(cxl_mem) - 1; i >= 0; i--)
 		platform_device_unregister(cxl_mem[i]);
diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index a4ee8e61dd60..b59c5976b2d9 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -100,6 +100,24 @@ static int mock_get_log(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 	return 0;
 }
 
+static int mock_rcd_id(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mbox_identify id = {
+		.fw_revision = { "mock fw v1 " },
+		.total_capacity =
+			cpu_to_le64(DEV_SIZE / CXL_CAPACITY_MULTIPLIER),
+		.volatile_capacity =
+			cpu_to_le64(DEV_SIZE / CXL_CAPACITY_MULTIPLIER),
+	};
+
+	if (cmd->size_out < sizeof(id))
+		return -EINVAL;
+
+	memcpy(cmd->payload_out, &id, sizeof(id));
+
+	return 0;
+}
+
 static int mock_id(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_identify id = {
@@ -216,7 +234,10 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
 		rc = mock_get_log(cxlds, cmd);
 		break;
 	case CXL_MBOX_OP_IDENTIFY:
-		rc = mock_id(cxlds, cmd);
+		if (cxlds->rcd)
+			rc = mock_rcd_id(cxlds, cmd);
+		else
+			rc = mock_id(cxlds, cmd);
 		break;
 	case CXL_MBOX_OP_GET_LSA:
 		rc = mock_get_lsa(cxlds, cmd);
@@ -245,6 +266,13 @@ static void label_area_release(void *lsa)
 	vfree(lsa);
 }
 
+static bool is_rcd(struct platform_device *pdev)
+{
+	const struct platform_device_id *id = platform_get_device_id(pdev);
+
+	return !!id->driver_data;
+}
+
 static int cxl_mock_mem_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -268,6 +296,10 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	cxlds->serial = pdev->id;
 	cxlds->mbox_send = cxl_mock_mbox_send;
 	cxlds->payload_size = SZ_4K;
+	if (is_rcd(pdev)) {
+		cxlds->rcd = true;
+		cxlds->component_reg_phys = CXL_RESOURCE_NONE;
+	}
 
 	rc = cxl_enumerate_cmds(cxlds);
 	if (rc)
@@ -289,7 +321,8 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 }
 
 static const struct platform_device_id cxl_mock_mem_ids[] = {
-	{ .name = "cxl_mem", },
+	{ .name = "cxl_mem", 0 },
+	{ .name = "cxl_rcd", 1 },
 	{ },
 };
 MODULE_DEVICE_TABLE(platform, cxl_mock_mem_ids);

