Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x22a.google.com (mail-ob0-x22a.google.com
 [IPv6:2607:f8b0:4003:c01::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B60E01A1F0A
 for <linux-nvdimm@lists.01.org>; Mon,  7 Mar 2016 10:15:01 -0800 (PST)
Received: by mail-ob0-x22a.google.com with SMTP id xx9so112707515obc.2
 for <linux-nvdimm@lists.01.org>; Mon, 07 Mar 2016 10:14:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457108082-4610-1-git-send-email-toshi.kani@hpe.com>
References: <1457108082-4610-1-git-send-email-toshi.kani@hpe.com>
Date: Mon, 7 Mar 2016 10:14:48 -0800
Message-ID: <CAPcyv4g8+6LBW08JZ3Ym0mAuo1bcwjGTeHrzS0p=QoJb4Mqeag@mail.gmail.com>
Subject: Re: [PATCH v2-UPDATE 3/4] resource: Add device-managed
 insert/remove_resource()
From: Dan Williams <dan.j.williams@intel.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

[ adding Linus for the implications of exporting insert_resource() ]

On Fri, Mar 4, 2016 at 8:14 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> insert_resource() and remove_resouce() are called by producers
> of resources, such as FW modules and bus drivers.  These modules
> may be implemented as loadable modules.
>
> Add device-managed implementaions of insert_resource() and
> remove_resouce() functions.
>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> ---
> v2-UPDATE:
>  - Rename a helper remove func to __devm_remove_resource(). (Dan Williams)
> ---
>  include/linux/ioport.h |    5 +++
>  kernel/resource.c      |   69 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 74 insertions(+)
>
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 8017b8b..3580038 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -259,6 +259,11 @@ extern struct resource * __devm_request_region(struct device *dev,
>
>  extern void __devm_release_region(struct device *dev, struct resource *parent,
>                                   resource_size_t start, resource_size_t n);
> +
> +extern int devm_insert_resource(struct device *dev, struct resource *root,
> +                                struct resource *new);
> +extern void devm_remove_resource(struct device *dev, struct resource *old);
> +
>  extern int iomem_map_sanity_check(resource_size_t addr, unsigned long size);
>  extern int iomem_is_exclusive(u64 addr);
>
> diff --git a/kernel/resource.c b/kernel/resource.c
> index effb6ee..12a9d57 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1449,6 +1449,75 @@ void __devm_release_region(struct device *dev, struct resource *parent,
>  EXPORT_SYMBOL(__devm_release_region);
>
>  /*
> + * Helper remove function for devm_insert_resource() and devm_remove_resource()
> + */
> +static void __devm_remove_resource(struct device *dev, void *ptr)
> +{
> +       struct resource **r = ptr;
> +
> +       remove_resource(*r);
> +}
> +
> +/**
> + * devm_insert_resource() - insert an I/O or memory resource
> + * @dev: device for which to produce the resource
> + * @root: root of the resource tree
> + * @new: descriptor of the new resource
> + *
> + * This is a device-managed version of insert_resource(). There is usually
> + * no need to release resources requested by this function explicitly since
> + * that will be taken care of when the device is unbound from its bus driver.
> + * If for some reason the resource needs to be released explicitly, because
> + * of ordering issues for example, bus drivers must call devm_remove_resource()
> + * rather than the regular remove_resource().
> + *
> + * devm_insert_resource() is intended for producers of resources, such as
> + * FW modules and bus drivers.
> + *
> + * Returns 0 on success or a negative error code on failure.
> + */
> +int devm_insert_resource(struct device *dev, struct resource *root,
> +                         struct resource *new)
> +{
> +       struct resource **ptr;
> +       int ret;
> +
> +       ptr = devres_alloc(__devm_remove_resource, sizeof(*ptr), GFP_KERNEL);
> +       if (!ptr)
> +               return -ENOMEM;
> +
> +       *ptr = new;
> +
> +       ret = insert_resource(root, new);
> +       if (ret) {
> +               dev_err(dev, "unable to insert resource: %pR (%d)\n", new, ret);
> +               devres_free(ptr);
> +               return -EBUSY;
> +       }
> +
> +       devres_add(dev, ptr);
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(devm_insert_resource);

The only hesitation I have with this is that the kernel has gotten by
a long time without allowing external modules to insert resources.  If
keeping it private all this time was purposeful then maybe we should
make this new NVDIMM-need to call insert_resource() private to the
nfit driver and built-in-only.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
