Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 428BA1A1E24
 for <linux-nvdimm@lists.01.org>; Wed, 28 Sep 2016 13:50:16 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id w11so68804008oia.2
 for <linux-nvdimm@lists.01.org>; Wed, 28 Sep 2016 13:50:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <147508875131.91583.12624254404354366550.stgit@djiang5-desk3.ch.intel.com>
References: <147508875131.91583.12624254404354366550.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Sep 2016 13:50:14 -0700
Message-ID: <CAPcyv4iJGBzQn9Qmt2sBdqqcHCpk7hB3jjSKgw96R8PZ-Xe-=A@mail.gmail.com>
Subject: Re: [PATCH] dev-dax: add support to display badblocks in sysfs for
 dev-dax
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 28, 2016 at 11:52 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding support to show badblocks in the pmem region that's provided
> by the poison_list. This should show up in
> /sys/class/dax/daxN.N/badblocks as read only.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/dax/dax.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
> index 29f600f..c73c494 100644
> --- a/drivers/dax/dax.c
> +++ b/drivers/dax/dax.c
> @@ -18,6 +18,8 @@
>  #include <linux/dax.h>
>  #include <linux/fs.h>
>  #include <linux/mm.h>
> +#include <linux/badblocks.h>
> +#include "../nvdimm/nd.h"
>
>  static int dax_major;
>  static struct class *dax_class;
> @@ -42,6 +44,7 @@ struct dax_region {
>         unsigned int align;
>         struct resource res;
>         unsigned long pfn_flags;
> +       struct badblocks bb;
>  };
>
>  /**
> @@ -97,6 +100,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>                 unsigned long pfn_flags)
>  {
>         struct dax_region *dax_region;
> +       struct nd_region *nd_region = to_nd_region(parent->parent);
>
>         dax_region = kzalloc(sizeof(*dax_region), GFP_KERNEL);
>
> @@ -112,6 +116,10 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>         dax_region->dev = parent;
>         dax_region->base = addr;
>
> +       if (devm_init_badblocks(parent, &dax_region->bb))
> +               return NULL;
> +       nvdimm_badblocks_populate(nd_region, &dax_region->bb, res);
> +
>         return dax_region;
>  }
>  EXPORT_SYMBOL_GPL(alloc_dax_region);
> @@ -130,8 +138,20 @@ static ssize_t size_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(size);
>
> +static ssize_t dax_dev_badblocks_show(struct device *dev,
> +               struct device_attribute *attr, char *page)
> +{
> +       struct dax_dev *dax_dev = dev_get_drvdata(dev);
> +       struct dax_region *dax_region = dax_dev->region;
> +
> +       return badblocks_show(&dax_region->bb, page, 0);

This will show the badblocks for the entire region...

> +}
> +
> +static DEVICE_ATTR(badblocks, S_IRUGO, dax_dev_badblocks_show, NULL);
> +
>  static struct attribute *dax_device_attributes[] = {
>         &dev_attr_size.attr,
> +       &dev_attr_badblocks.attr,

...but we want it to be limited per-device.

So the errors in the region need to be reconciled into the individual
resources that get assigned to the device instance.  This becomes more
important when we allow carving a dax region into multiple devices.

devm_create_dax_dev() takes a lists of resources that make up the
given instance.  Those may be discontiguous and the per-device
badblocks instance would need to account for that.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
