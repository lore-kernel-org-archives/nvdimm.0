Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 06/20] libnd: ndctl.h, the nd ioctl abi
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Apr 2015 14:24:44 -0400
Message-ID: <20150428182444.35812.1805.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Most configuration of the nd-subsystem is done via nd-sysfs attributes.
However, some nd buses, particularly the ACPI.NFIT bus, define a small
set of messages that can be passed to the platform.  For convenience we
derivce the initial nd-ioctl-command formats directly from the NFIT DSM
formats.

    ND_CMD_SMART: media health and diagnostics
    ND_CMD_GET_CONFIG_SIZE: size of the label space
    ND_CMD_GET_CONFIG_DATA: read label space
    ND_CMD_SET_CONFIG_DATA: write label space
    ND_CMD_VENDOR: vendor-specific command passthrough
    ND_CMD_ARS_CAP: report address-range-scrubbing capabilities
    ND_CMD_START_ARS: initiate scrubbing
    ND_CMD_QUERY_ARS: report on scrubbing state
    ND_CMD_SMART_THRESHOLD: configure alarm thresholds for smart events

If a platform later defines different commands than this set it is
straightforward to extend support to those formats.

Most of the commands target a specific dimm.  However, the
address-range-scrubbing commands target the bus.  The 'commands'
attribute in sysfs of an nd-bus, or an nd-dimm enumerate the supported
commands for that object.

Cc: <linux-acpi@vger.kernel.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-by: Nicholas Moulin <nicholas.w.moulin@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/Kconfig      |   12 ++
 drivers/block/nd/acpi.c       |  237 ++++++++++++++++++++++++++++++
 drivers/block/nd/acpi_nfit.h  |    3 
 drivers/block/nd/bus.c        |  324 ++++++++++++++++++++++++++++++++++++++++-
 drivers/block/nd/core.c       |   16 ++
 drivers/block/nd/dimm_devs.c  |   38 ++++-
 drivers/block/nd/libnd.h      |   25 +++
 drivers/block/nd/nd-private.h |    3 
 drivers/block/nd/test/nfit.c  |   78 ++++++++++
 include/uapi/linux/Kbuild     |    1 
 include/uapi/linux/ndctl.h    |  178 +++++++++++++++++++++++
 11 files changed, 903 insertions(+), 12 deletions(-)
 create mode 100644 include/uapi/linux/ndctl.h

diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
index 09f0135147ca..d2d84451e82c 100644
--- a/drivers/block/nd/Kconfig
+++ b/drivers/block/nd/Kconfig
@@ -37,6 +37,18 @@ config ND_ACPI
 	  addition to storage devices this also enables libnd craft
 	  ACPI._DSM messages for platform/dimm configuration.
 
+config ND_ACPI_DEBUG
+	bool "ACPI: Extra nd_acpi debugging"
+	depends on ND_ACPI
+	depends on DYNAMIC_DEBUG
+	default n
+	help
+	  Enabling this option causes the nd_acpi driver to dump the
+	  input and output buffers of _DSM operations on the ACPI0012
+	  device and its children.  This can be very verbose, so leave
+	  it disabled unless you are debugging a hardware / firmware
+	  issue.
+
 config NFIT_TEST
 	tristate "NFIT TEST: Manufactured NFIT for interface testing"
 	depends on DMA_CMA
diff --git a/drivers/block/nd/acpi.c b/drivers/block/nd/acpi.c
index af6684341c9b..c46e166695f7 100644
--- a/drivers/block/nd/acpi.c
+++ b/drivers/block/nd/acpi.c
@@ -12,6 +12,7 @@
  */
 #include <linux/list_sort.h>
 #include <linux/module.h>
+#include <linux/ndctl.h>
 #include <linux/list.h>
 #include <linux/acpi.h>
 #include "acpi_nfit.h"
@@ -25,11 +26,160 @@ enum {
 	NFIT_ACPI_NOTIFY_TABLE = 0x80,
 };
 
