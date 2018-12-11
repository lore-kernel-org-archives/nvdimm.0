Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7BFFB21196835
 for <linux-nvdimm@lists.01.org>; Tue, 11 Dec 2018 12:25:23 -0800 (PST)
Subject: [PATCH v13 01/17] acpi/nfit: Add support for Intel DSM 1.8 commands
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 11 Dec 2018 13:25:22 -0700
Message-ID: <154455992227.26509.9170884199860698809.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154455914081.26509.7988630204184570351.stgit@djiang5-desk3.ch.intel.com>
References: <154455914081.26509.7988630204184570351.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add command definition for security commands defined in Intel DSM
specification v1.8 [1]. This includes "get security state", "set
passphrase", "unlock unit", "freeze lock", "secure erase", "overwrite",
"overwrite query", "master passphrase enable/disable", and "master
erase", . Since this adds several Intel definitions, move the relevant
bits to their own header.

These commands mutate physical data, but that manipulation is not cache
coherent. The requirement to flush and invalidate caches makes these
commands unsuitable to be called from userspace, so extra logic is added
to detect and block these commands from being submitted via the ioctl
command submission path.

Lastly, the commands may contain sensitive key material that should not
be dumped in a standard debug session. Update the nvdimm-command
payload-dump facility to move security command payloads behind a
default-off compile time switch.

[1]: http://pmem.io/documents/NVDIMM_DSM_Interface-V1.8.pdf

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/Kconfig |   11 +++++++
 drivers/acpi/nfit/core.c  |   44 ++++++++++++++++++++++++---
 drivers/acpi/nfit/intel.h |   74 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/nfit.h  |   21 ++++++++++++-
 drivers/nvdimm/bus.c      |    2 +
 include/linux/libnvdimm.h |    2 +
 6 files changed, 147 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/nfit/Kconfig b/drivers/acpi/nfit/Kconfig
index f7c57e33499e..52eefd732cf2 100644
--- a/drivers/acpi/nfit/Kconfig
+++ b/drivers/acpi/nfit/Kconfig
@@ -13,3 +13,14 @@ config ACPI_NFIT
 
 	  To compile this driver as a module, choose M here:
 	  the module will be called nfit.
+
+config NFIT_SECURITY_DEBUG
+	bool "Enable debug for NVDIMM security commands"
+	depends on ACPI_NFIT
+	help
+	  Some NVDIMM devices and controllers support encryption and
+	  other security features. The payloads for the commands that
+	  enable those features may contain sensitive clear-text
+	  security material. Disable debug of those command payloads
+	  by default. If you are a kernel developer actively working
+	  on NVDIMM security enabling say Y, otherwise say N.
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 14d9f5bea015..68d146f8f8a6 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -24,6 +24,7 @@
 #include <linux/nd.h>
 #include <asm/cacheflush.h>
 #include <acpi/nfit.h>
+#include "intel.h"
 #include "nfit.h"
 #include "intel.h"
 
@@ -380,6 +381,14 @@ static u8 nfit_dsm_revid(unsigned family, unsigned func)
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
@@ -394,6 +403,15 @@ static u8 nfit_dsm_revid(unsigned family, unsigned func)
 	return id;
 }
 
+static bool payload_dumpable(unsigned int family, unsigned int func)
+{
+	if (family == NVDIMM_FAMILY_INTEL
+			&& func >= NVDIMM_INTEL_GET_SECURITY_STATE
+			&& func <= NVDIMM_INTEL_MASTER_SECURE_ERASE)
+		return IS_ENABLED(CONFIG_NFIT_SECURITY_DEBUG);
+	return true;
+}
+
 int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		unsigned int cmd, void *buf, unsigned int buf_len, int *cmd_rc)
 {
@@ -478,9 +496,10 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 
 	dev_dbg(dev, "%s cmd: %d: func: %d input length: %d\n",
 		dimm_name, cmd, func, in_buf.buffer.length);
-	print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
-			in_buf.buffer.pointer,
-			min_t(u32, 256, in_buf.buffer.length), true);
+	if (payload_dumpable(nfit_mem->family, func))
+		print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
+				in_buf.buffer.pointer,
+				min_t(u32, 256, in_buf.buffer.length), true);
 
 	/* call the BIOS, prefer the named methods over _DSM if available */
 	if (nvdimm && cmd == ND_CMD_GET_CONFIG_SIZE
@@ -3337,7 +3356,7 @@ static int acpi_nfit_flush_probe(struct nvdimm_bus_descriptor *nd_desc)
 	return 0;
 }
 
