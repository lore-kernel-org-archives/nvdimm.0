Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam03on0711.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe48::711])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB7251A1E20
 for <linux-nvdimm@lists.01.org>; Thu, 21 Jul 2016 12:41:26 -0700 (PDT)
Message-ID: <57912512.5060202@hpe.com>
Date: Thu, 21 Jul 2016 15:40:02 -0400
From: Linda Knippers <linda.knippers@hpe.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/3] nfit, libnvdimm: allow an ARS scrub to be triggered
 on demand
References: <1469065850-32401-1-git-send-email-vishal.l.verma@intel.com>
 <1469065850-32401-3-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1469065850-32401-3-git-send-email-vishal.l.verma@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, Tony Luck <tony.luck@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 07/20/2016 09:50 PM, Vishal Verma wrote:
> Normally, an ARS (Address Range Scrub) only happens at
> boot/initialization time. There can however arise situations where a
> bus-wide rescan is needed - notably, in the case of discovering a latent
> media error, we should do a full rescan to figure out what other sectors
> are bad, and thus potentially avoid triggering an mce on them in the
> future. Also provide a sysfs trigger to start a bus-wide scrub.

I don't see anything in here that checks to see if the platform actually
supports ARS before setting all this stuff up.  Setting up an MCE handler
and exposing a sysfs trigger for something that is optional and perhaps
not implemented doesn't seem helpful.  Or is there a check that I missed?

-- ljk

> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: <linux-acpi@vger.kernel.org>
> Cc: <linux-nvdimm@lists.01.org>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/acpi/nfit.c              | 123 +++++++++++++++++++++++++++++++++------
>  drivers/acpi/nfit.h              |   4 +-
>  drivers/nvdimm/core.c            |   7 +++
>  include/linux/libnvdimm.h        |   1 +
>  tools/testing/nvdimm/test/nfit.c |  16 +++++
>  5 files changed, 131 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index ac6ddcc0..4e65255 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -15,6 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/ndctl.h>
> +#include <linux/sysfs.h>
>  #include <linux/delay.h>
>  #include <linux/list.h>
>  #include <linux/acpi.h>
> @@ -806,8 +807,41 @@ static ssize_t revision_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(revision);
>  
> +/*
> + * This shows the number of full Address Range Scrubs that have been
> + * completed since driver load time. Userspace can wait on this using
> + * select/poll etc.
> + */
> +static ssize_t scrub_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
> +	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
> +	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
> +
> +	return sprintf(buf, "%d\n", acpi_desc->scrub_count);
> +}
> +
> +static int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc);
> +
> +static ssize_t scrub_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
> +	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
> +	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
> +	int rc;
> +
> +	rc = acpi_nfit_ars_rescan(acpi_desc);
> +	if (rc)
> +		return rc;
> +	return size;
> +}
> +static DEVICE_ATTR_RW(scrub);
> +
>  static struct attribute *acpi_nfit_attributes[] = {
>  	&dev_attr_revision.attr,
> +	&dev_attr_scrub.attr,
>  	NULL,
>  };
>  
> @@ -2138,7 +2172,7 @@ static void acpi_nfit_async_scrub(struct acpi_nfit_desc *acpi_desc,
>  	unsigned int tmo = scrub_timeout;
>  	int rc;
>  
> -	if (nfit_spa->ars_done || !nfit_spa->nd_region)
> +	if (!(nfit_spa->ars_required && nfit_spa->nd_region))
>  		return;
>  
>  	rc = ars_start(acpi_desc, nfit_spa);
> @@ -2227,7 +2261,9 @@ static void acpi_nfit_scrub(struct work_struct *work)
>  	 * firmware initiated scrubs to complete and then we go search for the
>  	 * affected spa regions to mark them scanned.  In the second phase we
>  	 * initiate a directed scrub for every range that was not scrubbed in
> -	 * phase 1.
> +	 * phase 1. If we're called for a 'rescan', we harmlessly pass through
> +	 * the first phase, but really only care about running phase 2, where
> +	 * regions can be notified of new poison.
>  	 */
>  
>  	/* process platform firmware initiated scrubs */
> @@ -2330,14 +2366,17 @@ static void acpi_nfit_scrub(struct work_struct *work)
>  		 * Flag all the ranges that still need scrubbing, but
>  		 * register them now to make data available.
>  		 */
> -		if (nfit_spa->nd_region)
> -			nfit_spa->ars_done = 1;
> -		else
> +		if (!nfit_spa->nd_region) {
> +			nfit_spa->ars_required = 1;
>  			acpi_nfit_register_region(acpi_desc, nfit_spa);
> +		}
>  	}
>  
>  	list_for_each_entry(nfit_spa, &acpi_desc->spas, list)
>  		acpi_nfit_async_scrub(acpi_desc, nfit_spa);
> +	acpi_desc->scrub_count++;
> +	if (acpi_desc->scrub_count_state)
> +		sysfs_notify_dirent(acpi_desc->scrub_count_state);
>  	mutex_unlock(&acpi_desc->init_mutex);
>  }
>  
> @@ -2495,6 +2534,27 @@ static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
>  	return 0;
>  }
>  
> +static int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc)
> +{
> +	struct device *dev = acpi_desc->dev;
> +	struct nfit_spa *nfit_spa;
> +
> +	if (work_busy(&acpi_desc->work))
> +		return -EBUSY;
> +
> +	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
> +		struct acpi_nfit_system_address *spa = nfit_spa->spa;
> +
> +		if (nfit_spa_type(spa) != NFIT_SPA_PM)
> +			continue;
> +
> +		nfit_spa->ars_required = 1;
> +	}
> +	queue_work(nfit_wq, &acpi_desc->work);
> +	dev_info(dev, "%s: ars_scan triggered\n", __func__);
> +	return 0;
> +}
> +
>  void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
>  {
>  	struct nvdimm_bus_descriptor *nd_desc;
> @@ -2523,6 +2583,37 @@ void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(acpi_nfit_desc_init);
>  
> +static struct acpi_nfit_desc *acpi_nfit_desc_alloc_register(struct device *dev)
> +{
> +	struct acpi_nfit_desc *acpi_desc;
> +	struct kernfs_node *nfit;
> +	struct device *bus_dev;
> +
> +	acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
> +	if (!acpi_desc)
> +		return ERR_PTR(-ENOMEM);
> +
> +	acpi_nfit_desc_init(acpi_desc, dev);
> +
> +	acpi_desc->nvdimm_bus = nvdimm_bus_register(dev, &acpi_desc->nd_desc);
> +	if (!acpi_desc->nvdimm_bus)
> +		return ERR_PTR(-ENOMEM);
> +
> +	bus_dev = to_nvdimm_bus_dev(acpi_desc->nvdimm_bus);
> +	nfit = sysfs_get_dirent(bus_dev->kobj.sd, "nfit");
> +	if (!nfit) {
> +		dev_err(dev, "sysfs_get_dirent 'nfit' failed\n");
> +		return ERR_PTR(-ENODEV);
> +	}
> +	acpi_desc->scrub_count_state = sysfs_get_dirent(nfit, "scrub");
> +	if (!acpi_desc->scrub_count_state) {
> +		dev_err(dev, "sysfs_get_dirent 'scrub' failed\n");
> +		return ERR_PTR(-ENODEV);
> +	}
> +
> +	return acpi_desc;
> +}
> +
>  static int acpi_nfit_add(struct acpi_device *adev)
>  {
>  	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
> @@ -2540,13 +2631,9 @@ static int acpi_nfit_add(struct acpi_device *adev)
>  		return 0;
>  	}
>  
> -	acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
> -	if (!acpi_desc)
> -		return -ENOMEM;
> -	acpi_nfit_desc_init(acpi_desc, &adev->dev);
> -	acpi_desc->nvdimm_bus = nvdimm_bus_register(dev, &acpi_desc->nd_desc);
> -	if (!acpi_desc->nvdimm_bus)
> -		return -ENOMEM;
> +	acpi_desc = acpi_nfit_desc_alloc_register(dev);
> +	if (IS_ERR(acpi_desc))
> +		return PTR_ERR(acpi_desc);
>  
>  	/*
>  	 * Save the acpi header for later and then skip it,
> @@ -2587,6 +2674,7 @@ static int acpi_nfit_remove(struct acpi_device *adev)
>  
>  	acpi_desc->cancel = 1;
>  	flush_workqueue(nfit_wq);
> +	sysfs_put(acpi_desc->scrub_count_state);
>  	nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
>  	return 0;
>  }
> @@ -2611,13 +2699,10 @@ static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
>  	}
>  
>  	if (!acpi_desc) {
> -		acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
> -		if (!acpi_desc)
> -			goto out_unlock;
> -		acpi_nfit_desc_init(acpi_desc, &adev->dev);
> -		acpi_desc->nvdimm_bus = nvdimm_bus_register(dev, &acpi_desc->nd_desc);
> -		if (!acpi_desc->nvdimm_bus)
> -			goto out_unlock;
> +		acpi_desc = acpi_nfit_desc_alloc_register(dev);
> +		if (IS_ERR(acpi_desc))
> +			dev_err(dev, "%s: failed to alloc acpi_desc (%ld)\n",
> +				__func__, PTR_ERR(acpi_desc));
>  	} else {
>  		/*
>  		 * Finish previous registration before considering new
> diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
> index 02b9ea1..954d2aa 100644
> --- a/drivers/acpi/nfit.h
> +++ b/drivers/acpi/nfit.h
> @@ -77,7 +77,7 @@ struct nfit_spa {
>  	struct acpi_nfit_system_address *spa;
>  	struct list_head list;
>  	struct nd_region *nd_region;
> -	unsigned int ars_done:1;
> +	unsigned int ars_required:1;
>  	u32 clear_err_unit;
>  	u32 max_ars;
>  };
> @@ -146,6 +146,8 @@ struct acpi_nfit_desc {
>  	struct nd_cmd_ars_status *ars_status;
>  	size_t ars_status_size;
>  	struct work_struct work;
> +	struct kernfs_node *scrub_count_state;
> +	unsigned int scrub_count;
>  	unsigned int cancel:1;
>  	unsigned long dimm_cmd_force_en;
>  	unsigned long bus_cmd_force_en;
> diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
> index be89764..d81db3ac 100644
> --- a/drivers/nvdimm/core.c
> +++ b/drivers/nvdimm/core.c
> @@ -99,6 +99,13 @@ struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus)
>  }
>  EXPORT_SYMBOL_GPL(to_nd_desc);
>  
> +struct device *to_nvdimm_bus_dev(struct nvdimm_bus *nvdimm_bus)
> +{
> +	/* struct nvdimm_bus definition is private to libnvdimm */
> +	return &nvdimm_bus->dev;
> +}
> +EXPORT_SYMBOL_GPL(to_nvdimm_bus_dev);
> +
>  struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev)
>  {
>  	struct device *dev;
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index 0c3c30c..27cecc2 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -129,6 +129,7 @@ struct nvdimm *to_nvdimm(struct device *dev);
>  struct nd_region *to_nd_region(struct device *dev);
>  struct nd_blk_region *to_nd_blk_region(struct device *dev);
>  struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus);
> +struct device *to_nvdimm_bus_dev(struct nvdimm_bus *nvdimm_bus);
>  const char *nvdimm_name(struct nvdimm *nvdimm);
>  unsigned long nvdimm_cmd_mask(struct nvdimm *nvdimm);
>  void *nvdimm_provider_data(struct nvdimm *nvdimm);
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index c919866..74231de 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -20,6 +20,7 @@
>  #include <linux/mutex.h>
>  #include <linux/ndctl.h>
>  #include <linux/sizes.h>
> +#include <linux/sysfs.h>
>  #include <linux/list.h>
>  #include <linux/slab.h>
>  #include <nfit.h>
> @@ -1409,6 +1410,8 @@ static int nfit_test_probe(struct platform_device *pdev)
>  	struct acpi_nfit_desc *acpi_desc;
>  	struct device *dev = &pdev->dev;
>  	struct nfit_test *nfit_test;
> +	struct kernfs_node *nfit;
> +	struct device *bus_dev;
>  	int rc;
>  
>  	nfit_test = to_nfit_test(&pdev->dev);
> @@ -1471,6 +1474,18 @@ static int nfit_test_probe(struct platform_device *pdev)
>  	if (!acpi_desc->nvdimm_bus)
>  		return -ENXIO;
>  
> +	bus_dev = to_nvdimm_bus_dev(acpi_desc->nvdimm_bus);
> +	nfit = sysfs_get_dirent(bus_dev->kobj.sd, "nfit");
> +	if (!nfit) {
> +		dev_err(dev, "sysfs_get_dirent 'nfit' failed\n");
> +		return -ENODEV;
> +	}
> +	acpi_desc->scrub_count_state = sysfs_get_dirent(nfit, "scrub");
> +	if (!acpi_desc->scrub_count_state) {
> +		dev_err(dev, "sysfs_get_dirent 'scrub' failed\n");
> +		return -ENODEV;
> +	}
> +
>  	rc = acpi_nfit_init(acpi_desc, nfit_test->nfit_size);
>  	if (rc) {
>  		nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
> @@ -1497,6 +1512,7 @@ static int nfit_test_remove(struct platform_device *pdev)
>  	struct nfit_test *nfit_test = to_nfit_test(&pdev->dev);
>  	struct acpi_nfit_desc *acpi_desc = &nfit_test->acpi_desc;
>  
> +	sysfs_put(acpi_desc->scrub_count_state);
>  	nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
>  
>  	return 0;
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
