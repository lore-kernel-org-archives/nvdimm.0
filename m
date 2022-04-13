Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0752F43;
	Wed, 13 Apr 2022 18:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649875094; x=1681411094;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2cspjk3ehP2RxkSlZOKEdhvz3HCPZyVpB/cKlunYSRc=;
  b=XEhqxpjpyJfMgZUrWWIIyxD1CJS3YOq6rrulsB+dLsK+s+88ejZ+PLOT
   /uF0SfGnrUmakRkWcVop+n2zwu2/bC0nV0gSohrmbeKqYOqhuvUp3I3Ua
   FV0ItotXqKoqhwJZKmiqGWksZnF0C7bjNRSGOV6rw+1j/MqwLq2RvPtZB
   gm01rFNrmp/1N+/lzB2gPBZul3GhKiUFUly6KWBBIqqJBSP1jLe3j9liN
   UQz1N88U5+oO+DYlkmiprabphdsFT9qOdEFo2jI+U1Q1OPHXxR0ZPDIGa
   0L2ibrzsvyrYa1pmL9XJNRuresCHBFACYoRPsj5t6Xvu2p9Mmtapt0hh8
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="244631842"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="244631842"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:48 -0700
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="725013581"
Received: from sushobhi-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.131.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:48 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 04/15] cxl/core: Create distinct decoder structs
Date: Wed, 13 Apr 2022 11:37:09 -0700
Message-Id: <20220413183720.2444089-5-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413183720.2444089-1-ben.widawsky@intel.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CXL HDM decoders have distinct properties at each level in the
hierarchy. Root decoders manage host physical address space. Switch
decoders manage demultiplexing of data to downstream targets. Endpoint
decoders must be aware of physical media size constraints. To properly
support these unique needs, create these unique structures.

CXL HDM decoders do have similar architectural properties at all levels:
interleave properties, flags, types and consumption of host physical
address space. Those are retained and when possible, still utilized.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/core/hdm.c       |   3 +-
 drivers/cxl/core/port.c      | 102 ++++++++++++++++++++++++-----------
 drivers/cxl/cxl.h            |  69 +++++++++++++++++++++---
 tools/testing/cxl/test/cxl.c |   2 +-
 4 files changed, 137 insertions(+), 39 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 3055e246aab9..37c09c77e9a7 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -6,6 +6,7 @@
 
 #include "cxlmem.h"
 #include "core.h"
