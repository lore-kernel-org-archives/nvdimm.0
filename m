Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670AD10782
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 21:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669930446; x=1701466446;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TX8q7SE6aou8uClElP+BHOuWwPLwLseEWV5Hk3z2aUQ=;
  b=bUWWdCJrF/QCC4ZC3GoMge7lJXGP6n1rwRlxeFvuFIfgHhCbMZPmhLCr
   k4ao3k2KDgtiGJcDiQNypVyY7TvupfJ+w1snbCNBcVHInb5wpg696VjEy
   //bUeiSmiT6nMS1vzy2tLPydteUvwqbTswQOjGaGuxZe2ylKjeH+fLjab
   ogIyf6HR49qI3opxC4G2xd0ker+vYDxXIQRq+buxNPTg2TVCDFmekwlAq
   RNcn/KVAipD9bs5bDNcFEIhkg3YuNUbYmKc6eEqGwYD/NXKgZVCvNVy7+
   10oQF475aWDjlxeuPf1RtpfKqjHDo0WCvWSTnSQSp/aEM00ZqJ1h2I+xi
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="313443277"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="313443277"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:34:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="675594810"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="675594810"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:34:05 -0800
Subject: [PATCH v6 08/12] cxl/acpi: Extract component registers of
 restricted hosts from RCRB
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 alison.schofield@intel.com, rrichter@amd.com, terry.bowman@amd.com,
 bhelgaas@google.com, dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 01 Dec 2022 13:34:05 -0800
Message-ID: <166993044524.1882361.2539922887413208807.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
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
Link: https://lore.kernel.org/r/Y4dsGZ24aJlxSfI1@rric.localdomain
[djbw: introduce devm_cxl_add_rch_dport()]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/acpi.c            |   51 ++++++++++++++++++++++++++++-----
 drivers/cxl/core/port.c       |   53 ++++++++++++++++++++++++++++++----
 drivers/cxl/core/regs.c       |   64 +++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h             |   16 ++++++++++
 tools/testing/cxl/Kbuild      |    1 +
 tools/testing/cxl/test/cxl.c  |   10 ++++++
 tools/testing/cxl/test/mock.c |   19 ++++++++++++
 tools/testing/cxl/test/mock.h |    3 ++
 8 files changed, 203 insertions(+), 14 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 50d82376097c..db8173f3ee10 100644
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
@@ -211,6 +213,11 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 		return 0;
 	}
 
+	if (dport->rch) {
+		dev_info(bridge, "host supports CXL (restricted)\n");
+		return 0;
+	}
+
 	rc = devm_cxl_register_pci_bus(host, bridge, pci_root->bus);
 	if (rc)
 		return rc;
@@ -226,9 +233,11 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 }
 
 struct cxl_chbs_context {
-	struct device *dev;
-	unsigned long long uid;
-	resource_size_t chbcr;
+	struct device		*dev;
+	unsigned long long	uid;
+	resource_size_t		rcrb;
+	resource_size_t		chbcr;
+	u32			cxl_version;
 };
 
 static int cxl_get_chbcr(union acpi_subtable_headers *header, void *arg,
@@ -244,7 +253,25 @@ static int cxl_get_chbcr(union acpi_subtable_headers *header, void *arg,
 
 	if (ctx->uid != chbs->uid)
 		return 0;
-	ctx->chbcr = chbs->base;
+
+	ctx->cxl_version = chbs->cxl_version;
+	ctx->rcrb = CXL_RESOURCE_NONE;
+	ctx->chbcr = CXL_RESOURCE_NONE;
+
+	if (!chbs->base)
+		return 0;
+
+	if (chbs->cxl_version != ACPI_CEDT_CHBS_VERSION_CXL11) {
+		ctx->chbcr = chbs->base;
+		return 0;
+	}
+
+	if (chbs->length != CXL_RCRB_SIZE)
+		return 0;
+
+	ctx->rcrb = chbs->base;
+	ctx->chbcr = cxl_rcrb_to_component(ctx->dev, chbs->base,
+					   CXL_RCRB_DOWNSTREAM);
 
 	return 0;
 }
@@ -274,21 +301,29 @@ static int add_host_bridge_dport(struct device *match, void *arg)
 	dev_dbg(match, "UID found: %lld\n", uid);
 
 	ctx = (struct cxl_chbs_context) {
-		.dev = host,
+		.dev = match,
 		.uid = uid,
 	};
 	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbcr, &ctx);
 
