Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A273833D7
	for <nvdimm@lists.linux.dev>; Thu, 24 Nov 2022 18:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669314922; x=1700850922;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x4EtLml9wOxo0cFsIuPtfI1xqLkxf41ClYBYjosEXp0=;
  b=GUKuhRYkBh/K4Dh4qXb3CMBIiuZuotUvZMikUNkjfXMHIRXIzHHRIw9Y
   LpWsTkkFo0hCqwx9BxjwYpnBMOcE8R29PbFuucHDl3SDo+CAqqYm3WIxD
   wicTHdyAHHEtgOgb8gAnv8JhtfJdUMV9pnUVlDVREyerI9JOBIgl2GdkM
   YNwa+m2RZ5acfG+qgQSy9badr8+uSo9X3CLD3v0OyCIMVk7YbDOD2sKKV
   +2H+kTKQqsenkNGNf2xmDHni5QuFmlIWAVlcJVsyfD0JUIF4iO0DRGKwg
   uMltz404VIWCa7RhSg2YAoEklDvupkjVSOgLayBU9lklVNpf/QcgIA7fT
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="378608466"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="378608466"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 10:35:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="816925988"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="816925988"
Received: from aglevin-mobl3.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.65.252])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 10:35:21 -0800
Subject: [PATCH v4 08/12] cxl/acpi: Extract component registers of
 restricted hosts from RCRB
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 rrichter@amd.com, terry.bowman@amd.com, bhelgaas@google.com,
 dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 24 Nov 2022 10:35:21 -0800
Message-ID: <166931492162.2104015.17972281946627197765.stgit@dwillia2-xfh.jf.intel.com>
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

From: Robert Richter <rrichter@amd.com>

A downstream port must be connected to a component register block.
For restricted hosts the base address is determined from the RCRB. The
RCRB is provided by the host's CEDT CHBS entry. Rework CEDT parser to
get the RCRB and add code to extract the component register block from
it.

RCRB's BAR[0..1] point to the component block containing CXL subsystem
component registers. MEMBAR extraction follows the PCI base spec here,
esp. 64 bit extraction and memory range alignment (6.0, 7.5.1.2.1). The
RCRB base address is cached in the cxl_dport per-host bridge so that the
upstream port component registers can be retrieved later by an RCD
(RCIEP) associated with the host bridge.

Note: Right now the component register block is used for HDM decoder
capability only which is optional for RCDs. If unsupported by the RCD,
the HDM init will fail. It is future work to bypass it in this case.

Co-developed-by: Terry Bowman <terry.bowman@amd.com>
Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Signed-off-by: Robert Richter <rrichter@amd.com>
[djbw: introduce devm_cxl_add_rch_dport()]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/acpi.c            |   54 ++++++++++++++++++++++++++++++++--------
 drivers/cxl/core/port.c       |   42 +++++++++++++++++++++++++++----
 drivers/cxl/core/regs.c       |   56 +++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h             |   16 ++++++++++++
 tools/testing/cxl/Kbuild      |    1 +
 tools/testing/cxl/test/cxl.c  |   10 +++++++
 tools/testing/cxl/test/mock.c |   19 ++++++++++++++
 tools/testing/cxl/test/mock.h |    3 ++
 8 files changed, 186 insertions(+), 15 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 50d82376097c..1224add13529 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -9,6 +9,8 @@
 #include "cxlpci.h"
 #include "cxl.h"
 
