Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82241226C7C3E
 for <linux-nvdimm@lists.01.org>; Tue,  3 Apr 2018 08:31:35 -0700 (PDT)
Subject: Re: [PATCH 4/6] nfit, address-range-scrub: introduce
 nfit_spa->ars_state
References: <152273076087.38372.4803377088477706610.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152273078267.38372.2191145328822655057.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <c37b43b3-bcb7-b3a3-f7d7-cc0753843859@intel.com>
Date: Tue, 3 Apr 2018 08:31:22 -0700
MIME-Version: 1.0
In-Reply-To: <152273078267.38372.2191145328822655057.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


On 4/2/2018 9:46 PM, Dan Williams wrote:
> In preparation for re-working the ARS implementation to better handle
> short vs long ARS runs, introduce nfit_spa->ars_state. For now this just
> replaces the nfit_spa->ars_required bit-field/flag, but going forward it
> will be used to track ARS completion and make short vs long ARS
> requests.
>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/acpi/nfit/core.c |    6 +++---
>   drivers/acpi/nfit/nfit.h |    9 ++++++++-
>   2 files changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 2a1fc3817a81..9ba60f58d929 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -2808,7 +2808,7 @@ static void acpi_nfit_async_scrub(struct acpi_nfit_desc *acpi_desc,
>   	unsigned int tmo = scrub_timeout;
>   	int rc;
>   
> -	if (!nfit_spa->ars_required || !nfit_spa->nd_region)
> +	if (!test_bit(ARS_REQ, &nfit_spa->ars_state) || !nfit_spa->nd_region)
>   		return;
>   
>   	rc = ars_start(acpi_desc, nfit_spa);
> @@ -3003,7 +3003,7 @@ static void acpi_nfit_scrub(struct work_struct *work)
>   		 * register them now to make data available.
>   		 */
>   		if (!nfit_spa->nd_region) {
> -			nfit_spa->ars_required = 1;
> +			set_bit(ARS_REQ, &nfit_spa->ars_state);
>   			acpi_nfit_register_region(acpi_desc, nfit_spa);
>   		}
>   	}
> @@ -3261,7 +3261,7 @@ int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc, u8 flags)
>   		if (nfit_spa_type(spa) != NFIT_SPA_PM)
>   			continue;
>   
> -		nfit_spa->ars_required = 1;
> +		set_bit(ARS_REQ, &nfit_spa->ars_state);
>   	}
>   	acpi_desc->ars_start_flags = flags;
>   	queue_work(nfit_wq, &acpi_desc->work);
> diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
> index ac9c49463731..efb6c6bcde42 100644
> --- a/drivers/acpi/nfit/nfit.h
> +++ b/drivers/acpi/nfit/nfit.h
> @@ -117,10 +117,17 @@ enum nfit_dimm_notifiers {
>   	NFIT_NOTIFY_DIMM_HEALTH = 0x81,
>   };
>   
> +enum nfit_ars_state {
> +	ARS_REQ,
> +	ARS_DONE,
> +	ARS_SHORT,
> +	ARS_FAILED,
> +};
> +
>   struct nfit_spa {
>   	struct list_head list;
>   	struct nd_region *nd_region;
> -	unsigned int ars_required:1;
> +	unsigned long ars_state;
>   	u32 clear_err_unit;
>   	u32 max_ars;
>   	struct acpi_nfit_system_address spa[0];
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
