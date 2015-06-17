Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v7 05/16] libnvdimm: control (ioctl) messages for nvdimm_bus
 and nvdimm devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:13:47 -0400
Message-ID: <20150617231346.11597.7607.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: mingo@kernel.org, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org, Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org, jmoyer@redhat.com, axboe@kernel.dk, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Most discovery/configuration of the nvdimm-subsystem is done via sysfs
attributes.  However, some nvdimm_bus instances, particularly the
ACPI.NFIT bus, define a small set of messages that can be passed to the
platform.  For convenience we derive the initial libnvdimm-ioctl command
formats directly from the NFIT DSM Interface Example formats.

    ND_CMD_SMART: media health and diagnostics
    ND_CMD_GET_CONFIG_SIZE: size of the label space
    ND_CMD_GET_CONFIG_DATA: read label space
    ND_CMD_SET_CONFIG_DATA: write label space
    ND_CMD_VENDOR: vendor-specific command passthrough
    ND_CMD_ARS_CAP: report address-range-scrubbing capabilities
    ND_CMD_ARS_START: initiate scrubbing
    ND_CMD_ARS_STATUS: report on scrubbing state
    ND_CMD_SMART_THRESHOLD: configure alarm thresholds for smart events

If a platform later defines different commands than this set it is
straightforward to extend support to those formats.

Most of the commands target a specific dimm.  However, the
address-range-scrubbing commands target the bus.  The 'commands'
attribute in sysfs of an nvdimm_bus, or nvdimm, enumerate the supported
commands for that object.

Cc: <linux-acpi@vger.kernel.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-by: Nicholas Moulin <nicholas.w.moulin@linux.intel.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/Kconfig       |   12 ++
 drivers/acpi/nfit.c        |  216 +++++++++++++++++++++++++++++
 drivers/acpi/nfit.h        |    3 
 drivers/nvdimm/bus.c       |  326 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/nvdimm/core.c      |   16 ++
 drivers/nvdimm/dimm_devs.c |   38 +++++
 drivers/nvdimm/nd-core.h   |    3 
 include/linux/libnvdimm.h  |   27 ++++
 include/uapi/linux/Kbuild  |    1 
 include/uapi/linux/ndctl.h |  178 ++++++++++++++++++++++++
 10 files changed, 810 insertions(+), 10 deletions(-)
 create mode 100644 include/uapi/linux/ndctl.h

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 300b4ef3712b..9c43ae301300 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -397,6 +397,18 @@ config ACPI_NFIT
 	  To compile this driver as a module, choose M here:
 	  the module will be called nfit.
 
+config ACPI_NFIT_DEBUG
+	bool "NFIT DSM debug"
+	depends on ACPI_NFIT
+	depends on DYNAMIC_DEBUG
+	default n
+	help
+	  Enabling this option causes the nfit driver to dump the
+	  input and output buffers of _DSM operations on the ACPI0012
+	  device and its children.  This can be very verbose, so leave
+	  it disabled unless you are debugging a hardware / firmware
+	  issue.
+
 source "drivers/acpi/apei/Kconfig"
 
 config ACPI_EXTLOG
diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 9fd7781f966e..9112a6210a4b 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -13,6 +13,7 @@
 #include <linux/list_sort.h>
 #include <linux/libnvdimm.h>
 #include <linux/module.h>
+#include <linux/ndctl.h>
 #include <linux/list.h>
 #include <linux/acpi.h>
 #include "nfit.h"
@@ -24,11 +25,153 @@ static const u8 *to_nfit_uuid(enum nfit_uuids id)
 	return nfit_uuid[id];
 }
 