+static u8 nd_acpi_uuids[2][16]; /* initialized at nd_acpi_init */
+
+static u8 *nd_acpi_bus_uuid(void)
+{
+	return nd_acpi_uuids[0];
+}
+
+static u8 *nd_acpi_dimm_uuid(void)
+{
+	return nd_acpi_uuids[1];
+}
+
+static struct acpi_nfit_desc *to_acpi_nfit_desc(struct nd_bus_descriptor *nd_desc)
+{
+	return container_of(nd_desc, struct acpi_nfit_desc, nd_desc);
+}
+
+static struct acpi_device *to_acpi_dev(struct acpi_nfit_desc *acpi_desc)
+{
+	struct nd_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
+
+	/*
+	 * If provider == 'ACPI.NFIT' we can assume 'dev' is a struct
+	 * acpi_device.
+	 */
+	if (!nd_desc->provider_name
+			|| strcmp(nd_desc->provider_name, "ACPI.NFIT") != 0)
+		return NULL;
+
+	return to_acpi_device(acpi_desc->dev);
+}
+
 static int nd_acpi_ctl(struct nd_bus_descriptor *nd_desc,
 		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
 		unsigned int buf_len)
 {
-	return -ENOTTY;
+	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
+	const struct nd_cmd_desc const *desc = NULL;
+	union acpi_object in_obj, in_buf, *out_obj;
+	struct device *dev = acpi_desc->dev;
+	const char *cmd_name, *dimm_name;
+	unsigned long dsm_mask;
+	acpi_handle handle;
+	u32 offset;
+	int rc, i;
+	u8 *uuid;
+
+	if (nd_dimm) {
+		struct nfit_mem *nfit_mem = nd_dimm_provider_data(nd_dimm);
+		struct acpi_device *adev = nfit_mem->adev;
+
+		if (!adev)
+			return -ENOTTY;
+		dimm_name = dev_name(&adev->dev);
+		cmd_name = nd_dimm_cmd_name(cmd);
+		dsm_mask = nfit_mem->dsm_mask;
+		desc = nd_cmd_dimm_desc(cmd);
+		uuid = nd_acpi_dimm_uuid();
+		handle = adev->handle;
+	} else {
+		struct acpi_device *adev = to_acpi_dev(acpi_desc);
+
+		cmd_name = nd_bus_cmd_name(cmd);
+		dsm_mask = nd_desc->dsm_mask;
+		desc = nd_cmd_bus_desc(cmd);
+		uuid = nd_acpi_bus_uuid();
+		handle = adev->handle;
+		dimm_name = "bus";
+	}
+
+	if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
+		return -ENOTTY;
+
+	if (!test_bit(cmd, &dsm_mask))
+		return -ENOTTY;
+
+	in_obj.type = ACPI_TYPE_PACKAGE;
+	in_obj.package.count = 1;
+	in_obj.package.elements = &in_buf;
+	in_buf.type = ACPI_TYPE_BUFFER;
+	in_buf.buffer.pointer = buf;
+	in_buf.buffer.length = 0;
+
+	/* libnd has already validated the input envelope */
+	for (i = 0; i < desc->in_num; i++)
+		in_buf.buffer.length += nd_cmd_in_size(nd_dimm, cmd, desc, i, buf);
+
+	dev_dbg(dev, "%s:%s cmd: %s input length: %d\n", __func__, dimm_name,
+			cmd_name, in_buf.buffer.length);
+	if (IS_ENABLED(CONFIG_ND_ACPI_DEBUG))
+		print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
+				4, in_buf.buffer.pointer, min_t(u32, 128,
+					in_buf.buffer.length), true);
+
+	out_obj = acpi_evaluate_dsm(handle, uuid, 1, cmd, &in_obj);
+	if (!out_obj) {
+		dev_dbg(dev, "%s:%s _DSM failed cmd: %s\n", __func__, dimm_name,
+				cmd_name);
+		return -EINVAL;
+	}
+
+	if (out_obj->package.type != ACPI_TYPE_BUFFER) {
+		dev_dbg(dev, "%s:%s unexpected output object type cmd: %s type: %d\n",
+				__func__, dimm_name, cmd_name, out_obj->type);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	dev_dbg(dev, "%s:%s cmd: %s output length: %d\n", __func__, dimm_name,
+			cmd_name, out_obj->buffer.length);
+	if (IS_ENABLED(CONFIG_ND_ACPI_DEBUG))
+		print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
+				4, out_obj->buffer.pointer, min_t(u32, 128,
+					out_obj->buffer.length), true);
+
+	for (i = 0, offset = 0; i < desc->out_num; i++) {
+		u32 out_size = nd_cmd_out_size(nd_dimm, cmd, desc, i, buf,
+				(u32 *) out_obj->buffer.pointer);
+
+		if (offset + out_size > out_obj->buffer.length) {
+			dev_dbg(dev, "%s:%s output object underflow cmd: %s field: %d\n",
+					__func__, dimm_name, cmd_name, i);
+			break;
+		}
+
+		if (in_buf.buffer.length + offset + out_size > buf_len) {
+			dev_dbg(dev, "%s:%s output overrun cmd: %s field: %d\n",
+					__func__, dimm_name, cmd_name, i);
+			rc = -ENXIO;
+			goto out;
+		}
+		memcpy(buf + in_buf.buffer.length + offset,
+				out_obj->buffer.pointer + offset, out_size);
+		offset += out_size;
+	}
+	if (offset + in_buf.buffer.length < buf_len) {
+		if (i >= 1) {
+			/*
+			 * status valid, return the number of bytes left
+			 * unfilled in the output buffer
+			 */
+			rc = buf_len - offset - in_buf.buffer.length;
+		} else {
+			dev_err(dev, "%s:%s underrun cmd: %s buf_len: %d out_len: %d\n",
+					__func__, dimm_name, cmd_name, buf_len, offset);
+			rc = -ENXIO;
+		}
+	} else
+		rc = 0;
+
+ out:
+	ACPI_FREE(out_obj);
+
+	return rc;
 }
 
 static const char *spa_type_name(u16 type)
@@ -476,6 +626,7 @@ static struct attribute_group nd_acpi_dimm_attribute_group = {
 };
 
 static const struct attribute_group *nd_acpi_dimm_attribute_groups[] = {
+	&nd_dimm_attribute_group,
 	&nd_acpi_dimm_attribute_group,
 	NULL,
 };
@@ -492,6 +643,50 @@ static struct nd_dimm *nd_acpi_dimm_by_handle(struct acpi_nfit_desc *acpi_desc,
 	return NULL;
 }
 
+static int nd_acpi_add_dimm(struct acpi_nfit_desc *acpi_desc,
+		struct nfit_mem *nfit_mem, u32 nfit_handle)
+{
+	struct acpi_device *adev, *adev_dimm;
+	struct device *dev = acpi_desc->dev;
+	u8 *uuid = nd_acpi_dimm_uuid();
+	unsigned long long sta;
+	int i, rc = -ENODEV;
+	acpi_status status;
+
+	nfit_mem->dsm_mask = acpi_desc->dimm_dsm_force_en;
+	adev = to_acpi_dev(acpi_desc);
+	if (!adev)
+		return 0;
+
+	adev_dimm = acpi_find_child_device(adev, nfit_handle, false);
+	nfit_mem->adev = adev_dimm;
+	if (!adev_dimm) {
+		dev_err(dev, "no ACPI.NFIT device with _ADR %#x, disabling...\n",
+				nfit_handle);
+		return -ENODEV;
+	}
+
+	status = acpi_evaluate_integer(adev_dimm->handle, "_STA", NULL, &sta);
+	if (status == AE_NOT_FOUND) {
+		dev_dbg(dev, "%s missing _STA, assuming enabled...\n",
+				dev_name(&adev_dimm->dev));
+		rc = 0;
+	} else if (ACPI_FAILURE(status))
+		dev_err(dev, "%s failed to retrieve_STA, disabling...\n",
+				dev_name(&adev_dimm->dev));
+	else if ((sta & ACPI_STA_DEVICE_ENABLED) == 0)
+		dev_info(dev, "%s disabled by firmware\n",
+				dev_name(&adev_dimm->dev));
+	else
+		rc = 0;
+
+	for (i = ND_CMD_SMART; i <= ND_CMD_VENDOR; i++)
+		if (acpi_check_dsm(adev_dimm->handle, uuid, 1, 1ULL << i))
+			set_bit(i, &nfit_mem->dsm_mask);
+
+	return rc;
+}
+
 static int nd_acpi_register_dimms(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nfit_mem *nfit_mem;
@@ -500,6 +695,7 @@ static int nd_acpi_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		struct nd_dimm *nd_dimm;
 		unsigned long flags = 0;
 		u32 nfit_handle;
+		int rc;
 
 		nfit_handle = __to_nfit_memdev(nfit_mem)->nfit_handle;
 		nd_dimm = nd_acpi_dimm_by_handle(acpi_desc, nfit_handle);
@@ -516,8 +712,13 @@ static int nd_acpi_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		if (nfit_mem->bdw && nfit_mem->memdev_pmem)
 			flags |= NDD_ALIASING;
 
+		rc = nd_acpi_add_dimm(acpi_desc, nfit_mem, nfit_handle);
+		if (rc)
+			continue;
+
 		nd_dimm = nd_dimm_create(acpi_desc->nd_bus, nfit_mem,
-				nd_acpi_dimm_attribute_groups, flags);
+				nd_acpi_dimm_attribute_groups,
+				flags, &nfit_mem->dsm_mask);
 		if (!nd_dimm)
 			return -ENOMEM;
 
