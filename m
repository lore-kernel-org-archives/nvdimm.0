Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 878AB210D97AB
 for <linux-nvdimm@lists.01.org>; Wed,  8 Aug 2018 10:42:59 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ACPI: nfit: check dcr immediately following its
 assignment codes
Date: Wed, 8 Aug 2018 17:42:49 +0000
Message-ID: <1533750167.7673.0.camel@intel.com>
References: <1533739821-9864-1-git-send-email-oceanhehy@gmail.com>
In-Reply-To: <1533739821-9864-1-git-send-email-oceanhehy@gmail.com>
Content-Language: en-US
Content-ID: <056CCCA00A86E94385781170EC549486@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "oceanhehy@gmail.com" <oceanhehy@gmail.com>, "Jiang, Dave" <dave.jiang@intel.com>, "lenb@kernel.org" <lenb@kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "hehy1@lenovo.com" <hehy1@lenovo.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2018-08-08 at 10:50 -0400, Ocean He wrote:
> From: Ocean He <hehy1@lenovo.com>
> 
> In commit 6697b2cf69d43632 ("nfit: fix multi-interface dimm handling,
> acpi6.1 compatibility"), the check codes of dcr were just following its
> assignment codes. But they were separated by commit ad9ac5e1957531a8
> ("nfit: always associate flush hints").
> 
> Just change the check codes back to original position, without function
> change.
> 
> Signed-off-by: Ocean He <hehy1@lenovo.com>
> ---
>  drivers/acpi/nfit/core.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

This seems like unnecessary churn. Does it cause any problems in
practice?

> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 7c47900..c9e4c9a 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1078,6 +1078,12 @@ static int __nfit_mem_init(struct acpi_nfit_desc *acpi_desc,
>  			break;
>  		}
>  
> +		if (dcr && !nfit_mem->dcr) {
> +			dev_err(acpi_desc->dev, "SPA %d missing DCR %d\n",
> +					spa->range_index, dcr);
> +			return -ENODEV;
> +		}
> +
>  		list_for_each_entry(nfit_flush, &acpi_desc->flushes, list) {
>  			struct acpi_nfit_flush_address *flush;
>  			u16 i;
> @@ -1101,12 +1107,6 @@ static int __nfit_mem_init(struct acpi_nfit_desc *acpi_desc,
>  			break;
>  		}
>  
> -		if (dcr && !nfit_mem->dcr) {
> -			dev_err(acpi_desc->dev, "SPA %d missing DCR %d\n",
> -					spa->range_index, dcr);
> -			return -ENODEV;
> -		}
> -
>  		if (type == NFIT_SPA_DCR) {
>  			struct nfit_idt *nfit_idt;
>  			u16 idt_idx;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