+static struct acpi_nfit_desc *to_acpi_nfit_desc(
+		struct nvdimm_bus_descriptor *nd_desc)
+{
+	return container_of(nd_desc, struct acpi_nfit_desc, nd_desc);
+}
+
+static struct acpi_device *to_acpi_dev(struct acpi_nfit_desc *acpi_desc)
+{
+	struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
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
 static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len)
 {
-	return -ENOTTY;
+	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
+	const struct nd_cmd_desc *desc = NULL;
+	union acpi_object in_obj, in_buf, *out_obj;
+	struct device *dev = acpi_desc->dev;
+	const char *cmd_name, *dimm_name;
+	unsigned long dsm_mask;
+	acpi_handle handle;
+	const u8 *uuid;
+	u32 offset;
+	int rc, i;
+
+	if (nvdimm) {
+		struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+		struct acpi_device *adev = nfit_mem->adev;
+
+		if (!adev)
+			return -ENOTTY;
+		dimm_name = dev_name(&adev->dev);
+		cmd_name = nvdimm_cmd_name(cmd);
+		dsm_mask = nfit_mem->dsm_mask;
+		desc = nd_cmd_dimm_desc(cmd);
+		uuid = to_nfit_uuid(NFIT_DEV_DIMM);
+		handle = adev->handle;
+	} else {
+		struct acpi_device *adev = to_acpi_dev(acpi_desc);
+
+		cmd_name = nvdimm_bus_cmd_name(cmd);
+		dsm_mask = nd_desc->dsm_mask;
+		desc = nd_cmd_bus_desc(cmd);
+		uuid = to_nfit_uuid(NFIT_DEV_BUS);
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
+	/* libnvdimm has already validated the input envelope */
+	for (i = 0; i < desc->in_num; i++)
+		in_buf.buffer.length += nd_cmd_in_size(nvdimm, cmd, desc,
+				i, buf);
+
+	if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
+		dev_dbg(dev, "%s:%s cmd: %s input length: %d\n", __func__,
+				dimm_name, cmd_name, in_buf.buffer.length);
+		print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
+				4, in_buf.buffer.pointer, min_t(u32, 128,
+					in_buf.buffer.length), true);
+	}
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
+	if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
+		dev_dbg(dev, "%s:%s cmd: %s output length: %d\n", __func__,
+				dimm_name, cmd_name, out_obj->buffer.length);
+		print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
+				4, out_obj->buffer.pointer, min_t(u32, 128,
+					out_obj->buffer.length), true);
+	}
+
+	for (i = 0, offset = 0; i < desc->out_num; i++) {
+		u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i, buf,
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
+					__func__, dimm_name, cmd_name, buf_len,
+					offset);
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
@@ -489,6 +632,7 @@ static struct attribute_group acpi_nfit_dimm_attribute_group = {
 };
 
 static const struct attribute_group *acpi_nfit_dimm_attribute_groups[] = {
+	&nvdimm_attribute_group,
 	&acpi_nfit_dimm_attribute_group,
 	NULL,
 };
@@ -505,6 +649,50 @@ static struct nvdimm *acpi_nfit_dimm_by_handle(struct acpi_nfit_desc *acpi_desc,
 	return NULL;
 }
 
+static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
+		struct nfit_mem *nfit_mem, u32 device_handle)
+{
+	struct acpi_device *adev, *adev_dimm;
+	struct device *dev = acpi_desc->dev;
+	const u8 *uuid = to_nfit_uuid(NFIT_DEV_DIMM);
+	unsigned long long sta;
+	int i, rc = -ENODEV;
+	acpi_status status;
+
+	nfit_mem->dsm_mask = acpi_desc->dimm_dsm_force_en;
+	adev = to_acpi_dev(acpi_desc);
+	if (!adev)
+		return 0;
+
+	adev_dimm = acpi_find_child_device(adev, device_handle, false);
+	nfit_mem->adev = adev_dimm;
+	if (!adev_dimm) {
+		dev_err(dev, "no ACPI.NFIT device with _ADR %#x, disabling...\n",
+				device_handle);
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
 static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nfit_mem *nfit_mem;
@@ -513,6 +701,7 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		struct nvdimm *nvdimm;
 		unsigned long flags = 0;
 		u32 device_handle;
+		int rc;
 
 		device_handle = __to_nfit_memdev(nfit_mem)->device_handle;
 		nvdimm = acpi_nfit_dimm_by_handle(acpi_desc, device_handle);
@@ -529,8 +718,13 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		if (nfit_mem->bdw && nfit_mem->memdev_pmem)
 			flags |= NDD_ALIASING;
 
+		rc = acpi_nfit_add_dimm(acpi_desc, nfit_mem, device_handle);
+		if (rc)
+			continue;
+
 		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
-				acpi_nfit_dimm_attribute_groups, flags);
+				acpi_nfit_dimm_attribute_groups,
+				flags, &nfit_mem->dsm_mask);
 		if (!nvdimm)
 			return -ENOMEM;
 
@@ -540,6 +734,22 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 	return 0;
 }
 
