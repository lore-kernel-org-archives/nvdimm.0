Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id DA2191A1F26
 for <linux-nvdimm@lists.01.org>; Fri, 15 Jul 2016 13:42:13 -0700 (PDT)
Date: Fri, 15 Jul 2016 14:40:59 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH] tools/testing/nvdimm: add manufacturing_{date|location}
 dimm properties
Message-ID: <20160715204059.GB12960@omniknight.lm.intel.com>
References: <146861143970.17001.5728377300713176227.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146861143970.17001.5728377300713176227.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 07/15, Dan Williams wrote:
> New for ACPI 6.1, these fields are used in the common dimm
> representation format defined by section 5.2.25.9 "NVDIMM representation
> format".
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  tools/testing/nvdimm/test/nfit.c |   54 +++++++++++++++-----------------------
>  1 file changed, 21 insertions(+), 33 deletions(-)

Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

> 
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index d4a4635c1186..78cba1e3b1da 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -639,6 +639,16 @@ static int nfit_test1_alloc(struct nfit_test *t)
>  	return ars_state_init(&t->pdev.dev, &t->ars_state);
>  }
>  
> +static void dcr_common_init(struct acpi_nfit_control_region *dcr)
> +{
> +	dcr->vendor_id = 0xabcd;
> +	dcr->device_id = 0;
> +	dcr->revision_id = 1;
> +	dcr->valid_fields = 1;
> +	dcr->manufacturing_location = 0xa;
> +	dcr->manufacturing_date = cpu_to_be16(2016);
> +}
> +
>  static void nfit_test0_setup(struct nfit_test *t)
>  {
>  	const int flush_hint_size = sizeof(struct acpi_nfit_flush_address)
> @@ -967,9 +977,7 @@ static void nfit_test0_setup(struct nfit_test *t)
>  	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
>  	dcr->header.length = sizeof(struct acpi_nfit_control_region);
>  	dcr->region_index = 0+1;
> -	dcr->vendor_id = 0xabcd;
> -	dcr->device_id = 0;
> -	dcr->revision_id = 1;
> +	dcr_common_init(dcr);
>  	dcr->serial_number = ~handle[0];
>  	dcr->code = NFIT_FIC_BLK;
>  	dcr->windows = 1;
> @@ -984,9 +992,7 @@ static void nfit_test0_setup(struct nfit_test *t)
>  	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
>  	dcr->header.length = sizeof(struct acpi_nfit_control_region);
>  	dcr->region_index = 1+1;
> -	dcr->vendor_id = 0xabcd;
> -	dcr->device_id = 0;
> -	dcr->revision_id = 1;
> +	dcr_common_init(dcr);
>  	dcr->serial_number = ~handle[1];
>  	dcr->code = NFIT_FIC_BLK;
>  	dcr->windows = 1;
> @@ -1001,9 +1007,7 @@ static void nfit_test0_setup(struct nfit_test *t)
>  	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
>  	dcr->header.length = sizeof(struct acpi_nfit_control_region);
>  	dcr->region_index = 2+1;
> -	dcr->vendor_id = 0xabcd;
> -	dcr->device_id = 0;
> -	dcr->revision_id = 1;
> +	dcr_common_init(dcr);
>  	dcr->serial_number = ~handle[2];
>  	dcr->code = NFIT_FIC_BLK;
>  	dcr->windows = 1;
> @@ -1018,9 +1022,7 @@ static void nfit_test0_setup(struct nfit_test *t)
>  	dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
>  	dcr->header.length = sizeof(struct acpi_nfit_control_region);
>  	dcr->region_index = 3+1;
> -	dcr->vendor_id = 0xabcd;
> -	dcr->device_id = 0;
> -	dcr->revision_id = 1;
> +	dcr_common_init(dcr);
>  	dcr->serial_number = ~handle[3];
>  	dcr->code = NFIT_FIC_BLK;
>  	dcr->windows = 1;
> @@ -1037,9 +1039,7 @@ static void nfit_test0_setup(struct nfit_test *t)
>  	dcr->header.length = offsetof(struct acpi_nfit_control_region,
>  			window_size);
>  	dcr->region_index = 4+1;
> -	dcr->vendor_id = 0xabcd;
> -	dcr->device_id = 0;
> -	dcr->revision_id = 1;
> +	dcr_common_init(dcr);
>  	dcr->serial_number = ~handle[0];
>  	dcr->code = NFIT_FIC_BYTEN;
>  	dcr->windows = 0;
> @@ -1051,9 +1051,7 @@ static void nfit_test0_setup(struct nfit_test *t)
>  	dcr->header.length = offsetof(struct acpi_nfit_control_region,
>  			window_size);
>  	dcr->region_index = 5+1;
> -	dcr->vendor_id = 0xabcd;
> -	dcr->device_id = 0;
> -	dcr->revision_id = 1;
> +	dcr_common_init(dcr);
>  	dcr->serial_number = ~handle[1];
>  	dcr->code = NFIT_FIC_BYTEN;
>  	dcr->windows = 0;
> @@ -1065,9 +1063,7 @@ static void nfit_test0_setup(struct nfit_test *t)
>  	dcr->header.length = offsetof(struct acpi_nfit_control_region,
>  			window_size);
>  	dcr->region_index = 6+1;
> -	dcr->vendor_id = 0xabcd;
> -	dcr->device_id = 0;
> -	dcr->revision_id = 1;
> +	dcr_common_init(dcr);
>  	dcr->serial_number = ~handle[2];
>  	dcr->code = NFIT_FIC_BYTEN;
>  	dcr->windows = 0;
> @@ -1079,9 +1075,7 @@ static void nfit_test0_setup(struct nfit_test *t)
>  	dcr->header.length = offsetof(struct acpi_nfit_control_region,
>  			window_size);
>  	dcr->region_index = 7+1;
> -	dcr->vendor_id = 0xabcd;
> -	dcr->device_id = 0;
> -	dcr->revision_id = 1;
> +	dcr_common_init(dcr);
>  	dcr->serial_number = ~handle[3];
>  	dcr->code = NFIT_FIC_BYTEN;
>  	dcr->windows = 0;
> @@ -1176,9 +1170,7 @@ static void nfit_test0_setup(struct nfit_test *t)
>  		dcr->header.type = ACPI_NFIT_TYPE_CONTROL_REGION;
>  		dcr->header.length = sizeof(struct acpi_nfit_control_region);
>  		dcr->region_index = 8+1;
> -		dcr->vendor_id = 0xabcd;
> -		dcr->device_id = 0;
> -		dcr->revision_id = 1;
> +		dcr_common_init(dcr);
>  		dcr->serial_number = ~handle[4];
>  		dcr->code = NFIT_FIC_BLK;
>  		dcr->windows = 1;
> @@ -1195,9 +1187,7 @@ static void nfit_test0_setup(struct nfit_test *t)
>  		dcr->header.length = offsetof(struct acpi_nfit_control_region,
>  				window_size);
>  		dcr->region_index = 9+1;
> -		dcr->vendor_id = 0xabcd;
> -		dcr->device_id = 0;
> -		dcr->revision_id = 1;
> +		dcr_common_init(dcr);
>  		dcr->serial_number = ~handle[4];
>  		dcr->code = NFIT_FIC_BYTEN;
>  		dcr->windows = 0;
> @@ -1375,9 +1365,7 @@ static void nfit_test1_setup(struct nfit_test *t)
>  	dcr->header.length = offsetof(struct acpi_nfit_control_region,
>  			window_size);
>  	dcr->region_index = 0+1;
> -	dcr->vendor_id = 0xabcd;
> -	dcr->device_id = 0;
> -	dcr->revision_id = 1;
> +	dcr_common_init(dcr);
>  	dcr->serial_number = ~0;
>  	dcr->code = NFIT_FIC_BYTE;
>  	dcr->windows = 0;
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
