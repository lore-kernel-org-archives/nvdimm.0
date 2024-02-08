Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F6A383A9;
	Thu,  8 Feb 2024 20:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707423314; cv=none; b=Ml9uDpQPFs0JXeSMHPWunnAdYfXXuHl0OQ7LuHfpzP80rIuLYCHN4EIdT8ltACmOgs6tn2W2KIDFOkk4T+QAsBgsknB92KsIoOK1Xwmjg+ZFthZ1CdCV9NjB1Xv2Icr/Hld6jIWmaOiiNew4v5vZ88EZHsCt6w6cIdqdb7hgT7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707423314; c=relaxed/simple;
	bh=3PA5iTtSWy2AAHcM2OZFk8S0UaV68Shti0Fbzi/CAH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3s9zwji5lbI4XTzqc16Euj4js42jf6DrkmbuImtqOeuE+fqlt3bMvju3TefoOkOLHrPhZMwAdOxpcYJzSycRdyAXAU9rC/vICGC4sEWoQh2Br1hUioDe5sBG/SQUYphd9pOGP9lcelNxlbmO+8GoBA1GQ7/8NaBEra5mtdr9fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF087C43394;
	Thu,  8 Feb 2024 20:15:13 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	Alison Schofield <alison.schofield@intel.com>
Subject: [NDCTL PATCH v7 3/4] ndctl: cxl: add QoS class check for CXL region creation
Date: Thu,  8 Feb 2024 13:11:57 -0700
Message-ID: <20240208201435.2081583-4-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240208201435.2081583-1-dave.jiang@intel.com>
References: <20240208201435.2081583-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CFMWS provides a QTG ID. The kernel driver creates a root decoder that
represents the CFMWS. A qos_class attribute is exported via sysfs for the root
decoder.

One or more qos_class tokens are retrieved via QTG ID _DSM from the ACPI0017
device for a CXL memory device. The input for the _DSM is the read and write
latency and bandwidth for the path between the device and the CPU. The
numbers are constructed by the kernel driver for the _DSM input. When a
device is probed, QoS class tokens  are retrieved. This is useful for a
hot-plugged CXL memory device that does not have regions created.

Add a QoS check during region creation. If --enforce-qos/-Q is set and
the qos_class mismatches, the region creation will fail.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v7:
- Add qos_class_mismatched to region for cxl list (Vishal)
- Add create_region -Q check (Vishal)
---
 Documentation/cxl/cxl-create-region.txt |  6 +++
 cxl/json.c                              |  6 +++
 cxl/lib/libcxl.c                        | 11 +++++
 cxl/lib/libcxl.sym                      |  2 +
 cxl/lib/private.h                       |  1 +
 cxl/libcxl.h                            |  2 +
 cxl/region.c                            | 56 ++++++++++++++++++++++++-
 7 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
index f11a412bddfe..b244af60b8a6 100644
--- a/Documentation/cxl/cxl-create-region.txt
+++ b/Documentation/cxl/cxl-create-region.txt
@@ -105,6 +105,12 @@ include::bus-option.txt[]
 	supplied, the first cross-host bridge (if available), decoder that
 	supports the largest interleave will be chosen.
 
+-Q::
+--enforce-qos::
+	Parameter to enforce qos_class mismatch failure. Region create operation
+	will fail of the qos_class of the root decoder and one of the memdev that
+	backs the region mismatches.
+
 include::human-option.txt[]
 
 include::debug-option.txt[]
diff --git a/cxl/json.c b/cxl/json.c
index c8bd8c27447a..27cbacc84f3a 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1238,6 +1238,12 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 		}
 	}
 
+	if (cxl_region_qos_class_mismatched(region)) {
+		jobj = json_object_new_boolean(true);
+		if (jobj)
+			json_object_object_add(jregion, "qos_class_mismatched", jobj);
+	}
+
 	json_object_set_userdata(jregion, region, NULL);
 
 
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 6c293f1dfc91..3461c4de2097 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -414,6 +414,17 @@ CXL_EXPORT int cxl_region_is_enabled(struct cxl_region *region)
 	return is_enabled(path);
 }
 