+static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
+{
+	struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
+	const u8 *uuid = to_nfit_uuid(NFIT_DEV_BUS);
+	struct acpi_device *adev;
+	int i;
+
+	adev = to_acpi_dev(acpi_desc);
+	if (!adev)
+		return;
+
+	for (i = ND_CMD_ARS_CAP; i <= ND_CMD_ARS_STATUS; i++)
+		if (acpi_check_dsm(adev->handle, uuid, 1, 1ULL << i))
+			set_bit(i, &nd_desc->dsm_mask);
+}
+
 static int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 {
 	struct device *dev = acpi_desc->dev;
@@ -567,6 +777,8 @@ static int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 	if (nfit_mem_init(acpi_desc) != 0)
 		return -ENOMEM;
 
+	acpi_nfit_init_dsms(acpi_desc);
+
 	return acpi_nfit_register_dimms(acpi_desc);
 }
 
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 9dd437fe5563..b76e33629098 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -67,6 +67,8 @@ struct nfit_mem {
 	struct acpi_nfit_system_address *spa_dcr;
 	struct acpi_nfit_system_address *spa_bdw;
 	struct list_head list;
+	struct acpi_device *adev;
+	unsigned long dsm_mask;
 };
 
 struct acpi_nfit_desc {
@@ -79,6 +81,7 @@ struct acpi_nfit_desc {
 	struct list_head bdws;
 	struct nvdimm_bus *nvdimm_bus;
 	struct device *dev;
+	unsigned long dimm_dsm_force_en;
 };
 
 static inline struct acpi_nfit_memory_map *__to_nfit_memdev(
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index a8802577fb55..15f3a3ddc225 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
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
 #include "nd-core.h"
 
+int nvdimm_major;
 static int nvdimm_bus_major;
 static struct class *nd_class;
 
@@ -47,19 +51,325 @@ void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus)
 	device_destroy(nd_class, MKDEV(nvdimm_bus_major, nvdimm_bus->id));
 }
 
