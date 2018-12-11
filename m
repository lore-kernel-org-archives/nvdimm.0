Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 04E242119A878
 for <linux-nvdimm@lists.01.org>; Tue, 11 Dec 2018 12:25:45 -0800 (PST)
Subject: [PATCH v13 05/17] acpi/nfit, libnvdimm: Introduce nvdimm_security_ops
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 11 Dec 2018 13:25:44 -0700
Message-ID: <154455994428.26509.2839527031690514135.stgit@djiang5-desk3.ch.intel.com>
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

Some NVDIMMs, like the ones defined by the NVDIMM_FAMILY_INTEL command
set, expose a security capability to lock the DIMMs at poweroff and
require a passphrase to unlock them. The security model is derived from
ATA security. In anticipation of other DIMMs implementing a similar
scheme, and to abstract the core security implementation away from the
device-specific details, introduce nvdimm_security_ops.

Initially only a status retrieval operation, ->state(), is defined,
along with the base infrastructure and definitions for future
operations.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Co-developed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/Makefile  |    1 +
 drivers/acpi/nfit/core.c    |   13 ++++++++++
 drivers/acpi/nfit/intel.c   |   54 +++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/intel.h   |    2 ++
 drivers/nvdimm/bus.c        |    6 +++++
 drivers/nvdimm/dimm_devs.c  |   45 +++++++++++++++++++++++++++++++++++-
 drivers/nvdimm/nd-core.h    |   13 ++++++++++
 include/linux/libnvdimm.h   |   27 ++++++++++++++++++++--
 tools/testing/nvdimm/Kbuild |    1 +
 9 files changed, 158 insertions(+), 4 deletions(-)
 create mode 100644 drivers/acpi/nfit/intel.c

diff --git a/drivers/acpi/nfit/Makefile b/drivers/acpi/nfit/Makefile
index a407e769f103..751081c47886 100644
--- a/drivers/acpi/nfit/Makefile
+++ b/drivers/acpi/nfit/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_ACPI_NFIT) := nfit.o
 nfit-y := core.o
+nfit-y += intel.o
 nfit-$(CONFIG_X86_MCE) += mce.o
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index c74f087398fb..77f188cd8023 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1928,6 +1928,16 @@ static void shutdown_dimm_notify(void *data)
 	mutex_unlock(&acpi_desc->init_mutex);
 }
 
+static const struct nvdimm_security_ops *acpi_nfit_get_security_ops(int family)
+{
+	switch (family) {
+	case NVDIMM_FAMILY_INTEL:
+		return intel_security_ops;
+	default:
+		return NULL;
+	}
+}
+
 static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nfit_mem *nfit_mem;
@@ -1997,7 +2007,8 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		nvdimm = __nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
 				acpi_nfit_dimm_attribute_groups,
 				flags, cmd_mask, flush ? flush->hint_count : 0,
-				nfit_mem->flush_wpq, &nfit_mem->id[0]);
+				nfit_mem->flush_wpq, &nfit_mem->id[0],
+				acpi_nfit_get_security_ops(nfit_mem->family));
 		if (!nvdimm)
 			return -ENOMEM;
 
diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
new file mode 100644
index 000000000000..fd7a8f6d2c20
--- /dev/null
+++ b/drivers/acpi/nfit/intel.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
+#include <linux/libnvdimm.h>
+#include <linux/ndctl.h>
+#include <linux/acpi.h>
+#include "intel.h"
+#include "nfit.h"
+
+static enum nvdimm_security_state intel_security_state(struct nvdimm *nvdimm)
+{
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct {
+		struct nd_cmd_pkg pkg;
+		struct nd_intel_get_security_state cmd;
+	} nd_cmd = {
+		.pkg = {
+			.nd_command = NVDIMM_INTEL_GET_SECURITY_STATE,
+			.nd_family = NVDIMM_FAMILY_INTEL,
+			.nd_size_out =
+				sizeof(struct nd_intel_get_security_state),
+			.nd_fw_size =
+				sizeof(struct nd_intel_get_security_state),
+		},
+	};
+	int rc;
+
+	if (!test_bit(NVDIMM_INTEL_GET_SECURITY_STATE, &nfit_mem->dsm_mask))
+		return -ENXIO;
+
+	rc = nvdimm_ctl(nvdimm, ND_CMD_CALL, &nd_cmd, sizeof(nd_cmd), NULL);
+	if (rc < 0)
+		return rc;
+	if (nd_cmd.cmd.status)
+		return -EIO;
+
+	/* check and see if security is enabled and locked */
+	if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_UNSUPPORTED)
+		return -ENXIO;
+	else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_ENABLED) {
+		if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_LOCKED)
+			return NVDIMM_SECURITY_LOCKED;
+		else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_FROZEN ||
+				nd_cmd.cmd.state & ND_INTEL_SEC_STATE_PLIMIT)
+			return NVDIMM_SECURITY_FROZEN;
+		else
+			return NVDIMM_SECURITY_UNLOCKED;
+	}
+	return NVDIMM_SECURITY_DISABLED;
+}
+
+static const struct nvdimm_security_ops __intel_security_ops = {
+	.state = intel_security_state,
+};
+const struct nvdimm_security_ops *intel_security_ops = &__intel_security_ops;
diff --git a/drivers/acpi/nfit/intel.h b/drivers/acpi/nfit/intel.h
index 1802bd398c23..0aca682ab9d7 100644
--- a/drivers/acpi/nfit/intel.h
+++ b/drivers/acpi/nfit/intel.h
@@ -35,6 +35,8 @@ struct nd_intel_smart {
 	};
 } __packed;
 
+extern const struct nvdimm_security_ops *intel_security_ops;
+
 #define ND_INTEL_STATUS_SIZE		4
 #define ND_INTEL_PASSPHRASE_SIZE	32
 
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 9743d8083538..eae17d8ee539 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -331,6 +331,12 @@ struct nvdimm_bus *to_nvdimm_bus(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(to_nvdimm_bus);
 
+struct nvdimm_bus *nvdimm_to_bus(struct nvdimm *nvdimm)
+{
+	return to_nvdimm_bus(nvdimm->dev.parent);
+}
+EXPORT_SYMBOL_GPL(nvdimm_to_bus);
+
 struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nd_desc)
 {
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 508dd405f84f..9609b671311b 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -370,23 +370,60 @@ static ssize_t available_slots_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(available_slots);
 
+static ssize_t security_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	switch (nvdimm->sec.state) {
+	case NVDIMM_SECURITY_DISABLED:
+		return sprintf(buf, "disabled\n");
+	case NVDIMM_SECURITY_UNLOCKED:
+		return sprintf(buf, "unlocked\n");
+	case NVDIMM_SECURITY_LOCKED:
+		return sprintf(buf, "locked\n");
+	case NVDIMM_SECURITY_FROZEN:
+		return sprintf(buf, "frozen\n");
+	case NVDIMM_SECURITY_OVERWRITE:
+		return sprintf(buf, "overwrite\n");
+	}
+
+	return -ENOTTY;
+}
+static DEVICE_ATTR_RO(security);
+
 static struct attribute *nvdimm_attributes[] = {
 	&dev_attr_state.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_commands.attr,
 	&dev_attr_available_slots.attr,
+	&dev_attr_security.attr,
 	NULL,
 };
 
+static umode_t nvdimm_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, typeof(*dev), kobj);
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	if (a != &dev_attr_security.attr)
+		return a->mode;
+	if (nvdimm->sec.state < 0)
+		return 0;
+	return a->mode;
+}
+
 struct attribute_group nvdimm_attribute_group = {
 	.attrs = nvdimm_attributes,
+	.is_visible = nvdimm_visible,
 };
 EXPORT_SYMBOL_GPL(nvdimm_attribute_group);
 
 struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 		void *provider_data, const struct attribute_group **groups,
 		unsigned long flags, unsigned long cmd_mask, int num_flush,