-	if (ctx.chbcr == 0) {
+	if (ctx.rcrb != CXL_RESOURCE_NONE)
+		dev_dbg(match, "RCRB found for UID %lld: %pa\n", uid, &ctx.rcrb);
+
+	if (ctx.chbcr == CXL_RESOURCE_NONE) {
 		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
 		return 0;
 	}
 
-	dev_dbg(match, "CHBCR found: 0x%08llx\n", (u64)ctx.chbcr);
+	dev_dbg(match, "CHBCR found: %pa\n", &ctx.chbcr);
 
 	pci_root = acpi_pci_find_root(hb->handle);
 	bridge = pci_root->bus->bridge;
-	dport = devm_cxl_add_dport(root_port, bridge, uid, ctx.chbcr);
+	if (ctx.cxl_version == ACPI_CEDT_CHBS_VERSION_CXL11)
+		dport = devm_cxl_add_rch_dport(root_port, bridge, uid,
+					       ctx.chbcr, ctx.rcrb);
+	else
+		dport = devm_cxl_add_dport(root_port, bridge, uid,
+					   ctx.chbcr);
 	if (IS_ERR(dport))
 		return PTR_ERR(dport);
 
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index d225267c69bb..dae2ca31885e 100644
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
@@ -899,10 +901,10 @@ static void cxl_dport_unlink(void *data)
 	sysfs_remove_link(&port->dev.kobj, link_name);
 }
 
-static struct cxl_dport *__devm_cxl_add_dport(struct cxl_port *port,
-					      struct device *dport_dev,
-					      int port_id,
-					      resource_size_t component_reg_phys)
+static struct cxl_dport *
+__devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
+		     int port_id, resource_size_t component_reg_phys,
+		     resource_size_t rcrb)
 {
 	char link_name[CXL_TARGET_STRLEN];
 	struct cxl_dport *dport;
@@ -932,6 +934,9 @@ static struct cxl_dport *__devm_cxl_add_dport(struct cxl_port *port,
 	dport->port_id = port_id;
 	dport->component_reg_phys = component_reg_phys;
 	dport->port = port;
+	if (rcrb != CXL_RESOURCE_NONE)
+		dport->rch = true;
+	dport->rcrb = rcrb;
 
 	cond_cxl_root_lock(port);
 	rc = add_dport(port, dport);
@@ -956,7 +961,7 @@ static struct cxl_dport *__devm_cxl_add_dport(struct cxl_port *port,
 }
 
 /**
- * devm_cxl_add_dport - append downstream port data to a cxl_port
+ * devm_cxl_add_dport - append VH downstream port data to a cxl_port
  * @port: the cxl_port that references this dport
  * @dport_dev: firmware or PCI device representing the dport
  * @port_id: identifier for this dport in a decoder's target list
@@ -973,7 +978,7 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
 	struct cxl_dport *dport;
 
 	dport = __devm_cxl_add_dport(port, dport_dev, port_id,
-				     component_reg_phys);
+				     component_reg_phys, CXL_RESOURCE_NONE);
 	if (IS_ERR(dport)) {
 		dev_dbg(dport_dev, "failed to add dport to %s: %ld\n",
 			dev_name(&port->dev), PTR_ERR(dport));
@@ -986,6 +991,42 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_add_dport, CXL);
 
+/**
+ * devm_cxl_add_rch_dport - append RCH downstream port data to a cxl_port
+ * @port: the cxl_port that references this dport
+ * @dport_dev: firmware or PCI device representing the dport
+ * @port_id: identifier for this dport in a decoder's target list
+ * @component_reg_phys: optional location of CXL component registers
+ * @rcrb: mandatory location of a Root Complex Register Block
+ *
+ * See CXL 3.0 9.11.8 CXL Devices Attached to an RCH
+ */
+struct cxl_dport *devm_cxl_add_rch_dport(struct cxl_port *port,
+					 struct device *dport_dev, int port_id,
+					 resource_size_t component_reg_phys,
+					 resource_size_t rcrb)
+{
+	struct cxl_dport *dport;
+
+	if (rcrb == CXL_RESOURCE_NONE) {
+		dev_dbg(&port->dev, "failed to add RCH dport, missing RCRB\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	dport = __devm_cxl_add_dport(port, dport_dev, port_id,
+				     component_reg_phys, rcrb);
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
index ec178e69b18f..28ed0ec8ee3e 100644
--- a/drivers/cxl/core/regs.c
+++ b/drivers/cxl/core/regs.c
@@ -307,3 +307,67 @@ int cxl_find_regblock(struct pci_dev *pdev, enum cxl_regloc_type type,
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
+	u32 id;
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
+	id = readl(addr + PCI_VENDOR_ID);
+	cmd = readw(addr + PCI_COMMAND);
+	bar0 = readl(addr + PCI_BASE_ADDRESS_0);
+	bar1 = readl(addr + PCI_BASE_ADDRESS_1);
+	iounmap(addr);
+	release_mem_region(rcrb, SZ_4K);
+
+	/*
+	 * Sanity check, see CXL 3.0 Figure 9-8 CXL Device that Does Not
+	 * Remap Upstream Port and Component Registers
+	 */
+	if (id == U32_MAX) {
+		if (which == CXL_RCRB_DOWNSTREAM)
+			dev_err(dev, "Failed to access Downstream Port RCRB\n");
+		return CXL_RESOURCE_NONE;
+	}
+	if (!(cmd & PCI_COMMAND_MEMORY))
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
index 281b1db5a271..1342e4e61537 100644
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
index 8acf52b7dab2..c1e395a5b8f7 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -696,6 +696,15 @@ static int mock_cxl_port_enumerate_dports(struct cxl_port *port)
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
@@ -704,6 +713,7 @@ static struct cxl_mock_ops cxl_mock_ops = {
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