+static const struct nd_cmd_desc __nd_cmd_dimm_descs[] = {
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
+const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd)
+{
+	if (cmd < ARRAY_SIZE(__nd_cmd_dimm_descs))
+		return &__nd_cmd_dimm_descs[cmd];
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nd_cmd_dimm_desc);
+
+static const struct nd_cmd_desc __nd_cmd_bus_descs[] = {
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
+	[ND_CMD_ARS_STATUS] = {
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
+u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
+		const struct nd_cmd_desc *desc, int idx, void *buf)
+{
+	if (idx >= desc->in_num)
+		return UINT_MAX;
+
+	if (desc->in_sizes[idx] < UINT_MAX)
+		return desc->in_sizes[idx];
+
+	if (nvdimm && cmd == ND_CMD_SET_CONFIG_DATA && idx == 2) {
+		struct nd_cmd_set_config_hdr *hdr = buf;
+
+		return hdr->in_length;
+	} else if (nvdimm && cmd == ND_CMD_VENDOR && idx == 2) {
+		struct nd_cmd_vendor_hdr *hdr = buf;
+
+		return hdr->in_length;
+	}
+
+	return UINT_MAX;
+}
+EXPORT_SYMBOL_GPL(nd_cmd_in_size);
+
+u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
+		const struct nd_cmd_desc *desc, int idx, const u32 *in_field,
+		const u32 *out_field)
+{
+	if (idx >= desc->out_num)
+		return UINT_MAX;
+
+	if (desc->out_sizes[idx] < UINT_MAX)
+		return desc->out_sizes[idx];
+
+	if (nvdimm && cmd == ND_CMD_GET_CONFIG_DATA && idx == 1)
+		return in_field[1];
+	else if (nvdimm && cmd == ND_CMD_VENDOR && idx == 2)
+		return out_field[1];
+	else if (!nvdimm && cmd == ND_CMD_ARS_STATUS && idx == 1)
+		return ND_CMD_ARS_STATUS_MAX;
+
+	return UINT_MAX;
+}
+EXPORT_SYMBOL_GPL(nd_cmd_out_size);
+
+static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
+		int read_only, unsigned int ioctl_cmd, unsigned long arg)
+{
+	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
+	size_t buf_len = 0, in_len = 0, out_len = 0;
+	static char out_env[ND_CMD_MAX_ENVELOPE];
+	static char in_env[ND_CMD_MAX_ENVELOPE];
+	const struct nd_cmd_desc *desc = NULL;
+	unsigned int cmd = _IOC_NR(ioctl_cmd);
+	void __user *p = (void __user *) arg;
+	struct device *dev = &nvdimm_bus->dev;
+	const char *cmd_name, *dimm_name;
+	unsigned long dsm_mask;
+	void *buf;
+	int rc, i;
+
+	if (nvdimm) {
+		desc = nd_cmd_dimm_desc(cmd);
+		cmd_name = nvdimm_cmd_name(cmd);
+		dsm_mask = nvdimm->dsm_mask ? *(nvdimm->dsm_mask) : 0;
+		dimm_name = dev_name(&nvdimm->dev);
+	} else {
+		desc = nd_cmd_bus_desc(cmd);
+		cmd_name = nvdimm_bus_cmd_name(cmd);
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
+			dev_dbg(&nvdimm_bus->dev, "'%s' command while read-only.\n",
+					nvdimm ? nvdimm_cmd_name(cmd)
+					: nvdimm_bus_cmd_name(cmd));
+			return -EPERM;
+		default:
+			break;
+		}
+
+	/* process an input envelope */
+	for (i = 0; i < desc->in_num; i++) {
+		u32 in_size, copy;
+
+		in_size = nd_cmd_in_size(nvdimm, cmd, desc, i, in_env);
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
+		u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i,
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
+		if (copy && copy_from_user(&out_env[out_len],
+					p + in_len + out_len, copy))
+			return -EFAULT;
+		out_len += out_size;
+	}
+
+	buf_len = out_len + in_len;
+	if (!access_ok(VERIFY_WRITE, p, sizeof(buf_len)))
+		return -EFAULT;
+
+	if (buf_len > ND_IOCTL_MAX_BUFLEN) {
+		dev_dbg(dev, "%s:%s cmd: %s buf_len: %zu > %d\n", __func__,
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
+	rc = nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len);
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
+	struct nvdimm_bus *nvdimm_bus;
+
+	read_only = (O_RDWR != (file->f_flags & O_ACCMODE));
+	mutex_lock(&nvdimm_bus_list_mutex);
+	list_for_each_entry(nvdimm_bus, &nvdimm_bus_list, list) {
+		if (nvdimm_bus->id == id) {
+			rc = __nd_ioctl(nvdimm_bus, NULL, read_only, cmd, arg);
+			break;
+		}
+	}
+	mutex_unlock(&nvdimm_bus_list_mutex);
+
+	return rc;
+}
+
+static int match_dimm(struct device *dev, void *data)
+{
+	long id = (long) data;
+
+	if (is_nvdimm(dev)) {
+		struct nvdimm *nvdimm = to_nvdimm(dev);
+
+		return nvdimm->id == id;
+	}
+
+	return 0;
+}
+
+static long nvdimm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int rc = -ENXIO, read_only;
+	struct nvdimm_bus *nvdimm_bus;
+
+	read_only = (O_RDWR != (file->f_flags & O_ACCMODE));
+	mutex_lock(&nvdimm_bus_list_mutex);
+	list_for_each_entry(nvdimm_bus, &nvdimm_bus_list, list) {
+		struct device *dev = device_find_child(&nvdimm_bus->dev,
+				file->private_data, match_dimm);
+		struct nvdimm *nvdimm;
+
+		if (!dev)
+			continue;
+
+		nvdimm = to_nvdimm(dev);
+		rc = __nd_ioctl(nvdimm_bus, nvdimm, read_only, cmd, arg);
+		put_device(dev);
+		break;
+	}
+	mutex_unlock(&nvdimm_bus_list_mutex);
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
 
 static const struct file_operations nvdimm_bus_fops = {
 	.owner = THIS_MODULE,
-	.open = nonseekable_open,
+	.open = nd_open,
 	.unlocked_ioctl = nd_ioctl,
 	.compat_ioctl = nd_ioctl,
 	.llseek = noop_llseek,
 };
 
+static const struct file_operations nvdimm_fops = {
+	.owner = THIS_MODULE,
+	.open = nd_open,
+	.unlocked_ioctl = nvdimm_ioctl,
+	.compat_ioctl = nvdimm_ioctl,
+	.llseek = noop_llseek,
+};
+
 int __init nvdimm_bus_init(void)
 {
 	int rc;
@@ -70,9 +380,14 @@ int __init nvdimm_bus_init(void)
 
 	rc = register_chrdev(0, "ndctl", &nvdimm_bus_fops);
 	if (rc < 0)
-		goto err_chrdev;
+		goto err_bus_chrdev;
 	nvdimm_bus_major = rc;
 
+	rc = register_chrdev(0, "dimmctl", &nvdimm_fops);
+	if (rc < 0)
+		goto err_dimm_chrdev;
+	nvdimm_major = rc;
+
 	nd_class = class_create(THIS_MODULE, "nd");
 	if (IS_ERR(nd_class))
 		goto err_class;
@@ -80,8 +395,10 @@ int __init nvdimm_bus_init(void)
 	return 0;
 
  err_class:
+	unregister_chrdev(nvdimm_major, "dimmctl");
+ err_dimm_chrdev:
 	unregister_chrdev(nvdimm_bus_major, "ndctl");
- err_chrdev:
+ err_bus_chrdev:
 	bus_unregister(&nvdimm_bus_type);
 
 	return rc;
@@ -91,5 +408,6 @@ void __exit nvdimm_bus_exit(void)
 {
 	class_destroy(nd_class);
 	unregister_chrdev(nvdimm_bus_major, "ndctl");
+	unregister_chrdev(nvdimm_major, "dimmctl");
 	bus_unregister(&nvdimm_bus_type);
 }
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index ef957eb37c90..1ce159095c52 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -14,6 +14,7 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/ndctl.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include "nd-core.h"
@@ -61,6 +62,20 @@ struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev)
 	return NULL;
 }
 
