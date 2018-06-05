Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on0106.outbound.protection.outlook.com [104.47.0.106])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F419121163DDA
 for <linux-nvdimm@lists.01.org>; Tue,  5 Jun 2018 06:59:50 -0700 (PDT)
Subject: Re: KASAN vs ZONE_DEVICE (was: Re: [PATCH v2 2/7] dax: change
 bdev_dax_supported()...)
References: <CAPcyv4hJOzRBR0hg=xBZkd_oLtQRZeTXShYChdu8VA+GgTqUvg@mail.gmail.com>
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <71c55f5c-deed-b307-9022-8a41dd898822@virtuozzo.com>
Date: Tue, 5 Jun 2018 17:01:10 +0300
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hJOzRBR0hg=xBZkd_oLtQRZeTXShYChdu8VA+GgTqUvg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Alexander Potapenko <glider@google.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <linux-nvdimm@lists.01.org>



On 06/05/2018 07:22 AM, Dan Williams wrote:
> On Mon, Jun 4, 2018 at 8:32 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> [ adding KASAN devs...]
>>
>> On Mon, Jun 4, 2018 at 4:40 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> On Sun, Jun 3, 2018 at 6:48 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>>> On Sun, Jun 3, 2018 at 5:25 PM, Dave Chinner <david@fromorbit.com> wrote:
>>>>> On Mon, Jun 04, 2018 at 08:20:38AM +1000, Dave Chinner wrote:
>>>>>> On Thu, May 31, 2018 at 09:02:52PM -0700, Dan Williams wrote:
>>>>>>> On Thu, May 31, 2018 at 7:24 PM, Dave Chinner <david@fromorbit.com> wrote:
>>>>>>>> On Thu, May 31, 2018 at 06:57:33PM -0700, Dan Williams wrote:
>>>>>>>>>> FWIW, XFS+DAX used to just work on this setup (I hadn't even
>>>>>>>>>> installed ndctl until this morning!) but after changing the kernel
>>>>>>>>>> it no longer works. That would make it a regression, yes?
>>>>>>
>>>>>> [....]
>>>>>>
>>>>>>>>> I suspect your kernel does not have CONFIG_ZONE_DEVICE enabled which
>>>>>>>>> has the following dependencies:
>>>>>>>>>
>>>>>>>>>         depends on MEMORY_HOTPLUG
>>>>>>>>>         depends on MEMORY_HOTREMOVE
>>>>>>>>>         depends on SPARSEMEM_VMEMMAP
>>>>>>>>
>>>>>>>> Filesystem DAX now has a dependency on memory hotplug?
>>>>>>
>>>>>> [....]
>>>>>>
>>>>>>>> OK, works now I've found the magic config incantantions to turn
>>>>>>>> everything I now need on.
>>>>>>
>>>>>> By enabling these options, my test VM now has a ~30s pause in the
>>>>>> boot very soon after the nvdimm subsystem is initialised.
>>>>>>
>>>>>> [    1.523718] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>>>>>> [    1.550353] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
>>>>>> [    1.552175] Non-volatile memory driver v1.3
>>>>>> [    2.332045] tsc: Refined TSC clocksource calibration: 2199.909 MHz
>>>>>> [    2.333280] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1fb5dcd4620, max_idle_ns: 440795264143 ns
>>>>>> [   37.217453] brd: module loaded
>>>>>> [   37.225423] loop: module loaded
>>>>>> [   37.228441] virtio_blk virtio2: [vda] 10485760 512-byte logical blocks (5.37 GB/5.00 GiB)
>>>>>> [   37.245418] virtio_blk virtio3: [vdb] 146800640 512-byte logical blocks (75.2 GB/70.0 GiB)
>>>>>> [   37.255794] virtio_blk virtio4: [vdc] 1073741824000 512-byte logical blocks (550 TB/500 TiB)
>>>>>> [   37.265403] nd_pmem namespace1.0: unable to guarantee persistence of writes
>>>>>> [   37.265618] nd_pmem namespace0.0: unable to guarantee persistence of writes
>>>>>>
>>>>>> The system does not appear to be consuming CPU, but it is blocking
>>>>>> NMIs so I can't get a CPU trace. For a VM that I rely on booting in
>>>>>> a few seconds because I reboot it tens of times a day, this is a
>>>>>> problem....
>>>>>
>>>>> And when I turn on KASAN, the kernel fails to boot to a login prompt
>>>>> because:
>>>>
>>>> What's your qemu and kernel command line? I'll take look at this first
>>>> thing tomorrow.
>>>
>>> I was able to reproduce this crash by just turning on KASAN...
>>> investigating. It would still help to have your config for our own
>>> regression testing purposes it makes sense for us to prioritize
>>> "Dave's test config", similar to the priority of not breaking Linus'
>>> laptop.
>>
>> I believe this is a bug in KASAN, or a bug in devm_memremap_pages(),
>> depends on your point of view. At the very least it is a mismatch of
>> assumptions. KASAN learns of hot added memory via the memory hotplug
>> notifier. However, the devm_memremap_pages() implementation is
>> intentionally limited to the "first half" of the memory hotplug
>> procedure. I.e. it does just enough to setup the linear map for
>> pfn_to_page() and initialize the "struct page" memmap, but then stops
>> short of onlining the pages. This is why we are getting a NULL ptr
>> deref and not a KASAN report, because KASAN has no shadow area setup
>> for the linearly mapped pmem range.
>>
>> In terms of solving it we could refactor kasan_mem_notifier() so that
>> devm_memremap_pages() can call it outside of the notifier... I'll give
>> this a shot.
> 
> Well, the attached patch got me slightly further, but only slightly...
> 
> [   14.998394] BUG: KASAN: unknown-crash in pmem_do_bvec+0x19e/0x790 [nd_pmem]
> [   15.000006] Read of size 4096 at addr ffff880200000000 by task
> systemd-udevd/915
> [   15.001991]
> [   15.002590] CPU: 15 PID: 915 Comm: systemd-udevd Tainted: G
>   OE     4.17.0-rc5+ #1
> 982
> [   15.004783] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.11.1-0-g0551a
> 4be2c-prebuilt.qemu-project.org 04/01/2014
> [   15.007652] Call Trace:
> [   15.008339]  dump_stack+0x9a/0xeb
> [   15.009344]  print_address_description+0x73/0x280
> [   15.010524]  kasan_report+0x258/0x380
> [   15.011528]  ? pmem_do_bvec+0x19e/0x790 [nd_pmem]
> [   15.012747]  memcpy+0x1f/0x50
> [   15.013659]  pmem_do_bvec+0x19e/0x790 [nd_pmem]
> 
> ...I've exhausted my limited kasan internals knowledge, any ideas what
> it's missing?
> 

