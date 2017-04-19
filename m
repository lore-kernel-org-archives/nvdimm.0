Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C2C6E21A0480F
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 07:34:31 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id x184so29765898oia.1
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 07:34:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJcbSZEbrOfnMQhr2dA0HBqogo0dYsEGCGsEbPMh1kM9tX4tEA@mail.gmail.com>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <20170419133630.GA2311@x1>
 <CAJcbSZEbrOfnMQhr2dA0HBqogo0dYsEGCGsEbPMh1kM9tX4tEA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Apr 2017 07:34:27 -0700
Message-ID: <CAPcyv4jGvy8b8KUb1Pg+h+5c6FVH2H7fbF3hM8wXp8Z=SUYtBw@mail.gmail.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
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
To: Thomas Garnier <thgarnie@google.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 19, 2017 at 7:27 AM, Thomas Garnier <thgarnie@google.com> wrote:
> On Wed, Apr 19, 2017 at 6:36 AM, Baoquan He <bhe@redhat.com> wrote:
>> Hi all,
>>
>> I login in Jeff's system, and added debug code, no clue found. However
>> DaveY found he disabled page_offset randomization only and the efi issue
>> won't be seen on his system with kaslr enabled. I did it too on Jeff's
>> pmem system, it has the same result. I have rebooted several times, all
>> boot successfully. In the current code, no __PAGE_OFFSET_BASE is used
>> directly, don't know why it failed.
>
> Great! I still cannot repro it.
>
>>
>> Does anyone have any idea or hint I can try? I read pmem code about
>> the devm_nsio_enable/pmem_attach_disk/arch_add_memory, have no idea yet.
>
> I would test couple things:
>  - Set page_offset_base to 0 by default and set it to
> __PAGE_OFFSET_BASE in kernel_randomize_memory (without randomizing
> it). If it crashes on a low address, it might be due to using __va or
> PAGE_OFFSET in general before randomization is done.
>  - Does any change in __PAGE_OFFSET lead to a crash? Or only when
> __PAGE_OFFSET is on a specific range. Given that you may have to
> reboot multiple times to get a crash, I assume that a specific range
> is the problem but might be worth checking.

Does the randomization ever cross a pgd boundary?

These crashes look very similar to the crashes caused by
arch_add_memory() racing itself. This issue was fixed in:

    f931ab479dd2 mm: fix devm_memremap_pages crash, use
mem_hotplug_{begin, done}

...but that only helps users that call mem_hotplug_begin() to prevent
concurrent updates.

