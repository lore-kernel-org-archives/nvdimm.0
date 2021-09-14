Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E020F29CA
	for <nvdimm@lists.linux.dev>; Tue, 14 Sep 2021 19:31:23 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10107"; a="218929562"
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="218929562"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 12:31:23 -0700
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="699629586"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 12:31:22 -0700
Subject: [PATCH v5 21/21] cxl/core: Split decoder setup into alloc + add
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>,
 Dan Carpenter <dan.carpenter@oracle.com>, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com
Date: Tue, 14 Sep 2021 12:31:22 -0700
Message-ID: <163164780319.2831662.7853294454760344393.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163116440612.2460985.14600637290781306289.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163116440612.2460985.14600637290781306289.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The kbuild robot reports:

    drivers/cxl/core/bus.c:516:1: warning: stack frame size (1032) exceeds
    limit (1024) in function 'devm_cxl_add_decoder'

It is also the case the devm_cxl_add_decoder() is unwieldy to use for
all the different decoder types. Fix the stack usage by splitting the
creation into alloc and add steps. This also allows for context
specific construction before adding.

With the split the caller is responsible for registering a devm callback
to trigger device_unregister() for the decoder rather than it being
implicit in the decoder registration. I.e. the routine that calls alloc
is responsible for calling put_device() if the "add" operation fails.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v4:
- hold the device lock over the list_empty(&port->dports) check
  (Jonathan)
