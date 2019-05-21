Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190517215438.6487-1-pasha.tatashin@soleen.com> <20190517215438.6487-4-pasha.tatashin@soleen.com>
In-Reply-To: <20190517215438.6487-4-pasha.tatashin@soleen.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 21 May 2019 09:54:03 -0700
Message-ID: <CAPcyv4iZ7sx6L+3yDKSXth6b+qdtCmVrLxmCvCuRAYBMbSM+Bw@mail.gmail.com>
Subject: Re: [v6 3/3] device-dax: "Hotremove" persistent memory that is used
 like normal RAM
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: James Morris <jmorris@namei.org>, Sasha Levin <sashal@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Dave Hansen <dave.hansen@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <zwisler@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Huang, Ying" <ying.huang@intel.com>, Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Takashi Iwai <tiwai@suse.de>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, David Hildenbrand <david@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 17, 2019 at 2:54 PM Pavel Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> It is now allowed to use persistent memory like a regular RAM, but
> currently there is no way to remove this memory until machine is
> rebooted.
>
> This work expands the functionality to also allows hotremoving
> previously hotplugged persistent memory, and recover the device for use
> for other purposes.
>
> To hotremove persistent memory, the management software must first
> offline all memory blocks of dax region, and than unbind it from
> device-dax/kmem driver. So, operations should look like this:
>
> echo offline > /sys/devices/system/memory/memoryN/state
> ...
> echo dax0.0 > /sys/bus/dax/drivers/kmem/unbind
>
> Note: if unbind is done without offlining memory beforehand, it won't be
> possible to do dax0.0 hotremove, and dax's memory is going to be part of
> System RAM until reboot.
>
> Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> ---
>  drivers/dax/dax-private.h |  2 ++
>  drivers/dax/kmem.c        | 41 +++++++++++++++++++++++++++++++++++----
>  2 files changed, 39 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index a45612148ca0..999aaf3a29b3 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -53,6 +53,7 @@ struct dax_region {
>   * @pgmap - pgmap for memmap setup / lifetime (driver owned)
>   * @ref: pgmap reference count (driver owned)
>   * @cmp: @ref final put completion (driver owned)
> + * @dax_mem_res: physical address range of hotadded DAX memory
>   */
>  struct dev_dax {
>         struct dax_region *region;
> @@ -62,6 +63,7 @@ struct dev_dax {
>         struct dev_pagemap pgmap;
>         struct percpu_ref ref;
>         struct completion cmp;
> +       struct resource *dax_kmem_res;
>  };
>
>  static inline struct dev_dax *to_dev_dax(struct device *dev)
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 4c0131857133..3d0a7e702c94 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -71,21 +71,54 @@ int dev_dax_kmem_probe(struct device *dev)
>                 kfree(new_res);
>                 return rc;
>         }
> +       dev_dax->dax_kmem_res = new_res;
>
>         return 0;
>  }
>
> +#ifdef CONFIG_MEMORY_HOTREMOVE
> +static int dev_dax_kmem_remove(struct device *dev)
> +{
> +       struct dev_dax *dev_dax = to_dev_dax(dev);
> +       struct resource *res = dev_dax->dax_kmem_res;
> +       resource_size_t kmem_start = res->start;
> +       resource_size_t kmem_size = resource_size(res);
> +       int rc;
> +
> +       /*
> +        * We have one shot for removing memory, if some memory blocks were not
> +        * offline prior to calling this function remove_memory() will fail, and
> +        * there is no way to hotremove this memory until reboot because device
> +        * unbind will succeed even if we return failure.
> +        */
> +       rc = remove_memory(dev_dax->target_node, kmem_start, kmem_size);
> +       if (rc) {
> +               dev_err(dev,
> +                       "DAX region %pR cannot be hotremoved until the next reboot\n",
> +                       res);

Small quibbles with this error message... "DAX" is redundant since the
device name is printed by dev_err(). I'd suggest dropping "until the
next reboot" since there is no guarantee it will work then either and
the surefire mechanism to recover the memory from the kmem driver is
to not add it in the first place. Perhaps also print out the error
code in case it might specify a finer grained reason the memory is
pinned.

Other than that you can add

   Reviewed-by: Dan Williams <dan.j.williams@intel.com>

...as it looks like Andrew will take this through -mm.
