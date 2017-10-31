Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 250C22035D0FA
 for <linux-nvdimm@lists.01.org>; Tue, 31 Oct 2017 14:23:35 -0700 (PDT)
Date: Tue, 31 Oct 2017 15:27:25 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v2 2/2] acpi, nfit: add support for NVDIMM_FAMILY_INTEL
 v1.6 DSMs
Message-ID: <20171031212725.GA22678@anatevka.americas.hpqcorp.net>
References: <150939641796.4577.379718469071595984.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150939642870.4577.1202379190708311186.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150939642870.4577.1202379190708311186.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 30, 2017 at 01:47:08PM -0700, Dan Williams wrote:
> Per v1.6 of the NVDIMM_FAMILY_INTEL command set [1] some of the new
> commands require rev-id 2. In addition to enabling ND_CMD_CALL for these
> new function numbers, add a lookup table for revision-ids by family
> and function number.
> 
> [1]: http://pmem.io/documents/NVDIMM_DSM_Interface-V1.6.pdf
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit/core.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
>  drivers/acpi/nfit/nfit.h |   26 +++++++++++++++++++++++++-
>  2 files changed, 65 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 444832b372ec..1b2c613a9d8b 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -370,6 +370,32 @@ static union acpi_object *acpi_label_info(acpi_handle handle)
>  	return pkg_to_buf(buf.pointer);
>  }
>  
> +static u8 nfit_dsm_revid(unsigned family, unsigned func)
> +{
> +	static const u8 revid_table[NVDIMM_FAMILY_MAX][32] = {
> +		[NVDIMM_FAMILY_INTEL] = {
> +			[NVDIMM_INTEL_GET_MODES] = 2,
> +			[NVDIMM_INTEL_GET_FWINFO] = 2,
> +			[NVDIMM_INTEL_START_FWUPDATE] = 2,
> +			[NVDIMM_INTEL_SEND_FWUPDATE] = 2,
> +			[NVDIMM_INTEL_FINISH_FWUPDATE] = 2,
> +			[NVDIMM_INTEL_QUERY_FWUPDATE] = 2,
> +			[NVDIMM_INTEL_SET_THRESHOLD] = 2,
> +			[NVDIMM_INTEL_INJECT_ERROR] = 2,
> +		},
> +	};
> +	u8 id;
> +
> +	if (family > NVDIMM_FAMILY_MAX)
> +		return 0;
> +	if (func > 31)
> +		return 0;
> +	id = revid_table[family][func];
> +	if (id == 0)
> +		return 1; /* default */
> +	return id;
> +}
> +


Elsewhere we find NVDIMM_FAMILY_MAX == NVDIMM_FAMILY_MSFT.
Code is off by 1 in the dimension the array revid_table.

This approach only ever calls revision ID 1 of a function that
was initially defined in revision ID 1 of a spec.

Is it required that FW returns same data for a given function if
called with different revision IDs?  I.e. could firmware implement
a function N such that it returns different information if called
with revision ID 2 versus being called with revision ID 1?
E.g. a field that is reserved in revision 1 could have a definition
in revision 2.  My reading of the ACPI spec is this is acceptable.

Not sure if this makes a difference w/ the Intel FW or not, but
some of the structures returns were modified from the earlier
spec.  I have concerns that this approach can be correctly
extended to other vendors.