+#include "cxl.h"
 
 /**
  * DOC: cxl core hdm
@@ -242,7 +243,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
 		struct cxl_decoder *cxld;
 
 		if (is_cxl_endpoint(port))
-			cxld = cxl_endpoint_decoder_alloc(port);
+			cxld = &cxl_endpoint_decoder_alloc(port)->base;
 		else
 			cxld = cxl_switch_decoder_alloc(port, target_count);
 		if (IS_ERR(cxld)) {
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 86f451ecb7ed..8dd29c97e318 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -121,18 +121,19 @@ static DEVICE_ATTR_RO(target_type);
 
 static ssize_t emit_target_list(struct cxl_decoder *cxld, char *buf)
 {
+	struct cxl_decoder_targets *t = cxl_get_decoder_targets(cxld);
 	ssize_t offset = 0;
 	int i, rc = 0;
 
 	for (i = 0; i < cxld->interleave_ways; i++) {
-		struct cxl_dport *dport = cxld->target[i];
+		struct cxl_dport *dport = t->target[i];
 		struct cxl_dport *next = NULL;
 
 		if (!dport)
 			break;
 
 		if (i + 1 < cxld->interleave_ways)
-			next = cxld->target[i + 1];
+			next = t->target[i + 1];
 		rc = sysfs_emit_at(buf, offset, "%d%s", dport->port_id,
 				   next ? "," : "");
 		if (rc < 0)
@@ -147,14 +148,15 @@ static ssize_t target_list_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct cxl_decoder_targets *t = cxl_get_decoder_targets(cxld);
 	ssize_t offset;
 	unsigned int seq;
 	int rc;
 
 	do {
-		seq = read_seqbegin(&cxld->target_lock);
+		seq = read_seqbegin(&t->target_lock);
 		rc = emit_target_list(cxld, buf);
-	} while (read_seqretry(&cxld->target_lock, seq));
+	} while (read_seqretry(&t->target_lock, seq));
 
 	if (rc < 0)
 		return rc;
@@ -199,23 +201,6 @@ static const struct attribute_group *cxl_decoder_root_attribute_groups[] = {
 	NULL,
 };
 
-static struct attribute *cxl_decoder_switch_attrs[] = {
-	&dev_attr_target_type.attr,
-	&dev_attr_target_list.attr,
-	NULL,
-};
-
-static struct attribute_group cxl_decoder_switch_attribute_group = {
-	.attrs = cxl_decoder_switch_attrs,
-};
-
-static const struct attribute_group *cxl_decoder_switch_attribute_groups[] = {
-	&cxl_decoder_switch_attribute_group,
-	&cxl_decoder_base_attribute_group,
-	&cxl_base_attribute_group,
-	NULL,
-};
-
 static struct attribute *cxl_decoder_endpoint_attrs[] = {
 	&dev_attr_target_type.attr,
 	NULL,
@@ -232,6 +217,12 @@ static const struct attribute_group *cxl_decoder_endpoint_attribute_groups[] = {
 	NULL,
 };
 
+static const struct attribute_group *cxl_decoder_switch_attribute_groups[] = {
+	&cxl_decoder_base_attribute_group,
+	&cxl_base_attribute_group,
+	NULL,
+};
+
 static void cxl_decoder_release(struct device *dev)
 {
 	struct cxl_decoder *cxld = to_cxl_decoder(dev);
@@ -264,6 +255,7 @@ bool is_endpoint_decoder(struct device *dev)
 {
 	return dev->type == &cxl_decoder_endpoint_type;
 }
+EXPORT_SYMBOL_NS_GPL(is_endpoint_decoder, CXL);
 
 bool is_root_decoder(struct device *dev)
 {
@@ -1136,6 +1128,7 @@ EXPORT_SYMBOL_NS_GPL(cxl_find_dport_by_dev, CXL);
 static int decoder_populate_targets(struct cxl_decoder *cxld,
 				    struct cxl_port *port, int *target_map)
 {
+	struct cxl_decoder_targets *t = cxl_get_decoder_targets(cxld);
 	int i, rc = 0;
 
 	if (!target_map)
@@ -1146,21 +1139,72 @@ static int decoder_populate_targets(struct cxl_decoder *cxld,
 	if (list_empty(&port->dports))
 		return -EINVAL;
 
-	write_seqlock(&cxld->target_lock);
-	for (i = 0; i < cxld->nr_targets; i++) {
+	write_seqlock(&t->target_lock);
+	for (i = 0; i < t->nr_targets; i++) {
 		struct cxl_dport *dport = find_dport(port, target_map[i]);
 
 		if (!dport) {
 			rc = -ENXIO;
 			break;
 		}
-		cxld->target[i] = dport;
+		t->target[i] = dport;
 	}
-	write_sequnlock(&cxld->target_lock);
+	write_sequnlock(&t->target_lock);
 
 	return rc;
 }
 
+static struct cxl_decoder *__cxl_decoder_alloc(struct cxl_port *port,
+					       unsigned int nr_targets)
+{
+	struct cxl_decoder *cxld;
+
+	if (is_cxl_endpoint(port)) {
+		struct cxl_endpoint_decoder *cxled;
+
+		cxled = kzalloc(sizeof(*cxled), GFP_KERNEL);
+		if (!cxled)
+			return NULL;
+		cxld = &cxled->base;
+	} else if (is_cxl_root(port)) {
+		struct cxl_root_decoder *cxlrd;
+
+		cxlrd = kzalloc(sizeof(*cxlrd), GFP_KERNEL);
+		if (!cxlrd)
+			return NULL;
+
+		cxlrd->targets =
+			kzalloc(struct_size(cxlrd->targets, target, nr_targets),
+				GFP_KERNEL);
+		if (!cxlrd->targets) {
+			kfree(cxlrd);
+			return NULL;
+		}
+		cxlrd->targets->nr_targets = nr_targets;
+		seqlock_init(&cxlrd->targets->target_lock);
+		cxld = &cxlrd->base;
+	} else {
+		struct cxl_switch_decoder *cxlsd;
+
+		cxlsd = kzalloc(sizeof(*cxlsd), GFP_KERNEL);
+		if (!cxlsd)
+			return NULL;
+
+		cxlsd->targets =
+			kzalloc(struct_size(cxlsd->targets, target, nr_targets),
+				GFP_KERNEL);
+		if (!cxlsd->targets) {
+			kfree(cxlsd);
+			return NULL;
+		}
+		cxlsd->targets->nr_targets = nr_targets;
+		seqlock_init(&cxlsd->targets->target_lock);
+		cxld = &cxlsd->base;
+	}
+
+	return cxld;
+}
+
 /**
  * cxl_decoder_alloc - Allocate a new CXL decoder
  * @port: owning port of this decoder
@@ -1186,7 +1230,7 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
 	if (nr_targets > CXL_DECODER_MAX_INTERLEAVE)
 		return ERR_PTR(-EINVAL);
 
-	cxld = kzalloc(struct_size(cxld, target, nr_targets), GFP_KERNEL);
+	cxld = __cxl_decoder_alloc(port, nr_targets);
 	if (!cxld)
 		return ERR_PTR(-ENOMEM);
 
@@ -1198,8 +1242,6 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
 	get_device(&port->dev);
 	cxld->id = rc;
 
-	cxld->nr_targets = nr_targets;
-	seqlock_init(&cxld->target_lock);
 	dev = &cxld->dev;
 	device_initialize(dev);
 	device_set_pm_not_required(dev);
@@ -1274,12 +1316,12 @@ EXPORT_SYMBOL_NS_GPL(cxl_switch_decoder_alloc, CXL);
  *
  * Return: A new cxl decoder to be registered by cxl_decoder_add()
  */
