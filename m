Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5084B2118FF2F
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 17:31:06 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 1/4] libndctl,
 intel: Add infrastructure for firmware_status translation
Date: Fri, 11 Jan 2019 18:30:32 -0700
Message-Id: <20190112013035.32087-2-vishal.l.verma@intel.com>
In-Reply-To: <20190112013035.32087-1-vishal.l.verma@intel.com>
References: <20190112013035.32087-1-vishal.l.verma@intel.com>
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
Cc: Ami Pathak <ami.g.pathak@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Add a new routine to ndctl_dimm_ops that allows a DSM family to provide
a translation routine that will translate the status codes of the result
of a DSM to generic errno style error codes. To use this routine
effectively, add a new wrapper around ndctl_cmd_submit (called
ndctl_cmd_submit_xlat) that submits the command, and also runs it
through the above translator dimm_op (if one is is defined).

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/intel.c      | 49 ++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/intel.h      |  1 +
 ndctl/lib/libndctl.c   | 28 ++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |  6 ++++++
 ndctl/lib/private.h    |  1 +
 ndctl/libndctl.h       |  3 +++
 6 files changed, 88 insertions(+)

diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index 744386f..d684bac 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -16,6 +16,54 @@
 #include <ndctl/libndctl.h>
 #include "private.h"
 
+static int intel_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
+{
+	struct nd_pkg_intel *pkg = cmd->intel;
+	unsigned int status, ext_status;
+
+	status = (*cmd->firmware_status) & ND_INTEL_STATUS_MASK;
+	ext_status = (*cmd->firmware_status) & ND_INTEL_STATUS_EXTEND_MASK;
+
+	/* Common statuses */
+	switch (status) {
+	case ND_INTEL_STATUS_SUCCESS:
+		return 0;
+	case ND_INTEL_STATUS_NOTSUPP:
+		return -EOPNOTSUPP;
+	case ND_INTEL_STATUS_NOTEXIST:
+		return -ENXIO;
+	case ND_INTEL_STATUS_INVALPARM:
+		return -EINVAL;
+	case ND_INTEL_STATUS_HWERR:
+		return -EIO;
+	case ND_INTEL_STATUS_RETRY:
+		return -EAGAIN;
+	case ND_INTEL_STATUS_EXTEND:
+		/* refer to extended status, break out of this */
+		break;
+	case ND_INTEL_STATUS_NORES:
+		return -EAGAIN;
+	case ND_INTEL_STATUS_NOTREADY:
+		return -EBUSY;
+	}
+
+	/* Extended status is command specific */
+	switch (pkg->gen.nd_command) {
+	case ND_INTEL_SMART:
+	case ND_INTEL_SMART_THRESHOLD:
+	case ND_INTEL_SMART_SET_THRESHOLD:
+		/* ext status not specified */
+		break;
+	case ND_INTEL_SMART_INJECT:
+		/* smart injection not enabled */
+		if (ext_status == ND_INTEL_STATUS_INJ_DISABLED)
+			return -ENXIO;
+		break;
+	}
+
+	return -ENOMSG;
+}
+
 static struct ndctl_cmd *alloc_intel_cmd(struct ndctl_dimm *dimm,
 		unsigned func, size_t in_size, size_t out_size)
 {
@@ -780,4 +828,5 @@ struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
 	.fw_xlat_firmware_status = intel_cmd_fw_xlat_firmware_status,
 	.new_ack_shutdown_count = intel_dimm_cmd_new_lss,
 	.fw_update_supported = intel_dimm_fw_update_supported,
+	.xlat_firmware_status = intel_cmd_xlat_firmware_status,
 };
diff --git a/ndctl/lib/intel.h b/ndctl/lib/intel.h
index 3b01bba..530c996 100644
--- a/ndctl/lib/intel.h
+++ b/ndctl/lib/intel.h
@@ -179,5 +179,6 @@ struct nd_pkg_intel {
 #define ND_INTEL_STATUS_FQ_BUSY		0x20000
 #define ND_INTEL_STATUS_FQ_BAD		0x30000
 #define ND_INTEL_STATUS_FQ_ORDER	0x40000
+#define ND_INTEL_STATUS_INJ_DISABLED	0x10000
 
 #endif /* __INTEL_H__ */
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index e82a08d..830b791 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2704,6 +2704,16 @@ static const char *ndctl_dimm_get_cmd_subname(struct ndctl_cmd *cmd)
 	return ops->cmd_desc(cmd->pkg->nd_command);
 }
 
+NDCTL_EXPORT int ndctl_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
+{
+	struct ndctl_dimm *dimm = cmd->dimm;
+	struct ndctl_dimm_ops *ops = dimm ? dimm->ops : NULL;
+
+	if (!dimm || !ops || !ops->xlat_firmware_status)
+		return -ENOMSG;
+	return ops->xlat_firmware_status(cmd);
+}
+
 static int do_cmd(int fd, int ioctl_cmd, struct ndctl_cmd *cmd)
 {
 	int rc;
@@ -2819,6 +2829,24 @@ NDCTL_EXPORT int ndctl_cmd_submit(struct ndctl_cmd *cmd)
 	return rc;
 }
 
+NDCTL_EXPORT int ndctl_cmd_submit_xlat(struct ndctl_cmd *cmd)
+{
+	int rc, xlat_rc;
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc < 0)
+		return rc;
+
+	/*
+	 * NOTE: This can lose a positive rc when xlat_rc is non-zero. The
+	 * positive rc indicates a buffer underrun from the original command
+	 * submission. If the caller cares about that (generally not very
+	 * useful), then the xlat function is available separately as well.
+	 */
+	xlat_rc = ndctl_cmd_xlat_firmware_status(cmd);
+	return (xlat_rc == 0) ? rc : xlat_rc;
+}
+
 NDCTL_EXPORT int ndctl_cmd_get_status(struct ndctl_cmd *cmd)
 {
 	return cmd->status;
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 6c4c8b4..275db92 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -385,3 +385,9 @@ global:
 	ndctl_namespace_get_next_badblock;
 	ndctl_dimm_get_dirty_shutdown;
 } LIBNDCTL_17;
+
+LIBNDCTL_19 {
+global:
+	ndctl_cmd_xlat_firmware_status;
+	ndctl_cmd_submit_xlat;
+} LIBNDCTL_18;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 4fbea56..a387b0b 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -338,6 +338,7 @@ struct ndctl_dimm_ops {
 	enum ND_FW_STATUS (*fw_xlat_firmware_status)(struct ndctl_cmd *);
 	struct ndctl_cmd *(*new_ack_shutdown_count)(struct ndctl_dimm *);
 	int (*fw_update_supported)(struct ndctl_dimm *);
+	int (*xlat_firmware_status)(struct ndctl_cmd *);
 };
 
 struct ndctl_dimm_ops * const intel_dimm_ops;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index c81cc03..e55a593 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -681,6 +681,9 @@ enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
 struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm);
 int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
 
+int ndctl_cmd_xlat_firmware_status(struct ndctl_cmd *cmd);
+int ndctl_cmd_submit_xlat(struct ndctl_cmd *cmd);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
-- 
2.17.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
