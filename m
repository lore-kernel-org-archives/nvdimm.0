Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2BD2F24
	for <nvdimm@lists.linux.dev>; Thu,  3 Feb 2022 04:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643860927; x=1675396927;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DuOHKHshGKKrTuFr3+TUPuFe/umk+40ivph/qTKR9rg=;
  b=YLYvj9LIK/OFmyrTXvh12Lt4Q9F3pNAeyt3I5s2NDNd9+VDoUk7j6Uc1
   OxXiLDD4Db4+Ryy87dZWweeG2R7rT0fUEmYJAvERNhppoSa3hlGj5dfcL
   Qiw7vYARgDLBtPyTpe+yLOd+AqVYr0olqylxr1F6IOsIA0AS9lSigTONi
   1PWPR9CecxSdfiTTxlXkO4UvJh0IyUxBV6by3F1g5QgICEeXO/M1bSC2r
   P/vGxmfLomGSst6lipaFnznG1B6nC+Giqz/KwQju/uXxIoPa5XflRvo3b
   EJCQLzGTGqG1ihLC/lgIYzlHWel1jfueu12Zfkyn3dL0xsypwosCLY7mF
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="248023666"
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="248023666"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 20:02:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="771666614"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 20:02:06 -0800
Subject: [PATCH v4 35/40] cxl/core/port: Add endpoint decoders
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, linux-pci@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Wed, 02 Feb 2022 20:02:06 -0800
Message-ID: <164386092069.765089.14895687988217608642.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298430609.3018233.3860765171749496117.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298430609.3018233.3860765171749496117.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Ben Widawsky <ben.widawsky@intel.com>

