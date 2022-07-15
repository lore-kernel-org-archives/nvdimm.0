Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B874C7460
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 00:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657843347; x=1689379347;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MzYsXLz52hUwHRWQxC1ck79lMKivl+7wU+DUNvWzc6A=;
  b=chgclW/nrMKI4m+U6qB1S8zgntABatuCO7wwHgWla9Y1eDnpO0hS5jdr
   Ki8UaNZjAkczPAzCDROdmnXOyADHa/seuTTrUlWh9ibgYi7rZyEA0uRNG
   npFiaPzlTyFyFjBjmHD6h59as9BGSKw0Aeujo6A/qKT+1fbai8QVxyY3O
   MifYRsfGlWPnwZSsK2mEBFVA5vhvGGQewpAGdCBkFkbsKS/MLNTUN7T57
   sp7fpzQTNwaeGpnO5qEqcRjWU+3L4oUrRER82OBbDXnY29EKNq9bGF/D6
   l9JAR8hmW88o9qCxtHJjk48hgjccxsjKj27U1XCA7yfzZqUVhEGAuZOfX
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="349626824"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="349626824"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:02:08 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="596276237"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:02:08 -0700
Subject: [PATCH v2 15/28] cxl/mem: Enumerate port targets before adding
 endpoints
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, hch@lst.de,
 nvdimm@lists.linux.dev, linux-pci@vger.kernel.org
Date: Thu, 14 Jul 2022 17:02:07 -0700
Message-ID: <165784332785.1758207.6457933746912970734.stgit@dwillia2-xfh.jf.intel.com>
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

The port scanning algorithm in devm_cxl_enumerate_ports() walks up the
topology and adds cxl_port objects starting from the root down to the
endpoint. When those ports are initially created they know all their
dports, but they do not know the downstream cxl_port instance that
represents the next descendant in the topology. Rework create_endpoint()
into devm_cxl_add_endpoint() that enumerates the downstream cxl_port
topology into each port's 'struct cxl_ep' record for each endpoint it
that the port is an ancestor.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20220624041950.559155-7-dan.j.williams@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/port.c |   41 +++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h       |    5 +++++
 drivers/cxl/mem.c       |   30 +-----------------------------
 3 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index a43735f349d6..4907db798ad9 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1087,6 +1087,47 @@ static struct cxl_ep *cxl_ep_load(struct cxl_port *port,
 	return xa_load(&port->endpoints, (unsigned long)&cxlmd->dev);
 }
 
+int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
+			  struct cxl_dport *parent_dport)
+{
+	struct cxl_port *parent_port = parent_dport->port;
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	struct cxl_port *endpoint, *iter, *down;
+	int rc;
+
+	/*
+	 * Now that the path to the root is established record all the
+	 * intervening ports in the chain.
+	 */
+	for (iter = parent_port, down = NULL; !is_cxl_root(iter);
+	     down = iter, iter = to_cxl_port(iter->dev.parent)) {
+		struct cxl_ep *ep;
+
+		ep = cxl_ep_load(iter, cxlmd);
+		ep->next = down;
+	}
+
+	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
+				     cxlds->component_reg_phys, parent_dport);
+	if (IS_ERR(endpoint))
+		return PTR_ERR(endpoint);
+
+	dev_dbg(&cxlmd->dev, "add: %s\n", dev_name(&endpoint->dev));
+
+	rc = cxl_endpoint_autoremove(cxlmd, endpoint);
+	if (rc)
+		return rc;
+
+	if (!endpoint->dev.driver) {
+		dev_err(&cxlmd->dev, "%s failed probe\n",
+			dev_name(&endpoint->dev));
+		return -ENXIO;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(devm_cxl_add_endpoint, CXL);
+
 static void cxl_detach_ep(void *data)
 {
 	struct cxl_memdev *cxlmd = data;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index bf5f0c305115..a108d5c288ca 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -378,10 +378,13 @@ struct cxl_dport {
  * struct cxl_ep - track an endpoint's interest in a port
  * @ep: device that hosts a generic CXL endpoint (expander or accelerator)
  * @dport: which dport routes to this endpoint on @port
+ * @next: cxl switch port across the link attached to @dport NULL if
+ *	  attached to an endpoint
  */
 struct cxl_ep {
 	struct device *ep;
 	struct cxl_dport *dport;
+	struct cxl_port *next;
 };
 
 /*
@@ -404,6 +407,8 @@ struct pci_bus *cxl_port_to_pci_bus(struct cxl_port *port);
 struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 				   resource_size_t component_reg_phys,
 				   struct cxl_dport *parent_dport);
+int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
+			  struct cxl_dport *parent_dport);
 struct cxl_port *find_cxl_root(struct device *dev);
 int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
 int cxl_bus_rescan(void);
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 2786d3402c9e..64ccf053d32c 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -25,34 +25,6 @@
  * in higher level operations.
  */
 
-static int create_endpoint(struct cxl_memdev *cxlmd,
-			   struct cxl_dport *parent_dport)
-{
-	struct cxl_port *parent_port = parent_dport->port;
-	struct cxl_dev_state *cxlds = cxlmd->cxlds;
-	struct cxl_port *endpoint;
-	int rc;
-
-	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
-				     cxlds->component_reg_phys, parent_dport);
-	if (IS_ERR(endpoint))
-		return PTR_ERR(endpoint);
-
-	dev_dbg(&cxlmd->dev, "add: %s\n", dev_name(&endpoint->dev));
-
-	rc = cxl_endpoint_autoremove(cxlmd, endpoint);
-	if (rc)
-		return rc;
-
-	if (!endpoint->dev.driver) {
-		dev_err(&cxlmd->dev, "%s failed probe\n",
-			dev_name(&endpoint->dev));
-		return -ENXIO;
-	}
-
-	return 0;
-}
-
 static void enable_suspend(void *data)
 {
 	cxl_mem_active_dec();
@@ -116,7 +88,7 @@ static int cxl_mem_probe(struct device *dev)
 		goto unlock;
 	}
 
-	rc = create_endpoint(cxlmd, dport);
+	rc = devm_cxl_add_endpoint(cxlmd, dport);
 unlock:
 	device_unlock(&parent_port->dev);
 	put_device(&parent_port->dev);

