Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7BE42209603EF
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 16:39:50 -0700 (PDT)
Subject: [PATCH 04/11] nfit/libnvdimm: add unlock of nvdimm support for
 Intel DIMMs
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 02 Jul 2018 16:39:29 -0700
Message-ID: <153057476931.38125.15448927598576316449.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
References: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
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

Adding support to allow query the security status of the Intel nvdimms and
also unlock the dimm via the kernel key management APIs. The passphrase is
expected to be pulled from userspace through keyutils. Moving the Intel
related bits to its own source file as well.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/Makefile |    2 -
 drivers/acpi/nfit/core.c   |    3 +
 drivers/acpi/nfit/intel.c  |  142 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/intel.h  |    2 +
 drivers/nvdimm/dimm.c      |    7 ++
 drivers/nvdimm/dimm_devs.c |  110 ++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h   |    3 +
 drivers/nvdimm/nd.h        |    2 +
 include/linux/libnvdimm.h  |   22 ++++++-
 9 files changed, 287 insertions(+), 6 deletions(-)
 create mode 100644 drivers/acpi/nfit/intel.c

diff --git a/drivers/acpi/nfit/Makefile b/drivers/acpi/nfit/Makefile
index a407e769f103..8287005f9226 100644
--- a/drivers/acpi/nfit/Makefile
+++ b/drivers/acpi/nfit/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_ACPI_NFIT) := nfit.o
-nfit-y := core.o
+nfit-y := core.o intel.o
 nfit-$(CONFIG_X86_MCE) += mce.o
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index a6fb336da79d..638bb7fbe565 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1907,7 +1907,8 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
 				acpi_nfit_dimm_attribute_groups,
 				flags, cmd_mask, flush ? flush->hint_count : 0,
-				nfit_mem->flush_wpq, dimm_id);
+				nfit_mem->flush_wpq, dimm_id,
+				&intel_security_ops);
 		if (!nvdimm)
 			return -ENOMEM;
 
diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
new file mode 100644
index 000000000000..1bdb493694e0
--- /dev/null
+++ b/drivers/acpi/nfit/intel.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
+/*
+ * Intel specific NFIT ops
+ */
+#include <linux/libnvdimm.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/ndctl.h>
+#include <linux/sysfs.h>
+#include <linux/delay.h>
+#include <linux/acpi.h>
+#include <linux/io.h>
+#include <linux/nd.h>
+#include <asm/cacheflush.h>
+#include <acpi/nfit.h>
+#include "nfit.h"
+
+static int intel_dimm_security_unlock(struct nvdimm_bus *nvdimm_bus,
+		struct nvdimm *nvdimm, const char *passphrase)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	int cmd_rc, rc = 0, pkg_size;
+	struct nd_intel_unlock_unit *cmd;
+	struct nd_cmd_pkg *pkg;
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+
+	if (!test_bit(NVDIMM_INTEL_UNLOCK_UNIT, &nfit_mem->dsm_mask))
+		return -ENOTTY;
+
+	pkg_size = sizeof(*pkg) + sizeof(*cmd);
+	pkg = kzalloc(pkg_size, GFP_KERNEL);
+	if (!pkg)
+		return -ENOMEM;
+
+	pkg->nd_command = NVDIMM_INTEL_UNLOCK_UNIT;
+	pkg->nd_family = NVDIMM_FAMILY_INTEL;
+	pkg->nd_size_in = ND_INTEL_PASSPHRASE_SIZE;
+	pkg->nd_size_out = ND_INTEL_STATUS_SIZE;
+	pkg->nd_fw_size = ND_INTEL_STATUS_SIZE;
+	cmd = (struct nd_intel_unlock_unit *)&pkg->nd_payload;
+	memcpy(cmd->passphrase, passphrase, ND_INTEL_PASSPHRASE_SIZE);
+	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, pkg,
+			sizeof(pkg_size), &cmd_rc);
+	if (rc < 0)
+		goto out;
+	if (cmd_rc < 0) {
+		rc = cmd_rc;
+		goto out;
+	}
+
+	switch (cmd->status) {
+	case 0:
+		break;
+	case ND_INTEL_STATUS_INVALID_PASS:
+		rc = -EINVAL;
+		goto out;
+	case ND_INTEL_STATUS_INVALID_STATE:
+	default:
+		rc = -ENXIO;
+		goto out;
+	}
+
+	/* DIMM unlocked, invalidate all CPU caches before we read it */
+	wbinvd();
+
+ out:
+	kfree(pkg);
+	return rc;
+}
+
+static int intel_dimm_security_state(struct nvdimm_bus *nvdimm_bus,
+		struct nvdimm *nvdimm, enum nvdimm_security_state *state)
+{
+	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
+	int cmd_rc, rc = 0, pkg_size;
+	struct nd_intel_get_security_state *cmd;
+	struct nd_cmd_pkg *pkg;
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+
+	if (!test_bit(NVDIMM_INTEL_GET_SECURITY_STATE, &nfit_mem->dsm_mask)) {
+		*state = NVDIMM_SECURITY_UNSUPPORTED;
+		return 0;
+	}
+
+	pkg_size = sizeof(*pkg) + sizeof(*cmd);
+	pkg = kzalloc(pkg_size, GFP_KERNEL);
+	if (!pkg)
+		return -ENOMEM;
+
+	*state = NVDIMM_SECURITY_DISABLED;
+
+	pkg->nd_command = NVDIMM_INTEL_GET_SECURITY_STATE;
+	pkg->nd_family = NVDIMM_FAMILY_INTEL;
+	pkg->nd_size_in = 0;
+	pkg->nd_size_out = sizeof(*cmd);
+	pkg->nd_fw_size = pkg->nd_size_out;
+	cmd = (struct nd_intel_get_security_state *)&pkg->nd_payload;
+
+	rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, pkg, pkg_size,
+			&cmd_rc);
+	if (rc < 0)
+		goto out;
+	if (cmd_rc < 0) {
+		rc = cmd_rc;
+		goto out;
+	}
+
+	switch (cmd->status) {
+	case 0:
+		break;
+	case ND_INTEL_STATUS_RETRY:
+		rc = -EAGAIN;
+		goto out;
+	case ND_INTEL_STATUS_NOT_READY:
+	default:
+		rc = -ENXIO;
+		goto out;
+	}
+
+	/* check and see if security is enabled and locked */
+	if (cmd->state & ND_INTEL_SEC_STATE_UNSUPPORTED)
+		*state = NVDIMM_SECURITY_UNSUPPORTED;
+	else if (cmd->state & ND_INTEL_SEC_STATE_ENABLED) {
+		if (cmd->state & ND_INTEL_SEC_STATE_LOCKED)
+			*state = NVDIMM_SECURITY_LOCKED;
+		else
+			*state = NVDIMM_SECURITY_UNLOCKED;
+	} else
+		*state = NVDIMM_SECURITY_DISABLED;
+
+ out:
+	kfree(pkg);
+	if (rc < 0)
+		*state = NVDIMM_SECURITY_INVALID;
+	return rc;
+}
+
+struct nvdimm_security_ops intel_security_ops = {
+	.state = intel_dimm_security_state,
+	.unlock = intel_dimm_security_unlock,
+};
diff --git a/drivers/acpi/nfit/intel.h b/drivers/acpi/nfit/intel.h
index a351f451b42a..774ceb65b1b8 100644
--- a/drivers/acpi/nfit/intel.h
+++ b/drivers/acpi/nfit/intel.h
@@ -6,6 +6,8 @@
 #ifndef _NFIT_INTEL_H_
 #define _NFIT_INTEL_H_
 
