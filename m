Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com
 [IPv6:2607:f8b0:4864:20::741])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9AE2211E95BE
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 21:20:36 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id o129so2458297qke.8
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 21:20:36 -0700 (PDT)
From: Dexuan Cui <dexuan.cui@gmail.com>
Subject: [ndctl PATCH v3 1/5] libndctl: Implement the "smart_get_health"
 dimm-op for Hyper-V
Date: Sat, 23 Mar 2019 04:20:25 +0000
Message-Id: <20190323042028.4310-2-decui@microsoft.com>
In-Reply-To: <20190323042028.4310-1-decui@microsoft.com>
References: <20190323042028.4310-1-decui@microsoft.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: vishal.l.verma@intel.com, dan.j.williams@intel.com, dave.jiang@intel.com, linux-nvdimm@lists.01.org, mikelley@microsoft.com
Cc: qi.fuli@fujitsu.com
List-ID: <linux-nvdimm@lists.01.org>

Show the health info of the NVDIMM by
	"Get Health Information (Function Index 1)"

See http://www.uefi.org/RFIC_LIST ("Virtual NVDIMM 0x1901").

Now "ndctl list --dimms --health" can show a line
	"health_state":"ok"
for Hyper-V NVDIMM, e.g.

  {
    "dev":"nmem0",
    "id":"04d5-01-1701-00000000",
    "handle":0,
    "phys_id":0,
    "health":{
      "health_state":"ok"
    }
  }

If the NVDIMM has an error, the string "ok" will be replaced with
"fatal", "critical", or "non-critical".

If ndctl fails to retrieve the health info due to some reason, a string
of "unknown" will be shown.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 ndctl/lib/Makefile.am |   1 +
 ndctl/lib/hyperv.c    | 126 ++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/hyperv.h    |  30 ++++++++++
 ndctl/lib/libndctl.c  |   2 +
 ndctl/lib/private.h   |   3 +
 ndctl/ndctl.h         |   1 +
 6 files changed, 163 insertions(+)
 create mode 100644 ndctl/lib/hyperv.c
 create mode 100644 ndctl/lib/hyperv.h

diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index 7797039..fb75fda 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -20,6 +20,7 @@ libndctl_la_SOURCES =\
 	intel.c \
 	hpe1.c \
 	msft.c \
+	hyperv.c \
 	ars.c \
 	firmware.c \
 	libndctl.c
