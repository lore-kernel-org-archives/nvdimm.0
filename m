Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1837D6D17
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 00:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657843273; x=1689379273;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yIncCty2UR6oXNxbEEHSGl8uWj7bPEwM/IqHg+ZT7g8=;
  b=eW1uIJmMQFuo/cPRQ8wkfPvFyKhdYzXQbTeroFe4+lsizid93nygtSfT
   bS5lnr0XERoo3uvOPeDDDClDEC4r3JMkRwX//VwlkZRxOnLYoPlClC78C
   UgNPwxDRch4Xs5E4/Iq93sVup4x0XJuYwrWHj5MRxBHNCFlm1bVzcFMIh
   bfDgUP6LS7fMj6fJU6cTrc4WGz4+SuuZVoeQWF2jsk9IYOfczEvMUkISs
   Rvu1zkeKjlrhRag6+D+6xi6c1RC9Ntwy/vOhBWI7a+DHY2ws8mxAWD6vT
   pE70Td3GlvyJyFm8H+MCWeYRwCmAC/nXNIciyXPw/fcETplXzSctsif8/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="283219233"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="283219233"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:01:06 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="546461332"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:01:05 -0700
Subject: [PATCH v2 04/28] cxl/core: Define a 'struct cxl_root_decoder'
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <bwidawsk@kernel.org>, hch@lst.de, nvdimm@lists.linux.dev,
 linux-pci@vger.kernel.org
Date: Thu, 14 Jul 2022 17:01:05 -0700
Message-ID: <165784326541.1758207.9915663937394448341.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Previously the target routing specifics of switch decoders were factored
out of 'struct cxl_decoder' into 'struct cxl_switch_decoder'.

This patch, 2 of 3, adds a 'struct cxl_root_decoder' as a superset of a
switch decoder that also track the associated CXL window platform
resource.

Note that the reason the resource for a given root decoder needs to be
looked up after the fact (i.e. after cxl_parse_cfmws() and
add_cxl_resource()) is because add_cxl_resource() may have merged CXL
windows in order to keep them at the top of the resource tree / decode
hierarchy.

Co-developed-by: Ben Widawsky <bwidawsk@kernel.org>
Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/acpi.c      |   40 ++++++++++++++++++++++++++++++++++++----
 drivers/cxl/core/port.c |   34 +++++++++++++++++++++++++++-------
 drivers/cxl/cxl.h       |   15 +++++++++++++--
 3 files changed, 76 insertions(+), 13 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index e2b6cbd04846..8f021241699f 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -84,7 +84,7 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
 	struct cxl_cfmws_context *ctx = arg;
 	struct cxl_port *root_port = ctx->root_port;
 	struct resource *cxl_res = ctx->cxl_res;
-	struct cxl_switch_decoder *cxlsd;
+	struct cxl_root_decoder *cxlrd;
 	struct device *dev = ctx->dev;
 	struct acpi_cedt_cfmws *cfmws;
 	struct cxl_decoder *cxld;
@@ -128,11 +128,11 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
 	if (rc)
 		goto err_insert;
 
-	cxlsd = cxl_root_decoder_alloc(root_port, ways);
-	if (IS_ERR(cxld))
+	cxlrd = cxl_root_decoder_alloc(root_port, ways);
+	if (IS_ERR(cxlrd))
 		return 0;
 
-	cxld = &cxlsd->cxld;
+	cxld = &cxlrd->cxlsd.cxld;
 	cxld->flags = cfmws_to_decoder_flags(cfmws->restrictions);
 	cxld->target_type = CXL_DECODER_EXPANDER;
 	cxld->hpa_range = (struct range) {
@@ -409,6 +409,32 @@ static int add_cxl_resources(struct resource *cxl_res)
 	return 0;
 }
 