-static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
+static int __acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd)
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
@@ -3359,6 +3378,23 @@ static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
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
 int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc,
 		enum nfit_ars_state req_type)
 {
diff --git a/drivers/acpi/nfit/intel.h b/drivers/acpi/nfit/intel.h
index 86746312381f..1802bd398c23 100644
--- a/drivers/acpi/nfit/intel.h
+++ b/drivers/acpi/nfit/intel.h
@@ -35,4 +35,78 @@ struct nd_intel_smart {
 	};
 } __packed;
 
+#define ND_INTEL_STATUS_SIZE		4
+#define ND_INTEL_PASSPHRASE_SIZE	32
+
+#define ND_INTEL_STATUS_NOT_SUPPORTED	1
+#define ND_INTEL_STATUS_RETRY		5
+#define ND_INTEL_STATUS_NOT_READY	9
+#define ND_INTEL_STATUS_INVALID_STATE	10
+#define ND_INTEL_STATUS_INVALID_PASS	11
+#define ND_INTEL_STATUS_OVERWRITE_UNSUPPORTED	0x10007
+#define ND_INTEL_STATUS_OQUERY_INPROGRESS	0x10007
+#define ND_INTEL_STATUS_OQUERY_SEQUENCE_ERR	0x20007
+
+#define ND_INTEL_SEC_STATE_ENABLED	0x02
+#define ND_INTEL_SEC_STATE_LOCKED	0x04
+#define ND_INTEL_SEC_STATE_FROZEN	0x08
+#define ND_INTEL_SEC_STATE_PLIMIT	0x10
+#define ND_INTEL_SEC_STATE_UNSUPPORTED	0x20
+#define ND_INTEL_SEC_STATE_OVERWRITE	0x40
+
+#define ND_INTEL_SEC_ESTATE_ENABLED	0x01
+#define ND_INTEL_SEC_ESTATE_PLIMIT	0x02
+
+struct nd_intel_get_security_state {
+	u32 status;
+	u8 extended_state;
+	u8 reserved[3];
+	u8 state;
+	u8 reserved1[3];
+} __packed;
+
+struct nd_intel_set_passphrase {
+	u8 old_pass[ND_INTEL_PASSPHRASE_SIZE];
+	u8 new_pass[ND_INTEL_PASSPHRASE_SIZE];
+	u32 status;
+} __packed;
+
+struct nd_intel_unlock_unit {
+	u8 passphrase[ND_INTEL_PASSPHRASE_SIZE];
+	u32 status;
+} __packed;
+
+struct nd_intel_disable_passphrase {
+	u8 passphrase[ND_INTEL_PASSPHRASE_SIZE];
+	u32 status;
+} __packed;
+
+struct nd_intel_freeze_lock {
+	u32 status;
+} __packed;
+
+struct nd_intel_secure_erase {
+	u8 passphrase[ND_INTEL_PASSPHRASE_SIZE];
+	u32 status;
+} __packed;
+
+struct nd_intel_overwrite {
+	u8 passphrase[ND_INTEL_PASSPHRASE_SIZE];
+	u32 status;
+} __packed;
+
+struct nd_intel_query_overwrite {
+	u32 status;
+} __packed;
+
+struct nd_intel_set_master_passphrase {
+	u8 old_pass[ND_INTEL_PASSPHRASE_SIZE];
+	u8 new_pass[ND_INTEL_PASSPHRASE_SIZE];
+	u32 status;
+} __packed;
+
+struct nd_intel_master_secure_erase {
+	u8 passphrase[ND_INTEL_PASSPHRASE_SIZE];
+	u32 status;
+} __packed;
 #endif
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index df0f6b8407e7..ecde13a9199d 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -60,14 +60,33 @@ enum nvdimm_family_cmds {
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
+	NVDIMM_INTEL_SET_MASTER_PASSPHRASE = 27,
+	NVDIMM_INTEL_MASTER_SECURE_ERASE = 28,
 };
 
+#define NVDIMM_INTEL_SECURITY_CMDMASK \
+(1 << NVDIMM_INTEL_GET_SECURITY_STATE | 1 << NVDIMM_INTEL_SET_PASSPHRASE \
+| 1 << NVDIMM_INTEL_DISABLE_PASSPHRASE | 1 << NVDIMM_INTEL_UNLOCK_UNIT \
+| 1 << NVDIMM_INTEL_FREEZE_LOCK | 1 << NVDIMM_INTEL_SECURE_ERASE \
+| 1 << NVDIMM_INTEL_OVERWRITE | 1 << NVDIMM_INTEL_QUERY_OVERWRITE \
+| 1 << NVDIMM_INTEL_SET_MASTER_PASSPHRASE \
+| 1 << NVDIMM_INTEL_MASTER_SECURE_ERASE)
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
index f1fb39921236..9743d8083538 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -902,7 +902,7 @@ static int nd_cmd_clear_to_send(struct nvdimm_bus *nvdimm_bus,
 
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