+static ssize_t commands_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int cmd, len = 0;
+	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
+	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
+
+	for_each_set_bit(cmd, &nd_desc->dsm_mask, BITS_PER_LONG)
+		len += sprintf(buf + len, "%s ", nvdimm_bus_cmd_name(cmd));
+	len += sprintf(buf + len, "\n");
+	return len;
+}
+static DEVICE_ATTR_RO(commands);
+
 static const char *nvdimm_bus_provider(struct nvdimm_bus *nvdimm_bus)
 {
 	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
@@ -84,6 +99,7 @@ static ssize_t provider_show(struct device *dev,
 static DEVICE_ATTR_RO(provider);
 
 static struct attribute *nvdimm_bus_attributes[] = {
+	&dev_attr_commands.attr,
 	&dev_attr_provider.attr,
 	NULL,
 };
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 51ea52cc2079..c3dd7227d1bb 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -12,6 +12,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/device.h>
+#include <linux/ndctl.h>
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/fs.h>
@@ -33,7 +34,7 @@ static struct device_type nvdimm_device_type = {
 	.release = nvdimm_release,
 };
 
-static bool is_nvdimm(struct device *dev)
+bool is_nvdimm(struct device *dev)
 {
 	return dev->type == &nvdimm_device_type;
 }
@@ -55,12 +56,41 @@ EXPORT_SYMBOL_GPL(nvdimm_name);
 
 void *nvdimm_provider_data(struct nvdimm *nvdimm)
 {
-	return nvdimm->provider_data;
+	if (nvdimm)
+		return nvdimm->provider_data;
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(nvdimm_provider_data);
 
+static ssize_t commands_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	int cmd, len = 0;
+
+	if (!nvdimm->dsm_mask)
+		return sprintf(buf, "\n");
+
+	for_each_set_bit(cmd, nvdimm->dsm_mask, BITS_PER_LONG)
+		len += sprintf(buf + len, "%s ", nvdimm_cmd_name(cmd));
+	len += sprintf(buf + len, "\n");
+	return len;
+}
+static DEVICE_ATTR_RO(commands);
+
+static struct attribute *nvdimm_attributes[] = {
+	&dev_attr_commands.attr,
+	NULL,
+};
+
+struct attribute_group nvdimm_attribute_group = {
+	.attrs = nvdimm_attributes,
+};
+EXPORT_SYMBOL_GPL(nvdimm_attribute_group);
+
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
-		const struct attribute_group **groups, unsigned long flags)
+		const struct attribute_group **groups, unsigned long flags,
+		unsigned long *dsm_mask)
 {
 	struct nvdimm *nvdimm = kzalloc(sizeof(*nvdimm), GFP_KERNEL);
 	struct device *dev;
@@ -75,12 +105,14 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 	}
 	nvdimm->provider_data = provider_data;
 	nvdimm->flags = flags;
