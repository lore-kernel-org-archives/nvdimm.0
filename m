Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id 01544212735A2
 for <linux-nvdimm@lists.01.org>; Mon, 13 May 2019 21:04:55 -0700 (PDT)
Subject: Re: [RFC PATCH] mm/nvdimm: Fix kernel crash on
 devm_mremap_pages_release
References: <20190514025354.9108-1-aneesh.kumar@linux.ibm.com>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <2f08e63e-5ff9-b036-1212-9345894cca26@arm.com>
Date: Tue, 14 May 2019 09:35:01 +0530
MIME-Version: 1.0
In-Reply-To: <20190514025354.9108-1-aneesh.kumar@linux.ibm.com>
Content-Language: en-US
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, dan.j.williams@intel.com
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 05/14/2019 08:23 AM, Aneesh Kumar K.V wrote:
> When we initialize the namespace, if we support altmap, we don't initialize all the
> backing struct page where as while releasing the namespace we look at some of
> these uninitilized struct page. This results in a kernel crash as below.
Yes this has been problematic which I have also previously encountered but in a bit
different way (while searching memory resources).

> 
> kernel BUG at include/linux/mm.h:1034!
What that would be ? Did not see a corresponding BUG_ON() line in the file.

> cpu 0x2: Vector: 700 (Program Check) at [c00000024146b870]
>     pc: c0000000003788f8: devm_memremap_pages_release+0x258/0x3a0
>     lr: c0000000003788f4: devm_memremap_pages_release+0x254/0x3a0
>     sp: c00000024146bb00
>    msr: 800000000282b033
>   current = 0xc000000241382f00
>   paca    = 0xc00000003fffd680   irqmask: 0x03   irq_happened: 0x01
>     pid   = 4114, comm = ndctl
>  c0000000009bf8c0 devm_action_release+0x30/0x50
>  c0000000009c0938 release_nodes+0x268/0x2d0
>  c0000000009b95b4 device_release_driver_internal+0x164/0x230
>  c0000000009b638c unbind_store+0x13c/0x190
>  c0000000009b4f44 drv_attr_store+0x44/0x60
>  c00000000058ccc0 sysfs_kf_write+0x70/0xa0
>  c00000000058b52c kernfs_fop_write+0x1ac/0x290
>  c0000000004a415c __vfs_write+0x3c/0x70
>  c0000000004a85ac vfs_write+0xec/0x200
>  c0000000004a8920 ksys_write+0x80/0x130
>  c00000000000bee4 system_call+0x5c/0x70

I saw this as memory hotplug problem with respect to ZONE_DEVICE based device memory.
Hence a bit different explanation which I never posted. I guess parts of the commit
message here can be used for a better comprehensive explanation of the problem.

mm/hotplug: Initialize struct pages for vmem_altmap reserved areas

The following ZONE_DEVICE ranges (altmap) have valid struct pages allocated
from within device memory memmap range.

A. Driver reserved area	[BASE -> BASE + RESV)
B. Device mmap area	[BASE + RESV -> BASE + RESV + FREE]
C. Device usable area	[BASE + RESV + FREE -> END]

BASE - pgmap->altmap.base_pfn (pgmap->res.start >> PAGE_SHIFT)
RESV - pgmap->altmap.reserve
FREE - pgmap->altmap.free
END  - pgmap->res->end >> PAGE_SHIFT

Struct page init for all areas happens in two phases which detects altmap
use case and init parts of the device range in each phase.

1. memmap_init_zone		(Device mmap area)
2. memmap_init_zone_device	(Device usable area)

memmap_init_zone() skips driver reserved area and does not init the
struct pages. This is problematic primarily for two reasons.

Though NODE_DATA(device_node(dev))->node_zones[ZONE_DEVICE] contains the
device memory range in it's entirety (in zone->spanned_pages) parts of this
range does not have zone set to ZONE_DEVICE in their struct page.

__remove_pages() called directly or from within arch_remove_memory() during
ZONE_DEVICE tear down procedure (devm_memremap_pages_release) hits an error
(like below) if there are reserved pages. This is because the first pfn of
the device range (invariably also the first pfn from reserved area) cannot
be identified belonging to ZONE_DEVICE. This erroneously leads range search
within iomem_resource region which never had this device memory region. So
this eventually ends up flashing the following error.

Unable to release resource <0x0000000680000000-0x00000006bfffffff> (-22)

Initialize struct pages for the driver reserved range while still staying
clear from it's contents.

> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  mm/page_alloc.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 59661106da16..892eabe1ec13 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5740,8 +5740,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
>  
>  #ifdef CONFIG_ZONE_DEVICE
>  	/*
> -	 * Honor reservation requested by the driver for this ZONE_DEVICE
> -	 * memory. We limit the total number of pages to initialize to just
> +	 * We limit the total number of pages to initialize to just
Comment needs bit change to reflect on the fact that both driver reserved as
well as mapped area (containing altmap struct pages) needs init here.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