@@ -527,6 +728,22 @@ static int nd_acpi_register_dimms(struct acpi_nfit_desc *acpi_desc)
 	return 0;
 }
 
+static void nd_acpi_init_dsms(struct acpi_nfit_desc *acpi_desc)
+{
+	struct nd_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
+	u8 *uuid = nd_acpi_bus_uuid();
+	struct acpi_device *adev;
+	int i;
+
+	adev = to_acpi_dev(acpi_desc);
+	if (!adev)
+		return;
+
+	for (i = ND_CMD_ARS_CAP; i <= ND_CMD_ARS_QUERY; i++)
+		if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
+			set_bit(i, &nd_desc->dsm_mask);
+}
+
 int nd_acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 {
 	struct device *dev = acpi_desc->dev;
@@ -564,6 +781,8 @@ int nd_acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 	if (nfit_mem_init(acpi_desc) != 0)
 		return -ENOMEM;
 
+	nd_acpi_init_dsms(acpi_desc);
+
 	return nd_acpi_register_dimms(acpi_desc);
 }
 EXPORT_SYMBOL_GPL(nd_acpi_nfit_init);
@@ -641,6 +860,14 @@ static struct acpi_driver nd_acpi_driver = {
 
 static __init int nd_acpi_init(void)
 {
+	char *uuids[] = {
+		/* bus interface */
+		"2f10e7a4-9e91-11e4-89d3-123b93f75cba",
+		/* per-dimm interface */
+		"4309ac30-0d11-11e4-9191-0800200c9a66",
+	};
+	int i;
+
 	BUILD_BUG_ON(sizeof(struct acpi_nfit) != 40);
 	BUILD_BUG_ON(sizeof(struct acpi_nfit_spa) != 56);
 	BUILD_BUG_ON(sizeof(struct acpi_nfit_memdev) != 48);
@@ -649,6 +876,12 @@ static __init int nd_acpi_init(void)
 	BUILD_BUG_ON(sizeof(struct acpi_nfit_dcr) != 80);
 	BUILD_BUG_ON(sizeof(struct acpi_nfit_bdw) != 40);
 
+	for (i = 0; i < ARRAY_SIZE(uuids); i++)
+		if (acpi_str_to_uuid(uuids[i], nd_acpi_uuids[i]) != AE_OK) {
+			WARN_ON_ONCE(1);
+			return -ENXIO;
+		}
+
 	return acpi_bus_register_driver(&nd_acpi_driver);
 }
 
diff --git a/drivers/block/nd/acpi_nfit.h b/drivers/block/nd/acpi_nfit.h
index 00aaaee5953b..2faac336c07d 100644
--- a/drivers/block/nd/acpi_nfit.h
+++ b/drivers/block/nd/acpi_nfit.h
@@ -241,6 +241,8 @@ struct nfit_mem {
 	struct acpi_nfit_spa *spa_dcr;
 	struct acpi_nfit_spa *spa_bdw;
 	struct list_head list;
+	struct acpi_device *adev;
+	unsigned long dsm_mask;
 };
 
 struct acpi_nfit_desc {
@@ -253,6 +255,7 @@ struct acpi_nfit_desc {
 	struct list_head bdws;
 	struct nd_bus *nd_bus;
 	struct device *dev;
+	unsigned long dimm_dsm_force_en;
 };
 
 static inline struct acpi_nfit_memdev *__to_nfit_memdev(struct nfit_mem *nfit_mem)
diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
index ee56aa1ab2ad..a271e01af4a9 100644
--- a/drivers/block/nd/bus.c
+++ b/drivers/block/nd/bus.c
@@ -11,14 +11,18 @@
  * General Public License for more details.
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/vmalloc.h>
 #include <linux/uaccess.h>
 #include <linux/fcntl.h>
 #include <linux/async.h>
+#include <linux/ndctl.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/io.h>
+#include <linux/mm.h>
 #include "nd-private.h"
 
+int nd_dimm_major;
 static int nd_bus_major;
 static struct class *nd_class;
 
@@ -47,19 +51,323 @@ void nd_bus_destroy_ndctl(struct nd_bus *nd_bus)
 	device_destroy(nd_class, MKDEV(nd_bus_major, nd_bus->id));
 }
 
+static const struct nd_cmd_desc const __nd_cmd_dimm_descs[] = {
+	[ND_CMD_IMPLEMENTED] = { },
+	[ND_CMD_SMART] = {
+		.out_num = 2,
+		.out_sizes = { 4, 8, },
+	},
+	[ND_CMD_SMART_THRESHOLD] = {
+		.out_num = 2,
+		.out_sizes = { 4, 8, },
+	},
+	[ND_CMD_DIMM_FLAGS] = {
+		.out_num = 2,
+		.out_sizes = { 4, 4 },
+	},
+	[ND_CMD_GET_CONFIG_SIZE] = {
+		.out_num = 3,
+		.out_sizes = { 4, 4, 4, },
+	},
+	[ND_CMD_GET_CONFIG_DATA] = {
+		.in_num = 2,
+		.in_sizes = { 4, 4, },
+		.out_num = 2,
+		.out_sizes = { 4, UINT_MAX, },
+	},
+	[ND_CMD_SET_CONFIG_DATA] = {
+		.in_num = 3,
+		.in_sizes = { 4, 4, UINT_MAX, },
+		.out_num = 1,
+		.out_sizes = { 4, },
+	},
+	[ND_CMD_VENDOR] = {
+		.in_num = 3,
+		.in_sizes = { 4, 4, UINT_MAX, },
+		.out_num = 3,
+		.out_sizes = { 4, 4, UINT_MAX, },
+	},
+};
+
+struct nd_cmd_desc const *nd_cmd_dimm_desc(int cmd)
+{
+	if (cmd < ARRAY_SIZE(__nd_cmd_dimm_descs))
+		return &__nd_cmd_dimm_descs[cmd];
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nd_cmd_dimm_desc);
+
+static const struct nd_cmd_desc const __nd_cmd_bus_descs[] = {
+	[ND_CMD_IMPLEMENTED] = { },
+	[ND_CMD_ARS_CAP] = {
+		.in_num = 2,
+		.in_sizes = { 8, 8, },
+		.out_num = 2,
+		.out_sizes = { 4, 4, },
+	},
+	[ND_CMD_ARS_START] = {
+		.in_num = 4,
+		.in_sizes = { 8, 8, 2, 6, },
+		.out_num = 1,
+		.out_sizes = { 4, },
+	},
+	[ND_CMD_ARS_QUERY] = {
+		.out_num = 2,
+		.out_sizes = { 4, UINT_MAX, },
+	},
+};
+
+const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd)
+{
+	if (cmd < ARRAY_SIZE(__nd_cmd_bus_descs))
+		return &__nd_cmd_bus_descs[cmd];
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nd_cmd_bus_desc);
+
+u32 nd_cmd_in_size(struct nd_dimm *nd_dimm, int cmd,
+		const struct nd_cmd_desc *desc, int idx, void *buf)
+{
+	if (idx >= desc->in_num)
+		return UINT_MAX;
+
+	if (desc->in_sizes[idx] < UINT_MAX)
+		return desc->in_sizes[idx];
+
+	if (nd_dimm && cmd == ND_CMD_SET_CONFIG_DATA && idx == 2) {
+		struct nd_cmd_set_config_hdr *hdr = buf;
+
+		return hdr->in_length;
+	} else if (nd_dimm && cmd == ND_CMD_VENDOR && idx == 2) {
+		struct nd_cmd_vendor_hdr *hdr = buf;
+
+		return hdr->in_length;
+	}
+
+	return UINT_MAX;
+}
+EXPORT_SYMBOL_GPL(nd_cmd_in_size);
+
+u32 nd_cmd_out_size(struct nd_dimm *nd_dimm, int cmd,
+		const struct nd_cmd_desc *desc, int idx, const u32 *in_field,
+		const u32 *out_field)
+{
+	if (idx >= desc->out_num)
+		return UINT_MAX;
+
+	if (desc->out_sizes[idx] < UINT_MAX)
+		return desc->out_sizes[idx];
+
+	if (nd_dimm && cmd == ND_CMD_GET_CONFIG_DATA && idx == 1)
+		return in_field[1];
+	else if (nd_dimm && cmd == ND_CMD_VENDOR && idx == 2)
+		return out_field[1];
+	else if (!nd_dimm && cmd == ND_CMD_ARS_QUERY && idx == 1)
+		return ND_CMD_ARS_QUERY_MAX;
+
+	return UINT_MAX;
+}
+EXPORT_SYMBOL_GPL(nd_cmd_out_size);
+
+static int __nd_ioctl(struct nd_bus *nd_bus, struct nd_dimm *nd_dimm,
+		int read_only, unsigned int ioctl_cmd, unsigned long arg)
+{
+	struct nd_bus_descriptor *nd_desc = nd_bus->nd_desc;
+	size_t buf_len = 0, in_len = 0, out_len = 0;
+	static char out_env[ND_CMD_MAX_ENVELOPE];
+	static char in_env[ND_CMD_MAX_ENVELOPE];
+	const struct nd_cmd_desc *desc = NULL;
+	unsigned int cmd = _IOC_NR(ioctl_cmd);
+	void __user *p = (void __user *) arg;
+	struct device *dev = &nd_bus->dev;
+	const char *cmd_name, *dimm_name;
+	unsigned long dsm_mask;
+	void *buf;
+	int rc, i;
+
+	if (nd_dimm) {
+		desc = nd_cmd_dimm_desc(cmd);
+		cmd_name = nd_dimm_cmd_name(cmd);
+		dsm_mask = nd_dimm->dsm_mask ? *(nd_dimm->dsm_mask) : 0;
+		dimm_name = dev_name(&nd_dimm->dev);
+	} else {
+		desc = nd_cmd_bus_desc(cmd);
+		cmd_name = nd_bus_cmd_name(cmd);
+		dsm_mask = nd_desc->dsm_mask;
+		dimm_name = "bus";
+	}
+
+	if (!desc || (desc->out_num + desc->in_num == 0) ||
+			!test_bit(cmd, &dsm_mask))
+		return -ENOTTY;
+
+	/* fail write commands (when read-only) */
+	if (read_only)
+		switch (ioctl_cmd) {
+		case ND_IOCTL_VENDOR:
+		case ND_IOCTL_SET_CONFIG_DATA:
+		case ND_IOCTL_ARS_START:
+			dev_dbg(&nd_bus->dev, "'%s' command while read-only.\n",
+					nd_dimm ? nd_dimm_cmd_name(cmd)
+					: nd_bus_cmd_name(cmd));
+			return -EPERM;
+		default:
+			break;
+		}
+
+	/* process an input envelope */
+	for (i = 0; i < desc->in_num; i++) {
+		u32 in_size, copy;
+
+		in_size = nd_cmd_in_size(nd_dimm, cmd, desc, i, in_env);
+		if (in_size == UINT_MAX) {
+			dev_err(dev, "%s:%s unknown input size cmd: %s field: %d\n",
+					__func__, dimm_name, cmd_name, i);
+			return -ENXIO;
+		}
+		if (!access_ok(VERIFY_READ, p + in_len, in_size))
+			return -EFAULT;
+		if (in_len < sizeof(in_env))
+			copy = min_t(u32, sizeof(in_env) - in_len, in_size);
+		else
+			copy = 0;
+		if (copy && copy_from_user(&in_env[in_len], p + in_len, copy))
+			return -EFAULT;
+		in_len += in_size;
+	}
+
+	/* process an output envelope */
+	for (i = 0; i < desc->out_num; i++) {
+		u32 out_size = nd_cmd_out_size(nd_dimm, cmd, desc, i,
+				(u32 *) in_env, (u32 *) out_env);
+		u32 copy;
+
+		if (out_size == UINT_MAX) {
+			dev_dbg(dev, "%s:%s unknown output size cmd: %s field: %d\n",
+					__func__, dimm_name, cmd_name, i);
+			return -EFAULT;
+		}
+		if (!access_ok(VERIFY_WRITE, p + in_len + out_len, out_size))
+			return -EFAULT;
+		if (out_len < sizeof(out_env))
+			copy = min_t(u32, sizeof(out_env) - out_len, out_size);
+		else
+			copy = 0;
+		if (copy && copy_from_user(&out_env[out_len], p + in_len + out_len,
+					copy))
+			return -EFAULT;
+		out_len += out_size;
+	}
+
+	buf_len = out_len + in_len;
+	if (!access_ok(VERIFY_WRITE, p, sizeof(buf_len)))
+		return -EFAULT;
+
+	if (buf_len > ND_IOCTL_MAX_BUFLEN) {
+		dev_dbg(dev, "%s:%s cmd: %s buf_len: %zd > %d\n", __func__,
+				dimm_name, cmd_name, buf_len,
+				ND_IOCTL_MAX_BUFLEN);
+		return -EINVAL;
+	}
+
+	buf = vmalloc(buf_len);
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, p, buf_len)) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	rc = nd_desc->ndctl(nd_desc, nd_dimm, cmd, buf, buf_len);
+	if (rc < 0)
+		goto out;
+	if (copy_to_user(p, buf, buf_len))
+		rc = -EFAULT;
+ out:
+	vfree(buf);
+	return rc;
+}
+
 static long nd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return -ENXIO;
