Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAF8F1A1E01
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 09:25:17 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id w18so32860900oiw.3
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 09:24:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1468889100-30698-4-git-send-email-vishal.l.verma@intel.com>
References: <1468889100-30698-1-git-send-email-vishal.l.verma@intel.com>
 <1468889100-30698-4-git-send-email-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Jul 2016 09:24:26 -0700
Message-ID: <CAPcyv4iQxw_Fg7ovQsjDOb2LKsY0-MRe_E54M525sgHfTL=FOw@mail.gmail.com>
Subject: Re: [PATCH 3/3] nfit: do an ARS rescan on hitting a latent media error
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Tony Luck <tony.luck@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 18, 2016 at 5:45 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> When a latent (unknown to 'badblocks') error is encountered, it will
> trigger a machine check exception. On a system with machine check
> recovery, this will only SIGBUS the process(es) which had the bad page
> mapped (as opposed to a kernel panic on platforms without machine
> check recovery features). In the former case, we want to trigger a full
> rescan of that nvdimm bus. This will allow any additional, new errors
> to be captured in the block devices' badblocks lists, and offending
> operations on them can be trapped early, avoiding machine checks.
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
>  drivers/acpi/nfit.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/nfit.h |   1 +
>  2 files changed, 103 insertions(+)
>
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index def9505..0d2d7a3 100644
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
> @@ -23,6 +24,7 @@
>  #include <linux/io.h>
>  #include <linux/nd.h>
>  #include <asm/cacheflush.h>
> +#include <asm/mce.h>
>  #include "nfit.h"
>
>  /*
> @@ -50,6 +52,9 @@ module_param(disable_vendor_specific, bool, S_IRUGO);
>  MODULE_PARM_DESC(disable_vendor_specific,
>                 "Limit commands to the publicly specified set\n");
>
> +static LIST_HEAD(acpi_descs);
> +static DEFINE_MUTEX(acpi_desc_lock);
> +
>  static struct workqueue_struct *nfit_wq;
>
>  struct nfit_table_prev {
> @@ -2382,6 +2387,7 @@ static int acpi_nfit_check_deletions(struct acpi_nfit_desc *acpi_desc,
>
>  int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
>  {
> +       struct acpi_nfit_desc *acpi_desc_entry;
>         struct device *dev = acpi_desc->dev;
>         struct nfit_table_prev prev;
>         const void *end;
> @@ -2439,6 +2445,25 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
>
>         rc = acpi_nfit_register_regions(acpi_desc);
>
> +       /*
> +        * We may get here due to an update of the nfit via _FIT.
> +        * Check if the acpi_desc we're (re)initializing is already
> +        * present in the list, and if so, don't re-add it
> +        */
> +       mutex_lock(&acpi_desc_lock);
> +       if (list_empty(&acpi_descs))
> +               list_add_tail(&acpi_desc->list, &acpi_descs);

No need to special case list_empty(), it's covered below and this
isn't a fast path.

