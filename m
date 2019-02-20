From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [ndctl PATCH v2 1/4] libndctl: add support for NVDIMM_FAMILY_HYPERV's
 _DSM Function 1
Date: Wed, 20 Feb 2019 05:10:32 +0000
Message-ID: <PU1P153MB016988DC99DD57082BEC6006BF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Michael Kelley <mikelley-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org" <qi.fuli-LMvhtfratI1BDgjK7y7TUQ@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org


This patch retrieves the health info by Hyper-V _DSM method Function 1:

Get Health Information (Function Index 1)
See http://www.uefi.org/RFIC_LIST ("Virtual NVDIMM 0x1901").

Now "ndctl list --dimms --health --idle" can show a line "health_state":"ok",
e.g.

  {
    "dev":"nmem0",
    "id":"04d5-01-1701-00000000",
    "handle":0,
    "phys_id":0,
    "health":{
      "health_state":"ok"
    }
  }

If there is an error with the NVDIMM, the "ok" will be replaced with "unknown",
"fatal", "critical", or "non-critical".

Signed-off-by: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 ndctl/lib/Makefile.am |   1 +
 ndctl/lib/hyperv.c    | 129 ++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/hyperv.h    |  51 +++++++++++++++++
 ndctl/lib/libndctl.c  |   2 +
 ndctl/lib/private.h   |   3 +
 ndctl/ndctl.h         |   1 +
 6 files changed, 187 insertions(+)
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
index 0000000..b303d50
--- /dev/null
+++ b/ndctl/lib/hyperv.c
@@ -0,0 +1,129 @@
+/*
+ * Copyright (c) 2019, Microsoft Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+#include <stdlib.h>
+#include <limits.h>
+#include <util/bitmap.h>
+#include <util/log.h>
+#include <ndctl/libndctl.h>
+#include "private.h"
+#include "hyperv.h"
+
+#define CMD_HYPERV(_c) ((_c)->hyperv)
+#define CMD_HYPERV_STATUS(_c) (CMD_HYPERV(_c)->u.status)
+#define CMD_HYPERV_SMART_DATA(_c) (CMD_HYPERV(_c)->u.smart.data)
+
+static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
+{
+	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	struct ndctl_cmd *cmd;
+	size_t size;
+	struct nd_pkg_hyperv *hyperv;
+
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL)) {
+		dbg(ctx, "unsupported cmd\n");
+		return NULL;
+	}
+
+	if (test_dimm_dsm(dimm, ND_HYPERV_CMD_GET_HEALTH_INFO) ==
+			  DIMM_DSM_UNSUPPORTED) {
+		dbg(ctx, "unsupported function\n");
+		return NULL;
+	}
+
+	size = sizeof(*cmd) + sizeof(struct nd_pkg_hyperv);
+	cmd = calloc(1, size);
+	if (!cmd)
+		return NULL;
+
+	cmd->dimm = dimm;
+	ndctl_cmd_ref(cmd);
+	cmd->type = ND_CMD_CALL;
+	cmd->size = size;
+	cmd->status = 1;
+
+	hyperv = CMD_HYPERV(cmd);
+	hyperv->gen.nd_family = NVDIMM_FAMILY_HYPERV;
+	hyperv->gen.nd_command = ND_HYPERV_CMD_GET_HEALTH_INFO;
+	hyperv->gen.nd_fw_size = 0;
+	hyperv->gen.nd_size_in = offsetof(struct nd_hyperv_smart, status);
+	hyperv->gen.nd_size_out = sizeof(hyperv->u.smart);
+	hyperv->u.smart.status = 0;
+
+	cmd->firmware_status = &hyperv->u.smart.status;
+
+	return cmd;
+}
+
+static int hyperv_smart_valid(struct ndctl_cmd *cmd)
+{
+	if (cmd->type != ND_CMD_CALL ||
+	    cmd->size != sizeof(*cmd) + sizeof(struct nd_pkg_hyperv) ||
+	    CMD_HYPERV(cmd)->gen.nd_family != NVDIMM_FAMILY_HYPERV ||
+	    CMD_HYPERV(cmd)->gen.nd_command != ND_HYPERV_CMD_GET_HEALTH_INFO ||
+	    cmd->status != 0 ||
+	    CMD_HYPERV_STATUS(cmd) != 0)
+		return cmd->status < 0 ? cmd->status : -EINVAL;
+	return 0;
+}
+
+static int hyperv_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
+{
+	return CMD_HYPERV_STATUS(cmd) == 0 ? 0 : -EINVAL;
+}
+
+static unsigned int hyperv_cmd_smart_get_flags(struct ndctl_cmd *cmd)
+{
+	int rc;
+
+	rc = hyperv_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
+		return 0;
+	}
+
+	return ND_SMART_HEALTH_VALID;
+}
+
+static unsigned int hyperv_cmd_smart_get_health(struct ndctl_cmd *cmd)
+{
+	unsigned int health = 0;
+	__u32 num;
+	int rc;
+
+	rc = hyperv_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
+		return UINT_MAX;
+	}
+
+	num = CMD_HYPERV_SMART_DATA(cmd)->health & 0x3F;
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
+struct ndctl_dimm_ops * const hyperv_dimm_ops = &(struct ndctl_dimm_ops) {
+	.new_smart = hyperv_dimm_cmd_new_smart,
+	.smart_get_flags = hyperv_cmd_smart_get_flags,
+	.smart_get_health = hyperv_cmd_smart_get_health,
+	.xlat_firmware_status = hyperv_cmd_xlat_firmware_status,
+};
diff --git a/ndctl/lib/hyperv.h b/ndctl/lib/hyperv.h
new file mode 100644
index 0000000..8e55a97
--- /dev/null
+++ b/ndctl/lib/hyperv.h
@@ -0,0 +1,51 @@
+/*
+ * Copyright (c) 2019, Microsoft Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+#ifndef __NDCTL_HYPERV_H__
+#define __NDCTL_HYPERV_H__
+
+/* See http://www.uefi.org/RFIC_LIST ("Virtual NVDIMM 0x1901") */
+enum {
+	ND_HYPERV_CMD_QUERY = 0,
+
+	/* non-root commands */
+	ND_HYPERV_CMD_GET_HEALTH_INFO = 1,
+};
+
+/*
+ * This is actually Function 1's data,
+ * This is the closest I can find to match the "smart".
+ * Hyper-V _DSM methods don't have a smart function.
+ */
+struct nd_hyperv_smart_data {
+	__u32	health;
+} __attribute__((packed));
+
+struct nd_hyperv_smart {
+	__u32	status;
+	union {
+		__u8 buf[4];
+		struct nd_hyperv_smart_data data[0];
+	};
+} __attribute__((packed));
+
+union nd_hyperv_cmd {
+	__u32			status;
+	struct nd_hyperv_smart	smart;
+} __attribute__((packed));
+
+struct nd_pkg_hyperv {
+	struct nd_cmd_pkg	gen;
+	union nd_hyperv_cmd	u;
+} __attribute__((packed));
+
+#endif /* __NDCTL_HYPERV_H__ */
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index c9e2875..48bdb27 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1492,6 +1492,8 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
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