-struct cxl_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port)
+struct cxl_endpoint_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port)
 {
 	if (!is_cxl_endpoint(port))
 		return ERR_PTR(-EINVAL);
 
-	return cxl_decoder_alloc(port, 0);
+	return to_cxl_endpoint_decoder(cxl_decoder_alloc(port, 0));
 }
 EXPORT_SYMBOL_NS_GPL(cxl_endpoint_decoder_alloc, CXL);
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 6517d5cdf5ee..85fd5e84f978 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -193,6 +193,18 @@ enum cxl_decoder_type {
  */
 #define CXL_DECODER_MAX_INTERLEAVE 16
 
+/**
+ * struct cxl_decoder_targets - Target information for root and switch decoders.
+ * @target_lock: coordinate coherent reads of the target list
+ * @nr_targets: number of elements in @target
+ * @target: active ordered target list in current decoder configuration
+ */
+struct cxl_decoder_targets {
+	seqlock_t target_lock;
+	int nr_targets;
+	struct cxl_dport *target[];
+};
+
 /**
  * struct cxl_decoder - CXL address range decode configuration
  * @dev: this decoder's device
@@ -202,9 +214,6 @@ enum cxl_decoder_type {
  * @interleave_granularity: data stride per dport
  * @target_type: accelerator vs expander (type2 vs type3) selector
  * @flags: memory type capabilities and locking
- * @target_lock: coordinate coherent reads of the target list
- * @nr_targets: number of elements in @target
- * @target: active ordered target list in current decoder configuration
  */
 struct cxl_decoder {
 	struct device dev;
@@ -214,11 +223,46 @@ struct cxl_decoder {
 	int interleave_granularity;
 	enum cxl_decoder_type target_type;
 	unsigned long flags;
-	seqlock_t target_lock;
-	int nr_targets;
-	struct cxl_dport *target[];
 };
 
+/**
+ * struct cxl_endpoint_decoder - An decoder residing in a CXL endpoint.
+ * @base: Base class decoder
+ */
+struct cxl_endpoint_decoder {
+	struct cxl_decoder base;
+};
+
+/**
+ * struct cxl_switch_decoder - A decoder in a switch or hostbridge.
+ * @base: Base class decoder
+ * @targets: Downstream targets for this switch.
+ */
+struct cxl_switch_decoder {
+	struct cxl_decoder base;
+	struct cxl_decoder_targets *targets;
+};
+
+/**
+ * struct cxl_root_decoder - A toplevel/platform decoder
+ * @base: Base class decoder
+ * @targets: Downstream targets (ie. hostbridges).
+ */
+struct cxl_root_decoder {
+	struct cxl_decoder base;
+	struct cxl_decoder_targets *targets;
+};
+
+#define _to_cxl_decoder(x)                                                     \
+	static inline struct cxl_##x##_decoder *to_cxl_##x##_decoder(          \
+		struct cxl_decoder *cxld)                                      \
+	{                                                                      \
+		return container_of(cxld, struct cxl_##x##_decoder, base);     \
+	}
+
+_to_cxl_decoder(root)
+_to_cxl_decoder(switch)
+_to_cxl_decoder(endpoint)
 
 /**
  * enum cxl_nvdimm_brige_state - state machine for managing bus rescans
@@ -343,11 +387,22 @@ struct cxl_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
 struct cxl_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
 					     unsigned int nr_targets);
 int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map);
-struct cxl_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port);
+struct cxl_endpoint_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port);
 int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map);
 int cxl_decoder_autoremove(struct device *host, struct cxl_decoder *cxld);
 int cxl_endpoint_autoremove(struct cxl_memdev *cxlmd, struct cxl_port *endpoint);
 
+static inline struct cxl_decoder_targets *
+cxl_get_decoder_targets(struct cxl_decoder *cxld)
+{
+	if (is_root_decoder(&cxld->dev))
+		return to_cxl_root_decoder(cxld)->targets;
+	else if (is_endpoint_decoder(&cxld->dev))
+		return NULL;
+	else
+		return to_cxl_switch_decoder(cxld)->targets;
+}
+
 struct cxl_hdm;
 struct cxl_hdm *devm_cxl_setup_hdm(struct cxl_port *port);
 int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm);
diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 431f2bddf6c8..0534d96486eb 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -454,7 +454,7 @@ static int mock_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
 		if (target_count)
 			cxld = cxl_switch_decoder_alloc(port, target_count);
 		else
-			cxld = cxl_endpoint_decoder_alloc(port);
+			cxld = &cxl_endpoint_decoder_alloc(port)->base;
 		if (IS_ERR(cxld)) {
 			dev_warn(&port->dev,
 				 "Failed to allocate the decoder\n");
-- 
2.35.1