On Wed, Apr 19, 2017 at 7:27 AM, Thomas Garnier <thgarnie@google.com> wrote:
> On Wed, Apr 19, 2017 at 6:36 AM, Baoquan He <bhe@redhat.com> wrote:
>> Hi all,
>>
>> I login in Jeff's system, and added debug code, no clue found. However
>> DaveY found he disabled page_offset randomization only and the efi issue
>> won't be seen on his system with kaslr enabled. I did it too on Jeff's
>> pmem system, it has the same result. I have rebooted several times, all
>> boot successfully. In the current code, no __PAGE_OFFSET_BASE is used
>> directly, don't know why it failed.
>
> Great! I still cannot repro it.
>
>>
>> Does anyone have any idea or hint I can try? I read pmem code about
>> the devm_nsio_enable/pmem_attach_disk/arch_add_memory, have no idea yet.
>
> I would test couple things:
>  - Set page_offset_base to 0 by default and set it to
> __PAGE_OFFSET_BASE in kernel_randomize_memory (without randomizing
> it). If it crashes on a low address, it might be due to using __va or
> PAGE_OFFSET in general before randomization is done.
>  - Does any change in __PAGE_OFFSET lead to a crash? Or only when
> __PAGE_OFFSET is on a specific range. Given that you may have to
> reboot multiple times to get a crash, I assume that a specific range
> is the problem but might be worth checking.
>
>>
>> Seems the failure on efi system has the same root cause as pmem issue.
>
> Thanks for looking into this.
>
>>
>> Thanks
>> Baoquan
>>
>> On 04/07/17 at 10:41am, Jeff Moyer wrote:
>>> Hi,
>>>
>>> commit 021182e52fe01 ("x86/mm: Enable KASLR for physical mapping memory
>>> regions") causes some of my systems with persistent memory (whether real
>>> or emulated) to fail to boot with a couple of different crash
>>> signatures.  The first signature is a NMI watchdog lockup of all but 1
>>> cpu, which causes much difficulty in extracting useful information from
>>> the console.  The second variant is an invalid paging request, listed
>>> below.
>>>
>>> On some systems, I haven't hit this problem at all.  Other systems
>>> experience a failed boot maybe 20-30% of the time.  To reproduce it,
>>> configure some emulated pmem on your system.  You can find directions
>>> for that here: https://nvdimm.wiki.kernel.org/
>>>
>>> Install ndctl (https://github.com/pmem/ndctl).
>>> Configure the namespace:
>>> # ndctl create-namespace -f -e namespace0.0 -m memory
>>>
>>> Then just reboot several times (5 should be enough), and hopefully
>>> you'll hit the issue.
>>>
>>> I've attached both my .config and the dmesg output from a successful
>>> boot at the end of this mail.
>>>
>>> Cheers,
>>> Jeff
>>>
>>> [    9.874109] pmem0: detected capacity change from 0 to 206158430208
>>> [    9.881652] BUG: unable to handle kernel paging request at ffff9406bfff0000
>>> [    9.889431] IP: memcpy_erms+0x6/0x10
>>> [    9.893422] PGD 0
>>> [    9.893423]
>>> [    9.897316] Oops: 0000 [#1] SMP
>>> [    9.900820] Modules linked in: isci mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt igb fb_sys_fops ahci libsas ttm ptp libahci crc32c_intel scsi_transport_sas nd_pmem pps_core nd_btt drm dca libata i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
>>> [    9.927322] CPU: 11 PID: 441 Comm: systemd-udevd Not tainted 4.11.0-rc5+ #1
>>> [    9.935092] Hardware name: Intel Corporation LH Pass/SVRBD-ROW_P, BIOS SE5C600.86B.02.01.SP06.050920141054 05/09/2014
>>> [    9.946934] task: ffff92dedae12b80 task.stack: ffffbaeb0783c000
>>> [    9.953539] RIP: 0010:memcpy_erms+0x6/0x10
>>> [    9.958108] RSP: 0018:ffffbaeb0783f9b8 EFLAGS: 00010286
>>> [    9.963939] RAX: ffff92e6dafef000 RBX: 0000000000000000 RCX: 0000000000001000
>>> [    9.971904] RDX: 0000000000001000 RSI: ffff9406bfff0000 RDI: ffff92e6dafef000
>>> [    9.979869] RBP: ffffbaeb0783fa38 R08: 0000000000000000 R09: 0000000017ffff80
>>> [    9.987831] R10: 0000000000000000 R11: ffff9406bfff0000 R12: ffff92d83bfaea98
>>> [    9.995794] R13: 0000002fffff0000 R14: 0000000000001000 R15: ffff92e6dafef000
>>> [   10.003759] FS:  00007fd4c2e618c0(0000) GS:ffff92e6de4c0000(0000) knlGS:0000000000000000
>>> [   10.012779] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [   10.019192] CR2: ffff9406bfff0000 CR3: 000000081a05c000 CR4: 00000000001406e0
>>> [   10.027158] Call Trace:
>>> [   10.029891]  ? pmem_do_bvec+0x93/0x290 [nd_pmem]
>>> [   10.035046]  ? radix_tree_node_alloc.constprop.20+0x85/0xc0
>>> [   10.041263]  ? radix_tree_node_alloc.constprop.20+0x85/0xc0
>>> [   10.047481]  pmem_rw_page+0x3a/0x60 [nd_pmem]
>>> [   10.052343]  bdev_read_page+0x81/0xb0
>>> [   10.056431]  do_mpage_readpage+0x56f/0x770
>>> [   10.060991]  ? I_BDEV+0x20/0x20
>>> [   10.064500]  ? lru_cache_add+0xe/0x10
>>> [   10.068584]  mpage_readpages+0x148/0x1e0
>>> [   10.072958]  ? I_BDEV+0x20/0x20
>>> [   10.076462]  ? I_BDEV+0x20/0x20
>>> [   10.079969]  ? alloc_pages_current+0x88/0x120
>>> [   10.084830]  blkdev_readpages+0x1d/0x20
>>> [   10.089111]  __do_page_cache_readahead+0x1ce/0x2c0
>>> [   10.094456]  force_page_cache_readahead+0xa2/0x100
>>> [   10.099800]  page_cache_sync_readahead+0x3f/0x50
>>> [   10.104956]  generic_file_read_iter+0x60d/0x8c0
>>> [   10.110014]  ? cp_new_stat+0x14f/0x180
>>> [   10.114187]  blkdev_read_iter+0x37/0x40
>>> [   10.118469]  __vfs_read+0xe0/0x150
>>> [   10.122253]  vfs_read+0x8c/0x130
>>> [   10.125856]  SyS_read+0x55/0xc0
>>> [   10.129354]  entry_SYSCALL_64_fastpath+0x1a/0xa9
>>> [   10.134508] RIP: 0033:0x7fd4c1d9d480
>>> [   10.138487] RSP: 002b:00007fffa1f96e08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>>> [   10.146934] RAX: ffffffffffffffda RBX: 00007fffa1f968f0 RCX: 00007fd4c1d9d480
>>> [   10.154896] RDX: 0000000000000040 RSI: 0000559de3d6d978 RDI: 0000000000000008
>>> [   10.162859] RBP: 0000000000010300 R08: 0000000000000020 R09: 0000000000000068
>>> [   10.170820] R10: 00007fffa1f96b90 R11: 0000000000000246 R12: 0000000000000000
>>> [   10.178783] R13: 00007fffa1f97980 R14: 0000000000000000 R15: 0000000000000000
>>> [   10.186748] Code: ff 90 90 90 90 eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a4 c3 0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38
>>> [   10.207813] RIP: memcpy_erms+0x6/0x10 RSP: ffffbaeb0783f9b8
>>> [   10.214022] CR2: ffff9406bfff0000
>>> [   10.217774] ---[ end trace 2ea6d4ce29040562 ]---
>>> [   10.265522] Kernel panic - not syncing: Fatal exception
>>> [   10.271381] Kernel Offset: 0x2a000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>>> [   10.309968] ---[ end Kernel panic - not syncing: Fatal exception
>>> [   10.316682] ------------[ cut here ]------------
>>>
>>>
>>
>>> [    0.000000] Linux version 4.11.0-rc5+ (root@intel-lizardhead-04.ml3.eng.bos.redhat.com) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-11) (GCC) ) #1 SMP Thu Apr 6 18:24:44 EDT 2017
>>> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.11.0-rc5+ root=/dev/mapper/rhel_intel--lizardhead--04-root ro memmap=192G!1024G crashkernel=auto rd.lvm.lv=rhel_intel-lizardhead-04/root rd.lvm.lv=rhel_intel-lizardhead-04/swap console=ttyS0,115200n81 LANG=en_US.UTF-8
>>> [    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
>>> [    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
>>> [    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
>>> [    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
>>> [    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
>>> [    0.000000] e820: BIOS-provided physical RAM map:
>>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008ffff] usable
>>> [    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bad4afff] usable
>>> [    0.000000] BIOS-e820: [mem 0x00000000bad4b000-0x00000000baf8efff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000baf8f000-0x00000000bafc3fff] usable
>>> [    0.000000] BIOS-e820: [mem 0x00000000bafc4000-0x00000000bafd8fff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000bafd9000-0x00000000bb3d3fff] usable
>>> [    0.000000] BIOS-e820: [mem 0x00000000bb3d4000-0x00000000bdd2efff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000bdd2f000-0x00000000bddcbfff] ACPI NVS
>>> [    0.000000] BIOS-e820: [mem 0x00000000bddcc000-0x00000000bde9ffff] ACPI data
>>> [    0.000000] BIOS-e820: [mem 0x00000000bdea0000-0x00000000bdf2efff] ACPI NVS
>>> [    0.000000] BIOS-e820: [mem 0x00000000bdf2f000-0x00000000bdfaafff] ACPI data
>>> [    0.000000] BIOS-e820: [mem 0x00000000bdfab000-0x00000000bdffffff] usable
>>> [    0.000000] BIOS-e820: [mem 0x00000000be000000-0x00000000cfffffff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000fed19000-0x00000000fed19fff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000ffa20000-0x00000000ffffffff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000103fffffff] usable
>>> [    0.000000] BIOS-e820: [mem 0x0000010000000000-0x0000012fffffffff] usable
>>> [    0.000000] NX (Execute Disable) protection: active
>>> [    0.000000] e820: user-defined physical RAM map:
>>> [    0.000000] user: [mem 0x0000000000000000-0x000000000008ffff] usable
>>> [    0.000000] user: [mem 0x0000000000090000-0x000000000009ffff] reserved
>>> [    0.000000] user: [mem 0x00000000000e0000-0x00000000000fffff] reserved
>>> [    0.000000] user: [mem 0x0000000000100000-0x00000000bad4afff] usable
>>> [    0.000000] user: [mem 0x00000000bad4b000-0x00000000baf8efff] reserved
>>> [    0.000000] user: [mem 0x00000000baf8f000-0x00000000bafc3fff] usable
>>> [    0.000000] user: [mem 0x00000000bafc4000-0x00000000bafd8fff] reserved
>>> [    0.000000] user: [mem 0x00000000bafd9000-0x00000000bb3d3fff] usable
>>> [    0.000000] user: [mem 0x00000000bb3d4000-0x00000000bdd2efff] reserved
>>> [    0.000000] user: [mem 0x00000000bdd2f000-0x00000000bddcbfff] ACPI NVS
>>> [    0.000000] user: [mem 0x00000000bddcc000-0x00000000bde9ffff] ACPI data
>>> [    0.000000] user: [mem 0x00000000bdea0000-0x00000000bdf2efff] ACPI NVS
>>> [    0.000000] user: [mem 0x00000000bdf2f000-0x00000000bdfaafff] ACPI data
>>> [    0.000000] user: [mem 0x00000000bdfab000-0x00000000bdffffff] usable
>>> [    0.000000] user: [mem 0x00000000be000000-0x00000000cfffffff] reserved
>>> [    0.000000] user: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
>>> [    0.000000] user: [mem 0x00000000fed19000-0x00000000fed19fff] reserved
>>> [    0.000000] user: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
>>> [    0.000000] user: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
>>> [    0.000000] user: [mem 0x00000000ffa20000-0x00000000ffffffff] reserved
>>> [    0.000000] user: [mem 0x0000000100000000-0x000000103fffffff] usable
>>> [    0.000000] user: [mem 0x0000010000000000-0x0000012fffffffff] persistent (type 12)
>>> [    0.000000] SMBIOS 2.6 present.
>>> [    0.000000] DMI: Intel Corporation LH Pass/SVRBD-ROW_P, BIOS SE5C600.86B.02.01.SP06.050920141054 05/09/2014
>>> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
>>> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
>>> [    0.000000] e820: last_pfn = 0x1040000 max_arch_pfn = 0x400000000
>>> [    0.000000] MTRR default type: uncachable
>>> [    0.000000] MTRR fixed ranges enabled:
>>> [    0.000000]   00000-9FFFF write-back
>>> [    0.000000]   A0000-BFFFF uncachable
>>> [    0.000000]   C0000-D3FFF write-through
>>> [    0.000000]   D4000-E7FFF uncachable
>>> [    0.000000]   E8000-FFFFF write-protect
>>> [    0.000000] MTRR variable ranges enabled:
>>> [    0.000000]   0 base 000000000000 mask 3F0000000000 write-back
>>> [    0.000000]   1 base 0000C0000000 mask 3FFFC0000000 uncachable
>>> [    0.000000]   2 base 010000000000 mask 3FE000000000 write-back
>>> [    0.000000]   3 base 012000000000 mask 3FF000000000 write-back
>>> [    0.000000]   4 disabled
>>> [    0.000000]   5 disabled
>>> [    0.000000]   6 disabled
>>> [    0.000000]   7 disabled
>>> [    0.000000]   8 disabled
>>> [    0.000000]   9 disabled
>>> [    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT
>>> [    0.000000] total RAM covered: 1244160M
>>> [    0.000000]  gran_size: 64K        chunk_size: 64K         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 128K        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 256K        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 512K        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 1M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 2M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 4M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 8M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 16M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 32M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 64M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 128M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 256M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 512M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64K        chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 128K        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 256K        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 512K        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 1M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 2M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 4M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 8M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 16M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 32M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 64M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 128M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 256M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 512M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128K       chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256K       chunk_size: 256K        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256K       chunk_size: 512K        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256K       chunk_size: 1M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256K       chunk_size: 2M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256K       chunk_size: 4M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256K       chunk_size: 8M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256K       chunk_size: 16M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256K       chunk_size: 32M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256K       chunk_size: 64M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256K       chunk_size: 128M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256K       chunk_size: 256M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256K       chunk_size: 512M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256K       chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256K       chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512K       chunk_size: 512K        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512K       chunk_size: 1M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512K       chunk_size: 2M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512K       chunk_size: 4M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512K       chunk_size: 8M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512K       chunk_size: 16M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512K       chunk_size: 32M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512K       chunk_size: 64M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512K       chunk_size: 128M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512K       chunk_size: 256M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512K       chunk_size: 512M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512K       chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512K       chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 1M         chunk_size: 1M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 1M         chunk_size: 2M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 1M         chunk_size: 4M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 1M         chunk_size: 8M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 1M         chunk_size: 16M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 1M         chunk_size: 32M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 1M         chunk_size: 64M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 1M         chunk_size: 128M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 1M         chunk_size: 256M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 1M         chunk_size: 512M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 1M         chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 1M         chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 2M         chunk_size: 2M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 2M         chunk_size: 4M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 2M         chunk_size: 8M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 2M         chunk_size: 16M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 2M         chunk_size: 32M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 2M         chunk_size: 64M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 2M         chunk_size: 128M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 2M         chunk_size: 256M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 2M         chunk_size: 512M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 2M         chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 2M         chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 4M         chunk_size: 4M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 4M         chunk_size: 8M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 4M         chunk_size: 16M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 4M         chunk_size: 32M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 4M         chunk_size: 64M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 4M         chunk_size: 128M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 4M         chunk_size: 256M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 4M         chunk_size: 512M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 4M         chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 4M         chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 8M         chunk_size: 8M  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 8M         chunk_size: 16M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 8M         chunk_size: 32M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 8M         chunk_size: 64M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 8M         chunk_size: 128M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 8M         chunk_size: 256M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 8M         chunk_size: 512M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 8M         chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 8M         chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 16M        chunk_size: 16M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 16M        chunk_size: 32M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 16M        chunk_size: 64M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 16M        chunk_size: 128M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 16M        chunk_size: 256M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 16M        chunk_size: 512M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 16M        chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 16M        chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 32M        chunk_size: 32M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 32M        chunk_size: 64M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 32M        chunk_size: 128M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 32M        chunk_size: 256M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 32M        chunk_size: 512M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 32M        chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 32M        chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64M        chunk_size: 64M         num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64M        chunk_size: 128M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64M        chunk_size: 256M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64M        chunk_size: 512M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64M        chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 64M        chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128M       chunk_size: 128M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128M       chunk_size: 256M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128M       chunk_size: 512M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128M       chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 128M       chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256M       chunk_size: 256M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256M       chunk_size: 512M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256M       chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 256M       chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512M       chunk_size: 512M        num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512M       chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 512M       chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 1G         chunk_size: 1G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 1G         chunk_size: 2G  num_reg: 10     lose cover RAM: 192G
>>> [    0.000000]  gran_size: 2G         chunk_size: 2G  num_reg: 10     lose cover RAM: 65G
>>> [    0.000000] mtrr_cleanup: can not find optimal value
>>> [    0.000000] please specify mtrr_gran_size/mtrr_chunk_size
>>> [    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
>>> [    0.000000] e820: last_pfn = 0xbe000 max_arch_pfn = 0x400000000
>>> [    0.000000] found SMP MP-table at [mem 0x000fcd00-0x000fcd0f] mapped at [ffff9743400fcd00]
>>> [    0.000000] Base memory trampoline at [ffff97434008a000] 8a000 size 24576
>>> [    0.000000] Using GB pages for direct mapping
>>> [    0.000000] BRK [0x77a27f000, 0x77a27ffff] PGTABLE
>>> [    0.000000] BRK [0x77a280000, 0x77a280fff] PGTABLE
>>> [    0.000000] BRK [0x77a281000, 0x77a281fff] PGTABLE
>>> [    0.000000] BRK [0x77a282000, 0x77a282fff] PGTABLE
>>> [    0.000000] BRK [0x77a283000, 0x77a283fff] PGTABLE
>>> [    0.000000] BRK [0x77a284000, 0x77a284fff] PGTABLE
>>> [    0.000000] BRK [0x77a285000, 0x77a285fff] PGTABLE
>>> [    0.000000] BRK [0x77a286000, 0x77a286fff] PGTABLE
>>> [    0.000000] BRK [0x77a287000, 0x77a287fff] PGTABLE
>>> [    0.000000] RAMDISK: [mem 0x3594b000-0x36c9dfff]
>>> [    0.000000] ACPI: Early table checksum verification disabled
>>> [    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
>>> [    0.000000] ACPI: XSDT 0x00000000BDFA8D98 0000C4 (v01 INTEL  S4600LH  06222004 INTL 20090903)
>>> [    0.000000] ACPI: FACP 0x00000000BDFA8918 0000F4 (v04 INTEL  S4600LH  06222004 INTL 20090903)
>>> [    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20170119/tbfadt-708)
>>> [    0.000000] ACPI: DSDT 0x00000000BDF92018 0148F1 (v02 INTEL  S4600LH  00000001 INTL 20100331)
>>> [    0.000000] ACPI: FACS 0x00000000BDFA8F40 000040
>>> [    0.000000] ACPI: APIC 0x00000000BDFA7018 000BAA (v03 INTEL  S4600LH  06222004 INTL 20090903)
>>> [    0.000000] ACPI: SPMI 0x00000000BDFAAA98 000041 (v05 INTEL  S4600LH  06222004 INTL 20090903)
>>> [    0.000000] ACPI: FPDT 0x00000000BDFAAA18 000044 (v01 INTEL  S4600LH  00000000      00000000)
>>> [    0.000000] ACPI: MCFG 0x00000000BDFAAF18 00003C (v01 INTEL  S4600LH  06222004 INTL 20090903)
>>> [    0.000000] ACPI: WDDT 0x00000000BDFAAE98 000040 (v01 INTEL  S4600LH  06222004 INTL 20090903)
>>> [    0.000000] ACPI: SRAT 0x00000000BDF8FC18 0001D0 (v03 INTEL  S4600LH  06222004 INTL 20090903)
>>> [    0.000000] ACPI: SLIT 0x00000000BDFAAE18 000030 (v01 INTEL  S4600LH  06222004 INTL 20090903)
>>> [    0.000000] ACPI: MSCT 0x00000000BDFA9D18 000090 (v01 INTEL  S4600LH  06222004 INTL 20090903)
>>> [    0.000000] ACPI: HPET 0x00000000BDFAAD98 000038 (v01 INTEL  S4600LH  06222004 INTL 20090903)
>>> [    0.000000] ACPI: SSDT 0x00000000BDDCC018 0D30C8 (v02 INTEL  S4600LH  00004000 INTL 20100331)
>>> [    0.000000] ACPI: BGRT 0x00000000BDFAAD18 000038 (v00 INTEL  S4600LH  06222004 AMI  00010013)
>>> [    0.000000] ACPI: HEST 0x00000000BDF91F18 0000A8 (v01 INTEL  S4600LH  00000001 INTL 00000001)
>>> [    0.000000] ACPI: BERT 0x00000000BDFAAB98 000030 (v01 INTEL  S4600LH  00000001 INTL 00000001)
>>> [    0.000000] ACPI: ERST 0x00000000BDF91C98 000230 (v01 INTEL  S4600LH  00000001 INTL 00000001)
>>> [    0.000000] ACPI: EINJ 0x00000000BDFA8798 000130 (v01 INTEL  S4600LH  00000001 INTL 00000001)
>>> [    0.000000] ACPI: SSDT 0x00000000BDF8D018 001729 (v02 INTEL  S4600LH  00000002 INTL 20100331)
>>> [    0.000000] ACPI: SSDT 0x00000000BDFAAC18 000045 (v02 INTEL  S4600LH  00000001 INTL 20100331)
>>> [    0.000000] ACPI: SSDT 0x00000000BDF8FA18 000181 (v02 INTEL  S4600LH  00000003 INTL 20100331)
>>> [    0.000000] ACPI: BGRT 0x00000000BDFAAC98 000038 (v00 INTEL  ROMLEY   06222004 AMI  00010013)
>>> [    0.000000] ACPI: Local APIC address 0xfee00000
>>> [    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
>>> [    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
>>> [    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
>>> [    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
>>> [    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
>>> [    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
>>> [    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
>>> [    0.000000] SRAT: PXM 0 -> APIC 0x0e -> Node 0
>>> [    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
>>> [    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
>>> [    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
>>> [    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
>>> [    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
>>> [    0.000000] SRAT: PXM 1 -> APIC 0x2a -> Node 1
>>> [    0.000000] SRAT: PXM 1 -> APIC 0x2c -> Node 1
>>> [    0.000000] SRAT: PXM 1 -> APIC 0x2e -> Node 1
>>> [    0.000000] ACPI: SRAT: Node 0 PXM 0 [mem 0x00000000-0xbfffffff]
>>> [    0.000000] ACPI: SRAT: Node 0 PXM 0 [mem 0x100000000-0x83fffffff]
>>> [    0.000000] ACPI: SRAT: Node 1 PXM 1 [mem 0x840000000-0x103fffffff]
>>> [    0.000000] ACPI: SRAT: Node 2 PXM 5 [mem 0x10000000000-0x12fffffffff]
>>> [    0.000000] ACPI: SLIT table looks invalid. Not used.
>>> [    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x83fffffff] -> [mem 0x00000000-0x83fffffff]
>>> [    0.000000] NODE_DATA(0) allocated [mem 0x83ffd5000-0x83fffffff]
>>> [    0.000000] NODE_DATA(1) allocated [mem 0x103ffd5000-0x103fffffff]
>>> [    0.000000] kexec_core: crashkernel: memory value expected
>>> [    0.000000] Zone ranges:
>>> [    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
>>> [    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
>>> [    0.000000]   Normal   [mem 0x0000000100000000-0x000000103fffffff]
>>> [    0.000000]   Device   empty
>>> [    0.000000] Movable zone start for each node
>>> [    0.000000] Early memory node ranges
>>> [    0.000000]   node   0: [mem 0x0000000000001000-0x000000000008ffff]
>>> [    0.000000]   node   0: [mem 0x0000000000100000-0x00000000bad4afff]
>>> [    0.000000]   node   0: [mem 0x00000000baf8f000-0x00000000bafc3fff]
>>> [    0.000000]   node   0: [mem 0x00000000bafd9000-0x00000000bb3d3fff]
>>> [    0.000000]   node   0: [mem 0x00000000bdfab000-0x00000000bdffffff]
>>> [    0.000000]   node   0: [mem 0x0000000100000000-0x000000083fffffff]
>>> [    0.000000]   node   1: [mem 0x0000000840000000-0x000000103fffffff]
>>> [    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000083fffffff]
>>> [    0.000000] On node 0 totalpages: 8368479
>>> [    0.000000]   DMA zone: 64 pages used for memmap
>>> [    0.000000]   DMA zone: 21 pages reserved
>>> [    0.000000]   DMA zone: 3983 pages, LIFO batch:0
>>> [    0.000000]   DMA32 zone: 11912 pages used for memmap
>>> [    0.000000]   DMA32 zone: 762320 pages, LIFO batch:31
>>> [    0.000000]   Normal zone: 118784 pages used for memmap
>>> [    0.000000]   Normal zone: 7602176 pages, LIFO batch:31
>>> [    0.000000] Initmem setup node 1 [mem 0x0000000840000000-0x000000103fffffff]
>>> [    0.000000] On node 1 totalpages: 8388608
>>> [    0.000000]   Normal zone: 131072 pages used for memmap
>>> [    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
>>> [    0.000000] ACPI: PM-Timer IO Port: 0x408
>>> [    0.000000] ACPI: Local APIC address 0xfee00000
>>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
>>> [    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
>>> [    0.000000] IOAPIC[1]: apic_id 1, version 32, address 0xfec3f000, GSI 24-47
>>> [    0.000000] IOAPIC[2]: apic_id 2, version 32, address 0xfec7f000, GSI 48-71
>>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>>> [    0.000000] ACPI: IRQ0 used by override.
>>> [    0.000000] ACPI: IRQ9 used by override.
>>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>>> [    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
>>> [    0.000000] efi: EFI_MEMMAP is not enabled.
>>> [    0.000000] efi: Failed to lookup EFI memory descriptor for 0x00000000b6da1018
>>> [    0.000000] smpboot: Allowing 136 CPUs, 120 hotplug CPUs
>>> [    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0x00090000-0x0009ffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xbad4b000-0xbaf8efff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xbafc4000-0xbafd8fff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xbb3d4000-0xbdd2efff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xbdd2f000-0xbddcbfff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xbddcc000-0xbde9ffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xbdea0000-0xbdf2efff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xbdf2f000-0xbdfaafff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xbe000000-0xcfffffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfebfffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed18fff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfed19000-0xfed19fff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffa1ffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xffa20000-0xffffffff]
>>> [    0.000000] e820: [mem 0xd0000000-0xfebfffff] available for PCI devices
>>> [    0.000000] Booting paravirtualized kernel on bare hardware
>>> [    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
>>> [    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:136 nr_cpu_ids:136 nr_node_ids:3
>>> [    0.000000] percpu: Embedded 38 pages/cpu @ffff974b5ec00000 s116120 r8192 d31336 u262144
>>> [    0.000000] pcpu-alloc: s116120 r8192 d31336 u262144 alloc=1*2097152
>>> [    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007
>>> [    0.000000] pcpu-alloc: [0] 016 018 020 022 024 026 028 030
>>> [    0.000000] pcpu-alloc: [0] 032 034 036 038 040 042 044 046
>>> [    0.000000] pcpu-alloc: [0] 048 050 052 054 056 058 060 062
>>> [    0.000000] pcpu-alloc: [0] 064 066 068 070 072 074 076 078
>>> [    0.000000] pcpu-alloc: [0] 080 082 084 086 088 090 092 094
>>> [    0.000000] pcpu-alloc: [0] 096 098 100 102 104 106 108 110
>>> [    0.000000] pcpu-alloc: [0] 112 114 116 118 120 122 124 126
>>> [    0.000000] pcpu-alloc: [0] 128 130 132 134 --- --- --- ---
>>> [    0.000000] pcpu-alloc: [1] 008 009 010 011 012 013 014 015
>>> [    0.000000] pcpu-alloc: [1] 017 019 021 023 025 027 029 031
>>> [    0.000000] pcpu-alloc: [1] 033 035 037 039 041 043 045 047
>>> [    0.000000] pcpu-alloc: [1] 049 051 053 055 057 059 061 063
>>> [    0.000000] pcpu-alloc: [1] 065 067 069 071 073 075 077 079
>>> [    0.000000] pcpu-alloc: [1] 081 083 085 087 089 091 093 095
>>> [    0.000000] pcpu-alloc: [1] 097 099 101 103 105 107 109 111
>>> [    0.000000] pcpu-alloc: [1] 113 115 117 119 121 123 125 127
>>> [    0.000000] pcpu-alloc: [1] 129 131 133 135 --- --- --- ---
>>> [    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 16495234
>>> [    0.000000] Policy zone: Normal
>>> [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.11.0-rc5+ root=/dev/mapper/rhel_intel--lizardhead--04-root ro memmap=192G!1024G crashkernel=auto rd.lvm.lv=rhel_intel-lizardhead-04/root rd.lvm.lv=rhel_intel-lizardhead-04/swap console=ttyS0,115200n81 LANG=en_US.UTF-8
>>> [    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
>>> [    0.000000] log_buf_len total cpu_extra contributions: 552960 bytes
>>> [    0.000000] log_buf_len min size: 1048576 bytes
>>> [    0.000000] log_buf_len: 2097152 bytes
>>> [    0.000000] early log buf free: 1019588(97%)
>>> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
>>> [    0.000000] Memory: 7173172K/67028348K available (7447K kernel code, 1577K rwdata, 3192K rodata, 2124K init, 2908K bss, 1177444K reserved, 0K cma-reserved)
>>> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=136, Nodes=3
>>> [    0.000000] Hierarchical RCU implementation.
>>> [    0.000000]        Build-time adjustment of leaf fanout to 64.
>>> [    0.000000]        RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=136.
>>> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=136
>>> [    0.000000] NR_IRQS:524544 nr_irqs:2328 16
>>> [    0.000000]        Offload RCU callbacks from all CPUs
>>> [    0.000000]        Offload RCU callbacks from CPUs: 0-135.
>>> [    0.000000] Console: colour VGA+ 80x25
>>> [    0.000000] console [ttyS0] enabled
>>> [    0.000000] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
>>> [    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
>>> [    0.000000] hpet clockevent registered
>>> [    0.000000] tsc: Fast TSC calibration using PIT
>>> [    0.001000] tsc: Detected 2593.662 MHz processor
>>> [    0.002000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5187.32 BogoMIPS (lpj=2593662)
>>> [    0.003002] pid_max: default: 139264 minimum: 1088
>>> [    0.004052] ACPI: Core revision 20170119
>>> [    0.059868] ACPI: 5 ACPI AML tables successfully acquired and loaded
>>> [    0.061150] Security Framework initialized
>>> [    0.062003] SELinux:  Initializing.
>>> [    0.063011] SELinux:  Starting in permissive mode
>>> [    0.066456] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
>>> [    0.083875] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
>>> [    0.091529] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes)
>>> [    0.092057] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes)
>>> [    0.094772] CPU: Physical Processor ID: 0
>>> [    0.095003] CPU: Processor Core ID: 0
>>> [    0.096010] mce: CPU supports 25 MCE banks
>>> [    0.097020] CPU0: Thermal monitoring enabled (TM1)
>>> [    0.098048] process: using mwait in idle threads
>>> [    0.099005] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
>>> [    0.100002] Last level dTLB entries: 4KB 512, 2MB 0, 4MB 0, 1GB 4
>>> [    0.102433] Freeing SMP alternatives memory: 28K
>>> [    0.105004] ftrace: allocating 28759 entries in 113 pages
>>> [    0.113170] smpboot: Max logical packages: 17
>>> [    0.114151] x2apic: IRQ remapping doesn't support X2APIC mode
>>> [    0.115003] Switched APIC routing to physical flat.
>>> [    0.117188] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>>> [    0.127900] TSC deadline timer enabled
>>> [    0.127925] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-4620 v2 @ 2.60GHz (family: 0x6, model: 0x3e, stepping: 0x4)
>>> [    0.128245] Performance Events: PEBS fmt1+, IvyBridge events, 16-deep LBR, full-width counters, Intel PMU driver.
>>> [    0.129004] ... version:                3
>>> [    0.130001] ... bit width:              48
>>> [    0.131000] ... generic registers:      4
>>> [    0.132001] ... value mask:             0000ffffffffffff
>>> [    0.133001] ... max period:             00007fffffffffff
>>> [    0.134000] ... fixed-purpose events:   3
>>> [    0.135001] ... event mask:             000000070000000f
>>> [    0.142025] smp: Bringing up secondary CPUs ...
>>> [    0.146149] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
>>> [    0.147149] x86: Booting SMP configuration:
>>> [    0.148002] .... node  #0, CPUs:          #1   #2   #3   #4   #5   #6   #7
>>> [    0.585002] .... node  #1, CPUs:     #8   #9  #10  #11  #12  #13  #14  #15
>>> [    1.081117] smp: Brought up 2 nodes, 16 CPUs
>>> [    1.083004] smpboot: Total of 16 processors activated (83093.10 BogoMIPS)
>>> [    1.086101] sched_clock: Marking stable (1086000000, 0)->(1385525935, -299525935)
>>> [    1.234930] node 0 initialised, 6939436 pages in 140ms
>>> [    1.250605] node 1 initialised, 7729995 pages in 155ms
>>> [    1.258571] devtmpfs: initialized
>>> [    1.262324] x86/mm: Memory block size: 2048MB
>>> [    1.269052] evm: security.selinux
>>> [    1.272752] evm: security.ima
>>> [    1.276054] evm: security.capability
>>> [    1.280185] PM: Registering ACPI NVS region [mem 0xbdd2f000-0xbddcbfff] (643072 bytes)
>>> [    1.289036] PM: Registering ACPI NVS region [mem 0xbdea0000-0xbdf2efff] (585728 bytes)
>>> [    1.298045] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
>>> [    1.309111] futex hash table entries: 65536 (order: 10, 4194304 bytes)
>>> [    1.317586] pinctrl core: initialized pinctrl subsystem
>>> [    1.324318] NET: Registered protocol family 16
>>> [    1.329562] cpuidle: using governor menu
>>> [    1.333940] PCCT header not found.
>>> [    1.337839] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
>>> [    1.346290] ACPI: bus type PCI registered
>>> [    1.350757] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>>> [    1.358112] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
>>> [    1.368503] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
>>> [    1.376089] pmd_set_huge: Cannot satisfy [mem 0xc0000000-0xc0200000] with a huge-page mapping due to MTRR override.
>>> [    1.388177] PCI: Using configuration type 1 for base access
>>> [    1.399327] core: PMU erratum BJ122, BV98, HSD29 workaround disabled, HT off
>>> [    1.407226] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
>>> [    1.416674] HugeTLB registered 1 GB page size, pre-allocated 0 pages
>>> [    1.423772] HugeTLB registered 2 MB page size, pre-allocated 0 pages
>>> [    1.432053] ACPI: Added _OSI(Module Device)
>>> [    1.436721] ACPI: Added _OSI(Processor Device)
>>> [    1.441680] ACPI: Added _OSI(3.0 _SCP Extensions)
>>> [    1.446929] ACPI: Added _OSI(Processor Aggregator Device)
>>> [    1.453108] ACPI: Executed 1 blocks of module-level executable AML code
>>> [    1.571927] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
>>> [    1.588206] ACPI: Interpreter enabled
>>> [    1.592309] ACPI: (supports S0 S1 S5)
>>> [    1.596394] ACPI: Using IOAPIC for interrupt routing
>>> [    1.601984] HEST: Table parsing has been initialized.
>>> [    1.607623] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
>>> [    1.641056] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
>>> [    1.647958] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
>>> [    1.657203] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME AER]
>>> [    1.665757] acpi PNP0A08:00: _OSC: OS now controls [PCIeCapability]
>>> [    1.672753] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
>>> [    1.682003] acpi PNP0A08:00: host bridge window expanded to [io  0x0000-0xbfff]; [io  0x0000-0xbfff window] ignored
>>> [    1.693656] acpi PNP0A08:00: ignoring host bridge window [mem 0x000d0000-0x000d3fff window] (conflicts with Adapter ROM [mem 0x000c8000-0x000d19ff])
>>> [    1.708688] PCI host bridge to bus 0000:00
>>> [    1.713261] pci_bus 0000:00: root bus resource [io  0x0000-0xbfff]
>>> [    1.720157] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
>>> [    1.728509] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff window]
>>> [    1.736862] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff window]
>>> [    1.745213] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff window]
>>> [    1.753568] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff window]
>>> [    1.761918] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
>>> [    1.770273] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
>>> [    1.778623] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
>>> [    1.786973] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff window]
>>> [    1.795324] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff window]
>>> [    1.803675] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff window]
>>> [    1.812026] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff window]
>>> [    1.820376] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff window]
>>> [    1.828726] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xebffffff window]
>>> [    1.837086] pci_bus 0000:00: root bus resource [mem 0x380000000000-0x38007fffffff window]
>>> [    1.846222] pci_bus 0000:00: root bus resource [bus 00-7e]
>>> [    1.852355] pci 0000:00:00.0: [8086:0e00] type 00 class 0x060000
>>> [    1.852431] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
>>> [    1.852513] pci 0000:00:01.0: [8086:0e02] type 01 class 0x060400
>>> [    1.852581] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
>>> [    1.852641] pci 0000:00:01.0: System wakeup disabled by ACPI
>>> [    1.858979] pci 0000:00:02.0: [8086:0e04] type 01 class 0x060400
>>> [    1.859049] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
>>> [    1.859105] pci 0000:00:02.0: System wakeup disabled by ACPI
>>> [    1.865449] pci 0000:00:03.0: [8086:0e08] type 01 class 0x060400
>>> [    1.865520] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
>>> [    1.865576] pci 0000:00:03.0: System wakeup disabled by ACPI
>>> [    1.871922] pci 0000:00:03.2: [8086:0e0a] type 01 class 0x060400
>>> [    1.871991] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
>>> [    1.872049] pci 0000:00:03.2: System wakeup disabled by ACPI
>>> [    1.878400] pci 0000:00:04.0: [8086:0e20] type 00 class 0x088000
>>> [    1.878415] pci 0000:00:04.0: reg 0x10: [mem 0x38007ff90000-0x38007ff93fff 64bit]
>>> [    1.878535] pci 0000:00:04.1: [8086:0e21] type 00 class 0x088000
>>> [    1.878549] pci 0000:00:04.1: reg 0x10: [mem 0x38007ff80000-0x38007ff83fff 64bit]
>>> [    1.878666] pci 0000:00:04.2: [8086:0e22] type 00 class 0x088000
>>> [    1.878680] pci 0000:00:04.2: reg 0x10: [mem 0x38007ff70000-0x38007ff73fff 64bit]
>>> [    1.878800] pci 0000:00:04.3: [8086:0e23] type 00 class 0x088000
>>> [    1.878813] pci 0000:00:04.3: reg 0x10: [mem 0x38007ff60000-0x38007ff63fff 64bit]
>>> [    1.878929] pci 0000:00:04.4: [8086:0e24] type 00 class 0x088000
>>> [    1.878943] pci 0000:00:04.4: reg 0x10: [mem 0x38007ff50000-0x38007ff53fff 64bit]
>>> [    1.879061] pci 0000:00:04.5: [8086:0e25] type 00 class 0x088000
>>> [    1.879075] pci 0000:00:04.5: reg 0x10: [mem 0x38007ff40000-0x38007ff43fff 64bit]
>>> [    1.879192] pci 0000:00:04.6: [8086:0e26] type 00 class 0x088000
>>> [    1.879206] pci 0000:00:04.6: reg 0x10: [mem 0x38007ff30000-0x38007ff33fff 64bit]
>>> [    1.879322] pci 0000:00:04.7: [8086:0e27] type 00 class 0x088000
>>> [    1.879336] pci 0000:00:04.7: reg 0x10: [mem 0x38007ff20000-0x38007ff23fff 64bit]
>>> [    1.879466] pci 0000:00:05.0: [8086:0e28] type 00 class 0x088000
>>> [    1.879575] pci 0000:00:05.1: [8086:0e29] type 00 class 0x088000
>>> [    1.879702] pci 0000:00:05.2: [8086:0e2a] type 00 class 0x088000
>>> [    1.879811] pci 0000:00:05.4: [8086:0e2c] type 00 class 0x080020
>>> [    1.879821] pci 0000:00:05.4: reg 0x10: [mem 0xd0b60000-0xd0b60fff]
>>> [    1.879950] pci 0000:00:11.0: [8086:1d3e] type 01 class 0x060400
>>> [    1.880042] pci 0000:00:11.0: PME# supported from D0 D3hot D3cold
>>> [    1.880131] pci 0000:00:16.0: [8086:1d3a] type 00 class 0x078000
>>> [    1.880148] pci 0000:00:16.0: reg 0x10: [mem 0xd0b50000-0xd0b5000f 64bit]
>>> [    1.880208] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
>>> [    1.880278] pci 0000:00:16.1: [8086:1d3b] type 00 class 0x078000
>>> [    1.880295] pci 0000:00:16.1: reg 0x10: [mem 0xd0b40000-0xd0b4000f 64bit]
>>> [    1.880355] pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
>>> [    1.880437] pci 0000:00:1a.0: [8086:1d2d] type 00 class 0x0c0320
>>> [    1.880454] pci 0000:00:1a.0: reg 0x10: [mem 0xd0b20000-0xd0b203ff]
>>> [    1.880534] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
>>> [    1.880598] pci 0000:00:1a.0: System wakeup disabled by ACPI
>>> [    1.886949] pci 0000:00:1c.0: [8086:1d10] type 01 class 0x060400
>>> [    1.887076] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
>>> [    1.887132] pci 0000:00:1c.0: System wakeup disabled by ACPI
>>> [    1.893493] pci 0000:00:1c.7: [8086:1d1e] type 01 class 0x060400
>>> [    1.893568] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
>>> [    1.893616] pci 0000:00:1c.7: System wakeup disabled by ACPI
>>> [    1.899958] pci 0000:00:1d.0: [8086:1d26] type 00 class 0x0c0320
>>> [    1.899975] pci 0000:00:1d.0: reg 0x10: [mem 0xd0b10000-0xd0b103ff]
>>> [    1.900055] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
>>> [    1.900116] pci 0000:00:1d.0: System wakeup disabled by ACPI
>>> [    1.906463] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
>>> [    1.906548] pci 0000:00:1e.0: System wakeup disabled by ACPI
>>> [    1.912888] pci 0000:00:1f.0: [8086:1d41] type 00 class 0x060100
>>> [    1.913053] pci 0000:00:1f.2: [8086:1d02] type 00 class 0x010601
>>> [    1.913067] pci 0000:00:1f.2: reg 0x10: [io  0x3070-0x3077]
>>> [    1.913074] pci 0000:00:1f.2: reg 0x14: [io  0x3060-0x3063]
>>> [    1.913081] pci 0000:00:1f.2: reg 0x18: [io  0x3050-0x3057]
>>> [    1.913087] pci 0000:00:1f.2: reg 0x1c: [io  0x3040-0x3043]
>>> [    1.913094] pci 0000:00:1f.2: reg 0x20: [io  0x3020-0x303f]
>>> [    1.913101] pci 0000:00:1f.2: reg 0x24: [mem 0xd0b00000-0xd0b007ff]
>>> [    1.913140] pci 0000:00:1f.2: PME# supported from D3hot
>>> [    1.913207] pci 0000:00:1f.3: [8086:1d22] type 00 class 0x0c0500
>>> [    1.913221] pci 0000:00:1f.3: reg 0x10: [mem 0x38007ff10000-0x38007ff100ff 64bit]
>>> [    1.913240] pci 0000:00:1f.3: reg 0x20: [io  0x3000-0x301f]
>>> [    1.913357] pci 0000:00:01.0: PCI bridge to [bus 01]
>>> [    1.918992] pci 0000:00:02.0: PCI bridge to [bus 02]
>>> [    1.924620] pci 0000:00:03.0: PCI bridge to [bus 03]
>>> [    1.930265] pci 0000:04:00.0: [8086:1521] type 00 class 0x020000
>>> [    1.930276] pci 0000:04:00.0: reg 0x10: [mem 0xd0a20000-0xd0a3ffff]
>>> [    1.930288] pci 0000:04:00.0: reg 0x18: [io  0x2020-0x203f]
>>> [    1.930295] pci 0000:04:00.0: reg 0x1c: [mem 0xd0a50000-0xd0a53fff]
>>> [    1.930361] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
>>> [    1.930386] pci 0000:04:00.0: reg 0x184: [mem 0x38007fe60000-0x38007fe63fff 64bit pref]
>>> [    1.930388] pci 0000:04:00.0: VF(n) BAR0 space: [mem 0x38007fe60000-0x38007fe7ffff 64bit pref] (contains BAR0 for 8 VFs)
>>> [    1.942535] pci 0000:04:00.0: reg 0x190: [mem 0x38007fe40000-0x38007fe43fff 64bit pref]
>>> [    1.942536] pci 0000:04:00.0: VF(n) BAR3 space: [mem 0x38007fe40000-0x38007fe5ffff 64bit pref] (contains BAR3 for 8 VFs)
>>> [    1.954760] pci 0000:04:00.1: [8086:1521] type 00 class 0x020000
>>> [    1.954771] pci 0000:04:00.1: reg 0x10: [mem 0xd0a00000-0xd0a1ffff]
>>> [    1.954783] pci 0000:04:00.1: reg 0x18: [io  0x2000-0x201f]
>>> [    1.954790] pci 0000:04:00.1: reg 0x1c: [mem 0xd0a40000-0xd0a43fff]
>>> [    1.954853] pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
>>> [    1.954876] pci 0000:04:00.1: reg 0x184: [mem 0x38007fe20000-0x38007fe23fff 64bit pref]
>>> [    1.954877] pci 0000:04:00.1: VF(n) BAR0 space: [mem 0x38007fe20000-0x38007fe3ffff 64bit pref] (contains BAR0 for 8 VFs)
>>> [    1.967022] pci 0000:04:00.1: reg 0x190: [mem 0x38007fe00000-0x38007fe03fff 64bit pref]
>>> [    1.967023] pci 0000:04:00.1: VF(n) BAR3 space: [mem 0x38007fe00000-0x38007fe1ffff 64bit pref] (contains BAR3 for 8 VFs)
>>> [    1.982216] pci 0000:00:03.2: PCI bridge to [bus 04-05]
>>> [    1.988048] pci 0000:00:03.2:   bridge window [io  0x2000-0x2fff]
>>> [    1.988051] pci 0000:00:03.2:   bridge window [mem 0xd0a00000-0xd0afffff]
>>> [    1.988056] pci 0000:00:03.2:   bridge window [mem 0x38007fe00000-0x38007fefffff 64bit pref]
>>> [    1.988120] pci 0000:06:00.0: [8086:1d6b] type 00 class 0x010700
>>> [    1.988140] pci 0000:06:00.0: reg 0x10: [mem 0x38007fc00000-0x38007fc03fff 64bit pref]
>>> [    1.988155] pci 0000:06:00.0: reg 0x18: [mem 0x38007f800000-0x38007fbfffff 64bit pref]
>>> [    1.988165] pci 0000:06:00.0: reg 0x20: [io  0x1000-0x10ff]
>>> [    1.988274] pci 0000:06:00.0: reg 0x164: [mem 0x38007fc10000-0x38007fc13fff 64bit pref]
>>> [    1.988276] pci 0000:06:00.0: VF(n) BAR0 space: [mem 0x38007fc10000-0x38007fc8bfff 64bit pref] (contains BAR0 for 31 VFs)
>>> [    2.000673] pci 0000:06:00.3: [8086:1d70] type 00 class 0x0c0500
>>> [    2.000690] pci 0000:06:00.3: reg 0x10: [mem 0xd0900000-0xd0900fff]
>>> [    2.000730] pci 0000:06:00.3: reg 0x20: [io  0x1100-0x111f]
>>> [    2.000805] pci 0000:06:00.3: PME# supported from D0 D3hot D3cold
>>> [    2.000890] pci 0000:00:11.0: PCI bridge to [bus 06]
>>> [    2.006425] pci 0000:00:11.0:   bridge window [io  0x1000-0x1fff]
>>> [    2.006429] pci 0000:00:11.0:   bridge window [mem 0xd0900000-0xd09fffff]
>>> [    2.006438] pci 0000:00:11.0:   bridge window [mem 0x38007f800000-0x38007fcfffff 64bit pref]
>>> [    2.006504] pci 0000:00:1c.0: PCI bridge to [bus 07]
>>> [    2.012125] pci 0000:08:00.0: [102b:0522] type 00 class 0x030000
>>> [    2.012152] pci 0000:08:00.0: reg 0x10: [mem 0xea000000-0xeaffffff pref]
>>> [    2.012171] pci 0000:08:00.0: reg 0x14: [mem 0xd0810000-0xd0813fff]
>>> [    2.012187] pci 0000:08:00.0: reg 0x18: [mem 0xd0000000-0xd07fffff]
>>> [    2.012248] pci 0000:08:00.0: reg 0x30: [mem 0xd0800000-0xd080ffff pref]
>>> [    2.012356] pci 0000:08:00.0: System wakeup disabled by ACPI
>>> [    2.018708] pci 0000:00:1c.7: PCI bridge to [bus 08]
>>> [    2.024246] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd08fffff]
>>> [    2.024251] pci 0000:00:1c.7:   bridge window [mem 0xea000000-0xeaffffff 64bit pref]
>>> [    2.024314] pci 0000:00:1e.0: PCI bridge to [bus 09] (subtractive decode)
>>> [    2.031897] pci 0000:00:1e.0:   bridge window [io  0x0000-0xbfff] (subtractive decode)
>>> [    2.031901] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
>>> [    2.031902] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000c3fff window] (subtractive decode)
>>> [    2.031903] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000c7fff window] (subtractive decode)
>>> [    2.031905] pci 0000:00:1e.0:   bridge window [mem 0x000c8000-0x000cbfff window] (subtractive decode)
>>> [    2.031906] pci 0000:00:1e.0:   bridge window [mem 0x000cc000-0x000cffff window] (subtractive decode)
>>> [    2.031906] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff window] (subtractive decode)
>>> [    2.031908] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff window] (subtractive decode)
>>> [    2.031909] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff window] (subtractive decode)
>>> [    2.031910] pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff window] (subtractive decode)
>>> [    2.031911] pci 0000:00:1e.0:   bridge window [mem 0x000e4000-0x000e7fff window] (subtractive decode)
>>> [    2.031913] pci 0000:00:1e.0:   bridge window [mem 0x000e8000-0x000ebfff window] (subtractive decode)
>>> [    2.031914] pci 0000:00:1e.0:   bridge window [mem 0x000ec000-0x000effff window] (subtractive decode)
>>> [    2.031915] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff window] (subtractive decode)
>>> [    2.031916] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xebffffff window] (subtractive decode)
>>> [    2.031917] pci 0000:00:1e.0:   bridge window [mem 0x380000000000-0x38007fffffff window] (subtractive decode)
>>> [    2.031965] pci_bus 0000:00: on NUMA node 0
>>> [    2.032525] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
>>> [    2.040245] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
>>> [    2.047954] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 10 11 12 14 15)
>>> [    2.055669] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
>>> [    2.063384] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
>>> [    2.071099] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 15)
>>> [    2.078814] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *10 11 12 14 15)
>>> [    2.086527] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
>>> [    2.094332] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-fe])
>>> [    2.101232] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
>>> [    2.110474] acpi PNP0A08:01: _OSC: platform does not support [PCIeHotplug PME AER]
>>> [    2.119027] acpi PNP0A08:01: _OSC: OS now controls [PCIeCapability]
>>> [    2.126022] acpi PNP0A08:01: FADT indicates ASPM is unsupported, using BIOS configuration
>>> [    2.135327] PCI host bridge to bus 0000:80
>>> [    2.139901] pci_bus 0000:80: root bus resource [io  0x03b0-0x03df window]
>>> [    2.147476] pci_bus 0000:80: root bus resource [io  0xc000-0xffff window]
>>> [    2.155054] pci_bus 0000:80: root bus resource [mem 0x000a0000-0x000bffff window]
>>> [    2.163407] pci_bus 0000:80: root bus resource [mem 0xec000000-0xfbffffff window]
>>> [    2.171760] pci_bus 0000:80: root bus resource [mem 0x380080000000-0x3800ffffffff window]
>>> [    2.180891] pci_bus 0000:80: root bus resource [bus 80-fe]
>>> [    2.187027] pci 0000:80:01.0: [8086:0e02] type 01 class 0x060400
>>> [    2.187107] pci 0000:80:01.0: PME# supported from D0 D3hot D3cold
>>> [    2.187148] pci 0000:80:01.0: System wakeup disabled by ACPI
>>> [    2.193502] pci 0000:80:02.0: [8086:0e04] type 01 class 0x060400
>>> [    2.193581] pci 0000:80:02.0: PME# supported from D0 D3hot D3cold
>>> [    2.193624] pci 0000:80:02.0: System wakeup disabled by ACPI
>>> [    2.199971] pci 0000:80:04.0: [8086:0e20] type 00 class 0x088000
>>> [    2.199996] pci 0000:80:04.0: reg 0x10: [mem 0x3800fff70000-0x3800fff73fff 64bit]
>>> [    2.200118] pci 0000:80:04.1: [8086:0e21] type 00 class 0x088000
>>> [    2.200133] pci 0000:80:04.1: reg 0x10: [mem 0x3800fff60000-0x3800fff63fff 64bit]
>>> [    2.200244] pci 0000:80:04.2: [8086:0e22] type 00 class 0x088000
>>> [    2.200259] pci 0000:80:04.2: reg 0x10: [mem 0x3800fff50000-0x3800fff53fff 64bit]
>>> [    2.200372] pci 0000:80:04.3: [8086:0e23] type 00 class 0x088000
>>> [    2.200387] pci 0000:80:04.3: reg 0x10: [mem 0x3800fff40000-0x3800fff43fff 64bit]
>>> [    2.200497] pci 0000:80:04.4: [8086:0e24] type 00 class 0x088000
>>> [    2.200513] pci 0000:80:04.4: reg 0x10: [mem 0x3800fff30000-0x3800fff33fff 64bit]
>>> [    2.200627] pci 0000:80:04.5: [8086:0e25] type 00 class 0x088000
>>> [    2.200642] pci 0000:80:04.5: reg 0x10: [mem 0x3800fff20000-0x3800fff23fff 64bit]
>>> [    2.200752] pci 0000:80:04.6: [8086:0e26] type 00 class 0x088000
>>> [    2.200767] pci 0000:80:04.6: reg 0x10: [mem 0x3800fff10000-0x3800fff13fff 64bit]
>>> [    2.200879] pci 0000:80:04.7: [8086:0e27] type 00 class 0x088000
>>> [    2.200894] pci 0000:80:04.7: reg 0x10: [mem 0x3800fff00000-0x3800fff03fff 64bit]
>>> [    2.201005] pci 0000:80:05.0: [8086:0e28] type 00 class 0x088000
>>> [    2.201111] pci 0000:80:05.1: [8086:0e29] type 00 class 0x088000
>>> [    2.201231] pci 0000:80:05.2: [8086:0e2a] type 00 class 0x088000
>>> [    2.201332] pci 0000:80:05.4: [8086:0e2c] type 00 class 0x080020
>>> [    2.201343] pci 0000:80:05.4: reg 0x10: [mem 0xec000000-0xec000fff]
>>> [    2.201503] pci 0000:80:01.0: PCI bridge to [bus 81]
>>> [    2.207150] pci 0000:80:02.0: PCI bridge to [bus 82]
>>> [    2.212713] pci_bus 0000:80: on NUMA node 1
>>> [    2.215937] ACPI: PCI Root Bridge [UCR0] (domain 0000 [bus 7f])
>>> [    2.222548] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
>>> [    2.231699] acpi PNP0A03:00: _OSC: platform does not support [PCIeHotplug PME AER]
>>> [    2.240171] acpi PNP0A03:00: _OSC: OS now controls [PCIeCapability]
>>> [    2.247166] acpi PNP0A03:00: FADT indicates ASPM is unsupported, using BIOS configuration
>>> [    2.256344] PCI host bridge to bus 0000:7f
>>> [    2.260915] pci_bus 0000:7f: root bus resource [bus 7f]
>>> [    2.266752] pci 0000:7f:08.0: [8086:0e80] type 00 class 0x088000
>>> [    2.266802] pci 0000:7f:09.0: [8086:0e90] type 00 class 0x088000
>>> [    2.266846] pci 0000:7f:0a.0: [8086:0ec0] type 00 class 0x088000
>>> [    2.266883] pci 0000:7f:0a.1: [8086:0ec1] type 00 class 0x088000
>>> [    2.266922] pci 0000:7f:0a.2: [8086:0ec2] type 00 class 0x088000
>>> [    2.266957] pci 0000:7f:0a.3: [8086:0ec3] type 00 class 0x088000
>>> [    2.266997] pci 0000:7f:0b.0: [8086:0e1e] type 00 class 0x088000
>>> [    2.267032] pci 0000:7f:0b.3: [8086:0e1f] type 00 class 0x088000
>>> [    2.267070] pci 0000:7f:0c.0: [8086:0ee0] type 00 class 0x088000
>>> [    2.267105] pci 0000:7f:0c.1: [8086:0ee2] type 00 class 0x088000
>>> [    2.267141] pci 0000:7f:0c.2: [8086:0ee4] type 00 class 0x088000
>>> [    2.267179] pci 0000:7f:0c.3: [8086:0ee6] type 00 class 0x088000
>>> [    2.267216] pci 0000:7f:0d.0: [8086:0ee1] type 00 class 0x088000
>>> [    2.267253] pci 0000:7f:0d.1: [8086:0ee3] type 00 class 0x088000
>>> [    2.267287] pci 0000:7f:0d.2: [8086:0ee5] type 00 class 0x088000
>>> [    2.267324] pci 0000:7f:0d.3: [8086:0ee7] type 00 class 0x088000
>>> [    2.267360] pci 0000:7f:0e.0: [8086:0ea0] type 00 class 0x088000
>>> [    2.267402] pci 0000:7f:0e.1: [8086:0e30] type 00 class 0x110100
>>> [    2.267445] pci 0000:7f:0f.0: [8086:0ea8] type 00 class 0x088000
>>> [    2.267499] pci 0000:7f:0f.1: [8086:0e71] type 00 class 0x088000
>>> [    2.267550] pci 0000:7f:0f.2: [8086:0eaa] type 00 class 0x088000
>>> [    2.267603] pci 0000:7f:0f.3: [8086:0eab] type 00 class 0x088000
>>> [    2.267654] pci 0000:7f:0f.4: [8086:0eac] type 00 class 0x088000
>>> [    2.267705] pci 0000:7f:0f.5: [8086:0ead] type 00 class 0x088000
>>> [    2.267762] pci 0000:7f:10.0: [8086:0eb0] type 00 class 0x088000
>>> [    2.267816] pci 0000:7f:10.1: [8086:0eb1] type 00 class 0x088000
>>> [    2.267870] pci 0000:7f:10.2: [8086:0eb2] type 00 class 0x088000
>>> [    2.267921] pci 0000:7f:10.3: [8086:0eb3] type 00 class 0x088000
>>> [    2.267973] pci 0000:7f:10.4: [8086:0eb4] type 00 class 0x088000
>>> [    2.268025] pci 0000:7f:10.5: [8086:0eb5] type 00 class 0x088000
>>> [    2.268078] pci 0000:7f:10.6: [8086:0eb6] type 00 class 0x088000
>>> [    2.268131] pci 0000:7f:10.7: [8086:0eb7] type 00 class 0x088000
>>> [    2.268187] pci 0000:7f:13.0: [8086:0e1d] type 00 class 0x088000
>>> [    2.268222] pci 0000:7f:13.1: [8086:0e34] type 00 class 0x110100
>>> [    2.268258] pci 0000:7f:13.4: [8086:0e81] type 00 class 0x088000
>>> [    2.268296] pci 0000:7f:13.5: [8086:0e36] type 00 class 0x110100
>>> [    2.268331] pci 0000:7f:13.6: [8086:0e37] type 00 class 0x110100
>>> [    2.268370] pci 0000:7f:16.0: [8086:0ec8] type 00 class 0x088000
>>> [    2.268405] pci 0000:7f:16.1: [8086:0ec9] type 00 class 0x088000
>>> [    2.268442] pci 0000:7f:16.2: [8086:0eca] type 00 class 0x088000
>>> [    2.268532] ACPI: PCI Root Bridge [UCR1] (domain 0000 [bus ff])
>>> [    2.275142] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
>>> [    2.284295] acpi PNP0A03:01: _OSC: platform does not support [PCIeHotplug PME AER]
>>> [    2.292767] acpi PNP0A03:01: _OSC: OS now controls [PCIeCapability]
>>> [    2.299763] acpi PNP0A03:01: FADT indicates ASPM is unsupported, using BIOS configuration
>>> [    2.308942] PCI host bridge to bus 0000:ff
>>> [    2.313515] pci_bus 0000:ff: root bus resource [bus ff]
>>> [    2.319343] pci 0000:ff:08.0: [8086:0e80] type 00 class 0x088000
>>> [    2.319398] pci 0000:ff:09.0: [8086:0e90] type 00 class 0x088000
>>> [    2.319446] pci 0000:ff:0a.0: [8086:0ec0] type 00 class 0x088000
>>> [    2.319491] pci 0000:ff:0a.1: [8086:0ec1] type 00 class 0x088000
>>> [    2.319533] pci 0000:ff:0a.2: [8086:0ec2] type 00 class 0x088000
>>> [    2.319577] pci 0000:ff:0a.3: [8086:0ec3] type 00 class 0x088000
>>> [    2.319621] pci 0000:ff:0b.0: [8086:0e1e] type 00 class 0x088000
>>> [    2.319664] pci 0000:ff:0b.3: [8086:0e1f] type 00 class 0x088000
>>> [    2.319704] pci 0000:ff:0c.0: [8086:0ee0] type 00 class 0x088000
>>> [    2.319750] pci 0000:ff:0c.1: [8086:0ee2] type 00 class 0x088000
>>> [    2.319791] pci 0000:ff:0c.2: [8086:0ee4] type 00 class 0x088000
>>> [    2.319835] pci 0000:ff:0c.3: [8086:0ee6] type 00 class 0x088000
>>> [    2.319878] pci 0000:ff:0d.0: [8086:0ee1] type 00 class 0x088000
>>> [    2.319919] pci 0000:ff:0d.1: [8086:0ee3] type 00 class 0x088000
>>> [    2.319963] pci 0000:ff:0d.2: [8086:0ee5] type 00 class 0x088000
>>> [    2.320004] pci 0000:ff:0d.3: [8086:0ee7] type 00 class 0x088000
>>> [    2.320049] pci 0000:ff:0e.0: [8086:0ea0] type 00 class 0x088000
>>> [    2.320100] pci 0000:ff:0e.1: [8086:0e30] type 00 class 0x110100
>>> [    2.320157] pci 0000:ff:0f.0: [8086:0ea8] type 00 class 0x088000
>>> [    2.320231] pci 0000:ff:0f.1: [8086:0e71] type 00 class 0x088000
>>> [    2.320299] pci 0000:ff:0f.2: [8086:0eaa] type 00 class 0x088000
>>> [    2.320362] pci 0000:ff:0f.3: [8086:0eab] type 00 class 0x088000
>>> [    2.320426] pci 0000:ff:0f.4: [8086:0eac] type 00 class 0x088000
>>> [    2.320491] pci 0000:ff:0f.5: [8086:0ead] type 00 class 0x088000
>>> [    2.320555] pci 0000:ff:10.0: [8086:0eb0] type 00 class 0x088000
>>> [    2.320620] pci 0000:ff:10.1: [8086:0eb1] type 00 class 0x088000
>>> [    2.320682] pci 0000:ff:10.2: [8086:0eb2] type 00 class 0x088000
>>> [    2.320744] pci 0000:ff:10.3: [8086:0eb3] type 00 class 0x088000
>>> [    2.320804] pci 0000:ff:10.4: [8086:0eb4] type 00 class 0x088000
>>> [    2.320866] pci 0000:ff:10.5: [8086:0eb5] type 00 class 0x088000
>>> [    2.320926] pci 0000:ff:10.6: [8086:0eb6] type 00 class 0x088000
>>> [    2.320989] pci 0000:ff:10.7: [8086:0eb7] type 00 class 0x088000
>>> [    2.321048] pci 0000:ff:13.0: [8086:0e1d] type 00 class 0x088000
>>> [    2.321092] pci 0000:ff:13.1: [8086:0e34] type 00 class 0x110100
>>> [    2.321134] pci 0000:ff:13.4: [8086:0e81] type 00 class 0x088000
>>> [    2.321178] pci 0000:ff:13.5: [8086:0e36] type 00 class 0x110100
>>> [    2.321229] pci 0000:ff:13.6: [8086:0e37] type 00 class 0x110100
>>> [    2.321278] pci 0000:ff:16.0: [8086:0ec8] type 00 class 0x088000
>>> [    2.321321] pci 0000:ff:16.1: [8086:0ec9] type 00 class 0x088000
>>> [    2.321364] pci 0000:ff:16.2: [8086:0eca] type 00 class 0x088000
>>> [    2.321539] ACPI: Enabled 6 GPEs in block 00 to 3F
>>> [    2.327138] pci 0000:08:00.0: vgaarb: setting as boot VGA device
>>> [    2.333842] pci 0000:08:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
>>> [    2.343375] pci 0000:08:00.0: vgaarb: bridge control possible
>>> [    2.349786] vgaarb: loaded
>>> [    2.352928] SCSI subsystem initialized
>>> [    2.357137] ACPI: bus type USB registered
>>> [    2.361625] usbcore: registered new interface driver usbfs
>>> [    2.367752] usbcore: registered new interface driver hub
>>> [    2.373811] usbcore: registered new device driver usb
>>> [    2.379737] PCI: Using ACPI for IRQ routing
>>> [    2.388858] PCI: pci_cache_line_size set to 64 bytes
>>> [    2.389041] e820: reserve RAM buffer [mem 0xbad4b000-0xbbffffff]
>>> [    2.389042] e820: reserve RAM buffer [mem 0xbafc4000-0xbbffffff]
>>> [    2.389043] e820: reserve RAM buffer [mem 0xbb3d4000-0xbbffffff]
>>> [    2.389044] e820: reserve RAM buffer [mem 0xbe000000-0xbfffffff]
>>> [    2.389194] NetLabel: Initializing
>>> [    2.392990] NetLabel:  domain hash size = 128
>>> [    2.397851] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
>>> [    2.404185] NetLabel:  unlabeled traffic allowed by default
>>> [    2.410621] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
>>> [    2.417526] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
>>> [    2.426158] clocksource: Switched to clocksource hpet
>>> [    2.443509] VFS: Disk quotas dquot_6.6.0
>>> [    2.447981] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
>>> [    2.455845] pnp: PnP ACPI init
>>> [    2.459561] system 00:00: [io  0x0680-0x069f] has been reserved
>>> [    2.466177] system 00:00: [io  0xffff] has been reserved
>>> [    2.472113] system 00:00: [io  0xffff] has been reserved
>>> [    2.478046] system 00:00: [io  0xffff] has been reserved
>>> [    2.483981] system 00:00: [io  0x0400-0x0453] has been reserved
>>> [    2.490592] system 00:00: [io  0x0458-0x047f] has been reserved
>>> [    2.497201] system 00:00: [io  0x0500-0x057f] has been reserved
>>> [    2.503811] system 00:00: [io  0x0600-0x061f] has been reserved
>>> [    2.510421] system 00:00: [io  0x0ca2-0x0ca5] has been reserved
>>> [    2.517033] system 00:00: [io  0x0cf9] could not be reserved
>>> [    2.523359] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
>>> [    2.523385] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
>>> [    2.523470] system 00:02: [io  0x0454-0x0457] has been reserved
>>> [    2.530086] system 00:02: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
>>> [    2.530293] pnp 00:03: [dma 0 disabled]
>>> [    2.530336] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
>>> [    2.530473] pnp 00:04: [dma 0 disabled]
>>> [    2.530513] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
>>> [    2.530815] system 00:05: [mem 0xfed1c000-0xfed1ffff] has been reserved
>>> [    2.538207] system 00:05: [mem 0xebfff000-0xebffffff] has been reserved
>>> [    2.545594] system 00:05: [mem 0xc0000000-0xcfffffff] has been reserved
>>> [    2.552984] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
>>> [    2.560371] system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
>>> [    2.567759] system 00:05: [mem 0xff000000-0xffffffff] could not be reserved
>>> [    2.575534] system 00:05: [mem 0xfee00000-0xfeefffff] could not be reserved
>>> [    2.583310] system 00:05: [mem 0xfec00000-0xfecfffff] could not be reserved
>>> [    2.591087] system 00:05: [mem 0xd0b70000-0xd0b70fff] has been reserved
>>> [    2.598477] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
>>> [    2.598724] system 00:06: [mem 0x00000000-0x0009cfff] could not be reserved
>>> [    2.606504] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
>>> [    2.606774] pnp: PnP ACPI: found 7 devices
>>> [    2.617510] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
>>> [    2.627517] pci 0000:00:01.0: PCI bridge to [bus 01]
>>> [    2.633070] pci 0000:00:02.0: PCI bridge to [bus 02]
>>> [    2.638620] pci 0000:00:03.0: PCI bridge to [bus 03]
>>> [    2.644172] pci 0000:00:03.2: PCI bridge to [bus 04-05]
>>> [    2.650007] pci 0000:00:03.2:   bridge window [io  0x2000-0x2fff]
>>> [    2.656813] pci 0000:00:03.2:   bridge window [mem 0xd0a00000-0xd0afffff]
>>> [    2.664393] pci 0000:00:03.2:   bridge window [mem 0x38007fe00000-0x38007fefffff 64bit pref]
>>> [    2.673823] pci 0000:00:11.0: PCI bridge to [bus 06]
>>> [    2.679366] pci 0000:00:11.0:   bridge window [io  0x1000-0x1fff]
>>> [    2.686173] pci 0000:00:11.0:   bridge window [mem 0xd0900000-0xd09fffff]
>>> [    2.693754] pci 0000:00:11.0:   bridge window [mem 0x38007f800000-0x38007fcfffff 64bit pref]
>>> [    2.703179] pci 0000:00:1c.0: PCI bridge to [bus 07]
>>> [    2.708738] pci 0000:00:1c.7: PCI bridge to [bus 08]
>>> [    2.714284] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd08fffff]
>>> [    2.721864] pci 0000:00:1c.7:   bridge window [mem 0xea000000-0xeaffffff 64bit pref]
>>> [    2.730513] pci 0000:00:1e.0: PCI bridge to [bus 09]
>>> [    2.736064] pci_bus 0000:00: resource 4 [io  0x0000-0xbfff]
>>> [    2.736066] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff window]
>>> [    2.736067] pci_bus 0000:00: resource 6 [mem 0x000c0000-0x000c3fff window]
>>> [    2.736068] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000c7fff window]
>>> [    2.736069] pci_bus 0000:00: resource 8 [mem 0x000c8000-0x000cbfff window]
>>> [    2.736070] pci_bus 0000:00: resource 9 [mem 0x000cc000-0x000cffff window]
>>> [    2.736071] pci_bus 0000:00: resource 10 [mem 0x000d4000-0x000d7fff window]
>>> [    2.736072] pci_bus 0000:00: resource 11 [mem 0x000d8000-0x000dbfff window]
>>> [    2.736073] pci_bus 0000:00: resource 12 [mem 0x000dc000-0x000dffff window]
>>> [    2.736074] pci_bus 0000:00: resource 13 [mem 0x000e0000-0x000e3fff window]
>>> [    2.736075] pci_bus 0000:00: resource 14 [mem 0x000e4000-0x000e7fff window]
>>> [    2.736076] pci_bus 0000:00: resource 15 [mem 0x000e8000-0x000ebfff window]
>>> [    2.736078] pci_bus 0000:00: resource 16 [mem 0x000ec000-0x000effff window]
>>> [    2.736079] pci_bus 0000:00: resource 17 [mem 0x000f0000-0x000fffff window]
>>> [    2.736080] pci_bus 0000:00: resource 18 [mem 0xd0000000-0xebffffff window]
>>> [    2.736081] pci_bus 0000:00: resource 19 [mem 0x380000000000-0x38007fffffff window]
>>> [    2.736083] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
>>> [    2.736084] pci_bus 0000:04: resource 1 [mem 0xd0a00000-0xd0afffff]
>>> [    2.736085] pci_bus 0000:04: resource 2 [mem 0x38007fe00000-0x38007fefffff 64bit pref]
>>> [    2.736086] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
>>> [    2.736087] pci_bus 0000:06: resource 1 [mem 0xd0900000-0xd09fffff]
>>> [    2.736088] pci_bus 0000:06: resource 2 [mem 0x38007f800000-0x38007fcfffff 64bit pref]
>>> [    2.736089] pci_bus 0000:08: resource 1 [mem 0xd0000000-0xd08fffff]
>>> [    2.736090] pci_bus 0000:08: resource 2 [mem 0xea000000-0xeaffffff 64bit pref]
>>> [    2.736091] pci_bus 0000:09: resource 4 [io  0x0000-0xbfff]
>>> [    2.736092] pci_bus 0000:09: resource 5 [mem 0x000a0000-0x000bffff window]
>>> [    2.736093] pci_bus 0000:09: resource 6 [mem 0x000c0000-0x000c3fff window]
>>> [    2.736094] pci_bus 0000:09: resource 7 [mem 0x000c4000-0x000c7fff window]
>>> [    2.736095] pci_bus 0000:09: resource 8 [mem 0x000c8000-0x000cbfff window]
>>> [    2.736096] pci_bus 0000:09: resource 9 [mem 0x000cc000-0x000cffff window]
>>> [    2.736097] pci_bus 0000:09: resource 10 [mem 0x000d4000-0x000d7fff window]
>>> [    2.736098] pci_bus 0000:09: resource 11 [mem 0x000d8000-0x000dbfff window]
>>> [    2.736099] pci_bus 0000:09: resource 12 [mem 0x000dc000-0x000dffff window]
>>> [    2.736100] pci_bus 0000:09: resource 13 [mem 0x000e0000-0x000e3fff window]
>>> [    2.736100] pci_bus 0000:09: resource 14 [mem 0x000e4000-0x000e7fff window]
>>> [    2.736101] pci_bus 0000:09: resource 15 [mem 0x000e8000-0x000ebfff window]
>>> [    2.736102] pci_bus 0000:09: resource 16 [mem 0x000ec000-0x000effff window]
>>> [    2.736103] pci_bus 0000:09: resource 17 [mem 0x000f0000-0x000fffff window]
>>> [    2.736104] pci_bus 0000:09: resource 18 [mem 0xd0000000-0xebffffff window]
>>> [    2.736105] pci_bus 0000:09: resource 19 [mem 0x380000000000-0x38007fffffff window]
>>> [    2.736219] pci 0000:80:01.0: PCI bridge to [bus 81]
>>> [    2.741771] pci 0000:80:02.0: PCI bridge to [bus 82]
>>> [    2.747323] pci_bus 0000:80: resource 4 [io  0x03b0-0x03df window]
>>> [    2.747324] pci_bus 0000:80: resource 5 [io  0xc000-0xffff window]
>>> [    2.747324] pci_bus 0000:80: resource 6 [mem 0x000a0000-0x000bffff window]
>>> [    2.747326] pci_bus 0000:80: resource 7 [mem 0xec000000-0xfbffffff window]
>>> [    2.747330] pci_bus 0000:80: resource 8 [mem 0x380080000000-0x3800ffffffff window]
>>> [    2.747527] NET: Registered protocol family 2
>>> [    2.753184] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
>>> [    2.762484] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
>>> [    2.770217] TCP: Hash tables configured (established 524288 bind 65536)
>>> [    2.777898] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
>>> [    2.785168] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
>>> [    2.793418] NET: Registered protocol family 1
>>> [    3.998191] pci 0000:00:1a.0: EHCI: BIOS handoff failed (BIOS bug?) 01010001
>>> [    5.206232] pci 0000:00:1d.0: EHCI: BIOS handoff failed (BIOS bug?) 01010001
>>> [    5.214313] pci 0000:08:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
>>> [    5.223797] PCI: CLS 64 bytes, default 64
>>> [    5.223860] Unpacking initramfs...
>>> [    5.515860] Freeing initrd memory: 19788K
>>> [    5.520345] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
>>> [    5.527536] software IO TLB [mem 0xb2da1000-0xb6da1000] (64MB) mapped at [ffff9743f2da1000-ffff9743f6da0fff]
>>> [    5.538877] RAPL PMU: API unit is 2^-32 Joules, 3 fixed counters, 163840 ms ovfl timer
>>> [    5.547728] RAPL PMU: hw unit of domain pp0-core 2^-16 Joules
>>> [    5.554144] RAPL PMU: hw unit of domain package 2^-16 Joules
>>> [    5.560463] RAPL PMU: hw unit of domain dram 2^-16 Joules
>>> [    5.573058] audit: initializing netlink subsys (disabled)
>>> [    5.579742] Initialise system trusted keyrings
>>> [    5.584830] workingset: timestamp_bits=36 max_order=24 bucket_order=0
>>> [    5.592982] zbud: loaded
>>> [    5.596363] SELinux:  Registering netfilter hooks
>>> [    5.645284] NET: Registered protocol family 38
>>> [    5.650275] Key type asymmetric registered
>>> [    5.654851] Asymmetric key parser 'x509' registered
>>> [    5.660318] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
>>> [    5.668724] io scheduler noop registered
>>> [    5.673121] io scheduler deadline registered (default)
>>> [    5.678896] io scheduler cfq registered
>>> [    5.683183] io scheduler mq-deadline registered
>>> [    5.688534] atomic64_test: passed for x86-64 platform with CX8 and with SSE
>>> [    5.698146] intel_idle: MWAIT substates: 0x20
>>> [    5.698147] intel_idle: v0.4.1 model 0x3E
>>> [    5.698715] intel_idle: lapic_timer_reliable_states 0xffffffff
>>> [    5.698843] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
>>> [    5.708177] ACPI: Sleep Button [SLPB]
>>> [    5.712307] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
>>> [    5.720568] ACPI: Power Button [PWRF]
>>> [    5.726828] ERST: Error Record Serialization Table (ERST) support is initialized.
>>> [    5.735195] pstore: using zlib compression
>>> [    5.739774] pstore: Registered erst as persistent store backend
>>> [    5.746556] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
>>> [    5.754890] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>>> [    5.782652] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
>>> [    5.811566] 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
>>> [    5.820255] Non-volatile memory driver v1.3
>>> [    5.824960] Linux agpgart interface v0.103
>>> [    5.830723] rdac: device handler registered
>>> [    5.835451] hp_sw: device handler registered
>>> [    5.840232] emc: device handler registered
>>> [    5.845092] alua: device handler registered
>>> [    5.849799] libphy: Fixed MDIO Bus: probed
>>> [    5.854423] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>>> [    5.861717] ehci-pci: EHCI PCI platform driver
>>> [    5.866923] ehci-pci 0000:00:1a.0: EHCI Host Controller
>>> [    5.872814] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
>>> [    5.881085] ehci-pci 0000:00:1a.0: debug port 2
>>> [    5.890051] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
>>> [    5.890067] ehci-pci 0000:00:1a.0: irq 22, io mem 0xd0b20000
>>> [    5.903259] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
>>> [    5.909725] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
>>> [    5.917304] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>>> [    5.925364] usb usb1: Product: EHCI Host Controller
>>> [    5.930813] usb usb1: Manufacturer: Linux 4.11.0-rc5+ ehci_hcd
>>> [    5.937329] usb usb1: SerialNumber: 0000:00:1a.0
>>> [    5.942582] hub 1-0:1.0: USB hub found
>>> [    5.946783] hub 1-0:1.0: 2 ports detected
>>> [    5.951487] ehci-pci 0000:00:1d.0: EHCI Host Controller
>>> [    5.957370] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
>>> [    5.965643] ehci-pci 0000:00:1d.0: debug port 2
>>> [    5.974614] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
>>> [    5.974622] ehci-pci 0000:00:1d.0: irq 20, io mem 0xd0b10000
>>> [    5.987260] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
>>> [    5.993715] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
>>> [    6.001297] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>>> [    6.009362] usb usb2: Product: EHCI Host Controller
>>> [    6.014809] usb usb2: Manufacturer: Linux 4.11.0-rc5+ ehci_hcd
>>> [    6.021324] usb usb2: SerialNumber: 0000:00:1d.0
>>> [    6.026555] hub 2-0:1.0: USB hub found
>>> [    6.030749] hub 2-0:1.0: 2 ports detected
>>> [    6.035343] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>>> [    6.042266] ohci-pci: OHCI PCI platform driver
>>> [    6.047252] uhci_hcd: USB Universal Host Controller Interface driver
>>> [    6.054404] usbcore: registered new interface driver usbserial
>>> [    6.060924] usbcore: registered new interface driver usbserial_generic
>>> [    6.068221] usbserial: USB Serial support registered for generic
>>> [    6.074950] i8042: PNP: No PS/2 controller found.
>>> [    6.080263] mousedev: PS/2 mouse device common for all mice
>>> [    6.086598] rtc_cmos 00:01: RTC can wake from S4
>>> [    6.091886] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
>>> [    6.098724] rtc_cmos 00:01: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
>>> [    6.107287] intel_pstate: Intel P-state driver initializing
>>> [    6.114304] hidraw: raw HID events driver (C) Jiri Kosina
>>> [    6.120403] usbcore: registered new interface driver usbhid
>>> [    6.126628] usbhid: USB HID core driver
>>> [    6.131133] drop_monitor: Initializing network drop monitor service
>>> [    6.138415] Initializing XFRM netlink socket
>>> [    6.143375] NET: Registered protocol family 10
>>> [    6.149141] Segment Routing with IPv6
>>> [    6.153256] NET: Registered protocol family 17
>>> [    6.159177] microcode: sig=0x306e4, pf=0x20, revision=0xc8730415
>>> [    6.165981] microcode: Microcode Update Driver: v2.2.
>>> [    6.166091] registered taskstats version 1
>>> [    6.176317] Loading compiled-in X.509 certificates
>>> [    6.183437] alg: No test for pkcs1pad(rsa,sha256) (pkcs1pad(rsa-generic,sha256))
>>> [    6.192499] Loaded X.509 cert 'Build time autogenerated kernel key: 1fb99fb420957198d5b4eec7933b1876619428a3'
>>> [    6.203605] zswap: loaded using pool lzo/zbud
>>> [    6.218365] Key type big_key registered
>>> [    6.224223] Key type trusted registered
>>> [    6.230005] Key type encrypted registered
>>> [    6.234482] ima: No TPM chip found, activating TPM-bypass! (rc=-19)
>>> [    6.241508] evm: HMAC attrs: 0x1
>>> [    6.245890] rtc_cmos 00:01: setting system clock to 2017-04-07 10:38:30 UTC (1491561510)
>>> [    6.256706] Freeing unused kernel memory: 2124K
>>> [    6.260257] usb 1-1: new high-speed USB device number 2 using ehci-pci
>>> [    6.269064] Write protecting the kernel read-only data: 12288k
>>> [    6.276117] Freeing unused kernel memory: 728K
>>> [    6.283265] Freeing unused kernel memory: 904K
>>> [    6.288243] rodata_test: all tests were successful
>>> [    6.311256] random: systemd: uninitialized urandom read (16 bytes read)
>>> [    6.319554] random: systemd: uninitialized urandom read (16 bytes read)
>>> [    6.329313] systemd[1]: systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
>>> [    6.349257] usb 2-1: new high-speed USB device number 2 using ehci-pci
>>> [    6.357048] systemd[1]: Detected architecture x86-64.
>>> [    6.362701] systemd[1]: Running in initial RAM disk.
>>> [    6.378569] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
>>> [    6.386063] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>>> [    6.394128] systemd[1]: Set hostname to <localhost.localdomain>.
>>> [    6.394343] hub 1-1:1.0: USB hub found
>>> [    6.394447] hub 1-1:1.0: 6 ports detected
>>> [    6.432374] random: systemd: uninitialized urandom read (16 bytes read)
>>> [    6.439787] random: systemd: uninitialized urandom read (16 bytes read)
>>> [    6.447208] random: systemd: uninitialized urandom read (16 bytes read)
>>> [    6.454649] random: systemd: uninitialized urandom read (16 bytes read)
>>> [    6.462669] random: systemd: uninitialized urandom read (16 bytes read)
>>> [    6.467576] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
>>> [    6.467577] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>>> [    6.467716] hub 2-1:1.0: USB hub found
>>> [    6.467824] hub 2-1:1.0: 8 ports detected
>>> [    6.494318] random: systemd: uninitialized urandom read (16 bytes read)
>>> [    6.501880] random: systemd: uninitialized urandom read (16 bytes read)
>>> [    6.509751] random: systemd: uninitialized urandom read (16 bytes read)
>>> [    6.527283] systemd[1]: Reached target Local File Systems.
>>> [    6.533435] systemd[1]: Starting Local File Systems.
>>> [    6.544274] systemd[1]: Reached target Timers.
>>> [    6.549258] systemd[1]: Starting Timers.
>>> [    6.559274] systemd[1]: Created slice Root Slice.
>>> [    6.564540] systemd[1]: Starting Root Slice.
>>> [    6.572285] tsc: Refined TSC clocksource calibration: 2593.749 MHz
>>> [    6.579449] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x25632b1b102, max_idle_ns: 440795335950 ns
>>> [    6.740272] usb 2-1.4: new full-speed USB device number 3 using ehci-pci
>>> [    6.776941] device-mapper: uevent: version 1.0.3
>>> [    6.782211] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel@redhat.com
>>> [    6.842210] usb 2-1.4: New USB device found, idVendor=046b, idProduct=ff10
>>> [    6.850265] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>>> [    6.858441] usb 2-1.4: Product: Virtual Keyboard and Mouse
>>> [    6.864577] usb 2-1.4: Manufacturer: American Megatrends Inc.
>>> [    6.864578] usb 2-1.4: SerialNumber: serial
>>> [    6.865944] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/0003:046B:FF10.0001/input/input2
>>> [    6.866137] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.0-1.4/input0
>>> [    6.867133] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.1/0003:046B:FF10.0002/input/input3
>>> [    6.867252] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.0-1.4/input1
>>> [    6.931281] usb 2-1.5: new low-speed USB device number 4 using ehci-pci
>>> [    6.950857] libata version 3.00 loaded.
>>> [    6.952030] nd_pmem namespace0.0: unable to guarantee persistence of writes
>>> [    6.959986] dca service started, version 1.12.1
>>> [    6.968804] pps_core: LinuxPPS API ver. 1 registered
>>> [    6.968805] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
>>> [    6.969159] ahci 0000:00:1f.2: version 3.0
>>> [    6.969894] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
>>> [    6.969896] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst
>>> [    6.970350] PTP clock support registered
>>> [    6.984709] scsi host0: ahci
>>> [    7.013349] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4.0-k
>>> [    7.018595] usb 2-1.5: New USB device found, idVendor=0624, idProduct=0291
>>> [    7.018597] usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>>> [    7.018598] usb 2-1.5: Product: Avocent AVRIQ-USB
>>> [    7.018599] usb 2-1.5: Manufacturer: Avocent
>>> [    7.050983] igb: Copyright (c) 2007-2014 Intel Corporation.
>>> [    7.057979] input: Avocent Avocent AVRIQ-USB as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/0003:0624:0291.0003/input/input4
>>> [    7.088292] [TTM] Zone  kernel: Available graphics memory: 32937238 kiB
>>> [    7.095685] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
>>> [    7.095685] [TTM] Initializing pool allocator
>>> [    7.095688] [TTM] Initializing DMA pool allocator
>>> [    7.125402] hid-generic 0003:0624:0291.0003: input,hidraw2: USB HID v1.10 Keyboard [Avocent Avocent AVRIQ-USB] on usb-0000:00:1d.0-1.5/input0
>>> [    7.146406] input: Avocent Avocent AVRIQ-USB as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.1/0003:0624:0291.0004/input/input5
>>> [    7.163796] igb 0000:04:00.0: added PHC on eth0
>>> [    7.169513] igb 0000:04:00.0: Intel(R) Gigabit Ethernet Network Connection
>>> [    7.169514] igb 0000:04:00.0: eth0: (PCIe:5.0Gb/s:Width x4) 00:1e:67:58:98:f8
>>> [    7.169518] fbcon: mgadrmfb (fb0) is primary device
>>> [    7.169596] igb 0000:04:00.0: eth0: PBA No: 106200-000
>>> [    7.169598] igb 0000:04:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
>>> [    7.215368] hid-generic 0003:0624:0291.0004: input,hidraw3: USB HID v1.10 Mouse [Avocent Avocent AVRIQ-USB] on usb-0000:00:1d.0-1.5/input1
>>> [    7.236988] igb 0000:04:00.1: added PHC on eth1
>>> [    7.236989] igb 0000:04:00.1: Intel(R) Gigabit Ethernet Network Connection
>>> [    7.236990] igb 0000:04:00.1: eth1: (PCIe:5.0Gb/s:Width x4) 00:1e:67:58:98:f9
>>> [    7.237063] igb 0000:04:00.1: eth1: PBA No: 106200-000
>>> [    7.237065] igb 0000:04:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
>>> [    7.238358] igb 0000:04:00.0 enp4s0f0: renamed from eth0
>>> [    7.401743] Console: switching to colour frame buffer device 128x48
>>> [    7.522125] mgag200 0000:08:00.0: fb0: mgadrmfb frame buffer device
>>> [    7.596926] clocksource: Switched to clocksource tsc
>>> [    8.813472] [drm] Initialized mgag200 1.0.0 20110418 for 0000:08:00.0 on minor 0
>>> [    8.813923] igb 0000:04:00.1 enp4s0f1: renamed from eth1
>>> [    9.309404] scsi host1: ahci
>>> [    9.312748] scsi host2: ahci
>>> [    9.312750] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
>>> [    9.312770] isci 0000:06:00.0: driver configured for rev: 6 silicon
>>> [    9.312773] isci 0000:06:00.0: OEM parameter table found in OROM
>>> [    9.312775] isci 0000:06:00.0: OEM SAS parameters (version: 1.1) loaded (platform)
>>> [    9.312952] isci 0000:06:00.0: SCU controller 0: phy 3-0 cables: {short, short, short, short}
>>> [    9.315366] scsi host3: isci
>>> [    9.358160] scsi host4: ahci
>>> [    9.361513] scsi host5: ahci
>>> [    9.364837] scsi host6: ahci
>>> [    9.368094] ata1: SATA max UDMA/133 abar m2048@0xd0b00000 port 0xd0b00100 irq 26
>>> [    9.376353] ata2: SATA max UDMA/133 abar m2048@0xd0b00000 port 0xd0b00180 irq 26
>>> [    9.384611] ata3: SATA max UDMA/133 abar m2048@0xd0b00000 port 0xd0b00200 irq 26
>>> [    9.392870] ata4: SATA max UDMA/133 abar m2048@0xd0b00000 port 0xd0b00280 irq 26
>>> [    9.401130] ata5: SATA max UDMA/133 abar m2048@0xd0b00000 port 0xd0b00300 irq 26
>>> [    9.409390] ata6: SATA max UDMA/133 abar m2048@0xd0b00000 port 0xd0b00380 irq 26
>>> [    9.721505] ata3: SATA link down (SStatus 0 SControl 300)
>>> [    9.727550] ata2: SATA link down (SStatus 0 SControl 300)
>>> [    9.733592] ata1: SATA link down (SStatus 0 SControl 300)
>>> [    9.739645] ata5: SATA link down (SStatus 0 SControl 300)
>>> [    9.745729] ata4: SATA link down (SStatus 0 SControl 300)
>>> [    9.751811] ata6: SATA link down (SStatus 0 SControl 300)
>>> [    9.923219] pmem0: detected capacity change from 0 to 206158430208
>>> [   10.412470] sas: phy-3:0 added to port-3:0, phy_mask:0x1 (5001e675898f8000)
>>> [   10.412486] sas: DOING DISCOVERY on port 0, pid:5
>>> [   10.412503] sas: DONE DISCOVERY on port 0, pid:5, result:0
>>> [   10.412510] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>>> [   10.412556] sas: ata7: end_device-3:0: dev error handler
>>> [   10.592430] ata7.00: ATA-8: WDC WD1002FAEX-00Z3A0, 05.01D05, max UDMA/133
>>> [   10.600014] ata7.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
>>> [   10.609311] ata7.00: configured for UDMA/133
>>> [   10.614091] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
>>> [   10.624824] scsi 3:0:0:0: Direct-Access     ATA      WDC WD1002FAEX-0 1D05 PQ: 0 ANSI: 5
>>> [   10.650771] sd 3:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/932 GiB)
>>> [   10.659348] sd 3:0:0:0: [sda] Write Protect is off
>>> [   10.664705] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
>>> [   10.664721] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>>> [   10.683938] random: fast init done
>>> [   10.687752]  sda: sda1 sda2
>>> [   10.691113] sd 3:0:0:0: [sda] Attached SCSI disk
>>> [   11.210624] SGI XFS with ACLs, security attributes, no debug enabled
>>> [   11.220309] XFS (dm-0): Mounting V5 Filesystem
>>> [   11.344019] XFS (dm-0): Ending clean mount
>>> [   11.623060] systemd-journald[283]: Received SIGTERM from PID 1 (systemd).
>>> [   11.748757] systemd: 22 output lines suppressed due to ratelimiting
>>> [   11.815996] random: crng init done
>>> [   12.138825] SELinux: 32768 avtab hash slots, 104960 rules.
>>> [   12.152479] SELinux: 32768 avtab hash slots, 104960 rules.
>>> [   12.176042] SELinux:  8 users, 14 roles, 4986 types, 301 bools, 1 sens, 1024 cats
>>> [   12.176045] SELinux:  91 classes, 104960 rules
>>> [   12.179329] SELinux:  Permission validate_trans in class security not defined in policy.
>>> [   12.188368] SELinux:  Permission module_load in class system not defined in policy.
>>> [   12.196989] SELinux:  Class binder not defined in policy.
>>> [   12.203016] SELinux:  Class cap_userns not defined in policy.
>>> [   12.209420] SELinux:  Class cap2_userns not defined in policy.
>>> [   12.215930] SELinux:  Class sctp_socket not defined in policy.
>>> [   12.222440] SELinux:  Class icmp_socket not defined in policy.
>>> [   12.228952] SELinux:  Class ax25_socket not defined in policy.
>>> [   12.235461] SELinux:  Class ipx_socket not defined in policy.
>>> [   12.241876] SELinux:  Class netrom_socket not defined in policy.
>>> [   12.248580] SELinux:  Class atmpvc_socket not defined in policy.
>>> [   12.255286] SELinux:  Class x25_socket not defined in policy.
>>> [   12.261699] SELinux:  Class rose_socket not defined in policy.
>>> [   12.268208] SELinux:  Class decnet_socket not defined in policy.
>>> [   12.274913] SELinux:  Class atmsvc_socket not defined in policy.
>>> [   12.281619] SELinux:  Class rds_socket not defined in policy.
>>> [   12.288023] SELinux:  Class irda_socket not defined in policy.
>>> [   12.294536] SELinux:  Class pppox_socket not defined in policy.
>>> [   12.301140] SELinux:  Class llc_socket not defined in policy.
>>> [   12.307553] SELinux:  Class can_socket not defined in policy.
>>> [   12.313964] SELinux:  Class tipc_socket not defined in policy.
>>> [   12.320474] SELinux:  Class bluetooth_socket not defined in policy.
>>> [   12.327467] SELinux:  Class iucv_socket not defined in policy.
>>> [   12.333977] SELinux:  Class rxrpc_socket not defined in policy.
>>> [   12.340582] SELinux:  Class isdn_socket not defined in policy.
>>> [   12.347091] SELinux:  Class phonet_socket not defined in policy.
>>> [   12.353795] SELinux:  Class ieee802154_socket not defined in policy.
>>> [   12.360887] SELinux:  Class caif_socket not defined in policy.
>>> [   12.367396] SELinux:  Class alg_socket not defined in policy.
>>> [   12.373809] SELinux:  Class nfc_socket not defined in policy.
>>> [   12.380219] SELinux:  Class vsock_socket not defined in policy.
>>> [   12.386827] SELinux:  Class kcm_socket not defined in policy.
>>> [   12.393239] SELinux:  Class qipcrtr_socket not defined in policy.
>>> [   12.400040] SELinux:  Class smc_socket not defined in policy.
>>> [   12.406451] SELinux: the above unknown classes and permissions will be allowed
>>> [   12.414519] SELinux:  Completing initialization.
>>> [   12.414519] SELinux:  Setting up existing superblocks.
>>> [   12.427708] systemd[1]: Successfully loaded SELinux policy in 398.099ms.
>>> [   12.525046] systemd[1]: RTC configured in localtime, applying delta of -240 minutes to system time.
>>> [   12.750481] ip_tables: (C) 2000-2006 Netfilter Core Team
>>> [   12.756546] systemd[1]: Inserted module 'ip_tables'
>>> [   12.780763] systemd[1]: Relabelled /dev and /run in 18.031ms.
>>> [   14.420114] systemd-journald[727]: Received request to flush runtime journal from PID 1
>>> [   15.280936] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
>>> [   15.289348] i801_smbus 0000:06:00.3: Enabling SMBus device
>>> [   15.295493] i801_smbus 0000:06:00.3: SMBus using PCI interrupt
>>> [   15.306180] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
>>> [   15.334380] ioatdma: Intel(R) QuickData Technology Driver 4.00
>>> [   15.350112] igb 0000:04:00.0: DCA enabled
>>> [   15.354605] igb 0000:04:00.1: DCA enabled
>>> [   15.424542] mei_me 0000:00:16.0: Device doesn't have valid ME Interface
>>> [   15.432543] ipmi message handler version 39.2
>>> [   15.483128] ipmi device interface
>>> [   15.520269] IPMI System Interface driver.
>>> [   15.524806] ipmi_si: probing via SMBIOS
>>> [   15.529092] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
>>> [   15.535705] ipmi_si: Adding SMBIOS-specified kcs state machine
>>> [   15.542222] ipmi_si: probing via SPMI
>>> [   15.546314] ipmi_si: SPMI: io 0xca2 regsize 1 spacing 1 irq 0
>>> [   15.546315] ipmi_si: SPMI-specified kcs state machine: duplicate
>>> [   15.546316] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
>>> [   15.650165] ipmi_si ipmi_si.0: Found new BMC (man_id: 0x000157, prod_id: 0x005c, dev_id: 0x21)
>>> [   15.659907] ipmi_si ipmi_si.0: IPMI kcs interface initialized
>>> [   15.673054] input: PC Speaker as /devices/platform/pcspkr/input/input6
>>> [   15.737609] IPMI SSIF Interface driver
>>> [   15.806509] iTCO_vendor_support: vendor-support=0
>>> [   15.828195] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
>>> [   15.834466] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
>>> [   15.844640] wmi: Mapper loaded
>>> [   15.892261] sd 3:0:0:0: Attached scsi generic sg0 type 0
>>> [   16.119760] AVX version of gcm_enc/dec engaged.
>>> [   16.124819] AES CTR mode by8 optimization enabled
>>> [   16.168376] alg: No test for pcbc(aes) (pcbc-aes-aesni)
>>> [   16.685594] kvm: disabled by bios
>>> [   16.706605] kvm: disabled by bios
>>> [   16.731575] kvm: disabled by bios
>>> [   16.756565] kvm: disabled by bios
>>> [   16.781665] kvm: disabled by bios
>>> [   16.982839] XFS (sda1): Mounting V5 Filesystem
>>> [   17.228200] XFS (sda1): Ending clean mount
>>> [   17.271320] EDAC MC: Ver: 3.0.0
>>> [   17.397151] EDAC sbridge: Seeking for: PCI ID 8086:0ea0
>>> [   17.397163] EDAC sbridge: Seeking for: PCI ID 8086:0ea0
>>> [   17.397167] EDAC sbridge: Seeking for: PCI ID 8086:0ea0
>>> [   17.397169] EDAC sbridge: Seeking for: PCI ID 8086:0ea8
>>> [   17.397173] EDAC sbridge: Seeking for: PCI ID 8086:0ea8
>>> [   17.397177] EDAC sbridge: Seeking for: PCI ID 8086:0ea8
>>> [   17.397179] EDAC sbridge: Seeking for: PCI ID 8086:0e71
>>> [   17.397183] EDAC sbridge: Seeking for: PCI ID 8086:0e71
>>> [   17.397187] EDAC sbridge: Seeking for: PCI ID 8086:0e71
>>> [   17.397188] EDAC sbridge: Seeking for: PCI ID 8086:0eaa
>>> [   17.397193] EDAC sbridge: Seeking for: PCI ID 8086:0eaa
>>> [   17.397196] EDAC sbridge: Seeking for: PCI ID 8086:0eaa
>>> [   17.397198] EDAC s
> ...
>
> [Message clipped]
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