- move the list_empty() check after the check for NULL @target_map in
  anticipation of endpoint decoders (Ben)

 drivers/cxl/acpi.c      |   84 +++++++++++++++++++++++---------
 drivers/cxl/core/bus.c  |  123 +++++++++++++++--------------------------------
 drivers/cxl/core/core.h |    5 --
 drivers/cxl/core/pmem.c |    7 ++-
 drivers/cxl/cxl.h       |   15 ++----
 5 files changed, 110 insertions(+), 124 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index d39cc797a64e..2368a8b67698 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -82,7 +82,6 @@ static void cxl_add_cfmws_decoders(struct device *dev,
 	struct cxl_decoder *cxld;
 	acpi_size len, cur = 0;
 	void *cedt_subtable;
-	unsigned long flags;
 	int rc;
 
 	len = acpi_cedt->length - sizeof(*acpi_cedt);
@@ -119,24 +118,36 @@ static void cxl_add_cfmws_decoders(struct device *dev,
 		for (i = 0; i < CFMWS_INTERLEAVE_WAYS(cfmws); i++)
 			target_map[i] = cfmws->interleave_targets[i];
 
-		flags = cfmws_to_decoder_flags(cfmws->restrictions);
-		cxld = devm_cxl_add_decoder(dev, root_port,
-					    CFMWS_INTERLEAVE_WAYS(cfmws),
-					    cfmws->base_hpa, cfmws->window_size,
-					    CFMWS_INTERLEAVE_WAYS(cfmws),
-					    CFMWS_INTERLEAVE_GRANULARITY(cfmws),
-					    CXL_DECODER_EXPANDER,
-					    flags, target_map);
-
-		if (IS_ERR(cxld)) {
+		cxld = cxl_decoder_alloc(root_port,
+					 CFMWS_INTERLEAVE_WAYS(cfmws));
+		if (IS_ERR(cxld))
+			goto next;
+
+		cxld->flags = cfmws_to_decoder_flags(cfmws->restrictions);
+		cxld->target_type = CXL_DECODER_EXPANDER;
+		cxld->range = (struct range) {
+			.start = cfmws->base_hpa,
+			.end = cfmws->base_hpa + cfmws->window_size - 1,
+		};
+		cxld->interleave_ways = CFMWS_INTERLEAVE_WAYS(cfmws);
+		cxld->interleave_granularity =
+			CFMWS_INTERLEAVE_GRANULARITY(cfmws);
+
+		rc = cxl_decoder_add(cxld, target_map);
+		if (rc)
+			put_device(&cxld->dev);
+		else
+			rc = cxl_decoder_autoremove(dev, cxld);
+		if (rc) {
 			dev_err(dev, "Failed to add decoder for %#llx-%#llx\n",
 				cfmws->base_hpa, cfmws->base_hpa +
 				cfmws->window_size - 1);
-		} else {
-			dev_dbg(dev, "add: %s range %#llx-%#llx\n",
-				dev_name(&cxld->dev), cfmws->base_hpa,
-				 cfmws->base_hpa + cfmws->window_size - 1);
+			goto next;
 		}
+		dev_dbg(dev, "add: %s range %#llx-%#llx\n",
+			dev_name(&cxld->dev), cfmws->base_hpa,
+			cfmws->base_hpa + cfmws->window_size - 1);
+next:
 		cur += c->length;
 	}
 }
@@ -266,6 +277,7 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 	struct acpi_device *bridge = to_cxl_host_bridge(host, match);
 	struct acpi_pci_root *pci_root;
 	struct cxl_walk_context ctx;
+	int single_port_map[1], rc;
 	struct cxl_decoder *cxld;
 	struct cxl_dport *dport;
 	struct cxl_port *port;
@@ -301,22 +313,46 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 		return -ENODEV;
 	if (ctx.error)
 		return ctx.error;
+	if (ctx.count > 1)
+		return 0;
 
 	/* TODO: Scan CHBCR for HDM Decoder resources */
 
 	/*
-	 * In the single-port host-bridge case there are no HDM decoders
-	 * in the CHBCR and a 1:1 passthrough decode is implied.
+	 * Per the CXL specification (8.2.5.12 CXL HDM Decoder Capability
+	 * Structure) single ported host-bridges need not publish a decoder
+	 * capability when a passthrough decode can be assumed, i.e. all
+	 * transactions that the uport sees are claimed and passed to the single
+	 * dport. Default the range a 0-base 0-length until the first CXL region
+	 * is activated.
 	 */
-	if (ctx.count == 1) {
-		cxld = devm_cxl_add_passthrough_decoder(host, port);
-		if (IS_ERR(cxld))
-			return PTR_ERR(cxld);
+	cxld = cxl_decoder_alloc(port, 1);
+	if (IS_ERR(cxld))
+		return PTR_ERR(cxld);
+
+	cxld->interleave_ways = 1;
+	cxld->interleave_granularity = PAGE_SIZE;
+	cxld->target_type = CXL_DECODER_EXPANDER;
+	cxld->range = (struct range) {
+		.start = 0,
+		.end = -1,
+	};
 
-		dev_dbg(host, "add: %s\n", dev_name(&cxld->dev));
-	}
+	device_lock(&port->dev);
+	dport = list_first_entry(&port->dports, typeof(*dport), list);
+	device_unlock(&port->dev);
 
-	return 0;
+	single_port_map[0] = dport->port_id;
+
+	rc = cxl_decoder_add(cxld, single_port_map);
+	if (rc)
+		put_device(&cxld->dev);
+	else
+		rc = cxl_decoder_autoremove(host, cxld);
+
+	if (rc == 0)
+		dev_dbg(host, "add: %s\n", dev_name(&cxld->dev));
+	return rc;
 }
 
 static int add_host_bridge_dport(struct device *match, void *arg)
diff --git a/drivers/cxl/core/bus.c b/drivers/cxl/core/bus.c
index 6dfdeaf999f0..396252749477 100644
--- a/drivers/cxl/core/bus.c
+++ b/drivers/cxl/core/bus.c
@@ -453,10 +453,8 @@ int cxl_add_dport(struct cxl_port *port, struct device *dport_dev, int port_id,
 }
 EXPORT_SYMBOL_GPL(cxl_add_dport);
 