+#define CXL_RCRB_SIZE	SZ_8K
+
 static unsigned long cfmws_to_decoder_flags(int restrictions)
 {
 	unsigned long flags = CXL_DECODER_F_ENABLE;
@@ -215,6 +217,11 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 	if (rc)
 		return rc;
 
+	if (dport->rch) {
+		dev_info(bridge, "host supports CXL (restricted)\n");
+		return 0;
+	}
+
 	port = devm_cxl_add_port(host, bridge, dport->component_reg_phys,
 				 dport);
 	if (IS_ERR(port))
@@ -228,27 +235,46 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 struct cxl_chbs_context {
 	struct device *dev;
 	unsigned long long uid;
-	resource_size_t chbcr;
+	struct acpi_cedt_chbs chbs;
 };
 
-static int cxl_get_chbcr(union acpi_subtable_headers *header, void *arg,
-			 const unsigned long end)
+static int cxl_get_chbs(union acpi_subtable_headers *header, void *arg,
+			const unsigned long end)
 {
 	struct cxl_chbs_context *ctx = arg;
 	struct acpi_cedt_chbs *chbs;
 
-	if (ctx->chbcr)
+	if (ctx->chbs.base)
 		return 0;
 
 	chbs = (struct acpi_cedt_chbs *) header;
 
 	if (ctx->uid != chbs->uid)
 		return 0;
-	ctx->chbcr = chbs->base;
+	ctx->chbs = *chbs;
 
 	return 0;
 }
 
+static resource_size_t cxl_get_chbcr(struct cxl_chbs_context *ctx)
+{
+	struct acpi_cedt_chbs *chbs = &ctx->chbs;
+
+	if (!chbs->base)
+		return CXL_RESOURCE_NONE;
+
+	if (chbs->cxl_version != ACPI_CEDT_CHBS_VERSION_CXL11)
+		return chbs->base;
+
+	if (chbs->length != CXL_RCRB_SIZE)
+		return CXL_RESOURCE_NONE;
+
+	dev_dbg(ctx->dev, "RCRB found for UID %lld: %pa\n", ctx->uid,
+		&chbs->base);
+
+	return cxl_rcrb_to_component(ctx->dev, chbs->base, CXL_RCRB_DOWNSTREAM);
+}
+
 static int add_host_bridge_dport(struct device *match, void *arg)
 {
 	acpi_status status;
@@ -258,6 +284,7 @@ static int add_host_bridge_dport(struct device *match, void *arg)
 	struct cxl_chbs_context ctx;
 	struct acpi_pci_root *pci_root;
 	struct cxl_port *root_port = arg;
+	resource_size_t component_reg_phys;
 	struct device *host = root_port->dev.parent;
 	struct acpi_device *hb = to_cxl_host_bridge(host, match);
 
@@ -274,21 +301,28 @@ static int add_host_bridge_dport(struct device *match, void *arg)
 	dev_dbg(match, "UID found: %lld\n", uid);
 
 	ctx = (struct cxl_chbs_context) {
-		.dev = host,
+		.dev = match,
 		.uid = uid,
 	};
-	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbcr, &ctx);
+	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbs, &ctx);
 
-	if (ctx.chbcr == 0) {
+	component_reg_phys = cxl_get_chbcr(&ctx);
+	if (component_reg_phys == CXL_RESOURCE_NONE) {
 		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
 		return 0;
 	}
 
-	dev_dbg(match, "CHBCR found: 0x%08llx\n", (u64)ctx.chbcr);
+	dev_dbg(match, "CHBCR found: %pa\n", &component_reg_phys);
 
 	pci_root = acpi_pci_find_root(hb->handle);
 	bridge = pci_root->bus->bridge;
-	dport = devm_cxl_add_dport(root_port, bridge, uid, ctx.chbcr);
+	if (ctx.chbs.cxl_version == ACPI_CEDT_CHBS_VERSION_CXL11)
+		dport = devm_cxl_add_rch_dport(root_port, bridge, uid,
+					       component_reg_phys,
+					       ctx.chbs.base);
+	else
+		dport = devm_cxl_add_dport(root_port, bridge, uid,
+					   component_reg_phys);
 	if (IS_ERR(dport))
 		return PTR_ERR(dport);
 
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index d225267c69bb..d9fe06e1462f 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -628,6 +628,8 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
 			iter = to_cxl_port(iter->dev.parent);
 		if (iter->host_bridge)
 			port->host_bridge = iter->host_bridge;
+		else if (parent_dport->rch)
+			port->host_bridge = parent_dport->dport;
 		else
 			port->host_bridge = iter->uport;
 		dev_dbg(uport, "host-bridge: %s\n", dev_name(port->host_bridge));
@@ -899,10 +901,15 @@ static void cxl_dport_unlink(void *data)
 	sysfs_remove_link(&port->dev.kobj, link_name);
 }
 
