Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t4622.austin.hp.com (g2t4622.austin.hp.com [15.73.212.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B040D1A1E4C
 for <linux-nvdimm@lists.01.org>; Fri,  6 May 2016 07:52:49 -0700 (PDT)
Subject: Re: [PATCH v11 2/5] nfit, libnvdimm: limited/whitelisted dimm command
 marshaling mechanism
References: <146189774241.29835.12947278159500915461.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146189775335.29835.217177508880335589.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <572CAFBB.20909@hpe.com>
Date: Fri, 6 May 2016 10:52:43 -0400
MIME-Version: 1.0
In-Reply-To: <146189775335.29835.217177508880335589.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com
List-ID: <linux-nvdimm@lists.01.org>


On 4/28/2016 10:42 PM, Dan Williams wrote:
> There are currently 4 known similar but incompatible definitions of the
> command sets that can be sent to an NVDIMM through ACPI.  It is also
> clear that future platform generations (ACPI or not) will continue to
> revise and extend the DIMM command set as new devices and use cases
> arrive.
> 
> It is obviously untenable to continue to proliferate divergence
> of these command definitions, and to that end a standardization process
> has begun to provide for a unified specification.  However, that leaves a
> problem about what to do with this first generation where vendors are
> already shipping divergence.

Actually, the ACPI spec in 9.20.5 describes support for vendor-specific,
and even version specific, management modules since different hardware
may have vastly different management interfaces, but I think we all agree
that we'd like to standardize at least a core set of functions for the
benefit of users and common utilities.

> The Linux kernel can support these initial diverged platforms without
> giving platform-firmware free reign to continue to diverge and compound
> kernel maintenance overhead.  The kernel implementation can encourage
> standardization in two ways:
> 
> 1/ Require that any function code that userspace wants to send be
>    explicitly white-listed in the implementation.  For ACPI this means
>    function codes marked as supported by acpi_check_dsm() may
>    only be invoked if they appear in the white-list.  A function must be
>    publicly documented before it is added to the white-list.
> 
> 2/ The above restrictions can be trivially bypassed by using the
>    "vendor-specific" payload command.  However, since vendor-specific
>    commands are by definition not publicly documented and have the
>    potential to corrupt the kernel's view of the dimm state, we provide a
>    toggle to disable vendor-specific operations.  Enabling undefined
>    behavior is a policy decision that can be made by the platform owner
>    and encourages firmware implementations to choose public over
>    private command implementations.

To me, an undocumented command is the same as a "vendor-specific"
command as both are unknown to the kernel.  If you want to restrict them,
I think the same knob you're using for vendor-specific commands
should apply to undocumented commands and that you shouldn't block
undocumented commands by default with no way to enable them.

My concern is that a FW update that introduces a new management
command, accompanied by an updated management utility, will
require a kernel update just to change your hard coded mask.
That's a huge burden for customers, as well as for vendors and
distros.

BTW, the same could be true for root device DSMs, where an updated
standard introduces a new DSM that is only used by user-space but
would still require a kernel update to support.

More below.

> Based on an initial patch from Jerry Hoemann
> Cc: Jerry Hoemann <jerry.hoemann@hpe.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit.c        |  101 +++++++++++++++++++++++++++++++++++++-------
>  drivers/acpi/nfit.h        |   14 ++++++
>  drivers/nvdimm/bus.c       |   39 +++++++++++++++++
>  include/uapi/linux/ndctl.h |   42 ++++++++++++++++++
>  4 files changed, 179 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index 1b98e9dc6138..710d3a07d178 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -171,33 +171,46 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>  		unsigned int buf_len, int *cmd_rc)
>  {
>  	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
> -	const struct nd_cmd_desc *desc = NULL;
>  	union acpi_object in_obj, in_buf, *out_obj;
> +	const struct nd_cmd_desc *desc = NULL;
>  	struct device *dev = acpi_desc->dev;
> +	struct nd_cmd_pkg *call_pkg = NULL;
>  	const char *cmd_name, *dimm_name;
> -	unsigned long cmd_mask;
> +	unsigned long cmd_mask, dsm_mask;
>  	acpi_handle handle;
> +	unsigned int func;
>  	const u8 *uuid;
>  	u32 offset;
>  	int rc, i;
>  
> +	func = cmd;
> +	if (cmd == ND_CMD_CALL) {
> +		call_pkg = buf;
> +		func = call_pkg->nd_command;
> +	}
> +
>  	if (nvdimm) {
>  		struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
>  		struct acpi_device *adev = nfit_mem->adev;
>  
>  		if (!adev)
>  			return -ENOTTY;
> +		if (call_pkg && nfit_mem->family != call_pkg->nd_family)
> +			return -ENOTTY;
> +
>  		dimm_name = nvdimm_name(nvdimm);
>  		cmd_name = nvdimm_cmd_name(cmd);
>  		cmd_mask = nvdimm_cmd_mask(nvdimm);
> +		dsm_mask = nfit_mem->dsm_mask;
>  		desc = nd_cmd_dimm_desc(cmd);
> -		uuid = to_nfit_uuid(NFIT_DEV_DIMM);
> +		uuid = to_nfit_uuid(nfit_mem->family);
>  		handle = adev->handle;
>  	} else {
>  		struct acpi_device *adev = to_acpi_dev(acpi_desc);
>  
>  		cmd_name = nvdimm_bus_cmd_name(cmd);
>  		cmd_mask = nd_desc->cmd_mask;
> +		dsm_mask = cmd_mask;
>  		desc = nd_cmd_bus_desc(cmd);
>  		uuid = to_nfit_uuid(NFIT_DEV_BUS);
>  		handle = adev->handle;
> @@ -207,7 +220,7 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>  	if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
>  		return -ENOTTY;
>  
> -	if (!test_bit(cmd, &cmd_mask))
> +	if (!test_bit(cmd, &cmd_mask) || !test_bit(func, &dsm_mask))
>  		return -ENOTTY;
>  
>  	in_obj.type = ACPI_TYPE_PACKAGE;
> @@ -222,21 +235,44 @@ static int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc,
>  		in_buf.buffer.length += nd_cmd_in_size(nvdimm, cmd, desc,
>  				i, buf);
>  
> +	if (call_pkg) {
> +		/* skip over package wrapper */
> +		in_buf.buffer.pointer = (void *) &call_pkg->nd_payload;
> +		in_buf.buffer.length = call_pkg->nd_size_in;
> +	}
> +
>  	if (IS_ENABLED(CONFIG_ACPI_NFIT_DEBUG)) {
> -		dev_dbg(dev, "%s:%s cmd: %s input length: %d\n", __func__,
> -				dimm_name, cmd_name, in_buf.buffer.length);
> -		print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4,
> -				4, in_buf.buffer.pointer, min_t(u32, 128,
> -					in_buf.buffer.length), true);
> +		dev_dbg(dev, "%s:%s cmd: %d: func: %d input length: %d\n",
> +				__func__, dimm_name, cmd, func,

Before the patch, you print cmd_name but now it's the command number.
If that's intentional, it's different from the debug statements for
the output, which still print the cmd_name.

> +				in_buf.buffer.length);
> +		print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
> +			in_buf.buffer.pointer,
> +			min_t(u32, 256, in_buf.buffer.length), true);
>  	}
>  
> -	out_obj = acpi_evaluate_dsm(handle, uuid, 1, cmd, &in_obj);
> +	out_obj = acpi_evaluate_dsm(handle, uuid, 1, func, &in_obj);
>  	if (!out_obj) {
>  		dev_dbg(dev, "%s:%s _DSM failed cmd: %s\n", __func__, dimm_name,
>  				cmd_name);
>  		return -EINVAL;
>  	}
>  
> +	if (call_pkg) {
> +		call_pkg->nd_fw_size = out_obj->buffer.length;
> +		memcpy(call_pkg->nd_payload + call_pkg->nd_size_in,
> +			out_obj->buffer.pointer,
> +			min(call_pkg->nd_fw_size, call_pkg->nd_size_out));
> +
> +		ACPI_FREE(out_obj);
> +		/*
> +		 * Need to support FW function w/o known size in advance.
> +		 * Caller can determine required size based upon nd_fw_size.
> +		 * If call erroed (like elsewhere) then caller wouldn't
> +		 * be able to rely upon data returned to make calculation.
> +		 */
> +		return 0;
> +	}
> +
>  	if (out_obj->package.type != ACPI_TYPE_BUFFER) {
>  		dev_dbg(dev, "%s:%s unexpected output object type cmd: %s type: %d\n",
>  				__func__, dimm_name, cmd_name, out_obj->type);
> @@ -923,11 +959,13 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>  {
>  	struct acpi_device *adev, *adev_dimm;
>  	struct device *dev = acpi_desc->dev;
> -	const u8 *uuid = to_nfit_uuid(NFIT_DEV_DIMM);
> +	unsigned long dsm_mask;
> +	const u8 *uuid;
>  	int i;
>  
>  	/* nfit test assumes 1:1 relationship between commands and dsms */
>  	nfit_mem->dsm_mask = acpi_desc->dimm_cmd_force_en;
> +	nfit_mem->family = NVDIMM_FAMILY_INTEL;
>  	adev = to_acpi_dev(acpi_desc);
>  	if (!adev)
>  		return 0;
> @@ -940,7 +978,31 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>  		return force_enable_dimms ? 0 : -ENODEV;
>  	}
>  
> -	for (i = ND_CMD_SMART; i <= ND_CMD_VENDOR; i++)
> +	/*
> +	 * Until standardization materializes we need to consider up to 3
> +	 * different command sets.  Note, that checking for function0 (bit0)
> +	 * tells us if any commands are reachable through this uuid.
> +	 */
> +	for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_HPE2; i++)
> +		if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
> +			break;
> +
> +	/* limit the supported commands to those that are publicly documented */
> +	nfit_mem->family = i;
> +	if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
> +		dsm_mask = 0x3fe;
> +	else if (nfit_mem->family == NVDIMM_FAMILY_HPE1)
> +		dsm_mask = 0x1c3c76;
> +	else if (nfit_mem->family == NVDIMM_FAMILY_HPE2)
> +		dsm_mask = 0x1fe;

I think this mask should only be used if the user explicitly requests
no vendor-defined functions.

I also think you should allow function 0 since that is the one function
that is documented for all devices.

> +	else {
> +		dev_err(dev, "unknown dimm command family\n");
> +		nfit_mem->family = -1;
> +		return force_enable_dimms ? 0 : -ENODEV;
> +	}
> +
> +	uuid = to_nfit_uuid(nfit_mem->family);
> +	for_each_set_bit(i, &dsm_mask, BITS_PER_LONG)
>  		if (acpi_check_dsm(adev_dimm->handle, uuid, 1, 1ULL << i))
>  			set_bit(i, &nfit_mem->dsm_mask);
>  
> @@ -953,8 +1015,8 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>  	int dimm_count = 0;
>  
>  	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
> +		unsigned long flags = 0, cmd_mask;
>  		struct nvdimm *nvdimm;
> -		unsigned long flags = 0;
>  		u32 device_handle;
>  		u16 mem_flags;
>  		int rc;
> @@ -978,12 +1040,17 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>  			continue;
>  
>  		/*
> -		 * For now there is 1:1 relationship between cmd_mask and
> -		 * dsm_mask.
> +		 * TODO: provide translation for non-NVDIMM_FAMILY_INTEL
> +		 * devices (i.e. from nd_cmd to acpi_dsm) to standardize the
> +		 * userspace interface.
>  		 */
> +		cmd_mask = 1UL << ND_CMD_CALL;
> +		if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
> +			cmd_mask |= nfit_mem->dsm_mask;
> +
>  		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
>  				acpi_nfit_dimm_attribute_groups,
> -				flags, nfit_mem->dsm_mask);
> +				flags, cmd_mask);
>  		if (!nvdimm)
>  			return -ENOMEM;
>  
> @@ -2468,6 +2535,8 @@ static __init int nfit_init(void)
>  	acpi_str_to_uuid(UUID_PERSISTENT_VIRTUAL_CD, nfit_uuid[NFIT_SPA_PCD]);
>  	acpi_str_to_uuid(UUID_NFIT_BUS, nfit_uuid[NFIT_DEV_BUS]);
>  	acpi_str_to_uuid(UUID_NFIT_DIMM, nfit_uuid[NFIT_DEV_DIMM]);
> +	acpi_str_to_uuid(UUID_NFIT_DIMM_N_HPE1, nfit_uuid[NFIT_DEV_DIMM_N_HPE1]);
> +	acpi_str_to_uuid(UUID_NFIT_DIMM_N_HPE2, nfit_uuid[NFIT_DEV_DIMM_N_HPE2]);
>  
>  	nfit_wq = create_singlethread_workqueue("nfit");
>  	if (!nfit_wq)
> diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
> index 332ee6f01662..f82fda55b6de 100644
> --- a/drivers/acpi/nfit.h
> +++ b/drivers/acpi/nfit.h
> @@ -21,13 +21,25 @@
>  #include <linux/acpi.h>
>  #include <acpi/acuuid.h>
>  
> +/* ACPI 6.1 */
>  #define UUID_NFIT_BUS "2f10e7a4-9e91-11e4-89d3-123b93f75cba"
> +
> +/* http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf */
>  #define UUID_NFIT_DIMM "4309ac30-0d11-11e4-9191-0800200c9a66"
> +
> +/* https://github.com/HewlettPackard/hpe-nvm/blob/master/Documentation/ */
> +#define UUID_NFIT_DIMM_N_HPE1 "9002c334-acf3-4c0e-9642-a235f0d53bc6"
> +#define UUID_NFIT_DIMM_N_HPE2 "5008664b-b758-41a0-a03c-27c2f2d04f7e"
> +
>  #define ACPI_NFIT_MEM_FAILED_MASK (ACPI_NFIT_MEM_SAVE_FAILED \
>  		| ACPI_NFIT_MEM_RESTORE_FAILED | ACPI_NFIT_MEM_FLUSH_FAILED \
>  		| ACPI_NFIT_MEM_NOT_ARMED)
>  
>  enum nfit_uuids {
> +	/* for simplicity alias the uuid index with the family id */
> +	NFIT_DEV_DIMM = NVDIMM_FAMILY_INTEL,
> +	NFIT_DEV_DIMM_N_HPE1 = NVDIMM_FAMILY_HPE1,
> +	NFIT_DEV_DIMM_N_HPE2 = NVDIMM_FAMILY_HPE2,
>  	NFIT_SPA_VOLATILE,
>  	NFIT_SPA_PM,
>  	NFIT_SPA_DCR,
> @@ -37,7 +49,6 @@ enum nfit_uuids {
>  	NFIT_SPA_PDISK,
>  	NFIT_SPA_PCD,
>  	NFIT_DEV_BUS,
> -	NFIT_DEV_DIMM,
>  	NFIT_UUID_MAX,
>  };
>  
> @@ -110,6 +121,7 @@ struct nfit_mem {
>  	struct list_head list;
>  	struct acpi_device *adev;
>  	unsigned long dsm_mask;
> +	int family;
>  };
>  
>  struct acpi_nfit_desc {
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index cb2042a12b76..395a9fbbc69d 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -439,6 +439,12 @@ static const struct nd_cmd_desc __nd_cmd_dimm_descs[] = {
>  		.out_num = 3,
>  		.out_sizes = { 4, 4, UINT_MAX, },
>  	},
> +	[ND_CMD_CALL] = {
> +		.in_num = 2,
> +		.in_sizes = { sizeof(struct nd_cmd_pkg), UINT_MAX, },
> +		.out_num = 1,
> +		.out_sizes = { UINT_MAX, },
> +	},
>  };
>  
>  const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd)
> @@ -473,6 +479,12 @@ static const struct nd_cmd_desc __nd_cmd_bus_descs[] = {
>  		.out_num = 3,
>  		.out_sizes = { 4, 4, 8, },
>  	},
> +	[ND_CMD_CALL] = {
> +		.in_num = 2,
> +		.in_sizes = { sizeof(struct nd_cmd_pkg), UINT_MAX, },
> +		.out_num = 1,
> +		.out_sizes = { UINT_MAX, },
> +	},
>  };
>  
>  const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd)
> @@ -500,6 +512,10 @@ u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
>  		struct nd_cmd_vendor_hdr *hdr = buf;
>  
>  		return hdr->in_length;
> +	} else if (cmd == ND_CMD_CALL) {
> +		struct nd_cmd_pkg *pkg = buf;
> +
> +		return pkg->nd_size_in;
>  	}
>  
>  	return UINT_MAX;
> @@ -522,6 +538,12 @@ u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
>  		return out_field[1];
>  	else if (!nvdimm && cmd == ND_CMD_ARS_STATUS && idx == 2)
>  		return out_field[1] - 8;
> +	else if (cmd == ND_CMD_CALL) {
> +		struct nd_cmd_pkg *pkg = (struct nd_cmd_pkg *) in_field;
> +
> +		return pkg->nd_size_out;
> +	}
> +
>  
>  	return UINT_MAX;
>  }
> @@ -588,6 +610,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
>  	unsigned int cmd = _IOC_NR(ioctl_cmd);
>  	void __user *p = (void __user *) arg;
>  	struct device *dev = &nvdimm_bus->dev;
> +	struct nd_cmd_pkg pkg;
>  	const char *cmd_name, *dimm_name;
>  	unsigned long cmd_mask;
>  	void *buf;
> @@ -605,6 +628,11 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
>  		dimm_name = "bus";
>  	}
>  
> +	if (cmd == ND_CMD_CALL) {
> +		if (copy_from_user(&pkg, p, sizeof(pkg)))
> +			return -EFAULT;
> +	}
> +
>  	if (!desc || (desc->out_num + desc->in_num == 0) ||
>  			!test_bit(cmd, &cmd_mask))
>  		return -ENOTTY;
> @@ -616,6 +644,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
>  		case ND_CMD_SET_CONFIG_DATA:
>  		case ND_CMD_ARS_START:
>  		case ND_CMD_CLEAR_ERROR:
> +		case ND_CMD_CALL:
>  			dev_dbg(&nvdimm_bus->dev, "'%s' command while read-only.\n",
>  					nvdimm ? nvdimm_cmd_name(cmd)
>  					: nvdimm_bus_cmd_name(cmd));
> @@ -643,6 +672,16 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
>  		in_len += in_size;
>  	}
>  
> +	if (cmd == ND_CMD_CALL) {
> +		dev_dbg(dev, "%s:%s, idx: %llu, in: %zu, out: %zu, len %zu\n",
> +				__func__, dimm_name, pkg.nd_command,
> +				in_len, out_len, buf_len);
> +
> +		for (i = 0; i < ARRAY_SIZE(pkg.nd_reserved2); i++)
> +			if (pkg.nd_reserved2[i])
> +				return -EINVAL;
> +	}
> +
>  	/* process an output envelope */
>  	for (i = 0; i < desc->out_num; i++) {
>  		u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i,
> diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
> index 7cc28ab05b87..45daa0be5ff9 100644
> --- a/include/uapi/linux/ndctl.h
> +++ b/include/uapi/linux/ndctl.h
> @@ -125,6 +125,7 @@ enum {
>  	ND_CMD_VENDOR_EFFECT_LOG_SIZE = 7,
>  	ND_CMD_VENDOR_EFFECT_LOG = 8,
>  	ND_CMD_VENDOR = 9,
> +	ND_CMD_CALL = 10,
>  };
>  
>  enum {
> @@ -158,6 +159,7 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
>  		[ND_CMD_VENDOR_EFFECT_LOG_SIZE] = "effect_size",
>  		[ND_CMD_VENDOR_EFFECT_LOG] = "effect_log",
>  		[ND_CMD_VENDOR] = "vendor",
> +		[ND_CMD_CALL] = "cmd_call",
>  	};
>  
>  	if (cmd < ARRAY_SIZE(names) && names[cmd])
> @@ -224,4 +226,44 @@ enum ars_masks {
>  	ARS_STATUS_MASK = 0x0000FFFF,
>  	ARS_EXT_STATUS_SHIFT = 16,
>  };
> +
> +/*
> + * struct nd_cmd_pkg
> + *
> + * is a wrapper to a quasi pass thru interface for invoking firmware
> + * associated with nvdimms.
> + *
> + * INPUT PARAMETERS
> + *
> + * nd_family corresponds to the firmware (e.g. DSM) interface.
> + *
> + * nd_command are the function index advertised by the firmware.
> + *
> + * nd_size_in is the size of the input parameters being passed to firmware
> + *
> + * OUTPUT PARAMETERS
> + *
> + * nd_fw_size is the size of the data firmware wants to return for
> + * the call.  If nd_fw_size is greater than size of nd_size_out, only
> + * the first nd_size_out bytes are returned.
> + */
> +
> +struct nd_cmd_pkg {
> +	__u64   nd_family;		/* family of commands */
> +	__u64   nd_command;
> +	__u32   nd_size_in;		/* INPUT: size of input args */
> +	__u32   nd_size_out;		/* INPUT: size of payload */
> +	__u32   nd_reserved2[9];	/* reserved must be zero */
> +	__u32   nd_fw_size;		/* OUTPUT: size fw wants to return */
> +	unsigned char nd_payload[];	/* Contents of call      */
> +};
> +
> +/* These NVDIMM families represent pre-standardization command sets */
> +#define NVDIMM_FAMILY_INTEL 0
> +#define NVDIMM_FAMILY_HPE1 1
> +#define NVDIMM_FAMILY_HPE2 2
> +
> +#define ND_IOCTL_CALL			_IOWR(ND_IOCTL, ND_CMD_CALL,\
> +					struct nd_cmd_pkg)
> +
>  #endif /* __NDCTL_H__ */
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
