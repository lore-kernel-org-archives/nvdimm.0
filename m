Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F97F10782
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 21:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669930457; x=1701466457;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O98m4xMzy9cK/S1X5uAeN+yITSkCvgF1iUiOGQt6z/E=;
  b=Ftg1RqBY0JcYzjOS9yLYA2NerwxF/KsrGV6qComjO5nmTVndwS3CYjME
   ByvqpxDrZrQ+0MFpwP0o1hwlxDG/yJKmel2oTwvhxE2+DJdDRaFDA1K6n
   iLW+SeJQg2SAxMQf7bdNfB+QFCOlr/UkGHYOoMSByLyD4m3g58V+r+wMY
   hGY4pOsE+qDsk60bDfPDKw1hUdqyaQgK7rsqC6LzG7NklQaOqEm9QUVIW
   nwkTz8DH8IC3s6SghF/SAX0/0S9/fX/pXeS0lIkyAFZl/AfOLDp+vD/FL
   Yh7B1P4u0FKvN9QOBQguMQxEQW170Q5qCMle3cO8svn00NFX+0hvatQoA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="313443320"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="313443320"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:34:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="675594837"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="675594837"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:34:16 -0800
Subject: [PATCH v6 10/12] cxl/port: Add RCD endpoint port enumeration
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Robert Richter <rrichter@amd.com>, alison.schofield@intel.com,
 rrichter@amd.com, terry.bowman@amd.com, bhelgaas@google.com,
 dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 01 Dec 2022 13:34:16 -0800
Message-ID: <166993045621.1882361.1730100141527044744.stgit@dwillia2-xfh.jf.intel.com>
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
Content-Transfer-Encoding: 8bit

Unlike a CXL memory expander in a VH topology that has at least one
intervening 'struct cxl_port' instance between itself and the CXL root
device, an RCD attaches one-level higher. For example:

               VH
          ┌──────────┐
          │ ACPI0017 │
          │  root0   │
          └─────┬────┘
                │
          ┌─────┴────┐
          │  dport0  │
    ┌─────┤ ACPI0016 ├─────┐
    │     │  port1   │     │
    │     └────┬─────┘     │
    │          │           │
 ┌──┴───┐   ┌──┴───┐   ┌───┴──┐
 │dport0│   │dport1│   │dport2│
 │ RP0  │   │ RP1  │   │ RP2  │
 └──────┘   └──┬───┘   └──────┘
               │
           ┌───┴─────┐
           │endpoint0│
           │  port2  │
           └─────────┘

...vs:

              RCH
          ┌──────────┐
          │ ACPI0017 │
          │  root0   │
          └────┬─────┘
               │
           ┌───┴────┐
           │ dport0 │
           │ACPI0016│
           └───┬────┘
               │
          ┌────┴─────┐
          │endpoint0 │
          │  port1   │
          └──────────┘

So arrange for endpoint port in the RCH/RCD case to appear directly
connected to the host-bridge in its singular role as a dport. Compare
that to the VH case where the host-bridge serves a dual role as a
'cxl_dport' for the CXL root device *and* a 'cxl_port' upstream port for
the Root Ports in the Root Complex that are modeled as 'cxl_dport'
instances in the CXL topology.

Another deviation from the VH case is that RCDs may need to look up
their component registers from the Root Complex Register Block (RCRB).
That platform firmware specified RCRB area is cached by the cxl_acpi
driver and conveyed via the host-bridge dport to the cxl_mem driver to
perform the cxl_rcrb_to_component() lookup for the endpoint port
(See 9.11.8 CXL Devices Attached to an RCH for the lookup of the
upstream port component registers).

Tested-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/port.c |    7 +++++++
 drivers/cxl/cxlmem.h    |    2 ++
 drivers/cxl/mem.c       |   31 ++++++++++++++++++++++++-------
 drivers/cxl/pci.c       |   10 ++++++++++
 4 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 4982b6902ef5..50bdbd9f8da3 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1369,6 +1369,13 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
 	struct device *iter;
 	int rc;
 