+extern struct nvdimm_security_ops intel_security_ops;
+
 /*
  * Command numbers that the kernel needs to know about to handle
  * non-default DSM revision ids
diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index ee0c68efa82a..a572e6fbd229 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -88,6 +88,13 @@ static int nvdimm_probe(struct device *dev)
 	get_device(dev);
 	kref_init(&ndd->kref);
 
+	nvdimm_security_get_state(dev);
+
+	/* unlock DIMM here before touch label */
+	rc = nvdimm_security_unlock_dimm(dev);
+	if (rc < 0)
+		dev_warn(dev, "failed to unlock dimm %s\n", dev_name(dev));
+
 	/*
 	 * EACCES failures reading the namespace label-area-properties
 	 * are interpreted as the DIMM capacity being locked but the
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 0ab06fd87992..f92bbe78e0df 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -18,6 +18,8 @@
 #include <linux/io.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/cred.h>
+#include <linux/key-type.h>
 #include "nd-core.h"
 #include "label.h"
 #include "pmem.h"
@@ -25,6 +27,110 @@
 
 static DEFINE_IDA(dimm_ida);
 
+/*
+ * Find key in kernel keyring
+ */
+static struct key *nvdimm_search_key(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	char *desc;
+	key_ref_t keyref;
+	struct key *key = NULL;
+
+	if (!nvdimm->security_ops)
+		return NULL;
+
+	desc = kzalloc(NVDIMM_DEFAULT_DESC_LEN, GFP_KERNEL);
+	if (!desc)
+		return NULL;
+
+	keyref = keyring_search(make_key_ref(nvdimm_cred->thread_keyring, 1),
+			&nvdimm_key_type, nvdimm->dimm_id);
+	if (IS_ERR(keyref))
+		key = NULL;
+	else
+		key = key_ref_to_ptr(keyref);
+
+	kfree(desc);
+	return key;
+}
+
+/*
+ * Retrieve kernel key for DIMM and request from user space if necessary.
+ */
+static struct key *nvdimm_request_key(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct key *key = NULL;
+
+	if (!nvdimm->security_ops)
+		return NULL;
+
+	key = request_key(&nvdimm_key_type, nvdimm->dimm_id, nvdimm->dimm_id);
+	if (IS_ERR(key))
+		key = NULL;
+
+	return key;
+}
+
+int nvdimm_security_get_state(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+
+	if (!nvdimm->security_ops)
+		return 0;
+
+	return nvdimm->security_ops->state(nvdimm_bus, nvdimm,
+			&nvdimm->state);
+}
+
+int nvdimm_security_unlock_dimm(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct key *key;
+	int rc;
+	char *payload;
+	bool cached_key = false;
+
+	if (!nvdimm->security_ops)
+		return 0;
+
+	if (nvdimm->state == NVDIMM_SECURITY_UNLOCKED ||
+			nvdimm->state == NVDIMM_SECURITY_UNSUPPORTED ||
+			nvdimm->state == NVDIMM_SECURITY_DISABLED)
+		return 0;
+
+	key = nvdimm_search_key(dev);
+	if (!key)
+		key = nvdimm_request_key(dev);
+	else
+		cached_key = true;
+	if (!key)
+		return -ENXIO;
+
+	dev_dbg(dev, "%s: key: %#x\n", __func__, key->serial);
+	down_read(&key->sem);
+	payload = key->payload.data[0];
+	rc = nvdimm->security_ops->unlock(nvdimm_bus, nvdimm, payload);
+	up_read(&key->sem);
+
+	if (rc == 0) {
+		if (!cached_key)
+			key_link(nvdimm_cred->thread_keyring, key);
+		nvdimm->state = NVDIMM_SECURITY_UNLOCKED;
+		dev_info(dev, "DIMM %s unlocked\n", dev_name(dev));
+	} else {
+		key_invalidate(key);
+		dev_warn(dev, "Failed to unlock dimm: %s\n", dev_name(dev));
+	}
+
+	key_put(key);
+	nvdimm_security_get_state(dev);
+	return rc;
+}
+
 /*
  * Retrieve bus and dimm handle and return if this bus supports
  * get_config_data commands
@@ -398,7 +504,8 @@ EXPORT_SYMBOL_GPL(nvdimm_attribute_group);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
 		unsigned long cmd_mask, int num_flush,
-		struct resource *flush_wpq, const char *id)
+		struct resource *flush_wpq, const char *id,
+		struct nvdimm_security_ops *sec_ops)
 {
 	struct nvdimm *nvdimm = kzalloc(sizeof(*nvdimm), GFP_KERNEL);
 	struct device *dev;
@@ -413,6 +520,7 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 	}
 
 	memcpy(nvdimm->dimm_id, id, NVDIMM_DEFAULT_DESC_LEN);
+	nvdimm->security_ops = sec_ops;
 	nvdimm->provider_data = provider_data;
 	nvdimm->flags = flags;
 	nvdimm->cmd_mask = cmd_mask;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 0e9c4fd1234f..6f1ce86f8e93 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -22,6 +22,7 @@
 extern struct list_head nvdimm_bus_list;
 extern struct mutex nvdimm_bus_list_mutex;
 extern int nvdimm_major;
+extern const struct cred *nvdimm_cred;
 
 struct nvdimm_bus {
 	struct nvdimm_bus_descriptor *nd_desc;
@@ -43,6 +44,8 @@ struct nvdimm {
 	int id, num_flush;
 	struct resource *flush_wpq;
 	char dimm_id[NVDIMM_DEFAULT_DESC_LEN];
+	struct nvdimm_security_ops *security_ops;
+	enum nvdimm_security_state state;
 };
 
 /**
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 9d17abd9f8d0..9c80e0f8c327 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -424,4 +424,6 @@ static inline bool is_bad_pmem(struct badblocks *bb, sector_t sector,
 resource_size_t nd_namespace_blk_validate(struct nd_namespace_blk *nsblk);
 const u8 *nd_dev_to_uuid(struct device *dev);
 bool pmem_should_map_pages(struct device *dev);
+int nvdimm_security_unlock_dimm(struct device *dev);
+int nvdimm_security_get_state(struct device *dev);
 #endif /* __ND_H__ */
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 74c6fb315bf0..be98afb5f27e 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -157,8 +157,23 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
 
 extern struct key_type nvdimm_key_type;
 