> +       else {
> +               int found = 0;
> +
> +               list_for_each_entry(acpi_desc_entry, &acpi_descs, list)
> +                       if (acpi_desc_entry == acpi_desc)
> +                               found = 1;
> +               if (found == 0)
> +                       list_add_tail(&acpi_desc->list, &acpi_descs);
> +       }
> +       mutex_unlock(&acpi_desc_lock);
> +
>   out_unlock:
>         mutex_unlock(&acpi_desc->init_mutex);
>         return rc;
> @@ -2522,6 +2547,69 @@ static int acpi_nfit_ars_rescan(struct nvdimm_bus_descriptor *nd_desc)
>         return 0;
>  }
>
> +static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
> +                       void *data)
> +{
> +       struct mce *mce = (struct mce *)data;
> +       struct acpi_nfit_desc *acpi_desc;
> +       struct nfit_spa *nfit_spa;
> +
> +       /* We only care about memory errors */
> +       if (!(mce->status & MCACOD))
> +               return NOTIFY_DONE;
> +
> +       /*
> +        * mce->addr contains the physical addr accessed that caused the
> +        * machine check. We need to walk through the list of NFITs, and see
> +        * if any of them matches that address, and only then start a scrub.
> +        */
> +       mutex_lock(&acpi_desc_lock);
> +       if (list_empty(&acpi_descs))
> +               goto out;

Again, no need to check for empty, list_for_each_entry() already does that...

> +
> +       list_for_each_entry(acpi_desc, &acpi_descs, list) {
> +               struct device *dev = acpi_desc->dev;
> +               int found_match = 0;
> +
> +               list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
> +                       struct acpi_nfit_system_address *spa = nfit_spa->spa;
> +
> +                       if (nfit_spa_type(spa) != NFIT_SPA_PM)
> +                               continue;
> +                       /* find the spa that covers the mce addr */
> +                       if (spa->address > mce->addr)
> +                               continue;
> +                       if ((spa->address + spa->length - 1) < mce->addr)
> +                               continue;
> +                       found_match = 1;
> +                       dev_dbg(dev, "%s: addr in SPA %d (0x%llx, 0x%llx)\n",
> +                               __func__, spa->range_index, spa->address,
> +                               spa->length);
> +                       /*
> +                        * We can break at the first match because we're going
> +                        * to rescan all the SPA ranges. There shouldn't be any
> +                        * aliasing anyway.
> +                        */
> +                       break;
> +               }
> +
> +               /*
> +                * We can ignore an -EBUSY here because if an ARS is already
> +                * in progress, just let that be the last authoritative one
> +                */
> +               if (found_match)
> +                       acpi_nfit_ars_rescan(&acpi_desc->nd_desc);
> +       }
> +
> + out:
> +       mutex_unlock(&acpi_desc_lock);
> +       return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block nfit_mce_dec = {
> +       .notifier_call  = nfit_handle_mce,
> +};
> +
>  void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
>  {
>         struct nvdimm_bus_descriptor *nd_desc;
> @@ -2616,6 +2704,9 @@ static int acpi_nfit_remove(struct acpi_device *adev)
>         acpi_desc->cancel = 1;
>         flush_workqueue(nfit_wq);
>         nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
> +       mutex_lock(&acpi_desc_lock);
> +       list_del(&acpi_desc->list);
> +       mutex_unlock(&acpi_desc_lock);
>         return 0;
>  }
>
> @@ -2725,13 +2816,24 @@ static __init int nfit_init(void)
>         if (!nfit_wq)
>                 return -ENOMEM;
>
> +       INIT_LIST_HEAD(&acpi_descs);
> +       mce_register_decode_chain(&nfit_mce_dec);
> +
>         return acpi_bus_register_driver(&acpi_nfit_driver);
>  }
>
>  static __exit void nfit_exit(void)
>  {
> +       struct acpi_nfit_desc *acpi_desc, *next;
> +
> +       mce_unregister_decode_chain(&nfit_mce_dec);
>         acpi_bus_unregister_driver(&acpi_nfit_driver);
>         destroy_workqueue(nfit_wq);
> +       mutex_lock(&acpi_desc_lock);
> +       if (list_empty(&acpi_descs))
> +               list_for_each_entry_safe(acpi_desc, next, &acpi_descs, list)
> +                       list_del(&acpi_desc->list);

We should WARN here, since there should be no way, outside of a bug,
that 'acpi_descs' is still populated after
acpi_bus_unregister_driver().

> +       mutex_unlock(&acpi_desc_lock);
>  }
>
>  module_init(nfit_init);
> diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
> index db95c5d..cf4d42d 100644
> --- a/drivers/acpi/nfit.h
> +++ b/drivers/acpi/nfit.h
> @@ -147,6 +147,7 @@ struct acpi_nfit_desc {
>         struct nd_cmd_ars_status *ars_status;
>         size_t ars_status_size;
>         struct work_struct work;
> +       struct list_head list;
>         unsigned int cancel:1;
>         unsigned long dimm_cmd_force_en;
>         unsigned long bus_cmd_force_en;

Outside of the minor comments above, this looks good to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
