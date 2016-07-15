Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 4087A1A1F04
 for <linux-nvdimm@lists.01.org>; Fri, 15 Jul 2016 00:56:04 -0700 (PDT)
Date: Fri, 15 Jul 2016 15:55:15 +0800
From: Haozhong Zhang <haozhong.zhang@intel.com>
Subject: Re: [PATCH 1/2] nfit: fix _FIT evaluation memory leak
Message-ID: <20160715075515.ufwwvwngteqyovsk@hz-desktop>
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
Cc: Xiao Guangrong <guangrong.xiao@intel.com>, linux-acpi@vger.kernel.org, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 07/14/16 20:28, Dan Williams wrote:
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

'rc' is not set in this path, so it maybe used uninitialized by 'if (rc)' below.
Should we set it to a non-zero value in this path?

> -	}
> +		kfree(buf.pointer);
> +		acpi_desc->nfit = NULL;

I notice the following code in acpi_nfit_notify():
	nfit_saved = acpi_desc->nfit;
	obj = buf.pointer;
	if (obj->type == ACPI_TYPE_BUFFER) {
		acpi_desc->nfit =
			(struct acpi_nfit_header *)obj->buffer.pointer;
		ret = acpi_nfit_init(acpi_desc, obj->buffer.length);
		if (ret) {
			/* Merge failed, restore old nfit, and exit */
			acpi_desc->nfit = nfit_saved;
			dev_err(dev, "failed to merge updated NFIT\n");
		}
		...

If we set acpi_desc->nfit to NULL in acpi_nfit_add() and
acpi_nfit_init() in acpi_nfit_notify() fails, it will be impossible to
restore the old nfit, because nfit_saved is NULL.

Thanks,
Haozhong

> +	} else
> +		rc = acpi_nfit_init(acpi_desc, sz);
>  
> -	rc = acpi_nfit_init(acpi_desc, sz);
>  	if (rc) {
>  		nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
>  		return rc;
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