+	long id = (long) file->private_data;
+	int rc = -ENXIO, read_only;
+	struct nd_bus *nd_bus;
+
+	read_only = (O_RDWR != (file->f_flags & O_ACCMODE));
+	mutex_lock(&nd_bus_list_mutex);
+	list_for_each_entry(nd_bus, &nd_bus_list, list) {
+		if (nd_bus->id == id) {
+			rc = __nd_ioctl(nd_bus, NULL, read_only, cmd, arg);
+			break;
+		}
+	}
+	mutex_unlock(&nd_bus_list_mutex);
+
+	return rc;
+}
+
+static int match_dimm(struct device *dev, void *data)
+{
+	long id = (long) data;
+
+	if (is_nd_dimm(dev)) {
+		struct nd_dimm *nd_dimm = to_nd_dimm(dev);
+
+		return nd_dimm->id == id;
+	}
+
+	return 0;
+}
+
+static long nd_dimm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int rc = -ENXIO, read_only;
+	struct nd_bus *nd_bus;
+
+	read_only = (O_RDWR != (file->f_flags & O_ACCMODE));
+	mutex_lock(&nd_bus_list_mutex);
+	list_for_each_entry(nd_bus, &nd_bus_list, list) {
+		struct device *dev = device_find_child(&nd_bus->dev,
+				file->private_data, match_dimm);
+
+		if (!dev)
+			continue;
+
+		rc = __nd_ioctl(nd_bus, to_nd_dimm(dev), read_only, cmd, arg);
+		put_device(dev);
+		break;
+	}
+	mutex_unlock(&nd_bus_list_mutex);
+
+	return rc;
+}
+
+static int nd_open(struct inode *inode, struct file *file)
+{
+	long minor = iminor(inode);
+
+	file->private_data = (void *) minor;
+	return 0;
 }
 
 static const struct file_operations nd_bus_fops = {
 	.owner = THIS_MODULE,
-	.open = nonseekable_open,
+	.open = nd_open,
 	.unlocked_ioctl = nd_ioctl,
 	.compat_ioctl = nd_ioctl,
 	.llseek = noop_llseek,
 };
 
