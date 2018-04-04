Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D3D6321FB7D45
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 09:26:13 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH 5/6] nfit, address-range-scrub: rework and simplify ARS
 state machine
Date: Wed, 4 Apr 2018 16:26:09 +0000
Message-ID: <1522859143.2693.296.camel@hpe.com>
References: <152273076087.38372.4803377088477706610.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152273078779.38372.13062348829183334140.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152273078779.38372.13062348829183334140.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <2261346303772C44A1DC3B4EEC8487D4@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2018-04-02 at 21:46 -0700, Dan Williams wrote:
 :
> +static int init_ars(struct acpi_nfit_desc *acpi_desc, struct nfit_spa *nfit_spa,
> +		int query_rc)
>  {
> -	struct acpi_nfit_system_address *spa = nfit_spa->spa;
> -	unsigned int overflow_retry = scrub_overflow_abort;
> -	u64 init_ars_start = 0, init_ars_len = 0;
> -	struct device *dev = acpi_desc->dev;
> -	unsigned int tmo = scrub_timeout;
>  	int rc;
>  
> -	if (!test_bit(ARS_REQ, &nfit_spa->ars_state) || !nfit_spa->nd_region)
> -		return;
> +	switch (query_rc) {
> +	case 0:
> +		/* ARS is idle, lets look for critical known errors... */
> +		break;
> +	case -EBUSY:
> +		/*
> +		 * ARS is already running, some agent thought it was ok
> +		 * to busy ARS before handing off to the nfit driver.
> +		 */
> +		clear_bit(ARS_SHORT, &nfit_spa->ars_state);
> +		rc = query_rc;
> +		goto out;
> +	case -ENOSPC:
> +		/* ARS continuation needed... */
> +		clear_bit(ARS_SHORT, &nfit_spa->ars_state);
> +		rc = query_rc;
> +		goto out;
> +	default:
> +		rc = query_rc;
> +		goto out;
> +	}
>  
> +	WARN_ON_ONCE(!test_bit(ARS_SHORT, &nfit_spa->ars_state));

I am hitting this WARN_ON_ONCE.  I think there is an issue in the code
flow that ars_complete() clears ARS_SHORT before init_ars().

  acpi_nfit_scrub
    acpi_nfit_query_poison
      ars_status_process_records
         ars_complete
    init_ars

Thanks!
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
