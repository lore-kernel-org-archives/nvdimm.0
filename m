Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 08/21] nd: ndctl.h, the nd ioctl abi
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Apr 2015 21:35:57 -0400
Message-ID: <20150418013557.25237.81354.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Most configuration of the nd-subsystem is done via nd-sysfs.  However,
the NFIT specification defines a small set of messages that can be
passed to the subsystem via platform-firmware-defined methods.  The
command set (as of the current version of the NFIT-DSM spec) is:

    NFIT_CMD_SMART: media health and diagnostics
    NFIT_CMD_GET_CONFIG_SIZE: size of the label space
    NFIT_CMD_GET_CONFIG_DATA: read label
    NFIT_CMD_SET_CONFIG_DATA: write label
    NFIT_CMD_VENDOR: vendor-specific command passthrough
    NFIT_CMD_ARS_CAP: report address-range-scrubbing capabilities
    NFIT_CMD_START_ARS: initiate scrubbing
    NFIT_CMD_QUERY_ARS: report on scrubbing state
    NFIT_CMD_SMART_THRESHOLD: configure alarm thresholds for smart events

Most of the commands target a specific dimm.  However, the
address-range-scrubbing commands target the entire NFIT-bus / platform.
The 'commands' attribute of an nd-bus, or an nd-dimm enumerate the
supported commands for that object.

Cc: <linux-acpi@vger.kernel.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-by: Nicholas Moulin <nicholas.w.moulin@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/Kconfig      |   11 +
 drivers/block/nd/acpi.c       |  333 +++++++++++++++++++++++++++++++++++++++++
 drivers/block/nd/bus.c        |  230 ++++++++++++++++++++++++++++
 drivers/block/nd/core.c       |   17 ++
 drivers/block/nd/dimm_devs.c  |   69 ++++++++
 drivers/block/nd/nd-private.h |   11 +
 drivers/block/nd/nd.h         |   21 +++
 drivers/block/nd/test/nfit.c  |   89 +++++++++++
 include/uapi/linux/Kbuild     |    1 
 include/uapi/linux/ndctl.h    |  178 ++++++++++++++++++++++
 10 files changed, 950 insertions(+), 10 deletions(-)
 create mode 100644 drivers/block/nd/nd.h
 create mode 100644 include/uapi/linux/ndctl.h

diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
index 0106b3807202..6c15d10bf4e0 100644
--- a/drivers/block/nd/Kconfig
+++ b/drivers/block/nd/Kconfig
@@ -42,6 +42,17 @@ config NFIT_ACPI
 	  enables the core to craft ACPI._DSM messages for platform/dimm
 	  configuration.
 
+config NFIT_ACPI_DEBUG
+	bool "NFIT ACPI: Turn on extra debugging"
+	depends on NFIT_ACPI
+	depends on DYNAMIC_DEBUG
+	default n
+	help
+	  Enabling this option causes the nd_acpi driver to dump the
+	  input and output buffers of _DSM operations on the ACPI0012
+	  device, which can be very verbose.  Leave it disabled unless
+	  you are debugging a hardware / firmware issue.
+
 config NFIT_TEST
 	tristate "NFIT TEST: Manufactured NFIT for interface testing"
 	depends on DMA_CMA
diff --git a/drivers/block/nd/acpi.c b/drivers/block/nd/acpi.c
index 48db723d7a90..073ff28fdbfe 100644
--- a/drivers/block/nd/acpi.c
+++ b/drivers/block/nd/acpi.c
@@ -13,8 +13,10 @@
 #include <linux/list.h>
 #include <linux/acpi.h>
 #include <linux/mutex.h>
+#include <linux/ndctl.h>
 #include <linux/module.h>
 #include "nfit.h"