+CXL_EXPORT void cxl_region_qos_class_mismatched_set(struct cxl_region *region,
+						  bool mismatched)
+{
+	region->qos_mismatched = mismatched;
+}
+
+CXL_EXPORT bool cxl_region_qos_class_mismatched(struct cxl_region *region)
+{
+	return region->qos_mismatched;
+}
+
 CXL_EXPORT int cxl_region_disable(struct cxl_region *region)
 {
 	const char *devname = cxl_region_get_devname(region);
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 465c78dc6c70..47a9c3cafc71 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -285,4 +285,6 @@ global:
 	cxl_root_decoder_get_qos_class;
 	cxl_memdev_get_pmem_qos_class;
 	cxl_memdev_get_ram_qos_class;
+	cxl_region_qos_class_mismatched_set;
+	cxl_region_qos_class_mismatched;
 } LIBCXL_7;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 07dc8c784f1d..88448d82d53f 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -174,6 +174,7 @@ struct cxl_region {
 	struct daxctl_region *dax_region;
 	struct kmod_module *module;
 	struct list_head mappings;
+	bool qos_mismatched;
 };
 
 struct cxl_memdev_mapping {
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index a180f01cb05e..7795496cdbbd 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -335,6 +335,8 @@ int cxl_region_clear_target(struct cxl_region *region, int position);
 int cxl_region_clear_all_targets(struct cxl_region *region);
 int cxl_region_decode_commit(struct cxl_region *region);
 int cxl_region_decode_reset(struct cxl_region *region);
+void cxl_region_qos_class_mismatched_set(struct cxl_region *region, bool mismatched);
+bool cxl_region_qos_class_mismatched(struct cxl_region *region);
 
 #define cxl_region_foreach(decoder, region)                                    \
 	for (region = cxl_region_get_first(decoder); region != NULL;           \
diff --git a/cxl/region.c b/cxl/region.c
index 3a762db4800e..76df177ef246 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -32,6 +32,7 @@ static struct region_params {
 	bool force;
 	bool human;
 	bool debug;
+	bool qos_enforce;
 } param = {
 	.ways = INT_MAX,
 	.granularity = INT_MAX,
@@ -49,6 +50,8 @@ struct parsed_params {
 	const char **argv;
 	struct cxl_decoder *root_decoder;
 	enum cxl_decoder_mode mode;
+	bool qos_enforce;
+	bool qos_mismatched;
 };
 
 enum region_actions {
@@ -81,7 +84,8 @@ OPT_STRING('U', "uuid", &param.uuid, \
 	   "region uuid", "uuid for the new region (default: autogenerate)"), \
 OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
 	    "non-option arguments are memdevs"), \
-OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats")
+OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats"), \
+OPT_BOOLEAN('Q', "enforce-qos", &param.qos_enforce, "enforce of qos_class matching")
 
 static const struct option create_options[] = {
 	BASE_OPTIONS(),
@@ -360,6 +364,8 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 		}
 	}
 
+	p->qos_enforce = param.qos_enforce;
+
 	return 0;
 
 err:
@@ -467,6 +473,49 @@ static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
 		p->mode = CXL_DECODER_MODE_PMEM;
 }
 
+static int create_region_validate_qos_class(struct cxl_ctx *ctx,
+					    struct parsed_params *p)
+{
+	int root_qos_class;
+	int qos_class;
+	int i;
+
+	if (!p->qos_enforce)
+		return 0;
+
+	root_qos_class = cxl_root_decoder_get_qos_class(p->root_decoder);
+	if (root_qos_class == CXL_QOS_CLASS_NONE)
+		return 0;
+
+	for (i = 0; i < p->ways; i++) {
+		struct json_object *jobj =
+			json_object_array_get_idx(p->memdevs, i);
+		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
+
+		if (p->mode == CXL_DECODER_MODE_RAM)
+			qos_class = cxl_memdev_get_ram_qos_class(memdev);
+		else
+			qos_class = cxl_memdev_get_pmem_qos_class(memdev);
+
+		/* No qos_class entries. Possibly no kernel support */
+		if (qos_class == CXL_QOS_CLASS_NONE)
+			break;
+
+		if (qos_class != root_qos_class) {
+			p->qos_mismatched = true;
+			if (p->qos_enforce) {
+				log_err(&rl, "%s QoS Class mismatches %s\n",
+					cxl_decoder_get_devname(p->root_decoder),
+					cxl_memdev_get_devname(memdev));
+
+				return -ENXIO;
+			}
+		}
+	}
+
+	return 0;
+}
+
 static int create_region_validate_config(struct cxl_ctx *ctx,
 					 struct parsed_params *p)
 {
@@ -507,6 +556,10 @@ found:
 		return rc;
 
 	collect_minsize(ctx, p);
+	rc = create_region_validate_qos_class(ctx, p);
+	if (rc)
+		return rc;
+
 	return 0;
 }
 
@@ -654,6 +707,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 		return -EOPNOTSUPP;
 	}
 
+	cxl_region_qos_class_mismatched_set(region, p->qos_mismatched);
 	devname = cxl_region_get_devname(region);
 
 	rc = cxl_region_determine_granularity(region, p);
-- 
2.43.0