-		struct resource *flush_wpq, const char *dimm_id)
+		struct resource *flush_wpq, const char *dimm_id,
+		const struct nvdimm_security_ops *sec_ops)
 {
 	struct nvdimm *nvdimm = kzalloc(sizeof(*nvdimm), GFP_KERNEL);
 	struct device *dev;
@@ -413,6 +450,12 @@ struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 	dev->type = &nvdimm_device_type;
 	dev->devt = MKDEV(nvdimm_major, nvdimm->id);
 	dev->groups = groups;
+	nvdimm->sec.ops = sec_ops;
+	/*
+	 * Security state must be initialized before device_add() for
+	 * attribute visibility.
+	 */
+	nvdimm->sec.state = nvdimm_security_state(nvdimm);
 	nd_device_register(dev);
 
 	return nvdimm;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index ff26876e6ea3..1919f5c0d581 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -42,8 +42,21 @@ struct nvdimm {
 	int id, num_flush;
 	struct resource *flush_wpq;
 	const char *dimm_id;
+	struct {
+		const struct nvdimm_security_ops *ops;
+		enum nvdimm_security_state state;
+	} sec;
 };
 
+static inline enum nvdimm_security_state nvdimm_security_state(
+		struct nvdimm *nvdimm)
+{
+	if (!nvdimm->sec.ops)
+		return -ENXIO;
+
+	return nvdimm->sec.ops->state(nvdimm);
+}
+
 /**
  * struct blk_alloc_info - tracking info for BLK dpa scanning
  * @nd_mapping: blk region mapping boundaries
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index f980046b9588..f4d63f49f7dd 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -155,6 +155,18 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
 
 }
 
+enum nvdimm_security_state {
+	NVDIMM_SECURITY_DISABLED,
+	NVDIMM_SECURITY_UNLOCKED,
+	NVDIMM_SECURITY_LOCKED,
+	NVDIMM_SECURITY_FROZEN,
+	NVDIMM_SECURITY_OVERWRITE,
+};
+
+struct nvdimm_security_ops {
+	enum nvdimm_security_state (*state)(struct nvdimm *nvdimm);
+};
+
 void badrange_init(struct badrange *badrange);
 int badrange_add(struct badrange *badrange, u64 addr, u64 length);
 void badrange_forget(struct badrange *badrange, phys_addr_t start,
@@ -165,6 +177,7 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nfit_desc);
 void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus);
 struct nvdimm_bus *to_nvdimm_bus(struct device *dev);
+struct nvdimm_bus *nvdimm_to_bus(struct nvdimm *nvdimm);
 struct nvdimm *to_nvdimm(struct device *dev);
 struct nd_region *to_nd_region(struct device *dev);
 struct device *nd_region_dev(struct nd_region *nd_region);
@@ -178,14 +191,15 @@ void *nvdimm_provider_data(struct nvdimm *nvdimm);
 struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 		void *provider_data, const struct attribute_group **groups,
 		unsigned long flags, unsigned long cmd_mask, int num_flush,
-		struct resource *flush_wpq, const char *dimm_id);
+		struct resource *flush_wpq, const char *dimm_id,
+		const struct nvdimm_security_ops *sec_ops);
 static inline struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus,
 		void *provider_data, const struct attribute_group **groups,
 		unsigned long flags, unsigned long cmd_mask, int num_flush,
 		struct resource *flush_wpq)
 {
 	return __nvdimm_create(nvdimm_bus, provider_data, groups, flags,
-			cmd_mask, num_flush, flush_wpq, NULL);
+			cmd_mask, num_flush, flush_wpq, NULL, NULL);
 }
 
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
@@ -214,6 +228,15 @@ void nvdimm_flush(struct nd_region *nd_region);
 int nvdimm_has_flush(struct nd_region *nd_region);
 int nvdimm_has_cache(struct nd_region *nd_region);
 
+static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
+		unsigned int buf_len, int *cmd_rc)
+{
+	struct nvdimm_bus *nvdimm_bus = nvdimm_to_bus(nvdimm);
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+
+	return nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len, cmd_rc);
+}
+
 #ifdef CONFIG_ARCH_HAS_PMEM_API
 #define ARCH_MEMREMAP_PMEM MEMREMAP_WB
 void arch_wb_cache_pmem(void *addr, size_t size);
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 778ceb651000..4a2f3cff2a75 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -37,6 +37,7 @@ obj-$(CONFIG_DEV_DAX) += device_dax.o
 obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
 
 nfit-y := $(ACPI_SRC)/core.o
+nfit-y += $(ACPI_SRC)/intel.o
 nfit-$(CONFIG_X86_MCE) += $(ACPI_SRC)/mce.o
 nfit-y += acpi_nfit_test.o
 nfit-y += config_check.o

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
