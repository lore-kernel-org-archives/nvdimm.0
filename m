Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DDE651A1E01
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 09:16:07 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id j185so32614128oih.0
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 09:15:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1468889100-30698-3-git-send-email-vishal.l.verma@intel.com>
References: <1468889100-30698-1-git-send-email-vishal.l.verma@intel.com>
 <1468889100-30698-3-git-send-email-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Jul 2016 09:15:16 -0700
Message-ID: <CAPcyv4guVe2Mm_EaBMMRqpfCahR_E0xbhtE30VoDAb+sqvK=AQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] nfit, libnvdimm: allow an ARS rescan to be triggered
 on demand
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

On Mon, Jul 18, 2016 at 5:44 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Normally, an ARS (Address Range Scrub) only happens at
> boot/initialization time. There can however arise situations where a
> bus-wide rescan is needed - notably, in the case of discovering a latent
> media error, we should do a full rescan to figure out what other sectors
> are bad, and thus potentially avoid triggering an mce on them in the
> future. Also provide a sysfs trigger to start a bus-wide rescan.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: <linux-acpi@vger.kernel.org>
> Cc: <linux-nvdimm@lists.01.org>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/acpi/nfit.c       | 36 ++++++++++++++++++++++++++++++++----
>  drivers/acpi/nfit.h       |  1 +
>  drivers/nvdimm/core.c     | 17 +++++++++++++++++
>  include/linux/libnvdimm.h |  1 +
>  4 files changed, 51 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index ac6ddcc0..def9505 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -2138,8 +2138,9 @@ static void acpi_nfit_async_scrub(struct acpi_nfit_desc *acpi_desc,
>         unsigned int tmo = scrub_timeout;
>         int rc;
>
> -       if (nfit_spa->ars_done || !nfit_spa->nd_region)
> -               return;
> +       if (!nfit_spa->ars_rescan)
> +               if (nfit_spa->ars_done || !nfit_spa->nd_region)
> +                       return;

Do we need a new flag? Why not just clear ->ars_done?

>
>         rc = ars_start(acpi_desc, nfit_spa);
>         /*
> @@ -2227,7 +2228,9 @@ static void acpi_nfit_scrub(struct work_struct *work)
>          * firmware initiated scrubs to complete and then we go search for the
>          * affected spa regions to mark them scanned.  In the second phase we
>          * initiate a directed scrub for every range that was not scrubbed in
> -        * phase 1.
> +        * phase 1. If we're called for a 'rescan', we harmlessly pass through
> +        * the first phase, but really only care about running phase 2, where
> +        * regions can be notified of new poison.
>          */

I don't think we need to distinguish the initial scan case from the
re-scan case in acpi_nfit_scrub().  Whether it's a scan or a re-scan
doesn't matter to acpi_nfit_scrub().

>
>         /* process platform firmware initiated scrubs */
> @@ -2336,8 +2339,10 @@ static void acpi_nfit_scrub(struct work_struct *work)
>                         acpi_nfit_register_region(acpi_desc, nfit_spa);
>         }
>
> -       list_for_each_entry(nfit_spa, &acpi_desc->spas, list)
> +       list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
>                 acpi_nfit_async_scrub(acpi_desc, nfit_spa);
> +               nfit_spa->ars_rescan = 0;
> +       }
>         mutex_unlock(&acpi_desc->init_mutex);
>  }
>
> @@ -2495,6 +2500,28 @@ static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
>         return 0;
>  }
>
> +static int acpi_nfit_ars_rescan(struct nvdimm_bus_descriptor *nd_desc)
> +{
> +       struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
> +       struct device *dev = acpi_desc->dev;
> +       struct nfit_spa *nfit_spa;
> +
> +       if (work_busy(&acpi_desc->work))
> +               return -EBUSY;

How does userspace figure out when the queue is not busy?  See below
in the notes about the ars_rescan attribute.

> +
> +       list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
> +               struct acpi_nfit_system_address *spa = nfit_spa->spa;
> +
> +               if (nfit_spa_type(spa) != NFIT_SPA_PM)
> +                       continue;
> +
> +               nfit_spa->ars_rescan = 1;
> +       }
> +       queue_work(nfit_wq, &acpi_desc->work);
> +       dev_info(dev, "%s: ars_rescan triggered\n", __func__);
> +       return 0;
> +}
> +
>  void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
>  {
>         struct nvdimm_bus_descriptor *nd_desc;
> @@ -2507,6 +2534,7 @@ void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
>         nd_desc->ndctl = acpi_nfit_ctl;
>         nd_desc->flush_probe = acpi_nfit_flush_probe;
>         nd_desc->clear_to_send = acpi_nfit_clear_to_send;
> +       nd_desc->ars_rescan = acpi_nfit_ars_rescan;
>         nd_desc->attr_groups = acpi_nfit_attribute_groups;
>
>         INIT_LIST_HEAD(&acpi_desc->spa_maps);
> diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
> index 02b9ea1..db95c5d 100644
> --- a/drivers/acpi/nfit.h
> +++ b/drivers/acpi/nfit.h
> @@ -78,6 +78,7 @@ struct nfit_spa {
>         struct list_head list;
>         struct nd_region *nd_region;
>         unsigned int ars_done:1;
> +       unsigned int ars_rescan:1;
>         u32 clear_err_unit;
>         u32 max_ars;
>  };
> diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
> index be89764..54f6fd5 100644
> --- a/drivers/nvdimm/core.c
> +++ b/drivers/nvdimm/core.c
> @@ -313,10 +313,27 @@ static ssize_t wait_probe_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(wait_probe);
>
> +static ssize_t ars_rescan_store(struct device *dev,
> +               struct device_attribute *attr, const char *buf, size_t size)
> +{
> +       struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
> +       struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
> +       int rc;
> +
> +       if (nd_desc->ars_rescan) {
> +               rc = nd_desc->ars_rescan(nd_desc);
> +               if (rc)
> +                       return rc;
> +       }
> +       return size;
> +}
> +static DEVICE_ATTR_WO(ars_rescan);

A few notes:

1/ ARS is unique to the nfit driver so let's make this nfit specific,
i.e. add it to acpi_nfit_attribute_group.

2/ Let's just call the attribute scrub and not distinguish it as "re-"

3/ Userspace may want to know when scanning is complete so let's make
this attribute read/write and on read return a count of the number of
completed scans since the driver was loaded.  For notification of last
completion use sysfs_notify_dirent_safe() to make this scrub attribute
select()/poll() capable.

> +
>  static struct attribute *nvdimm_bus_attributes[] = {
>         &dev_attr_commands.attr,
>         &dev_attr_wait_probe.attr,
>         &dev_attr_provider.attr,
> +       &dev_attr_ars_rescan.attr,
>         NULL,
>  };
>
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index 0c3c30c..1c6867a 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -74,6 +74,7 @@ struct nvdimm_bus_descriptor {
>         int (*flush_probe)(struct nvdimm_bus_descriptor *nd_desc);
>         int (*clear_to_send)(struct nvdimm_bus_descriptor *nd_desc,
>                         struct nvdimm *nvdimm, unsigned int cmd);
> +       int (*ars_rescan)(struct nvdimm_bus_descriptor *nd_desc);
>  };
>
>  struct nd_cmd_desc {
> --
> 2.7.4
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
