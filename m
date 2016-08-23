Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA6D21A1E26
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 15:32:46 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id 4so217170957oih.2
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 15:32:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1471977800-12688-1-git-send-email-toshi.kani@hpe.com>
References: <1471977800-12688-1-git-send-email-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Aug 2016 15:32:45 -0700
Message-ID: <CAPcyv4g8y4P02wm6Fx5Cx1zX6_xysdYg7jG6jjz6GTX7KqCkvA@mail.gmail.com>
Subject: Re: [PATCH] memremap: Fix NULL pointer BUG in get_zone_device_page()
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
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, m.abhilash-kumar@hpe.com, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Brian Starkey <brian.starkey@arm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 23, 2016 at 11:43 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> The following BUG was observed while starting up KVM with nvdimm
> device as memory-backend-file to /dev/dax.
>
>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>  IP: [<ffffffff811ac851>] get_zone_device_page+0x11/0x30
>  Call Trace:
>    follow_devmap_pmd+0x298/0x2c0
>    follow_page_mask+0x275/0x530
>    __get_user_pages+0xe3/0x750
>    __gfn_to_pfn_memslot+0x1b2/0x450 [kvm]
>    ? hrtimer_try_to_cancel+0x2c/0x120
>    ? kvm_read_l1_tsc+0x55/0x60 [kvm]
>    try_async_pf+0x66/0x230 [kvm]
>    ? kvm_host_page_size+0x90/0xa0 [kvm]
>    tdp_page_fault+0x130/0x280 [kvm]
>    kvm_mmu_page_fault+0x5f/0xf0 [kvm]
>    handle_ept_violation+0x94/0x180 [kvm_intel]
>    vmx_handle_exit+0x1d3/0x1440 [kvm_intel]
>    ? atomic_switch_perf_msrs+0x6f/0xa0 [kvm_intel]
>    ? vmx_vcpu_run+0x2d1/0x490 [kvm_intel]
>    kvm_arch_vcpu_ioctl_run+0x81d/0x16a0 [kvm]
>    ? wake_up_q+0x44/0x80
>    kvm_vcpu_ioctl+0x33c/0x620 [kvm]
>    ? __vfs_write+0x37/0x160
>    do_vfs_ioctl+0xa2/0x5d0
>    SyS_ioctl+0x79/0x90
>    entry_SYSCALL_64_fastpath+0x1a/0xa4
>
> devm_memremap_pages() calls for_each_device_pfn() to walk through
> all pfns in page_map.  pfn_first(), however, returns a wrong pfn
> that leaves page->pgmap uninitialized.
>
> Since arch_add_memory() has set up direct mappings to the NVDIMM
> range with altmap, pfn_first() should not modify the start pfn.
> Change pfn_first() to simply return pfn of res->start.
>
> Reported-and-tested-by: Abhilash Kumar Mulumudi <m.abhilash-kumar@hpe.com>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Brian Starkey <brian.starkey@arm.com>
> ---
>  kernel/memremap.c |    8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index 251d16b..50ea577 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -210,15 +210,9 @@ static void pgmap_radix_release(struct resource *res)
>
>  static unsigned long pfn_first(struct page_map *page_map)
>  {
> -       struct dev_pagemap *pgmap = &page_map->pgmap;
>         const struct resource *res = &page_map->res;
> -       struct vmem_altmap *altmap = pgmap->altmap;
> -       unsigned long pfn;
>
> -       pfn = res->start >> PAGE_SHIFT;
> -       if (altmap)
> -               pfn += vmem_altmap_offset(altmap);
> -       return pfn;
> +       return res->start >> PAGE_SHIFT;
>  }

I'm not sure about this fix.  The point of honoring
vmem_altmap_offset() is because a portion of the resource that is
passed to devm_memremap_pages() also contains the metadata info block
for the device.  The offset says "use everything past this point for
pages".  This may work for avoiding a crash, but it may corrupt info
block metadata in the process.  Can you provide more information about
the failing scenario to be sure that we are not triggering a fault on
an address that is not meant to have a page mapping?  I.e. what is the
host physical address of the page that caused this fault, and is it
valid?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