+#include "nd.h"
 
 enum {
 	NFIT_ACPI_NOTIFY_TABLE = 0x80,
@@ -26,20 +28,330 @@ struct acpi_nfit {
 	struct nd_bus *nd_bus;
 };
 
+static struct acpi_nfit *to_acpi_nfit(struct nfit_bus_descriptor *nfit_desc)
+{
+	return container_of(nfit_desc, struct acpi_nfit, nfit_desc);
+}
+
+#define NFIT_ACPI_MAX_ELEM 4
+struct nfit_cmd_desc {
+	int in_num;
+	int out_num;
+	u32 in_sizes[NFIT_ACPI_MAX_ELEM];
+	int out_sizes[NFIT_ACPI_MAX_ELEM];
+};
+
+static const struct nfit_cmd_desc nfit_dimm_descs[] = {
+	[NFIT_CMD_IMPLEMENTED] = { },
+	[NFIT_CMD_SMART] = {
+		.out_num = 2,
+		.out_sizes = { 4, 8, },
+	},
+	[NFIT_CMD_SMART_THRESHOLD] = {
+		.out_num = 2,
+		.out_sizes = { 4, 8, },
+	},
+	[NFIT_CMD_DIMM_FLAGS] = {
+		.out_num = 2,
+		.out_sizes = { 4, 4 },
+	},
+	[NFIT_CMD_GET_CONFIG_SIZE] = {
+		.out_num = 3,
+		.out_sizes = { 4, 4, 4, },
+	},
+	[NFIT_CMD_GET_CONFIG_DATA] = {
+		.in_num = 2,
+		.in_sizes = { 4, 4, },
+		.out_num = 2,
+		.out_sizes = { 4, UINT_MAX, },
+	},
+	[NFIT_CMD_SET_CONFIG_DATA] = {
+		.in_num = 3,
+		.in_sizes = { 4, 4, UINT_MAX, },
+		.out_num = 1,
+		.out_sizes = { 4, },
+	},
+	[NFIT_CMD_VENDOR] = {
+		.in_num = 3,
+		.in_sizes = { 4, 4, UINT_MAX, },
+		.out_num = 3,
+		.out_sizes = { 4, 4, UINT_MAX, },
+	},
+};
+
+static const struct nfit_cmd_desc nfit_acpi_descs[] = {
+	[NFIT_CMD_IMPLEMENTED] = { },
+	[NFIT_CMD_ARS_CAP] = {
+		.in_num = 2,
+		.in_sizes = { 8, 8, },
+		.out_num = 2,
+		.out_sizes = { 4, 4, },
+	},
+	[NFIT_CMD_ARS_START] = {
+		.in_num = 4,
+		.in_sizes = { 8, 8, 2, 6, },
+		.out_num = 1,
+		.out_sizes = { 4, },
+	},
+	[NFIT_CMD_ARS_QUERY] = {
+		.out_num = 2,
+		.out_sizes = { 4, UINT_MAX, },
+	},
+};
+
+static u32 to_cmd_in_size(struct nd_dimm *nd_dimm, int cmd,
+		const struct nfit_cmd_desc *desc, int idx, void *buf)
+{
+	if (idx >= desc->in_num)
+		return UINT_MAX;
+
+	if (desc->in_sizes[idx] < UINT_MAX)
+		return desc->in_sizes[idx];
+
+	if (nd_dimm && cmd == NFIT_CMD_SET_CONFIG_DATA && idx == 2) {
+		struct nfit_cmd_set_config_hdr *hdr = buf;
+
+		return hdr->in_length;
+	} else if (nd_dimm && cmd == NFIT_CMD_VENDOR && idx == 2) {
+		struct nfit_cmd_vendor_hdr *hdr = buf;
+
+		return hdr->in_length;
+	}
+
+	return UINT_MAX;
+}
+
+static u32 to_cmd_out_size(struct nd_dimm *nd_dimm, int cmd,
+		const struct nfit_cmd_desc *desc, int idx,
+		void *buf, u32 out_length, u32 offset)
+{
+	if (idx >= desc->out_num)
+		return UINT_MAX;
+
+	if (desc->out_sizes[idx] < UINT_MAX)
+		return desc->out_sizes[idx];
+
+	if (offset >= out_length)
+		return UINT_MAX;
+
+	if (nd_dimm && cmd == NFIT_CMD_GET_CONFIG_DATA && idx == 1)
+		return out_length - offset;
+	else if (nd_dimm && cmd == NFIT_CMD_VENDOR && idx == 2)
+		return out_length - offset;
+	else if (!nd_dimm && cmd == NFIT_CMD_ARS_QUERY && idx == 1)
+		return out_length - offset;
+
+	return UINT_MAX;
+}
+
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
 static int nd_acpi_ctl(struct nfit_bus_descriptor *nfit_desc,
 		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
 		unsigned int buf_len)
 {
-	return -ENOTTY;
+	struct acpi_nfit *nfit = to_acpi_nfit(nfit_desc);
+	union acpi_object in_obj, in_buf, *out_obj;
+	const struct nfit_cmd_desc *desc = NULL;
+	struct device *dev = &nfit->dev->dev;
+	const char *cmd_name, *dimm_name;
+	unsigned long dsm_mask;
+	acpi_handle handle;
+	u32 offset;
+	int rc, i;
+	u8 *uuid;
+
+	if (nd_dimm) {
+		struct acpi_device *adev = nd_dimm_get_pdata(nd_dimm);
+
+		if (cmd < ARRAY_SIZE(nfit_dimm_descs))
+			desc = &nfit_dimm_descs[cmd];
+		cmd_name = nfit_dimm_cmd_name(cmd);
+		dsm_mask = nd_dimm_get_dsm_mask(nd_dimm);
+		handle = adev->handle;
+		uuid = nd_acpi_dimm_uuid();
+		dimm_name = dev_name(&adev->dev);
+	} else {
+		if (cmd < ARRAY_SIZE(nfit_acpi_descs))
+			desc = &nfit_acpi_descs[cmd];
+		cmd_name = nfit_bus_cmd_name(cmd);
+		dsm_mask = nfit_desc->dsm_mask;
+		handle = nfit->dev->handle;
+		uuid = nd_acpi_bus_uuid();
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
+	/* double check that the nfit_acpi_cmd_descs table is self consistent */
+	if (desc->in_num > NFIT_ACPI_MAX_ELEM) {
+		WARN_ON_ONCE(1);
+		return -ENXIO;
+	}
+
+	for (i = 0; i < desc->in_num; i++) {
+		u32 in_size;
+
+		in_size = to_cmd_in_size(nd_dimm, cmd, desc, i, buf);
+		if (in_size == UINT_MAX) {
+			dev_err(dev, "%s:%s unknown input size cmd: %s field: %d\n",
+					__func__, dimm_name, cmd_name, i);
+			return -ENXIO;
+		}
+		in_buf.buffer.length += in_size;
+		if (in_buf.buffer.length > buf_len) {
+			dev_err(dev, "%s:%s input underrun cmd: %s field: %d\n",
+					__func__, dimm_name, cmd_name, i);
+			return -ENXIO;
+		}
+	}
+
+	dev_dbg(dev, "%s:%s cmd: %s input length: %d\n", __func__, dimm_name,
+			cmd_name, in_buf.buffer.length);
+	if (IS_ENABLED(CONFIG_NFIT_ACPI_DEBUG))
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
+	if (IS_ENABLED(CONFIG_NFIT_ACPI_DEBUG))
+		print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
+				4, out_obj->buffer.pointer, min_t(u32, 128,
+					out_obj->buffer.length), true);
+
+	for (i = 0, offset = 0; i < desc->out_num; i++) {
+		u32 out_size = to_cmd_out_size(nd_dimm, cmd, desc, i, buf,
+				out_obj->buffer.length, offset);
+
+		if (out_size == UINT_MAX) {
+			dev_dbg(dev, "%s:%s unknown output size cmd: %s field: %d\n",
+					__func__, dimm_name, cmd_name, i);
+			break;
+		}
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
+}
+
+static int nd_acpi_add_dimm(struct nfit_bus_descriptor *nfit_desc,
+		struct nd_dimm *nd_dimm)
+{
+	struct acpi_nfit *nfit = to_acpi_nfit(nfit_desc);
+	u32 nfit_handle = to_nfit_handle(nd_dimm);
+	struct device *dev = &nfit->dev->dev;
+	struct acpi_device *acpi_dimm;
+	unsigned long dsm_mask = 0;
+	u8 *uuid = nd_acpi_dimm_uuid();
+	unsigned long long sta;
+	int i, rc = -ENODEV;
+	acpi_status status;
+
+	acpi_dimm = acpi_find_child_device(nfit->dev, nfit_handle, false);
+	if (!acpi_dimm) {
+		dev_err(dev, "no ACPI.NFIT device with _ADR %#x, disabling...\n",
+				nfit_handle);
+		return -ENODEV;
+	}
+
+	status = acpi_evaluate_integer(acpi_dimm->handle, "_STA", NULL, &sta);
+	if (status == AE_NOT_FOUND)
+		dev_err(dev, "%s missing _STA, disabling...\n",
+				dev_name(&acpi_dimm->dev));
+	else if (ACPI_FAILURE(status))
+		dev_err(dev, "%s failed to retrieve_STA, disabling...\n",
+				dev_name(&acpi_dimm->dev));
+	else if ((sta & ACPI_STA_DEVICE_ENABLED) == 0)
+		dev_info(dev, "%s disabled by firmware\n",
+				dev_name(&acpi_dimm->dev));
+	else
+		rc = 0;
+
+	for (i = NFIT_CMD_SMART; i <= NFIT_CMD_VENDOR; i++)
+		if (acpi_check_dsm(acpi_dimm->handle, uuid, 1, 1ULL << i))
+			set_bit(i, &dsm_mask);
+	nd_dimm_set_dsm_mask(nd_dimm, dsm_mask);
+	nd_dimm_set_pdata(nd_dimm, acpi_dimm);
+	return rc;
 }
 
 static int nd_acpi_add(struct acpi_device *dev)
 {
 	struct nfit_bus_descriptor *nfit_desc;
 	struct acpi_table_header *tbl;
+	u8 *uuid = nd_acpi_bus_uuid();
 	acpi_status status = AE_OK;
 	struct acpi_nfit *nfit;
 	acpi_size sz;
+	int i;
 
 	status = acpi_get_table_with_size("NFIT", 0, &tbl, &sz);
 	if (ACPI_FAILURE(status)) {
@@ -56,6 +368,11 @@ static int nd_acpi_add(struct acpi_device *dev)
 	nfit_desc->nfit_size = sz;
 	nfit_desc->provider_name = "ACPI.NFIT";
 	nfit_desc->nfit_ctl = nd_acpi_ctl;
+	nfit_desc->add_dimm = nd_acpi_add_dimm;
+
+	for (i = NFIT_CMD_ARS_CAP; i <= NFIT_CMD_ARS_QUERY; i++)
+		if (acpi_check_dsm(dev->handle, uuid, 1, 1ULL << i))
+			set_bit(i, &nfit_desc->dsm_mask);
 
 	nfit->nd_bus = nfit_bus_register(&dev->dev, nfit_desc);
 	if (!nfit->nd_bus)
@@ -98,6 +415,20 @@ static struct acpi_driver nd_acpi_driver = {
 
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
+	for (i = 0; i < ARRAY_SIZE(uuids); i++)
+		if (acpi_str_to_uuid(uuids[i], nd_acpi_uuids[i]) != AE_OK) {
+			WARN_ON_ONCE(1);
+			return -ENXIO;
+		}
+
 	return acpi_bus_register_driver(&nd_acpi_driver);
 }
 
diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
index e24db67001d0..67a0624c265b 100644
--- a/drivers/block/nd/bus.c
+++ b/drivers/block/nd/bus.c
@@ -11,15 +11,20 @@
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
 #include "nfit.h"
+#include "nd.h"
 
+int nd_dimm_major;
 static int nd_bus_major;
 static struct class *nd_class;
 
@@ -84,19 +89,228 @@ void nd_bus_destroy_ndctl(struct nd_bus *nd_bus)
 	device_destroy(nd_class, MKDEV(nd_bus_major, nd_bus->id));
 }
 
+static int __nd_ioctl(struct nd_bus *nd_bus, struct nd_dimm *nd_dimm,
+		int read_only, unsigned int cmd, unsigned long arg)
+{
+	struct nfit_bus_descriptor *nfit_desc = nd_bus->nfit_desc;
+	void __user *p = (void __user *) arg;
+	unsigned long dsm_mask;
+	size_t buf_len = 0;
+	void *buf = NULL;
+	int rc;
+
+	/* check if the command is supported */
+	dsm_mask = nd_dimm ? nd_dimm->dsm_mask : nfit_desc->dsm_mask;
+	if (!test_bit(_IOC_NR(cmd), &dsm_mask))
+		return -ENXIO;
+
+	/* fail write commands (when read-only), or unknown commands */
+	switch (cmd) {
+	case NFIT_IOCTL_VENDOR:
+	case NFIT_IOCTL_SET_CONFIG_DATA:
+	case NFIT_IOCTL_ARS_START:
+		if (read_only)
+			return -EPERM;
+		/* fallthrough */
+	case NFIT_IOCTL_SMART:
+	case NFIT_IOCTL_DIMM_FLAGS:
+	case NFIT_IOCTL_GET_CONFIG_SIZE:
+	case NFIT_IOCTL_GET_CONFIG_DATA:
+	case NFIT_IOCTL_ARS_CAP:
+	case NFIT_IOCTL_ARS_QUERY:
+	case NFIT_IOCTL_SMART_THRESHOLD:
+		break;
+	default:
+		pr_debug("%s: unknown cmd: %d\n", __func__, _IOC_NR(cmd));
+		return -ENOTTY;
+	}
+
+	/* validate input buffer / determine size */
+	switch (cmd) {
+	case NFIT_IOCTL_SMART:
+		buf_len = sizeof(struct nfit_cmd_smart);
+		break;
+	case NFIT_IOCTL_DIMM_FLAGS:
+		buf_len = sizeof(struct nfit_cmd_dimm_flags);
+		break;
+	case NFIT_IOCTL_VENDOR: {
+		struct nfit_cmd_vendor_hdr nfit_cmd_v;
+		struct nfit_cmd_vendor_tail nfit_cmd_vt;
+
+		if (!access_ok(VERIFY_WRITE, p, sizeof(nfit_cmd_v)))
+			return -EFAULT;
+		if (copy_from_user(&nfit_cmd_v, p, sizeof(nfit_cmd_v)))
+			return -EFAULT;
+		buf_len = sizeof(nfit_cmd_v) + nfit_cmd_v.in_length;
+		if (!access_ok(VERIFY_WRITE, p + buf_len, sizeof(nfit_cmd_vt)))
+			return -EFAULT;
+		if (copy_from_user(&nfit_cmd_vt, p + buf_len,
+					sizeof(nfit_cmd_vt)))
+			return -EFAULT;
+		buf_len += sizeof(nfit_cmd_vt) + nfit_cmd_vt.out_length;
+		break;
+	}
+	case NFIT_IOCTL_SET_CONFIG_DATA: {
+		struct nfit_cmd_set_config_hdr nfit_cmd_set;
+
+		if (!access_ok(VERIFY_WRITE, p, sizeof(nfit_cmd_set)))
+			return -EFAULT;
+		if (copy_from_user(&nfit_cmd_set, p, sizeof(nfit_cmd_set)))
+			return -EFAULT;
+		/* include input buffer size and trailing status */
+		buf_len = sizeof(nfit_cmd_set) + nfit_cmd_set.in_length + 4;
+		break;
+	}
+	case NFIT_IOCTL_ARS_START:
+		buf_len = sizeof(struct nfit_cmd_ars_start);
+		break;
+	case NFIT_IOCTL_GET_CONFIG_SIZE:
+		buf_len = sizeof(struct nfit_cmd_get_config_size);
+		break;
+	case NFIT_IOCTL_GET_CONFIG_DATA: {
+		struct nfit_cmd_get_config_data_hdr nfit_cmd_get;
+
+		if (!access_ok(VERIFY_WRITE, p, sizeof(nfit_cmd_get)))
+			return -EFAULT;
+		if (copy_from_user(&nfit_cmd_get, p, sizeof(nfit_cmd_get)))
+			return -EFAULT;
+		buf_len = sizeof(nfit_cmd_get) + nfit_cmd_get.in_length;
+		break;
+	}
+	case NFIT_IOCTL_ARS_CAP:
+		buf_len = sizeof(struct nfit_cmd_ars_cap);
+		break;
+	case NFIT_IOCTL_ARS_QUERY: {
+		struct nfit_cmd_ars_query nfit_cmd_query;
+
+		if (!access_ok(VERIFY_WRITE, p, sizeof(nfit_cmd_query)))
+			return -EFAULT;
+		if (copy_from_user(&nfit_cmd_query, p, sizeof(nfit_cmd_query)))
+			return -EFAULT;
+		buf_len = sizeof(nfit_cmd_query) + nfit_cmd_query.out_length
+			- offsetof(struct nfit_cmd_ars_query, out_length);
+		break;
+	}
+	case NFIT_IOCTL_SMART_THRESHOLD:
+		buf_len = sizeof(struct nfit_cmd_smart_threshold);
+		break;
+	}
+
+	if (!access_ok(VERIFY_WRITE, p, sizeof(buf_len)))
+		return -EFAULT;
+
+	if (buf_len > ND_IOCTL_MAX_BUFLEN) {
+		pr_debug("%s: buf_len: %zd > %d\n",
+				__func__, buf_len, ND_IOCTL_MAX_BUFLEN);
+		return -EINVAL;
+	}
+
+	if (buf_len < KMALLOC_MAX_SIZE)
+		buf = kmalloc(buf_len, GFP_KERNEL);
+
+	if (!buf)
+		buf = vmalloc(buf_len);
+
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, p, buf_len)) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	rc = nfit_desc->nfit_ctl(nfit_desc, nd_dimm, _IOC_NR(cmd), buf, buf_len);
+	if (rc < 0)
+		goto out;
+	if (copy_to_user(p, buf, buf_len))
+		rc = -EFAULT;
+ out:
+	if (is_vmalloc_addr(buf))
+		vfree(buf);
+	else
+		kfree(buf);
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
@@ -107,9 +321,14 @@ int __init nd_bus_init(void)
 
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
@@ -117,8 +336,10 @@ int __init nd_bus_init(void)
 	return 0;
 
  err_class:
+	unregister_chrdev(nd_dimm_major, "dimmctl");
+ err_dimm_chrdev:
 	unregister_chrdev(nd_bus_major, "ndctl");
- err_chrdev:
+ err_bus_chrdev:
 	bus_unregister(&nd_bus_type);
 
 	return rc;
@@ -128,5 +349,6 @@ void __exit nd_bus_exit(void)
 {
 	class_destroy(nd_class);
 	unregister_chrdev(nd_bus_major, "ndctl");
+	unregister_chrdev(nd_dimm_major, "dimmctl");
 	bus_unregister(&nd_bus_type);
 }
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index a0d1623b3641..0df1e82fcb18 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -14,12 +14,14 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/ndctl.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/uuid.h>
 #include <linux/io.h>
 #include "nd-private.h"
 #include "nfit.h"
+#include "nd.h"
 
 LIST_HEAD(nd_bus_list);
 DEFINE_MUTEX(nd_bus_list_mutex);
@@ -102,6 +104,20 @@ struct nd_bus *walk_to_nd_bus(struct device *nd_dev)
 	return NULL;
 }
 
+static ssize_t commands_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int cmd, len = 0;
+	struct nd_bus *nd_bus = to_nd_bus(dev);
+	struct nfit_bus_descriptor *nfit_desc = nd_bus->nfit_desc;
+
+	for_each_set_bit(cmd, &nfit_desc->dsm_mask, BITS_PER_LONG)
+		len += sprintf(buf + len, "%s ", nfit_bus_cmd_name(cmd));
+	len += sprintf(buf + len, "\n");
+	return len;
+}
+static DEVICE_ATTR_RO(commands);
+
 static const char *nd_bus_provider(struct nd_bus *nd_bus)
 {
 	struct nfit_bus_descriptor *nfit_desc = nd_bus->nfit_desc;
@@ -135,6 +151,7 @@ static ssize_t revision_show(struct device *dev,
 static DEVICE_ATTR_RO(revision);
 
 static struct attribute *nd_bus_attributes[] = {
+	&dev_attr_commands.attr,
 	&dev_attr_provider.attr,
 	&dev_attr_revision.attr,
 	NULL,
diff --git a/drivers/block/nd/dimm_devs.c b/drivers/block/nd/dimm_devs.c
index b74b23c297fb..b73006cfbf66 100644
--- a/drivers/block/nd/dimm_devs.c
+++ b/drivers/block/nd/dimm_devs.c
@@ -12,12 +12,14 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/device.h>
+#include <linux/ndctl.h>
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include "nd-private.h"
 #include "nfit.h"
+#include "nd.h"
 
 static DEFINE_IDA(dimm_ida);
 
@@ -35,7 +37,7 @@ static struct device_type nd_dimm_device_type = {
 	.release = nd_dimm_release,
 };
 
-static bool is_nd_dimm(struct device *dev)
+bool is_nd_dimm(struct device *dev)
 {
 	return dev->type == &nd_dimm_device_type;
 }
@@ -66,12 +68,48 @@ static struct nfit_dcr __iomem *to_nfit_dcr(struct device *dev)
 	return nfit_dcr;
 }
 
+u32 to_nfit_handle(struct nd_dimm *nd_dimm)
+{
+	struct nfit_mem __iomem *nfit_mem = nd_dimm->nd_mem->nfit_mem_dcr;
+
+	return readl(&nfit_mem->nfit_handle);
+}
+EXPORT_SYMBOL(to_nfit_handle);
+
+void *nd_dimm_get_pdata(struct nd_dimm *nd_dimm)
+{
+	if (nd_dimm)
+		return nd_dimm->provider_data;
+	return NULL;
+}
+EXPORT_SYMBOL(nd_dimm_get_pdata);
+
+void nd_dimm_set_pdata(struct nd_dimm *nd_dimm, void *data)
+{
+	if (nd_dimm)
+		nd_dimm->provider_data = data;
+}
+EXPORT_SYMBOL(nd_dimm_set_pdata);
+
+unsigned long nd_dimm_get_dsm_mask(struct nd_dimm *nd_dimm)
+{
+	if (nd_dimm)
+		return nd_dimm->dsm_mask;
+	return 0;
+}
+EXPORT_SYMBOL(nd_dimm_get_dsm_mask);
+
+void nd_dimm_set_dsm_mask(struct nd_dimm *nd_dimm, unsigned long dsm_mask)
+{
+	if (nd_dimm)
+		nd_dimm->dsm_mask = dsm_mask;
+}
+EXPORT_SYMBOL(nd_dimm_set_dsm_mask);
+
 static ssize_t handle_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nfit_mem __iomem *nfit_mem = to_nfit_mem(dev);
-
-	return sprintf(buf, "%#x\n", readl(&nfit_mem->nfit_handle));
+	return sprintf(buf, "%#x\n", to_nfit_handle(to_nd_dimm(dev)));
 }
 static DEVICE_ATTR_RO(handle);
 
@@ -129,6 +167,19 @@ static ssize_t serial_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(serial);
 
+static ssize_t commands_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_dimm *nd_dimm = to_nd_dimm(dev);
+	int cmd, len = 0;
+
+	for_each_set_bit(cmd, &nd_dimm->dsm_mask, BITS_PER_LONG)
+		len += sprintf(buf + len, "%s ", nfit_dimm_cmd_name(cmd));
+	len += sprintf(buf + len, "\n");
+	return len;
+}
+static DEVICE_ATTR_RO(commands);
+
 static struct attribute *nd_dimm_attributes[] = {
 	&dev_attr_handle.attr,
 	&dev_attr_phys_id.attr,
@@ -137,6 +188,7 @@ static struct attribute *nd_dimm_attributes[] = {
 	&dev_attr_format.attr,
 	&dev_attr_serial.attr,
 	&dev_attr_revision.attr,
+	&dev_attr_commands.attr,
 	NULL,
 };
 
@@ -166,6 +218,7 @@ static struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus,
 		struct nd_mem *nd_mem)
 {
 	struct nd_dimm *nd_dimm = kzalloc(sizeof(*nd_dimm), GFP_KERNEL);
+	struct nfit_bus_descriptor *nfit_desc = nd_bus->nfit_desc;
 	struct device *dev;
 	u32 nfit_handle;
 
@@ -193,6 +246,14 @@ static struct nd_dimm *nd_dimm_create(struct nd_bus *nd_bus,
 	dev->type = &nd_dimm_device_type;
 	dev->bus = &nd_bus_type;
 	dev->groups = nd_dimm_attribute_groups;
+	dev->devt = MKDEV(nd_dimm_major, nd_dimm->id);
+	if (nfit_desc->add_dimm)
+		if (nfit_desc->add_dimm(nfit_desc, nd_dimm) != 0) {
+			device_initialize(dev);
+			put_device(dev);
+			return NULL;
+		}
+
 	if (device_register(dev) != 0) {
 		put_device(dev);
 		return NULL;
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index 58a52c03f5ee..31239942b724 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -14,9 +14,17 @@
 #define __ND_PRIVATE_H__
 #include <linux/radix-tree.h>
 #include <linux/device.h>
+#include <linux/sizes.h>
+
 extern struct list_head nd_bus_list;
 extern struct mutex nd_bus_list_mutex;
 extern struct bus_type nd_bus_type;
+extern int nd_dimm_major;
+
+enum {
+	/* need to set a limit somewhere, but yes, this is likely overkill */
+	ND_IOCTL_MAX_BUFLEN = SZ_4M,
+};
 
 struct nd_bus {
 	struct nfit_bus_descriptor *nfit_desc;
@@ -32,8 +40,10 @@ struct nd_bus {
 };
 
 struct nd_dimm {
+	unsigned long dsm_mask;
 	struct nd_mem *nd_mem;
 	struct device dev;
+	void *provider_data;
 	int id;
 	struct nd_dimm_delete {
 		struct nd_bus *nd_bus;
@@ -72,6 +82,7 @@ struct nd_mem {
 };
 
 struct nd_dimm *nd_dimm_by_handle(struct nd_bus *nd_bus, u32 nfit_handle);
+bool is_nd_dimm(struct device *dev);
 struct nd_bus *to_nd_bus(struct device *dev);
 struct nd_dimm *to_nd_dimm(struct device *dev);
 struct nd_bus *walk_to_nd_bus(struct device *nd_dev);
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
new file mode 100644
index 000000000000..bf6313fffd4c
--- /dev/null
+++ b/drivers/block/nd/nd.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __ND_H__
+#define __ND_H__
+struct nd_dimm;
+u32 to_nfit_handle(struct nd_dimm *nd_dimm);
+void *nd_dimm_get_pdata(struct nd_dimm *nd_dimm);
+void nd_dimm_set_pdata(struct nd_dimm *nd_dimm, void *data);
+unsigned long nd_dimm_get_dsm_mask(struct nd_dimm *nd_dimm);
+void nd_dimm_set_dsm_mask(struct nd_dimm *nd_dimm, unsigned long dsm_mask);
+#endif /* __ND_H__ */
diff --git a/drivers/block/nd/test/nfit.c b/drivers/block/nd/test/nfit.c
index 61227dec111a..e9fb9da765b9 100644
--- a/drivers/block/nd/test/nfit.c
+++ b/drivers/block/nd/test/nfit.c
@@ -14,10 +14,12 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
+#include <linux/ndctl.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include "nfit_test.h"
 #include "../nfit.h"
+#include "../nd.h"
 
 #include <asm-generic/io-64-nonatomic-lo-hi.h>
 
@@ -138,11 +140,94 @@ static struct nfit_test *to_nfit_test(struct device *dev)
 	return container_of(pdev, struct nfit_test, pdev);
 }
 
+static int nfit_test_add_dimm(struct nfit_bus_descriptor *nfit_desc,
+		struct nd_dimm *nd_dimm)
+{
+	u32 nfit_handle = to_nfit_handle(nd_dimm);
+	unsigned long dsm_mask = 0;
+	long i;
+
+	for (i = 0; i < ARRAY_SIZE(handle); i++)
+		if (nfit_handle == handle[i])
+			break;
+	if (i >= ARRAY_SIZE(handle))
+		return -EINVAL;
+
+	set_bit(NFIT_CMD_GET_CONFIG_SIZE, &dsm_mask);
+	set_bit(NFIT_CMD_GET_CONFIG_DATA, &dsm_mask);
+	set_bit(NFIT_CMD_SET_CONFIG_DATA, &dsm_mask);
+	nd_dimm_set_dsm_mask(nd_dimm, dsm_mask);
+	nd_dimm_set_pdata(nd_dimm, (void *) i);
+	return 0;
+}
+
 static int nfit_test_ctl(struct nfit_bus_descriptor *nfit_desc,
 		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
 		unsigned int buf_len)
 {
-	return -ENOTTY;
+	struct nfit_test *t = container_of(nfit_desc, typeof(*t), nfit_desc);
+	unsigned long dsm_mask = nd_dimm_get_dsm_mask(nd_dimm);
+	int i, rc;
+
+	if (!nd_dimm || !test_bit(cmd, &dsm_mask))
+		return -ENXIO;
+
+	/* lookup label space for the given dimm */
+	i = (long) nd_dimm_get_pdata(nd_dimm);
+
+	switch (cmd) {
+	case NFIT_CMD_GET_CONFIG_SIZE: {
+		struct nfit_cmd_get_config_size *nfit_cmd = buf;
+
+		if (buf_len < sizeof(*nfit_cmd))
+			return -EINVAL;
+		nfit_cmd->status = 0;
+		nfit_cmd->config_size = LABEL_SIZE;
+		nfit_cmd->max_xfer = SZ_4K;
+		rc = 0;
+		break;
+	}
+	case NFIT_CMD_GET_CONFIG_DATA: {
+		struct nfit_cmd_get_config_data_hdr *nfit_cmd = buf;
+		unsigned int len, offset = nfit_cmd->in_offset;
+
+		if (buf_len < sizeof(*nfit_cmd))
+			return -EINVAL;
+		if (offset >= LABEL_SIZE)
+			return -EINVAL;
+		if (nfit_cmd->in_length + sizeof(*nfit_cmd) > buf_len)
+			return -EINVAL;
+
+		nfit_cmd->status = 0;
+		len = min(nfit_cmd->in_length, LABEL_SIZE - offset);
+		memcpy(nfit_cmd->out_buf, t->label[i] + offset, len);
+		rc = buf_len - sizeof(*nfit_cmd) - len;
+		break;
+	}
+	case NFIT_CMD_SET_CONFIG_DATA: {
+		struct nfit_cmd_set_config_hdr *nfit_cmd = buf;
+		unsigned int len, offset = nfit_cmd->in_offset;
+		u32 *status;
+
+		if (buf_len < sizeof(*nfit_cmd))
+			return -EINVAL;
+		if (offset >= LABEL_SIZE)
+			return -EINVAL;
+		if (nfit_cmd->in_length + sizeof(*nfit_cmd) + 4 > buf_len)
+			return -EINVAL;
+
+		status = buf + nfit_cmd->in_length + sizeof(*nfit_cmd);
+		*status = 0;
+		len = min(nfit_cmd->in_length, LABEL_SIZE - offset);
+		memcpy(t->label[i] + offset, nfit_cmd->in_buf, len);
+		rc = buf_len - sizeof(*nfit_cmd) - (len + 4);
+		break;
+	}
+	default:
+		return -ENOTTY;
+	}
+
+	return rc;
 }
 
 static DEFINE_SPINLOCK(nfit_test_lock);
@@ -234,6 +319,7 @@ static int nfit_test0_alloc(struct nfit_test *t)
 		t->label[i] = alloc_coherent(t, LABEL_SIZE, &t->label_dma[i]);
 		if (!t->label[i])
 			return -ENOMEM;
+		sprintf(t->label[i], "label%d", i);
 	}
 
 	for (i = 0; i < NUM_DCR; i++) {
@@ -726,6 +812,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 
 	nfit_desc = &t->nfit_desc;
 	nfit_desc->nfit_ctl = nfit_test_ctl;
+	nfit_desc->add_dimm = nfit_test_add_dimm;
 }
 
 static void nfit_test1_setup(struct nfit_test *t)
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
index 000000000000..6cc8c91a0058
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
+struct nfit_cmd_smart {
+	__u32 status;
+	__u8 data[128];
+} __packed;
+
+struct nfit_cmd_smart_threshold {
+	__u32 status;
+	__u8 data[8];
+} __packed;
+
+struct nfit_cmd_dimm_flags {
+	__u32 status;
+	__u32 flags;
+} __packed;
+
+struct nfit_cmd_get_config_size {
+	__u32 status;
+	__u32 config_size;
+	__u32 max_xfer;
+} __packed;
+
+struct nfit_cmd_get_config_data_hdr {
+	__u32 in_offset;
+	__u32 in_length;
+	__u32 status;
+	__u8 out_buf[0];
+} __packed;
+
+struct nfit_cmd_set_config_hdr {
+	__u32 in_offset;
+	__u32 in_length;
+	__u8 in_buf[0];
+} __packed;
+
+struct nfit_cmd_vendor_hdr {
+	__u32 opcode;
+	__u32 in_length;
+	__u8 in_buf[0];
+} __packed;
+
+struct nfit_cmd_vendor_tail {
+	__u32 status;
+	__u32 out_length;
+	__u8 out_buf[0];
+} __packed;
+
+struct nfit_cmd_ars_cap {
+	__u64 address;
+	__u64 length;
+	__u32 status;
+	__u32 max_ars_out;
+} __packed;
+
+struct nfit_cmd_ars_start {
+	__u64 address;
+	__u64 length;
+	__u16 type;
+	__u8 reserved[6];
+	__u32 status;
+} __packed;
+
+struct nfit_cmd_ars_query {
+	__u32 status;
+	__u16 out_length;
+	__u64 address;
+	__u64 length;
+	__u16 type;
+	__u32 num_records;
+	struct nfit_ars_record {
+		__u32 nfit_handle;
+		__u32 flags;
+		__u64 err_address;
+		__u64 mask;
+	} __packed records[0];
+} __packed;
+
+enum {
+	NFIT_CMD_IMPLEMENTED = 0,
+
+	/* bus commands */
+	NFIT_CMD_ARS_CAP = 1,
+	NFIT_CMD_ARS_START = 2,
+	NFIT_CMD_ARS_QUERY = 3,
+
+	/* per-dimm commands */
+	NFIT_CMD_SMART = 1,
+	NFIT_CMD_SMART_THRESHOLD = 2,
+	NFIT_CMD_DIMM_FLAGS = 3,
+	NFIT_CMD_GET_CONFIG_SIZE = 4,
+	NFIT_CMD_GET_CONFIG_DATA = 5,
+	NFIT_CMD_SET_CONFIG_DATA = 6,
+	NFIT_CMD_VENDOR_EFFECT_LOG_SIZE = 7,
+	NFIT_CMD_VENDOR_EFFECT_LOG = 8,
+	NFIT_CMD_VENDOR = 9,
+};
+
+static inline const char *nfit_bus_cmd_name(unsigned cmd)
+{
+	static const char * const names[] = {
+		[NFIT_CMD_ARS_CAP] = "ars_cap",
+		[NFIT_CMD_ARS_START] = "ars_start",
+		[NFIT_CMD_ARS_QUERY] = "ars_query",
+	};
+
+	if (cmd < ARRAY_SIZE(names) && names[cmd])
+		return names[cmd];
+	return "unknown";
+}
+
+static inline const char *nfit_dimm_cmd_name(unsigned cmd)
+{
+	static const char * const names[] = {
+		[NFIT_CMD_SMART] = "smart",
+		[NFIT_CMD_SMART_THRESHOLD] = "smart_thresh",
+		[NFIT_CMD_DIMM_FLAGS] = "flags",
+		[NFIT_CMD_GET_CONFIG_SIZE] = "get_size",
+		[NFIT_CMD_GET_CONFIG_DATA] = "get_data",
+		[NFIT_CMD_SET_CONFIG_DATA] = "set_data",
+		[NFIT_CMD_VENDOR_EFFECT_LOG_SIZE] = "effect_size",
+		[NFIT_CMD_VENDOR_EFFECT_LOG] = "effect_log",
+		[NFIT_CMD_VENDOR] = "vendor",
+	};
+
+	if (cmd < ARRAY_SIZE(names) && names[cmd])
+		return names[cmd];
+	return "unknown";
+}
+
+#define ND_IOCTL 'N'
+
+#define NFIT_IOCTL_SMART		_IOWR(ND_IOCTL, NFIT_CMD_SMART,\
+					struct nfit_cmd_smart)
+
+#define NFIT_IOCTL_SMART_THRESHOLD	_IOWR(ND_IOCTL, NFIT_CMD_SMART_THRESHOLD,\
+					struct nfit_cmd_smart_threshold)
+
+#define NFIT_IOCTL_DIMM_FLAGS		_IOWR(ND_IOCTL, NFIT_CMD_DIMM_FLAGS,\
+					struct nfit_cmd_dimm_flags)
+
+#define NFIT_IOCTL_GET_CONFIG_SIZE	_IOWR(ND_IOCTL, NFIT_CMD_GET_CONFIG_SIZE,\
+					struct nfit_cmd_get_config_size)
+
+#define NFIT_IOCTL_GET_CONFIG_DATA	_IOWR(ND_IOCTL, NFIT_CMD_GET_CONFIG_DATA,\
+					struct nfit_cmd_get_config_data_hdr)
+
+#define NFIT_IOCTL_SET_CONFIG_DATA	_IOWR(ND_IOCTL, NFIT_CMD_SET_CONFIG_DATA,\
+					struct nfit_cmd_set_config_hdr)
+
+#define NFIT_IOCTL_VENDOR		_IOWR(ND_IOCTL, NFIT_CMD_VENDOR,\
+					struct nfit_cmd_vendor_hdr)
+
+#define NFIT_IOCTL_ARS_CAP		_IOWR(ND_IOCTL, NFIT_CMD_ARS_CAP,\
+					struct nfit_cmd_ars_cap)
+
+#define NFIT_IOCTL_ARS_START		_IOWR(ND_IOCTL, NFIT_CMD_ARS_START,\
+					struct nfit_cmd_ars_start)
+
+#define NFIT_IOCTL_ARS_QUERY		_IOWR(ND_IOCTL, NFIT_CMD_ARS_QUERY,\
+					struct nfit_cmd_ars_query)
+
+#endif /* __NDCTL_H__ */