+static const struct file_operations nd_dimm_fops = {
+	.owner = THIS_MODULE,
+	.open = nd_open,
+	.unlocked_ioctl = nd_dimm_ioctl,
+	.compat_ioctl = nd_dimm_ioctl,
+	.llseek = noop_llseek,
+};
+
 int __init nd_bus_init(void)
 {
 	int rc;
@@ -70,9 +378,14 @@ int __init nd_bus_init(void)
 
 	rc = register_chrdev(0, "ndctl", &nd_bus_fops);
 	if (rc < 0)
-		goto err_chrdev;
+		goto err_bus_chrdev;
 	nd_bus_major = rc;
 
+	rc = register_chrdev(0, "dimmctl", &nd_dimm_fops);
+	if (rc < 0)
+		goto err_dimm_chrdev;
+	nd_dimm_major = rc;
+
 	nd_class = class_create(THIS_MODULE, "nd");
 	if (IS_ERR(nd_class))
 		goto err_class;
@@ -80,8 +393,10 @@ int __init nd_bus_init(void)
 	return 0;
 
  err_class:
+	unregister_chrdev(nd_dimm_major, "dimmctl");
+ err_dimm_chrdev:
 	unregister_chrdev(nd_bus_major, "ndctl");
- err_chrdev:
+ err_bus_chrdev:
 	bus_unregister(&nd_bus_type);
 
 	return rc;
@@ -91,5 +406,6 @@ void __exit nd_bus_exit(void)
 {
 	class_destroy(nd_class);
 	unregister_chrdev(nd_bus_major, "ndctl");
+	unregister_chrdev(nd_dimm_major, "dimmctl");
 	bus_unregister(&nd_bus_type);
 }
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index 24046db897c1..b14bf47dc292 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -13,6 +13,7 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/ndctl.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include "nd-private.h"
@@ -59,6 +60,20 @@ struct nd_bus *walk_to_nd_bus(struct device *nd_dev)
 	return NULL;
 }
 