Recall that a CXL Port is any object that publishes a CXL HDM Decoder
Capability structure. That is Host Bridge and Switches that have been
enabled so far. Now, add decoder support to the 'endpoint' CXL Ports
registered by the cxl_mem driver. They mostly share the same enumeration
as Bridges and Switches, but witout a target list. The target of
endpoint decode is device-internal DPA space, not another downstream
port.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[djbw: clarify changelog, hookup enumeration in the port driver]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v3:
- Resolve conflicts from changes to preceding patches in the series.

 drivers/cxl/core/hdm.c  |    8 +++++-
 drivers/cxl/core/port.c |   63 ++++++++++++++++++++++++++++++++++++++++++-----
 drivers/cxl/cxl.h       |    1 +
 drivers/cxl/port.c      |   17 +++++++------
 4 files changed, 73 insertions(+), 16 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 80280db316c0..05b0b292e72d 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -186,6 +186,9 @@ static void init_hdm_decoder(struct cxl_decoder *cxld, int *target_map,
 	else
 		cxld->target_type = CXL_DECODER_ACCELERATOR;
 
+	if (is_cxl_endpoint(to_cxl_port(cxld->dev.parent)))
+		return;
+
 	target_list.value =
 		ioread64_hi_lo(hdm + CXL_HDM_DECODER0_TL_LOW(which));
 	for (i = 0; i < cxld->interleave_ways; i++)
@@ -225,7 +228,10 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
 		int rc, target_count = cxlhdm->target_count;
 		struct cxl_decoder *cxld;
 
-		cxld = cxl_switch_decoder_alloc(port, target_count);
+		if (is_cxl_endpoint(port))
+			cxld = cxl_endpoint_decoder_alloc(port);
+		else
+			cxld = cxl_switch_decoder_alloc(port, target_count);
 		if (IS_ERR(cxld)) {
 			dev_warn(&port->dev,
 				 "Failed to allocate the decoder\n");
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 359d4303de9a..bc18d339738b 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -228,6 +228,22 @@ static const struct attribute_group *cxl_decoder_switch_attribute_groups[] = {
 	NULL,
 };
 
+static struct attribute *cxl_decoder_endpoint_attrs[] = {
+	&dev_attr_target_type.attr,
+	NULL,
+};
+
+static struct attribute_group cxl_decoder_endpoint_attribute_group = {
+	.attrs = cxl_decoder_endpoint_attrs,
+};
+
+static const struct attribute_group *cxl_decoder_endpoint_attribute_groups[] = {
+	&cxl_decoder_base_attribute_group,
+	&cxl_decoder_endpoint_attribute_group,
+	&cxl_base_attribute_group,
+	NULL,
+};
+
 static void cxl_decoder_release(struct device *dev)
 {
 	struct cxl_decoder *cxld = to_cxl_decoder(dev);
@@ -237,6 +253,12 @@ static void cxl_decoder_release(struct device *dev)
 	kfree(cxld);
 }
 
+static const struct device_type cxl_decoder_endpoint_type = {
+	.name = "cxl_decoder_endpoint",
+	.release = cxl_decoder_release,
+	.groups = cxl_decoder_endpoint_attribute_groups,
+};
+
 static const struct device_type cxl_decoder_switch_type = {
 	.name = "cxl_decoder_switch",
 	.release = cxl_decoder_release,
@@ -249,6 +271,11 @@ static const struct device_type cxl_decoder_root_type = {
 	.groups = cxl_decoder_root_attribute_groups,
 };
 
+static bool is_endpoint_decoder(struct device *dev)
+{
+	return dev->type == &cxl_decoder_endpoint_type;
+}
+
 bool is_root_decoder(struct device *dev)
 {
 	return dev->type == &cxl_decoder_root_type;
@@ -1129,7 +1156,9 @@ static int decoder_populate_targets(struct cxl_decoder *cxld,
  * cxl_decoder_alloc - Allocate a new CXL decoder
  * @port: owning port of this decoder
  * @nr_targets: downstream targets accessible by this decoder. All upstream
- *		ports and root ports must have at least 1 target.
+ *		ports and root ports must have at least 1 target. Endpoint
+ *		devices will have 0 targets. Callers wishing to register an
+ *		endpoint device should specify 0.
  *
  * A port should contain one or more decoders. Each of those decoders enable
  * some address space for CXL.mem utilization. A decoder is expected to be
@@ -1145,7 +1174,7 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
 	struct device *dev;
 	int rc = 0;
 
-	if (nr_targets > CXL_DECODER_MAX_INTERLEAVE || nr_targets == 0)
+	if (nr_targets > CXL_DECODER_MAX_INTERLEAVE)
 		return ERR_PTR(-EINVAL);
 
 	cxld = kzalloc(struct_size(cxld, target, nr_targets), GFP_KERNEL);
@@ -1166,6 +1195,8 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
 	dev->bus = &cxl_bus_type;
 	if (is_cxl_root(port))
 		cxld->dev.type = &cxl_decoder_root_type;
+	else if (is_cxl_endpoint(port))
+		cxld->dev.type = &cxl_decoder_endpoint_type;
 	else
 		cxld->dev.type = &cxl_decoder_switch_type;
 
@@ -1215,13 +1246,28 @@ EXPORT_SYMBOL_NS_GPL(cxl_root_decoder_alloc, CXL);
 struct cxl_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
 					     unsigned int nr_targets)
 {
-	if (is_cxl_root(port))
+	if (is_cxl_root(port) || is_cxl_endpoint(port))
 		return ERR_PTR(-EINVAL);
 
 	return cxl_decoder_alloc(port, nr_targets);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_switch_decoder_alloc, CXL);
 
+/**
+ * cxl_endpoint_decoder_alloc - Allocate an endpoint decoder
+ * @port: owning port of this decoder
+ *
+ * Return: A new cxl decoder to be registered by cxl_decoder_add()
+ */
+struct cxl_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port)
+{
+	if (!is_cxl_endpoint(port))
+		return ERR_PTR(-EINVAL);
+
+	return cxl_decoder_alloc(port, 0);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_endpoint_decoder_alloc, CXL);
+
 /**
  * cxl_decoder_add_locked - Add a decoder with targets
  * @cxld: The cxl decoder allocated by cxl_decoder_alloc()
@@ -1256,12 +1302,15 @@ int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map)
 	if (cxld->interleave_ways < 1)
 		return -EINVAL;
 
+	dev = &cxld->dev;
+
 	port = to_cxl_port(cxld->dev.parent);
-	rc = decoder_populate_targets(cxld, port, target_map);
-	if (rc)
-		return rc;
+	if (!is_endpoint_decoder(dev)) {
+		rc = decoder_populate_targets(cxld, port, target_map);
+		if (rc)
+			return rc;
+	}
 
-	dev = &cxld->dev;
 	rc = dev_set_name(dev, "decoder%d.%d", port->id, cxld->id);
 	if (rc)
 		return rc;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index f5e5b4ac8228..990b6670222e 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -346,6 +346,7 @@ struct cxl_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
 struct cxl_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
 					     unsigned int nr_targets);
 int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map);
+struct cxl_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port);
 int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map);
 int cxl_decoder_autoremove(struct device *host, struct cxl_decoder *cxld);
 int cxl_endpoint_autoremove(struct cxl_memdev *cxlmd, struct cxl_port *endpoint);
diff --git a/drivers/cxl/port.c b/drivers/cxl/port.c
index 4d4e23b9adff..d420da5fc39c 100644
--- a/drivers/cxl/port.c
+++ b/drivers/cxl/port.c
@@ -40,16 +40,17 @@ static int cxl_port_probe(struct device *dev)
 		struct cxl_memdev *cxlmd = to_cxl_memdev(port->uport);
 
 		get_device(&cxlmd->dev);
-		return devm_add_action_or_reset(dev, schedule_detach, cxlmd);
+		rc = devm_add_action_or_reset(dev, schedule_detach, cxlmd);
+		if (rc)
+			return rc;
+	} else {
+		rc = devm_cxl_port_enumerate_dports(port);
+		if (rc < 0)
+			return rc;
+		if (rc == 1)
+			return devm_cxl_add_passthrough_decoder(port);
 	}
 
-	rc = devm_cxl_port_enumerate_dports(port);
-	if (rc < 0)
-		return rc;
-
-	if (rc == 1)
-		return devm_cxl_add_passthrough_decoder(port);
-
 	cxlhdm = devm_cxl_setup_hdm(port);
 	if (IS_ERR(cxlhdm))
 		return PTR_ERR(cxlhdm);

