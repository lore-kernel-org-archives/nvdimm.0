Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27D5D209688E3
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 15:19:18 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2] ndctl: add an API to check support for smart
 injection
Date: Wed, 11 Jul 2018 16:19:02 -0600
Message-Id: <20180711221902.13640-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add an API to check whether smart injection is supported, and add an
intel-dsm implementation for it. Use this check in the ndctl
inject-smart command.

Reported-by: Leszek Lugin <leszek.lugin@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/inject-smart.c   | 16 ++++++++++++++++
 ndctl/lib/intel.c      | 18 ++++++++++++++++++
 ndctl/lib/libndctl.sym |  5 +++++
 ndctl/lib/private.h    |  1 +
 ndctl/lib/smart.c      | 10 ++++++++++
 ndctl/libndctl.h       |  1 +
 6 files changed, 51 insertions(+)

v2:
 - Fix the supported check to only use the command DSM instead of all
   its internal flags (which are not commands by themselves).
 - Improve readability of the DSM test (Dan)

diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index 60de9fe..7793706 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -352,6 +352,22 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
 	struct json_object *jdimm;
 	int rc;
 
+	rc = ndctl_dimm_smart_inject_supported(dimm);
+	switch (rc) {
+	case -ENOTTY:
+		error("%s: smart injection not supported by ndctl.",
+			ndctl_dimm_get_devname(dimm));
+		return rc;
+	case -EOPNOTSUPP:
+		error("%s: smart injection not supported by the kernel",
+			ndctl_dimm_get_devname(dimm));
+		return rc;
+	case -EIO:
+		error("%s: smart injection not supported by either platform firmware or the kernel.",
+			ndctl_dimm_get_devname(dimm));
+		return rc;
+	}
+
 	if (sctx.op_mask & (1 << OP_SET)) {
 		rc = smart_set_thresh(dimm);
 		if (rc)
diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index 49a4360..0abea1e 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -362,6 +362,23 @@ static int intel_cmd_smart_inject_unsafe_shutdown(struct ndctl_cmd *cmd,
 	return 0;
 }
 
+static int intel_dimm_smart_inject_supported(struct ndctl_dimm *dimm)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL)) {
+		dbg(ctx, "unsupported cmd: %d\n", ND_CMD_CALL);
+		return -EOPNOTSUPP;
+	}
+
+	if (!test_dimm_dsm(dimm, ND_INTEL_SMART_INJECT)) {
+		dbg(ctx, "smart injection functions unsupported\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static const char *intel_cmd_desc(int fn)
 {
 	static const char *descs[] = {
@@ -714,6 +731,7 @@ struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
 	.smart_inject_spares = intel_cmd_smart_inject_spares,
 	.smart_inject_fatal = intel_cmd_smart_inject_fatal,
 	.smart_inject_unsafe_shutdown = intel_cmd_smart_inject_unsafe_shutdown,
+	.smart_inject_supported = intel_dimm_smart_inject_supported,
 	.new_fw_get_info = intel_dimm_cmd_new_fw_get_info,
 	.fw_info_get_storage_size = intel_cmd_fw_info_get_storage_size,
 	.fw_info_get_max_send_len = intel_cmd_fw_info_get_max_send_len,
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index e939993..8932ef6 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -367,3 +367,8 @@ global:
 	ndctl_namespace_uninject_error2;
 	ndctl_cmd_ars_stat_get_flag_overflow;
 } LIBNDCTL_15;
+
+LIBNDCTL_17 {
+global:
+	ndctl_dimm_smart_inject_supported;
+} LIBNDCTL_16;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index b756b74..a94f894 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -311,6 +311,7 @@ struct ndctl_dimm_ops {
 	int (*smart_inject_spares)(struct ndctl_cmd *, bool, unsigned int);
 	int (*smart_inject_fatal)(struct ndctl_cmd *, bool);
 	int (*smart_inject_unsafe_shutdown)(struct ndctl_cmd *, bool);
+	int (*smart_inject_supported)(struct ndctl_dimm *);
 	struct ndctl_cmd *(*new_fw_get_info)(struct ndctl_dimm *);
 	unsigned int (*fw_info_get_storage_size)(struct ndctl_cmd *);
 	unsigned int (*fw_info_get_max_send_len)(struct ndctl_cmd *);
diff --git a/ndctl/lib/smart.c b/ndctl/lib/smart.c
index 0455252..7ba46d1 100644
--- a/ndctl/lib/smart.c
+++ b/ndctl/lib/smart.c
@@ -172,3 +172,13 @@ ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm)
 	else
 		return NULL;
 }
+
+NDCTL_EXPORT int ndctl_dimm_smart_inject_supported(struct ndctl_dimm *dimm)
+{
+	struct ndctl_dimm_ops *ops = dimm->ops;
+
+	if (ops && ops->smart_inject_supported)
+		return ops->smart_inject_supported(dimm);
+	else
+		return -ENOTTY;
+}
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 9270bae..8a96c84 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -279,6 +279,7 @@ int ndctl_cmd_smart_inject_spares(struct ndctl_cmd *cmd, bool enable,
 		unsigned int spares);
 int ndctl_cmd_smart_inject_fatal(struct ndctl_cmd *cmd, bool enable);
 int ndctl_cmd_smart_inject_unsafe_shutdown(struct ndctl_cmd *cmd, bool enable);
+int ndctl_dimm_smart_inject_supported(struct ndctl_dimm *dimm);
 
 struct ndctl_cmd *ndctl_dimm_cmd_new_vendor_specific(struct ndctl_dimm *dimm,
 		unsigned int opcode, size_t input_size, size_t output_size);
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