-static struct cxl_dport *__devm_cxl_add_dport(struct cxl_port *port,
-					      struct device *dport_dev,
-					      int port_id,
-					      resource_size_t component_reg_phys)
+enum cxl_dport_mode {
+	CXL_DPORT_VH,
+	CXL_DPORT_RCH,
+};
+
+static struct cxl_dport *
+__devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
+		     int port_id, resource_size_t component_reg_phys,
+		     enum cxl_dport_mode mode, resource_size_t rcrb)
 {
 	char link_name[CXL_TARGET_STRLEN];
 	struct cxl_dport *dport;
@@ -932,6 +939,9 @@ static struct cxl_dport *__devm_cxl_add_dport(struct cxl_port *port,
 	dport->port_id = port_id;
 	dport->component_reg_phys = component_reg_phys;
 	dport->port = port;
+	if (mode == CXL_DPORT_RCH)
+		dport->rch = true;
+	dport->rcrb = rcrb;
 
 	cond_cxl_root_lock(port);
 	rc = add_dport(port, dport);
@@ -973,7 +983,8 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
 	struct cxl_dport *dport;
 
 	dport = __devm_cxl_add_dport(port, dport_dev, port_id,
-				     component_reg_phys);
+				     component_reg_phys, CXL_DPORT_VH,
+				     CXL_RESOURCE_NONE);
 	if (IS_ERR(dport)) {
 		dev_dbg(dport_dev, "failed to add dport to %s: %ld\n",
 			dev_name(&port->dev), PTR_ERR(dport));
@@ -986,6 +997,27 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_add_dport, CXL);
 
+struct cxl_dport *devm_cxl_add_rch_dport(struct cxl_port *port,
+					 struct device *dport_dev, int port_id,
+					 resource_size_t component_reg_phys,
+					 resource_size_t rcrb)
+{
+	struct cxl_dport *dport;
+
+	dport = __devm_cxl_add_dport(port, dport_dev, port_id,
+				     component_reg_phys, CXL_DPORT_RCH, rcrb);
+	if (IS_ERR(dport)) {
+		dev_dbg(dport_dev, "failed to add RCH dport to %s: %ld\n",
+			dev_name(&port->dev), PTR_ERR(dport));
+	} else {
+		dev_dbg(dport_dev, "RCH dport added to %s\n",
+			dev_name(&port->dev));
+	}
+
+	return dport;
+}
+EXPORT_SYMBOL_NS_GPL(devm_cxl_add_rch_dport, CXL);
+
 static int add_ep(struct cxl_ep *new)
 {
 	struct cxl_port *port = new->dport->port;
diff --git a/drivers/cxl/core/regs.c b/drivers/cxl/core/regs.c
index ec178e69b18f..7c2a85dc4125 100644
--- a/drivers/cxl/core/regs.c
+++ b/drivers/cxl/core/regs.c
@@ -307,3 +307,59 @@ int cxl_find_regblock(struct pci_dev *pdev, enum cxl_regloc_type type,
 	return -ENODEV;
 }
 EXPORT_SYMBOL_NS_GPL(cxl_find_regblock, CXL);
+
+resource_size_t cxl_rcrb_to_component(struct device *dev,
+				      resource_size_t rcrb,
+				      enum cxl_rcrb which)
+{
+	resource_size_t component_reg_phys;
+	u32 bar0, bar1;
+	void *addr;
+	u16 cmd;
+
+	if (which == CXL_RCRB_UPSTREAM)
+		rcrb += SZ_4K;
+
+	/*
+	 * RCRB's BAR[0..1] point to component block containing CXL
+	 * subsystem component registers. MEMBAR extraction follows
+	 * the PCI Base spec here, esp. 64 bit extraction and memory
+	 * ranges alignment (6.0, 7.5.1.2.1).
+	 */
+	if (!request_mem_region(rcrb, SZ_4K, "CXL RCRB"))
+		return CXL_RESOURCE_NONE;
+	addr = ioremap(rcrb, SZ_4K);
+	if (!addr) {
+		dev_err(dev, "Failed to map region %pr\n", addr);
+		release_mem_region(rcrb, SZ_4K);
+		return CXL_RESOURCE_NONE;
+	}
+
+	cmd = readw(addr + PCI_COMMAND);
+	bar0 = readl(addr + PCI_BASE_ADDRESS_0);
+	bar1 = readl(addr + PCI_BASE_ADDRESS_1);
+	iounmap(addr);
+	release_mem_region(rcrb, SZ_4K);
+
+	/* sanity check */
+	if (cmd == 0xffff)
+		return CXL_RESOURCE_NONE;
+	if ((cmd & PCI_COMMAND_MEMORY) == 0)
+		return CXL_RESOURCE_NONE;
+	if (bar0 & (PCI_BASE_ADDRESS_MEM_TYPE_1M | PCI_BASE_ADDRESS_SPACE_IO))
+		return CXL_RESOURCE_NONE;
+
+	component_reg_phys = bar0 & PCI_BASE_ADDRESS_MEM_MASK;
+	if (bar0 & PCI_BASE_ADDRESS_MEM_TYPE_64)
+		component_reg_phys |= ((u64)bar1) << 32;
+
+	if (!component_reg_phys)
+		return CXL_RESOURCE_NONE;
+
+	/* MEMBAR is block size (64k) aligned. */
+	if (!IS_ALIGNED(component_reg_phys, CXL_COMPONENT_REG_BLOCK_SIZE))
+		return CXL_RESOURCE_NONE;
+
+	return component_reg_phys;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_rcrb_to_component, CXL);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 9b33ae4b2aec..43c43d1ec069 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -223,6 +223,14 @@ enum cxl_regloc_type;
 int cxl_find_regblock(struct pci_dev *pdev, enum cxl_regloc_type type,
 		      struct cxl_register_map *map);
 
+enum cxl_rcrb {
+	CXL_RCRB_DOWNSTREAM,
+	CXL_RCRB_UPSTREAM,
+};
+resource_size_t cxl_rcrb_to_component(struct device *dev,
+				      resource_size_t rcrb,
+				      enum cxl_rcrb which);
+
 #define CXL_RESOURCE_NONE ((resource_size_t) -1)
 #define CXL_TARGET_STRLEN 20
 
@@ -486,12 +494,16 @@ cxl_find_dport_by_dev(struct cxl_port *port, const struct device *dport_dev)
  * @dport: PCI bridge or firmware device representing the downstream link
  * @port_id: unique hardware identifier for dport in decoder target list
  * @component_reg_phys: downstream port component registers
+ * @rcrb: base address for the Root Complex Register Block
+ * @rch: Indicate whether this dport was enumerated in RCH or VH mode
  * @port: reference to cxl_port that contains this downstream port
  */
 struct cxl_dport {
 	struct device *dport;
 	int port_id;
 	resource_size_t component_reg_phys;
+	resource_size_t rcrb;
+	bool rch;
 	struct cxl_port *port;
 };
 
@@ -561,6 +573,10 @@ bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd);
 struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
 				     struct device *dport, int port_id,
 				     resource_size_t component_reg_phys);