+static ssize_t commands_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int cmd, len = 0;
+	struct nd_bus *nd_bus = to_nd_bus(dev);
+	struct nd_bus_descriptor *nd_desc = nd_bus->nd_desc;
+
+	for_each_set_bit(cmd, &nd_desc->dsm_mask, BITS_PER_LONG)
+		len += sprintf(buf + len, "%s ", nd_bus_cmd_name(cmd));
+	len += sprintf(buf + len, "\n");
+	return len;
+}
+static DEVICE_ATTR_RO(commands);
+
 static const char *nd_bus_provider(struct nd_bus *nd_bus)
 {
 	struct nd_bus_descriptor *nd_desc = nd_bus->nd_desc;
@@ -82,6 +97,7 @@ static ssize_t provider_show(struct device *dev,
 static DEVICE_ATTR_RO(provider);
 
 static struct attribute *nd_bus_attributes[] = {
+	&dev_attr_commands.attr,
 	&dev_attr_provider.attr,
 	NULL,
 };
diff --git a/drivers/block/nd/dimm_devs.c b/drivers/block/nd/dimm_devs.c
index 19b081392f2f..3fa26f61c3db 100644
--- a/drivers/block/nd/dimm_devs.c
+++ b/drivers/block/nd/dimm_devs.c
@@ -12,6 +12,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/device.h>
+#include <linux/ndctl.h>
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/fs.h>
@@ -33,7 +34,7 @@ static struct device_type nd_dimm_device_type = {
 	.release = nd_dimm_release,
 };
 
-static bool is_nd_dimm(struct device *dev)
+bool is_nd_dimm(struct device *dev)
 {
 	return dev->type == &nd_dimm_device_type;
 }
@@ -55,12 +56,41 @@ EXPORT_SYMBOL_GPL(nd_dimm_name);
 
 void *nd_dimm_provider_data(struct nd_dimm *nd_dimm)
 {
-	return nd_dimm->provider_data;
+	if (nd_dimm)
+		return nd_dimm->provider_data;
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(nd_dimm_provider_data);
 
+static ssize_t commands_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_dimm *nd_dimm = to_nd_dimm(dev);
+	int cmd, len = 0;
+
+	if (!nd_dimm->dsm_mask)
+		return sprintf(buf, "\n");
+
+	for_each_set_bit(cmd, nd_dimm->dsm_mask, BITS_PER_LONG)
+		len += sprintf(buf + len, "%s ", nd_dimm_cmd_name(cmd));
+	len += sprintf(buf + len, "\n");
+	return len;
+}
+static DEVICE_ATTR_RO(commands);
+
+static struct attribute *nd_dimm_attributes[] = {
+	&dev_attr_commands.attr,
+	NULL,
+};
+
+struct attribute_group nd_dimm_attribute_group = {
+	.attrs = nd_dimm_attributes,
+};
+EXPORT_SYMBOL_GPL(nd_dimm_attribute_group);
+
 struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus, void *provider_data,
-		const struct attribute_group **groups, unsigned long flags)
+		const struct attribute_group **groups, unsigned long flags,
+		unsigned long *dsm_mask)
 {
 	struct nd_dimm *nd_dimm = kzalloc(sizeof(*nd_dimm), GFP_KERNEL);
 	struct device *dev;
@@ -75,12 +105,14 @@ struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus, void *provider_data,
 	}
 	nd_dimm->provider_data = provider_data;
 	nd_dimm->flags = flags;
+	nd_dimm->dsm_mask = dsm_mask;
 
 	dev = &nd_dimm->dev;
 	dev_set_name(dev, "nmem%d", nd_dimm->id);
 	dev->parent = &nd_bus->dev;
 	dev->type = &nd_dimm_device_type;
 	dev->bus = &nd_bus_type;
+	dev->devt = MKDEV(nd_dimm_major, nd_dimm->id);
 	dev->groups = groups;
 	if (device_register(dev) != 0) {
 		put_device(dev);
diff --git a/drivers/block/nd/libnd.h b/drivers/block/nd/libnd.h
index 4f8f2ebbcf7b..23dae8c1e65b 100644
--- a/drivers/block/nd/libnd.h
+++ b/drivers/block/nd/libnd.h
@@ -14,13 +14,21 @@
  */
 #ifndef __LIBND_H__
 #define __LIBND_H__
+#include <linux/sizes.h>
 
 enum {
 	/* when a dimm supports both PMEM and BLK access a label is required */
 	NDD_ALIASING = 1 << 0,
+
+	/* need to set a limit somewhere, but yes, this is likely overkill */
+	ND_IOCTL_MAX_BUFLEN = SZ_4M,
+	ND_CMD_MAX_ELEM = 4,
+	ND_CMD_MAX_ENVELOPE = 16,
+	ND_CMD_ARS_QUERY_MAX = SZ_4K,
 };
 
 extern struct attribute_group nd_bus_attribute_group;
+extern struct attribute_group nd_dimm_attribute_group;
 
 struct nd_dimm;
 struct nd_bus_descriptor;
@@ -35,6 +43,13 @@ struct nd_bus_descriptor {
 	ndctl_fn ndctl;
 };
 
+struct nd_cmd_desc {
+	int in_num;
+	int out_num;
+	u32 in_sizes[ND_CMD_MAX_ELEM];
+	int out_sizes[ND_CMD_MAX_ELEM];
+};
+
 struct nd_bus;
 struct nd_bus *nd_bus_register(struct device *parent,
 		struct nd_bus_descriptor *nfit_desc);
@@ -45,5 +60,13 @@ struct nd_bus_descriptor *to_nd_desc(struct nd_bus *nd_bus);
 const char *nd_dimm_name(struct nd_dimm *nd_dimm);
 void *nd_dimm_provider_data(struct nd_dimm *nd_dimm);
 struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus, void *provider_data,
-		const struct attribute_group **groups, unsigned long flags);
+		const struct attribute_group **groups, unsigned long flags,
+		unsigned long *dsm_mask);
+const struct nd_cmd_desc const *nd_cmd_dimm_desc(int cmd);
+const struct nd_cmd_desc const *nd_cmd_bus_desc(int cmd);
+u32 nd_cmd_in_size(struct nd_dimm *nd_dimm, int cmd,
+		const struct nd_cmd_desc *desc, int idx, void *buf);
+u32 nd_cmd_out_size(struct nd_dimm *nd_dimm, int cmd,
+		const struct nd_cmd_desc *desc, int idx, const u32 *in_field,
+		const u32 *out_field);
 #endif /* __LIBND_H__ */
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index cfb5a7241ed1..968e5089f72c 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -18,6 +18,7 @@
 extern struct list_head nd_bus_list;
 extern struct mutex nd_bus_list_mutex;
 extern struct bus_type nd_bus_type;
