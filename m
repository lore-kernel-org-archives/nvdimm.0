Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8501C2110A007
 for <linux-nvdimm@lists.01.org>; Tue,  5 Jun 2018 12:10:18 -0700 (PDT)
Received: by mail-ot0-x241.google.com with SMTP id h6-v6so4185754otj.0
 for <linux-nvdimm@lists.01.org>; Tue, 05 Jun 2018 12:10:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <71c55f5c-deed-b307-9022-8a41dd898822@virtuozzo.com>
References: <CAPcyv4hJOzRBR0hg=xBZkd_oLtQRZeTXShYChdu8VA+GgTqUvg@mail.gmail.com>
 <71c55f5c-deed-b307-9022-8a41dd898822@virtuozzo.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 5 Jun 2018 12:10:16 -0700
Message-ID: <CAPcyv4gXBKU-gjsk1+veCRAVqaN-hdd3vfT+kiF=2HaoLLxDEA@mail.gmail.com>
Subject: Re: KASAN vs ZONE_DEVICE (was: Re: [PATCH v2 2/7] dax: change
 bdev_dax_supported()...)
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
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Alexander Potapenko <glider@google.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 5, 2018 at 7:01 AM, Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
>
>
> On 06/05/2018 07:22 AM, Dan Williams wrote:
>> On Mon, Jun 4, 2018 at 8:32 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> [ adding KASAN devs...]
>>>
>>> On Mon, Jun 4, 2018 at 4:40 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>>> On Sun, Jun 3, 2018 at 6:48 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>>>> On Sun, Jun 3, 2018 at 5:25 PM, Dave Chinner <david@fromorbit.com> wrote:
>>>>>> On Mon, Jun 04, 2018 at 08:20:38AM +1000, Dave Chinner wrote:
>>>>>>> On Thu, May 31, 2018 at 09:02:52PM -0700, Dan Williams wrote:
>>>>>>>> On Thu, May 31, 2018 at 7:24 PM, Dave Chinner <david@fromorbit.com> wrote:
>>>>>>>>> On Thu, May 31, 2018 at 06:57:33PM -0700, Dan Williams wrote:
>>>>>>>>>>> FWIW, XFS+DAX used to just work on this setup (I hadn't even
>>>>>>>>>>> installed ndctl until this morning!) but after changing the kernel
>>>>>>>>>>> it no longer works. That would make it a regression, yes?
>>>>>>>
>>>>>>> [....]
>>>>>>>
>>>>>>>>>> I suspect your kernel does not have CONFIG_ZONE_DEVICE enabled which
>>>>>>>>>> has the following dependencies:
>>>>>>>>>>
>>>>>>>>>>         depends on MEMORY_HOTPLUG
>>>>>>>>>>         depends on MEMORY_HOTREMOVE
>>>>>>>>>>         depends on SPARSEMEM_VMEMMAP
>>>>>>>>>
>>>>>>>>> Filesystem DAX now has a dependency on memory hotplug?
>>>>>>>
>>>>>>> [....]
>>>>>>>
>>>>>>>>> OK, works now I've found the magic config incantantions to turn
>>>>>>>>> everything I now need on.
>>>>>>>
>>>>>>> By enabling these options, my test VM now has a ~30s pause in the
>>>>>>> boot very soon after the nvdimm subsystem is initialised.
>>>>>>>
>>>>>>> [    1.523718] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>>>>>>> [    1.550353] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
>>>>>>> [    1.552175] Non-volatile memory driver v1.3
>>>>>>> [    2.332045] tsc: Refined TSC clocksource calibration: 2199.909 MHz
>>>>>>> [    2.333280] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1fb5dcd4620, max_idle_ns: 440795264143 ns
>>>>>>> [   37.217453] brd: module loaded
>>>>>>> [   37.225423] loop: module loaded
>>>>>>> [   37.228441] virtio_blk virtio2: [vda] 10485760 512-byte logical blocks (5.37 GB/5.00 GiB)
>>>>>>> [   37.245418] virtio_blk virtio3: [vdb] 146800640 512-byte logical blocks (75.2 GB/70.0 GiB)
>>>>>>> [   37.255794] virtio_blk virtio4: [vdc] 1073741824000 512-byte logical blocks (550 TB/500 TiB)
>>>>>>> [   37.265403] nd_pmem namespace1.0: unable to guarantee persistence of writes
>>>>>>> [   37.265618] nd_pmem namespace0.0: unable to guarantee persistence of writes
>>>>>>>
>>>>>>> The system does not appear to be consuming CPU, but it is blocking
>>>>>>> NMIs so I can't get a CPU trace. For a VM that I rely on booting in
>>>>>>> a few seconds because I reboot it tens of times a day, this is a
>>>>>>> problem....
>>>>>>
>>>>>> And when I turn on KASAN, the kernel fails to boot to a login prompt
>>>>>> because:
>>>>>
>>>>> What's your qemu and kernel command line? I'll take look at this first
>>>>> thing tomorrow.
>>>>
>>>> I was able to reproduce this crash by just turning on KASAN...
>>>> investigating. It would still help to have your config for our own
>>>> regression testing purposes it makes sense for us to prioritize
>>>> "Dave's test config", similar to the priority of not breaking Linus'
>>>> laptop.
>>>
>>> I believe this is a bug in KASAN, or a bug in devm_memremap_pages(),
>>> depends on your point of view. At the very least it is a mismatch of
>>> assumptions. KASAN learns of hot added memory via the memory hotplug
>>> notifier. However, the devm_memremap_pages() implementation is
>>> intentionally limited to the "first half" of the memory hotplug
>>> procedure. I.e. it does just enough to setup the linear map for
>>> pfn_to_page() and initialize the "struct page" memmap, but then stops
>>> short of onlining the pages. This is why we are getting a NULL ptr
>>> deref and not a KASAN report, because KASAN has no shadow area setup
>>> for the linearly mapped pmem range.
>>>
>>> In terms of solving it we could refactor kasan_mem_notifier() so that
>>> devm_memremap_pages() can call it outside of the notifier... I'll give
>>> this a shot.
>>
>> Well, the attached patch got me slightly further, but only slightly...
>>
>> [   14.998394] BUG: KASAN: unknown-crash in pmem_do_bvec+0x19e/0x790 [nd_pmem]
>> [   15.000006] Read of size 4096 at addr ffff880200000000 by task
>> systemd-udevd/915
>> [   15.001991]
>> [   15.002590] CPU: 15 PID: 915 Comm: systemd-udevd Tainted: G
>>   OE     4.17.0-rc5+ #1
>> 982
>> [   15.004783] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>> BIOS rel-1.11.1-0-g0551a
>> 4be2c-prebuilt.qemu-project.org 04/01/2014
>> [   15.007652] Call Trace:
>> [   15.008339]  dump_stack+0x9a/0xeb
>> [   15.009344]  print_address_description+0x73/0x280
>> [   15.010524]  kasan_report+0x258/0x380
>> [   15.011528]  ? pmem_do_bvec+0x19e/0x790 [nd_pmem]
>> [   15.012747]  memcpy+0x1f/0x50
>> [   15.013659]  pmem_do_bvec+0x19e/0x790 [nd_pmem]
>>
>> ...I've exhausted my limited kasan internals knowledge, any ideas what
>> it's missing?
>>
>
> Initialization is missing. kasan_mem_notifier() doesn't initialize shadow because
> it expects kasan_free_pages()/kasan_alloc_pages() will do that when page allocated/freed.
>
> So adding memset(shadow_start, 0, shadow_size); will make this work.
> But we shouldn't use kasan_mem_notifier here, as that would mean wasting a lot of memory only
> to store zeroes.
>
> A better solution would be mapping kasan_zero_page in shadow.
> The draft patch bellow demonstrates the idea (build tested only).
>
>
> ---
>  include/linux/kasan.h | 14 ++++++++++++++
>  kernel/memremap.c     | 10 ++++++++++
>  mm/kasan/kasan_init.c | 46 ++++++++++++++++++++++++++++++++++++----------
>  3 files changed, 60 insertions(+), 10 deletions(-)


Thank you! This RFC patch works for me. For now we don't necessarily
need kasan_remove_zero_shadow(), but in the future we might
dynamically switch the same physical address from being mapped by
devm_memremap_page() and traditional memory hotplug.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
