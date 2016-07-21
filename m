Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam01on0731.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe42::731])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1B1011A1E43
 for <linux-nvdimm@lists.01.org>; Thu, 21 Jul 2016 13:55:25 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] nfit: do an ARS scrub on hitting a latent media
 error
References: <1469065850-32401-1-git-send-email-vishal.l.verma@intel.com>
 <1469065850-32401-4-git-send-email-vishal.l.verma@intel.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <b8252ea0-2c3b-c26f-82c0-a3728f61d27d@hpe.com>
Date: Thu, 21 Jul 2016 16:54:26 -0400
MIME-Version: 1.0
In-Reply-To: <1469065850-32401-4-git-send-email-vishal.l.verma@intel.com>
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



On 7/20/2016 9:50 PM, Vishal Verma wrote:
> When a latent (unknown to 'badblocks') error is encountered, it will
> trigger a machine check exception. On a system with machine check
> recovery, this will only SIGBUS the process(es) which had the bad page
> mapped (as opposed to a kernel panic on platforms without machine
> check recovery features). In the former case, we want to trigger a full
> rescan of that nvdimm bus. This will allow any additional, new errors
> to be captured in the block devices' badblocks lists, and offending
> operations on them can be trapped early, avoiding machine checks.

Do we really need to rescan all SPA ranges?  If the problem is with
an NVDIMM, wouldn't the blast radius be the device or it's interleave set,
which would be part of the same SPA range?

I don't know what the overhead associated with a scan is which is why I'm asking.

-- ljk