-#define NVDIMM_DEFAULT_PASSPHRASE_LEN		32
-#define NVDIMM_DEFAULT_DESC_LEN			32
+enum nvdimm_security_state {
+	NVDIMM_SECURITY_INVALID = 0,
+	NVDIMM_SECURITY_DISABLED,
+	NVDIMM_SECURITY_UNLOCKED,
+	NVDIMM_SECURITY_LOCKED,
+	NVDIMM_SECURITY_UNSUPPORTED,
+};
+
+#define NVDIMM_DEFAULT_PASSPHRASE_LEN	32
+#define NVDIMM_DEFAULT_DESC_LEN		32
+struct nvdimm_security_ops {
+	int (*state)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm,
+			enum nvdimm_security_state *state);
+	int (*unlock)(struct nvdimm_bus *nvdimm_bus,
+			struct nvdimm *nvdimm, const char *passphrase);
+};
 
 void badrange_init(struct badrange *badrange);
 int badrange_add(struct badrange *badrange, u64 addr, u64 length);
@@ -183,7 +198,8 @@ void *nvdimm_provider_data(struct nvdimm *nvdimm);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
 		unsigned long cmd_mask, int num_flush,
-		struct resource *flush_wpq, const char *dimm_id);
+		struct resource *flush_wpq, const char *dimm_id,
+		struct nvdimm_security_ops *sec_ops);
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
 u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
