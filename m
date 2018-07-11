Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D4FCC209605D3
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 15:33:57 -0700 (PDT)
Subject: [PATCH v3 01/11] nfit: add support for Intel DSM 1.7 commands
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 11 Jul 2018 15:33:54 -0700
Message-ID: <153134843411.41955.4688653636984361387.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153134823290.41955.817023337662647245.stgit@djiang5-desk3.ch.intel.com>
References: <153134823290.41955.817023337662647245.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: dhowells@redhat.com, alison.schofield@intel.com, keyrings@vger.kernel.org, keescook@chromium.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add command definition for security commands defined in Intel DSM
specification v1.7. This includes "get security state", "set passphrase",
"unlock unit", "freeze lock", "secure erase", "ovewrite", and
"overwrite query". Since we are adding a lot of Intel definitions, moving
the relevant bits to its own header. Also, we don't want those commands
to be issued from user space through ioctls. Reason being some of the
security commands require kernel involvement to flush all CPU caches that
can't be done in userspace and the result can cause system crash. So
blocking security commands in the ioctl path.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/core.c  |   28 ++++++++++++++++++-
 drivers/acpi/nfit/intel.h |   67 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/nfit.h  |   17 +++++++++++
 drivers/nvdimm/bus.c      |    2 +
 include/linux/libnvdimm.h |    2 +
 5 files changed, 112 insertions(+), 4 deletions(-)
 create mode 100644 drivers/acpi/nfit/intel.h

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 0f47917b8ef1..a3a944751e6a 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -24,6 +24,7 @@
 #include <linux/nd.h>
 #include <asm/cacheflush.h>
 #include <acpi/nfit.h>
