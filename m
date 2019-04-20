Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 72CC62120B107
 for <linux-nvdimm@lists.01.org>; Sat, 20 Apr 2019 09:18:28 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id t8so6490941otp.7
 for <linux-nvdimm@lists.01.org>; Sat, 20 Apr 2019 09:18:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190420153148.21548-1-pasha.tatashin@soleen.com>
 <20190420153148.21548-3-pasha.tatashin@soleen.com>
In-Reply-To: <20190420153148.21548-3-pasha.tatashin@soleen.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 20 Apr 2019 09:18:16 -0700
Message-ID: <CAPcyv4j9sG6Wy3EfTuPb0uZ2qp=gr9UgUhpnXQA_g6Ko9KFmLA@mail.gmail.com>
Subject: Re: [v1 2/2] device-dax: "Hotremove" persistent memory that is used
 like normal RAM
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
To: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Sasha Levin <sashal@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Huang, Ying" <ying.huang@intel.com>, James Morris <jmorris@namei.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Apr 20, 2019 at 8:36 AM Pavel Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> It is now allowed to use persistent memory like a regular RAM, but
> currently there is no way to remove this memory until machine is
> rebooted.
>
> This work expands the functionality to also allow hot removing
> previously hotplugged persistent memory, and recover the device for use
> for other purposes.
>
> To hotremove persistent memory, the management software must unbind it
> from device-dax/kmem driver:
>
>             echo dax0.0 > /sys/bus/dax/drivers/kmem/unbind
>
> Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
> ---
>  drivers/dax/dax-private.h |  2 +
>  drivers/dax/kmem.c        | 77 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 75 insertions(+), 4 deletions(-)
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
> index 4c0131857133..026c34f93df5 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -71,21 +71,90 @@ int dev_dax_kmem_probe(struct device *dev)
>                 kfree(new_res);
>                 return rc;
>         }
> +       dev_dax->dax_kmem_res = new_res;
>
>         return 0;
>  }
>
> +#ifdef CONFIG_MEMORY_HOTREMOVE
> +/*
> + * Offline device-dax's memory_blocks. If a memory_block cannot be offlined
> + * a warning is printed and an error is returned. dax hotremove can succeed
> + * only when every memory_block is offline.
> + */
> +static int
> +offline_memblock_cb(struct memory_block *mem, void *arg)
> +{
> +       struct device *dev = (struct device *)arg;
> +       int rc = device_offline(&mem->dev);
> +
> +       if (rc < 0) {
> +               unsigned long spfn = section_nr_to_pfn(mem->start_section_nr);
> +               unsigned long epfn = section_nr_to_pfn(mem->end_section_nr);
> +               phys_addr_t spa = spfn << PAGE_SHIFT;
> +               phys_addr_t epa = epfn << PAGE_SHIFT;
> +
> +               dev_warn(dev, "could not offline memory block [%pa-%pa]\n",
> +                        &spa, &epa);
> +
> +               return rc;
> +       }
> +
> +       return 0;
> +}
> +
> +static int dev_dax_kmem_remove(struct device *dev)
> +{
> +       struct dev_dax *dev_dax = to_dev_dax(dev);
> +       struct resource *res = dev_dax->dax_kmem_res;
> +       resource_size_t kmem_start;
> +       resource_size_t kmem_size;
> +       unsigned long start_pfn;
> +       unsigned long end_pfn;
> +       int rc;
> +
> +       /*
> +        * dax kmem resource does not exist, means memory was never hotplugged.
> +        * So, nothing to do here.
> +        */
> +       if (!res)
> +               return 0;
> +
> +       kmem_start = res->start;
> +       kmem_size = resource_size(res);
> +       start_pfn = kmem_start >> PAGE_SHIFT;
> +       end_pfn = start_pfn + (kmem_size >> PAGE_SHIFT) - 1;
> +
> +       /* Walk and offline every singe memory_block of the dax region. */
> +       lock_device_hotplug();
> +       rc = walk_memory_range(start_pfn, end_pfn, dev, offline_memblock_cb);
> +       unlock_device_hotplug();
> +       if (rc)
> +               return rc;

This potential early return is the reason why memory hotremove is not
reliable vs the driver-core. If this walk fails to offline the memory
it will still be online, but the driver-core has no consideration for
device-unbind failing. The ubind will proceed while the memory stays
pinned.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