+	/*
+	 * Skip intermediate port enumeration in the RCH case, there
+	 * are no ports in between a host bridge and an endpoint.
+	 */
+	if (cxlmd->cxlds->rcd)
+		return 0;
+
 	rc = devm_add_action_or_reset(&cxlmd->dev, cxl_detach_ep, cxlmd);
 	if (rc)
 		return rc;
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index e082991bc58c..35d485d041f0 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -201,6 +201,7 @@ struct cxl_endpoint_dvsec_info {
  * @dev: The device associated with this CXL state
  * @regs: Parsed register blocks
  * @cxl_dvsec: Offset to the PCIe device DVSEC
+ * @rcd: operating in RCD mode (CXL 3.0 9.11.8 CXL Devices Attached to an RCH)
  * @payload_size: Size of space for payload
  *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
  * @lsa_size: Size of Label Storage Area
@@ -235,6 +236,7 @@ struct cxl_dev_state {
 	struct cxl_regs regs;
 	int cxl_dvsec;
 
+	bool rcd;
 	size_t payload_size;
 	size_t lsa_size;
 	struct mutex mbox_mutex; /* Protects device mailbox and firmware */
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index aa63ce8c7ca6..4b94e63f78ec 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -45,12 +45,13 @@ static int cxl_mem_dpa_show(struct seq_file *file, void *data)
 	return 0;
 }
 
-static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
+static int devm_cxl_add_endpoint(struct device *host, struct cxl_memdev *cxlmd,
 				 struct cxl_dport *parent_dport)
 {
 	struct cxl_port *parent_port = parent_dport->port;
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct cxl_port *endpoint, *iter, *down;
+	resource_size_t component_reg_phys;
 	int rc;
 
 	/*
@@ -65,8 +66,18 @@ static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
 		ep->next = down;
 	}
 
-	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
-				     cxlds->component_reg_phys, parent_dport);
+	/*
+	 * The component registers for an RCD might come from the
+	 * host-bridge RCRB if they are not already mapped via the
+	 * typical register locator mechanism.
+	 */
+	if (parent_dport->rch && cxlds->component_reg_phys == CXL_RESOURCE_NONE)
+		component_reg_phys = cxl_rcrb_to_component(
+			&cxlmd->dev, parent_dport->rcrb, CXL_RCRB_UPSTREAM);
+	else
+		component_reg_phys = cxlds->component_reg_phys;
+	endpoint = devm_cxl_add_port(host, &cxlmd->dev, component_reg_phys,
+				     parent_dport);
 	if (IS_ERR(endpoint))
 		return PTR_ERR(endpoint);
 
@@ -87,6 +98,7 @@ static int cxl_mem_probe(struct device *dev)
 {
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	struct device *endpoint_parent;
 	struct cxl_port *parent_port;
 	struct cxl_dport *dport;
 	struct dentry *dentry;
@@ -119,17 +131,22 @@ static int cxl_mem_probe(struct device *dev)
 		return -ENXIO;
 	}
 
-	device_lock(&parent_port->dev);
-	if (!parent_port->dev.driver) {
+	if (dport->rch)
+		endpoint_parent = parent_port->uport;
+	else
+		endpoint_parent = &parent_port->dev;
+
+	device_lock(endpoint_parent);
+	if (!endpoint_parent->driver) {
 		dev_err(dev, "CXL port topology %s not enabled\n",
 			dev_name(&parent_port->dev));
 		rc = -ENXIO;
 		goto unlock;
 	}
 
-	rc = devm_cxl_add_endpoint(cxlmd, dport);
+	rc = devm_cxl_add_endpoint(endpoint_parent, cxlmd, dport);
 unlock:
-	device_unlock(&parent_port->dev);
+	device_unlock(endpoint_parent);
 	put_device(&parent_port->dev);
 	if (rc)
 		return rc;
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index e15da405b948..73ff6c33a0c0 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -433,6 +433,15 @@ static void devm_cxl_pci_create_doe(struct cxl_dev_state *cxlds)
 	}
 }
 
+/*
+ * Assume that any RCIEP that emits the CXL memory expander class code
+ * is an RCD
+ */
+static bool is_cxl_restricted(struct pci_dev *pdev)
+{
+	return pci_pcie_type(pdev) == PCI_EXP_TYPE_RC_END;
+}
+
 static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct cxl_register_map map;
@@ -455,6 +464,7 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (IS_ERR(cxlds))
 		return PTR_ERR(cxlds);
 
+	cxlds->rcd = is_cxl_restricted(pdev);
 	cxlds->serial = pci_get_dsn(pdev);
 	cxlds->cxl_dvsec = pci_find_dvsec_capability(
 		pdev, PCI_DVSEC_VENDOR_ID_CXL, CXL_DVSEC_PCIE_DEVICE);

