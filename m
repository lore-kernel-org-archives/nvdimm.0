Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.nue.novell.com (smtp.nue.novell.com [195.135.221.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F3991A1DFC
 for <linux-nvdimm@lists.01.org>; Fri, 22 Jul 2016 05:42:44 -0700 (PDT)
Date: Fri, 22 Jul 2016 20:41:41 +0800
From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 2/2] nfit, tools/testing/nvdimm/: unify shutdown paths
Message-ID: <20160722124141.GI12939@linux-rxt1.site>
References: <146915794457.7201.5023729229431647060.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146915794992.7201.150642033798020654.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146915794992.7201.150642033798020654.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Hi Dan,

On Thu, Jul 21, 2016 at 08:25:50PM -0700, Dan Williams wrote:
> While testing the new on-demand ARS patches we discovered that
> differences between the nfit_test and normal nfit driver shutdown paths
> can leak resources.  Unify the shutdown paths to trigger via a devm_
> callback when the acpi_desc->dev is unbound from its driver.
> 
> Reported-by: Vishal Verma <vishal.l.verma@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Lee, Chun-Yi <jlee@suse.com>

Thanks a lot!
Joey Lee

> ---
>  drivers/acpi/nfit.c              |   36 ++++++++++++++++++++++--------------
>  tools/testing/nvdimm/test/nfit.c |   16 ++--------------
>  2 files changed, 24 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index e7eb3b6f1514..be7c2fde16e7 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -2291,6 +2291,16 @@ static int acpi_nfit_check_deletions(struct acpi_nfit_desc *acpi_desc,
>  	return 0;
>  }
>  
> +static void acpi_nfit_destruct(void *data)
> +{
> +	struct acpi_nfit_desc *acpi_desc = data;
> +
> +	acpi_desc->cancel = 1;
> +	flush_workqueue(nfit_wq);
> +	nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
> +	acpi_desc->nvdimm_bus = NULL;
> +}
> +
>  int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
>  {
>  	struct device *dev = acpi_desc->dev;
> @@ -2298,6 +2308,17 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
>  	const void *end;
>  	int rc;
>  
> +	if (!acpi_desc->nvdimm_bus) {
> +		acpi_desc->nvdimm_bus = nvdimm_bus_register(dev,
> +				&acpi_desc->nd_desc);
> +		if (!acpi_desc->nvdimm_bus)
> +			return -ENOMEM;
> +		rc = devm_add_action_or_reset(dev, acpi_nfit_destruct,
> +				acpi_desc);
> +		if (rc)
> +			return rc;
> +	}
> +
>  	mutex_lock(&acpi_desc->init_mutex);
>  
>  	INIT_LIST_HEAD(&prev.spas);
> @@ -2456,9 +2477,6 @@ static int acpi_nfit_add(struct acpi_device *adev)
>  	if (!acpi_desc)
>  		return -ENOMEM;
>  	acpi_nfit_desc_init(acpi_desc, &adev->dev);
> -	acpi_desc->nvdimm_bus = nvdimm_bus_register(dev, &acpi_desc->nd_desc);
> -	if (!acpi_desc->nvdimm_bus)
> -		return -ENOMEM;
>  
>  	/* Save the acpi header for exporting the revision via sysfs */
>  	acpi_desc->acpi_header = *tbl;
> @@ -2480,19 +2498,12 @@ static int acpi_nfit_add(struct acpi_device *adev)
>  		rc = acpi_nfit_init(acpi_desc, (void *) tbl
>  				+ sizeof(struct acpi_table_nfit),
>  				sz - sizeof(struct acpi_table_nfit));
> -
> -	if (rc)
> -		nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
>  	return rc;
>  }
>  
>  static int acpi_nfit_remove(struct acpi_device *adev)
>  {
> -	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(&adev->dev);
> -
> -	acpi_desc->cancel = 1;
> -	flush_workqueue(nfit_wq);
> -	nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
> +	/* see acpi_nfit_destruct */
>  	return 0;
>  }
>  
> @@ -2519,9 +2530,6 @@ static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
>  		if (!acpi_desc)
>  			goto out_unlock;
>  		acpi_nfit_desc_init(acpi_desc, &adev->dev);
> -		acpi_desc->nvdimm_bus = nvdimm_bus_register(dev, &acpi_desc->nd_desc);
> -		if (!acpi_desc->nvdimm_bus)
> -			goto out_unlock;
>  	} else {
>  		/*
>  		 * Finish previous registration before considering new
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index 642713f15723..5404efa578a3 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -1465,16 +1465,11 @@ static int nfit_test_probe(struct platform_device *pdev)
>  	nd_desc->provider_name = NULL;
>  	nd_desc->module = THIS_MODULE;
>  	nd_desc->ndctl = nfit_test_ctl;
> -	acpi_desc->nvdimm_bus = nvdimm_bus_register(&pdev->dev, nd_desc);
> -	if (!acpi_desc->nvdimm_bus)
> -		return -ENXIO;
>  
>  	rc = acpi_nfit_init(acpi_desc, nfit_test->nfit_buf,
>  			nfit_test->nfit_size);
> -	if (rc) {
> -		nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
> +	if (rc)
>  		return rc;
> -	}
>  
>  	if (nfit_test->setup != nfit_test0_setup)
>  		return 0;
> @@ -1484,21 +1479,14 @@ static int nfit_test_probe(struct platform_device *pdev)
>  
>  	rc = acpi_nfit_init(acpi_desc, nfit_test->nfit_buf,
>  			nfit_test->nfit_size);
> -	if (rc) {
> -		nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
> +	if (rc)
>  		return rc;
> -	}
>  
>  	return 0;
>  }
>  
>  static int nfit_test_remove(struct platform_device *pdev)
>  {
> -	struct nfit_test *nfit_test = to_nfit_test(&pdev->dev);
> -	struct acpi_nfit_desc *acpi_desc = &nfit_test->acpi_desc;
> -
> -	nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
> -
>  	return 0;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