+static int pair_cxl_resource(struct device *dev, void *data)
+{
+	struct resource *cxl_res = data;
+	struct resource *p;
+
+	if (!is_root_decoder(dev))
+		return 0;
+
+	for (p = cxl_res->child; p; p = p->sibling) {
+		struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
+		struct cxl_decoder *cxld = &cxlrd->cxlsd.cxld;
+		struct resource res = {
+			.start = cxld->hpa_range.start,
+			.end = cxld->hpa_range.end,
+			.flags = IORESOURCE_MEM,
+		};
+
+		if (resource_contains(p, &res)) {
+			cxlrd->res = cxl_get_public_resource(p);
+			break;
+		}
+	}
+
+	return 0;
+}
+
 static int cxl_acpi_probe(struct platform_device *pdev)
 {
 	int rc;
@@ -459,6 +485,12 @@ static int cxl_acpi_probe(struct platform_device *pdev)
 	if (rc)
 		return rc;
 
+	/*
+	 * Populate the root decoders with their related iomem resource,
+	 * if present
+	 */
+	device_for_each_child(&root_port->dev, cxl_res, pair_cxl_resource);
+
 	/*
 	 * Root level scanned with host-bridge as dports, now scan host-bridges
 	 * for their role as CXL uports to their CXL-capable PCIe Root Ports.
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 27a2a6b839aa..4953a1c7b245 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -260,6 +260,23 @@ static void cxl_switch_decoder_release(struct device *dev)
 	kfree(cxlsd);
 }
 
+struct cxl_root_decoder *to_cxl_root_decoder(struct device *dev)
+{
+	if (dev_WARN_ONCE(dev, !is_root_decoder(dev),
+			  "not a cxl_root_decoder device\n"))
+		return NULL;
+	return container_of(dev, struct cxl_root_decoder, cxlsd.cxld.dev);
+}
+EXPORT_SYMBOL_NS_GPL(to_cxl_root_decoder, CXL);
+
+static void cxl_root_decoder_release(struct device *dev)
+{
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev);
+
+	__cxl_decoder_release(&cxlrd->cxlsd.cxld);
+	kfree(cxlrd);
+}
+
 static const struct device_type cxl_decoder_endpoint_type = {
 	.name = "cxl_decoder_endpoint",
 	.release = cxl_decoder_release,
@@ -274,7 +291,7 @@ static const struct device_type cxl_decoder_switch_type = {
 
 static const struct device_type cxl_decoder_root_type = {
 	.name = "cxl_decoder_root",
-	.release = cxl_switch_decoder_release,
+	.release = cxl_root_decoder_release,
 	.groups = cxl_decoder_root_attribute_groups,
 };
 
@@ -1271,9 +1288,10 @@ static int cxl_switch_decoder_init(struct cxl_port *port,
  * firmware description of CXL resources into a CXL standard decode
  * topology.
  */
-struct cxl_switch_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
-						  unsigned int nr_targets)
+struct cxl_root_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
+						unsigned int nr_targets)
 {
+	struct cxl_root_decoder *cxlrd;
 	struct cxl_switch_decoder *cxlsd;
 	struct cxl_decoder *cxld;
 	int rc;
@@ -1281,19 +1299,21 @@ struct cxl_switch_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
 	if (!is_cxl_root(port))
 		return ERR_PTR(-EINVAL);
 
-	cxlsd = kzalloc(struct_size(cxlsd, target, nr_targets), GFP_KERNEL);
-	if (!cxlsd)
+	cxlrd = kzalloc(struct_size(cxlrd, cxlsd.target, nr_targets),
+			GFP_KERNEL);
+	if (!cxlrd)
 		return ERR_PTR(-ENOMEM);
 
+	cxlsd = &cxlrd->cxlsd;
 	rc = cxl_switch_decoder_init(port, cxlsd, nr_targets);
 	if (rc) {
-		kfree(cxlsd);
+		kfree(cxlrd);
 		return ERR_PTR(rc);
 	}
 
 	cxld = &cxlsd->cxld;
 	cxld->dev.type = &cxl_decoder_root_type;
-	return cxlsd;
+	return cxlrd;
 }
 EXPORT_SYMBOL_NS_GPL(cxl_root_decoder_alloc, CXL);
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 0289c06ec72c..ebdac8e7d181 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -260,6 +260,16 @@ struct cxl_switch_decoder {
 };
 
 
+/**
+ * struct cxl_root_decoder - Static platform CXL address decoder
+ * @res: host / parent resource for region allocations
+ * @cxlsd: base cxl switch decoder
+ */
+struct cxl_root_decoder {
+	struct resource *res;
+	struct cxl_switch_decoder cxlsd;
+};
+
 /**
  * enum cxl_nvdimm_brige_state - state machine for managing bus rescans
  * @CXL_NVB_NEW: Set at bridge create and after cxl_pmem_wq is destroyed
@@ -376,10 +386,11 @@ struct cxl_dport *cxl_find_dport_by_dev(struct cxl_port *port,
 					const struct device *dev);
 
 struct cxl_decoder *to_cxl_decoder(struct device *dev);
+struct cxl_root_decoder *to_cxl_root_decoder(struct device *dev);
 bool is_root_decoder(struct device *dev);
 bool is_endpoint_decoder(struct device *dev);
-struct cxl_switch_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
-						  unsigned int nr_targets);
+struct cxl_root_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
+						unsigned int nr_targets);
 struct cxl_switch_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
 						    unsigned int nr_targets);
 int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map);