+#include "intel.h"
 #include "nfit.h"
 
 /*
@@ -377,6 +378,14 @@ static u8 nfit_dsm_revid(unsigned family, unsigned func)
 			[NVDIMM_INTEL_QUERY_FWUPDATE] = 2,
 			[NVDIMM_INTEL_SET_THRESHOLD] = 2,
 			[NVDIMM_INTEL_INJECT_ERROR] = 2,
+			[NVDIMM_INTEL_GET_SECURITY_STATE] = 2,
+			[NVDIMM_INTEL_SET_PASSPHRASE] = 2,
+			[NVDIMM_INTEL_DISABLE_PASSPHRASE] = 2,
+			[NVDIMM_INTEL_UNLOCK_UNIT] = 2,
+			[NVDIMM_INTEL_FREEZE_LOCK] = 2,
+			[NVDIMM_INTEL_SECURE_ERASE] = 2,
+			[NVDIMM_INTEL_OVERWRITE] = 2,
+			[NVDIMM_INTEL_QUERY_OVERWRITE] = 2,
 		},
 	};
 	u8 id;
@@ -3202,7 +3211,7 @@ static int acpi_nfit_flush_probe(struct nvdimm_bus_descriptor *nd_desc)
 	return 0;
 }
 
-static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
+static int __acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd)
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
@@ -3224,6 +3233,23 @@ static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
 	return 0;
 }
 
+/* prevent security commands from being issued via ioctl */
+static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
+		struct nvdimm *nvdimm, unsigned int cmd, void *buf)
+{
+	struct nd_cmd_pkg *call_pkg = buf;
+	unsigned int func;
+
+	if (nvdimm && cmd == ND_CMD_CALL &&
+			call_pkg->nd_family == NVDIMM_FAMILY_INTEL) {
+		func = call_pkg->nd_command;
+		if ((1 << func) & NVDIMM_INTEL_SECURITY_CMDMASK)
+			return -EOPNOTSUPP;
+	}
+
+	return __acpi_nfit_clear_to_send(nd_desc, nvdimm, cmd);
+}
+
 int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc, unsigned long flags)
 {
 	struct device *dev = acpi_desc->dev;
diff --git a/drivers/acpi/nfit/intel.h b/drivers/acpi/nfit/intel.h
new file mode 100644
index 000000000000..f60dbcbc5f33
--- /dev/null
+++ b/drivers/acpi/nfit/intel.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
+/*
+ * Intel specific definitions for NVDIMM Firmware Interface Table - NFIT
+ */
+#ifndef _NFIT_INTEL_H_
+#define _NFIT_INTEL_H_
+
+#ifdef CONFIG_X86
+
+#define ND_INTEL_STATUS_SIZE		4
+#define ND_INTEL_PASSPHRASE_SIZE	32
+
+#define ND_INTEL_STATUS_RETRY		5
+#define ND_INTEL_STATUS_NOT_READY	9
+#define ND_INTEL_STATUS_INVALID_STATE	10
+#define ND_INTEL_STATUS_INVALID_PASS	11
+
+#define ND_INTEL_SEC_STATE_ENABLED	0x02
+#define ND_INTEL_SEC_STATE_LOCKED	0x04
+#define ND_INTEL_SEC_STATE_FROZEN	0x08
+#define ND_INTEL_SEC_STATE_PLIMIT	0x10
+#define ND_INTEL_SEC_STATE_UNSUPPORTED	0x20
+
+struct nd_intel_get_security_state {
+	u32 status;
+	u32 reserved;
+	u8 state;
+	u8 reserved1[3];
+} __packed;
+
+struct nd_intel_set_passphrase {
+	u8 old_pass[32];
+	u8 new_pass[32];
+	u32 status;
+} __packed;
+
+struct nd_intel_unlock_unit {
+	u8 passphrase[32];
+	u32 status;
+} __packed;
+
+struct nd_intel_disable_passphrase {
+	u8 passphrase[32];
+	u32 status;
+} __packed;
+
+struct nd_intel_freeze_lock {
+	u32 status;
+} __packed;
+
+struct nd_intel_secure_erase {
+	u8 passphrase[32];
+	u32 status;
+} __packed;
+
+struct nd_intel_overwrite {
+	u8 passphrase[32];
+	u32 status;
+} __packed;
+
+struct nd_intel_query_overwrite {
+	u32 status;
+} __packed;
+#endif /* CONFIG_X86 */
+
+#endif
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 7d15856a739f..40b0003b1805 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -60,14 +60,29 @@ enum nvdimm_family_cmds {
 	NVDIMM_INTEL_QUERY_FWUPDATE = 16,
 	NVDIMM_INTEL_SET_THRESHOLD = 17,
 	NVDIMM_INTEL_INJECT_ERROR = 18,
+	NVDIMM_INTEL_GET_SECURITY_STATE = 19,
+	NVDIMM_INTEL_SET_PASSPHRASE = 20,
+	NVDIMM_INTEL_DISABLE_PASSPHRASE = 21,
+	NVDIMM_INTEL_UNLOCK_UNIT = 22,
+	NVDIMM_INTEL_FREEZE_LOCK = 23,
+	NVDIMM_INTEL_SECURE_ERASE = 24,
+	NVDIMM_INTEL_OVERWRITE = 25,
+	NVDIMM_INTEL_QUERY_OVERWRITE = 26,
 };
 
+#define NVDIMM_INTEL_SECURITY_CMDMASK \
+(1 << NVDIMM_INTEL_GET_SECURITY_STATE | 1 << NVDIMM_INTEL_SET_PASSPHRASE \
+| 1 << NVDIMM_INTEL_DISABLE_PASSPHRASE | 1 << NVDIMM_INTEL_UNLOCK_UNIT \
+| 1 << NVDIMM_INTEL_FREEZE_LOCK | 1 << NVDIMM_INTEL_SECURE_ERASE \
+| 1 << NVDIMM_INTEL_OVERWRITE | 1 << NVDIMM_INTEL_QUERY_OVERWRITE)
+
 #define NVDIMM_INTEL_CMDMASK \
 (NVDIMM_STANDARD_CMDMASK | 1 << NVDIMM_INTEL_GET_MODES \
  | 1 << NVDIMM_INTEL_GET_FWINFO | 1 << NVDIMM_INTEL_START_FWUPDATE \
  | 1 << NVDIMM_INTEL_SEND_FWUPDATE | 1 << NVDIMM_INTEL_FINISH_FWUPDATE \
  | 1 << NVDIMM_INTEL_QUERY_FWUPDATE | 1 << NVDIMM_INTEL_SET_THRESHOLD \
- | 1 << NVDIMM_INTEL_INJECT_ERROR | 1 << NVDIMM_INTEL_LATCH_SHUTDOWN)
+ | 1 << NVDIMM_INTEL_INJECT_ERROR | 1 << NVDIMM_INTEL_LATCH_SHUTDOWN \
+ | NVDIMM_INTEL_SECURITY_CMDMASK)
 
 enum nfit_uuids {
 	/* for simplicity alias the uuid index with the family id */
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 27902a8799b1..de2af49bbf08 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -894,7 +894,7 @@ static int nd_cmd_clear_to_send(struct nvdimm_bus *nvdimm_bus,
 
 	/* ask the bus provider if it would like to block this request */
 	if (nd_desc->clear_to_send) {
-		int rc = nd_desc->clear_to_send(nd_desc, nvdimm, cmd);
+		int rc = nd_desc->clear_to_send(nd_desc, nvdimm, cmd, data);
 
 		if (rc)
 			return rc;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 097072c5a852..472171af7f60 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -87,7 +87,7 @@ struct nvdimm_bus_descriptor {
 	ndctl_fn ndctl;
 	int (*flush_probe)(struct nvdimm_bus_descriptor *nd_desc);
 	int (*clear_to_send)(struct nvdimm_bus_descriptor *nd_desc,
-			struct nvdimm *nvdimm, unsigned int cmd);
+			struct nvdimm *nvdimm, unsigned int cmd, void *data);
 };
 
 struct nd_cmd_desc {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
