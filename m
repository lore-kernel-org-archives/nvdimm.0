Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hp.com (g9t5009.houston.hp.com [15.240.92.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE90B1A1E98
 for <linux-nvdimm@lists.01.org>; Thu,  5 May 2016 11:01:38 -0700 (PDT)
Date: Thu, 5 May 2016 12:01:35 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v11 2/5] nfit, libnvdimm: limited/whitelisted dimm
 command marshaling mechanism
Message-ID: <20160505180135.GD6808@tevye.fc.hp.com>
References: <146189774241.29835.12947278159500915461.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146189775335.29835.217177508880335589.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146189775335.29835.217177508880335589.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Jerry.Hoemann@hpe.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 28, 2016 at 07:42:33PM -0700, Dan Williams wrote:

...


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
                           ^^^^^^^
			typo:  returned error?



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



			^ Missing defined function 0.



> +	else if (nfit_mem->family == NVDIMM_FAMILY_HPE2)
> +		dsm_mask = 0x1fe;




			^ Missing defined function 0.



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

...

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
