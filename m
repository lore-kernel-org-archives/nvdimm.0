Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 47E4D2119EF50
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 17:33:07 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] acpi/nfit: Fix command-supported detection
Date: Sat, 12 Jan 2019 01:33:05 +0000
Message-ID: <3b9845692298bc246d359f48b4be1eb497381d05.camel@intel.com>
References: <154725096972.1367907.12968253382302127133.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154725096972.1367907.12968253382302127133.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <40985656A5E0584BAC0656CA241C8CCF@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "sujith_pandel@dell.com" <sujith_pandel@dell.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2019-01-11 at 15:59 -0800, Dan Williams wrote:
> The _DSM function number validation only happens to succeed when the
> generic Linux command number translation corresponds with a
> DSM-family-specific function number. This breaks NVDIMM-N
> implementations that correctly implement _LSR, _LSW, and _LSI, but do
> not happen to publish support for DSM function numbers 4, 5, and 6.
> 
> Recall that the support for _LS{I,R,W} family of methods results in the
> DIMM being marked as supporting those command numbers at
> acpi_nfit_register_dimms() time. The DSM function mask is only used for
> ND_CMD_CALL support of non-NVDIMM_FAMILY_INTEL devices.
> 
> Fixes: 31eca76ba2fc ("nfit, libnvdimm: limited/whitelisted dimm command...")
> Cc: <stable@vger.kernel.org>
> Link: https://github.com/pmem/ndctl/issues/78
> Reported-by: Sujith Pandel <sujith_pandel@dell.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Sujith, this is a larger change than what you originally tested, but it
> should behave the same. I wanted to consolidate all the code that
> handles Linux command number to DIMM _DSM function number translation.
> 
> If you have a chance to re-test with this it would be much appreciated.
> 
> Thanks for the report!
> 
>  drivers/acpi/nfit/core.c |   43 +++++++++++++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 14 deletions(-)

Looks good to me || good find ;)
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 790691d9a982..d5d64e90ae71 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -409,6 +409,29 @@ static bool payload_dumpable(struct nvdimm *nvdimm, unsigned int func)
>  	return true;
>  }
>  
> +static int cmd_to_func(struct nvdimm *nvdimm, unsigned int cmd,
> +		struct nd_cmd_pkg *call_pkg)
> +{
> +	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> +
> +	if (cmd == ND_CMD_CALL) {
> +		int i;
> +
> +		if (call_pkg && nfit_mem->family != call_pkg->nd_family)
> +			return -ENOTTY;
> +
> +		for (i = 0; i < ARRAY_SIZE(call_pkg->nd_reserved2); i++)
> +			if (call_pkg->nd_reserved2[i])
> +				return -EINVAL;
> +		return call_pkg->nd_command;
> +	}
> +
> +	/* Linux ND commands == NVDIMM_FAMILY_INTEL function numbers */
> +	if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
> +		return cmd;
> +	return 0;
> +}
> +
>  int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>  		unsigned int cmd, void *buf, unsigned int buf_len, int *cmd_rc)
>  {
> @@ -422,30 +445,21 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>  	unsigned long cmd_mask, dsm_mask;
>  	u32 offset, fw_status = 0;
>  	acpi_handle handle;
> -	unsigned int func;
>  	const guid_t *guid;
> -	int rc, i;
> +	int func, rc, i;
>  
>  	if (cmd_rc)
>  		*cmd_rc = -EINVAL;
> -	func = cmd;
> -	if (cmd == ND_CMD_CALL) {
> -		call_pkg = buf;
> -		func = call_pkg->nd_command;
> -
> -		for (i = 0; i < ARRAY_SIZE(call_pkg->nd_reserved2); i++)
> -			if (call_pkg->nd_reserved2[i])
> -				return -EINVAL;
> -	}
>  
>  	if (nvdimm) {
>  		struct acpi_device *adev = nfit_mem->adev;
>  
>  		if (!adev)
>  			return -ENOTTY;
> -		if (call_pkg && nfit_mem->family != call_pkg->nd_family)
> -			return -ENOTTY;
>  
> +		func = cmd_to_func(nvdimm, cmd, buf);
> +		if (func < 0)
> +			return func;
>  		dimm_name = nvdimm_name(nvdimm);
>  		cmd_name = nvdimm_cmd_name(cmd);
>  		cmd_mask = nvdimm_cmd_mask(nvdimm);
> @@ -456,6 +470,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>  	} else {
>  		struct acpi_device *adev = to_acpi_dev(acpi_desc);
>  
> +		func = cmd;
>  		cmd_name = nvdimm_bus_cmd_name(cmd);
>  		cmd_mask = nd_desc->cmd_mask;
>  		dsm_mask = cmd_mask;
> @@ -470,7 +485,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>  	if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
>  		return -ENOTTY;
>  
> -	if (!test_bit(cmd, &cmd_mask) || !test_bit(func, &dsm_mask))
> +	if (!test_bit(cmd, &cmd_mask) && !test_bit(func, &dsm_mask))
>  		return -ENOTTY;
>  
>  	in_obj.type = ACPI_TYPE_PACKAGE;
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
