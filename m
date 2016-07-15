Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.nue.novell.com (smtp.nue.novell.com [195.135.221.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E3591A1F00
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jul 2016 22:16:52 -0700 (PDT)
Date: Fri, 15 Jul 2016 13:15:53 +0800
From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 1/2] nfit: fix _FIT evaluation memory leak
Message-ID: <20160715051553.GE27155@linux-rxt1.site>
References: <146855333714.573.13934675433503265133.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146855333714.573.13934675433503265133.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Xiao Guangrong <guangrong.xiao@intel.com>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

On Thu, Jul 14, 2016 at 08:28:57PM -0700, Dan Williams wrote:
> acpi_evaluate_object() allocates memory. Free the buffer allocated
> during acpi_nfit_add().
> 
> Cc: <stable@vger.kernel.org>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Reported-by: Xiao Guangrong <guangrong.xiao@intel.com>
> Reported-by: Haozhong Zhang <haozhong.zhang@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index 0497175ee6cb..008dbaaa2b75 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -2414,12 +2414,15 @@ static int acpi_nfit_add(struct acpi_device *adev)
>  			acpi_desc->nfit =
>  				(struct acpi_nfit_header *)obj->buffer.pointer;
>  			sz = obj->buffer.length;
> +			rc = acpi_nfit_init(acpi_desc, sz);
>  		} else
>  			dev_dbg(dev, "%s invalid type %d, ignoring _FIT\n",
>  				 __func__, (int) obj->type);
> -	}
> +		kfree(buf.pointer);
> +		acpi_desc->nfit = NULL;

Looks "acpi_desc->nfit = NULL" statement will be removed in [PATCH 2/2]
immediately. Why add it in PATCH 1?

> +	} else
> +		rc = acpi_nfit_init(acpi_desc, sz);
>  
> -	rc = acpi_nfit_init(acpi_desc, sz);
>  	if (rc) {
>  		nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
>  		return rc;
>

Other parts are no problem to me.


Thanks a lot! 
Joey Lee
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