>  int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>  		unsigned int cmd, void *buf, unsigned int buf_len, int *cmd_rc)
>  {
> @@ -468,8 +494,15 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>  
>  		out_obj = acpi_label_write(handle, p->in_offset, p->in_length,
>  				p->in_buf);
> -	} else
> -		out_obj = acpi_evaluate_dsm(handle, guid, 1, func, &in_obj);
> +	} else {
> +		u8 revid;
> +
> +		if (nfit_mem)
> +			revid = nfit_dsm_revid(nfit_mem->family, func);
> +		else
> +			revid = 1;
> +		out_obj = acpi_evaluate_dsm(handle, guid, revid, func, &in_obj);
> +	}
>  
>  	if (!out_obj) {
>  		dev_dbg(dev, "%s:%s _DSM failed cmd: %s\n", __func__, dimm_name,
> @@ -1640,7 +1673,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>  	 * different command sets.  Note, that checking for function0 (bit0)
>  	 * tells us if any commands are reachable through this GUID.
>  	 */
> -	for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_MSFT; i++)
> +	for (i = 0; i <= NVDIMM_FAMILY_MAX; i++)
>  		if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
>  			if (family < 0 || i == default_dsm_family)
>  				family = i;
> @@ -1650,7 +1683,7 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>  	if (override_dsm_mask && !disable_vendor_specific)
>  		dsm_mask = override_dsm_mask;
>  	else if (nfit_mem->family == NVDIMM_FAMILY_INTEL) {
> -		dsm_mask = 0x3fe;
> +		dsm_mask = NVDIMM_INTEL_CMDMASK;
>  		if (disable_vendor_specific)
>  			dsm_mask &= ~(1 << ND_CMD_VENDOR);
>  	} else if (nfit_mem->family == NVDIMM_FAMILY_HPE1) {
> @@ -1670,7 +1703,9 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
>  
>  	guid = to_nfit_uuid(nfit_mem->family);
>  	for_each_set_bit(i, &dsm_mask, BITS_PER_LONG)
> -		if (acpi_check_dsm(adev_dimm->handle, guid, 1, 1ULL << i))
> +		if (acpi_check_dsm(adev_dimm->handle, guid,
> +					nfit_dsm_revid(nfit_mem->family, i),
> +					1ULL << i))
>  			set_bit(i, &nfit_mem->dsm_mask);
>  
>  	obj = acpi_label_info(adev_dimm->handle);
> diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
> index b987196bf132..341be9511d0e 100644
> --- a/drivers/acpi/nfit/nfit.h
> +++ b/drivers/acpi/nfit/nfit.h
> @@ -24,7 +24,7 @@
>  /* ACPI 6.1 */
>  #define UUID_NFIT_BUS "2f10e7a4-9e91-11e4-89d3-123b93f75cba"
>  
> -/* http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf */
> +/* http://pmem.io/documents/NVDIMM_DSM_Interface-V1.6.pdf */
>  #define UUID_NFIT_DIMM "4309ac30-0d11-11e4-9191-0800200c9a66"
>  
>  /* https://github.com/HewlettPackard/hpe-nvm/blob/master/Documentation/ */
> @@ -38,12 +38,36 @@
>  		| ACPI_NFIT_MEM_RESTORE_FAILED | ACPI_NFIT_MEM_FLUSH_FAILED \
>  		| ACPI_NFIT_MEM_NOT_ARMED | ACPI_NFIT_MEM_MAP_FAILED)
>  
> +#define NVDIMM_FAMILY_MAX NVDIMM_FAMILY_MSFT


Suggest this be defined immediately after where NVDIMM_FAMILY_MSFT
is defined.  That way if a new family is ever defined, its more obvious
that NVDIMM_FAMILY_MAX needs to be redefined as well.



> +
>  #define NVDIMM_STANDARD_CMDMASK \
>  (1 << ND_CMD_SMART | 1 << ND_CMD_SMART_THRESHOLD | 1 << ND_CMD_DIMM_FLAGS \
>   | 1 << ND_CMD_GET_CONFIG_SIZE | 1 << ND_CMD_GET_CONFIG_DATA \
>   | 1 << ND_CMD_SET_CONFIG_DATA | 1 << ND_CMD_VENDOR_EFFECT_LOG_SIZE \
>   | 1 << ND_CMD_VENDOR_EFFECT_LOG | 1 << ND_CMD_VENDOR)
>  
> +/*
> + * Command numbers that the kernel needs to know about to handle
> + * non-default DSM revision ids
> + */
> +enum nvdimm_family_cmds {
> +	NVDIMM_INTEL_GET_MODES = 11,
> +	NVDIMM_INTEL_GET_FWINFO = 12,
> +	NVDIMM_INTEL_START_FWUPDATE = 13,
> +	NVDIMM_INTEL_SEND_FWUPDATE = 14,
> +	NVDIMM_INTEL_FINISH_FWUPDATE = 15,
> +	NVDIMM_INTEL_QUERY_FWUPDATE = 16,
> +	NVDIMM_INTEL_SET_THRESHOLD = 17,
> +	NVDIMM_INTEL_INJECT_ERROR = 18,
> +};
> +
> +#define NVDIMM_INTEL_CMDMASK \
> +(NVDIMM_STANDARD_CMDMASK | 1 << NVDIMM_INTEL_GET_MODES \
> + | 1 << NVDIMM_INTEL_GET_FWINFO | 1 << NVDIMM_INTEL_START_FWUPDATE \
> + | 1 << NVDIMM_INTEL_SEND_FWUPDATE | 1 << NVDIMM_INTEL_FINISH_FWUPDATE \
> + | 1 << NVDIMM_INTEL_QUERY_FWUPDATE | 1 << NVDIMM_INTEL_SET_THRESHOLD \
> + | 1 << NVDIMM_INTEL_INJECT_ERROR)
> +
>  enum nfit_uuids {
>  	/* for simplicity alias the uuid index with the family id */
>  	NFIT_DEV_DIMM = NVDIMM_FAMILY_INTEL,
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