+extern int nd_dimm_major;
 
 struct nd_bus {
 	struct nd_bus_descriptor *nd_desc;
@@ -29,10 +30,12 @@ struct nd_bus {
 struct nd_dimm {
 	unsigned long flags;
 	void *provider_data;
+	unsigned long *dsm_mask;
 	struct device dev;
 	int id;
 };
 
+bool is_nd_dimm(struct device *dev);
 struct nd_bus *walk_to_nd_bus(struct device *nd_dev);
 int __init nd_bus_init(void);
 void __exit nd_bus_exit(void);
diff --git a/drivers/block/nd/test/nfit.c b/drivers/block/nd/test/nfit.c
index 1c79f32376fc..50916f0ca901 100644
--- a/drivers/block/nd/test/nfit.c
+++ b/drivers/block/nd/test/nfit.c
@@ -14,6 +14,7 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
+#include <linux/ndctl.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include "nfit_test.h"
@@ -142,7 +143,74 @@ static int nfit_test_ctl(struct nd_bus_descriptor *nd_desc,
 		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
 		unsigned int buf_len)
 {
-	return -ENOTTY;
+	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
+	struct nfit_test *t = container_of(acpi_desc, typeof(*t), acpi_desc);
+	struct nfit_mem *nfit_mem = nd_dimm_provider_data(nd_dimm);
+	int i, rc;
+
+	if (!nfit_mem || !test_bit(cmd, &nfit_mem->dsm_mask))
+		return -ENXIO;
+
+	/* lookup label space for the given dimm */
+	for (i = 0; i < ARRAY_SIZE(handle); i++)
+		if (__to_nfit_memdev(nfit_mem)->nfit_handle == handle[i])
+			break;
+	if (i >= ARRAY_SIZE(handle))
+		return -ENXIO;
+
+	switch (cmd) {
+	case ND_CMD_GET_CONFIG_SIZE: {
+		struct nd_cmd_get_config_size *nd_cmd = buf;
+
+		if (buf_len < sizeof(*nd_cmd))
+			return -EINVAL;
+		nd_cmd->status = 0;
+		nd_cmd->config_size = LABEL_SIZE;
+		nd_cmd->max_xfer = SZ_4K;
+		rc = 0;
+		break;
+	}
+	case ND_CMD_GET_CONFIG_DATA: {
+		struct nd_cmd_get_config_data_hdr *nd_cmd = buf;
+		unsigned int len, offset = nd_cmd->in_offset;
+
+		if (buf_len < sizeof(*nd_cmd))
+			return -EINVAL;
+		if (offset >= LABEL_SIZE)
+			return -EINVAL;
+		if (nd_cmd->in_length + sizeof(*nd_cmd) > buf_len)
+			return -EINVAL;
+
+		nd_cmd->status = 0;
+		len = min(nd_cmd->in_length, LABEL_SIZE - offset);
+		memcpy(nd_cmd->out_buf, t->label[i] + offset, len);
+		rc = buf_len - sizeof(*nd_cmd) - len;
+		break;
+	}
+	case ND_CMD_SET_CONFIG_DATA: {
+		struct nd_cmd_set_config_hdr *nd_cmd = buf;
+		unsigned int len, offset = nd_cmd->in_offset;
+		u32 *status;
+
+		if (buf_len < sizeof(*nd_cmd))
+			return -EINVAL;
+		if (offset >= LABEL_SIZE)
+			return -EINVAL;
+		if (nd_cmd->in_length + sizeof(*nd_cmd) + 4 > buf_len)
+			return -EINVAL;
+
+		status = buf + nd_cmd->in_length + sizeof(*nd_cmd);
+		*status = 0;
+		len = min(nd_cmd->in_length, LABEL_SIZE - offset);
+		memcpy(t->label[i] + offset, nd_cmd->in_buf, len);
+		rc = buf_len - sizeof(*nd_cmd) - (len + 4);
+		break;
+	}
+	default:
+		return -ENOTTY;
+	}
+
+	return rc;
 }
 
 static DEFINE_SPINLOCK(nfit_test_lock);
@@ -280,6 +348,7 @@ static int nfit_test0_alloc(struct nfit_test *t)
 		t->label[i] = test_alloc(t, LABEL_SIZE, &t->label_dma[i]);
 		if (!t->label[i])
 			return -ENOMEM;
+		sprintf(t->label[i], "label%d", i);
 	}
 
 	for (i = 0; i < NUM_DCR; i++) {
@@ -322,6 +391,7 @@ static int nfit_test1_alloc(struct nfit_test *t)
 static void nfit_test0_setup(struct nfit_test *t)
 {
 	struct nd_bus_descriptor *nd_desc;
+	struct acpi_nfit_desc *acpi_desc;
 	struct acpi_nfit_memdev *memdev;
 	void *nfit_buf = t->nfit_buf;
 	size_t size = t->nfit_size;
@@ -763,7 +833,11 @@ static void nfit_test0_setup(struct nfit_test *t)
 
 	nfit->checksum = nfit_checksum(nfit_buf, size);
 
-	nd_desc = &t->acpi_desc.nd_desc;
+	acpi_desc = &t->acpi_desc;
+	set_bit(ND_CMD_GET_CONFIG_SIZE, &acpi_desc->dimm_dsm_force_en);
+	set_bit(ND_CMD_GET_CONFIG_DATA, &acpi_desc->dimm_dsm_force_en);
+	set_bit(ND_CMD_SET_CONFIG_DATA, &acpi_desc->dimm_dsm_force_en);
+	nd_desc = &acpi_desc->nd_desc;
 	nd_desc->ndctl = nfit_test_ctl;
 }
 
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 68ceb97c458c..384e8d212b04 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -270,6 +270,7 @@ header-y += ncp_fs.h
 header-y += ncp.h
 header-y += ncp_mount.h
 header-y += ncp_no.h
+header-y += ndctl.h
 header-y += neighbour.h
 header-y += netconf.h
 header-y += netdevice.h
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
new file mode 100644
index 000000000000..62c01bf76198
--- /dev/null
+++ b/include/uapi/linux/ndctl.h
@@ -0,0 +1,178 @@
+/*
+ * Copyright (c) 2014-2015, Intel Corporation.
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
+#ifndef __NDCTL_H__
+#define __NDCTL_H__
+
+#include <linux/types.h>
+
+struct nd_cmd_smart {
+	__u32 status;
+	__u8 data[128];
+} __packed;
+
+struct nd_cmd_smart_threshold {
+	__u32 status;
+	__u8 data[8];
+} __packed;
+
+struct nd_cmd_dimm_flags {
+	__u32 status;
+	__u32 flags;
+} __packed;
+
+struct nd_cmd_get_config_size {
+	__u32 status;
+	__u32 config_size;
+	__u32 max_xfer;
+} __packed;
+
+struct nd_cmd_get_config_data_hdr {
+	__u32 in_offset;
+	__u32 in_length;
+	__u32 status;
+	__u8 out_buf[0];
+} __packed;
+
+struct nd_cmd_set_config_hdr {
+	__u32 in_offset;
+	__u32 in_length;
+	__u8 in_buf[0];
+} __packed;
+
+struct nd_cmd_vendor_hdr {
+	__u32 opcode;
+	__u32 in_length;
+	__u8 in_buf[0];
+} __packed;
+
+struct nd_cmd_vendor_tail {
+	__u32 status;
+	__u32 out_length;
+	__u8 out_buf[0];
+} __packed;
+
+struct nd_cmd_ars_cap {
+	__u64 address;
+	__u64 length;
+	__u32 status;
+	__u32 max_ars_out;
+} __packed;
+
+struct nd_cmd_ars_start {
+	__u64 address;
+	__u64 length;
+	__u16 type;
+	__u8 reserved[6];
+	__u32 status;
+} __packed;
+
+struct nd_cmd_ars_query {
+	__u32 status;
+	__u32 out_length;
+	__u64 address;
+	__u64 length;
+	__u16 type;
+	__u32 num_records;
+	struct nd_ars_record {
+		__u32 handle;
+		__u32 flags;
+		__u64 err_address;
+		__u64 mask;
+	} __packed records[0];
+} __packed;
+
+enum {
+	ND_CMD_IMPLEMENTED = 0,
+
+	/* bus commands */
+	ND_CMD_ARS_CAP = 1,
+	ND_CMD_ARS_START = 2,
+	ND_CMD_ARS_QUERY = 3,
+
+	/* per-dimm commands */
+	ND_CMD_SMART = 1,
+	ND_CMD_SMART_THRESHOLD = 2,
+	ND_CMD_DIMM_FLAGS = 3,
+	ND_CMD_GET_CONFIG_SIZE = 4,
+	ND_CMD_GET_CONFIG_DATA = 5,
+	ND_CMD_SET_CONFIG_DATA = 6,
+	ND_CMD_VENDOR_EFFECT_LOG_SIZE = 7,
+	ND_CMD_VENDOR_EFFECT_LOG = 8,
+	ND_CMD_VENDOR = 9,
+};
+
+static inline const char *nd_bus_cmd_name(unsigned cmd)
+{
+	static const char * const names[] = {
+		[ND_CMD_ARS_CAP] = "ars_cap",
+		[ND_CMD_ARS_START] = "ars_start",
+		[ND_CMD_ARS_QUERY] = "ars_query",
+	};
+
+	if (cmd < ARRAY_SIZE(names) && names[cmd])
+		return names[cmd];
+	return "unknown";
+}
+
+static inline const char *nd_dimm_cmd_name(unsigned cmd)
+{
+	static const char * const names[] = {
+		[ND_CMD_SMART] = "smart",
+		[ND_CMD_SMART_THRESHOLD] = "smart_thresh",
+		[ND_CMD_DIMM_FLAGS] = "flags",
+		[ND_CMD_GET_CONFIG_SIZE] = "get_size",
+		[ND_CMD_GET_CONFIG_DATA] = "get_data",
+		[ND_CMD_SET_CONFIG_DATA] = "set_data",
+		[ND_CMD_VENDOR_EFFECT_LOG_SIZE] = "effect_size",
+		[ND_CMD_VENDOR_EFFECT_LOG] = "effect_log",
+		[ND_CMD_VENDOR] = "vendor",
+	};
+
+	if (cmd < ARRAY_SIZE(names) && names[cmd])
+		return names[cmd];
+	return "unknown";
+}
+
+#define ND_IOCTL 'N'
+
+#define ND_IOCTL_SMART			_IOWR(ND_IOCTL, ND_CMD_SMART,\
+					struct nd_cmd_smart)
+
+#define ND_IOCTL_SMART_THRESHOLD	_IOWR(ND_IOCTL, ND_CMD_SMART_THRESHOLD,\
+					struct nd_cmd_smart_threshold)
+
+#define ND_IOCTL_DIMM_FLAGS		_IOWR(ND_IOCTL, ND_CMD_DIMM_FLAGS,\
+					struct nd_cmd_dimm_flags)
+
+#define ND_IOCTL_GET_CONFIG_SIZE	_IOWR(ND_IOCTL, ND_CMD_GET_CONFIG_SIZE,\
+					struct nd_cmd_get_config_size)
+
+#define ND_IOCTL_GET_CONFIG_DATA	_IOWR(ND_IOCTL, ND_CMD_GET_CONFIG_DATA,\
+					struct nd_cmd_get_config_data_hdr)
+
+#define ND_IOCTL_SET_CONFIG_DATA	_IOWR(ND_IOCTL, ND_CMD_SET_CONFIG_DATA,\
+					struct nd_cmd_set_config_hdr)
+
+#define ND_IOCTL_VENDOR			_IOWR(ND_IOCTL, ND_CMD_VENDOR,\
+					struct nd_cmd_vendor_hdr)
+
+#define ND_IOCTL_ARS_CAP		_IOWR(ND_IOCTL, ND_CMD_ARS_CAP,\
+					struct nd_cmd_ars_cap)
+
+#define ND_IOCTL_ARS_START		_IOWR(ND_IOCTL, ND_CMD_ARS_START,\
+					struct nd_cmd_ars_start)
+
+#define ND_IOCTL_ARS_QUERY		_IOWR(ND_IOCTL, ND_CMD_ARS_QUERY,\
+					struct nd_cmd_ars_query)
+
+#endif /* __NDCTL_H__ */

