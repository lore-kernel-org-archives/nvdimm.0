Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1429651258.17259.60.camel@misato.fc.hp.com>
Subject: Re: [Linux-nvdimm] [PATCH 08/21] nd: ndctl.h, the nd ioctl abi
From: Toshi Kani <toshi.kani@hp.com>
Date: Tue, 21 Apr 2015 15:20:58 -0600
In-Reply-To: <20150418013557.25237.81354.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150418013557.25237.81354.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2015-04-17 at 21:35 -0400, Dan Williams wrote:
> Most configuration of the nd-subsystem is done via nd-sysfs.  However,
> the NFIT specification defines a small set of messages that can be
> passed to the subsystem via platform-firmware-defined methods.  The
> command set (as of the current version of the NFIT-DSM spec) is:
> 
>     NFIT_CMD_SMART: media health and diagnostics
>     NFIT_CMD_GET_CONFIG_SIZE: size of the label space
>     NFIT_CMD_GET_CONFIG_DATA: read label
>     NFIT_CMD_SET_CONFIG_DATA: write label
>     NFIT_CMD_VENDOR: vendor-specific command passthrough
>     NFIT_CMD_ARS_CAP: report address-range-scrubbing capabilities
>     NFIT_CMD_START_ARS: initiate scrubbing
>     NFIT_CMD_QUERY_ARS: report on scrubbing state
>     NFIT_CMD_SMART_THRESHOLD: configure alarm thresholds for smart events
> 
> Most of the commands target a specific dimm.  However, the
> address-range-scrubbing commands target the entire NFIT-bus / platform.
> The 'commands' attribute of an nd-bus, or an nd-dimm enumerate the
> supported commands for that object.
> 
> Cc: <linux-acpi@vger.kernel.org>
> Cc: Robert Moore <robert.moore@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reported-by: Nicholas Moulin <nicholas.w.moulin@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/block/nd/Kconfig      |   11 +
>  drivers/block/nd/acpi.c       |  333 +++++++++++++++++++++++++++++++++++++++++
>  drivers/block/nd/bus.c        |  230 ++++++++++++++++++++++++++++
>  drivers/block/nd/core.c       |   17 ++
>  drivers/block/nd/dimm_devs.c  |   69 ++++++++
>  drivers/block/nd/nd-private.h |   11 +
>  drivers/block/nd/nd.h         |   21 +++
>  drivers/block/nd/test/nfit.c  |   89 +++++++++++
>  include/uapi/linux/Kbuild     |    1 
>  include/uapi/linux/ndctl.h    |  178 ++++++++++++++++++++++
>  10 files changed, 950 insertions(+), 10 deletions(-)
>  create mode 100644 drivers/block/nd/nd.h
>  create mode 100644 include/uapi/linux/ndctl.h
> 
> diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
> index 0106b3807202..6c15d10bf4e0 100644
> --- a/drivers/block/nd/Kconfig
> +++ b/drivers/block/nd/Kconfig
> @@ -42,6 +42,17 @@ config NFIT_ACPI
>  	  enables the core to craft ACPI._DSM messages for platform/dimm
>  	  configuration.
>  
> +config NFIT_ACPI_DEBUG
> +	bool "NFIT ACPI: Turn on extra debugging"
> +	depends on NFIT_ACPI
> +	depends on DYNAMIC_DEBUG
> +	default n
> +	help
> +	  Enabling this option causes the nd_acpi driver to dump the
> +	  input and output buffers of _DSM operations on the ACPI0012
> +	  device, which can be very verbose.  Leave it disabled unless
> +	  you are debugging a hardware / firmware issue.
> +
>  config NFIT_TEST
>  	tristate "NFIT TEST: Manufactured NFIT for interface testing"
>  	depends on DMA_CMA
> diff --git a/drivers/block/nd/acpi.c b/drivers/block/nd/acpi.c
> index 48db723d7a90..073ff28fdbfe 100644
> --- a/drivers/block/nd/acpi.c
> +++ b/drivers/block/nd/acpi.c
> @@ -13,8 +13,10 @@
>  #include <linux/list.h>
>  #include <linux/acpi.h>
>  #include <linux/mutex.h>
> +#include <linux/ndctl.h>
>  #include <linux/module.h>
>  #include "nfit.h"
> +#include "nd.h"
>  
>  enum {
>  	NFIT_ACPI_NOTIFY_TABLE = 0x80,
> @@ -26,20 +28,330 @@ struct acpi_nfit {
>  	struct nd_bus *nd_bus;
>  };
>  
> +static struct acpi_nfit *to_acpi_nfit(struct nfit_bus_descriptor *nfit_desc)
> +{
> +	return container_of(nfit_desc, struct acpi_nfit, nfit_desc);
> +}
> +
> +#define NFIT_ACPI_MAX_ELEM 4
> +struct nfit_cmd_desc {
> +	int in_num;
> +	int out_num;
> +	u32 in_sizes[NFIT_ACPI_MAX_ELEM];
> +	int out_sizes[NFIT_ACPI_MAX_ELEM];
> +};
> +
> +static const struct nfit_cmd_desc nfit_dimm_descs[] = {
> +	[NFIT_CMD_IMPLEMENTED] = { },
> +	[NFIT_CMD_SMART] = {
> +		.out_num = 2,
> +		.out_sizes = { 4, 8, },
> +	},
> +	[NFIT_CMD_SMART_THRESHOLD] = {
> +		.out_num = 2,
> +		.out_sizes = { 4, 8, },
> +	},
> +	[NFIT_CMD_DIMM_FLAGS] = {
> +		.out_num = 2,
> +		.out_sizes = { 4, 4 },
> +	},
> +	[NFIT_CMD_GET_CONFIG_SIZE] = {
> +		.out_num = 3,
> +		.out_sizes = { 4, 4, 4, },
> +	},
> +	[NFIT_CMD_GET_CONFIG_DATA] = {
> +		.in_num = 2,
> +		.in_sizes = { 4, 4, },
> +		.out_num = 2,
> +		.out_sizes = { 4, UINT_MAX, },
> +	},
> +	[NFIT_CMD_SET_CONFIG_DATA] = {
> +		.in_num = 3,
> +		.in_sizes = { 4, 4, UINT_MAX, },
> +		.out_num = 1,
> +		.out_sizes = { 4, },
> +	},
> +	[NFIT_CMD_VENDOR] = {
> +		.in_num = 3,
> +		.in_sizes = { 4, 4, UINT_MAX, },
> +		.out_num = 3,
> +		.out_sizes = { 4, 4, UINT_MAX, },
> +	},
> +};
> +
> +static const struct nfit_cmd_desc nfit_acpi_descs[] = {
> +	[NFIT_CMD_IMPLEMENTED] = { },
> +	[NFIT_CMD_ARS_CAP] = {
> +		.in_num = 2,
> +		.in_sizes = { 8, 8, },
> +		.out_num = 2,
> +		.out_sizes = { 4, 4, },
> +	},
> +	[NFIT_CMD_ARS_START] = {
> +		.in_num = 4,
> +		.in_sizes = { 8, 8, 2, 6, },
> +		.out_num = 1,
> +		.out_sizes = { 4, },
> +	},
> +	[NFIT_CMD_ARS_QUERY] = {
> +		.out_num = 2,
> +		.out_sizes = { 4, UINT_MAX, },
> +	},
> +};
> +
> +static u32 to_cmd_in_size(struct nd_dimm *nd_dimm, int cmd,
> +		const struct nfit_cmd_desc *desc, int idx, void *buf)
> +{
> +	if (idx >= desc->in_num)
> +		return UINT_MAX;
> +
> +	if (desc->in_sizes[idx] < UINT_MAX)
> +		return desc->in_sizes[idx];
> +
> +	if (nd_dimm && cmd == NFIT_CMD_SET_CONFIG_DATA && idx == 2) {
> +		struct nfit_cmd_set_config_hdr *hdr = buf;
> +
> +		return hdr->in_length;
> +	} else if (nd_dimm && cmd == NFIT_CMD_VENDOR && idx == 2) {
> +		struct nfit_cmd_vendor_hdr *hdr = buf;
> +
> +		return hdr->in_length;
> +	}
> +
> +	return UINT_MAX;
> +}
> +
> +static u32 to_cmd_out_size(struct nd_dimm *nd_dimm, int cmd,
> +		const struct nfit_cmd_desc *desc, int idx,
> +		void *buf, u32 out_length, u32 offset)
> +{
> +	if (idx >= desc->out_num)
> +		return UINT_MAX;
> +
> +	if (desc->out_sizes[idx] < UINT_MAX)
> +		return desc->out_sizes[idx];
> +
> +	if (offset >= out_length)
> +		return UINT_MAX;
> +
> +	if (nd_dimm && cmd == NFIT_CMD_GET_CONFIG_DATA && idx == 1)
> +		return out_length - offset;
> +	else if (nd_dimm && cmd == NFIT_CMD_VENDOR && idx == 2)
> +		return out_length - offset;
> +	else if (!nd_dimm && cmd == NFIT_CMD_ARS_QUERY && idx == 1)
> +		return out_length - offset;
> +
> +	return UINT_MAX;
> +}
> +
> +static u8 nd_acpi_uuids[2][16]; /* initialized at nd_acpi_init */
> +
> +static u8 *nd_acpi_bus_uuid(void)
> +{
> +	return nd_acpi_uuids[0];
> +}
> +
> +static u8 *nd_acpi_dimm_uuid(void)
> +{
> +	return nd_acpi_uuids[1];
> +}
> +
>  static int nd_acpi_ctl(struct nfit_bus_descriptor *nfit_desc,
>  		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
>  		unsigned int buf_len)
>  {
> -	return -ENOTTY;
> +	struct acpi_nfit *nfit = to_acpi_nfit(nfit_desc);
> +	union acpi_object in_obj, in_buf, *out_obj;
> +	const struct nfit_cmd_desc *desc = NULL;
> +	struct device *dev = &nfit->dev->dev;
> +	const char *cmd_name, *dimm_name;
> +	unsigned long dsm_mask;
> +	acpi_handle handle;
> +	u32 offset;
> +	int rc, i;
> +	u8 *uuid;
> +
> +	if (nd_dimm) {
> +		struct acpi_device *adev = nd_dimm_get_pdata(nd_dimm);
> +
> +		if (cmd < ARRAY_SIZE(nfit_dimm_descs))
> +			desc = &nfit_dimm_descs[cmd];
> +		cmd_name = nfit_dimm_cmd_name(cmd);
> +		dsm_mask = nd_dimm_get_dsm_mask(nd_dimm);
> +		handle = adev->handle;
> +		uuid = nd_acpi_dimm_uuid();
> +		dimm_name = dev_name(&adev->dev);
> +	} else {
> +		if (cmd < ARRAY_SIZE(nfit_acpi_descs))
> +			desc = &nfit_acpi_descs[cmd];
> +		cmd_name = nfit_bus_cmd_name(cmd);
> +		dsm_mask = nfit_desc->dsm_mask;
> +		handle = nfit->dev->handle;
> +		uuid = nd_acpi_bus_uuid();
> +		dimm_name = "bus";
> +	}
> +
> +	if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
> +		return -ENOTTY;
> +
> +	if (!test_bit(cmd, &dsm_mask))
> +		return -ENOTTY;
> +
> +	in_obj.type = ACPI_TYPE_PACKAGE;
> +	in_obj.package.count = 1;
> +	in_obj.package.elements = &in_buf;
> +	in_buf.type = ACPI_TYPE_BUFFER;
> +	in_buf.buffer.pointer = buf;
> +	in_buf.buffer.length = 0;
> +
> +	/* double check that the nfit_acpi_cmd_descs table is self consistent */
> +	if (desc->in_num > NFIT_ACPI_MAX_ELEM) {
> +		WARN_ON_ONCE(1);
> +		return -ENXIO;
> +	}
> +
> +	for (i = 0; i < desc->in_num; i++) {
> +		u32 in_size;
> +
> +		in_size = to_cmd_in_size(nd_dimm, cmd, desc, i, buf);
> +		if (in_size == UINT_MAX) {
> +			dev_err(dev, "%s:%s unknown input size cmd: %s field: %d\n",
> +					__func__, dimm_name, cmd_name, i);
> +			return -ENXIO;
> +		}
> +		in_buf.buffer.length += in_size;
> +		if (in_buf.buffer.length > buf_len) {
> +			dev_err(dev, "%s:%s input underrun cmd: %s field: %d\n",
> +					__func__, dimm_name, cmd_name, i);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	dev_dbg(dev, "%s:%s cmd: %s input length: %d\n", __func__, dimm_name,
> +			cmd_name, in_buf.buffer.length);
> +	if (IS_ENABLED(CONFIG_NFIT_ACPI_DEBUG))
> +		print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
> +				4, in_buf.buffer.pointer, min_t(u32, 128,
> +					in_buf.buffer.length), true);
> +
> +	out_obj = acpi_evaluate_dsm(handle, uuid, 1, cmd, &in_obj);
> +	if (!out_obj) {
> +		dev_dbg(dev, "%s:%s _DSM failed cmd: %s\n", __func__, dimm_name,
> +				cmd_name);
> +		return -EINVAL;
> +	}
> +
> +	if (out_obj->package.type != ACPI_TYPE_BUFFER) {
> +		dev_dbg(dev, "%s:%s unexpected output object type cmd: %s type: %d\n",
> +				__func__, dimm_name, cmd_name, out_obj->type);
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	dev_dbg(dev, "%s:%s cmd: %s output length: %d\n", __func__, dimm_name,
> +			cmd_name, out_obj->buffer.length);
> +	if (IS_ENABLED(CONFIG_NFIT_ACPI_DEBUG))
> +		print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
> +				4, out_obj->buffer.pointer, min_t(u32, 128,
> +					out_obj->buffer.length), true);
> +
> +	for (i = 0, offset = 0; i < desc->out_num; i++) {
> +		u32 out_size = to_cmd_out_size(nd_dimm, cmd, desc, i, buf,
> +				out_obj->buffer.length, offset);
> +
> +		if (out_size == UINT_MAX) {
> +			dev_dbg(dev, "%s:%s unknown output size cmd: %s field: %d\n",
> +					__func__, dimm_name, cmd_name, i);
> +			break;
> +		}
> +
> +		if (offset + out_size > out_obj->buffer.length) {
> +			dev_dbg(dev, "%s:%s output object underflow cmd: %s field: %d\n",
> +					__func__, dimm_name, cmd_name, i);
> +			break;
> +		}
> +
> +		if (in_buf.buffer.length + offset + out_size > buf_len) {
> +			dev_dbg(dev, "%s:%s output overrun cmd: %s field: %d\n",
> +					__func__, dimm_name, cmd_name, i);
> +			rc = -ENXIO;
> +			goto out;
> +		}
> +		memcpy(buf + in_buf.buffer.length + offset,
> +				out_obj->buffer.pointer + offset, out_size);
> +		offset += out_size;
> +	}
> +	if (offset + in_buf.buffer.length < buf_len) {
> +		if (i >= 1) {
> +			/*
> +			 * status valid, return the number of bytes left
> +			 * unfilled in the output buffer
> +			 */
> +			rc = buf_len - offset - in_buf.buffer.length;
> +		} else {
> +			dev_err(dev, "%s:%s underrun cmd: %s buf_len: %d out_len: %d\n",
> +					__func__, dimm_name, cmd_name, buf_len, offset);
> +			rc = -ENXIO;
> +		}
> +	} else
> +		rc = 0;
> +
> + out:
> +	ACPI_FREE(out_obj);
> +
> +	return rc;
> +}
> +
> +static int nd_acpi_add_dimm(struct nfit_bus_descriptor *nfit_desc,
> +		struct nd_dimm *nd_dimm)
> +{
> +	struct acpi_nfit *nfit = to_acpi_nfit(nfit_desc);
> +	u32 nfit_handle = to_nfit_handle(nd_dimm);
> +	struct device *dev = &nfit->dev->dev;
> +	struct acpi_device *acpi_dimm;
> +	unsigned long dsm_mask = 0;
> +	u8 *uuid = nd_acpi_dimm_uuid();
> +	unsigned long long sta;
> +	int i, rc = -ENODEV;
> +	acpi_status status;
> +
> +	acpi_dimm = acpi_find_child_device(nfit->dev, nfit_handle, false);
> +	if (!acpi_dimm) {
> +		dev_err(dev, "no ACPI.NFIT device with _ADR %#x, disabling...\n",
> +				nfit_handle);
> +		return -ENODEV;
> +	}
> +
> +	status = acpi_evaluate_integer(acpi_dimm->handle, "_STA", NULL, &sta);
> +	if (status == AE_NOT_FOUND)
> +		dev_err(dev, "%s missing _STA, disabling...\n",
> +				dev_name(&acpi_dimm->dev));

I do not think it is correct to set a DIMM _ADR object disabled when it
has no _STA.  ACPI 6.0 spec states the followings:

 - Section 6.3.7 _STA, "If a device object describes a device that is
not on an enumerable bus and the device object does not have an _STA
object, then OSPM assumes that the device is present, enabled, shown in
the UI, and functioning."
 - Section 9.20.1 Hot Plug Support, "1. Prior to hot add of the NVDIMM,
the corresponding ACPI Name Space devices, NVD1, NVD2 return an address
from _ADR object (NFIT Device handle) which does not match any entries
present in NFIT (either the static or from _FIT) indicating that the
corresponding NVDIMM is not present."

So, in this case, it should set the DIMM object enabled or look up the
NFIT table to check the presence. 

Thanks,
-Toshi