-static int decoder_populate_targets(struct device *host,
-				    struct cxl_decoder *cxld,
-				    struct cxl_port *port, int *target_map,
-				    int nr_targets)
+static int decoder_populate_targets(struct cxl_decoder *cxld,
+				    struct cxl_port *port, int *target_map)
 {
 	int rc = 0, i;
 
@@ -464,42 +462,36 @@ static int decoder_populate_targets(struct device *host,
 		return 0;
 
 	device_lock(&port->dev);
-	for (i = 0; i < nr_targets; i++) {
+	if (list_empty(&port->dports)) {
+		rc = -EINVAL;
+		goto out_unlock;
+	}
+
+	for (i = 0; i < cxld->nr_targets; i++) {
 		struct cxl_dport *dport = find_dport(port, target_map[i]);
 
 		if (!dport) {
 			rc = -ENXIO;
-			break;
+			goto out_unlock;
 		}
-		dev_dbg(host, "%s: target: %d\n", dev_name(dport->dport), i);
 		cxld->target[i] = dport;
 	}
+
+out_unlock:
 	device_unlock(&port->dev);
 
 	return rc;
 }
 
-static struct cxl_decoder *
-cxl_decoder_alloc(struct device *host, struct cxl_port *port, int nr_targets,
-		  resource_size_t base, resource_size_t len,
-		  int interleave_ways, int interleave_granularity,
-		  enum cxl_decoder_type type, unsigned long flags,
-		  int *target_map)
+struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets)
 {
 	struct cxl_decoder *cxld;
 	struct device *dev;
 	int rc = 0;
 
-	if (interleave_ways < 1)
+	if (nr_targets > CXL_DECODER_MAX_INTERLEAVE || nr_targets < 1)
 		return ERR_PTR(-EINVAL);
 
-	device_lock(&port->dev);
-	if (list_empty(&port->dports))
-		rc = -EINVAL;
-	device_unlock(&port->dev);
-	if (rc)
-		return ERR_PTR(rc);
-
 	cxld = kzalloc(struct_size(cxld, target, nr_targets), GFP_KERNEL);
 	if (!cxld)
 		return ERR_PTR(-ENOMEM);
@@ -508,22 +500,8 @@ cxl_decoder_alloc(struct device *host, struct cxl_port *port, int nr_targets,
 	if (rc < 0)
 		goto err;
 
-	*cxld = (struct cxl_decoder) {
-		.id = rc,
-		.range = {
-			.start = base,
-			.end = base + len - 1,
-		},
-		.flags = flags,
-		.interleave_ways = interleave_ways,
-		.interleave_granularity = interleave_granularity,
-		.target_type = type,
-	};
-
-	rc = decoder_populate_targets(host, cxld, port, target_map, nr_targets);
-	if (rc)
-		goto err;
-
+	cxld->id = rc;
+	cxld->nr_targets = nr_targets;
 	dev = &cxld->dev;
 	device_initialize(dev);
 	device_set_pm_not_required(dev);
@@ -541,72 +519,47 @@ cxl_decoder_alloc(struct device *host, struct cxl_port *port, int nr_targets,
 	kfree(cxld);
 	return ERR_PTR(rc);
 }
+EXPORT_SYMBOL_GPL(cxl_decoder_alloc);
 
-struct cxl_decoder *
-devm_cxl_add_decoder(struct device *host, struct cxl_port *port, int nr_targets,
-		     resource_size_t base, resource_size_t len,
-		     int interleave_ways, int interleave_granularity,
-		     enum cxl_decoder_type type, unsigned long flags,
-		     int *target_map)
+int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map)
 {
-	struct cxl_decoder *cxld;
+	struct cxl_port *port;
 	struct device *dev;
 	int rc;
 
-	if (nr_targets > CXL_DECODER_MAX_INTERLEAVE)
-		return ERR_PTR(-EINVAL);
+	if (!cxld)
+		return -EINVAL;
 
-	cxld = cxl_decoder_alloc(host, port, nr_targets, base, len,
-				 interleave_ways, interleave_granularity, type,
-				 flags, target_map);
 	if (IS_ERR(cxld))
-		return cxld;
+		return PTR_ERR(cxld);
 
-	dev = &cxld->dev;
-	rc = dev_set_name(dev, "decoder%d.%d", port->id, cxld->id);
-	if (rc)
-		goto err;
+	if (cxld->interleave_ways < 1)
+		return -EINVAL;
 
-	rc = device_add(dev);
+	port = to_cxl_port(cxld->dev.parent);
+	rc = decoder_populate_targets(cxld, port, target_map);
 	if (rc)
-		goto err;
+		return rc;
 
-	rc = devm_add_action_or_reset(host, unregister_cxl_dev, dev);
+	dev = &cxld->dev;
+	rc = dev_set_name(dev, "decoder%d.%d", port->id, cxld->id);
 	if (rc)
-		return ERR_PTR(rc);
-	return cxld;
+		return rc;
 
-err:
-	put_device(dev);
-	return ERR_PTR(rc);
+	return device_add(dev);
 }
-EXPORT_SYMBOL_GPL(devm_cxl_add_decoder);
+EXPORT_SYMBOL_GPL(cxl_decoder_add);
 
-/*
- * Per the CXL specification (8.2.5.12 CXL HDM Decoder Capability Structure)
- * single ported host-bridges need not publish a decoder capability when a
- * passthrough decode can be assumed, i.e. all transactions that the uport sees
- * are claimed and passed to the single dport. Default the range a 0-base
- * 0-length until the first CXL region is activated.
- */
-struct cxl_decoder *devm_cxl_add_passthrough_decoder(struct device *host,
-						     struct cxl_port *port)
+static void cxld_unregister(void *dev)
 {
-	struct cxl_dport *dport;
-	int target_map[1];
-
-	device_lock(&port->dev);
-	dport = list_first_entry_or_null(&port->dports, typeof(*dport), list);
-	device_unlock(&port->dev);
-
-	if (!dport)
-		return ERR_PTR(-ENXIO);
+	device_unregister(dev);
+}
 
-	target_map[0] = dport->port_id;
-	return devm_cxl_add_decoder(host, port, 1, 0, 0, 1, PAGE_SIZE,
-				    CXL_DECODER_EXPANDER, 0, target_map);
+int cxl_decoder_autoremove(struct device *host, struct cxl_decoder *cxld)
+{
+	return devm_add_action_or_reset(host, cxld_unregister, &cxld->dev);
 }
-EXPORT_SYMBOL_GPL(devm_cxl_add_passthrough_decoder);
+EXPORT_SYMBOL_GPL(cxl_decoder_autoremove);
 
 /**
  * __cxl_driver_register - register a driver for the cxl bus
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index c85b7fbad02d..e0c9aacc4e9c 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -9,11 +9,6 @@ extern const struct device_type cxl_nvdimm_type;
 
 extern struct attribute_group cxl_base_attribute_group;
 
-static inline void unregister_cxl_dev(void *dev)
-{
-	device_unregister(dev);
-}
-
 struct cxl_send_command;
 struct cxl_mem_query_commands;
 int cxl_query_cmd(struct cxl_memdev *cxlmd,
diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index 74be5132df1c..5032f4c1c69d 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -222,6 +222,11 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
 	return cxl_nvd;
 }
 
+static void cxl_nvd_unregister(void *dev)
+{
+	device_unregister(dev);
+}
+
 /**
  * devm_cxl_add_nvdimm() - add a bridge between a cxl_memdev and an nvdimm
  * @host: same host as @cxlmd
@@ -251,7 +256,7 @@ int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd)
 	dev_dbg(host, "%s: register %s\n", dev_name(dev->parent),
 		dev_name(dev));
 
-	return devm_add_action_or_reset(host, unregister_cxl_dev, dev);
+	return devm_add_action_or_reset(host, cxl_nvd_unregister, dev);
 
 err:
 	put_device(dev);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 9af5745ba2c0..7d6b011dd963 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -195,6 +195,7 @@ enum cxl_decoder_type {
  * @interleave_granularity: data stride per dport
  * @target_type: accelerator vs expander (type2 vs type3) selector
  * @flags: memory type capabilities and locking
+ * @nr_targets: number of elements in @target
  * @target: active ordered target list in current decoder configuration
  */
 struct cxl_decoder {
@@ -205,6 +206,7 @@ struct cxl_decoder {
 	int interleave_granularity;
 	enum cxl_decoder_type target_type;
 	unsigned long flags;
+	int nr_targets;
 	struct cxl_dport *target[];
 };
 
@@ -286,15 +288,10 @@ int cxl_add_dport(struct cxl_port *port, struct device *dport, int port_id,
 
 struct cxl_decoder *to_cxl_decoder(struct device *dev);
 bool is_root_decoder(struct device *dev);
-struct cxl_decoder *
-devm_cxl_add_decoder(struct device *host, struct cxl_port *port, int nr_targets,
-		     resource_size_t base, resource_size_t len,
-		     int interleave_ways, int interleave_granularity,
-		     enum cxl_decoder_type type, unsigned long flags,
-		     int *target_map);
-
-struct cxl_decoder *devm_cxl_add_passthrough_decoder(struct device *host,
-						     struct cxl_port *port);
+struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets);
+int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map);
+int cxl_decoder_autoremove(struct device *host, struct cxl_decoder *cxld);
+
 extern struct bus_type cxl_bus_type;
 
 struct cxl_driver {