Initialization is missing. kasan_mem_notifier() doesn't initialize shadow because
it expects kasan_free_pages()/kasan_alloc_pages() will do that when page allocated/freed.

So adding memset(shadow_start, 0, shadow_size); will make this work.
But we shouldn't use kasan_mem_notifier here, as that would mean wasting a lot of memory only
to store zeroes.

A better solution would be mapping kasan_zero_page in shadow.
The draft patch bellow demonstrates the idea (build tested only).


---
 include/linux/kasan.h | 14 ++++++++++++++
 kernel/memremap.c     | 10 ++++++++++
 mm/kasan/kasan_init.c | 46 ++++++++++++++++++++++++++++++++++++----------
 3 files changed, 60 insertions(+), 10 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index de784fd11d12..b5f5d2d9e46f 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -71,6 +71,10 @@ struct kasan_cache {
 int kasan_module_alloc(void *addr, size_t size);
 void kasan_free_shadow(const struct vm_struct *vm);
 
+int kasan_add_zero_shadow(unsigned long start, unsigned long size);
+void kasan_remove_zero_shadow(unsigned long start, unsigned long size);
+
+
 size_t ksize(const void *);
 static inline void kasan_unpoison_slab(const void *ptr) { ksize(ptr); }
 size_t kasan_metadata_size(struct kmem_cache *cache);
@@ -124,6 +128,16 @@ static inline bool kasan_slab_free(struct kmem_cache *s, void *object,
 static inline int kasan_module_alloc(void *addr, size_t size) { return 0; }
 static inline void kasan_free_shadow(const struct vm_struct *vm) {}
 
+static inline int kasan_add_zero_shadow(unsigned long start, unsigned long size)
+{
+	return 0;
+}
+static inline int kasan_remove_zero_shadow(unsigned long start,
+					unsigned long size)
+{
+	return 0;
+}
+
 static inline void kasan_unpoison_slab(const void *ptr) { }
 static inline size_t kasan_metadata_size(struct kmem_cache *cache) { return 0; }
 
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 895e6b76b25e..1524dda52667 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/pfn_t.h>
 #include <linux/io.h>
+#include <linux/kasan.h>
 #include <linux/mm.h>
 #include <linux/memory_hotplug.h>
 #include <linux/swap.h>
@@ -309,6 +310,7 @@ static void devm_memremap_pages_release(void *data)
 	mem_hotplug_begin();
 	arch_remove_memory(align_start, align_size, pgmap->altmap_valid ?
 			&pgmap->altmap : NULL);
+	kasan_remove_zero_shadow((unsigned long)__va(align_start), align_size);
 	mem_hotplug_done();
 
 	untrack_pfn(NULL, PHYS_PFN(align_start), align_size);
@@ -395,6 +397,12 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 		goto err_pfn_remap;
 
 	mem_hotplug_begin();
+	error = kasan_add_zero_shadow((unsigned long)__va(align_start), align_size);
+	if (error) {
+		mem_hotplug_done();
+		goto err_kasan;
+	}
+
 	error = arch_add_memory(nid, align_start, align_size, altmap, false);
 	if (!error)
 		move_pfn_range_to_zone(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
@@ -423,6 +431,8 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 	return __va(res->start);
 
  err_add_memory:
+	kasan_remove_zero_shadow((unsigned long)__va(align_start), align_size);
+ err_kasan:
 	untrack_pfn(NULL, PHYS_PFN(align_start), align_size);
  err_pfn_remap:
  err_radix:
diff --git a/mm/kasan/kasan_init.c b/mm/kasan/kasan_init.c
index f436246ccc79..160d35d28e62 100644
--- a/mm/kasan/kasan_init.c
+++ b/mm/kasan/kasan_init.c
@@ -21,6 +21,8 @@
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 
+#include "kasan.h"
+
 /*
  * This page serves two purposes:
  *   - It used as early shadow memory. The entire shadow region populated
@@ -41,13 +43,16 @@ pmd_t kasan_zero_pmd[PTRS_PER_PMD] __page_aligned_bss;
 #endif
 pte_t kasan_zero_pte[PTRS_PER_PTE] __page_aligned_bss;
 
-static __init void *early_alloc(size_t size, int node)
+static void *kasan_alloc(size_t size, int node)
 {
+	if (slab_is_available())
+		return (void *)get_zeroed_page(GFP_KERNEL | __GFP_NOFAIL);
+
 	return memblock_virt_alloc_try_nid(size, size, __pa(MAX_DMA_ADDRESS),
 					BOOTMEM_ALLOC_ACCESSIBLE, node);
 }
 
-static void __init zero_pte_populate(pmd_t *pmd, unsigned long addr,
+static void __ref zero_pte_populate(pmd_t *pmd, unsigned long addr,
 				unsigned long end)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
@@ -63,7 +68,7 @@ static void __init zero_pte_populate(pmd_t *pmd, unsigned long addr,
 	}
 }
 
-static void __init zero_pmd_populate(pud_t *pud, unsigned long addr,
+static void __ref zero_pmd_populate(pud_t *pud, unsigned long addr,
 				unsigned long end)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
@@ -79,13 +84,13 @@ static void __init zero_pmd_populate(pud_t *pud, unsigned long addr,
 
 		if (pmd_none(*pmd)) {
 			pmd_populate_kernel(&init_mm, pmd,
-					early_alloc(PAGE_SIZE, NUMA_NO_NODE));
+					kasan_alloc(PAGE_SIZE, NUMA_NO_NODE));
 		}
 		zero_pte_populate(pmd, addr, next);
 	} while (pmd++, addr = next, addr != end);
 }
 
-static void __init zero_pud_populate(p4d_t *p4d, unsigned long addr,
+static void __ref zero_pud_populate(p4d_t *p4d, unsigned long addr,
 				unsigned long end)
 {
 	pud_t *pud = pud_offset(p4d, addr);
@@ -104,13 +109,13 @@ static void __init zero_pud_populate(p4d_t *p4d, unsigned long addr,
 
 		if (pud_none(*pud)) {
 			pud_populate(&init_mm, pud,
-				early_alloc(PAGE_SIZE, NUMA_NO_NODE));
+				kasan_alloc(PAGE_SIZE, NUMA_NO_NODE));
 		}
 		zero_pmd_populate(pud, addr, next);
 	} while (pud++, addr = next, addr != end);
 }
 
-static void __init zero_p4d_populate(pgd_t *pgd, unsigned long addr,
+static void __ref zero_p4d_populate(pgd_t *pgd, unsigned long addr,
 				unsigned long end)
 {
 	p4d_t *p4d = p4d_offset(pgd, addr);
@@ -133,7 +138,7 @@ static void __init zero_p4d_populate(pgd_t *pgd, unsigned long addr,
 
 		if (p4d_none(*p4d)) {
 			p4d_populate(&init_mm, p4d,
-				early_alloc(PAGE_SIZE, NUMA_NO_NODE));
+				kasan_alloc(PAGE_SIZE, NUMA_NO_NODE));
 		}
 		zero_pud_populate(p4d, addr, next);
 	} while (p4d++, addr = next, addr != end);
@@ -145,7 +150,7 @@ static void __init zero_p4d_populate(pgd_t *pgd, unsigned long addr,
  * @shadow_start - start of the memory range to populate
  * @shadow_end   - end of the memory range to populate
  */
-void __init kasan_populate_zero_shadow(const void *shadow_start,
+void __ref kasan_populate_zero_shadow(const void *shadow_start,
 				const void *shadow_end)
 {
 	unsigned long addr = (unsigned long)shadow_start;
@@ -192,8 +197,29 @@ void __init kasan_populate_zero_shadow(const void *shadow_start,
 
 		if (pgd_none(*pgd)) {
 			pgd_populate(&init_mm, pgd,
-				early_alloc(PAGE_SIZE, NUMA_NO_NODE));
+				kasan_alloc(PAGE_SIZE, NUMA_NO_NODE));
 		}
 		zero_p4d_populate(pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
+
+int kasan_add_zero_shadow(unsigned long start, unsigned long size)
+{
+	unsigned long shadow_start, shadow_end;
+
+	shadow_start = (unsigned long)kasan_mem_to_shadow((void *)start);
+	shadow_end = shadow_start + (size >> KASAN_SHADOW_SCALE_SHIFT);
+
+	if (WARN_ON(start % (KASAN_SHADOW_SCALE_SIZE * PAGE_SIZE)) ||
+	    WARN_ON(size % (KASAN_SHADOW_SCALE_SIZE * PAGE_SIZE)))
+		return -EINVAL;
+
+	kasan_populate_zero_shadow((void *)shadow_start,
+				(void *)shadow_end);
+	return 0;
+}
+
+void kasan_remove_zero_shadow(unsigned long start, unsigned long size)
+{
+	/* TODO */
+}
-- 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