+	nvdimm->dsm_mask = dsm_mask;
 
 	dev = &nvdimm->dev;
 	dev_set_name(dev, "nmem%d", nvdimm->id);
 	dev->parent = &nvdimm_bus->dev;
 	dev->type = &nvdimm_device_type;
 	dev->bus = &nvdimm_bus_type;
+	dev->devt = MKDEV(nvdimm_major, nvdimm->id);
 	dev->groups = groups;
 	if (device_register(dev) != 0) {
 		put_device(dev);
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 9b8303413b60..59528b3c9de8 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -18,6 +18,7 @@
 extern struct list_head nvdimm_bus_list;
 extern struct mutex nvdimm_bus_list_mutex;
 extern struct bus_type nvdimm_bus_type;
+extern int nvdimm_major;
 
 struct nvdimm_bus {
 	struct nvdimm_bus_descriptor *nd_desc;
@@ -29,10 +30,12 @@ struct nvdimm_bus {
 struct nvdimm {
 	unsigned long flags;
 	void *provider_data;
+	unsigned long *dsm_mask;
 	struct device dev;
 	int id;
 };
 
+bool is_nvdimm(struct device *dev);
 struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
 int __init nvdimm_bus_init(void);
 void __exit nvdimm_bus_exit(void);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 07787f0dd7de..a39235819af3 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -14,13 +14,22 @@
  */
 #ifndef __LIBNVDIMM_H__
 #define __LIBNVDIMM_H__
+#include <linux/sizes.h>
+#include <linux/types.h>
 
 enum {
 	/* when a dimm supports both PMEM and BLK access a label is required */
 	NDD_ALIASING = 1 << 0,
+
+	/* need to set a limit somewhere, but yes, this is likely overkill */
+	ND_IOCTL_MAX_BUFLEN = SZ_4M,
+	ND_CMD_MAX_ELEM = 4,
+	ND_CMD_MAX_ENVELOPE = 16,
+	ND_CMD_ARS_STATUS_MAX = SZ_4K,
 };
 
 extern struct attribute_group nvdimm_bus_attribute_group;
+extern struct attribute_group nvdimm_attribute_group;
 
 struct nvdimm;
 struct nvdimm_bus_descriptor;
@@ -35,6 +44,14 @@ struct nvdimm_bus_descriptor {
 	ndctl_fn ndctl;
 };
 
+struct nd_cmd_desc {
+	int in_num;
+	int out_num;
+	u32 in_sizes[ND_CMD_MAX_ELEM];
+	int out_sizes[ND_CMD_MAX_ELEM];
+};
+
+struct nvdimm_bus;
 struct device;
 struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nfit_desc);
@@ -45,5 +62,13 @@ struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus);
 const char *nvdimm_name(struct nvdimm *nvdimm);
 void *nvdimm_provider_data(struct nvdimm *nvdimm);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
-		const struct attribute_group **groups, unsigned long flags);
+		const struct attribute_group **groups, unsigned long flags,
+		unsigned long *dsm_mask);
+const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
+const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
+u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
+		const struct nd_cmd_desc *desc, int idx, void *buf);
+u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
+		const struct nd_cmd_desc *desc, int idx, const u32 *in_field,
+		const u32 *out_field);
 #endif /* __LIBNVDIMM_H__ */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 1a0006a76b00..200cc5ea2998 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -271,6 +271,7 @@ header-y += ncp_fs.h
 header-y += ncp.h
 header-y += ncp_mount.h
 header-y += ncp_no.h
+header-y += ndctl.h
 header-y += neighbour.h
 header-y += netconf.h
 header-y += netdevice.h
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
new file mode 100644
index 000000000000..ff13c23b26df
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
+struct nd_cmd_ars_status {
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
+	ND_CMD_ARS_STATUS = 3,
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
+static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
+{
+	static const char * const names[] = {
+		[ND_CMD_ARS_CAP] = "ars_cap",
+		[ND_CMD_ARS_START] = "ars_start",
+		[ND_CMD_ARS_STATUS] = "ars_status",
+	};
+
+	if (cmd < ARRAY_SIZE(names) && names[cmd])
+		return names[cmd];
+	return "unknown";
+}
+
+static inline const char *nvdimm_cmd_name(unsigned cmd)
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
+#define ND_IOCTL_ARS_STATUS		_IOWR(ND_IOCTL, ND_CMD_ARS_STATUS,\
+					struct nd_cmd_ars_status)
+
+#endif /* __NDCTL_H__ */

