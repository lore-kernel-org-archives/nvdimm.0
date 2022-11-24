Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD0533D7
	for <nvdimm@lists.linux.dev>; Thu, 24 Nov 2022 18:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669314934; x=1700850934;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tJebQl8RUUx4vxlpn/stkglQ9c3mSNB00ewB5W4CO/8=;
  b=iA3ELHjrzZpfo++NyAUlFnOXcGV/L3ZnBbJv3vojthWoybKjaBgABMf7
   bo7UodgiwdSbyS+IRcASY4z1vMpVc4rL3JHU3HgrIWwR1nk2l9Iw1dpPx
   lr0jC7VKbK+rXcGO1sES9GnVPgvBWq6OOayggQ2036mKNT+VcX8SCznkE
   4+7qXPPDz1TpC9OTC005U75RtPryZGXuZ6u7iUie1gCy8EL4z0sg6kaKz
   olDZHOrJyKzj9xpUW/Aj4lVcnZbnhFa7ivLgAwFnPClLu3Kj6m8IfSMwH
   NRLuZJ70ei0R5IBstAbiRc0VLvMfMdbARWE/S5P7rdMECK0NIu3nebS8F
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313050448"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="313050448"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 10:35:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="816926013"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="816926013"
Received: from aglevin-mobl3.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.65.252])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 10:35:32 -0800
Subject: [PATCH v4 10/12] cxl/port: Add RCD endpoint port enumeration
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: rrichter@amd.com, terry.bowman@amd.com, bhelgaas@google.com,
 dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 24 Nov 2022 10:35:32 -0800
Message-ID: <166931493266.2104015.8062923429837042172.stgit@dwillia2-xfh.jf.intel.com>
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

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/port.c |   11 +++++++++--
 drivers/cxl/cxlmem.h    |    2 ++
 drivers/cxl/mem.c       |   31 ++++++++++++++++++++++++-------
 drivers/cxl/pci.c       |   10 ++++++++++
 4 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index c7f58282b2c1..2385ee00eb9a 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1358,8 +1358,17 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
 {
 	struct device *dev = &cxlmd->dev;
 	struct device *iter;
+	struct cxl_dport *dport;
+	struct cxl_port *port;
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
@@ -1373,8 +1382,6 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
 	for (iter = dev; iter; iter = grandparent(iter)) {
 		struct device *dport_dev = grandparent(iter);
 		struct device *uport_dev;
-		struct cxl_dport *dport;
-		struct cxl_port *port;
 
 		if (!dport_dev)
 			return 0;
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
index aa63ce8c7ca6..9a655b4b5e52 100644
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
+			&cxlmd->dev, parent_dport->rcrb, CXL_RCRB_DOWNSTREAM);
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