> 
> This is done by registering a callback function with the
> x86_mce_decoder_chain and calling the new ars_rescan functionality with
> the address in the mce notificatiion.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: <linux-acpi@vger.kernel.org>
> Cc: <linux-nvdimm@lists.01.org>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/acpi/nfit.c | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/nfit.h |  1 +
>  2 files changed, 90 insertions(+)
> 
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index 4e65255..c9f1ee4 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -12,6 +12,7 @@
>   */
>  #include <linux/list_sort.h>
>  #include <linux/libnvdimm.h>
> +#include <linux/notifier.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/ndctl.h>
> @@ -24,6 +25,7 @@
>  #include <linux/io.h>
>  #include <linux/nd.h>
>  #include <asm/cacheflush.h>
> +#include <asm/mce.h>
>  #include "nfit.h"
>  
>  /*
> @@ -51,6 +53,9 @@ module_param(disable_vendor_specific, bool, S_IRUGO);
>  MODULE_PARM_DESC(disable_vendor_specific,
>  		"Limit commands to the publicly specified set\n");
>  
> +static LIST_HEAD(acpi_descs);
> +static DEFINE_MUTEX(acpi_desc_lock);
> +
>  static struct workqueue_struct *nfit_wq;
>  
>  struct nfit_table_prev {
> @@ -2416,9 +2421,11 @@ static int acpi_nfit_check_deletions(struct acpi_nfit_desc *acpi_desc,
>  
>  int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
>  {
> +	struct acpi_nfit_desc *acpi_desc_entry;
>  	struct device *dev = acpi_desc->dev;
>  	struct nfit_table_prev prev;
>  	const void *end;
> +	int found = 0;
>  	u8 *data;
>  	int rc;
>  
> @@ -2473,6 +2480,19 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
>  
>  	rc = acpi_nfit_register_regions(acpi_desc);
>  
> +	/*
> +	 * We may get here due to an update of the nfit via _FIT.
> +	 * Check if the acpi_desc we're (re)initializing is already
> +	 * present in the list, and if so, don't re-add it
> +	 */
> +	mutex_lock(&acpi_desc_lock);
> +	list_for_each_entry(acpi_desc_entry, &acpi_descs, list)
> +		if (acpi_desc_entry == acpi_desc)
> +			found = 1;
> +	if (found == 0)
> +		list_add_tail(&acpi_desc->list, &acpi_descs);
> +	mutex_unlock(&acpi_desc_lock);
> +
>   out_unlock:
>  	mutex_unlock(&acpi_desc->init_mutex);
>  	return rc;
> @@ -2555,6 +2575,65 @@ static int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc)
>  	return 0;
>  }
>  
> +static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
> +			void *data)
> +{
> +	struct mce *mce = (struct mce *)data;
> +	struct acpi_nfit_desc *acpi_desc;
> +	struct nfit_spa *nfit_spa;
> +
> +	/* We only care about memory errors */
> +	if (!(mce->status & MCACOD))
> +		return NOTIFY_DONE;
> +
> +	/*
> +	 * mce->addr contains the physical addr accessed that caused the
> +	 * machine check. We need to walk through the list of NFITs, and see
> +	 * if any of them matches that address, and only then start a scrub.
> +	 */
> +	mutex_lock(&acpi_desc_lock);
> +	list_for_each_entry(acpi_desc, &acpi_descs, list) {
> +		struct device *dev = acpi_desc->dev;
> +		int found_match = 0;
> +
> +		list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
> +			struct acpi_nfit_system_address *spa = nfit_spa->spa;
> +
> +			if (nfit_spa_type(spa) != NFIT_SPA_PM)
> +				continue;
> +			/* find the spa that covers the mce addr */
> +			if (spa->address > mce->addr)
> +				continue;
> +			if ((spa->address + spa->length - 1) < mce->addr)
> +				continue;
> +			found_match = 1;
> +			dev_dbg(dev, "%s: addr in SPA %d (0x%llx, 0x%llx)\n",
> +				__func__, spa->range_index, spa->address,
> +				spa->length);
> +			/*
> +			 * We can break at the first match because we're going
> +			 * to rescan all the SPA ranges. There shouldn't be any
> +			 * aliasing anyway.
> +			 */
> +			break;
> +		}
> +
> +		/*
> +		 * We can ignore an -EBUSY here because if an ARS is already
> +		 * in progress, just let that be the last authoritative one
> +		 */
> +		if (found_match)
> +			acpi_nfit_ars_rescan(acpi_desc);
> +	}
> +
> +	mutex_unlock(&acpi_desc_lock);
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block nfit_mce_dec = {
> +	.notifier_call	= nfit_handle_mce,
> +};
> +
>  void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
>  {
>  	struct nvdimm_bus_descriptor *nd_desc;
> @@ -2676,6 +2755,9 @@ static int acpi_nfit_remove(struct acpi_device *adev)
>  	flush_workqueue(nfit_wq);
>  	sysfs_put(acpi_desc->scrub_count_state);
>  	nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
> +	mutex_lock(&acpi_desc_lock);
> +	list_del(&acpi_desc->list);
> +	mutex_unlock(&acpi_desc_lock);
>  	return 0;
>  }
>  
> @@ -2782,13 +2864,20 @@ static __init int nfit_init(void)
>  	if (!nfit_wq)
>  		return -ENOMEM;
>  
> +	INIT_LIST_HEAD(&acpi_descs);
> +	mce_register_decode_chain(&nfit_mce_dec);
> +
>  	return acpi_bus_register_driver(&acpi_nfit_driver);
>  }
>  
>  static __exit void nfit_exit(void)
>  {
> +	mce_unregister_decode_chain(&nfit_mce_dec);
>  	acpi_bus_unregister_driver(&acpi_nfit_driver);
>  	destroy_workqueue(nfit_wq);
> +	mutex_lock(&acpi_desc_lock);
> +	WARN_ON(!list_empty(&acpi_descs));
> +	mutex_unlock(&acpi_desc_lock);
>  }
>  
>  module_init(nfit_init);
> diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
> index 954d2aa..d2aec6f 100644
> --- a/drivers/acpi/nfit.h
> +++ b/drivers/acpi/nfit.h
> @@ -146,6 +146,7 @@ struct acpi_nfit_desc {
>  	struct nd_cmd_ars_status *ars_status;
>  	size_t ars_status_size;
>  	struct work_struct work;
> +	struct list_head list;
>  	struct kernfs_node *scrub_count_state;
>  	unsigned int scrub_count;
>  	unsigned int cancel:1;
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