diff --git a/ndctl/lib/hyperv.c b/ndctl/lib/hyperv.c
new file mode 100644
index 0000000..6ed2125
--- /dev/null
+++ b/ndctl/lib/hyperv.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2019, Microsoft Corporation. All rights reserved. */
+
+#include <stdlib.h>
+#include <limits.h>
+#include <util/bitmap.h>
+#include <util/log.h>
+#include <ndctl/libndctl.h>
+#include "private.h"
+#include "hyperv.h"
+
+static struct ndctl_cmd *alloc_hyperv_cmd(struct ndctl_dimm *dimm,
+		unsigned int command)
+{
+	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	struct nd_pkg_hyperv *hyperv;
+	struct ndctl_cmd *cmd;
+	size_t size;
+
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL)) {
+		dbg(ctx, "unsupported cmd\n");
+		return NULL;
+	}
+
+	if (test_dimm_dsm(dimm, command) == DIMM_DSM_UNSUPPORTED) {
+		dbg(ctx, "unsupported function\n");
+		return NULL;
+	}
+
+	size = sizeof(*cmd) + sizeof(struct nd_pkg_hyperv);
+	cmd = calloc(1, size);
+	if (!cmd)
+		return NULL;
+
+	ndctl_cmd_ref(cmd);
+
+	cmd->dimm = dimm;
+	cmd->type = ND_CMD_CALL;
+	cmd->size = size;
+	cmd->status = 1;
+
+	hyperv = cmd->hyperv;
+	hyperv->gen.nd_family = NVDIMM_FAMILY_HYPERV;
+	hyperv->gen.nd_command = command;
+	hyperv->gen.nd_size_out = sizeof(hyperv->u.health_info);
+
+	cmd->firmware_status = &hyperv->u.health_info.status;
+	return cmd;
+}
+
+static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
+{
+	return alloc_hyperv_cmd(dimm, ND_HYPERV_CMD_GET_HEALTH_INFO);
+}
+
+static int hyperv_cmd_valid(struct ndctl_cmd *cmd, unsigned int command)
+{
+	if (cmd->type != ND_CMD_CALL ||
+	    cmd->size != sizeof(*cmd) + sizeof(struct nd_pkg_hyperv) ||
+	    cmd->hyperv->gen.nd_family != NVDIMM_FAMILY_HYPERV ||
+	    cmd->hyperv->gen.nd_command != command ||
+	    cmd->status != 0 ||
+	    cmd->hyperv->u.status != 0)
+		return cmd->status < 0 ? cmd->status : -EINVAL;
+
+	return 0;
+}
+
+static int hyperv_valid_health_info(struct ndctl_cmd *cmd)
+{
+	return hyperv_cmd_valid(cmd, ND_HYPERV_CMD_GET_HEALTH_INFO);
+}
+
+static unsigned int hyperv_cmd_get_flags(struct ndctl_cmd *cmd)
+{
+	unsigned int flags = 0;
+	int rc;
+
+	rc = hyperv_valid_health_info(cmd);
+	if (rc < 0) {
+		errno = -rc;
+		return 0;
+	}
+	flags |= ND_SMART_HEALTH_VALID;
+
+	return flags;
+}
+
+static unsigned int hyperv_cmd_get_health(struct ndctl_cmd *cmd)
+{
+	unsigned int health = 0;
+	__u32 num;
+	int rc;
+
+	rc = hyperv_valid_health_info(cmd);
+	if (rc < 0) {
+		errno = -rc;
+		return UINT_MAX;
+	}
+
+	num = cmd->hyperv->u.health_info.health & 0x3F;
+
+	if (num & (BIT(0) | BIT(1)))
+		health |= ND_SMART_CRITICAL_HEALTH;
+
+	if (num & BIT(2))
+		health |= ND_SMART_FATAL_HEALTH;
+
+	if (num & (BIT(3) | BIT(4) | BIT(5)))
+		health |= ND_SMART_NON_CRITICAL_HEALTH;
+
+	return health;
+}
+
+static int hyperv_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
+{
+	return cmd->hyperv->u.status == 0 ? 0 : -EINVAL;
+}
+
+struct ndctl_dimm_ops * const hyperv_dimm_ops = &(struct ndctl_dimm_ops) {
+	.new_smart = hyperv_dimm_cmd_new_smart,
+	.smart_get_flags = hyperv_cmd_get_flags,
+	.smart_get_health = hyperv_cmd_get_health,
+	.xlat_firmware_status = hyperv_cmd_xlat_firmware_status,
+};
diff --git a/ndctl/lib/hyperv.h b/ndctl/lib/hyperv.h
new file mode 100644
index 0000000..45bbc12
--- /dev/null
+++ b/ndctl/lib/hyperv.h
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2019, Microsoft Corporation. All rights reserved. */
+
+#ifndef __NDCTL_HYPERV_H__
+#define __NDCTL_HYPERV_H__
+
+/* See http://www.uefi.org/RFIC_LIST ("Virtual NVDIMM 0x1901") */
+
+enum {
+	ND_HYPERV_CMD_QUERY_SUPPORTED_FUNCTIONS	= 0,
+	ND_HYPERV_CMD_GET_HEALTH_INFO		= 1,
+};
+
+/* Get Health Information (Function Index 1) */
+struct nd_hyperv_health_info {
+	__u32	status;
+	__u32	health;
+} __attribute__((packed));
+
+union nd_hyperv_cmd {
+	__u32				status;
+	struct nd_hyperv_health_info	health_info;
+} __attribute__((packed));
+
+struct nd_pkg_hyperv {
+	struct nd_cmd_pkg	gen;
+	union  nd_hyperv_cmd	u;
+} __attribute__((packed));
+
+#endif /* __NDCTL_HYPERV_H__ */
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 98893bc..24b8ad3 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1543,6 +1543,8 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 		dimm->ops = hpe1_dimm_ops;
 	if (dimm->cmd_family == NVDIMM_FAMILY_MSFT)
 		dimm->ops = msft_dimm_ops;
+	if (dimm->cmd_family == NVDIMM_FAMILY_HYPERV)
+		dimm->ops = hyperv_dimm_ops;
 
 	sprintf(path, "%s/nfit/dsm_mask", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index a387b0b..a9d35c5 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -31,6 +31,7 @@
 #include "intel.h"
 #include "hpe1.h"
 #include "msft.h"
+#include "hyperv.h"
 
 struct nvdimm_data {
 	struct ndctl_cmd *cmd_read;
@@ -270,6 +271,7 @@ struct ndctl_cmd {
 		struct nd_cmd_pkg pkg[0];
 		struct ndn_pkg_hpe1 hpe1[0];
 		struct ndn_pkg_msft msft[0];
+		struct nd_pkg_hyperv hyperv[0];
 		struct nd_pkg_intel intel[0];
 		struct nd_cmd_get_config_size get_size[0];
 		struct nd_cmd_get_config_data_hdr get_data[0];
@@ -344,6 +346,7 @@ struct ndctl_dimm_ops {
 struct ndctl_dimm_ops * const intel_dimm_ops;
 struct ndctl_dimm_ops * const hpe1_dimm_ops;
 struct ndctl_dimm_ops * const msft_dimm_ops;
+struct ndctl_dimm_ops * const hyperv_dimm_ops;
 
 static inline struct ndctl_bus *cmd_to_bus(struct ndctl_cmd *cmd)
 {
diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
index c6aaa4c..008f81c 100644
--- a/ndctl/ndctl.h
+++ b/ndctl/ndctl.h
@@ -262,6 +262,7 @@ struct nd_cmd_pkg {
 #define NVDIMM_FAMILY_HPE1 1
 #define NVDIMM_FAMILY_HPE2 2
 #define NVDIMM_FAMILY_MSFT 3
+#define NVDIMM_FAMILY_HYPERV 4
 
 #define ND_IOCTL_CALL			_IOWR(ND_IOCTL, ND_CMD_CALL,\
 					struct nd_cmd_pkg)
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