+struct cxl_dport *devm_cxl_add_rch_dport(struct cxl_port *port,
+					 struct device *dport_dev, int port_id,
+					 resource_size_t component_reg_phys,
+					 resource_size_t rcrb);
 
 struct cxl_decoder *to_cxl_decoder(struct device *dev);
 struct cxl_root_decoder *to_cxl_root_decoder(struct device *dev);
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 500be85729cc..9e4d94e81723 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -10,6 +10,7 @@ ldflags-y += --wrap=devm_cxl_add_passthrough_decoder
 ldflags-y += --wrap=devm_cxl_enumerate_decoders
 ldflags-y += --wrap=cxl_await_media_ready
 ldflags-y += --wrap=cxl_hdm_decode_init
+ldflags-y += --wrap=cxl_rcrb_to_component
 
 DRIVERS := ../../../drivers
 CXL_SRC := $(DRIVERS)/cxl
diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 42a34650dd2f..1823c61d7ba3 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -694,6 +694,15 @@ static int mock_cxl_port_enumerate_dports(struct cxl_port *port)
 	return 0;
 }
 
+resource_size_t mock_cxl_rcrb_to_component(struct device *dev,
+					   resource_size_t rcrb,
+					   enum cxl_rcrb which)
+{
+	dev_dbg(dev, "rcrb: %pa which: %d\n", &rcrb, which);
+
+	return 0;
+}
+
 static struct cxl_mock_ops cxl_mock_ops = {
 	.is_mock_adev = is_mock_adev,
 	.is_mock_bridge = is_mock_bridge,
@@ -702,6 +711,7 @@ static struct cxl_mock_ops cxl_mock_ops = {
 	.is_mock_dev = is_mock_dev,
 	.acpi_table_parse_cedt = mock_acpi_table_parse_cedt,
 	.acpi_evaluate_integer = mock_acpi_evaluate_integer,
+	.cxl_rcrb_to_component = mock_cxl_rcrb_to_component,
 	.acpi_pci_find_root = mock_acpi_pci_find_root,
 	.devm_cxl_port_enumerate_dports = mock_cxl_port_enumerate_dports,
 	.devm_cxl_setup_hdm = mock_cxl_setup_hdm,
diff --git a/tools/testing/cxl/test/mock.c b/tools/testing/cxl/test/mock.c
index bce6a21df0d5..5dface08e0de 100644
--- a/tools/testing/cxl/test/mock.c
+++ b/tools/testing/cxl/test/mock.c
@@ -224,6 +224,25 @@ int __wrap_cxl_hdm_decode_init(struct cxl_dev_state *cxlds,
 }
 EXPORT_SYMBOL_NS_GPL(__wrap_cxl_hdm_decode_init, CXL);
 
+resource_size_t __wrap_cxl_rcrb_to_component(struct device *dev,
+					     resource_size_t rcrb,
+					     enum cxl_rcrb which)
+{
+	int index;
+	resource_size_t component_reg_phys;
+	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
+
+	if (ops && ops->is_mock_port(dev))
+		component_reg_phys =
+			ops->cxl_rcrb_to_component(dev, rcrb, which);
+	else
+		component_reg_phys = cxl_rcrb_to_component(dev, rcrb, which);
+	put_cxl_mock_ops(index);
+
+	return component_reg_phys;
+}
+EXPORT_SYMBOL_NS_GPL(__wrap_cxl_rcrb_to_component, CXL);
+
 MODULE_LICENSE("GPL v2");
 MODULE_IMPORT_NS(ACPI);
 MODULE_IMPORT_NS(CXL);
diff --git a/tools/testing/cxl/test/mock.h b/tools/testing/cxl/test/mock.h
index 738f24e3988a..ef33f159375e 100644
--- a/tools/testing/cxl/test/mock.h
+++ b/tools/testing/cxl/test/mock.h
@@ -15,6 +15,9 @@ struct cxl_mock_ops {
 					     acpi_string pathname,
 					     struct acpi_object_list *arguments,
 					     unsigned long long *data);
+	resource_size_t (*cxl_rcrb_to_component)(struct device *dev,
+						 resource_size_t rcrb,
+						 enum cxl_rcrb which);
 	struct acpi_pci_root *(*acpi_pci_find_root)(acpi_handle handle);
 	bool (*is_mock_bus)(struct pci_bus *bus);
 	bool (*is_mock_port)(struct device *dev);

