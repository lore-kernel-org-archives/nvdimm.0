Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 32F0A21A0480F
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 21:08:46 -0700 (PDT)
Date: Sat, 8 Apr 2017 12:08:37 +0800
From: Baoquan He <bhe@redhat.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
Message-ID: <20170408040837.GD4111@x1>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, thgarnie@google.com, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 04/07/17 at 10:41am, Jeff Moyer wrote:
> Hi,
> 
> commit 021182e52fe01 ("x86/mm: Enable KASLR for physical mapping memory
> regions") causes some of my systems with persistent memory (whether real
> or emulated) to fail to boot with a couple of different crash
> signatures.  The first signature is a NMI watchdog lockup of all but 1
> cpu, which causes much difficulty in extracting useful information from
> the console.  The second variant is an invalid paging request, listed
> below.
> 
> On some systems, I haven't hit this problem at all.  Other systems
> experience a failed boot maybe 20-30% of the time.  To reproduce it,
> configure some emulated pmem on your system.  You can find directions
> for that here: https://nvdimm.wiki.kernel.org/

I got below problem when configure ndctl, didn't find a package named
libkmod:

~~~~~~~~~
configure: error: Package requirements (libkmod) were not met:

No package 'libkmod' found
> 
> Install ndctl (https://github.com/pmem/ndctl).
> Configure the namespace:
> # ndctl create-namespace -f -e namespace0.0 -m memory
> 
> Then just reboot several times (5 should be enough), and hopefully
> you'll hit the issue.
> 
> I've attached both my .config and the dmesg output from a successful
> boot at the end of this mail.
> 
> Cheers,
> Jeff
> 
> [    9.874109] pmem0: detected capacity change from 0 to 206158430208
> [    9.881652] BUG: unable to handle kernel paging request at ffff9406bfff0000
> [    9.889431] IP: memcpy_erms+0x6/0x10
> [    9.893422] PGD 0 
> [    9.893423] 
> [    9.897316] Oops: 0000 [#1] SMP
> [    9.900820] Modules linked in: isci mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt igb fb_sys_fops ahci libsas ttm ptp libahci crc32c_intel scsi_transport_sas nd_pmem pps_core nd_btt drm dca libata i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
> [    9.927322] CPU: 11 PID: 441 Comm: systemd-udevd Not tainted 4.11.0-rc5+ #1
> [    9.935092] Hardware name: Intel Corporation LH Pass/SVRBD-ROW_P, BIOS SE5C600.86B.02.01.SP06.050920141054 05/09/2014
> [    9.946934] task: ffff92dedae12b80 task.stack: ffffbaeb0783c000
> [    9.953539] RIP: 0010:memcpy_erms+0x6/0x10
> [    9.958108] RSP: 0018:ffffbaeb0783f9b8 EFLAGS: 00010286
> [    9.963939] RAX: ffff92e6dafef000 RBX: 0000000000000000 RCX: 0000000000001000
> [    9.971904] RDX: 0000000000001000 RSI: ffff9406bfff0000 RDI: ffff92e6dafef000
> [    9.979869] RBP: ffffbaeb0783fa38 R08: 0000000000000000 R09: 0000000017ffff80
> [    9.987831] R10: 0000000000000000 R11: ffff9406bfff0000 R12: ffff92d83bfaea98
> [    9.995794] R13: 0000002fffff0000 R14: 0000000000001000 R15: ffff92e6dafef000
> [   10.003759] FS:  00007fd4c2e618c0(0000) GS:ffff92e6de4c0000(0000) knlGS:0000000000000000
> [   10.012779] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   10.019192] CR2: ffff9406bfff0000 CR3: 000000081a05c000 CR4: 00000000001406e0
> [   10.027158] Call Trace:
> [   10.029891]  ? pmem_do_bvec+0x93/0x290 [nd_pmem]
> [   10.035046]  ? radix_tree_node_alloc.constprop.20+0x85/0xc0
> [   10.041263]  ? radix_tree_node_alloc.constprop.20+0x85/0xc0
> [   10.047481]  pmem_rw_page+0x3a/0x60 [nd_pmem]
> [   10.052343]  bdev_read_page+0x81/0xb0
> [   10.056431]  do_mpage_readpage+0x56f/0x770
> [   10.060991]  ? I_BDEV+0x20/0x20
> [   10.064500]  ? lru_cache_add+0xe/0x10
> [   10.068584]  mpage_readpages+0x148/0x1e0
> [   10.072958]  ? I_BDEV+0x20/0x20
> [   10.076462]  ? I_BDEV+0x20/0x20
> [   10.079969]  ? alloc_pages_current+0x88/0x120
> [   10.084830]  blkdev_readpages+0x1d/0x20
> [   10.089111]  __do_page_cache_readahead+0x1ce/0x2c0
> [   10.094456]  force_page_cache_readahead+0xa2/0x100
> [   10.099800]  page_cache_sync_readahead+0x3f/0x50
> [   10.104956]  generic_file_read_iter+0x60d/0x8c0
> [   10.110014]  ? cp_new_stat+0x14f/0x180
> [   10.114187]  blkdev_read_iter+0x37/0x40
> [   10.118469]  __vfs_read+0xe0/0x150
> [   10.122253]  vfs_read+0x8c/0x130
> [   10.125856]  SyS_read+0x55/0xc0
> [   10.129354]  entry_SYSCALL_64_fastpath+0x1a/0xa9
> [   10.134508] RIP: 0033:0x7fd4c1d9d480
> [   10.138487] RSP: 002b:00007fffa1f96e08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> [   10.146934] RAX: ffffffffffffffda RBX: 00007fffa1f968f0 RCX: 00007fd4c1d9d480
> [   10.154896] RDX: 0000000000000040 RSI: 0000559de3d6d978 RDI: 0000000000000008
> [   10.162859] RBP: 0000000000010300 R08: 0000000000000020 R09: 0000000000000068
> [   10.170820] R10: 00007fffa1f96b90 R11: 0000000000000246 R12: 0000000000000000
> [   10.178783] R13: 00007fffa1f97980 R14: 0000000000000000 R15: 0000000000000000
> [   10.186748] Code: ff 90 90 90 90 eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a4 c3 0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38 
> [   10.207813] RIP: memcpy_erms+0x6/0x10 RSP: ffffbaeb0783f9b8
> [   10.214022] CR2: ffff9406bfff0000
> [   10.217774] ---[ end trace 2ea6d4ce29040562 ]---
> [   10.265522] Kernel panic - not syncing: Fatal exception
> [   10.271381] Kernel Offset: 0x2a000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [   10.309968] ---[ end Kernel panic - not syncing: Fatal exception
> [   10.316682] ------------[ cut here ]------------
> 
> 

> [    0.000000] Linux version 4.11.0-rc5+ (root@intel-lizardhead-04.ml3.eng.bos.redhat.com) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-11) (GCC) ) #1 SMP Thu Apr 6 18:24:44 EDT 2017
> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.11.0-rc5+ root=/dev/mapper/rhel_intel--lizardhead--04-root ro memmap=192G!1024G crashkernel=auto rd.lvm.lv=rhel_intel-lizardhead-04/root rd.lvm.lv=rhel_intel-lizardhead-04/swap console=ttyS0,115200n81 LANG=en_US.UTF-8
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
> [    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
> [    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008ffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bad4afff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bad4b000-0x00000000baf8efff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000baf8f000-0x00000000bafc3fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bafc4000-0x00000000bafd8fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000bafd9000-0x00000000bb3d3fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bb3d4000-0x00000000bdd2efff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000bdd2f000-0x00000000bddcbfff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bddcc000-0x00000000bde9ffff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000bdea0000-0x00000000bdf2efff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bdf2f000-0x00000000bdfaafff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000bdfab000-0x00000000bdffffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000be000000-0x00000000cfffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed19000-0x00000000fed19fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ffa20000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000103fffffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000010000000000-0x0000012fffffffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] e820: user-defined physical RAM map:
> [    0.000000] user: [mem 0x0000000000000000-0x000000000008ffff] usable
> [    0.000000] user: [mem 0x0000000000090000-0x000000000009ffff] reserved
> [    0.000000] user: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] user: [mem 0x0000000000100000-0x00000000bad4afff] usable
> [    0.000000] user: [mem 0x00000000bad4b000-0x00000000baf8efff] reserved
> [    0.000000] user: [mem 0x00000000baf8f000-0x00000000bafc3fff] usable
> [    0.000000] user: [mem 0x00000000bafc4000-0x00000000bafd8fff] reserved
> [    0.000000] user: [mem 0x00000000bafd9000-0x00000000bb3d3fff] usable
> [    0.000000] user: [mem 0x00000000bb3d4000-0x00000000bdd2efff] reserved
> [    0.000000] user: [mem 0x00000000bdd2f000-0x00000000bddcbfff] ACPI NVS
> [    0.000000] user: [mem 0x00000000bddcc000-0x00000000bde9ffff] ACPI data
> [    0.000000] user: [mem 0x00000000bdea0000-0x00000000bdf2efff] ACPI NVS
> [    0.000000] user: [mem 0x00000000bdf2f000-0x00000000bdfaafff] ACPI data
> [    0.000000] user: [mem 0x00000000bdfab000-0x00000000bdffffff] usable
> [    0.000000] user: [mem 0x00000000be000000-0x00000000cfffffff] reserved
> [    0.000000] user: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] user: [mem 0x00000000fed19000-0x00000000fed19fff] reserved
> [    0.000000] user: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
> [    0.000000] user: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] user: [mem 0x00000000ffa20000-0x00000000ffffffff] reserved
> [    0.000000] user: [mem 0x0000000100000000-0x000000103fffffff] usable
> [    0.000000] user: [mem 0x0000010000000000-0x0000012fffffffff] persistent (type 12)
> [    0.000000] SMBIOS 2.6 present.
> [    0.000000] DMI: Intel Corporation LH Pass/SVRBD-ROW_P, BIOS SE5C600.86B.02.01.SP06.050920141054 05/09/2014
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x1040000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-D3FFF write-through
> [    0.000000]   D4000-E7FFF uncachable
> [    0.000000]   E8000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000000 mask 3F0000000000 write-back
> [    0.000000]   1 base 0000C0000000 mask 3FFFC0000000 uncachable
> [    0.000000]   2 base 010000000000 mask 3FE000000000 write-back
> [    0.000000]   3 base 012000000000 mask 3FF000000000 write-back
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
> [    0.000000] total RAM covered: 1244160M
> [    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 128K 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 256K 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 512K 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 1M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 2M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 4M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64K 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 128K 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 256K 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 512K 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 1M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 2M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 4M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128K 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256K 	chunk_size: 256K 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256K 	chunk_size: 512K 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256K 	chunk_size: 1M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256K 	chunk_size: 2M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256K 	chunk_size: 4M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256K 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256K 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256K 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256K 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256K 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256K 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256K 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256K 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256K 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512K 	chunk_size: 512K 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512K 	chunk_size: 1M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512K 	chunk_size: 2M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512K 	chunk_size: 4M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512K 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512K 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512K 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512K 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512K 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512K 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512K 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512K 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512K 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 1M 	chunk_size: 1M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 1M 	chunk_size: 2M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 1M 	chunk_size: 4M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 1M 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 1M 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 1M 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 1M 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 1M 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 1M 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 1M 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 1M 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 1M 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 2M 	chunk_size: 2M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 2M 	chunk_size: 4M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 2M 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 2M 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 2M 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 2M 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 2M 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 2M 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 2M 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 2M 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 2M 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 4M 	chunk_size: 4M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 4M 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 4M 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 4M 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 4M 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 4M 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 4M 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 4M 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 4M 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 4M 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 8M 	chunk_size: 8M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 8M 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 8M 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 8M 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 8M 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 8M 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 8M 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 8M 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 8M 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 16M 	chunk_size: 16M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 16M 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 16M 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 16M 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 16M 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 16M 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 16M 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 16M 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 32M 	chunk_size: 32M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 32M 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 32M 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 32M 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 32M 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 32M 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 32M 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64M 	chunk_size: 64M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64M 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64M 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64M 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64M 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 64M 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128M 	chunk_size: 128M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128M 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128M 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128M 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 128M 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256M 	chunk_size: 256M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256M 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256M 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 256M 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512M 	chunk_size: 512M 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512M 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 512M 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 1G 	chunk_size: 1G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 1G 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 192G
> [    0.000000]  gran_size: 2G 	chunk_size: 2G 	num_reg: 10  	lose cover RAM: 65G
> [    0.000000] mtrr_cleanup: can not find optimal value
> [    0.000000] please specify mtrr_gran_size/mtrr_chunk_size
> [    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
> [    0.000000] e820: last_pfn = 0xbe000 max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000fcd00-0x000fcd0f] mapped at [ffff9743400fcd00]
> [    0.000000] Base memory trampoline at [ffff97434008a000] 8a000 size 24576
> [    0.000000] Using GB pages for direct mapping
> [    0.000000] BRK [0x77a27f000, 0x77a27ffff] PGTABLE
> [    0.000000] BRK [0x77a280000, 0x77a280fff] PGTABLE
> [    0.000000] BRK [0x77a281000, 0x77a281fff] PGTABLE
> [    0.000000] BRK [0x77a282000, 0x77a282fff] PGTABLE
> [    0.000000] BRK [0x77a283000, 0x77a283fff] PGTABLE
> [    0.000000] BRK [0x77a284000, 0x77a284fff] PGTABLE
> [    0.000000] BRK [0x77a285000, 0x77a285fff] PGTABLE
> [    0.000000] BRK [0x77a286000, 0x77a286fff] PGTABLE
> [    0.000000] BRK [0x77a287000, 0x77a287fff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x3594b000-0x36c9dfff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
> [    0.000000] ACPI: XSDT 0x00000000BDFA8D98 0000C4 (v01 INTEL  S4600LH  06222004 INTL 20090903)
> [    0.000000] ACPI: FACP 0x00000000BDFA8918 0000F4 (v04 INTEL  S4600LH  06222004 INTL 20090903)
> [    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20170119/tbfadt-708)
> [    0.000000] ACPI: DSDT 0x00000000BDF92018 0148F1 (v02 INTEL  S4600LH  00000001 INTL 20100331)
> [    0.000000] ACPI: FACS 0x00000000BDFA8F40 000040
> [    0.000000] ACPI: APIC 0x00000000BDFA7018 000BAA (v03 INTEL  S4600LH  06222004 INTL 20090903)
> [    0.000000] ACPI: SPMI 0x00000000BDFAAA98 000041 (v05 INTEL  S4600LH  06222004 INTL 20090903)
> [    0.000000] ACPI: FPDT 0x00000000BDFAAA18 000044 (v01 INTEL  S4600LH  00000000      00000000)
> [    0.000000] ACPI: MCFG 0x00000000BDFAAF18 00003C (v01 INTEL  S4600LH  06222004 INTL 20090903)
> [    0.000000] ACPI: WDDT 0x00000000BDFAAE98 000040 (v01 INTEL  S4600LH  06222004 INTL 20090903)
> [    0.000000] ACPI: SRAT 0x00000000BDF8FC18 0001D0 (v03 INTEL  S4600LH  06222004 INTL 20090903)
> [    0.000000] ACPI: SLIT 0x00000000BDFAAE18 000030 (v01 INTEL  S4600LH  06222004 INTL 20090903)
> [    0.000000] ACPI: MSCT 0x00000000BDFA9D18 000090 (v01 INTEL  S4600LH  06222004 INTL 20090903)
> [    0.000000] ACPI: HPET 0x00000000BDFAAD98 000038 (v01 INTEL  S4600LH  06222004 INTL 20090903)
> [    0.000000] ACPI: SSDT 0x00000000BDDCC018 0D30C8 (v02 INTEL  S4600LH  00004000 INTL 20100331)
> [    0.000000] ACPI: BGRT 0x00000000BDFAAD18 000038 (v00 INTEL  S4600LH  06222004 AMI  00010013)
> [    0.000000] ACPI: HEST 0x00000000BDF91F18 0000A8 (v01 INTEL  S4600LH  00000001 INTL 00000001)
> [    0.000000] ACPI: BERT 0x00000000BDFAAB98 000030 (v01 INTEL  S4600LH  00000001 INTL 00000001)
> [    0.000000] ACPI: ERST 0x00000000BDF91C98 000230 (v01 INTEL  S4600LH  00000001 INTL 00000001)
> [    0.000000] ACPI: EINJ 0x00000000BDFA8798 000130 (v01 INTEL  S4600LH  00000001 INTL 00000001)
> [    0.000000] ACPI: SSDT 0x00000000BDF8D018 001729 (v02 INTEL  S4600LH  00000002 INTL 20100331)
> [    0.000000] ACPI: SSDT 0x00000000BDFAAC18 000045 (v02 INTEL  S4600LH  00000001 INTL 20100331)
> [    0.000000] ACPI: SSDT 0x00000000BDF8FA18 000181 (v02 INTEL  S4600LH  00000003 INTL 20100331)
> [    0.000000] ACPI: BGRT 0x00000000BDFAAC98 000038 (v00 INTEL  ROMLEY   06222004 AMI  00010013)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 0x0e -> Node 0
> [    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x2a -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x2c -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 0x2e -> Node 1
> [    0.000000] ACPI: SRAT: Node 0 PXM 0 [mem 0x00000000-0xbfffffff]
> [    0.000000] ACPI: SRAT: Node 0 PXM 0 [mem 0x100000000-0x83fffffff]
> [    0.000000] ACPI: SRAT: Node 1 PXM 1 [mem 0x840000000-0x103fffffff]
> [    0.000000] ACPI: SRAT: Node 2 PXM 5 [mem 0x10000000000-0x12fffffffff]
> [    0.000000] ACPI: SLIT table looks invalid. Not used.
> [    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x83fffffff] -> [mem 0x00000000-0x83fffffff]
> [    0.000000] NODE_DATA(0) allocated [mem 0x83ffd5000-0x83fffffff]
> [    0.000000] NODE_DATA(1) allocated [mem 0x103ffd5000-0x103fffffff]
> [    0.000000] kexec_core: crashkernel: memory value expected
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> [    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
> [    0.000000]   Normal   [mem 0x0000000100000000-0x000000103fffffff]
> [    0.000000]   Device   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000000001000-0x000000000008ffff]
> [    0.000000]   node   0: [mem 0x0000000000100000-0x00000000bad4afff]
> [    0.000000]   node   0: [mem 0x00000000baf8f000-0x00000000bafc3fff]
> [    0.000000]   node   0: [mem 0x00000000bafd9000-0x00000000bb3d3fff]
> [    0.000000]   node   0: [mem 0x00000000bdfab000-0x00000000bdffffff]
> [    0.000000]   node   0: [mem 0x0000000100000000-0x000000083fffffff]
> [    0.000000]   node   1: [mem 0x0000000840000000-0x000000103fffffff]
> [    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000083fffffff]
> [    0.000000] On node 0 totalpages: 8368479
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3983 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 11912 pages used for memmap
> [    0.000000]   DMA32 zone: 762320 pages, LIFO batch:31
> [    0.000000]   Normal zone: 118784 pages used for memmap
> [    0.000000]   Normal zone: 7602176 pages, LIFO batch:31
> [    0.000000] Initmem setup node 1 [mem 0x0000000840000000-0x000000103fffffff]
> [    0.000000] On node 1 totalpages: 8388608
> [    0.000000]   Normal zone: 131072 pages used for memmap
> [    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] IOAPIC[1]: apic_id 1, version 32, address 0xfec3f000, GSI 24-47
> [    0.000000] IOAPIC[2]: apic_id 2, version 32, address 0xfec7f000, GSI 48-71
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
> [    0.000000] efi: EFI_MEMMAP is not enabled.
> [    0.000000] efi: Failed to lookup EFI memory descriptor for 0x00000000b6da1018
> [    0.000000] smpboot: Allowing 136 CPUs, 120 hotplug CPUs
> [    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x00090000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbad4b000-0xbaf8efff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbafc4000-0xbafd8fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbb3d4000-0xbdd2efff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbdd2f000-0xbddcbfff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbddcc000-0xbde9ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbdea0000-0xbdf2efff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbdf2f000-0xbdfaafff]
> [    0.000000] PM: Registered nosave memory: [mem 0xbe000000-0xcfffffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfebfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed18fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed19000-0xfed19fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
> [    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffa1ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0xffa20000-0xffffffff]
> [    0.000000] e820: [mem 0xd0000000-0xfebfffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
> [    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:136 nr_cpu_ids:136 nr_node_ids:3
> [    0.000000] percpu: Embedded 38 pages/cpu @ffff974b5ec00000 s116120 r8192 d31336 u262144
> [    0.000000] pcpu-alloc: s116120 r8192 d31336 u262144 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007 
> [    0.000000] pcpu-alloc: [0] 016 018 020 022 024 026 028 030 
> [    0.000000] pcpu-alloc: [0] 032 034 036 038 040 042 044 046 
> [    0.000000] pcpu-alloc: [0] 048 050 052 054 056 058 060 062 
> [    0.000000] pcpu-alloc: [0] 064 066 068 070 072 074 076 078 
> [    0.000000] pcpu-alloc: [0] 080 082 084 086 088 090 092 094 
> [    0.000000] pcpu-alloc: [0] 096 098 100 102 104 106 108 110 
> [    0.000000] pcpu-alloc: [0] 112 114 116 118 120 122 124 126 
> [    0.000000] pcpu-alloc: [0] 128 130 132 134 --- --- --- --- 
> [    0.000000] pcpu-alloc: [1] 008 009 010 011 012 013 014 015 
> [    0.000000] pcpu-alloc: [1] 017 019 021 023 025 027 029 031 
> [    0.000000] pcpu-alloc: [1] 033 035 037 039 041 043 045 047 
> [    0.000000] pcpu-alloc: [1] 049 051 053 055 057 059 061 063 
> [    0.000000] pcpu-alloc: [1] 065 067 069 071 073 075 077 079 
> [    0.000000] pcpu-alloc: [1] 081 083 085 087 089 091 093 095 
> [    0.000000] pcpu-alloc: [1] 097 099 101 103 105 107 109 111 
> [    0.000000] pcpu-alloc: [1] 113 115 117 119 121 123 125 127 
> [    0.000000] pcpu-alloc: [1] 129 131 133 135 --- --- --- --- 
> [    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 16495234
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.11.0-rc5+ root=/dev/mapper/rhel_intel--lizardhead--04-root ro memmap=192G!1024G crashkernel=auto rd.lvm.lv=rhel_intel-lizardhead-04/root rd.lvm.lv=rhel_intel-lizardhead-04/swap console=ttyS0,115200n81 LANG=en_US.UTF-8
> [    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
> [    0.000000] log_buf_len total cpu_extra contributions: 552960 bytes
> [    0.000000] log_buf_len min size: 1048576 bytes
> [    0.000000] log_buf_len: 2097152 bytes
> [    0.000000] early log buf free: 1019588(97%)
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] Memory: 7173172K/67028348K available (7447K kernel code, 1577K rwdata, 3192K rodata, 2124K init, 2908K bss, 1177444K reserved, 0K cma-reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=136, Nodes=3
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	Build-time adjustment of leaf fanout to 64.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=136.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=136
> [    0.000000] NR_IRQS:524544 nr_irqs:2328 16
> [    0.000000] 	Offload RCU callbacks from all CPUs
> [    0.000000] 	Offload RCU callbacks from CPUs: 0-135.
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [ttyS0] enabled
> [    0.000000] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
> [    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.001000] tsc: Detected 2593.662 MHz processor
> [    0.002000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5187.32 BogoMIPS (lpj=2593662)
> [    0.003002] pid_max: default: 139264 minimum: 1088
> [    0.004052] ACPI: Core revision 20170119
> [    0.059868] ACPI: 5 ACPI AML tables successfully acquired and loaded
> [    0.061150] Security Framework initialized
> [    0.062003] SELinux:  Initializing.
> [    0.063011] SELinux:  Starting in permissive mode
> [    0.066456] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
> [    0.083875] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
> [    0.091529] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.092057] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.094772] CPU: Physical Processor ID: 0
> [    0.095003] CPU: Processor Core ID: 0
> [    0.096010] mce: CPU supports 25 MCE banks
> [    0.097020] CPU0: Thermal monitoring enabled (TM1)
> [    0.098048] process: using mwait in idle threads
> [    0.099005] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
> [    0.100002] Last level dTLB entries: 4KB 512, 2MB 0, 4MB 0, 1GB 4
> [    0.102433] Freeing SMP alternatives memory: 28K
> [    0.105004] ftrace: allocating 28759 entries in 113 pages
> [    0.113170] smpboot: Max logical packages: 17
> [    0.114151] x2apic: IRQ remapping doesn't support X2APIC mode
> [    0.115003] Switched APIC routing to physical flat.
> [    0.117188] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.127900] TSC deadline timer enabled
> [    0.127925] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-4620 v2 @ 2.60GHz (family: 0x6, model: 0x3e, stepping: 0x4)
> [    0.128245] Performance Events: PEBS fmt1+, IvyBridge events, 16-deep LBR, full-width counters, Intel PMU driver.
> [    0.129004] ... version:                3
> [    0.130001] ... bit width:              48
> [    0.131000] ... generic registers:      4
> [    0.132001] ... value mask:             0000ffffffffffff
> [    0.133001] ... max period:             00007fffffffffff
> [    0.134000] ... fixed-purpose events:   3
> [    0.135001] ... event mask:             000000070000000f
> [    0.142025] smp: Bringing up secondary CPUs ...
> [    0.146149] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> [    0.147149] x86: Booting SMP configuration:
> [    0.148002] .... node  #0, CPUs:          #1   #2   #3   #4   #5   #6   #7
> [    0.585002] .... node  #1, CPUs:     #8   #9  #10  #11  #12  #13  #14  #15
> [    1.081117] smp: Brought up 2 nodes, 16 CPUs
> [    1.083004] smpboot: Total of 16 processors activated (83093.10 BogoMIPS)
> [    1.086101] sched_clock: Marking stable (1086000000, 0)->(1385525935, -299525935)
> [    1.234930] node 0 initialised, 6939436 pages in 140ms
> [    1.250605] node 1 initialised, 7729995 pages in 155ms
> [    1.258571] devtmpfs: initialized
> [    1.262324] x86/mm: Memory block size: 2048MB
> [    1.269052] evm: security.selinux
> [    1.272752] evm: security.ima
> [    1.276054] evm: security.capability
> [    1.280185] PM: Registering ACPI NVS region [mem 0xbdd2f000-0xbddcbfff] (643072 bytes)
> [    1.289036] PM: Registering ACPI NVS region [mem 0xbdea0000-0xbdf2efff] (585728 bytes)
> [    1.298045] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
> [    1.309111] futex hash table entries: 65536 (order: 10, 4194304 bytes)
> [    1.317586] pinctrl core: initialized pinctrl subsystem
> [    1.324318] NET: Registered protocol family 16
> [    1.329562] cpuidle: using governor menu
> [    1.333940] PCCT header not found.
> [    1.337839] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    1.346290] ACPI: bus type PCI registered
> [    1.350757] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    1.358112] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
> [    1.368503] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
> [    1.376089] pmd_set_huge: Cannot satisfy [mem 0xc0000000-0xc0200000] with a huge-page mapping due to MTRR override.
> [    1.388177] PCI: Using configuration type 1 for base access
> [    1.399327] core: PMU erratum BJ122, BV98, HSD29 workaround disabled, HT off
> [    1.407226] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> [    1.416674] HugeTLB registered 1 GB page size, pre-allocated 0 pages
> [    1.423772] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    1.432053] ACPI: Added _OSI(Module Device)
> [    1.436721] ACPI: Added _OSI(Processor Device)
> [    1.441680] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    1.446929] ACPI: Added _OSI(Processor Aggregator Device)
> [    1.453108] ACPI: Executed 1 blocks of module-level executable AML code
> [    1.571927] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
> [    1.588206] ACPI: Interpreter enabled
> [    1.592309] ACPI: (supports S0 S1 S5)
> [    1.596394] ACPI: Using IOAPIC for interrupt routing
> [    1.601984] HEST: Table parsing has been initialized.
> [    1.607623] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    1.641056] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
> [    1.647958] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    1.657203] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME AER]
> [    1.665757] acpi PNP0A08:00: _OSC: OS now controls [PCIeCapability]
> [    1.672753] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
> [    1.682003] acpi PNP0A08:00: host bridge window expanded to [io  0x0000-0xbfff]; [io  0x0000-0xbfff window] ignored
> [    1.693656] acpi PNP0A08:00: ignoring host bridge window [mem 0x000d0000-0x000d3fff window] (conflicts with Adapter ROM [mem 0x000c8000-0x000d19ff])
> [    1.708688] PCI host bridge to bus 0000:00
> [    1.713261] pci_bus 0000:00: root bus resource [io  0x0000-0xbfff]
> [    1.720157] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
> [    1.728509] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff window]
> [    1.736862] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff window]
> [    1.745213] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff window]
> [    1.753568] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff window]
> [    1.761918] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
> [    1.770273] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
> [    1.778623] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
> [    1.786973] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff window]
> [    1.795324] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff window]
> [    1.803675] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff window]
> [    1.812026] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff window]
> [    1.820376] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff window]
> [    1.828726] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xebffffff window]
> [    1.837086] pci_bus 0000:00: root bus resource [mem 0x380000000000-0x38007fffffff window]
> [    1.846222] pci_bus 0000:00: root bus resource [bus 00-7e]
> [    1.852355] pci 0000:00:00.0: [8086:0e00] type 00 class 0x060000
> [    1.852431] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
> [    1.852513] pci 0000:00:01.0: [8086:0e02] type 01 class 0x060400
> [    1.852581] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    1.852641] pci 0000:00:01.0: System wakeup disabled by ACPI
> [    1.858979] pci 0000:00:02.0: [8086:0e04] type 01 class 0x060400
> [    1.859049] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
> [    1.859105] pci 0000:00:02.0: System wakeup disabled by ACPI
> [    1.865449] pci 0000:00:03.0: [8086:0e08] type 01 class 0x060400
> [    1.865520] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
> [    1.865576] pci 0000:00:03.0: System wakeup disabled by ACPI
> [    1.871922] pci 0000:00:03.2: [8086:0e0a] type 01 class 0x060400
> [    1.871991] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
> [    1.872049] pci 0000:00:03.2: System wakeup disabled by ACPI
> [    1.878400] pci 0000:00:04.0: [8086:0e20] type 00 class 0x088000
> [    1.878415] pci 0000:00:04.0: reg 0x10: [mem 0x38007ff90000-0x38007ff93fff 64bit]
> [    1.878535] pci 0000:00:04.1: [8086:0e21] type 00 class 0x088000
> [    1.878549] pci 0000:00:04.1: reg 0x10: [mem 0x38007ff80000-0x38007ff83fff 64bit]
> [    1.878666] pci 0000:00:04.2: [8086:0e22] type 00 class 0x088000
> [    1.878680] pci 0000:00:04.2: reg 0x10: [mem 0x38007ff70000-0x38007ff73fff 64bit]
> [    1.878800] pci 0000:00:04.3: [8086:0e23] type 00 class 0x088000
> [    1.878813] pci 0000:00:04.3: reg 0x10: [mem 0x38007ff60000-0x38007ff63fff 64bit]
> [    1.878929] pci 0000:00:04.4: [8086:0e24] type 00 class 0x088000
> [    1.878943] pci 0000:00:04.4: reg 0x10: [mem 0x38007ff50000-0x38007ff53fff 64bit]
> [    1.879061] pci 0000:00:04.5: [8086:0e25] type 00 class 0x088000
> [    1.879075] pci 0000:00:04.5: reg 0x10: [mem 0x38007ff40000-0x38007ff43fff 64bit]
> [    1.879192] pci 0000:00:04.6: [8086:0e26] type 00 class 0x088000
> [    1.879206] pci 0000:00:04.6: reg 0x10: [mem 0x38007ff30000-0x38007ff33fff 64bit]
> [    1.879322] pci 0000:00:04.7: [8086:0e27] type 00 class 0x088000
> [    1.879336] pci 0000:00:04.7: reg 0x10: [mem 0x38007ff20000-0x38007ff23fff 64bit]
> [    1.879466] pci 0000:00:05.0: [8086:0e28] type 00 class 0x088000
> [    1.879575] pci 0000:00:05.1: [8086:0e29] type 00 class 0x088000
> [    1.879702] pci 0000:00:05.2: [8086:0e2a] type 00 class 0x088000
> [    1.879811] pci 0000:00:05.4: [8086:0e2c] type 00 class 0x080020
> [    1.879821] pci 0000:00:05.4: reg 0x10: [mem 0xd0b60000-0xd0b60fff]
> [    1.879950] pci 0000:00:11.0: [8086:1d3e] type 01 class 0x060400
> [    1.880042] pci 0000:00:11.0: PME# supported from D0 D3hot D3cold
> [    1.880131] pci 0000:00:16.0: [8086:1d3a] type 00 class 0x078000
> [    1.880148] pci 0000:00:16.0: reg 0x10: [mem 0xd0b50000-0xd0b5000f 64bit]
> [    1.880208] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    1.880278] pci 0000:00:16.1: [8086:1d3b] type 00 class 0x078000
> [    1.880295] pci 0000:00:16.1: reg 0x10: [mem 0xd0b40000-0xd0b4000f 64bit]
> [    1.880355] pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
> [    1.880437] pci 0000:00:1a.0: [8086:1d2d] type 00 class 0x0c0320
> [    1.880454] pci 0000:00:1a.0: reg 0x10: [mem 0xd0b20000-0xd0b203ff]
> [    1.880534] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    1.880598] pci 0000:00:1a.0: System wakeup disabled by ACPI
> [    1.886949] pci 0000:00:1c.0: [8086:1d10] type 01 class 0x060400
> [    1.887076] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    1.887132] pci 0000:00:1c.0: System wakeup disabled by ACPI
> [    1.893493] pci 0000:00:1c.7: [8086:1d1e] type 01 class 0x060400
> [    1.893568] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
> [    1.893616] pci 0000:00:1c.7: System wakeup disabled by ACPI
> [    1.899958] pci 0000:00:1d.0: [8086:1d26] type 00 class 0x0c0320
> [    1.899975] pci 0000:00:1d.0: reg 0x10: [mem 0xd0b10000-0xd0b103ff]
> [    1.900055] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    1.900116] pci 0000:00:1d.0: System wakeup disabled by ACPI
> [    1.906463] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
> [    1.906548] pci 0000:00:1e.0: System wakeup disabled by ACPI
> [    1.912888] pci 0000:00:1f.0: [8086:1d41] type 00 class 0x060100
> [    1.913053] pci 0000:00:1f.2: [8086:1d02] type 00 class 0x010601
> [    1.913067] pci 0000:00:1f.2: reg 0x10: [io  0x3070-0x3077]
> [    1.913074] pci 0000:00:1f.2: reg 0x14: [io  0x3060-0x3063]
> [    1.913081] pci 0000:00:1f.2: reg 0x18: [io  0x3050-0x3057]
> [    1.913087] pci 0000:00:1f.2: reg 0x1c: [io  0x3040-0x3043]
> [    1.913094] pci 0000:00:1f.2: reg 0x20: [io  0x3020-0x303f]
> [    1.913101] pci 0000:00:1f.2: reg 0x24: [mem 0xd0b00000-0xd0b007ff]
> [    1.913140] pci 0000:00:1f.2: PME# supported from D3hot
> [    1.913207] pci 0000:00:1f.3: [8086:1d22] type 00 class 0x0c0500
> [    1.913221] pci 0000:00:1f.3: reg 0x10: [mem 0x38007ff10000-0x38007ff100ff 64bit]
> [    1.913240] pci 0000:00:1f.3: reg 0x20: [io  0x3000-0x301f]
> [    1.913357] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    1.918992] pci 0000:00:02.0: PCI bridge to [bus 02]
> [    1.924620] pci 0000:00:03.0: PCI bridge to [bus 03]
> [    1.930265] pci 0000:04:00.0: [8086:1521] type 00 class 0x020000
> [    1.930276] pci 0000:04:00.0: reg 0x10: [mem 0xd0a20000-0xd0a3ffff]
> [    1.930288] pci 0000:04:00.0: reg 0x18: [io  0x2020-0x203f]
> [    1.930295] pci 0000:04:00.0: reg 0x1c: [mem 0xd0a50000-0xd0a53fff]
> [    1.930361] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
> [    1.930386] pci 0000:04:00.0: reg 0x184: [mem 0x38007fe60000-0x38007fe63fff 64bit pref]
> [    1.930388] pci 0000:04:00.0: VF(n) BAR0 space: [mem 0x38007fe60000-0x38007fe7ffff 64bit pref] (contains BAR0 for 8 VFs)
> [    1.942535] pci 0000:04:00.0: reg 0x190: [mem 0x38007fe40000-0x38007fe43fff 64bit pref]
> [    1.942536] pci 0000:04:00.0: VF(n) BAR3 space: [mem 0x38007fe40000-0x38007fe5ffff 64bit pref] (contains BAR3 for 8 VFs)
> [    1.954760] pci 0000:04:00.1: [8086:1521] type 00 class 0x020000
> [    1.954771] pci 0000:04:00.1: reg 0x10: [mem 0xd0a00000-0xd0a1ffff]
> [    1.954783] pci 0000:04:00.1: reg 0x18: [io  0x2000-0x201f]
> [    1.954790] pci 0000:04:00.1: reg 0x1c: [mem 0xd0a40000-0xd0a43fff]
> [    1.954853] pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
> [    1.954876] pci 0000:04:00.1: reg 0x184: [mem 0x38007fe20000-0x38007fe23fff 64bit pref]
> [    1.954877] pci 0000:04:00.1: VF(n) BAR0 space: [mem 0x38007fe20000-0x38007fe3ffff 64bit pref] (contains BAR0 for 8 VFs)
> [    1.967022] pci 0000:04:00.1: reg 0x190: [mem 0x38007fe00000-0x38007fe03fff 64bit pref]
> [    1.967023] pci 0000:04:00.1: VF(n) BAR3 space: [mem 0x38007fe00000-0x38007fe1ffff 64bit pref] (contains BAR3 for 8 VFs)
> [    1.982216] pci 0000:00:03.2: PCI bridge to [bus 04-05]
> [    1.988048] pci 0000:00:03.2:   bridge window [io  0x2000-0x2fff]
> [    1.988051] pci 0000:00:03.2:   bridge window [mem 0xd0a00000-0xd0afffff]
> [    1.988056] pci 0000:00:03.2:   bridge window [mem 0x38007fe00000-0x38007fefffff 64bit pref]
> [    1.988120] pci 0000:06:00.0: [8086:1d6b] type 00 class 0x010700
> [    1.988140] pci 0000:06:00.0: reg 0x10: [mem 0x38007fc00000-0x38007fc03fff 64bit pref]
> [    1.988155] pci 0000:06:00.0: reg 0x18: [mem 0x38007f800000-0x38007fbfffff 64bit pref]
> [    1.988165] pci 0000:06:00.0: reg 0x20: [io  0x1000-0x10ff]
> [    1.988274] pci 0000:06:00.0: reg 0x164: [mem 0x38007fc10000-0x38007fc13fff 64bit pref]
> [    1.988276] pci 0000:06:00.0: VF(n) BAR0 space: [mem 0x38007fc10000-0x38007fc8bfff 64bit pref] (contains BAR0 for 31 VFs)
> [    2.000673] pci 0000:06:00.3: [8086:1d70] type 00 class 0x0c0500
> [    2.000690] pci 0000:06:00.3: reg 0x10: [mem 0xd0900000-0xd0900fff]
> [    2.000730] pci 0000:06:00.3: reg 0x20: [io  0x1100-0x111f]
> [    2.000805] pci 0000:06:00.3: PME# supported from D0 D3hot D3cold
> [    2.000890] pci 0000:00:11.0: PCI bridge to [bus 06]
> [    2.006425] pci 0000:00:11.0:   bridge window [io  0x1000-0x1fff]
> [    2.006429] pci 0000:00:11.0:   bridge window [mem 0xd0900000-0xd09fffff]
> [    2.006438] pci 0000:00:11.0:   bridge window [mem 0x38007f800000-0x38007fcfffff 64bit pref]
> [    2.006504] pci 0000:00:1c.0: PCI bridge to [bus 07]
> [    2.012125] pci 0000:08:00.0: [102b:0522] type 00 class 0x030000
> [    2.012152] pci 0000:08:00.0: reg 0x10: [mem 0xea000000-0xeaffffff pref]
> [    2.012171] pci 0000:08:00.0: reg 0x14: [mem 0xd0810000-0xd0813fff]
> [    2.012187] pci 0000:08:00.0: reg 0x18: [mem 0xd0000000-0xd07fffff]
> [    2.012248] pci 0000:08:00.0: reg 0x30: [mem 0xd0800000-0xd080ffff pref]
> [    2.012356] pci 0000:08:00.0: System wakeup disabled by ACPI
> [    2.018708] pci 0000:00:1c.7: PCI bridge to [bus 08]
> [    2.024246] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd08fffff]
> [    2.024251] pci 0000:00:1c.7:   bridge window [mem 0xea000000-0xeaffffff 64bit pref]
> [    2.024314] pci 0000:00:1e.0: PCI bridge to [bus 09] (subtractive decode)
> [    2.031897] pci 0000:00:1e.0:   bridge window [io  0x0000-0xbfff] (subtractive decode)
> [    2.031901] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
> [    2.031902] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000c3fff window] (subtractive decode)
> [    2.031903] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000c7fff window] (subtractive decode)
> [    2.031905] pci 0000:00:1e.0:   bridge window [mem 0x000c8000-0x000cbfff window] (subtractive decode)
> [    2.031906] pci 0000:00:1e.0:   bridge window [mem 0x000cc000-0x000cffff window] (subtractive decode)
> [    2.031906] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff window] (subtractive decode)
> [    2.031908] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff window] (subtractive decode)
> [    2.031909] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff window] (subtractive decode)
> [    2.031910] pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff window] (subtractive decode)
> [    2.031911] pci 0000:00:1e.0:   bridge window [mem 0x000e4000-0x000e7fff window] (subtractive decode)
> [    2.031913] pci 0000:00:1e.0:   bridge window [mem 0x000e8000-0x000ebfff window] (subtractive decode)
> [    2.031914] pci 0000:00:1e.0:   bridge window [mem 0x000ec000-0x000effff window] (subtractive decode)
> [    2.031915] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff window] (subtractive decode)
> [    2.031916] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xebffffff window] (subtractive decode)
> [    2.031917] pci 0000:00:1e.0:   bridge window [mem 0x380000000000-0x38007fffffff window] (subtractive decode)
> [    2.031965] pci_bus 0000:00: on NUMA node 0
> [    2.032525] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
> [    2.040245] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
> [    2.047954] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 10 11 12 14 15)
> [    2.055669] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
> [    2.063384] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
> [    2.071099] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 15)
> [    2.078814] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *10 11 12 14 15)
> [    2.086527] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
> [    2.094332] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-fe])
> [    2.101232] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    2.110474] acpi PNP0A08:01: _OSC: platform does not support [PCIeHotplug PME AER]
> [    2.119027] acpi PNP0A08:01: _OSC: OS now controls [PCIeCapability]
> [    2.126022] acpi PNP0A08:01: FADT indicates ASPM is unsupported, using BIOS configuration
> [    2.135327] PCI host bridge to bus 0000:80
> [    2.139901] pci_bus 0000:80: root bus resource [io  0x03b0-0x03df window]
> [    2.147476] pci_bus 0000:80: root bus resource [io  0xc000-0xffff window]
> [    2.155054] pci_bus 0000:80: root bus resource [mem 0x000a0000-0x000bffff window]
> [    2.163407] pci_bus 0000:80: root bus resource [mem 0xec000000-0xfbffffff window]
> [    2.171760] pci_bus 0000:80: root bus resource [mem 0x380080000000-0x3800ffffffff window]
> [    2.180891] pci_bus 0000:80: root bus resource [bus 80-fe]
> [    2.187027] pci 0000:80:01.0: [8086:0e02] type 01 class 0x060400
> [    2.187107] pci 0000:80:01.0: PME# supported from D0 D3hot D3cold
> [    2.187148] pci 0000:80:01.0: System wakeup disabled by ACPI
> [    2.193502] pci 0000:80:02.0: [8086:0e04] type 01 class 0x060400
> [    2.193581] pci 0000:80:02.0: PME# supported from D0 D3hot D3cold
> [    2.193624] pci 0000:80:02.0: System wakeup disabled by ACPI
> [    2.199971] pci 0000:80:04.0: [8086:0e20] type 00 class 0x088000
> [    2.199996] pci 0000:80:04.0: reg 0x10: [mem 0x3800fff70000-0x3800fff73fff 64bit]
> [    2.200118] pci 0000:80:04.1: [8086:0e21] type 00 class 0x088000
> [    2.200133] pci 0000:80:04.1: reg 0x10: [mem 0x3800fff60000-0x3800fff63fff 64bit]
> [    2.200244] pci 0000:80:04.2: [8086:0e22] type 00 class 0x088000
> [    2.200259] pci 0000:80:04.2: reg 0x10: [mem 0x3800fff50000-0x3800fff53fff 64bit]
> [    2.200372] pci 0000:80:04.3: [8086:0e23] type 00 class 0x088000
> [    2.200387] pci 0000:80:04.3: reg 0x10: [mem 0x3800fff40000-0x3800fff43fff 64bit]
> [    2.200497] pci 0000:80:04.4: [8086:0e24] type 00 class 0x088000
> [    2.200513] pci 0000:80:04.4: reg 0x10: [mem 0x3800fff30000-0x3800fff33fff 64bit]
> [    2.200627] pci 0000:80:04.5: [8086:0e25] type 00 class 0x088000
> [    2.200642] pci 0000:80:04.5: reg 0x10: [mem 0x3800fff20000-0x3800fff23fff 64bit]
> [    2.200752] pci 0000:80:04.6: [8086:0e26] type 00 class 0x088000
> [    2.200767] pci 0000:80:04.6: reg 0x10: [mem 0x3800fff10000-0x3800fff13fff 64bit]
> [    2.200879] pci 0000:80:04.7: [8086:0e27] type 00 class 0x088000
> [    2.200894] pci 0000:80:04.7: reg 0x10: [mem 0x3800fff00000-0x3800fff03fff 64bit]
> [    2.201005] pci 0000:80:05.0: [8086:0e28] type 00 class 0x088000
> [    2.201111] pci 0000:80:05.1: [8086:0e29] type 00 class 0x088000
> [    2.201231] pci 0000:80:05.2: [8086:0e2a] type 00 class 0x088000
> [    2.201332] pci 0000:80:05.4: [8086:0e2c] type 00 class 0x080020
> [    2.201343] pci 0000:80:05.4: reg 0x10: [mem 0xec000000-0xec000fff]
> [    2.201503] pci 0000:80:01.0: PCI bridge to [bus 81]
> [    2.207150] pci 0000:80:02.0: PCI bridge to [bus 82]
> [    2.212713] pci_bus 0000:80: on NUMA node 1
> [    2.215937] ACPI: PCI Root Bridge [UCR0] (domain 0000 [bus 7f])
> [    2.222548] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    2.231699] acpi PNP0A03:00: _OSC: platform does not support [PCIeHotplug PME AER]
> [    2.240171] acpi PNP0A03:00: _OSC: OS now controls [PCIeCapability]
> [    2.247166] acpi PNP0A03:00: FADT indicates ASPM is unsupported, using BIOS configuration
> [    2.256344] PCI host bridge to bus 0000:7f
> [    2.260915] pci_bus 0000:7f: root bus resource [bus 7f]
> [    2.266752] pci 0000:7f:08.0: [8086:0e80] type 00 class 0x088000
> [    2.266802] pci 0000:7f:09.0: [8086:0e90] type 00 class 0x088000
> [    2.266846] pci 0000:7f:0a.0: [8086:0ec0] type 00 class 0x088000
> [    2.266883] pci 0000:7f:0a.1: [8086:0ec1] type 00 class 0x088000
> [    2.266922] pci 0000:7f:0a.2: [8086:0ec2] type 00 class 0x088000
> [    2.266957] pci 0000:7f:0a.3: [8086:0ec3] type 00 class 0x088000
> [    2.266997] pci 0000:7f:0b.0: [8086:0e1e] type 00 class 0x088000
> [    2.267032] pci 0000:7f:0b.3: [8086:0e1f] type 00 class 0x088000
> [    2.267070] pci 0000:7f:0c.0: [8086:0ee0] type 00 class 0x088000
> [    2.267105] pci 0000:7f:0c.1: [8086:0ee2] type 00 class 0x088000
> [    2.267141] pci 0000:7f:0c.2: [8086:0ee4] type 00 class 0x088000
> [    2.267179] pci 0000:7f:0c.3: [8086:0ee6] type 00 class 0x088000
> [    2.267216] pci 0000:7f:0d.0: [8086:0ee1] type 00 class 0x088000
> [    2.267253] pci 0000:7f:0d.1: [8086:0ee3] type 00 class 0x088000
> [    2.267287] pci 0000:7f:0d.2: [8086:0ee5] type 00 class 0x088000
> [    2.267324] pci 0000:7f:0d.3: [8086:0ee7] type 00 class 0x088000
> [    2.267360] pci 0000:7f:0e.0: [8086:0ea0] type 00 class 0x088000
> [    2.267402] pci 0000:7f:0e.1: [8086:0e30] type 00 class 0x110100
> [    2.267445] pci 0000:7f:0f.0: [8086:0ea8] type 00 class 0x088000
> [    2.267499] pci 0000:7f:0f.1: [8086:0e71] type 00 class 0x088000
> [    2.267550] pci 0000:7f:0f.2: [8086:0eaa] type 00 class 0x088000
> [    2.267603] pci 0000:7f:0f.3: [8086:0eab] type 00 class 0x088000
> [    2.267654] pci 0000:7f:0f.4: [8086:0eac] type 00 class 0x088000
> [    2.267705] pci 0000:7f:0f.5: [8086:0ead] type 00 class 0x088000
> [    2.267762] pci 0000:7f:10.0: [8086:0eb0] type 00 class 0x088000
> [    2.267816] pci 0000:7f:10.1: [8086:0eb1] type 00 class 0x088000
> [    2.267870] pci 0000:7f:10.2: [8086:0eb2] type 00 class 0x088000
> [    2.267921] pci 0000:7f:10.3: [8086:0eb3] type 00 class 0x088000
> [    2.267973] pci 0000:7f:10.4: [8086:0eb4] type 00 class 0x088000
> [    2.268025] pci 0000:7f:10.5: [8086:0eb5] type 00 class 0x088000
> [    2.268078] pci 0000:7f:10.6: [8086:0eb6] type 00 class 0x088000
> [    2.268131] pci 0000:7f:10.7: [8086:0eb7] type 00 class 0x088000
> [    2.268187] pci 0000:7f:13.0: [8086:0e1d] type 00 class 0x088000
> [    2.268222] pci 0000:7f:13.1: [8086:0e34] type 00 class 0x110100
> [    2.268258] pci 0000:7f:13.4: [8086:0e81] type 00 class 0x088000
> [    2.268296] pci 0000:7f:13.5: [8086:0e36] type 00 class 0x110100
> [    2.268331] pci 0000:7f:13.6: [8086:0e37] type 00 class 0x110100
> [    2.268370] pci 0000:7f:16.0: [8086:0ec8] type 00 class 0x088000
> [    2.268405] pci 0000:7f:16.1: [8086:0ec9] type 00 class 0x088000
> [    2.268442] pci 0000:7f:16.2: [8086:0eca] type 00 class 0x088000
> [    2.268532] ACPI: PCI Root Bridge [UCR1] (domain 0000 [bus ff])
> [    2.275142] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    2.284295] acpi PNP0A03:01: _OSC: platform does not support [PCIeHotplug PME AER]
> [    2.292767] acpi PNP0A03:01: _OSC: OS now controls [PCIeCapability]
> [    2.299763] acpi PNP0A03:01: FADT indicates ASPM is unsupported, using BIOS configuration
> [    2.308942] PCI host bridge to bus 0000:ff
> [    2.313515] pci_bus 0000:ff: root bus resource [bus ff]
> [    2.319343] pci 0000:ff:08.0: [8086:0e80] type 00 class 0x088000
> [    2.319398] pci 0000:ff:09.0: [8086:0e90] type 00 class 0x088000
> [    2.319446] pci 0000:ff:0a.0: [8086:0ec0] type 00 class 0x088000
> [    2.319491] pci 0000:ff:0a.1: [8086:0ec1] type 00 class 0x088000
> [    2.319533] pci 0000:ff:0a.2: [8086:0ec2] type 00 class 0x088000
> [    2.319577] pci 0000:ff:0a.3: [8086:0ec3] type 00 class 0x088000
> [    2.319621] pci 0000:ff:0b.0: [8086:0e1e] type 00 class 0x088000
> [    2.319664] pci 0000:ff:0b.3: [8086:0e1f] type 00 class 0x088000
> [    2.319704] pci 0000:ff:0c.0: [8086:0ee0] type 00 class 0x088000
> [    2.319750] pci 0000:ff:0c.1: [8086:0ee2] type 00 class 0x088000
> [    2.319791] pci 0000:ff:0c.2: [8086:0ee4] type 00 class 0x088000
> [    2.319835] pci 0000:ff:0c.3: [8086:0ee6] type 00 class 0x088000
> [    2.319878] pci 0000:ff:0d.0: [8086:0ee1] type 00 class 0x088000
> [    2.319919] pci 0000:ff:0d.1: [8086:0ee3] type 00 class 0x088000
> [    2.319963] pci 0000:ff:0d.2: [8086:0ee5] type 00 class 0x088000
> [    2.320004] pci 0000:ff:0d.3: [8086:0ee7] type 00 class 0x088000
> [    2.320049] pci 0000:ff:0e.0: [8086:0ea0] type 00 class 0x088000
> [    2.320100] pci 0000:ff:0e.1: [8086:0e30] type 00 class 0x110100
> [    2.320157] pci 0000:ff:0f.0: [8086:0ea8] type 00 class 0x088000
> [    2.320231] pci 0000:ff:0f.1: [8086:0e71] type 00 class 0x088000
> [    2.320299] pci 0000:ff:0f.2: [8086:0eaa] type 00 class 0x088000
> [    2.320362] pci 0000:ff:0f.3: [8086:0eab] type 00 class 0x088000
> [    2.320426] pci 0000:ff:0f.4: [8086:0eac] type 00 class 0x088000
> [    2.320491] pci 0000:ff:0f.5: [8086:0ead] type 00 class 0x088000
> [    2.320555] pci 0000:ff:10.0: [8086:0eb0] type 00 class 0x088000
> [    2.320620] pci 0000:ff:10.1: [8086:0eb1] type 00 class 0x088000
> [    2.320682] pci 0000:ff:10.2: [8086:0eb2] type 00 class 0x088000
> [    2.320744] pci 0000:ff:10.3: [8086:0eb3] type 00 class 0x088000
> [    2.320804] pci 0000:ff:10.4: [8086:0eb4] type 00 class 0x088000
> [    2.320866] pci 0000:ff:10.5: [8086:0eb5] type 00 class 0x088000
> [    2.320926] pci 0000:ff:10.6: [8086:0eb6] type 00 class 0x088000
> [    2.320989] pci 0000:ff:10.7: [8086:0eb7] type 00 class 0x088000
> [    2.321048] pci 0000:ff:13.0: [8086:0e1d] type 00 class 0x088000
> [    2.321092] pci 0000:ff:13.1: [8086:0e34] type 00 class 0x110100
> [    2.321134] pci 0000:ff:13.4: [8086:0e81] type 00 class 0x088000
> [    2.321178] pci 0000:ff:13.5: [8086:0e36] type 00 class 0x110100
> [    2.321229] pci 0000:ff:13.6: [8086:0e37] type 00 class 0x110100
> [    2.321278] pci 0000:ff:16.0: [8086:0ec8] type 00 class 0x088000
> [    2.321321] pci 0000:ff:16.1: [8086:0ec9] type 00 class 0x088000
> [    2.321364] pci 0000:ff:16.2: [8086:0eca] type 00 class 0x088000
> [    2.321539] ACPI: Enabled 6 GPEs in block 00 to 3F
> [    2.327138] pci 0000:08:00.0: vgaarb: setting as boot VGA device
> [    2.333842] pci 0000:08:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
> [    2.343375] pci 0000:08:00.0: vgaarb: bridge control possible
> [    2.349786] vgaarb: loaded
> [    2.352928] SCSI subsystem initialized
> [    2.357137] ACPI: bus type USB registered
> [    2.361625] usbcore: registered new interface driver usbfs
> [    2.367752] usbcore: registered new interface driver hub
> [    2.373811] usbcore: registered new device driver usb
> [    2.379737] PCI: Using ACPI for IRQ routing
> [    2.388858] PCI: pci_cache_line_size set to 64 bytes
> [    2.389041] e820: reserve RAM buffer [mem 0xbad4b000-0xbbffffff]
> [    2.389042] e820: reserve RAM buffer [mem 0xbafc4000-0xbbffffff]
> [    2.389043] e820: reserve RAM buffer [mem 0xbb3d4000-0xbbffffff]
> [    2.389044] e820: reserve RAM buffer [mem 0xbe000000-0xbfffffff]
> [    2.389194] NetLabel: Initializing
> [    2.392990] NetLabel:  domain hash size = 128
> [    2.397851] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
> [    2.404185] NetLabel:  unlabeled traffic allowed by default
> [    2.410621] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    2.417526] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    2.426158] clocksource: Switched to clocksource hpet
> [    2.443509] VFS: Disk quotas dquot_6.6.0
> [    2.447981] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    2.455845] pnp: PnP ACPI init
> [    2.459561] system 00:00: [io  0x0680-0x069f] has been reserved
> [    2.466177] system 00:00: [io  0xffff] has been reserved
> [    2.472113] system 00:00: [io  0xffff] has been reserved
> [    2.478046] system 00:00: [io  0xffff] has been reserved
> [    2.483981] system 00:00: [io  0x0400-0x0453] has been reserved
> [    2.490592] system 00:00: [io  0x0458-0x047f] has been reserved
> [    2.497201] system 00:00: [io  0x0500-0x057f] has been reserved
> [    2.503811] system 00:00: [io  0x0600-0x061f] has been reserved
> [    2.510421] system 00:00: [io  0x0ca2-0x0ca5] has been reserved
> [    2.517033] system 00:00: [io  0x0cf9] could not be reserved
> [    2.523359] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    2.523385] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    2.523470] system 00:02: [io  0x0454-0x0457] has been reserved
> [    2.530086] system 00:02: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
> [    2.530293] pnp 00:03: [dma 0 disabled]
> [    2.530336] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
> [    2.530473] pnp 00:04: [dma 0 disabled]
> [    2.530513] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
> [    2.530815] system 00:05: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    2.538207] system 00:05: [mem 0xebfff000-0xebffffff] has been reserved
> [    2.545594] system 00:05: [mem 0xc0000000-0xcfffffff] has been reserved
> [    2.552984] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    2.560371] system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    2.567759] system 00:05: [mem 0xff000000-0xffffffff] could not be reserved
> [    2.575534] system 00:05: [mem 0xfee00000-0xfeefffff] could not be reserved
> [    2.583310] system 00:05: [mem 0xfec00000-0xfecfffff] could not be reserved
> [    2.591087] system 00:05: [mem 0xd0b70000-0xd0b70fff] has been reserved
> [    2.598477] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    2.598724] system 00:06: [mem 0x00000000-0x0009cfff] could not be reserved
> [    2.606504] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    2.606774] pnp: PnP ACPI: found 7 devices
> [    2.617510] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
> [    2.627517] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    2.633070] pci 0000:00:02.0: PCI bridge to [bus 02]
> [    2.638620] pci 0000:00:03.0: PCI bridge to [bus 03]
> [    2.644172] pci 0000:00:03.2: PCI bridge to [bus 04-05]
> [    2.650007] pci 0000:00:03.2:   bridge window [io  0x2000-0x2fff]
> [    2.656813] pci 0000:00:03.2:   bridge window [mem 0xd0a00000-0xd0afffff]
> [    2.664393] pci 0000:00:03.2:   bridge window [mem 0x38007fe00000-0x38007fefffff 64bit pref]
> [    2.673823] pci 0000:00:11.0: PCI bridge to [bus 06]
> [    2.679366] pci 0000:00:11.0:   bridge window [io  0x1000-0x1fff]
> [    2.686173] pci 0000:00:11.0:   bridge window [mem 0xd0900000-0xd09fffff]
> [    2.693754] pci 0000:00:11.0:   bridge window [mem 0x38007f800000-0x38007fcfffff 64bit pref]
> [    2.703179] pci 0000:00:1c.0: PCI bridge to [bus 07]
> [    2.708738] pci 0000:00:1c.7: PCI bridge to [bus 08]
> [    2.714284] pci 0000:00:1c.7:   bridge window [mem 0xd0000000-0xd08fffff]
> [    2.721864] pci 0000:00:1c.7:   bridge window [mem 0xea000000-0xeaffffff 64bit pref]
> [    2.730513] pci 0000:00:1e.0: PCI bridge to [bus 09]
> [    2.736064] pci_bus 0000:00: resource 4 [io  0x0000-0xbfff]
> [    2.736066] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff window]
> [    2.736067] pci_bus 0000:00: resource 6 [mem 0x000c0000-0x000c3fff window]
> [    2.736068] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000c7fff window]
> [    2.736069] pci_bus 0000:00: resource 8 [mem 0x000c8000-0x000cbfff window]
> [    2.736070] pci_bus 0000:00: resource 9 [mem 0x000cc000-0x000cffff window]
> [    2.736071] pci_bus 0000:00: resource 10 [mem 0x000d4000-0x000d7fff window]
> [    2.736072] pci_bus 0000:00: resource 11 [mem 0x000d8000-0x000dbfff window]
> [    2.736073] pci_bus 0000:00: resource 12 [mem 0x000dc000-0x000dffff window]
> [    2.736074] pci_bus 0000:00: resource 13 [mem 0x000e0000-0x000e3fff window]
> [    2.736075] pci_bus 0000:00: resource 14 [mem 0x000e4000-0x000e7fff window]
> [    2.736076] pci_bus 0000:00: resource 15 [mem 0x000e8000-0x000ebfff window]
> [    2.736078] pci_bus 0000:00: resource 16 [mem 0x000ec000-0x000effff window]
> [    2.736079] pci_bus 0000:00: resource 17 [mem 0x000f0000-0x000fffff window]
> [    2.736080] pci_bus 0000:00: resource 18 [mem 0xd0000000-0xebffffff window]
> [    2.736081] pci_bus 0000:00: resource 19 [mem 0x380000000000-0x38007fffffff window]
> [    2.736083] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
> [    2.736084] pci_bus 0000:04: resource 1 [mem 0xd0a00000-0xd0afffff]
> [    2.736085] pci_bus 0000:04: resource 2 [mem 0x38007fe00000-0x38007fefffff 64bit pref]
> [    2.736086] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
> [    2.736087] pci_bus 0000:06: resource 1 [mem 0xd0900000-0xd09fffff]
> [    2.736088] pci_bus 0000:06: resource 2 [mem 0x38007f800000-0x38007fcfffff 64bit pref]
> [    2.736089] pci_bus 0000:08: resource 1 [mem 0xd0000000-0xd08fffff]
> [    2.736090] pci_bus 0000:08: resource 2 [mem 0xea000000-0xeaffffff 64bit pref]
> [    2.736091] pci_bus 0000:09: resource 4 [io  0x0000-0xbfff]
> [    2.736092] pci_bus 0000:09: resource 5 [mem 0x000a0000-0x000bffff window]
> [    2.736093] pci_bus 0000:09: resource 6 [mem 0x000c0000-0x000c3fff window]
> [    2.736094] pci_bus 0000:09: resource 7 [mem 0x000c4000-0x000c7fff window]
> [    2.736095] pci_bus 0000:09: resource 8 [mem 0x000c8000-0x000cbfff window]
> [    2.736096] pci_bus 0000:09: resource 9 [mem 0x000cc000-0x000cffff window]
> [    2.736097] pci_bus 0000:09: resource 10 [mem 0x000d4000-0x000d7fff window]
> [    2.736098] pci_bus 0000:09: resource 11 [mem 0x000d8000-0x000dbfff window]
> [    2.736099] pci_bus 0000:09: resource 12 [mem 0x000dc000-0x000dffff window]
> [    2.736100] pci_bus 0000:09: resource 13 [mem 0x000e0000-0x000e3fff window]
> [    2.736100] pci_bus 0000:09: resource 14 [mem 0x000e4000-0x000e7fff window]
> [    2.736101] pci_bus 0000:09: resource 15 [mem 0x000e8000-0x000ebfff window]
> [    2.736102] pci_bus 0000:09: resource 16 [mem 0x000ec000-0x000effff window]
> [    2.736103] pci_bus 0000:09: resource 17 [mem 0x000f0000-0x000fffff window]
> [    2.736104] pci_bus 0000:09: resource 18 [mem 0xd0000000-0xebffffff window]
> [    2.736105] pci_bus 0000:09: resource 19 [mem 0x380000000000-0x38007fffffff window]
> [    2.736219] pci 0000:80:01.0: PCI bridge to [bus 81]
> [    2.741771] pci 0000:80:02.0: PCI bridge to [bus 82]
> [    2.747323] pci_bus 0000:80: resource 4 [io  0x03b0-0x03df window]
> [    2.747324] pci_bus 0000:80: resource 5 [io  0xc000-0xffff window]
> [    2.747324] pci_bus 0000:80: resource 6 [mem 0x000a0000-0x000bffff window]
> [    2.747326] pci_bus 0000:80: resource 7 [mem 0xec000000-0xfbffffff window]
> [    2.747330] pci_bus 0000:80: resource 8 [mem 0x380080000000-0x3800ffffffff window]
> [    2.747527] NET: Registered protocol family 2
> [    2.753184] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
> [    2.762484] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    2.770217] TCP: Hash tables configured (established 524288 bind 65536)
> [    2.777898] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
> [    2.785168] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
> [    2.793418] NET: Registered protocol family 1
> [    3.998191] pci 0000:00:1a.0: EHCI: BIOS handoff failed (BIOS bug?) 01010001
> [    5.206232] pci 0000:00:1d.0: EHCI: BIOS handoff failed (BIOS bug?) 01010001
> [    5.214313] pci 0000:08:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
> [    5.223797] PCI: CLS 64 bytes, default 64
> [    5.223860] Unpacking initramfs...
> [    5.515860] Freeing initrd memory: 19788K
> [    5.520345] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    5.527536] software IO TLB [mem 0xb2da1000-0xb6da1000] (64MB) mapped at [ffff9743f2da1000-ffff9743f6da0fff]
> [    5.538877] RAPL PMU: API unit is 2^-32 Joules, 3 fixed counters, 163840 ms ovfl timer
> [    5.547728] RAPL PMU: hw unit of domain pp0-core 2^-16 Joules
> [    5.554144] RAPL PMU: hw unit of domain package 2^-16 Joules
> [    5.560463] RAPL PMU: hw unit of domain dram 2^-16 Joules
> [    5.573058] audit: initializing netlink subsys (disabled)
> [    5.579742] Initialise system trusted keyrings
> [    5.584830] workingset: timestamp_bits=36 max_order=24 bucket_order=0
> [    5.592982] zbud: loaded
> [    5.596363] SELinux:  Registering netfilter hooks
> [    5.645284] NET: Registered protocol family 38
> [    5.650275] Key type asymmetric registered
> [    5.654851] Asymmetric key parser 'x509' registered
> [    5.660318] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
> [    5.668724] io scheduler noop registered
> [    5.673121] io scheduler deadline registered (default)
> [    5.678896] io scheduler cfq registered
> [    5.683183] io scheduler mq-deadline registered
> [    5.688534] atomic64_test: passed for x86-64 platform with CX8 and with SSE
> [    5.698146] intel_idle: MWAIT substates: 0x20
> [    5.698147] intel_idle: v0.4.1 model 0x3E
> [    5.698715] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    5.698843] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
> [    5.708177] ACPI: Sleep Button [SLPB]
> [    5.712307] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [    5.720568] ACPI: Power Button [PWRF]
> [    5.726828] ERST: Error Record Serialization Table (ERST) support is initialized.
> [    5.735195] pstore: using zlib compression
> [    5.739774] pstore: Registered erst as persistent store backend
> [    5.746556] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
> [    5.754890] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    5.782652] 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    5.811566] 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
> [    5.820255] Non-volatile memory driver v1.3
> [    5.824960] Linux agpgart interface v0.103
> [    5.830723] rdac: device handler registered
> [    5.835451] hp_sw: device handler registered
> [    5.840232] emc: device handler registered
> [    5.845092] alua: device handler registered
> [    5.849799] libphy: Fixed MDIO Bus: probed
> [    5.854423] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    5.861717] ehci-pci: EHCI PCI platform driver
> [    5.866923] ehci-pci 0000:00:1a.0: EHCI Host Controller
> [    5.872814] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
> [    5.881085] ehci-pci 0000:00:1a.0: debug port 2
> [    5.890051] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
> [    5.890067] ehci-pci 0000:00:1a.0: irq 22, io mem 0xd0b20000
> [    5.903259] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    5.909725] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    5.917304] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.925364] usb usb1: Product: EHCI Host Controller
> [    5.930813] usb usb1: Manufacturer: Linux 4.11.0-rc5+ ehci_hcd
> [    5.937329] usb usb1: SerialNumber: 0000:00:1a.0
> [    5.942582] hub 1-0:1.0: USB hub found
> [    5.946783] hub 1-0:1.0: 2 ports detected
> [    5.951487] ehci-pci 0000:00:1d.0: EHCI Host Controller
> [    5.957370] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    5.965643] ehci-pci 0000:00:1d.0: debug port 2
> [    5.974614] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
> [    5.974622] ehci-pci 0000:00:1d.0: irq 20, io mem 0xd0b10000
> [    5.987260] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    5.993715] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    6.001297] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.009362] usb usb2: Product: EHCI Host Controller
> [    6.014809] usb usb2: Manufacturer: Linux 4.11.0-rc5+ ehci_hcd
> [    6.021324] usb usb2: SerialNumber: 0000:00:1d.0
> [    6.026555] hub 2-0:1.0: USB hub found
> [    6.030749] hub 2-0:1.0: 2 ports detected
> [    6.035343] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    6.042266] ohci-pci: OHCI PCI platform driver
> [    6.047252] uhci_hcd: USB Universal Host Controller Interface driver
> [    6.054404] usbcore: registered new interface driver usbserial
> [    6.060924] usbcore: registered new interface driver usbserial_generic
> [    6.068221] usbserial: USB Serial support registered for generic
> [    6.074950] i8042: PNP: No PS/2 controller found.
> [    6.080263] mousedev: PS/2 mouse device common for all mice
> [    6.086598] rtc_cmos 00:01: RTC can wake from S4
> [    6.091886] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
> [    6.098724] rtc_cmos 00:01: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
> [    6.107287] intel_pstate: Intel P-state driver initializing
> [    6.114304] hidraw: raw HID events driver (C) Jiri Kosina
> [    6.120403] usbcore: registered new interface driver usbhid
> [    6.126628] usbhid: USB HID core driver
> [    6.131133] drop_monitor: Initializing network drop monitor service
> [    6.138415] Initializing XFRM netlink socket
> [    6.143375] NET: Registered protocol family 10
> [    6.149141] Segment Routing with IPv6
> [    6.153256] NET: Registered protocol family 17
> [    6.159177] microcode: sig=0x306e4, pf=0x20, revision=0xc8730415
> [    6.165981] microcode: Microcode Update Driver: v2.2.
> [    6.166091] registered taskstats version 1
> [    6.176317] Loading compiled-in X.509 certificates
> [    6.183437] alg: No test for pkcs1pad(rsa,sha256) (pkcs1pad(rsa-generic,sha256))
> [    6.192499] Loaded X.509 cert 'Build time autogenerated kernel key: 1fb99fb420957198d5b4eec7933b1876619428a3'
> [    6.203605] zswap: loaded using pool lzo/zbud
> [    6.218365] Key type big_key registered
> [    6.224223] Key type trusted registered
> [    6.230005] Key type encrypted registered
> [    6.234482] ima: No TPM chip found, activating TPM-bypass! (rc=-19)
> [    6.241508] evm: HMAC attrs: 0x1
> [    6.245890] rtc_cmos 00:01: setting system clock to 2017-04-07 10:38:30 UTC (1491561510)
> [    6.256706] Freeing unused kernel memory: 2124K
> [    6.260257] usb 1-1: new high-speed USB device number 2 using ehci-pci
> [    6.269064] Write protecting the kernel read-only data: 12288k
> [    6.276117] Freeing unused kernel memory: 728K
> [    6.283265] Freeing unused kernel memory: 904K
> [    6.288243] rodata_test: all tests were successful
> [    6.311256] random: systemd: uninitialized urandom read (16 bytes read)
> [    6.319554] random: systemd: uninitialized urandom read (16 bytes read)
> [    6.329313] systemd[1]: systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
> [    6.349257] usb 2-1: new high-speed USB device number 2 using ehci-pci
> [    6.357048] systemd[1]: Detected architecture x86-64.
> [    6.362701] systemd[1]: Running in initial RAM disk.
> [    6.378569] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
> [    6.386063] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    6.394128] systemd[1]: Set hostname to <localhost.localdomain>.
> [    6.394343] hub 1-1:1.0: USB hub found
> [    6.394447] hub 1-1:1.0: 6 ports detected
> [    6.432374] random: systemd: uninitialized urandom read (16 bytes read)
> [    6.439787] random: systemd: uninitialized urandom read (16 bytes read)
> [    6.447208] random: systemd: uninitialized urandom read (16 bytes read)
> [    6.454649] random: systemd: uninitialized urandom read (16 bytes read)
> [    6.462669] random: systemd: uninitialized urandom read (16 bytes read)
> [    6.467576] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
> [    6.467577] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    6.467716] hub 2-1:1.0: USB hub found
> [    6.467824] hub 2-1:1.0: 8 ports detected
> [    6.494318] random: systemd: uninitialized urandom read (16 bytes read)
> [    6.501880] random: systemd: uninitialized urandom read (16 bytes read)
> [    6.509751] random: systemd: uninitialized urandom read (16 bytes read)
> [    6.527283] systemd[1]: Reached target Local File Systems.
> [    6.533435] systemd[1]: Starting Local File Systems.
> [    6.544274] systemd[1]: Reached target Timers.
> [    6.549258] systemd[1]: Starting Timers.
> [    6.559274] systemd[1]: Created slice Root Slice.
> [    6.564540] systemd[1]: Starting Root Slice.
> [    6.572285] tsc: Refined TSC clocksource calibration: 2593.749 MHz
> [    6.579449] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x25632b1b102, max_idle_ns: 440795335950 ns
> [    6.740272] usb 2-1.4: new full-speed USB device number 3 using ehci-pci
> [    6.776941] device-mapper: uevent: version 1.0.3
> [    6.782211] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel@redhat.com
> [    6.842210] usb 2-1.4: New USB device found, idVendor=046b, idProduct=ff10
> [    6.850265] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    6.858441] usb 2-1.4: Product: Virtual Keyboard and Mouse
> [    6.864577] usb 2-1.4: Manufacturer: American Megatrends Inc.
> [    6.864578] usb 2-1.4: SerialNumber: serial
> [    6.865944] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/0003:046B:FF10.0001/input/input2
> [    6.866137] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.0-1.4/input0
> [    6.867133] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.1/0003:046B:FF10.0002/input/input3
> [    6.867252] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.0-1.4/input1
> [    6.931281] usb 2-1.5: new low-speed USB device number 4 using ehci-pci
> [    6.950857] libata version 3.00 loaded.
> [    6.952030] nd_pmem namespace0.0: unable to guarantee persistence of writes
> [    6.959986] dca service started, version 1.12.1
> [    6.968804] pps_core: LinuxPPS API ver. 1 registered
> [    6.968805] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    6.969159] ahci 0000:00:1f.2: version 3.0
> [    6.969894] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
> [    6.969896] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
> [    6.970350] PTP clock support registered
> [    6.984709] scsi host0: ahci
> [    7.013349] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4.0-k
> [    7.018595] usb 2-1.5: New USB device found, idVendor=0624, idProduct=0291
> [    7.018597] usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    7.018598] usb 2-1.5: Product: Avocent AVRIQ-USB
> [    7.018599] usb 2-1.5: Manufacturer: Avocent
> [    7.050983] igb: Copyright (c) 2007-2014 Intel Corporation.
> [    7.057979] input: Avocent Avocent AVRIQ-USB as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/0003:0624:0291.0003/input/input4
> [    7.088292] [TTM] Zone  kernel: Available graphics memory: 32937238 kiB
> [    7.095685] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
> [    7.095685] [TTM] Initializing pool allocator
> [    7.095688] [TTM] Initializing DMA pool allocator
> [    7.125402] hid-generic 0003:0624:0291.0003: input,hidraw2: USB HID v1.10 Keyboard [Avocent Avocent AVRIQ-USB] on usb-0000:00:1d.0-1.5/input0
> [    7.146406] input: Avocent Avocent AVRIQ-USB as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.1/0003:0624:0291.0004/input/input5
> [    7.163796] igb 0000:04:00.0: added PHC on eth0
> [    7.169513] igb 0000:04:00.0: Intel(R) Gigabit Ethernet Network Connection
> [    7.169514] igb 0000:04:00.0: eth0: (PCIe:5.0Gb/s:Width x4) 00:1e:67:58:98:f8
> [    7.169518] fbcon: mgadrmfb (fb0) is primary device
> [    7.169596] igb 0000:04:00.0: eth0: PBA No: 106200-000
> [    7.169598] igb 0000:04:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> [    7.215368] hid-generic 0003:0624:0291.0004: input,hidraw3: USB HID v1.10 Mouse [Avocent Avocent AVRIQ-USB] on usb-0000:00:1d.0-1.5/input1
> [    7.236988] igb 0000:04:00.1: added PHC on eth1
> [    7.236989] igb 0000:04:00.1: Intel(R) Gigabit Ethernet Network Connection
> [    7.236990] igb 0000:04:00.1: eth1: (PCIe:5.0Gb/s:Width x4) 00:1e:67:58:98:f9
> [    7.237063] igb 0000:04:00.1: eth1: PBA No: 106200-000
> [    7.237065] igb 0000:04:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> [    7.238358] igb 0000:04:00.0 enp4s0f0: renamed from eth0
> [    7.401743] Console: switching to colour frame buffer device 128x48
> [    7.522125] mgag200 0000:08:00.0: fb0: mgadrmfb frame buffer device
> [    7.596926] clocksource: Switched to clocksource tsc
> [    8.813472] [drm] Initialized mgag200 1.0.0 20110418 for 0000:08:00.0 on minor 0
> [    8.813923] igb 0000:04:00.1 enp4s0f1: renamed from eth1
> [    9.309404] scsi host1: ahci
> [    9.312748] scsi host2: ahci
> [    9.312750] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
> [    9.312770] isci 0000:06:00.0: driver configured for rev: 6 silicon
> [    9.312773] isci 0000:06:00.0: OEM parameter table found in OROM
> [    9.312775] isci 0000:06:00.0: OEM SAS parameters (version: 1.1) loaded (platform)
> [    9.312952] isci 0000:06:00.0: SCU controller 0: phy 3-0 cables: {short, short, short, short}
> [    9.315366] scsi host3: isci
> [    9.358160] scsi host4: ahci
> [    9.361513] scsi host5: ahci
> [    9.364837] scsi host6: ahci
> [    9.368094] ata1: SATA max UDMA/133 abar m2048@0xd0b00000 port 0xd0b00100 irq 26
> [    9.376353] ata2: SATA max UDMA/133 abar m2048@0xd0b00000 port 0xd0b00180 irq 26
> [    9.384611] ata3: SATA max UDMA/133 abar m2048@0xd0b00000 port 0xd0b00200 irq 26
> [    9.392870] ata4: SATA max UDMA/133 abar m2048@0xd0b00000 port 0xd0b00280 irq 26
> [    9.401130] ata5: SATA max UDMA/133 abar m2048@0xd0b00000 port 0xd0b00300 irq 26
> [    9.409390] ata6: SATA max UDMA/133 abar m2048@0xd0b00000 port 0xd0b00380 irq 26
> [    9.721505] ata3: SATA link down (SStatus 0 SControl 300)
> [    9.727550] ata2: SATA link down (SStatus 0 SControl 300)
> [    9.733592] ata1: SATA link down (SStatus 0 SControl 300)
> [    9.739645] ata5: SATA link down (SStatus 0 SControl 300)
> [    9.745729] ata4: SATA link down (SStatus 0 SControl 300)
> [    9.751811] ata6: SATA link down (SStatus 0 SControl 300)
> [    9.923219] pmem0: detected capacity change from 0 to 206158430208
> [   10.412470] sas: phy-3:0 added to port-3:0, phy_mask:0x1 (5001e675898f8000)
> [   10.412486] sas: DOING DISCOVERY on port 0, pid:5
> [   10.412503] sas: DONE DISCOVERY on port 0, pid:5, result:0
> [   10.412510] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [   10.412556] sas: ata7: end_device-3:0: dev error handler
> [   10.592430] ata7.00: ATA-8: WDC WD1002FAEX-00Z3A0, 05.01D05, max UDMA/133
> [   10.600014] ata7.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [   10.609311] ata7.00: configured for UDMA/133
> [   10.614091] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
> [   10.624824] scsi 3:0:0:0: Direct-Access     ATA      WDC WD1002FAEX-0 1D05 PQ: 0 ANSI: 5
> [   10.650771] sd 3:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/932 GiB)
> [   10.659348] sd 3:0:0:0: [sda] Write Protect is off
> [   10.664705] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [   10.664721] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   10.683938] random: fast init done
> [   10.687752]  sda: sda1 sda2
> [   10.691113] sd 3:0:0:0: [sda] Attached SCSI disk
> [   11.210624] SGI XFS with ACLs, security attributes, no debug enabled
> [   11.220309] XFS (dm-0): Mounting V5 Filesystem
> [   11.344019] XFS (dm-0): Ending clean mount
> [   11.623060] systemd-journald[283]: Received SIGTERM from PID 1 (systemd).
> [   11.748757] systemd: 22 output lines suppressed due to ratelimiting
> [   11.815996] random: crng init done
> [   12.138825] SELinux: 32768 avtab hash slots, 104960 rules.
> [   12.152479] SELinux: 32768 avtab hash slots, 104960 rules.
> [   12.176042] SELinux:  8 users, 14 roles, 4986 types, 301 bools, 1 sens, 1024 cats
> [   12.176045] SELinux:  91 classes, 104960 rules
> [   12.179329] SELinux:  Permission validate_trans in class security not defined in policy.
> [   12.188368] SELinux:  Permission module_load in class system not defined in policy.
> [   12.196989] SELinux:  Class binder not defined in policy.
> [   12.203016] SELinux:  Class cap_userns not defined in policy.
> [   12.209420] SELinux:  Class cap2_userns not defined in policy.
> [   12.215930] SELinux:  Class sctp_socket not defined in policy.
> [   12.222440] SELinux:  Class icmp_socket not defined in policy.
> [   12.228952] SELinux:  Class ax25_socket not defined in policy.
> [   12.235461] SELinux:  Class ipx_socket not defined in policy.
> [   12.241876] SELinux:  Class netrom_socket not defined in policy.
> [   12.248580] SELinux:  Class atmpvc_socket not defined in policy.
> [   12.255286] SELinux:  Class x25_socket not defined in policy.
> [   12.261699] SELinux:  Class rose_socket not defined in policy.
> [   12.268208] SELinux:  Class decnet_socket not defined in policy.
> [   12.274913] SELinux:  Class atmsvc_socket not defined in policy.
> [   12.281619] SELinux:  Class rds_socket not defined in policy.
> [   12.288023] SELinux:  Class irda_socket not defined in policy.
> [   12.294536] SELinux:  Class pppox_socket not defined in policy.
> [   12.301140] SELinux:  Class llc_socket not defined in policy.
> [   12.307553] SELinux:  Class can_socket not defined in policy.
> [   12.313964] SELinux:  Class tipc_socket not defined in policy.
> [   12.320474] SELinux:  Class bluetooth_socket not defined in policy.
> [   12.327467] SELinux:  Class iucv_socket not defined in policy.
> [   12.333977] SELinux:  Class rxrpc_socket not defined in policy.
> [   12.340582] SELinux:  Class isdn_socket not defined in policy.
> [   12.347091] SELinux:  Class phonet_socket not defined in policy.
> [   12.353795] SELinux:  Class ieee802154_socket not defined in policy.
> [   12.360887] SELinux:  Class caif_socket not defined in policy.
> [   12.367396] SELinux:  Class alg_socket not defined in policy.
> [   12.373809] SELinux:  Class nfc_socket not defined in policy.
> [   12.380219] SELinux:  Class vsock_socket not defined in policy.
> [   12.386827] SELinux:  Class kcm_socket not defined in policy.
> [   12.393239] SELinux:  Class qipcrtr_socket not defined in policy.
> [   12.400040] SELinux:  Class smc_socket not defined in policy.
> [   12.406451] SELinux: the above unknown classes and permissions will be allowed
> [   12.414519] SELinux:  Completing initialization.
> [   12.414519] SELinux:  Setting up existing superblocks.
> [   12.427708] systemd[1]: Successfully loaded SELinux policy in 398.099ms.
> [   12.525046] systemd[1]: RTC configured in localtime, applying delta of -240 minutes to system time.
> [   12.750481] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   12.756546] systemd[1]: Inserted module 'ip_tables'
> [   12.780763] systemd[1]: Relabelled /dev and /run in 18.031ms.
> [   14.420114] systemd-journald[727]: Received request to flush runtime journal from PID 1
> [   15.280936] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
> [   15.289348] i801_smbus 0000:06:00.3: Enabling SMBus device
> [   15.295493] i801_smbus 0000:06:00.3: SMBus using PCI interrupt
> [   15.306180] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [   15.334380] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [   15.350112] igb 0000:04:00.0: DCA enabled
> [   15.354605] igb 0000:04:00.1: DCA enabled
> [   15.424542] mei_me 0000:00:16.0: Device doesn't have valid ME Interface
> [   15.432543] ipmi message handler version 39.2
> [   15.483128] ipmi device interface
> [   15.520269] IPMI System Interface driver.
> [   15.524806] ipmi_si: probing via SMBIOS
> [   15.529092] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
> [   15.535705] ipmi_si: Adding SMBIOS-specified kcs state machine
> [   15.542222] ipmi_si: probing via SPMI
> [   15.546314] ipmi_si: SPMI: io 0xca2 regsize 1 spacing 1 irq 0
> [   15.546315] ipmi_si: SPMI-specified kcs state machine: duplicate
> [   15.546316] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
> [   15.650165] ipmi_si ipmi_si.0: Found new BMC (man_id: 0x000157, prod_id: 0x005c, dev_id: 0x21)
> [   15.659907] ipmi_si ipmi_si.0: IPMI kcs interface initialized
> [   15.673054] input: PC Speaker as /devices/platform/pcspkr/input/input6
> [   15.737609] IPMI SSIF Interface driver
> [   15.806509] iTCO_vendor_support: vendor-support=0
> [   15.828195] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> [   15.834466] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
> [   15.844640] wmi: Mapper loaded
> [   15.892261] sd 3:0:0:0: Attached scsi generic sg0 type 0
> [   16.119760] AVX version of gcm_enc/dec engaged.
> [   16.124819] AES CTR mode by8 optimization enabled
> [   16.168376] alg: No test for pcbc(aes) (pcbc-aes-aesni)
> [   16.685594] kvm: disabled by bios
> [   16.706605] kvm: disabled by bios
> [   16.731575] kvm: disabled by bios
> [   16.756565] kvm: disabled by bios
> [   16.781665] kvm: disabled by bios
> [   16.982839] XFS (sda1): Mounting V5 Filesystem
> [   17.228200] XFS (sda1): Ending clean mount
> [   17.271320] EDAC MC: Ver: 3.0.0
> [   17.397151] EDAC sbridge: Seeking for: PCI ID 8086:0ea0
> [   17.397163] EDAC sbridge: Seeking for: PCI ID 8086:0ea0
> [   17.397167] EDAC sbridge: Seeking for: PCI ID 8086:0ea0
> [   17.397169] EDAC sbridge: Seeking for: PCI ID 8086:0ea8
> [   17.397173] EDAC sbridge: Seeking for: PCI ID 8086:0ea8
> [   17.397177] EDAC sbridge: Seeking for: PCI ID 8086:0ea8
> [   17.397179] EDAC sbridge: Seeking for: PCI ID 8086:0e71
> [   17.397183] EDAC sbridge: Seeking for: PCI ID 8086:0e71
> [   17.397187] EDAC sbridge: Seeking for: PCI ID 8086:0e71
> [   17.397188] EDAC sbridge: Seeking for: PCI ID 8086:0eaa
> [   17.397193] EDAC sbridge: Seeking for: PCI ID 8086:0eaa
> [   17.397196] EDAC sbridge: Seeking for: PCI ID 8086:0eaa
> [   17.397198] EDAC sbridge: Seeking for: PCI ID 8086:0eab
> [   17.397202] EDAC sbridge: Seeking for: PCI ID 8086:0eab
> [   17.397206] EDAC sbridge: Seeking for: PCI ID 8086:0eab
> [   17.397207] EDAC sbridge: Seeking for: PCI ID 8086:0eac
> [   17.397212] EDAC sbridge: Seeking for: PCI ID 8086:0eac
> [   17.397215] EDAC sbridge: Seeking for: PCI ID 8086:0eac
> [   17.397217] EDAC sbridge: Seeking for: PCI ID 8086:0ead
> [   17.397221] EDAC sbridge: Seeking for: PCI ID 8086:0ead
> [   17.397225] EDAC sbridge: Seeking for: PCI ID 8086:0ead
> [   17.397226] EDAC sbridge: Seeking for: PCI ID 8086:0ec8
> [   17.397231] EDAC sbridge: Seeking for: PCI ID 8086:0ec8
> [   17.397234] EDAC sbridge: Seeking for: PCI ID 8086:0ec8
> [   17.397235] EDAC sbridge: Seeking for: PCI ID 8086:0ec9
> [   17.397240] EDAC sbridge: Seeking for: PCI ID 8086:0ec9
> [   17.397244] EDAC sbridge: Seeking for: PCI ID 8086:0ec9
> [   17.397244] EDAC sbridge: Seeking for: PCI ID 8086:0eca
> [   17.397249] EDAC sbridge: Seeking for: PCI ID 8086:0eca
> [   17.397253] EDAC sbridge: Seeking for: PCI ID 8086:0eca
> [   17.397253] EDAC sbridge: Seeking for: PCI ID 8086:0e60
> [   17.397259] EDAC sbridge: Seeking for: PCI ID 8086:0e6a
> [   17.397264] EDAC sbridge: Seeking for: PCI ID 8086:0e6b
> [   17.397270] EDAC sbridge: Seeking for: PCI ID 8086:0e6c
> [   17.397275] EDAC sbridge: Seeking for: PCI ID 8086:0e6d
> [   17.397281] EDAC sbridge: Seeking for: PCI ID 8086:0eb8
> [   17.397286] EDAC sbridge: Seeking for: PCI ID 8086:0ebc
> [   17.397525] EDAC MC0: Giving out device to module sbridge_edac.c controller Ivy Bridge Socket#0: DEV 0000:7f:0e.0 (INTERRUPT)
> [   17.410388] EDAC MC1: Giving out device to module sbridge_edac.c controller Ivy Bridge Socket#1: DEV 0000:ff:0e.0 (INTERRUPT)
> [   17.423021] EDAC sbridge:  Ver: 1.1.1 
> [   17.464909] intel_rapl: Found RAPL domain package
> [   17.470162] intel_rapl: Found RAPL domain core
> [   17.475143] intel_rapl: Found RAPL domain dram
> [   17.481390] intel_rapl: Found RAPL domain package
> [   17.486646] intel_rapl: Found RAPL domain core
> [   17.491617] intel_rapl: Found RAPL domain dram
> [   17.501701] Adding 4194300k swap on /dev/mapper/rhel_intel--lizardhead--04-swap.  Priority:-1 extents:1 across:4194300k FS
> [   18.266922] XFS (dm-2): Mounting V5 Filesystem
> [   18.395080] XFS (dm-2): Ending clean mount
> [   19.022089] audit: type=2000 audit(1491561506.500:1): state=initialized audit_enabled=0 res=1
> [   19.031619] audit: type=1404 audit(1491561516.290:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
> [   19.042988] audit: type=1403 audit(1491561516.677:3): policy loaded auid=4294967295 ses=4294967295
> [   21.342920] IPv6: ADDRCONF(NETDEV_UP): enp4s0f0: link is not ready
> [   21.483606] IPv6: ADDRCONF(NETDEV_UP): enp4s0f0: link is not ready
> [   21.493164] IPv6: ADDRCONF(NETDEV_UP): enp4s0f1: link is not ready
> [   21.611514] IPv6: ADDRCONF(NETDEV_UP): enp4s0f1: link is not ready
> [   21.623914] IPv6: ADDRCONF(NETDEV_UP): enp4s0f0: link is not ready
> [   21.631244] IPv6: ADDRCONF(NETDEV_UP): enp4s0f1: link is not ready
> [   24.671103] igb 0000:04:00.0 enp4s0f0: igb: enp4s0f0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> [   24.682407] IPv6: ADDRCONF(NETDEV_CHANGE): enp4s0f0: link becomes ready

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/x86 4.11.0-rc5 Kernel Configuration
> #
> CONFIG_64BIT=y
> CONFIG_X86_64=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf64-x86-64"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_ARCH_MMAP_RND_BITS_MIN=28
> CONFIG_ARCH_MMAP_RND_BITS_MAX=32
> CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
> CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> CONFIG_ZONE_DMA32=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_HAVE_INTEL_TXT=y
> CONFIG_X86_64_SMP=y
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_PGTABLE_LEVELS=4
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> CONFIG_THREAD_INFO_IN_TASK=y
> 
> #
> # General setup
> #
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> # CONFIG_COMPILE_TEST is not set
> CONFIG_LOCALVERSION=""
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> CONFIG_KERNEL_GZIP=y
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> CONFIG_CROSS_MEMORY_ATTACH=y
> CONFIG_FHANDLE=y
> CONFIG_USELIB=y
> CONFIG_AUDIT=y
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> CONFIG_AUDITSYSCALL=y
> CONFIG_AUDIT_WATCH=y
> CONFIG_AUDIT_TREE=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_IRQ_DOMAIN=y
> CONFIG_IRQ_DOMAIN_HIERARCHY=y
> CONFIG_GENERIC_MSI_IRQ=y
> CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
> # CONFIG_IRQ_DOMAIN_DEBUG is not set
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_ARCH_CLOCKSOURCE_DATA=y
> CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ_COMMON=y
> # CONFIG_HZ_PERIODIC is not set
> # CONFIG_NO_HZ_IDLE is not set
> CONFIG_NO_HZ_FULL=y
> # CONFIG_NO_HZ_FULL_ALL is not set
> # CONFIG_NO_HZ_FULL_SYSIDLE is not set
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_VIRT_CPU_ACCOUNTING=y
> CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> CONFIG_BSD_PROCESS_ACCT=y
> CONFIG_BSD_PROCESS_ACCT_V3=y
> CONFIG_TASKSTATS=y
> CONFIG_TASK_DELAY_ACCT=y
> CONFIG_TASK_XACCT=y
> CONFIG_TASK_IO_ACCOUNTING=y
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=y
> # CONFIG_RCU_EXPERT is not set
> CONFIG_SRCU=y
> # CONFIG_TASKS_RCU is not set
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_CONTEXT_TRACKING=y
> # CONFIG_CONTEXT_TRACKING_FORCE is not set
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_RCU_NOCB_CPU=y
> # CONFIG_RCU_NOCB_CPU_NONE is not set
> # CONFIG_RCU_NOCB_CPU_ZERO is not set
> CONFIG_RCU_NOCB_CPU_ALL=y
> CONFIG_BUILD_BIN2C=y
> # CONFIG_IKCONFIG is not set
> CONFIG_LOG_BUF_SHIFT=20
> CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
> CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
> CONFIG_ARCH_SUPPORTS_INT128=y
> CONFIG_NUMA_BALANCING=y
> CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
> CONFIG_CGROUPS=y
> CONFIG_PAGE_COUNTER=y
> CONFIG_MEMCG=y
> CONFIG_MEMCG_SWAP=y
> CONFIG_MEMCG_SWAP_ENABLED=y
> CONFIG_BLK_CGROUP=y
> # CONFIG_DEBUG_BLK_CGROUP is not set
> CONFIG_CGROUP_WRITEBACK=y
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> CONFIG_CFS_BANDWIDTH=y
> CONFIG_RT_GROUP_SCHED=y
> # CONFIG_CGROUP_PIDS is not set
> # CONFIG_CGROUP_RDMA is not set
> CONFIG_CGROUP_FREEZER=y
> CONFIG_CGROUP_HUGETLB=y
> CONFIG_CPUSETS=y
> CONFIG_PROC_PID_CPUSET=y
> CONFIG_CGROUP_DEVICE=y
> CONFIG_CGROUP_CPUACCT=y
> CONFIG_CGROUP_PERF=y
> # CONFIG_CGROUP_DEBUG is not set
> CONFIG_SOCK_CGROUP_DATA=y
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> CONFIG_IPC_NS=y
> CONFIG_USER_NS=y
> CONFIG_PID_NS=y
> CONFIG_NET_NS=y
> CONFIG_SCHED_AUTOGROUP=y
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_XZ=y
> CONFIG_RD_LZO=y
> CONFIG_RD_LZ4=y
> CONFIG_INITRAMFS_COMPRESSION=".gz"
> CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_BPF=y
> # CONFIG_EXPERT is not set
> CONFIG_UID16=y
> CONFIG_MULTIUSER=y
> CONFIG_SGETMASK_SYSCALL=y
> CONFIG_SYSFS_SYSCALL=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_POSIX_TIMERS=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
> CONFIG_KALLSYMS_BASE_RELATIVE=y
> CONFIG_PRINTK=y
> CONFIG_PRINTK_NMI=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> # CONFIG_BPF_SYSCALL is not set
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_ADVISE_SYSCALLS=y
> # CONFIG_USERFAULTFD is not set
> CONFIG_PCI_QUIRKS=y
> CONFIG_MEMBARRIER=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> # CONFIG_PC104 is not set
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_SLUB_MEMCG_SYSFS_ON is not set
> # CONFIG_COMPAT_BRK is not set
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLAB_FREELIST_RANDOM is not set
> CONFIG_SLUB_CPU_PARTIAL=y
> CONFIG_SYSTEM_DATA_VERIFICATION=y
> CONFIG_PROFILING=y
> CONFIG_TRACEPOINTS=y
> CONFIG_KEXEC_CORE=y
> CONFIG_OPROFILE=m
> CONFIG_OPROFILE_EVENT_MULTIPLEX=y
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> CONFIG_KPROBES=y
> CONFIG_JUMP_LABEL=y
> # CONFIG_STATIC_KEYS_SELFTEST is not set
> CONFIG_OPTPROBES=y
> CONFIG_KPROBES_ON_FTRACE=y
> # CONFIG_UPROBES is not set
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_KRETPROBES=y
> CONFIG_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_NMI=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_CONTIGUOUS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_ARCH_HAS_SET_MEMORY=y
> CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_CLK=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
> CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_SECCOMP_FILTER=y
> CONFIG_HAVE_GCC_PLUGINS=y
> # CONFIG_GCC_PLUGINS is not set
> CONFIG_HAVE_CC_STACKPROTECTOR=y
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_CC_STACKPROTECTOR_NONE is not set
> # CONFIG_CC_STACKPROTECTOR_REGULAR is not set
> CONFIG_CC_STACKPROTECTOR_STRONG=y
> CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
> CONFIG_HAVE_CONTEXT_TRACKING=y
> CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
> CONFIG_HAVE_ARCH_HUGE_VMAP=y
> CONFIG_HAVE_ARCH_SOFT_DIRTY=y
> CONFIG_MODULES_USE_ELF_RELA=y
> CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
> CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
> CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
> CONFIG_HAVE_EXIT_THREAD=y
> CONFIG_ARCH_MMAP_RND_BITS=28
> CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
> CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
> CONFIG_HAVE_COPY_THREAD_TLS=y
> CONFIG_HAVE_STACK_VALIDATION=y
> # CONFIG_HAVE_ARCH_HASH is not set
> # CONFIG_ISA_BUS_API is not set
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_COMPAT_OLD_SIGACTION=y
> # CONFIG_CPU_NO_EFFICIENT_FFS is not set
> CONFIG_HAVE_ARCH_VMAP_STACK=y
> CONFIG_VMAP_STACK=y
> # CONFIG_ARCH_OPTIONAL_KERNEL_RWX is not set
> # CONFIG_ARCH_OPTIONAL_KERNEL_RWX_DEFAULT is not set
> CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
> CONFIG_STRICT_KERNEL_RWX=y
> CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
> CONFIG_STRICT_MODULE_RWX=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> CONFIG_MODULE_FORCE_LOAD=y
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODULE_FORCE_UNLOAD is not set
> CONFIG_MODVERSIONS=y
> CONFIG_MODULE_SRCVERSION_ALL=y
> CONFIG_MODULE_SIG=y
> # CONFIG_MODULE_SIG_FORCE is not set
> CONFIG_MODULE_SIG_ALL=y
> # CONFIG_MODULE_SIG_SHA1 is not set
> # CONFIG_MODULE_SIG_SHA224 is not set
> CONFIG_MODULE_SIG_SHA256=y
> # CONFIG_MODULE_SIG_SHA384 is not set
> # CONFIG_MODULE_SIG_SHA512 is not set
> CONFIG_MODULE_SIG_HASH="sha256"
> # CONFIG_MODULE_COMPRESS is not set
> # CONFIG_TRIM_UNUSED_KSYMS is not set
> CONFIG_MODULES_TREE_LOOKUP=y
> CONFIG_BLOCK=y
> CONFIG_BLK_SCSI_REQUEST=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> CONFIG_BLK_DEV_INTEGRITY=y
> # CONFIG_BLK_DEV_ZONED is not set
> CONFIG_BLK_DEV_THROTTLING=y
> # CONFIG_BLK_CMDLINE_PARSER is not set
> CONFIG_BLK_WBT=y
> CONFIG_BLK_WBT_SQ=y
> CONFIG_BLK_WBT_MQ=y
> CONFIG_BLK_DEBUG_FS=y
> # CONFIG_BLK_SED_OPAL is not set
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> # CONFIG_ACORN_PARTITION is not set
> # CONFIG_AIX_PARTITION is not set
> CONFIG_OSF_PARTITION=y
> CONFIG_AMIGA_PARTITION=y
> # CONFIG_ATARI_PARTITION is not set
> CONFIG_MAC_PARTITION=y
> CONFIG_MSDOS_PARTITION=y
> CONFIG_BSD_DISKLABEL=y
> CONFIG_MINIX_SUBPARTITION=y
> CONFIG_SOLARIS_X86_PARTITION=y
> CONFIG_UNIXWARE_DISKLABEL=y
> # CONFIG_LDM_PARTITION is not set
> CONFIG_SGI_PARTITION=y
> # CONFIG_ULTRIX_PARTITION is not set
> CONFIG_SUN_PARTITION=y
> CONFIG_KARMA_PARTITION=y
> CONFIG_EFI_PARTITION=y
> # CONFIG_SYSV68_PARTITION is not set
> # CONFIG_CMDLINE_PARTITION is not set
> CONFIG_BLOCK_COMPAT=y
> CONFIG_BLK_MQ_PCI=y
> CONFIG_BLK_MQ_VIRTIO=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> CONFIG_CFQ_GROUP_IOSCHED=y
> CONFIG_DEFAULT_DEADLINE=y
> # CONFIG_DEFAULT_CFQ is not set
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="deadline"
> CONFIG_MQ_IOSCHED_DEADLINE=y
> CONFIG_PREEMPT_NOTIFIERS=y
> CONFIG_PADATA=y
> CONFIG_ASN1=y
> CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
> CONFIG_INLINE_READ_UNLOCK=y
> CONFIG_INLINE_READ_UNLOCK_IRQ=y
> CONFIG_INLINE_WRITE_UNLOCK=y
> CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
> CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
> CONFIG_MUTEX_SPIN_ON_OWNER=y
> CONFIG_RWSEM_SPIN_ON_OWNER=y
> CONFIG_LOCK_SPIN_ON_OWNER=y
> CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
> CONFIG_QUEUED_SPINLOCKS=y
> CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
> CONFIG_QUEUED_RWLOCKS=y
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> CONFIG_SMP=y
> CONFIG_X86_FEATURE_NAMES=y
> CONFIG_X86_FAST_FEATURE_TESTS=y
> CONFIG_X86_X2APIC=y
> CONFIG_X86_MPPARSE=y
> # CONFIG_GOLDFISH is not set
> # CONFIG_INTEL_RDT_A is not set
> CONFIG_X86_EXTENDED_PLATFORM=y
> # CONFIG_X86_NUMACHIP is not set
> # CONFIG_X86_VSMP is not set
> CONFIG_X86_UV=y
> # CONFIG_X86_GOLDFISH is not set
> # CONFIG_X86_INTEL_MID is not set
> CONFIG_X86_INTEL_LPSS=y
> # CONFIG_X86_AMD_PLATFORM_DEVICE is not set
> CONFIG_IOSF_MBI=y
> # CONFIG_IOSF_MBI_DEBUG is not set
> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> CONFIG_SCHED_OMIT_FRAME_POINTER=y
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> CONFIG_PARAVIRT_SPINLOCKS=y
> # CONFIG_QUEUED_LOCK_STAT is not set
> CONFIG_XEN=y
> CONFIG_XEN_DOM0=y
> CONFIG_XEN_PVHVM=y
> CONFIG_XEN_512GB=y
> CONFIG_XEN_SAVE_RESTORE=y
> # CONFIG_XEN_DEBUG_FS is not set
> # CONFIG_XEN_PVH is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_KVM_DEBUG_FS is not set
> CONFIG_PARAVIRT_TIME_ACCOUNTING=y
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> # CONFIG_MK8 is not set
> # CONFIG_MPSC is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> CONFIG_GENERIC_CPU=y
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=64
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> CONFIG_GART_IOMMU=y
> # CONFIG_CALGARY_IOMMU is not set
> CONFIG_SWIOTLB=y
> CONFIG_IOMMU_HELPER=y
> CONFIG_MAXSMP=y
> CONFIG_NR_CPUS=8192
> CONFIG_SCHED_SMT=y
> CONFIG_SCHED_MC=y
> CONFIG_SCHED_MC_PRIO=y
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> CONFIG_X86_MCE_AMD=y
> CONFIG_X86_MCE_THRESHOLD=y
> CONFIG_X86_MCE_INJECT=m
> CONFIG_X86_THERMAL_VECTOR=y
> 
> #
> # Performance monitoring
> #
> CONFIG_PERF_EVENTS_INTEL_UNCORE=y
> CONFIG_PERF_EVENTS_INTEL_RAPL=y
> CONFIG_PERF_EVENTS_INTEL_CSTATE=y
> # CONFIG_PERF_EVENTS_AMD_POWER is not set
> # CONFIG_VM86 is not set
> CONFIG_X86_16BIT=y
> CONFIG_X86_ESPFIX64=y
> CONFIG_X86_VSYSCALL_EMULATION=y
> CONFIG_I8K=m
> CONFIG_MICROCODE=y
> CONFIG_MICROCODE_INTEL=y
> CONFIG_MICROCODE_AMD=y
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_X86_MSR=y
> CONFIG_X86_CPUID=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> CONFIG_X86_DIRECT_GBPAGES=y
> CONFIG_NUMA=y
> CONFIG_AMD_NUMA=y
> CONFIG_X86_64_ACPI_NUMA=y
> CONFIG_NODES_SPAN_OTHER_NODES=y
> # CONFIG_NUMA_EMU is not set
> CONFIG_NODES_SHIFT=10
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ARCH_MEMORY_PROBE=y
> CONFIG_ARCH_PROC_KCORE_TEXT=y
> CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_NEED_MULTIPLE_NODES=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
> CONFIG_SPARSEMEM_VMEMMAP=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> CONFIG_MOVABLE_NODE=y
> CONFIG_HAVE_BOOTMEM_INFO_NODE=y
> CONFIG_MEMORY_HOTPLUG=y
> CONFIG_MEMORY_HOTPLUG_SPARSE=y
> # CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
> CONFIG_MEMORY_HOTREMOVE=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
> CONFIG_MEMORY_BALLOON=y
> CONFIG_BALLOON_COMPACTION=y
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_MMU_NOTIFIER=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> CONFIG_MEMORY_FAILURE=y
> CONFIG_HWPOISON_INJECT=m
> CONFIG_TRANSPARENT_HUGEPAGE=y
> CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
> # CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
> CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
> CONFIG_CLEANCACHE=y
> CONFIG_FRONTSWAP=y
> CONFIG_CMA=y
> # CONFIG_CMA_DEBUG is not set
> # CONFIG_CMA_DEBUGFS is not set
> CONFIG_CMA_AREAS=7
> CONFIG_ZSWAP=y
> CONFIG_ZPOOL=y
> CONFIG_ZBUD=y
> # CONFIG_Z3FOLD is not set
> CONFIG_ZSMALLOC=y
> # CONFIG_PGTABLE_MAPPING is not set
> # CONFIG_ZSMALLOC_STAT is not set
> CONFIG_GENERIC_EARLY_IOREMAP=y
> CONFIG_ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT=y
> CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
> # CONFIG_IDLE_PAGE_TRACKING is not set
> CONFIG_ZONE_DEVICE=y
> CONFIG_FRAME_VECTOR=y
> CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
> CONFIG_ARCH_HAS_PKEYS=y
> CONFIG_X86_PMEM_LEGACY_DEVICE=y
> CONFIG_X86_PMEM_LEGACY=y
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> # CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
> CONFIG_X86_RESERVE_LOW=64
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> CONFIG_ARCH_RANDOM=y
> CONFIG_X86_SMAP=y
> CONFIG_X86_INTEL_MPX=y
> CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
> CONFIG_EFI=y
> CONFIG_EFI_STUB=y
> # CONFIG_EFI_MIXED is not set
> CONFIG_SECCOMP=y
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> CONFIG_HZ_1000=y
> CONFIG_HZ=1000
> CONFIG_SCHED_HRTICK=y
> CONFIG_KEXEC=y
> CONFIG_KEXEC_FILE=y
> CONFIG_KEXEC_VERIFY_SIG=y
> CONFIG_KEXEC_BZIMAGE_VERIFY_SIG=y
> CONFIG_CRASH_DUMP=y
> CONFIG_KEXEC_JUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> CONFIG_RANDOMIZE_BASE=y
> CONFIG_X86_NEED_RELOCS=y
> CONFIG_PHYSICAL_ALIGN=0x1000000
> CONFIG_RANDOMIZE_MEMORY=y
> CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
> CONFIG_HOTPLUG_CPU=y
> CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
> # CONFIG_DEBUG_HOTPLUG_CPU0 is not set
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_LEGACY_VSYSCALL_NATIVE is not set
> CONFIG_LEGACY_VSYSCALL_EMULATE=y
> # CONFIG_LEGACY_VSYSCALL_NONE is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_MODIFY_LDT_SYSCALL=y
> CONFIG_HAVE_LIVEPATCH=y
> # CONFIG_LIVEPATCH is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
> CONFIG_USE_PERCPU_NUMA_NODE_ID=y
> 
> #
> # Power management and ACPI options
> #
> CONFIG_ARCH_HIBERNATION_HEADER=y
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_HIBERNATE_CALLBACKS=y
> CONFIG_HIBERNATION=y
> CONFIG_PM_STD_PARTITION=""
> CONFIG_PM_SLEEP=y
> CONFIG_PM_SLEEP_SMP=y
> # CONFIG_PM_AUTOSLEEP is not set
> # CONFIG_PM_WAKELOCKS is not set
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> CONFIG_PM_CLK=y
> # CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
> CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
> CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
> # CONFIG_ACPI_DEBUGGER is not set
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS_POWER is not set
> CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
> CONFIG_ACPI_EC_DEBUGFS=m
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_VIDEO=m
> CONFIG_ACPI_FAN=y
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_CPU_FREQ_PSS=y
> CONFIG_ACPI_PROCESSOR_CSTATE=y
> CONFIG_ACPI_PROCESSOR_IDLE=y
> CONFIG_ACPI_CPPC_LIB=y
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_IPMI=m
> CONFIG_ACPI_HOTPLUG_CPU=y
> CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
> CONFIG_ACPI_THERMAL=y
> CONFIG_ACPI_NUMA=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
> CONFIG_ACPI_TABLE_UPGRADE=y
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_PCI_SLOT=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> CONFIG_ACPI_HOTPLUG_MEMORY=y
> CONFIG_ACPI_HOTPLUG_IOAPIC=y
> CONFIG_ACPI_SBS=m
> CONFIG_ACPI_HED=y
> CONFIG_ACPI_CUSTOM_METHOD=m
> CONFIG_ACPI_BGRT=y
> # CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
> CONFIG_ACPI_NFIT=m
> # CONFIG_ACPI_NFIT_DEBUG is not set
> CONFIG_HAVE_ACPI_APEI=y
> CONFIG_HAVE_ACPI_APEI_NMI=y
> CONFIG_ACPI_APEI=y
> CONFIG_ACPI_APEI_GHES=y
> CONFIG_ACPI_APEI_PCIEAER=y
> CONFIG_ACPI_APEI_MEMORY_FAILURE=y
> CONFIG_ACPI_APEI_EINJ=m
> # CONFIG_ACPI_APEI_ERST_DEBUG is not set
> # CONFIG_DPTF_POWER is not set
> CONFIG_ACPI_EXTLOG=m
> # CONFIG_PMIC_OPREGION is not set
> # CONFIG_ACPI_CONFIGFS is not set
> CONFIG_SFI=y
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_GOV_ATTR_SET=y
> CONFIG_CPU_FREQ_GOV_COMMON=y
> # CONFIG_CPU_FREQ_STAT is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> # CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set
> 
> #
> # CPU frequency scaling drivers
> #
> CONFIG_X86_INTEL_PSTATE=y
> CONFIG_X86_PCC_CPUFREQ=m
> CONFIG_X86_ACPI_CPUFREQ=m
> CONFIG_X86_ACPI_CPUFREQ_CPB=y
> CONFIG_X86_POWERNOW_K8=m
> CONFIG_X86_AMD_FREQ_SENSITIVITY=m
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> CONFIG_X86_P4_CLOCKMOD=m
> 
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=m
> 
> #
> # CPU Idle
> #
> CONFIG_CPU_IDLE=y
> # CONFIG_CPU_IDLE_GOV_LADDER is not set
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> CONFIG_INTEL_IDLE=y
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_XEN=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCIEPORTBUS=y
> CONFIG_HOTPLUG_PCI_PCIE=y
> CONFIG_PCIEAER=y
> CONFIG_PCIE_ECRC=y
> CONFIG_PCIEAER_INJECT=m
> CONFIG_PCIEASPM=y
> # CONFIG_PCIEASPM_DEBUG is not set
> CONFIG_PCIEASPM_DEFAULT=y
> # CONFIG_PCIEASPM_POWERSAVE is not set
> # CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
> # CONFIG_PCIEASPM_PERFORMANCE is not set
> CONFIG_PCIE_PME=y
> # CONFIG_PCIE_DPC is not set
> # CONFIG_PCIE_PTM is not set
> CONFIG_PCI_BUS_ADDR_T_64BIT=y
> CONFIG_PCI_MSI=y
> CONFIG_PCI_MSI_IRQ_DOMAIN=y
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> CONFIG_PCI_STUB=y
> # CONFIG_XEN_PCIDEV_FRONTEND is not set
> CONFIG_HT_IRQ=y
> CONFIG_PCI_ATS=y
> CONFIG_PCI_IOV=y
> CONFIG_PCI_PRI=y
> CONFIG_PCI_PASID=y
> CONFIG_PCI_LABEL=y
> # CONFIG_PCI_HYPERV is not set
> CONFIG_HOTPLUG_PCI=y
> CONFIG_HOTPLUG_PCI_ACPI=y
> CONFIG_HOTPLUG_PCI_ACPI_IBM=m
> # CONFIG_HOTPLUG_PCI_CPCI is not set
> CONFIG_HOTPLUG_PCI_SHPC=m
> 
> #
> # DesignWare PCI Core Support
> #
> # CONFIG_PCIE_DW_PLAT is not set
> 
> #
> # PCI host controller drivers
> #
> # CONFIG_VMD is not set
> CONFIG_ISA_DMA_API=y
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=y
> # CONFIG_PCMCIA is not set
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> CONFIG_YENTA=m
> CONFIG_YENTA_O2=y
> CONFIG_YENTA_RICOH=y
> CONFIG_YENTA_TI=y
> CONFIG_YENTA_ENE_TUNE=y
> CONFIG_YENTA_TOSHIBA=y
> # CONFIG_RAPIDIO is not set
> # CONFIG_X86_SYSFB is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_COMPAT_BINFMT_ELF=y
> CONFIG_ELFCORE=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> CONFIG_BINFMT_SCRIPT=y
> # CONFIG_HAVE_AOUT is not set
> CONFIG_BINFMT_MISC=m
> CONFIG_COREDUMP=y
> CONFIG_IA32_EMULATION=y
> # CONFIG_IA32_AOUT is not set
> # CONFIG_X86_X32 is not set
> CONFIG_COMPAT_32=y
> CONFIG_COMPAT=y
> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> CONFIG_SYSVIPC_COMPAT=y
> CONFIG_KEYS_COMPAT=y
> CONFIG_X86_DEV_DMA_OPS=y
> CONFIG_NET=y
> CONFIG_COMPAT_NETLINK_MESSAGES=y
> CONFIG_NET_INGRESS=y
> CONFIG_NET_EGRESS=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_DIAG=m
> CONFIG_UNIX=y
> CONFIG_UNIX_DIAG=m
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=y
> CONFIG_XFRM_USER=y
> CONFIG_XFRM_SUB_POLICY=y
> CONFIG_XFRM_MIGRATE=y
> CONFIG_XFRM_STATISTICS=y
> CONFIG_XFRM_IPCOMP=m
> CONFIG_NET_KEY=m
> CONFIG_NET_KEY_MIGRATE=y
> # CONFIG_SMC is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_IP_FIB_TRIE_STATS=y
> CONFIG_IP_MULTIPLE_TABLES=y
> CONFIG_IP_ROUTE_MULTIPATH=y
> CONFIG_IP_ROUTE_VERBOSE=y
> CONFIG_IP_ROUTE_CLASSID=y
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=m
> CONFIG_NET_IPGRE_DEMUX=m
> CONFIG_NET_IP_TUNNEL=m
> CONFIG_NET_IPGRE=m
> CONFIG_NET_IPGRE_BROADCAST=y
> CONFIG_IP_MROUTE=y
> CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
> CONFIG_IP_PIMSM_V1=y
> CONFIG_IP_PIMSM_V2=y
> CONFIG_SYN_COOKIES=y
> CONFIG_NET_IPVTI=m
> CONFIG_NET_UDP_TUNNEL=m
> # CONFIG_NET_FOU is not set
> # CONFIG_NET_FOU_IP_TUNNELS is not set
> CONFIG_INET_AH=m
> CONFIG_INET_ESP=m
> # CONFIG_INET_ESP_OFFLOAD is not set
> CONFIG_INET_IPCOMP=m
> CONFIG_INET_XFRM_TUNNEL=m
> CONFIG_INET_TUNNEL=m
> CONFIG_INET_XFRM_MODE_TRANSPORT=m
> CONFIG_INET_XFRM_MODE_TUNNEL=m
> CONFIG_INET_XFRM_MODE_BEET=m
> CONFIG_INET_DIAG=m
> CONFIG_INET_TCP_DIAG=m
> CONFIG_INET_UDP_DIAG=m
> # CONFIG_INET_RAW_DIAG is not set
> # CONFIG_INET_DIAG_DESTROY is not set
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=m
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_TCP_CONG_WESTWOOD=m
> CONFIG_TCP_CONG_HTCP=m
> CONFIG_TCP_CONG_HSTCP=m
> CONFIG_TCP_CONG_HYBLA=m
> CONFIG_TCP_CONG_VEGAS=m
> # CONFIG_TCP_CONG_NV is not set
> CONFIG_TCP_CONG_SCALABLE=m
> CONFIG_TCP_CONG_LP=m
> CONFIG_TCP_CONG_VENO=m
> CONFIG_TCP_CONG_YEAH=m
> CONFIG_TCP_CONG_ILLINOIS=m
> CONFIG_TCP_CONG_DCTCP=m
> # CONFIG_TCP_CONG_CDG is not set
> # CONFIG_TCP_CONG_BBR is not set
> CONFIG_DEFAULT_CUBIC=y
> # CONFIG_DEFAULT_RENO is not set
> CONFIG_DEFAULT_TCP_CONG="cubic"
> CONFIG_TCP_MD5SIG=y
> CONFIG_IPV6=y
> CONFIG_IPV6_ROUTER_PREF=y
> CONFIG_IPV6_ROUTE_INFO=y
> CONFIG_IPV6_OPTIMISTIC_DAD=y
> CONFIG_INET6_AH=m
> CONFIG_INET6_ESP=m
> # CONFIG_INET6_ESP_OFFLOAD is not set
> CONFIG_INET6_IPCOMP=m
> CONFIG_IPV6_MIP6=m
> # CONFIG_IPV6_ILA is not set
> CONFIG_INET6_XFRM_TUNNEL=m
> CONFIG_INET6_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_TRANSPORT=m
> CONFIG_INET6_XFRM_MODE_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_BEET=m
> CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
> CONFIG_IPV6_VTI=m
> CONFIG_IPV6_SIT=m
> CONFIG_IPV6_SIT_6RD=y
> CONFIG_IPV6_NDISC_NODETYPE=y
> CONFIG_IPV6_TUNNEL=m
> CONFIG_IPV6_GRE=m
> # CONFIG_IPV6_FOU is not set
> # CONFIG_IPV6_FOU_TUNNEL is not set
> CONFIG_IPV6_MULTIPLE_TABLES=y
> # CONFIG_IPV6_SUBTREES is not set
> CONFIG_IPV6_MROUTE=y
> CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
> CONFIG_IPV6_PIMSM_V2=y
> # CONFIG_IPV6_SEG6_LWTUNNEL is not set
> # CONFIG_IPV6_SEG6_HMAC is not set
> CONFIG_NETLABEL=y
> CONFIG_NETWORK_SECMARK=y
> CONFIG_NET_PTP_CLASSIFY=y
> CONFIG_NETWORK_PHY_TIMESTAMPING=y
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=y
> CONFIG_BRIDGE_NETFILTER=m
> 
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_INGRESS=y
> CONFIG_NETFILTER_NETLINK=m
> CONFIG_NETFILTER_NETLINK_ACCT=m
> CONFIG_NETFILTER_NETLINK_QUEUE=m
> CONFIG_NETFILTER_NETLINK_LOG=m
> CONFIG_NF_CONNTRACK=m
> CONFIG_NF_LOG_COMMON=m
> # CONFIG_NF_LOG_NETDEV is not set
> CONFIG_NF_CONNTRACK_MARK=y
> CONFIG_NF_CONNTRACK_SECMARK=y
> CONFIG_NF_CONNTRACK_ZONES=y
> CONFIG_NF_CONNTRACK_PROCFS=y
> CONFIG_NF_CONNTRACK_EVENTS=y
> # CONFIG_NF_CONNTRACK_TIMEOUT is not set
> CONFIG_NF_CONNTRACK_TIMESTAMP=y
> CONFIG_NF_CONNTRACK_LABELS=y
> CONFIG_NF_CT_PROTO_DCCP=y
> CONFIG_NF_CT_PROTO_GRE=m
> CONFIG_NF_CT_PROTO_SCTP=y
> CONFIG_NF_CT_PROTO_UDPLITE=y
> CONFIG_NF_CONNTRACK_AMANDA=m
> CONFIG_NF_CONNTRACK_FTP=m
> CONFIG_NF_CONNTRACK_H323=m
> CONFIG_NF_CONNTRACK_IRC=m
> CONFIG_NF_CONNTRACK_BROADCAST=m
> CONFIG_NF_CONNTRACK_NETBIOS_NS=m
> CONFIG_NF_CONNTRACK_SNMP=m
> CONFIG_NF_CONNTRACK_PPTP=m
> CONFIG_NF_CONNTRACK_SANE=m
> CONFIG_NF_CONNTRACK_SIP=m
> CONFIG_NF_CONNTRACK_TFTP=m
> CONFIG_NF_CT_NETLINK=m
> # CONFIG_NF_CT_NETLINK_TIMEOUT is not set
> # CONFIG_NETFILTER_NETLINK_GLUE_CT is not set
> CONFIG_NF_NAT=m
> CONFIG_NF_NAT_NEEDED=y
> CONFIG_NF_NAT_PROTO_DCCP=y
> CONFIG_NF_NAT_PROTO_UDPLITE=y
> CONFIG_NF_NAT_PROTO_SCTP=y
> CONFIG_NF_NAT_AMANDA=m
> CONFIG_NF_NAT_FTP=m
> CONFIG_NF_NAT_IRC=m
> CONFIG_NF_NAT_SIP=m
> CONFIG_NF_NAT_TFTP=m
> CONFIG_NF_NAT_REDIRECT=m
> CONFIG_NETFILTER_SYNPROXY=m
> CONFIG_NF_TABLES=m
> CONFIG_NF_TABLES_INET=m
> # CONFIG_NF_TABLES_NETDEV is not set
> CONFIG_NFT_EXTHDR=m
> CONFIG_NFT_META=m
> # CONFIG_NFT_RT is not set
> # CONFIG_NFT_NUMGEN is not set
> CONFIG_NFT_CT=m
> # CONFIG_NFT_SET_RBTREE is not set
> # CONFIG_NFT_SET_HASH is not set
> # CONFIG_NFT_SET_BITMAP is not set
> CONFIG_NFT_COUNTER=m
> CONFIG_NFT_LOG=m
> CONFIG_NFT_LIMIT=m
> # CONFIG_NFT_MASQ is not set
> # CONFIG_NFT_REDIR is not set
> CONFIG_NFT_NAT=m
> # CONFIG_NFT_OBJREF is not set
> CONFIG_NFT_QUEUE=m
> # CONFIG_NFT_QUOTA is not set
> # CONFIG_NFT_REJECT is not set
> # CONFIG_NFT_REJECT_INET is not set
> CONFIG_NFT_COMPAT=m
> CONFIG_NFT_HASH=m
> CONFIG_NETFILTER_XTABLES=y
> 
> #
> # Xtables combined modules
> #
> CONFIG_NETFILTER_XT_MARK=m
> CONFIG_NETFILTER_XT_CONNMARK=m
> CONFIG_NETFILTER_XT_SET=m
> 
> #
> # Xtables targets
> #
> CONFIG_NETFILTER_XT_TARGET_AUDIT=m
> CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
> CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
> CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
> CONFIG_NETFILTER_XT_TARGET_CT=m
> CONFIG_NETFILTER_XT_TARGET_DSCP=m
> CONFIG_NETFILTER_XT_TARGET_HL=m
> CONFIG_NETFILTER_XT_TARGET_HMARK=m
> CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
> CONFIG_NETFILTER_XT_TARGET_LED=m
> CONFIG_NETFILTER_XT_TARGET_LOG=m
> CONFIG_NETFILTER_XT_TARGET_MARK=m
> CONFIG_NETFILTER_XT_NAT=m
> CONFIG_NETFILTER_XT_TARGET_NETMAP=m
> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
> CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
> CONFIG_NETFILTER_XT_TARGET_RATEEST=m
> CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
> CONFIG_NETFILTER_XT_TARGET_TEE=m
> CONFIG_NETFILTER_XT_TARGET_TPROXY=m
> CONFIG_NETFILTER_XT_TARGET_TRACE=m
> CONFIG_NETFILTER_XT_TARGET_SECMARK=m
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
> CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
> 
> #
> # Xtables matches
> #
> CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
> CONFIG_NETFILTER_XT_MATCH_BPF=m
> CONFIG_NETFILTER_XT_MATCH_CGROUP=m
> CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
> CONFIG_NETFILTER_XT_MATCH_COMMENT=m
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
> CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
> CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
> CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
> CONFIG_NETFILTER_XT_MATCH_CPU=m
> CONFIG_NETFILTER_XT_MATCH_DCCP=m
> CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
> CONFIG_NETFILTER_XT_MATCH_DSCP=m
> CONFIG_NETFILTER_XT_MATCH_ECN=m
> CONFIG_NETFILTER_XT_MATCH_ESP=m
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
> CONFIG_NETFILTER_XT_MATCH_HELPER=m
> CONFIG_NETFILTER_XT_MATCH_HL=m
> # CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
> CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
> CONFIG_NETFILTER_XT_MATCH_IPVS=m
> CONFIG_NETFILTER_XT_MATCH_L2TP=m
> CONFIG_NETFILTER_XT_MATCH_LENGTH=m
> CONFIG_NETFILTER_XT_MATCH_LIMIT=m
> CONFIG_NETFILTER_XT_MATCH_MAC=m
> CONFIG_NETFILTER_XT_MATCH_MARK=m
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
> CONFIG_NETFILTER_XT_MATCH_NFACCT=m
> CONFIG_NETFILTER_XT_MATCH_OSF=m
> CONFIG_NETFILTER_XT_MATCH_OWNER=m
> CONFIG_NETFILTER_XT_MATCH_POLICY=m
> CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
> CONFIG_NETFILTER_XT_MATCH_QUOTA=m
> CONFIG_NETFILTER_XT_MATCH_RATEEST=m
> CONFIG_NETFILTER_XT_MATCH_REALM=m
> CONFIG_NETFILTER_XT_MATCH_RECENT=m
> CONFIG_NETFILTER_XT_MATCH_SCTP=m
> CONFIG_NETFILTER_XT_MATCH_STATE=m
> CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
> CONFIG_NETFILTER_XT_MATCH_STRING=m
> CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
> CONFIG_NETFILTER_XT_MATCH_TIME=m
> CONFIG_NETFILTER_XT_MATCH_U32=m
> CONFIG_IP_SET=m
> CONFIG_IP_SET_MAX=256
> CONFIG_IP_SET_BITMAP_IP=m
> CONFIG_IP_SET_BITMAP_IPMAC=m
> CONFIG_IP_SET_BITMAP_PORT=m
> CONFIG_IP_SET_HASH_IP=m
> # CONFIG_IP_SET_HASH_IPMARK is not set
> CONFIG_IP_SET_HASH_IPPORT=m
> CONFIG_IP_SET_HASH_IPPORTIP=m
> CONFIG_IP_SET_HASH_IPPORTNET=m
> # CONFIG_IP_SET_HASH_IPMAC is not set
> # CONFIG_IP_SET_HASH_MAC is not set
> # CONFIG_IP_SET_HASH_NETPORTNET is not set
> CONFIG_IP_SET_HASH_NET=m
> # CONFIG_IP_SET_HASH_NETNET is not set
> CONFIG_IP_SET_HASH_NETPORT=m
> CONFIG_IP_SET_HASH_NETIFACE=m
> CONFIG_IP_SET_LIST_SET=m
> CONFIG_IP_VS=m
> CONFIG_IP_VS_IPV6=y
> # CONFIG_IP_VS_DEBUG is not set
> CONFIG_IP_VS_TAB_BITS=12
> 
> #
> # IPVS transport protocol load balancing support
> #
> CONFIG_IP_VS_PROTO_TCP=y
> CONFIG_IP_VS_PROTO_UDP=y
> CONFIG_IP_VS_PROTO_AH_ESP=y
> CONFIG_IP_VS_PROTO_ESP=y
> CONFIG_IP_VS_PROTO_AH=y
> CONFIG_IP_VS_PROTO_SCTP=y
> 
> #
> # IPVS scheduler
> #
> CONFIG_IP_VS_RR=m
> CONFIG_IP_VS_WRR=m
> CONFIG_IP_VS_LC=m
> CONFIG_IP_VS_WLC=m
> # CONFIG_IP_VS_FO is not set
> # CONFIG_IP_VS_OVF is not set
> CONFIG_IP_VS_LBLC=m
> CONFIG_IP_VS_LBLCR=m
> CONFIG_IP_VS_DH=m
> CONFIG_IP_VS_SH=m
> CONFIG_IP_VS_SED=m
> CONFIG_IP_VS_NQ=m
> 
> #
> # IPVS SH scheduler
> #
> CONFIG_IP_VS_SH_TAB_BITS=8
> 
> #
> # IPVS application helper
> #
> CONFIG_IP_VS_FTP=m
> CONFIG_IP_VS_NFCT=y
> CONFIG_IP_VS_PE_SIP=m
> 
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV4=m
> CONFIG_NF_CONNTRACK_IPV4=m
> # CONFIG_NF_SOCKET_IPV4 is not set
> CONFIG_NF_TABLES_IPV4=m
> CONFIG_NFT_CHAIN_ROUTE_IPV4=m
> # CONFIG_NFT_REJECT_IPV4 is not set
> # CONFIG_NFT_DUP_IPV4 is not set
> # CONFIG_NFT_FIB_IPV4 is not set
> # CONFIG_NF_TABLES_ARP is not set
> CONFIG_NF_DUP_IPV4=m
> # CONFIG_NF_LOG_ARP is not set
> CONFIG_NF_LOG_IPV4=m
> CONFIG_NF_REJECT_IPV4=m
> CONFIG_NF_NAT_IPV4=m
> CONFIG_NFT_CHAIN_NAT_IPV4=m
> CONFIG_NF_NAT_MASQUERADE_IPV4=m
> CONFIG_NF_NAT_SNMP_BASIC=m
> CONFIG_NF_NAT_PROTO_GRE=m
> CONFIG_NF_NAT_PPTP=m
> CONFIG_NF_NAT_H323=m
> CONFIG_IP_NF_IPTABLES=m
> CONFIG_IP_NF_MATCH_AH=m
> CONFIG_IP_NF_MATCH_ECN=m
> CONFIG_IP_NF_MATCH_RPFILTER=m
> CONFIG_IP_NF_MATCH_TTL=m
> CONFIG_IP_NF_FILTER=m
> CONFIG_IP_NF_TARGET_REJECT=m
> CONFIG_IP_NF_TARGET_SYNPROXY=m
> CONFIG_IP_NF_NAT=m
> CONFIG_IP_NF_TARGET_MASQUERADE=m
> CONFIG_IP_NF_TARGET_NETMAP=m
> CONFIG_IP_NF_TARGET_REDIRECT=m
> CONFIG_IP_NF_MANGLE=m
> CONFIG_IP_NF_TARGET_CLUSTERIP=m
> CONFIG_IP_NF_TARGET_ECN=m
> CONFIG_IP_NF_TARGET_TTL=m
> CONFIG_IP_NF_RAW=m
> CONFIG_IP_NF_SECURITY=m
> CONFIG_IP_NF_ARPTABLES=m
> CONFIG_IP_NF_ARPFILTER=m
> CONFIG_IP_NF_ARP_MANGLE=m
> 
> #
> # IPv6: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV6=m
> CONFIG_NF_CONNTRACK_IPV6=m
> # CONFIG_NF_SOCKET_IPV6 is not set
> CONFIG_NF_TABLES_IPV6=m
> CONFIG_NFT_CHAIN_ROUTE_IPV6=m
> # CONFIG_NFT_REJECT_IPV6 is not set
> # CONFIG_NFT_DUP_IPV6 is not set
> # CONFIG_NFT_FIB_IPV6 is not set
> CONFIG_NF_DUP_IPV6=m
> CONFIG_NF_REJECT_IPV6=m
> CONFIG_NF_LOG_IPV6=m
> CONFIG_NF_NAT_IPV6=m
> CONFIG_NFT_CHAIN_NAT_IPV6=m
> CONFIG_NF_NAT_MASQUERADE_IPV6=m
> CONFIG_IP6_NF_IPTABLES=m
> CONFIG_IP6_NF_MATCH_AH=m
> CONFIG_IP6_NF_MATCH_EUI64=m
> CONFIG_IP6_NF_MATCH_FRAG=m
> CONFIG_IP6_NF_MATCH_OPTS=m
> CONFIG_IP6_NF_MATCH_HL=m
> CONFIG_IP6_NF_MATCH_IPV6HEADER=m
> CONFIG_IP6_NF_MATCH_MH=m
> CONFIG_IP6_NF_MATCH_RPFILTER=m
> CONFIG_IP6_NF_MATCH_RT=m
> CONFIG_IP6_NF_TARGET_HL=m
> CONFIG_IP6_NF_FILTER=m
> CONFIG_IP6_NF_TARGET_REJECT=m
> CONFIG_IP6_NF_TARGET_SYNPROXY=m
> CONFIG_IP6_NF_MANGLE=m
> CONFIG_IP6_NF_RAW=m
> CONFIG_IP6_NF_SECURITY=m
> CONFIG_IP6_NF_NAT=m
> CONFIG_IP6_NF_TARGET_MASQUERADE=m
> # CONFIG_IP6_NF_TARGET_NPT is not set
> CONFIG_NF_TABLES_BRIDGE=m
> CONFIG_NFT_BRIDGE_META=m
> # CONFIG_NF_LOG_BRIDGE is not set
> CONFIG_BRIDGE_NF_EBTABLES=m
> CONFIG_BRIDGE_EBT_BROUTE=m
> CONFIG_BRIDGE_EBT_T_FILTER=m
> CONFIG_BRIDGE_EBT_T_NAT=m
> CONFIG_BRIDGE_EBT_802_3=m
> CONFIG_BRIDGE_EBT_AMONG=m
> CONFIG_BRIDGE_EBT_ARP=m
> CONFIG_BRIDGE_EBT_IP=m
> CONFIG_BRIDGE_EBT_IP6=m
> CONFIG_BRIDGE_EBT_LIMIT=m
> CONFIG_BRIDGE_EBT_MARK=m
> CONFIG_BRIDGE_EBT_PKTTYPE=m
> CONFIG_BRIDGE_EBT_STP=m
> CONFIG_BRIDGE_EBT_VLAN=m
> CONFIG_BRIDGE_EBT_ARPREPLY=m
> CONFIG_BRIDGE_EBT_DNAT=m
> CONFIG_BRIDGE_EBT_MARK_T=m
> CONFIG_BRIDGE_EBT_REDIRECT=m
> CONFIG_BRIDGE_EBT_SNAT=m
> CONFIG_BRIDGE_EBT_LOG=m
> CONFIG_BRIDGE_EBT_NFLOG=m
> CONFIG_IP_DCCP=m
> CONFIG_INET_DCCP_DIAG=m
> 
> #
> # DCCP CCIDs Configuration
> #
> # CONFIG_IP_DCCP_CCID2_DEBUG is not set
> CONFIG_IP_DCCP_CCID3=y
> # CONFIG_IP_DCCP_CCID3_DEBUG is not set
> CONFIG_IP_DCCP_TFRC_LIB=y
> 
> #
> # DCCP Kernel Hacking
> #
> # CONFIG_IP_DCCP_DEBUG is not set
> # CONFIG_NET_DCCPPROBE is not set
> CONFIG_IP_SCTP=m
> CONFIG_NET_SCTPPROBE=m
> # CONFIG_SCTP_DBG_OBJCNT is not set
> # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
> CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
> # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
> CONFIG_SCTP_COOKIE_HMAC_MD5=y
> CONFIG_SCTP_COOKIE_HMAC_SHA1=y
> CONFIG_INET_SCTP_DIAG=m
> # CONFIG_RDS is not set
> # CONFIG_TIPC is not set
> CONFIG_ATM=m
> CONFIG_ATM_CLIP=m
> # CONFIG_ATM_CLIP_NO_ICMP is not set
> CONFIG_ATM_LANE=m
> # CONFIG_ATM_MPOA is not set
> CONFIG_ATM_BR2684=m
> # CONFIG_ATM_BR2684_IPFILTER is not set
> CONFIG_L2TP=m
> CONFIG_L2TP_DEBUGFS=m
> CONFIG_L2TP_V3=y
> CONFIG_L2TP_IP=m
> CONFIG_L2TP_ETH=m
> CONFIG_STP=m
> CONFIG_GARP=m
> CONFIG_MRP=m
> CONFIG_BRIDGE=m
> CONFIG_BRIDGE_IGMP_SNOOPING=y
> CONFIG_BRIDGE_VLAN_FILTERING=y
> CONFIG_HAVE_NET_DSA=y
> # CONFIG_NET_DSA is not set
> CONFIG_VLAN_8021Q=m
> CONFIG_VLAN_8021Q_GVRP=y
> CONFIG_VLAN_8021Q_MVRP=y
> # CONFIG_DECNET is not set
> CONFIG_LLC=m
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_PHONET is not set
> CONFIG_6LOWPAN=m
> # CONFIG_6LOWPAN_DEBUGFS is not set
> CONFIG_6LOWPAN_NHC=m
> CONFIG_6LOWPAN_NHC_DEST=m
> CONFIG_6LOWPAN_NHC_FRAGMENT=m
> CONFIG_6LOWPAN_NHC_HOP=m
> CONFIG_6LOWPAN_NHC_IPV6=m
> CONFIG_6LOWPAN_NHC_MOBILITY=m
> CONFIG_6LOWPAN_NHC_ROUTING=m
> CONFIG_6LOWPAN_NHC_UDP=m
> # CONFIG_6LOWPAN_GHC_EXT_HDR_HOP is not set
> # CONFIG_6LOWPAN_GHC_UDP is not set
> # CONFIG_6LOWPAN_GHC_ICMPV6 is not set
> # CONFIG_6LOWPAN_GHC_EXT_HDR_DEST is not set
> # CONFIG_6LOWPAN_GHC_EXT_HDR_FRAG is not set
> # CONFIG_6LOWPAN_GHC_EXT_HDR_ROUTE is not set
> CONFIG_IEEE802154=m
> # CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
> CONFIG_IEEE802154_SOCKET=m
> CONFIG_IEEE802154_6LOWPAN=m
> CONFIG_MAC802154=m
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> CONFIG_NET_SCH_CBQ=m
> CONFIG_NET_SCH_HTB=m
> CONFIG_NET_SCH_HFSC=m
> CONFIG_NET_SCH_ATM=m
> CONFIG_NET_SCH_PRIO=m
> CONFIG_NET_SCH_MULTIQ=m
> CONFIG_NET_SCH_RED=m
> CONFIG_NET_SCH_SFB=m
> CONFIG_NET_SCH_SFQ=m
> CONFIG_NET_SCH_TEQL=m
> CONFIG_NET_SCH_TBF=m
> CONFIG_NET_SCH_GRED=m
> CONFIG_NET_SCH_DSMARK=m
> CONFIG_NET_SCH_NETEM=m
> CONFIG_NET_SCH_DRR=m
> CONFIG_NET_SCH_MQPRIO=m
> CONFIG_NET_SCH_CHOKE=m
> CONFIG_NET_SCH_QFQ=m
> CONFIG_NET_SCH_CODEL=m
> CONFIG_NET_SCH_FQ_CODEL=m
> CONFIG_NET_SCH_FQ=m
> # CONFIG_NET_SCH_HHF is not set
> # CONFIG_NET_SCH_PIE is not set
> CONFIG_NET_SCH_INGRESS=m
> CONFIG_NET_SCH_PLUG=m
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> CONFIG_NET_CLS_BASIC=m
> CONFIG_NET_CLS_TCINDEX=m
> CONFIG_NET_CLS_ROUTE4=m
> CONFIG_NET_CLS_FW=m
> CONFIG_NET_CLS_U32=m
> CONFIG_CLS_U32_PERF=y
> CONFIG_CLS_U32_MARK=y
> CONFIG_NET_CLS_RSVP=m
> CONFIG_NET_CLS_RSVP6=m
> CONFIG_NET_CLS_FLOW=m
> CONFIG_NET_CLS_CGROUP=y
> CONFIG_NET_CLS_BPF=m
> # CONFIG_NET_CLS_FLOWER is not set
> # CONFIG_NET_CLS_MATCHALL is not set
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> CONFIG_NET_EMATCH_CMP=m
> CONFIG_NET_EMATCH_NBYTE=m
> CONFIG_NET_EMATCH_U32=m
> CONFIG_NET_EMATCH_META=m
> CONFIG_NET_EMATCH_TEXT=m
> # CONFIG_NET_EMATCH_CANID is not set
> CONFIG_NET_EMATCH_IPSET=m
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=m
> CONFIG_NET_ACT_GACT=m
> CONFIG_GACT_PROB=y
> CONFIG_NET_ACT_MIRRED=m
> # CONFIG_NET_ACT_SAMPLE is not set
> CONFIG_NET_ACT_IPT=m
> CONFIG_NET_ACT_NAT=m
> CONFIG_NET_ACT_PEDIT=m
> CONFIG_NET_ACT_SIMP=m
> CONFIG_NET_ACT_SKBEDIT=m
> CONFIG_NET_ACT_CSUM=m
> # CONFIG_NET_ACT_VLAN is not set
> # CONFIG_NET_ACT_BPF is not set
> # CONFIG_NET_ACT_CONNMARK is not set
> # CONFIG_NET_ACT_SKBMOD is not set
> # CONFIG_NET_ACT_IFE is not set
> # CONFIG_NET_ACT_TUNNEL_KEY is not set
> CONFIG_NET_CLS_IND=y
> CONFIG_NET_SCH_FIFO=y
> CONFIG_DCB=y
> CONFIG_DNS_RESOLVER=m
> # CONFIG_BATMAN_ADV is not set
> CONFIG_OPENVSWITCH=m
> CONFIG_OPENVSWITCH_GRE=m
> CONFIG_OPENVSWITCH_VXLAN=m
> CONFIG_VSOCKETS=m
> CONFIG_VMWARE_VMCI_VSOCKETS=m
> # CONFIG_VIRTIO_VSOCKETS is not set
> CONFIG_NETLINK_DIAG=m
> CONFIG_MPLS=y
> CONFIG_NET_MPLS_GSO=m
> # CONFIG_MPLS_ROUTING is not set
> # CONFIG_HSR is not set
> # CONFIG_NET_SWITCHDEV is not set
> # CONFIG_NET_L3_MASTER_DEV is not set
> # CONFIG_NET_NCSI is not set
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> # CONFIG_CGROUP_NET_PRIO is not set
> CONFIG_CGROUP_NET_CLASSID=y
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> CONFIG_BPF_JIT=y
> CONFIG_NET_FLOW_LIMIT=y
> 
> #
> # Network testing
> #
> CONFIG_NET_PKTGEN=m
> # CONFIG_NET_TCPPROBE is not set
> CONFIG_NET_DROP_MONITOR=y
> # CONFIG_HAMRADIO is not set
> CONFIG_CAN=m
> CONFIG_CAN_RAW=m
> CONFIG_CAN_BCM=m
> CONFIG_CAN_GW=m
> 
> #
> # CAN Device Drivers
> #
> CONFIG_CAN_VCAN=m
> CONFIG_CAN_SLCAN=m
> CONFIG_CAN_DEV=m
> CONFIG_CAN_CALC_BITTIMING=y
> CONFIG_CAN_LEDS=y
> CONFIG_CAN_C_CAN=m
> CONFIG_CAN_C_CAN_PLATFORM=m
> CONFIG_CAN_C_CAN_PCI=m
> CONFIG_CAN_CC770=m
> # CONFIG_CAN_CC770_ISA is not set
> CONFIG_CAN_CC770_PLATFORM=m
> # CONFIG_CAN_IFI_CANFD is not set
> # CONFIG_CAN_M_CAN is not set
> CONFIG_CAN_SJA1000=m
> # CONFIG_CAN_SJA1000_ISA is not set
> CONFIG_CAN_SJA1000_PLATFORM=m
> CONFIG_CAN_EMS_PCI=m
> CONFIG_CAN_PEAK_PCI=m
> CONFIG_CAN_PEAK_PCIEC=y
> CONFIG_CAN_KVASER_PCI=m
> CONFIG_CAN_PLX_PCI=m
> CONFIG_CAN_SOFTING=m
> 
> #
> # CAN USB interfaces
> #
> CONFIG_CAN_EMS_USB=m
> CONFIG_CAN_ESD_USB2=m
> # CONFIG_CAN_GS_USB is not set
> CONFIG_CAN_KVASER_USB=m
> CONFIG_CAN_PEAK_USB=m
> CONFIG_CAN_8DEV_USB=m
> # CONFIG_CAN_DEBUG_DEVICES is not set
> # CONFIG_IRDA is not set
> CONFIG_BT=m
> CONFIG_BT_BREDR=y
> CONFIG_BT_RFCOMM=m
> CONFIG_BT_RFCOMM_TTY=y
> CONFIG_BT_BNEP=m
> CONFIG_BT_BNEP_MC_FILTER=y
> CONFIG_BT_BNEP_PROTO_FILTER=y
> CONFIG_BT_CMTP=m
> CONFIG_BT_HIDP=m
> CONFIG_BT_HS=y
> CONFIG_BT_LE=y
> # CONFIG_BT_6LOWPAN is not set
> # CONFIG_BT_LEDS is not set
> # CONFIG_BT_SELFTEST is not set
> CONFIG_BT_DEBUGFS=y
> 
> #
> # Bluetooth device drivers
> #
> CONFIG_BT_INTEL=m
> CONFIG_BT_BCM=m
> CONFIG_BT_RTL=m
> CONFIG_BT_HCIBTUSB=m
> CONFIG_BT_HCIBTUSB_BCM=y
> CONFIG_BT_HCIBTUSB_RTL=y
> CONFIG_BT_HCIBTSDIO=m
> CONFIG_BT_HCIUART=m
> CONFIG_BT_HCIUART_H4=y
> CONFIG_BT_HCIUART_BCSP=y
> CONFIG_BT_HCIUART_ATH3K=y
> CONFIG_BT_HCIUART_LL=y
> CONFIG_BT_HCIUART_3WIRE=y
> # CONFIG_BT_HCIUART_INTEL is not set
> # CONFIG_BT_HCIUART_BCM is not set
> # CONFIG_BT_HCIUART_QCA is not set
> # CONFIG_BT_HCIUART_AG6XX is not set
> # CONFIG_BT_HCIUART_MRVL is not set
> CONFIG_BT_HCIBCM203X=m
> CONFIG_BT_HCIBPA10X=m
> CONFIG_BT_HCIBFUSB=m
> CONFIG_BT_HCIVHCI=m
> CONFIG_BT_MRVL=m
> CONFIG_BT_MRVL_SDIO=m
> CONFIG_BT_ATH3K=m
> # CONFIG_AF_RXRPC is not set
> # CONFIG_AF_KCM is not set
> # CONFIG_STREAM_PARSER is not set
> CONFIG_FIB_RULES=y
> CONFIG_WIRELESS=y
> CONFIG_WIRELESS_EXT=y
> CONFIG_WEXT_CORE=y
> CONFIG_WEXT_PROC=y
> CONFIG_WEXT_PRIV=y
> CONFIG_CFG80211=m
> # CONFIG_NL80211_TESTMODE is not set
> # CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
> CONFIG_CFG80211_DEFAULT_PS=y
> # CONFIG_CFG80211_DEBUGFS is not set
> # CONFIG_CFG80211_INTERNAL_REGDB is not set
> CONFIG_CFG80211_CRDA_SUPPORT=y
> CONFIG_CFG80211_WEXT=y
> CONFIG_LIB80211=m
> # CONFIG_LIB80211_DEBUG is not set
> CONFIG_MAC80211=m
> CONFIG_MAC80211_HAS_RC=y
> CONFIG_MAC80211_RC_MINSTREL=y
> CONFIG_MAC80211_RC_MINSTREL_HT=y
> # CONFIG_MAC80211_RC_MINSTREL_VHT is not set
> CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
> CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
> # CONFIG_MAC80211_MESH is not set
> CONFIG_MAC80211_LEDS=y
> CONFIG_MAC80211_DEBUGFS=y
> # CONFIG_MAC80211_MESSAGE_TRACING is not set
> # CONFIG_MAC80211_DEBUG_MENU is not set
> CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
> # CONFIG_WIMAX is not set
> CONFIG_RFKILL=m
> CONFIG_RFKILL_LEDS=y
> CONFIG_RFKILL_INPUT=y
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> CONFIG_CEPH_LIB=m
> # CONFIG_CEPH_LIB_PRETTYDEBUG is not set
> CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
> # CONFIG_NFC is not set
> # CONFIG_PSAMPLE is not set
> # CONFIG_NET_IFE is not set
> # CONFIG_LWTUNNEL is not set
> CONFIG_DST_CACHE=y
> CONFIG_GRO_CELLS=y
> # CONFIG_NET_DEVLINK is not set
> CONFIG_MAY_USE_DEVLINK=y
> CONFIG_HAVE_EBPF_JIT=y
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER=y
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_DEVTMPFS=y
> CONFIG_DEVTMPFS_MOUNT=y
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
> CONFIG_WANT_DEV_COREDUMP=y
> CONFIG_ALLOW_DEV_COREDUMP=y
> CONFIG_DEV_COREDUMP=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
> # CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
> CONFIG_SYS_HYPERVISOR=y
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=m
> CONFIG_DMA_SHARED_BUFFER=y
> # CONFIG_DMA_FENCE_TRACE is not set
> # CONFIG_DMA_CMA is not set
> 
> #
> # Bus devices
> #
> CONFIG_CONNECTOR=y
> CONFIG_PROC_EVENTS=y
> CONFIG_MTD=m
> # CONFIG_MTD_TESTS is not set
> # CONFIG_MTD_REDBOOT_PARTS is not set
> # CONFIG_MTD_CMDLINE_PARTS is not set
> # CONFIG_MTD_AR7_PARTS is not set
> 
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_BLKDEVS=m
> CONFIG_MTD_BLOCK=m
> # CONFIG_MTD_BLOCK_RO is not set
> # CONFIG_FTL is not set
> # CONFIG_NFTL is not set
> # CONFIG_INFTL is not set
> # CONFIG_RFD_FTL is not set
> # CONFIG_SSFDC is not set
> # CONFIG_SM_FTL is not set
> # CONFIG_MTD_OOPS is not set
> # CONFIG_MTD_SWAP is not set
> # CONFIG_MTD_PARTITIONED_MASTER is not set
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> # CONFIG_MTD_CFI is not set
> # CONFIG_MTD_JEDECPROBE is not set
> CONFIG_MTD_MAP_BANK_WIDTH_1=y
> CONFIG_MTD_MAP_BANK_WIDTH_2=y
> CONFIG_MTD_MAP_BANK_WIDTH_4=y
> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
> CONFIG_MTD_CFI_I1=y
> CONFIG_MTD_CFI_I2=y
> # CONFIG_MTD_CFI_I4 is not set
> # CONFIG_MTD_CFI_I8 is not set
> # CONFIG_MTD_RAM is not set
> # CONFIG_MTD_ROM is not set
> # CONFIG_MTD_ABSENT is not set
> 
> #
> # Mapping drivers for chip access
> #
> # CONFIG_MTD_COMPLEX_MAPPINGS is not set
> # CONFIG_MTD_INTEL_VR_NOR is not set
> # CONFIG_MTD_PLATRAM is not set
> 
> #
> # Self-contained MTD device drivers
> #
> # CONFIG_MTD_PMC551 is not set
> # CONFIG_MTD_SLRAM is not set
> # CONFIG_MTD_PHRAM is not set
> # CONFIG_MTD_MTDRAM is not set
> # CONFIG_MTD_BLOCK2MTD is not set
> 
> #
> # Disk-On-Chip Device Drivers
> #
> # CONFIG_MTD_DOCG3 is not set
> # CONFIG_MTD_NAND is not set
> # CONFIG_MTD_ONENAND is not set
> 
> #
> # LPDDR & LPDDR2 PCM memory drivers
> #
> # CONFIG_MTD_LPDDR is not set
> # CONFIG_MTD_SPI_NOR is not set
> CONFIG_MTD_UBI=m
> CONFIG_MTD_UBI_WL_THRESHOLD=4096
> CONFIG_MTD_UBI_BEB_LIMIT=20
> # CONFIG_MTD_UBI_FASTMAP is not set
> # CONFIG_MTD_UBI_GLUEBI is not set
> # CONFIG_MTD_UBI_BLOCK is not set
> # CONFIG_OF is not set
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PARPORT=m
> CONFIG_PARPORT_PC=m
> CONFIG_PARPORT_SERIAL=m
> # CONFIG_PARPORT_PC_FIFO is not set
> # CONFIG_PARPORT_PC_SUPERIO is not set
> # CONFIG_PARPORT_GSC is not set
> # CONFIG_PARPORT_AX88796 is not set
> CONFIG_PARPORT_1284=y
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG_MESSAGES is not set
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_NULL_BLK=m
> CONFIG_BLK_DEV_FD=m
> # CONFIG_PARIDE is not set
> CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
> CONFIG_ZRAM=m
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=m
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> # CONFIG_BLK_DEV_DRBD is not set
> CONFIG_BLK_DEV_NBD=m
> # CONFIG_BLK_DEV_SKD is not set
> CONFIG_BLK_DEV_OSD=m
> CONFIG_BLK_DEV_SX8=m
> CONFIG_BLK_DEV_RAM=m
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=16384
> CONFIG_BLK_DEV_RAM_DAX=y
> CONFIG_CDROM_PKTCDVD=m
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> # CONFIG_CDROM_PKTCDVD_WCACHE is not set
> CONFIG_ATA_OVER_ETH=m
> CONFIG_XEN_BLKDEV_FRONTEND=m
> # CONFIG_XEN_BLKDEV_BACKEND is not set
> CONFIG_VIRTIO_BLK=m
> # CONFIG_VIRTIO_BLK_SCSI is not set
> # CONFIG_BLK_DEV_HD is not set
> CONFIG_BLK_DEV_RBD=m
> # CONFIG_BLK_DEV_RSXX is not set
> CONFIG_NVME_CORE=m
> CONFIG_BLK_DEV_NVME=m
> # CONFIG_BLK_DEV_NVME_SCSI is not set
> # CONFIG_NVME_RDMA is not set
> # CONFIG_NVME_FC is not set
> # CONFIG_NVME_TARGET is not set
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=m
> # CONFIG_AD525X_DPOT is not set
> # CONFIG_DUMMY_IRQ is not set
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> CONFIG_SGI_IOC4=m
> CONFIG_TIFM_CORE=m
> CONFIG_TIFM_7XX1=m
> # CONFIG_ICS932S401 is not set
> CONFIG_ENCLOSURE_SERVICES=m
> CONFIG_SGI_XP=m
> CONFIG_HP_ILO=m
> CONFIG_SGI_GRU=m
> # CONFIG_SGI_GRU_DEBUG is not set
> CONFIG_APDS9802ALS=m
> CONFIG_ISL29003=m
> CONFIG_ISL29020=m
> CONFIG_SENSORS_TSL2550=m
> CONFIG_SENSORS_BH1770=m
> CONFIG_SENSORS_APDS990X=m
> # CONFIG_HMC6352 is not set
> # CONFIG_DS1682 is not set
> CONFIG_VMWARE_BALLOON=m
> # CONFIG_USB_SWITCH_FSA9480 is not set
> # CONFIG_SRAM is not set
> # CONFIG_PANEL is not set
> # CONFIG_C2PORT is not set
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=m
> CONFIG_EEPROM_LEGACY=m
> CONFIG_EEPROM_MAX6875=m
> CONFIG_EEPROM_93CX6=m
> # CONFIG_EEPROM_IDT_89HPESX is not set
> CONFIG_CB710_CORE=m
> # CONFIG_CB710_DEBUG is not set
> CONFIG_CB710_DEBUG_ASSUMPTIONS=y
> 
> #
> # Texas Instruments shared transport line discipline
> #
> CONFIG_SENSORS_LIS3_I2C=m
> 
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=m
> CONFIG_INTEL_MEI=m
> CONFIG_INTEL_MEI_ME=m
> # CONFIG_INTEL_MEI_TXE is not set
> CONFIG_VMWARE_VMCI=m
> 
> #
> # Intel MIC Bus Driver
> #
> # CONFIG_INTEL_MIC_BUS is not set
> 
> #
> # SCIF Bus Driver
> #
> # CONFIG_SCIF_BUS is not set
> 
> #
> # VOP Bus Driver
> #
> # CONFIG_VOP_BUS is not set
> 
> #
> # Intel MIC Host Driver
> #
> 
> #
> # Intel MIC Card Driver
> #
> 
> #
> # SCIF Driver
> #
> 
> #
> # Intel MIC Coprocessor State Management (COSM) Drivers
> #
> 
> #
> # VOP Driver
> #
> # CONFIG_GENWQE is not set
> # CONFIG_ECHO is not set
> # CONFIG_CXL_BASE is not set
> # CONFIG_CXL_AFU_DRIVER_OPS is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> CONFIG_RAID_ATTRS=m
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_NETLINK=y
> # CONFIG_SCSI_MQ_DEFAULT is not set
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=m
> CONFIG_CHR_DEV_ST=m
> CONFIG_CHR_DEV_OSST=m
> CONFIG_BLK_DEV_SR=m
> CONFIG_BLK_DEV_SR_VENDOR=y
> CONFIG_CHR_DEV_SG=m
> CONFIG_CHR_DEV_SCH=m
> CONFIG_SCSI_ENCLOSURE=m
> CONFIG_SCSI_CONSTANTS=y
> CONFIG_SCSI_LOGGING=y
> CONFIG_SCSI_SCAN_ASYNC=y
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=m
> CONFIG_SCSI_FC_ATTRS=m
> CONFIG_SCSI_ISCSI_ATTRS=m
> CONFIG_SCSI_SAS_ATTRS=m
> CONFIG_SCSI_SAS_LIBSAS=m
> CONFIG_SCSI_SAS_ATA=y
> CONFIG_SCSI_SAS_HOST_SMP=y
> CONFIG_SCSI_SRP_ATTRS=m
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ISCSI_TCP=m
> CONFIG_ISCSI_BOOT_SYSFS=m
> CONFIG_SCSI_CXGB3_ISCSI=m
> CONFIG_SCSI_CXGB4_ISCSI=m
> CONFIG_SCSI_BNX2_ISCSI=m
> CONFIG_SCSI_BNX2X_FCOE=m
> CONFIG_BE2ISCSI=m
> # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> CONFIG_SCSI_HPSA=m
> CONFIG_SCSI_3W_9XXX=m
> CONFIG_SCSI_3W_SAS=m
> # CONFIG_SCSI_ACARD is not set
> CONFIG_SCSI_AACRAID=m
> # CONFIG_SCSI_AIC7XXX is not set
> CONFIG_SCSI_AIC79XX=m
> CONFIG_AIC79XX_CMDS_PER_DEVICE=4
> CONFIG_AIC79XX_RESET_DELAY_MS=15000
> # CONFIG_AIC79XX_DEBUG_ENABLE is not set
> CONFIG_AIC79XX_DEBUG_MASK=0
> # CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
> # CONFIG_SCSI_AIC94XX is not set
> CONFIG_SCSI_MVSAS=m
> # CONFIG_SCSI_MVSAS_DEBUG is not set
> CONFIG_SCSI_MVSAS_TASKLET=y
> CONFIG_SCSI_MVUMI=m
> # CONFIG_SCSI_DPT_I2O is not set
> # CONFIG_SCSI_ADVANSYS is not set
> CONFIG_SCSI_ARCMSR=m
> # CONFIG_SCSI_ESAS2R is not set
> # CONFIG_MEGARAID_NEWGEN is not set
> # CONFIG_MEGARAID_LEGACY is not set
> CONFIG_MEGARAID_SAS=m
> CONFIG_SCSI_MPT3SAS=m
> CONFIG_SCSI_MPT2SAS_MAX_SGE=128
> CONFIG_SCSI_MPT3SAS_MAX_SGE=128
> CONFIG_SCSI_MPT2SAS=m
> # CONFIG_SCSI_SMARTPQI is not set
> CONFIG_SCSI_UFSHCD=m
> CONFIG_SCSI_UFSHCD_PCI=m
> # CONFIG_SCSI_UFS_DWC_TC_PCI is not set
> # CONFIG_SCSI_UFSHCD_PLATFORM is not set
> CONFIG_SCSI_HPTIOP=m
> # CONFIG_SCSI_BUSLOGIC is not set
> CONFIG_VMWARE_PVSCSI=m
> # CONFIG_XEN_SCSI_FRONTEND is not set
> CONFIG_HYPERV_STORAGE=m
> CONFIG_LIBFC=m
> CONFIG_LIBFCOE=m
> CONFIG_FCOE=m
> CONFIG_FCOE_FNIC=m
> # CONFIG_SCSI_SNIC is not set
> # CONFIG_SCSI_DMX3191D is not set
> # CONFIG_SCSI_EATA is not set
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> # CONFIG_SCSI_GDTH is not set
> CONFIG_SCSI_ISCI=m
> # CONFIG_SCSI_IPS is not set
> CONFIG_SCSI_INITIO=m
> # CONFIG_SCSI_INIA100 is not set
> # CONFIG_SCSI_PPA is not set
> # CONFIG_SCSI_IMM is not set
> CONFIG_SCSI_STEX=m
> # CONFIG_SCSI_SYM53C8XX_2 is not set
> # CONFIG_SCSI_IPR is not set
> # CONFIG_SCSI_QLOGIC_1280 is not set
> CONFIG_SCSI_QLA_FC=m
> # CONFIG_TCM_QLA2XXX is not set
> CONFIG_SCSI_QLA_ISCSI=m
> # CONFIG_SCSI_LPFC is not set
> # CONFIG_SCSI_DC395x is not set
> # CONFIG_SCSI_AM53C974 is not set
> # CONFIG_SCSI_WD719X is not set
> CONFIG_SCSI_DEBUG=m
> CONFIG_SCSI_PMCRAID=m
> CONFIG_SCSI_PM8001=m
> CONFIG_SCSI_BFA_FC=m
> CONFIG_SCSI_VIRTIO=m
> # CONFIG_SCSI_CHELSIO_FCOE is not set
> CONFIG_SCSI_DH=y
> CONFIG_SCSI_DH_RDAC=y
> CONFIG_SCSI_DH_HP_SW=y
> CONFIG_SCSI_DH_EMC=y
> CONFIG_SCSI_DH_ALUA=y
> CONFIG_SCSI_OSD_INITIATOR=m
> CONFIG_SCSI_OSD_ULD=m
> CONFIG_SCSI_OSD_DPRINT_SENSE=1
> # CONFIG_SCSI_OSD_DEBUG is not set
> CONFIG_ATA=m
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_ATA_ACPI=y
> # CONFIG_SATA_ZPODD is not set
> CONFIG_SATA_PMP=y
> 
> #
> # Controllers with non-SFF native interface
> #
> CONFIG_SATA_AHCI=m
> CONFIG_SATA_AHCI_PLATFORM=m
> # CONFIG_SATA_INIC162X is not set
> CONFIG_SATA_ACARD_AHCI=m
> CONFIG_SATA_SIL24=m
> CONFIG_ATA_SFF=y
> 
> #
> # SFF controllers with custom DMA interface
> #
> CONFIG_PDC_ADMA=m
> CONFIG_SATA_QSTOR=m
> CONFIG_SATA_SX4=m
> CONFIG_ATA_BMDMA=y
> 
> #
> # SATA SFF controllers with BMDMA
> #
> CONFIG_ATA_PIIX=m
> # CONFIG_SATA_DWC is not set
> CONFIG_SATA_MV=m
> CONFIG_SATA_NV=m
> CONFIG_SATA_PROMISE=m
> CONFIG_SATA_SIL=m
> CONFIG_SATA_SIS=m
> CONFIG_SATA_SVW=m
> CONFIG_SATA_ULI=m
> CONFIG_SATA_VIA=m
> CONFIG_SATA_VITESSE=m
> 
> #
> # PATA SFF controllers with BMDMA
> #
> CONFIG_PATA_ALI=m
> CONFIG_PATA_AMD=m
> CONFIG_PATA_ARTOP=m
> CONFIG_PATA_ATIIXP=m
> CONFIG_PATA_ATP867X=m
> CONFIG_PATA_CMD64X=m
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> CONFIG_PATA_HPT366=m
> CONFIG_PATA_HPT37X=m
> CONFIG_PATA_HPT3X2N=m
> CONFIG_PATA_HPT3X3=m
> # CONFIG_PATA_HPT3X3_DMA is not set
> CONFIG_PATA_IT8213=m
> CONFIG_PATA_IT821X=m
> CONFIG_PATA_JMICRON=m
> CONFIG_PATA_MARVELL=m
> CONFIG_PATA_NETCELL=m
> CONFIG_PATA_NINJA32=m
> # CONFIG_PATA_NS87415 is not set
> CONFIG_PATA_OLDPIIX=m
> # CONFIG_PATA_OPTIDMA is not set
> CONFIG_PATA_PDC2027X=m
> CONFIG_PATA_PDC_OLD=m
> # CONFIG_PATA_RADISYS is not set
> CONFIG_PATA_RDC=m
> CONFIG_PATA_SCH=m
> CONFIG_PATA_SERVERWORKS=m
> CONFIG_PATA_SIL680=m
> CONFIG_PATA_SIS=m
> CONFIG_PATA_TOSHIBA=m
> # CONFIG_PATA_TRIFLEX is not set
> CONFIG_PATA_VIA=m
> # CONFIG_PATA_WINBOND is not set
> 
> #
> # PIO-only SFF controllers
> #
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_RZ1000 is not set
> 
> #
> # Generic fallback / legacy drivers
> #
> CONFIG_PATA_ACPI=m
> CONFIG_ATA_GENERIC=m
> # CONFIG_PATA_LEGACY is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=y
> CONFIG_MD_AUTODETECT=y
> CONFIG_MD_LINEAR=m
> CONFIG_MD_RAID0=m
> CONFIG_MD_RAID1=m
> CONFIG_MD_RAID10=m
> CONFIG_MD_RAID456=m
> # CONFIG_MD_MULTIPATH is not set
> CONFIG_MD_FAULTY=m
> # CONFIG_MD_CLUSTER is not set
> # CONFIG_BCACHE is not set
> CONFIG_BLK_DEV_DM_BUILTIN=y
> CONFIG_BLK_DEV_DM=m
> # CONFIG_DM_MQ_DEFAULT is not set
> CONFIG_DM_DEBUG=y
> CONFIG_DM_BUFIO=m
> # CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
> CONFIG_DM_BIO_PRISON=m
> CONFIG_DM_PERSISTENT_DATA=m
> CONFIG_DM_CRYPT=m
> CONFIG_DM_SNAPSHOT=m
> CONFIG_DM_THIN_PROVISIONING=m
> CONFIG_DM_CACHE=m
> CONFIG_DM_CACHE_SMQ=m
> CONFIG_DM_CACHE_CLEANER=m
> CONFIG_DM_ERA=m
> CONFIG_DM_MIRROR=m
> CONFIG_DM_LOG_USERSPACE=m
> CONFIG_DM_RAID=m
> CONFIG_DM_ZERO=m
> CONFIG_DM_MULTIPATH=m
> CONFIG_DM_MULTIPATH_QL=m
> CONFIG_DM_MULTIPATH_ST=m
> CONFIG_DM_DELAY=m
> CONFIG_DM_UEVENT=y
> CONFIG_DM_FLAKEY=m
> CONFIG_DM_VERITY=m
> # CONFIG_DM_VERITY_FEC is not set
> CONFIG_DM_SWITCH=m
> # CONFIG_DM_LOG_WRITES is not set
> CONFIG_TARGET_CORE=m
> CONFIG_TCM_IBLOCK=m
> CONFIG_TCM_FILEIO=m
> CONFIG_TCM_PSCSI=m
> # CONFIG_TCM_USER2 is not set
> CONFIG_LOOPBACK_TARGET=m
> CONFIG_TCM_FC=m
> CONFIG_ISCSI_TARGET=m
> # CONFIG_ISCSI_TARGET_CXGB4 is not set
> # CONFIG_SBP_TARGET is not set
> CONFIG_FUSION=y
> CONFIG_FUSION_SPI=m
> # CONFIG_FUSION_FC is not set
> CONFIG_FUSION_SAS=m
> CONFIG_FUSION_MAX_SGE=128
> CONFIG_FUSION_CTL=m
> CONFIG_FUSION_LOGGING=y
> 
> #
> # IEEE 1394 (FireWire) support
> #
> CONFIG_FIREWIRE=m
> CONFIG_FIREWIRE_OHCI=m
> CONFIG_FIREWIRE_SBP2=m
> CONFIG_FIREWIRE_NET=m
> # CONFIG_FIREWIRE_NOSY is not set
> CONFIG_MACINTOSH_DRIVERS=y
> CONFIG_MAC_EMUMOUSEBTN=y
> CONFIG_NETDEVICES=y
> CONFIG_MII=m
> CONFIG_NET_CORE=y
> CONFIG_BONDING=m
> CONFIG_DUMMY=m
> # CONFIG_EQUALIZER is not set
> CONFIG_NET_FC=y
> CONFIG_IFB=m
> CONFIG_NET_TEAM=m
> CONFIG_NET_TEAM_MODE_BROADCAST=m
> CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
> CONFIG_NET_TEAM_MODE_RANDOM=m
> CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
> CONFIG_NET_TEAM_MODE_LOADBALANCE=m
> CONFIG_MACVLAN=m
> CONFIG_MACVTAP=m
> CONFIG_VXLAN=m
> # CONFIG_GENEVE is not set
> # CONFIG_GTP is not set
> # CONFIG_MACSEC is not set
> CONFIG_NETCONSOLE=m
> CONFIG_NETCONSOLE_DYNAMIC=y
> CONFIG_NETPOLL=y
> CONFIG_NET_POLL_CONTROLLER=y
> CONFIG_TUN=m
> CONFIG_TAP=m
> # CONFIG_TUN_VNET_CROSS_LE is not set
> CONFIG_VETH=m
> CONFIG_VIRTIO_NET=m
> CONFIG_NLMON=m
> # CONFIG_ARCNET is not set
> # CONFIG_ATM_DRIVERS is not set
> 
> #
> # CAIF transport drivers
> #
> 
> #
> # Distributed Switch Architecture drivers
> #
> CONFIG_ETHERNET=y
> CONFIG_MDIO=m
> # CONFIG_NET_VENDOR_3COM is not set
> # CONFIG_NET_VENDOR_ADAPTEC is not set
> CONFIG_NET_VENDOR_AGERE=y
> # CONFIG_ET131X is not set
> CONFIG_NET_VENDOR_ALACRITECH=y
> # CONFIG_SLICOSS is not set
> # CONFIG_NET_VENDOR_ALTEON is not set
> # CONFIG_ALTERA_TSE is not set
> CONFIG_NET_VENDOR_AMAZON=y
> # CONFIG_ENA_ETHERNET is not set
> # CONFIG_NET_VENDOR_AMD is not set
> CONFIG_NET_VENDOR_AQUANTIA=y
> # CONFIG_AQTION is not set
> CONFIG_NET_VENDOR_ARC=y
> CONFIG_NET_VENDOR_ATHEROS=y
> CONFIG_ATL2=m
> CONFIG_ATL1=m
> CONFIG_ATL1E=m
> CONFIG_ATL1C=m
> CONFIG_ALX=m
> # CONFIG_NET_VENDOR_AURORA is not set
> CONFIG_NET_CADENCE=y
> CONFIG_MACB=m
> # CONFIG_MACB_PCI is not set
> CONFIG_NET_VENDOR_BROADCOM=y
> CONFIG_B44=m
> CONFIG_B44_PCI_AUTOSELECT=y
> CONFIG_B44_PCICORE_AUTOSELECT=y
> CONFIG_B44_PCI=y
> # CONFIG_BCMGENET is not set
> CONFIG_BNX2=m
> CONFIG_CNIC=m
> CONFIG_TIGON3=m
> CONFIG_BNX2X=m
> CONFIG_BNX2X_SRIOV=y
> # CONFIG_BNXT is not set
> CONFIG_NET_VENDOR_BROCADE=y
> CONFIG_BNA=m
> CONFIG_NET_VENDOR_CAVIUM=y
> # CONFIG_THUNDER_NIC_PF is not set
> # CONFIG_THUNDER_NIC_VF is not set
> # CONFIG_THUNDER_NIC_BGX is not set
> # CONFIG_THUNDER_NIC_RGX is not set
> # CONFIG_LIQUIDIO is not set
> # CONFIG_LIQUIDIO_VF is not set
> CONFIG_NET_VENDOR_CHELSIO=y
> # CONFIG_CHELSIO_T1 is not set
> CONFIG_CHELSIO_T3=m
> CONFIG_CHELSIO_T4=m
> # CONFIG_CHELSIO_T4_DCB is not set
> CONFIG_CHELSIO_T4VF=m
> CONFIG_CHELSIO_LIB=m
> CONFIG_NET_VENDOR_CISCO=y
> CONFIG_ENIC=m
> # CONFIG_CX_ECAT is not set
> CONFIG_DNET=m
> CONFIG_NET_VENDOR_DEC=y
> CONFIG_NET_TULIP=y
> CONFIG_DE2104X=m
> CONFIG_DE2104X_DSL=0
> CONFIG_TULIP=m
> # CONFIG_TULIP_MWI is not set
> CONFIG_TULIP_MMIO=y
> # CONFIG_TULIP_NAPI is not set
> CONFIG_DE4X5=m
> CONFIG_WINBOND_840=m
> CONFIG_DM9102=m
> CONFIG_ULI526X=m
> CONFIG_PCMCIA_XIRCOM=m
> # CONFIG_NET_VENDOR_DLINK is not set
> CONFIG_NET_VENDOR_EMULEX=y
> CONFIG_BE2NET=m
> CONFIG_BE2NET_HWMON=y
> CONFIG_NET_VENDOR_EZCHIP=y
> # CONFIG_NET_VENDOR_EXAR is not set
> # CONFIG_NET_VENDOR_HP is not set
> CONFIG_NET_VENDOR_INTEL=y
> # CONFIG_E100 is not set
> CONFIG_E1000=m
> CONFIG_E1000E=m
> CONFIG_E1000E_HWTS=y
> CONFIG_IGB=m
> CONFIG_IGB_HWMON=y
> CONFIG_IGB_DCA=y
> CONFIG_IGBVF=m
> # CONFIG_IXGB is not set
> CONFIG_IXGBE=m
> CONFIG_IXGBE_HWMON=y
> CONFIG_IXGBE_DCA=y
> CONFIG_IXGBE_DCB=y
> CONFIG_IXGBEVF=m
> CONFIG_I40E=m
> CONFIG_I40E_DCB=y
> # CONFIG_I40E_FCOE is not set
> CONFIG_I40EVF=m
> CONFIG_FM10K=m
> # CONFIG_NET_VENDOR_I825XX is not set
> CONFIG_JME=m
> CONFIG_NET_VENDOR_MARVELL=y
> CONFIG_MVMDIO=m
> CONFIG_SKGE=m
> # CONFIG_SKGE_DEBUG is not set
> CONFIG_SKGE_GENESIS=y
> CONFIG_SKY2=m
> # CONFIG_SKY2_DEBUG is not set
> CONFIG_NET_VENDOR_MELLANOX=y
> CONFIG_MLX4_EN=m
> CONFIG_MLX4_EN_DCB=y
> CONFIG_MLX4_CORE=m
> CONFIG_MLX4_DEBUG=y
> CONFIG_MLX5_CORE=m
> CONFIG_MLX5_CORE_EN=y
> CONFIG_MLX5_CORE_EN_DCB=y
> # CONFIG_MLXSW_CORE is not set
> # CONFIG_NET_VENDOR_MICREL is not set
> CONFIG_NET_VENDOR_MYRI=y
> CONFIG_MYRI10GE=m
> CONFIG_MYRI10GE_DCA=y
> # CONFIG_FEALNX is not set
> # CONFIG_NET_VENDOR_NATSEMI is not set
> CONFIG_NET_VENDOR_NETRONOME=y
> # CONFIG_NFP is not set
> # CONFIG_NET_VENDOR_NVIDIA is not set
> CONFIG_NET_VENDOR_OKI=y
> CONFIG_ETHOC=m
> CONFIG_NET_PACKET_ENGINE=y
> # CONFIG_HAMACHI is not set
> # CONFIG_YELLOWFIN is not set
> CONFIG_NET_VENDOR_QLOGIC=y
> CONFIG_QLA3XXX=m
> CONFIG_QLCNIC=m
> CONFIG_QLCNIC_SRIOV=y
> CONFIG_QLCNIC_DCB=y
> CONFIG_QLCNIC_HWMON=y
> CONFIG_QLGE=m
> CONFIG_NETXEN_NIC=m
> # CONFIG_QED is not set
> CONFIG_NET_VENDOR_QUALCOMM=y
> # CONFIG_QCOM_EMAC is not set
> CONFIG_NET_VENDOR_REALTEK=y
> # CONFIG_ATP is not set
> CONFIG_8139CP=m
> CONFIG_8139TOO=m
> # CONFIG_8139TOO_PIO is not set
> # CONFIG_8139TOO_TUNE_TWISTER is not set
> CONFIG_8139TOO_8129=y
> # CONFIG_8139_OLD_RX_RESET is not set
> CONFIG_R8169=m
> CONFIG_NET_VENDOR_RENESAS=y
> # CONFIG_NET_VENDOR_RDC is not set
> CONFIG_NET_VENDOR_ROCKER=y
> CONFIG_NET_VENDOR_SAMSUNG=y
> # CONFIG_SXGBE_ETH is not set
> # CONFIG_NET_VENDOR_SEEQ is not set
> # CONFIG_NET_VENDOR_SILAN is not set
> # CONFIG_NET_VENDOR_SIS is not set
> CONFIG_NET_VENDOR_SOLARFLARE=y
> CONFIG_SFC=m
> CONFIG_SFC_MTD=y
> CONFIG_SFC_MCDI_MON=y
> CONFIG_SFC_SRIOV=y
> CONFIG_SFC_MCDI_LOGGING=y
> # CONFIG_SFC_FALCON is not set
> CONFIG_NET_VENDOR_SMSC=y
> CONFIG_EPIC100=m
> # CONFIG_SMSC911X is not set
> CONFIG_SMSC9420=m
> # CONFIG_NET_VENDOR_STMICRO is not set
> # CONFIG_NET_VENDOR_SUN is not set
> # CONFIG_NET_VENDOR_TEHUTI is not set
> CONFIG_NET_VENDOR_TI=y
> # CONFIG_TI_CPSW_ALE is not set
> CONFIG_TLAN=m
> # CONFIG_NET_VENDOR_VIA is not set
> # CONFIG_NET_VENDOR_WIZNET is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_NET_SB1000 is not set
> CONFIG_PHYLIB=y
> CONFIG_SWPHY=y
> # CONFIG_LED_TRIGGER_PHY is not set
> 
> #
> # MDIO bus device drivers
> #
> # CONFIG_MDIO_BCM_UNIMAC is not set
> CONFIG_MDIO_BITBANG=m
> # CONFIG_MDIO_OCTEON is not set
> # CONFIG_MDIO_THUNDER is not set
> 
> #
> # MII PHY device drivers
> #
> CONFIG_AMD_PHY=m
> # CONFIG_AQUANTIA_PHY is not set
> CONFIG_AT803X_PHY=m
> # CONFIG_BCM7XXX_PHY is not set
> CONFIG_BCM87XX_PHY=m
> CONFIG_BCM_NET_PHYLIB=m
> CONFIG_BROADCOM_PHY=m
> CONFIG_CICADA_PHY=m
> CONFIG_DAVICOM_PHY=m
> # CONFIG_DP83848_PHY is not set
> # CONFIG_DP83867_PHY is not set
> CONFIG_FIXED_PHY=y
> CONFIG_ICPLUS_PHY=m
> # CONFIG_INTEL_XWAY_PHY is not set
> CONFIG_LSI_ET1011C_PHY=m
> CONFIG_LXT_PHY=m
> CONFIG_MARVELL_PHY=m
> CONFIG_MICREL_PHY=m
> # CONFIG_MICROCHIP_PHY is not set
> # CONFIG_MICROSEMI_PHY is not set
> CONFIG_NATIONAL_PHY=m
> CONFIG_QSEMI_PHY=m
> CONFIG_REALTEK_PHY=m
> CONFIG_SMSC_PHY=m
> CONFIG_STE10XP=m
> # CONFIG_TERANETICS_PHY is not set
> CONFIG_VITESSE_PHY=m
> # CONFIG_XILINX_GMII2RGMII is not set
> # CONFIG_PLIP is not set
> CONFIG_PPP=m
> CONFIG_PPP_BSDCOMP=m
> CONFIG_PPP_DEFLATE=m
> CONFIG_PPP_FILTER=y
> CONFIG_PPP_MPPE=m
> CONFIG_PPP_MULTILINK=y
> CONFIG_PPPOATM=m
> CONFIG_PPPOE=m
> CONFIG_PPTP=m
> CONFIG_PPPOL2TP=m
> CONFIG_PPP_ASYNC=m
> CONFIG_PPP_SYNC_TTY=m
> CONFIG_SLIP=m
> CONFIG_SLHC=m
> CONFIG_SLIP_COMPRESSED=y
> CONFIG_SLIP_SMART=y
> # CONFIG_SLIP_MODE_SLIP6 is not set
> CONFIG_USB_NET_DRIVERS=y
> CONFIG_USB_CATC=m
> CONFIG_USB_KAWETH=m
> CONFIG_USB_PEGASUS=m
> CONFIG_USB_RTL8150=m
> CONFIG_USB_RTL8152=m
> # CONFIG_USB_LAN78XX is not set
> CONFIG_USB_USBNET=m
> CONFIG_USB_NET_AX8817X=m
> CONFIG_USB_NET_AX88179_178A=m
> CONFIG_USB_NET_CDCETHER=m
> CONFIG_USB_NET_CDC_EEM=m
> CONFIG_USB_NET_CDC_NCM=m
> CONFIG_USB_NET_HUAWEI_CDC_NCM=m
> CONFIG_USB_NET_CDC_MBIM=m
> CONFIG_USB_NET_DM9601=m
> # CONFIG_USB_NET_SR9700 is not set
> # CONFIG_USB_NET_SR9800 is not set
> CONFIG_USB_NET_SMSC75XX=m
> CONFIG_USB_NET_SMSC95XX=m
> CONFIG_USB_NET_GL620A=m
> CONFIG_USB_NET_NET1080=m
> CONFIG_USB_NET_PLUSB=m
> CONFIG_USB_NET_MCS7830=m
> CONFIG_USB_NET_RNDIS_HOST=m
> CONFIG_USB_NET_CDC_SUBSET_ENABLE=m
> CONFIG_USB_NET_CDC_SUBSET=m
> CONFIG_USB_ALI_M5632=y
> CONFIG_USB_AN2720=y
> CONFIG_USB_BELKIN=y
> CONFIG_USB_ARMLINUX=y
> CONFIG_USB_EPSON2888=y
> CONFIG_USB_KC2190=y
> CONFIG_USB_NET_ZAURUS=m
> CONFIG_USB_NET_CX82310_ETH=m
> CONFIG_USB_NET_KALMIA=m
> CONFIG_USB_NET_QMI_WWAN=m
> CONFIG_USB_HSO=m
> CONFIG_USB_NET_INT51X1=m
> CONFIG_USB_IPHETH=m
> CONFIG_USB_SIERRA_NET=m
> CONFIG_USB_VL600=m
> # CONFIG_USB_NET_CH9200 is not set
> CONFIG_WLAN=y
> CONFIG_WLAN_VENDOR_ADMTEK=y
> # CONFIG_ADM8211 is not set
> CONFIG_WLAN_VENDOR_ATH=y
> # CONFIG_ATH_DEBUG is not set
> # CONFIG_ATH5K is not set
> # CONFIG_ATH5K_PCI is not set
> # CONFIG_ATH9K is not set
> # CONFIG_ATH9K_HTC is not set
> # CONFIG_CARL9170 is not set
> # CONFIG_ATH6KL is not set
> # CONFIG_AR5523 is not set
> # CONFIG_WIL6210 is not set
> # CONFIG_ATH10K is not set
> # CONFIG_WCN36XX is not set
> CONFIG_WLAN_VENDOR_ATMEL=y
> # CONFIG_ATMEL is not set
> # CONFIG_AT76C50X_USB is not set
> CONFIG_WLAN_VENDOR_BROADCOM=y
> # CONFIG_B43 is not set
> # CONFIG_B43LEGACY is not set
> CONFIG_BRCMUTIL=m
> CONFIG_BRCMSMAC=m
> CONFIG_BRCMFMAC=m
> CONFIG_BRCMFMAC_PROTO_BCDC=y
> CONFIG_BRCMFMAC_SDIO=y
> CONFIG_BRCMFMAC_USB=y
> # CONFIG_BRCMFMAC_PCIE is not set
> # CONFIG_BRCM_TRACING is not set
> # CONFIG_BRCMDBG is not set
> CONFIG_WLAN_VENDOR_CISCO=y
> # CONFIG_AIRO is not set
> CONFIG_WLAN_VENDOR_INTEL=y
> # CONFIG_IPW2100 is not set
> # CONFIG_IPW2200 is not set
> CONFIG_IWLEGACY=m
> CONFIG_IWL4965=m
> CONFIG_IWL3945=m
> 
> #
> # iwl3945 / iwl4965 Debugging Options
> #
> CONFIG_IWLEGACY_DEBUG=y
> CONFIG_IWLEGACY_DEBUGFS=y
> CONFIG_IWLWIFI=m
> CONFIG_IWLWIFI_LEDS=y
> CONFIG_IWLDVM=m
> CONFIG_IWLMVM=m
> CONFIG_IWLWIFI_OPMODE_MODULAR=y
> # CONFIG_IWLWIFI_BCAST_FILTERING is not set
> 
> #
> # Debugging Options
> #
> # CONFIG_IWLWIFI_DEBUG is not set
> CONFIG_IWLWIFI_DEBUGFS=y
> # CONFIG_IWLWIFI_DEVICE_TRACING is not set
> CONFIG_WLAN_VENDOR_INTERSIL=y
> # CONFIG_HOSTAP is not set
> # CONFIG_HERMES is not set
> # CONFIG_P54_COMMON is not set
> # CONFIG_PRISM54 is not set
> CONFIG_WLAN_VENDOR_MARVELL=y
> # CONFIG_LIBERTAS is not set
> # CONFIG_LIBERTAS_THINFIRM is not set
> CONFIG_MWIFIEX=m
> CONFIG_MWIFIEX_SDIO=m
> CONFIG_MWIFIEX_PCIE=m
> CONFIG_MWIFIEX_USB=m
> CONFIG_MWL8K=m
> CONFIG_WLAN_VENDOR_MEDIATEK=y
> # CONFIG_MT7601U is not set
> CONFIG_WLAN_VENDOR_RALINK=y
> CONFIG_RT2X00=m
> # CONFIG_RT2400PCI is not set
> # CONFIG_RT2500PCI is not set
> CONFIG_RT61PCI=m
> CONFIG_RT2800PCI=m
> CONFIG_RT2800PCI_RT33XX=y
> CONFIG_RT2800PCI_RT35XX=y
> CONFIG_RT2800PCI_RT53XX=y
> CONFIG_RT2800PCI_RT3290=y
> # CONFIG_RT2500USB is not set
> CONFIG_RT73USB=m
> CONFIG_RT2800USB=m
> CONFIG_RT2800USB_RT33XX=y
> CONFIG_RT2800USB_RT35XX=y
> # CONFIG_RT2800USB_RT3573 is not set
> CONFIG_RT2800USB_RT53XX=y
> CONFIG_RT2800USB_RT55XX=y
> CONFIG_RT2800USB_UNKNOWN=y
> CONFIG_RT2800_LIB=m
> CONFIG_RT2800_LIB_MMIO=m
> CONFIG_RT2X00_LIB_MMIO=m
> CONFIG_RT2X00_LIB_PCI=m
> CONFIG_RT2X00_LIB_USB=m
> CONFIG_RT2X00_LIB=m
> CONFIG_RT2X00_LIB_FIRMWARE=y
> CONFIG_RT2X00_LIB_CRYPTO=y
> CONFIG_RT2X00_LIB_LEDS=y
> CONFIG_RT2X00_LIB_DEBUGFS=y
> # CONFIG_RT2X00_DEBUG is not set
> CONFIG_WLAN_VENDOR_REALTEK=y
> # CONFIG_RTL8180 is not set
> CONFIG_RTL8187=m
> CONFIG_RTL8187_LEDS=y
> CONFIG_RTL_CARDS=m
> CONFIG_RTL8192CE=m
> CONFIG_RTL8192SE=m
> CONFIG_RTL8192DE=m
> CONFIG_RTL8723AE=m
> # CONFIG_RTL8723BE is not set
> CONFIG_RTL8188EE=m
> # CONFIG_RTL8192EE is not set
> # CONFIG_RTL8821AE is not set
> CONFIG_RTL8192CU=m
> CONFIG_RTLWIFI=m
> CONFIG_RTLWIFI_PCI=m
> CONFIG_RTLWIFI_USB=m
> # CONFIG_RTLWIFI_DEBUG is not set
> CONFIG_RTL8192C_COMMON=m
> CONFIG_RTL8723_COMMON=m
> CONFIG_RTLBTCOEXIST=m
> # CONFIG_RTL8XXXU is not set
> CONFIG_WLAN_VENDOR_RSI=y
> # CONFIG_RSI_91X is not set
> CONFIG_WLAN_VENDOR_ST=y
> # CONFIG_CW1200 is not set
> CONFIG_WLAN_VENDOR_TI=y
> # CONFIG_WL1251 is not set
> # CONFIG_WL12XX is not set
> # CONFIG_WL18XX is not set
> # CONFIG_WLCORE is not set
> CONFIG_WLAN_VENDOR_ZYDAS=y
> # CONFIG_USB_ZD1201 is not set
> # CONFIG_ZD1211RW is not set
> # CONFIG_MAC80211_HWSIM is not set
> # CONFIG_USB_NET_RNDIS_WLAN is not set
> 
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> CONFIG_WAN=y
> # CONFIG_LANMEDIA is not set
> CONFIG_HDLC=m
> CONFIG_HDLC_RAW=m
> # CONFIG_HDLC_RAW_ETH is not set
> CONFIG_HDLC_CISCO=m
> CONFIG_HDLC_FR=m
> CONFIG_HDLC_PPP=m
> 
> #
> # X.25/LAPB support is disabled
> #
> # CONFIG_PCI200SYN is not set
> # CONFIG_WANXL is not set
> # CONFIG_PC300TOO is not set
> # CONFIG_FARSYNC is not set
> # CONFIG_DSCC4 is not set
> CONFIG_DLCI=m
> CONFIG_DLCI_MAX=8
> # CONFIG_SBNI is not set
> CONFIG_IEEE802154_DRIVERS=m
> CONFIG_IEEE802154_FAKELB=m
> # CONFIG_IEEE802154_ATUSB is not set
> CONFIG_XEN_NETDEV_FRONTEND=m
> # CONFIG_XEN_NETDEV_BACKEND is not set
> CONFIG_VMXNET3=m
> # CONFIG_FUJITSU_ES is not set
> CONFIG_HYPERV_NET=m
> CONFIG_ISDN=y
> CONFIG_ISDN_I4L=m
> CONFIG_ISDN_PPP=y
> CONFIG_ISDN_PPP_VJ=y
> CONFIG_ISDN_MPP=y
> CONFIG_IPPP_FILTER=y
> # CONFIG_ISDN_PPP_BSDCOMP is not set
> CONFIG_ISDN_AUDIO=y
> CONFIG_ISDN_TTY_FAX=y
> 
> #
> # ISDN feature submodules
> #
> CONFIG_ISDN_DIVERSION=m
> 
> #
> # ISDN4Linux hardware drivers
> #
> 
> #
> # Passive cards
> #
> CONFIG_ISDN_DRV_HISAX=m
> 
> #
> # D-channel protocol features
> #
> CONFIG_HISAX_EURO=y
> CONFIG_DE_AOC=y
> CONFIG_HISAX_NO_SENDCOMPLETE=y
> CONFIG_HISAX_NO_LLC=y
> CONFIG_HISAX_NO_KEYPAD=y
> CONFIG_HISAX_1TR6=y
> CONFIG_HISAX_NI1=y
> CONFIG_HISAX_MAX_CARDS=8
> 
> #
> # HiSax supported cards
> #
> CONFIG_HISAX_16_3=y
> CONFIG_HISAX_TELESPCI=y
> CONFIG_HISAX_S0BOX=y
> CONFIG_HISAX_FRITZPCI=y
> CONFIG_HISAX_AVM_A1_PCMCIA=y
> CONFIG_HISAX_ELSA=y
> CONFIG_HISAX_DIEHLDIVA=y
> CONFIG_HISAX_SEDLBAUER=y
> CONFIG_HISAX_NETJET=y
> CONFIG_HISAX_NETJET_U=y
> CONFIG_HISAX_NICCY=y
> CONFIG_HISAX_BKM_A4T=y
> CONFIG_HISAX_SCT_QUADRO=y
> CONFIG_HISAX_GAZEL=y
> CONFIG_HISAX_HFC_PCI=y
> CONFIG_HISAX_W6692=y
> CONFIG_HISAX_HFC_SX=y
> CONFIG_HISAX_ENTERNOW_PCI=y
> # CONFIG_HISAX_DEBUG is not set
> 
> #
> # HiSax PCMCIA card service modules
> #
> 
> #
> # HiSax sub driver modules
> #
> CONFIG_HISAX_ST5481=m
> # CONFIG_HISAX_HFCUSB is not set
> CONFIG_HISAX_HFC4S8S=m
> CONFIG_HISAX_FRITZ_PCIPNP=m
> CONFIG_ISDN_CAPI=m
> # CONFIG_CAPI_TRACE is not set
> CONFIG_ISDN_CAPI_CAPI20=m
> CONFIG_ISDN_CAPI_MIDDLEWARE=y
> CONFIG_ISDN_CAPI_CAPIDRV=m
> # CONFIG_ISDN_CAPI_CAPIDRV_VERBOSE is not set
> 
> #
> # CAPI hardware drivers
> #
> CONFIG_CAPI_AVM=y
> CONFIG_ISDN_DRV_AVMB1_B1PCI=m
> CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
> CONFIG_ISDN_DRV_AVMB1_T1PCI=m
> CONFIG_ISDN_DRV_AVMB1_C4=m
> # CONFIG_CAPI_EICON is not set
> CONFIG_ISDN_DRV_GIGASET=m
> CONFIG_GIGASET_CAPI=y
> # CONFIG_GIGASET_I4L is not set
> # CONFIG_GIGASET_DUMMYLL is not set
> CONFIG_GIGASET_BASE=m
> CONFIG_GIGASET_M105=m
> CONFIG_GIGASET_M101=m
> # CONFIG_GIGASET_DEBUG is not set
> CONFIG_HYSDN=m
> CONFIG_HYSDN_CAPI=y
> CONFIG_MISDN=m
> CONFIG_MISDN_DSP=m
> CONFIG_MISDN_L1OIP=m
> 
> #
> # mISDN hardware drivers
> #
> CONFIG_MISDN_HFCPCI=m
> CONFIG_MISDN_HFCMULTI=m
> CONFIG_MISDN_HFCUSB=m
> CONFIG_MISDN_AVMFRITZ=m
> CONFIG_MISDN_SPEEDFAX=m
> CONFIG_MISDN_INFINEON=m
> CONFIG_MISDN_W6692=m
> CONFIG_MISDN_NETJET=m
> CONFIG_MISDN_IPAC=m
> CONFIG_MISDN_ISAR=m
> CONFIG_ISDN_HDLC=m
> # CONFIG_NVM is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_LEDS=y
> CONFIG_INPUT_FF_MEMLESS=m
> CONFIG_INPUT_POLLDEV=m
> CONFIG_INPUT_SPARSEKMAP=m
> # CONFIG_INPUT_MATRIXKMAP is not set
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> # CONFIG_INPUT_JOYDEV is not set
> CONFIG_INPUT_EVDEV=y
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> # CONFIG_KEYBOARD_ADP5588 is not set
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_TCA8418 is not set
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_LM8333 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_SAMSUNG is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_BYD=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_CYPRESS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> CONFIG_MOUSE_PS2_ELANTECH=y
> CONFIG_MOUSE_PS2_SENTELIC=y
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> CONFIG_MOUSE_PS2_FOCALTECH=y
> # CONFIG_MOUSE_PS2_VMMOUSE is not set
> CONFIG_MOUSE_SERIAL=m
> CONFIG_MOUSE_APPLETOUCH=m
> CONFIG_MOUSE_BCM5974=m
> CONFIG_MOUSE_CYAPA=m
> # CONFIG_MOUSE_ELAN_I2C is not set
> CONFIG_MOUSE_VSXXXAA=m
> CONFIG_MOUSE_SYNAPTICS_I2C=m
> CONFIG_MOUSE_SYNAPTICS_USB=m
> # CONFIG_INPUT_JOYSTICK is not set
> CONFIG_INPUT_TABLET=y
> CONFIG_TABLET_USB_ACECAD=m
> CONFIG_TABLET_USB_AIPTEK=m
> CONFIG_TABLET_USB_GTCO=m
> # CONFIG_TABLET_USB_HANWANG is not set
> CONFIG_TABLET_USB_KBTAB=m
> # CONFIG_TABLET_USB_PEGASUS is not set
> # CONFIG_TABLET_SERIAL_WACOM4 is not set
> CONFIG_INPUT_TOUCHSCREEN=y
> CONFIG_TOUCHSCREEN_PROPERTIES=y
> # CONFIG_TOUCHSCREEN_AD7879 is not set
> # CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
> # CONFIG_TOUCHSCREEN_BU21013 is not set
> # CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
> # CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
> # CONFIG_TOUCHSCREEN_DYNAPRO is not set
> # CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
> # CONFIG_TOUCHSCREEN_EETI is not set
> # CONFIG_TOUCHSCREEN_EGALAX_SERIAL is not set
> # CONFIG_TOUCHSCREEN_FUJITSU is not set
> # CONFIG_TOUCHSCREEN_ILI210X is not set
> # CONFIG_TOUCHSCREEN_GUNZE is not set
> # CONFIG_TOUCHSCREEN_EKTF2127 is not set
> # CONFIG_TOUCHSCREEN_ELAN is not set
> CONFIG_TOUCHSCREEN_ELO=m
> CONFIG_TOUCHSCREEN_WACOM_W8001=m
> CONFIG_TOUCHSCREEN_WACOM_I2C=m
> # CONFIG_TOUCHSCREEN_MAX11801 is not set
> # CONFIG_TOUCHSCREEN_MCS5000 is not set
> # CONFIG_TOUCHSCREEN_MMS114 is not set
> # CONFIG_TOUCHSCREEN_MELFAS_MIP4 is not set
> # CONFIG_TOUCHSCREEN_MTOUCH is not set
> # CONFIG_TOUCHSCREEN_INEXIO is not set
> # CONFIG_TOUCHSCREEN_MK712 is not set
> # CONFIG_TOUCHSCREEN_PENMOUNT is not set
> # CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
> # CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
> # CONFIG_TOUCHSCREEN_TOUCHWIN is not set
> # CONFIG_TOUCHSCREEN_PIXCIR is not set
> # CONFIG_TOUCHSCREEN_WDT87XX_I2C is not set
> # CONFIG_TOUCHSCREEN_WM97XX is not set
> # CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
> # CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
> # CONFIG_TOUCHSCREEN_TSC_SERIO is not set
> # CONFIG_TOUCHSCREEN_TSC2004 is not set
> # CONFIG_TOUCHSCREEN_TSC2007 is not set
> # CONFIG_TOUCHSCREEN_SILEAD is not set
> # CONFIG_TOUCHSCREEN_ST1232 is not set
> # CONFIG_TOUCHSCREEN_SUR40 is not set
> # CONFIG_TOUCHSCREEN_SX8654 is not set
> # CONFIG_TOUCHSCREEN_TPS6507X is not set
> # CONFIG_TOUCHSCREEN_ZET6223 is not set
> # CONFIG_TOUCHSCREEN_ROHM_BU21023 is not set
> CONFIG_INPUT_MISC=y
> # CONFIG_INPUT_AD714X is not set
> # CONFIG_INPUT_BMA150 is not set
> # CONFIG_INPUT_E3X0_BUTTON is not set
> CONFIG_INPUT_PCSPKR=m
> # CONFIG_INPUT_MMA8450 is not set
> CONFIG_INPUT_APANEL=m
> CONFIG_INPUT_ATLAS_BTNS=m
> CONFIG_INPUT_ATI_REMOTE2=m
> CONFIG_INPUT_KEYSPAN_REMOTE=m
> # CONFIG_INPUT_KXTJ9 is not set
> CONFIG_INPUT_POWERMATE=m
> CONFIG_INPUT_YEALINK=m
> CONFIG_INPUT_CM109=m
> CONFIG_INPUT_UINPUT=m
> # CONFIG_INPUT_PCF8574 is not set
> # CONFIG_INPUT_ADXL34X is not set
> # CONFIG_INPUT_IMS_PCU is not set
> # CONFIG_INPUT_CMA3000 is not set
> CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m
> # CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
> # CONFIG_INPUT_DRV2665_HAPTICS is not set
> # CONFIG_INPUT_DRV2667_HAPTICS is not set
> CONFIG_RMI4_CORE=m
> # CONFIG_RMI4_I2C is not set
> # CONFIG_RMI4_SMB is not set
> CONFIG_RMI4_F03=y
> CONFIG_RMI4_F03_SERIO=m
> CONFIG_RMI4_2D_SENSOR=y
> CONFIG_RMI4_F11=y
> CONFIG_RMI4_F12=y
> CONFIG_RMI4_F30=y
> # CONFIG_RMI4_F34 is not set
> # CONFIG_RMI4_F54 is not set
> # CONFIG_RMI4_F55 is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> # CONFIG_SERIO_CT82C710 is not set
> # CONFIG_SERIO_PARKBD is not set
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=m
> CONFIG_SERIO_ALTERA_PS2=m
> # CONFIG_SERIO_PS2MULT is not set
> CONFIG_SERIO_ARC_PS2=m
> CONFIG_HYPERV_KEYBOARD=m
> # CONFIG_USERIO is not set
> # CONFIG_GAMEPORT is not set
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_VT_CONSOLE_SLEEP=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_UNIX98_PTYS=y
> # CONFIG_LEGACY_PTYS is not set
> CONFIG_SERIAL_NONSTANDARD=y
> # CONFIG_ROCKETPORT is not set
> CONFIG_CYCLADES=m
> # CONFIG_CYZ_INTR is not set
> # CONFIG_MOXA_INTELLIO is not set
> # CONFIG_MOXA_SMARTIO is not set
> CONFIG_SYNCLINK=m
> CONFIG_SYNCLINKMP=m
> CONFIG_SYNCLINK_GT=m
> CONFIG_NOZOMI=m
> # CONFIG_ISI is not set
> CONFIG_N_HDLC=m
> CONFIG_N_GSM=m
> # CONFIG_TRACE_SINK is not set
> CONFIG_DEVMEM=y
> # CONFIG_DEVKMEM is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_EARLYCON=y
> CONFIG_SERIAL_8250=y
> # CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
> CONFIG_SERIAL_8250_PNP=y
> # CONFIG_SERIAL_8250_FINTEK is not set
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_DMA=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_EXAR=y
> CONFIG_SERIAL_8250_NR_UARTS=32
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> CONFIG_SERIAL_8250_RSA=y
> # CONFIG_SERIAL_8250_FSL is not set
> # CONFIG_SERIAL_8250_DW is not set
> # CONFIG_SERIAL_8250_RT288X is not set
> CONFIG_SERIAL_8250_LPSS=y
> CONFIG_SERIAL_8250_MID=y
> # CONFIG_SERIAL_8250_MOXA is not set
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_KGDB_NMI is not set
> # CONFIG_SERIAL_UARTLITE is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_CONSOLE_POLL=y
> CONFIG_SERIAL_JSM=m
> # CONFIG_SERIAL_SCCNXP is not set
> # CONFIG_SERIAL_SC16IS7XX is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> CONFIG_SERIAL_ARC=m
> CONFIG_SERIAL_ARC_NR_PORTS=1
> # CONFIG_SERIAL_RP2 is not set
> # CONFIG_SERIAL_FSL_LPUART is not set
> # CONFIG_SERIAL_DEV_BUS is not set
> CONFIG_PRINTER=m
> # CONFIG_LP_CONSOLE is not set
> CONFIG_PPDEV=m
> CONFIG_HVC_DRIVER=y
> CONFIG_HVC_IRQ=y
> CONFIG_HVC_XEN=y
> CONFIG_HVC_XEN_FRONTEND=y
> CONFIG_VIRTIO_CONSOLE=m
> CONFIG_IPMI_HANDLER=m
> # CONFIG_IPMI_PANIC_EVENT is not set
> CONFIG_IPMI_DEVICE_INTERFACE=m
> CONFIG_IPMI_SI=m
> CONFIG_IPMI_SSIF=m
> CONFIG_IPMI_WATCHDOG=m
> CONFIG_IPMI_POWEROFF=m
> CONFIG_HW_RANDOM=y
> CONFIG_HW_RANDOM_TIMERIOMEM=m
> CONFIG_HW_RANDOM_INTEL=m
> CONFIG_HW_RANDOM_AMD=m
> CONFIG_HW_RANDOM_VIA=m
> CONFIG_HW_RANDOM_VIRTIO=m
> CONFIG_HW_RANDOM_TPM=m
> CONFIG_NVRAM=y
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_MWAVE is not set
> CONFIG_RAW_DRIVER=y
> CONFIG_MAX_RAW_DEVS=8192
> CONFIG_HPET=y
> CONFIG_HPET_MMAP=y
> # CONFIG_HPET_MMAP_DEFAULT is not set
> CONFIG_HANGCHECK_TIMER=m
> CONFIG_UV_MMTIMER=m
> CONFIG_TCG_TPM=y
> CONFIG_TCG_TIS_CORE=y
> CONFIG_TCG_TIS=y
> CONFIG_TCG_TIS_I2C_ATMEL=m
> CONFIG_TCG_TIS_I2C_INFINEON=m
> CONFIG_TCG_TIS_I2C_NUVOTON=m
> CONFIG_TCG_NSC=m
> CONFIG_TCG_ATMEL=m
> CONFIG_TCG_INFINEON=m
> # CONFIG_TCG_XEN is not set
> CONFIG_TCG_CRB=m
> # CONFIG_TCG_VTPM_PROXY is not set
> # CONFIG_TCG_TIS_ST33ZP24_I2C is not set
> CONFIG_TELCLOCK=m
> CONFIG_DEVPORT=y
> # CONFIG_XILLYBUS is not set
> 
> #
> # I2C support
> #
> CONFIG_I2C=m
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=m
> CONFIG_I2C_MUX=m
> 
> #
> # Multiplexer I2C Chip support
> #
> # CONFIG_I2C_MUX_PCA9541 is not set
> # CONFIG_I2C_MUX_PINCTRL is not set
> # CONFIG_I2C_MUX_REG is not set
> # CONFIG_I2C_MUX_MLXCPLD is not set
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_SMBUS=m
> CONFIG_I2C_ALGOBIT=m
> CONFIG_I2C_ALGOPCA=m
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> CONFIG_I2C_AMD756=m
> CONFIG_I2C_AMD756_S4882=m
> CONFIG_I2C_AMD8111=m
> CONFIG_I2C_I801=m
> CONFIG_I2C_ISCH=m
> CONFIG_I2C_ISMT=m
> CONFIG_I2C_PIIX4=m
> CONFIG_I2C_NFORCE2=m
> CONFIG_I2C_NFORCE2_S4985=m
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> CONFIG_I2C_SIS96X=m
> CONFIG_I2C_VIA=m
> CONFIG_I2C_VIAPRO=m
> 
> #
> # ACPI drivers
> #
> CONFIG_I2C_SCMI=m
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_DESIGNWARE_CORE=m
> CONFIG_I2C_DESIGNWARE_PLATFORM=m
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> # CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
> # CONFIG_I2C_EMEV2 is not set
> # CONFIG_I2C_OCORES is not set
> CONFIG_I2C_PCA_PLATFORM=m
> # CONFIG_I2C_PXA_PCI is not set
> CONFIG_I2C_SIMTEC=m
> # CONFIG_I2C_XILINX is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_DIOLAN_U2C=m
> CONFIG_I2C_PARPORT=m
> CONFIG_I2C_PARPORT_LIGHT=m
> # CONFIG_I2C_ROBOTFUZZ_OSIF is not set
> # CONFIG_I2C_TAOS_EVM is not set
> CONFIG_I2C_TINY_USB=m
> CONFIG_I2C_VIPERBOARD=m
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_MLXCPLD is not set
> CONFIG_I2C_STUB=m
> # CONFIG_I2C_SLAVE is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
> # CONFIG_SPMI is not set
> # CONFIG_HSI is not set
> 
> #
> # PPS support
> #
> CONFIG_PPS=m
> # CONFIG_PPS_DEBUG is not set
> 
> #
> # PPS clients support
> #
> # CONFIG_PPS_CLIENT_KTIMER is not set
> CONFIG_PPS_CLIENT_LDISC=m
> CONFIG_PPS_CLIENT_PARPORT=m
> CONFIG_PPS_CLIENT_GPIO=m
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> CONFIG_PTP_1588_CLOCK=m
> CONFIG_DP83640_PHY=m
> CONFIG_PTP_1588_CLOCK_KVM=m
> CONFIG_PINCTRL=y
> 
> #
> # Pin controllers
> #
> # CONFIG_DEBUG_PINCTRL is not set
> # CONFIG_PINCTRL_CHERRYVIEW is not set
> # CONFIG_PINCTRL_BROXTON is not set
> # CONFIG_PINCTRL_GEMINILAKE is not set
> # CONFIG_PINCTRL_SUNRISEPOINT is not set
> # CONFIG_GPIOLIB is not set
> # CONFIG_W1 is not set
> # CONFIG_POWER_AVS is not set
> CONFIG_POWER_RESET=y
> # CONFIG_POWER_RESET_RESTART is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_TEST_POWER is not set
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2781 is not set
> # CONFIG_BATTERY_DS2782 is not set
> # CONFIG_BATTERY_SBS is not set
> # CONFIG_CHARGER_SBS is not set
> # CONFIG_BATTERY_BQ27XXX is not set
> # CONFIG_BATTERY_MAX17040 is not set
> # CONFIG_BATTERY_MAX17042 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> # CONFIG_CHARGER_LP8727 is not set
> # CONFIG_CHARGER_BQ2415X is not set
> CONFIG_CHARGER_SMB347=m
> # CONFIG_BATTERY_GAUGE_LTC2941 is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=m
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> CONFIG_SENSORS_ABITUGURU=m
> CONFIG_SENSORS_ABITUGURU3=m
> CONFIG_SENSORS_AD7414=m
> CONFIG_SENSORS_AD7418=m
> CONFIG_SENSORS_ADM1021=m
> CONFIG_SENSORS_ADM1025=m
> CONFIG_SENSORS_ADM1026=m
> CONFIG_SENSORS_ADM1029=m
> CONFIG_SENSORS_ADM1031=m
> CONFIG_SENSORS_ADM9240=m
> CONFIG_SENSORS_ADT7X10=m
> CONFIG_SENSORS_ADT7410=m
> CONFIG_SENSORS_ADT7411=m
> CONFIG_SENSORS_ADT7462=m
> CONFIG_SENSORS_ADT7470=m
> CONFIG_SENSORS_ADT7475=m
> CONFIG_SENSORS_ASC7621=m
> CONFIG_SENSORS_K8TEMP=m
> CONFIG_SENSORS_K10TEMP=m
> CONFIG_SENSORS_FAM15H_POWER=m
> CONFIG_SENSORS_APPLESMC=m
> CONFIG_SENSORS_ASB100=m
> CONFIG_SENSORS_ATXP1=m
> CONFIG_SENSORS_DS620=m
> CONFIG_SENSORS_DS1621=m
> CONFIG_SENSORS_DELL_SMM=m
> CONFIG_SENSORS_I5K_AMB=m
> CONFIG_SENSORS_F71805F=m
> CONFIG_SENSORS_F71882FG=m
> CONFIG_SENSORS_F75375S=m
> CONFIG_SENSORS_FSCHMD=m
> # CONFIG_SENSORS_FTSTEUTATES is not set
> CONFIG_SENSORS_GL518SM=m
> CONFIG_SENSORS_GL520SM=m
> CONFIG_SENSORS_G760A=m
> # CONFIG_SENSORS_G762 is not set
> # CONFIG_SENSORS_HIH6130 is not set
> CONFIG_SENSORS_IBMAEM=m
> CONFIG_SENSORS_IBMPEX=m
> # CONFIG_SENSORS_I5500 is not set
> CONFIG_SENSORS_CORETEMP=m
> CONFIG_SENSORS_IT87=m
> # CONFIG_SENSORS_JC42 is not set
> # CONFIG_SENSORS_POWR1220 is not set
> CONFIG_SENSORS_LINEAGE=m
> # CONFIG_SENSORS_LTC2945 is not set
> # CONFIG_SENSORS_LTC2990 is not set
> CONFIG_SENSORS_LTC4151=m
> CONFIG_SENSORS_LTC4215=m
> # CONFIG_SENSORS_LTC4222 is not set
> CONFIG_SENSORS_LTC4245=m
> # CONFIG_SENSORS_LTC4260 is not set
> CONFIG_SENSORS_LTC4261=m
> CONFIG_SENSORS_MAX16065=m
> CONFIG_SENSORS_MAX1619=m
> CONFIG_SENSORS_MAX1668=m
> CONFIG_SENSORS_MAX197=m
> CONFIG_SENSORS_MAX6639=m
> CONFIG_SENSORS_MAX6642=m
> CONFIG_SENSORS_MAX6650=m
> CONFIG_SENSORS_MAX6697=m
> # CONFIG_SENSORS_MAX31790 is not set
> CONFIG_SENSORS_MCP3021=m
> # CONFIG_SENSORS_TC654 is not set
> CONFIG_SENSORS_LM63=m
> CONFIG_SENSORS_LM73=m
> CONFIG_SENSORS_LM75=m
> CONFIG_SENSORS_LM77=m
> CONFIG_SENSORS_LM78=m
> CONFIG_SENSORS_LM80=m
> CONFIG_SENSORS_LM83=m
> CONFIG_SENSORS_LM85=m
> CONFIG_SENSORS_LM87=m
> CONFIG_SENSORS_LM90=m
> CONFIG_SENSORS_LM92=m
> CONFIG_SENSORS_LM93=m
> CONFIG_SENSORS_LM95234=m
> CONFIG_SENSORS_LM95241=m
> CONFIG_SENSORS_LM95245=m
> CONFIG_SENSORS_PC87360=m
> CONFIG_SENSORS_PC87427=m
> CONFIG_SENSORS_NTC_THERMISTOR=m
> # CONFIG_SENSORS_NCT6683 is not set
> CONFIG_SENSORS_NCT6775=m
> # CONFIG_SENSORS_NCT7802 is not set
> # CONFIG_SENSORS_NCT7904 is not set
> CONFIG_SENSORS_PCF8591=m
> CONFIG_PMBUS=m
> CONFIG_SENSORS_PMBUS=m
> CONFIG_SENSORS_ADM1275=m
> CONFIG_SENSORS_LM25066=m
> CONFIG_SENSORS_LTC2978=m
> # CONFIG_SENSORS_LTC3815 is not set
> CONFIG_SENSORS_MAX16064=m
> # CONFIG_SENSORS_MAX20751 is not set
> CONFIG_SENSORS_MAX34440=m
> CONFIG_SENSORS_MAX8688=m
> # CONFIG_SENSORS_TPS40422 is not set
> CONFIG_SENSORS_UCD9000=m
> CONFIG_SENSORS_UCD9200=m
> CONFIG_SENSORS_ZL6100=m
> CONFIG_SENSORS_SHT21=m
> # CONFIG_SENSORS_SHT3x is not set
> # CONFIG_SENSORS_SHTC1 is not set
> CONFIG_SENSORS_SIS5595=m
> CONFIG_SENSORS_DME1737=m
> CONFIG_SENSORS_EMC1403=m
> # CONFIG_SENSORS_EMC2103 is not set
> CONFIG_SENSORS_EMC6W201=m
> CONFIG_SENSORS_SMSC47M1=m
> CONFIG_SENSORS_SMSC47M192=m
> CONFIG_SENSORS_SMSC47B397=m
> CONFIG_SENSORS_SCH56XX_COMMON=m
> CONFIG_SENSORS_SCH5627=m
> CONFIG_SENSORS_SCH5636=m
> # CONFIG_SENSORS_STTS751 is not set
> # CONFIG_SENSORS_SMM665 is not set
> # CONFIG_SENSORS_ADC128D818 is not set
> CONFIG_SENSORS_ADS1015=m
> CONFIG_SENSORS_ADS7828=m
> CONFIG_SENSORS_AMC6821=m
> CONFIG_SENSORS_INA209=m
> CONFIG_SENSORS_INA2XX=m
> # CONFIG_SENSORS_INA3221 is not set
> # CONFIG_SENSORS_TC74 is not set
> CONFIG_SENSORS_THMC50=m
> CONFIG_SENSORS_TMP102=m
> # CONFIG_SENSORS_TMP103 is not set
> # CONFIG_SENSORS_TMP108 is not set
> CONFIG_SENSORS_TMP401=m
> CONFIG_SENSORS_TMP421=m
> CONFIG_SENSORS_VIA_CPUTEMP=m
> CONFIG_SENSORS_VIA686A=m
> CONFIG_SENSORS_VT1211=m
> CONFIG_SENSORS_VT8231=m
> CONFIG_SENSORS_W83781D=m
> CONFIG_SENSORS_W83791D=m
> CONFIG_SENSORS_W83792D=m
> CONFIG_SENSORS_W83793=m
> CONFIG_SENSORS_W83795=m
> # CONFIG_SENSORS_W83795_FANCTRL is not set
> CONFIG_SENSORS_W83L785TS=m
> CONFIG_SENSORS_W83L786NG=m
> CONFIG_SENSORS_W83627HF=m
> CONFIG_SENSORS_W83627EHF=m
> # CONFIG_SENSORS_XGENE is not set
> 
> #
> # ACPI drivers
> #
> CONFIG_SENSORS_ACPI_POWER=m
> CONFIG_SENSORS_ATK0110=m
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> CONFIG_THERMAL_WRITABLE_TRIPS=y
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
> CONFIG_THERMAL_GOV_FAIR_SHARE=y
> CONFIG_THERMAL_GOV_STEP_WISE=y
> CONFIG_THERMAL_GOV_BANG_BANG=y
> CONFIG_THERMAL_GOV_USER_SPACE=y
> # CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
> # CONFIG_THERMAL_EMULATION is not set
> CONFIG_INTEL_POWERCLAMP=m
> CONFIG_X86_PKG_TEMP_THERMAL=m
> # CONFIG_INTEL_SOC_DTS_THERMAL is not set
> 
> #
> # ACPI INT340X thermal drivers
> #
> # CONFIG_INT340X_THERMAL is not set
> # CONFIG_INTEL_PCH_THERMAL is not set
> CONFIG_WATCHDOG=y
> CONFIG_WATCHDOG_CORE=y
> # CONFIG_WATCHDOG_NOWAYOUT is not set
> # CONFIG_WATCHDOG_SYSFS is not set
> 
> #
> # Watchdog Device Drivers
> #
> CONFIG_SOFT_WATCHDOG=m
> # CONFIG_WDAT_WDT is not set
> # CONFIG_XILINX_WATCHDOG is not set
> # CONFIG_ZIIRAVE_WATCHDOG is not set
> # CONFIG_CADENCE_WATCHDOG is not set
> # CONFIG_DW_WATCHDOG is not set
> # CONFIG_MAX63XX_WATCHDOG is not set
> # CONFIG_ACQUIRE_WDT is not set
> # CONFIG_ADVANTECH_WDT is not set
> CONFIG_ALIM1535_WDT=m
> CONFIG_ALIM7101_WDT=m
> CONFIG_F71808E_WDT=m
> CONFIG_SP5100_TCO=m
> CONFIG_SBC_FITPC2_WATCHDOG=m
> # CONFIG_EUROTECH_WDT is not set
> CONFIG_IB700_WDT=m
> CONFIG_IBMASR=m
> # CONFIG_WAFER_WDT is not set
> CONFIG_I6300ESB_WDT=m
> CONFIG_IE6XX_WDT=m
> CONFIG_ITCO_WDT=m
> CONFIG_ITCO_VENDOR_SUPPORT=y
> CONFIG_IT8712F_WDT=m
> CONFIG_IT87_WDT=m
> CONFIG_HP_WATCHDOG=m
> CONFIG_HPWDT_NMI_DECODING=y
> # CONFIG_SC1200_WDT is not set
> # CONFIG_PC87413_WDT is not set
> CONFIG_NV_TCO=m
> # CONFIG_60XX_WDT is not set
> # CONFIG_CPU5_WDT is not set
> CONFIG_SMSC_SCH311X_WDT=m
> # CONFIG_SMSC37B787_WDT is not set
> CONFIG_VIA_WDT=m
> CONFIG_W83627HF_WDT=m
> CONFIG_W83877F_WDT=m
> CONFIG_W83977F_WDT=m
> CONFIG_MACHZ_WDT=m
> # CONFIG_SBC_EPX_C3_WATCHDOG is not set
> # CONFIG_INTEL_MEI_WDT is not set
> # CONFIG_NI903X_WDT is not set
> # CONFIG_NIC7018_WDT is not set
> CONFIG_XEN_WDT=m
> 
> #
> # PCI-based Watchdog Cards
> #
> CONFIG_PCIPCWATCHDOG=m
> CONFIG_WDTPCI=m
> 
> #
> # USB-based Watchdog Cards
> #
> CONFIG_USBPCWATCHDOG=m
> 
> #
> # Watchdog Pretimeout Governors
> #
> # CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=m
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> # CONFIG_SSB_B43_PCI_BRIDGE is not set
> CONFIG_SSB_SDIOHOST_POSSIBLE=y
> CONFIG_SSB_SDIOHOST=y
> # CONFIG_SSB_DEBUG is not set
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> CONFIG_SSB_DRIVER_PCICORE=y
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=m
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> CONFIG_BCMA_HOST_PCI=y
> # CONFIG_BCMA_HOST_SOC is not set
> CONFIG_BCMA_DRIVER_PCI=y
> CONFIG_BCMA_DRIVER_GMAC_CMN=y
> # CONFIG_BCMA_DEBUG is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=m
> # CONFIG_MFD_BCM590XX is not set
> # CONFIG_MFD_AXP20X_I2C is not set
> # CONFIG_MFD_CROS_EC is not set
> # CONFIG_MFD_DA9062 is not set
> # CONFIG_MFD_DA9063 is not set
> # CONFIG_MFD_DA9150 is not set
> # CONFIG_MFD_DLN2 is not set
> # CONFIG_MFD_MC13XXX_I2C is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
> CONFIG_LPC_ICH=m
> CONFIG_LPC_SCH=m
> # CONFIG_MFD_INTEL_LPSS_ACPI is not set
> # CONFIG_MFD_INTEL_LPSS_PCI is not set
> # CONFIG_MFD_JANZ_CMODIO is not set
> # CONFIG_MFD_KEMPLD is not set
> # CONFIG_MFD_88PM800 is not set
> # CONFIG_MFD_88PM805 is not set
> # CONFIG_MFD_MAX14577 is not set
> # CONFIG_MFD_MAX77693 is not set
> # CONFIG_MFD_MAX8907 is not set
> # CONFIG_MFD_MT6397 is not set
> # CONFIG_MFD_MENF21BMC is not set
> CONFIG_MFD_VIPERBOARD=m
> # CONFIG_MFD_RETU is not set
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_MFD_RDC321X is not set
> CONFIG_MFD_RTSX_PCI=m
> # CONFIG_MFD_RT5033 is not set
> CONFIG_MFD_RTSX_USB=m
> # CONFIG_MFD_SI476X_CORE is not set
> CONFIG_MFD_SM501=m
> # CONFIG_MFD_SKY81452 is not set
> # CONFIG_ABX500_CORE is not set
> # CONFIG_MFD_SYSCON is not set
> # CONFIG_MFD_TI_AM335X_TSCADC is not set
> # CONFIG_MFD_LP3943 is not set
> # CONFIG_TPS6105X is not set
> # CONFIG_TPS6507X is not set
> # CONFIG_MFD_TPS65086 is not set
> # CONFIG_MFD_TPS65217 is not set
> # CONFIG_MFD_TI_LP873X is not set
> # CONFIG_MFD_TPS65218 is not set
> # CONFIG_MFD_TPS65912_I2C is not set
> # CONFIG_MFD_WL1273_CORE is not set
> # CONFIG_MFD_LM3533 is not set
> # CONFIG_MFD_TMIO is not set
> CONFIG_MFD_VX855=m
> # CONFIG_MFD_ARIZONA_I2C is not set
> # CONFIG_MFD_WM8994 is not set
> # CONFIG_REGULATOR is not set
> CONFIG_MEDIA_SUPPORT=m
> 
> #
> # Multimedia core support
> #
> CONFIG_MEDIA_CAMERA_SUPPORT=y
> CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
> CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
> CONFIG_MEDIA_RADIO_SUPPORT=y
> # CONFIG_MEDIA_SDR_SUPPORT is not set
> CONFIG_MEDIA_RC_SUPPORT=y
> # CONFIG_MEDIA_CEC_SUPPORT is not set
> # CONFIG_MEDIA_CONTROLLER is not set
> CONFIG_VIDEO_DEV=m
> CONFIG_VIDEO_V4L2=m
> # CONFIG_VIDEO_ADV_DEBUG is not set
> # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
> CONFIG_VIDEO_TUNER=m
> CONFIG_VIDEOBUF_GEN=m
> CONFIG_VIDEOBUF_DMA_SG=m
> CONFIG_VIDEOBUF_VMALLOC=m
> CONFIG_VIDEOBUF_DVB=m
> CONFIG_VIDEOBUF2_CORE=m
> CONFIG_VIDEOBUF2_MEMOPS=m
> CONFIG_VIDEOBUF2_VMALLOC=m
> CONFIG_VIDEOBUF2_DMA_SG=m
> CONFIG_VIDEOBUF2_DVB=m
> CONFIG_DVB_CORE=m
> CONFIG_DVB_NET=y
> CONFIG_TTPCI_EEPROM=m
> CONFIG_DVB_MAX_ADAPTERS=8
> CONFIG_DVB_DYNAMIC_MINORS=y
> # CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
> 
> #
> # Media drivers
> #
> CONFIG_RC_CORE=m
> CONFIG_RC_MAP=m
> CONFIG_RC_DECODERS=y
> CONFIG_LIRC=m
> CONFIG_IR_LIRC_CODEC=m
> CONFIG_IR_NEC_DECODER=m
> CONFIG_IR_RC5_DECODER=m
> CONFIG_IR_RC6_DECODER=m
> CONFIG_IR_JVC_DECODER=m
> CONFIG_IR_SONY_DECODER=m
> CONFIG_IR_SANYO_DECODER=m
> CONFIG_IR_SHARP_DECODER=m
> CONFIG_IR_MCE_KBD_DECODER=m
> CONFIG_IR_XMP_DECODER=m
> CONFIG_RC_DEVICES=y
> CONFIG_RC_ATI_REMOTE=m
> CONFIG_IR_ENE=m
> # CONFIG_IR_HIX5HD2 is not set
> CONFIG_IR_IMON=m
> CONFIG_IR_MCEUSB=m
> CONFIG_IR_ITE_CIR=m
> CONFIG_IR_FINTEK=m
> CONFIG_IR_NUVOTON=m
> CONFIG_IR_REDRAT3=m
> CONFIG_IR_STREAMZAP=m
> CONFIG_IR_WINBOND_CIR=m
> # CONFIG_IR_IGORPLUGUSB is not set
> CONFIG_IR_IGUANA=m
> CONFIG_IR_TTUSBIR=m
> # CONFIG_RC_LOOPBACK is not set
> CONFIG_IR_GPIO_CIR=m
> # CONFIG_IR_SERIAL is not set
> CONFIG_MEDIA_USB_SUPPORT=y
> 
> #
> # Webcam devices
> #
> CONFIG_USB_VIDEO_CLASS=m
> CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
> CONFIG_USB_GSPCA=m
> CONFIG_USB_M5602=m
> CONFIG_USB_STV06XX=m
> CONFIG_USB_GL860=m
> CONFIG_USB_GSPCA_BENQ=m
> CONFIG_USB_GSPCA_CONEX=m
> CONFIG_USB_GSPCA_CPIA1=m
> # CONFIG_USB_GSPCA_DTCS033 is not set
> CONFIG_USB_GSPCA_ETOMS=m
> CONFIG_USB_GSPCA_FINEPIX=m
> CONFIG_USB_GSPCA_JEILINJ=m
> CONFIG_USB_GSPCA_JL2005BCD=m
> # CONFIG_USB_GSPCA_KINECT is not set
> CONFIG_USB_GSPCA_KONICA=m
> CONFIG_USB_GSPCA_MARS=m
> CONFIG_USB_GSPCA_MR97310A=m
> CONFIG_USB_GSPCA_NW80X=m
> CONFIG_USB_GSPCA_OV519=m
> CONFIG_USB_GSPCA_OV534=m
> CONFIG_USB_GSPCA_OV534_9=m
> CONFIG_USB_GSPCA_PAC207=m
> CONFIG_USB_GSPCA_PAC7302=m
> CONFIG_USB_GSPCA_PAC7311=m
> CONFIG_USB_GSPCA_SE401=m
> CONFIG_USB_GSPCA_SN9C2028=m
> CONFIG_USB_GSPCA_SN9C20X=m
> CONFIG_USB_GSPCA_SONIXB=m
> CONFIG_USB_GSPCA_SONIXJ=m
> CONFIG_USB_GSPCA_SPCA500=m
> CONFIG_USB_GSPCA_SPCA501=m
> CONFIG_USB_GSPCA_SPCA505=m
> CONFIG_USB_GSPCA_SPCA506=m
> CONFIG_USB_GSPCA_SPCA508=m
> CONFIG_USB_GSPCA_SPCA561=m
> CONFIG_USB_GSPCA_SPCA1528=m
> CONFIG_USB_GSPCA_SQ905=m
> CONFIG_USB_GSPCA_SQ905C=m
> CONFIG_USB_GSPCA_SQ930X=m
> CONFIG_USB_GSPCA_STK014=m
> # CONFIG_USB_GSPCA_STK1135 is not set
> CONFIG_USB_GSPCA_STV0680=m
> CONFIG_USB_GSPCA_SUNPLUS=m
> CONFIG_USB_GSPCA_T613=m
> CONFIG_USB_GSPCA_TOPRO=m
> # CONFIG_USB_GSPCA_TOUPTEK is not set
> CONFIG_USB_GSPCA_TV8532=m
> CONFIG_USB_GSPCA_VC032X=m
> CONFIG_USB_GSPCA_VICAM=m
> CONFIG_USB_GSPCA_XIRLINK_CIT=m
> CONFIG_USB_GSPCA_ZC3XX=m
> CONFIG_USB_PWC=m
> # CONFIG_USB_PWC_DEBUG is not set
> CONFIG_USB_PWC_INPUT_EVDEV=y
> # CONFIG_VIDEO_CPIA2 is not set
> CONFIG_USB_ZR364XX=m
> CONFIG_USB_STKWEBCAM=m
> CONFIG_USB_S2255=m
> # CONFIG_VIDEO_USBTV is not set
> 
> #
> # Analog TV USB devices
> #
> CONFIG_VIDEO_PVRUSB2=m
> CONFIG_VIDEO_PVRUSB2_SYSFS=y
> CONFIG_VIDEO_PVRUSB2_DVB=y
> # CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
> CONFIG_VIDEO_HDPVR=m
> CONFIG_VIDEO_USBVISION=m
> # CONFIG_VIDEO_STK1160_COMMON is not set
> # CONFIG_VIDEO_GO7007 is not set
> 
> #
> # Analog/digital TV USB devices
> #
> CONFIG_VIDEO_AU0828=m
> CONFIG_VIDEO_AU0828_V4L2=y
> # CONFIG_VIDEO_AU0828_RC is not set
> CONFIG_VIDEO_CX231XX=m
> CONFIG_VIDEO_CX231XX_RC=y
> CONFIG_VIDEO_CX231XX_ALSA=m
> CONFIG_VIDEO_CX231XX_DVB=m
> CONFIG_VIDEO_TM6000=m
> CONFIG_VIDEO_TM6000_ALSA=m
> CONFIG_VIDEO_TM6000_DVB=m
> 
> #
> # Digital TV USB devices
> #
> CONFIG_DVB_USB=m
> # CONFIG_DVB_USB_DEBUG is not set
> CONFIG_DVB_USB_DIB3000MC=m
> CONFIG_DVB_USB_A800=m
> CONFIG_DVB_USB_DIBUSB_MB=m
> # CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
> CONFIG_DVB_USB_DIBUSB_MC=m
> CONFIG_DVB_USB_DIB0700=m
> CONFIG_DVB_USB_UMT_010=m
> CONFIG_DVB_USB_CXUSB=m
> CONFIG_DVB_USB_M920X=m
> CONFIG_DVB_USB_DIGITV=m
> CONFIG_DVB_USB_VP7045=m
> CONFIG_DVB_USB_VP702X=m
> CONFIG_DVB_USB_GP8PSK=m
> CONFIG_DVB_USB_NOVA_T_USB2=m
> CONFIG_DVB_USB_TTUSB2=m
> CONFIG_DVB_USB_DTT200U=m
> CONFIG_DVB_USB_OPERA1=m
> CONFIG_DVB_USB_AF9005=m
> CONFIG_DVB_USB_AF9005_REMOTE=m
> CONFIG_DVB_USB_PCTV452E=m
> CONFIG_DVB_USB_DW2102=m
> CONFIG_DVB_USB_CINERGY_T2=m
> CONFIG_DVB_USB_DTV5100=m
> CONFIG_DVB_USB_FRIIO=m
> CONFIG_DVB_USB_AZ6027=m
> CONFIG_DVB_USB_TECHNISAT_USB2=m
> CONFIG_DVB_USB_V2=m
> CONFIG_DVB_USB_AF9015=m
> CONFIG_DVB_USB_AF9035=m
> CONFIG_DVB_USB_ANYSEE=m
> CONFIG_DVB_USB_AU6610=m
> CONFIG_DVB_USB_AZ6007=m
> CONFIG_DVB_USB_CE6230=m
> CONFIG_DVB_USB_EC168=m
> CONFIG_DVB_USB_GL861=m
> CONFIG_DVB_USB_LME2510=m
> CONFIG_DVB_USB_MXL111SF=m
> CONFIG_DVB_USB_RTL28XXU=m
> # CONFIG_DVB_USB_DVBSKY is not set
> # CONFIG_DVB_USB_ZD1301 is not set
> CONFIG_DVB_TTUSB_BUDGET=m
> CONFIG_DVB_TTUSB_DEC=m
> CONFIG_SMS_USB_DRV=m
> CONFIG_DVB_B2C2_FLEXCOP_USB=m
> # CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set
> # CONFIG_DVB_AS102 is not set
> 
> #
> # Webcam, TV (analog/digital) USB devices
> #
> CONFIG_VIDEO_EM28XX=m
> # CONFIG_VIDEO_EM28XX_V4L2 is not set
> CONFIG_VIDEO_EM28XX_ALSA=m
> CONFIG_VIDEO_EM28XX_DVB=m
> CONFIG_VIDEO_EM28XX_RC=m
> CONFIG_MEDIA_PCI_SUPPORT=y
> 
> #
> # Media capture support
> #
> # CONFIG_VIDEO_MEYE is not set
> # CONFIG_VIDEO_SOLO6X10 is not set
> # CONFIG_VIDEO_TW5864 is not set
> # CONFIG_VIDEO_TW68 is not set
> # CONFIG_VIDEO_TW686X is not set
> # CONFIG_VIDEO_ZORAN is not set
> 
> #
> # Media capture/analog TV support
> #
> CONFIG_VIDEO_IVTV=m
> # CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS is not set
> # CONFIG_VIDEO_IVTV_ALSA is not set
> CONFIG_VIDEO_FB_IVTV=m
> # CONFIG_VIDEO_HEXIUM_GEMINI is not set
> # CONFIG_VIDEO_HEXIUM_ORION is not set
> # CONFIG_VIDEO_MXB is not set
> # CONFIG_VIDEO_DT3155 is not set
> 
> #
> # Media capture/analog/hybrid TV support
> #
> CONFIG_VIDEO_CX18=m
> CONFIG_VIDEO_CX18_ALSA=m
> CONFIG_VIDEO_CX23885=m
> CONFIG_MEDIA_ALTERA_CI=m
> # CONFIG_VIDEO_CX25821 is not set
> CONFIG_VIDEO_CX88=m
> CONFIG_VIDEO_CX88_ALSA=m
> CONFIG_VIDEO_CX88_BLACKBIRD=m
> CONFIG_VIDEO_CX88_DVB=m
> CONFIG_VIDEO_CX88_ENABLE_VP3054=y
> CONFIG_VIDEO_CX88_VP3054=m
> CONFIG_VIDEO_CX88_MPEG=m
> CONFIG_VIDEO_BT848=m
> CONFIG_DVB_BT8XX=m
> CONFIG_VIDEO_SAA7134=m
> CONFIG_VIDEO_SAA7134_ALSA=m
> CONFIG_VIDEO_SAA7134_RC=y
> CONFIG_VIDEO_SAA7134_DVB=m
> CONFIG_VIDEO_SAA7164=m
> 
> #
> # Media digital TV PCI Adapters
> #
> CONFIG_DVB_AV7110_IR=y
> CONFIG_DVB_AV7110=m
> CONFIG_DVB_AV7110_OSD=y
> CONFIG_DVB_BUDGET_CORE=m
> CONFIG_DVB_BUDGET=m
> CONFIG_DVB_BUDGET_CI=m
> CONFIG_DVB_BUDGET_AV=m
> CONFIG_DVB_BUDGET_PATCH=m
> CONFIG_DVB_B2C2_FLEXCOP_PCI=m
> # CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
> CONFIG_DVB_PLUTO2=m
> CONFIG_DVB_DM1105=m
> CONFIG_DVB_PT1=m
> # CONFIG_DVB_PT3 is not set
> CONFIG_MANTIS_CORE=m
> CONFIG_DVB_MANTIS=m
> CONFIG_DVB_HOPPER=m
> CONFIG_DVB_NGENE=m
> CONFIG_DVB_DDBRIDGE=m
> # CONFIG_DVB_SMIPCIE is not set
> # CONFIG_V4L_PLATFORM_DRIVERS is not set
> # CONFIG_V4L_MEM2MEM_DRIVERS is not set
> # CONFIG_V4L_TEST_DRIVERS is not set
> # CONFIG_DVB_PLATFORM_DRIVERS is not set
> 
> #
> # Supported MMC/SDIO adapters
> #
> CONFIG_SMS_SDIO_DRV=m
> CONFIG_RADIO_ADAPTERS=y
> CONFIG_RADIO_TEA575X=m
> # CONFIG_RADIO_SI470X is not set
> # CONFIG_RADIO_SI4713 is not set
> # CONFIG_USB_MR800 is not set
> # CONFIG_USB_DSBR is not set
> # CONFIG_RADIO_MAXIRADIO is not set
> # CONFIG_RADIO_SHARK is not set
> # CONFIG_RADIO_SHARK2 is not set
> # CONFIG_USB_KEENE is not set
> # CONFIG_USB_RAREMONO is not set
> # CONFIG_USB_MA901 is not set
> # CONFIG_RADIO_TEA5764 is not set
> # CONFIG_RADIO_SAA7706H is not set
> # CONFIG_RADIO_TEF6862 is not set
> # CONFIG_RADIO_WL1273 is not set
> 
> #
> # Texas Instruments WL128x FM driver (ST based)
> #
> 
> #
> # Supported FireWire (IEEE 1394) Adapters
> #
> CONFIG_DVB_FIREDTV=m
> CONFIG_DVB_FIREDTV_INPUT=y
> CONFIG_MEDIA_COMMON_OPTIONS=y
> 
> #
> # common driver options
> #
> CONFIG_VIDEO_CX2341X=m
> CONFIG_VIDEO_TVEEPROM=m
> CONFIG_CYPRESS_FIRMWARE=m
> CONFIG_DVB_B2C2_FLEXCOP=m
> CONFIG_VIDEO_SAA7146=m
> CONFIG_VIDEO_SAA7146_VV=m
> CONFIG_SMS_SIANO_MDTV=m
> CONFIG_SMS_SIANO_RC=y
> # CONFIG_SMS_SIANO_DEBUGFS is not set
> 
> #
> # Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
> #
> CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
> CONFIG_MEDIA_ATTACH=y
> CONFIG_VIDEO_IR_I2C=m
> 
> #
> # Audio decoders, processors and mixers
> #
> CONFIG_VIDEO_TVAUDIO=m
> CONFIG_VIDEO_TDA7432=m
> CONFIG_VIDEO_MSP3400=m
> CONFIG_VIDEO_CS3308=m
> CONFIG_VIDEO_CS5345=m
> CONFIG_VIDEO_CS53L32A=m
> CONFIG_VIDEO_WM8775=m
> CONFIG_VIDEO_WM8739=m
> CONFIG_VIDEO_VP27SMPX=m
> 
> #
> # RDS decoders
> #
> CONFIG_VIDEO_SAA6588=m
> 
> #
> # Video decoders
> #
> CONFIG_VIDEO_SAA711X=m
> 
> #
> # Video and audio decoders
> #
> CONFIG_VIDEO_SAA717X=m
> CONFIG_VIDEO_CX25840=m
> 
> #
> # Video encoders
> #
> CONFIG_VIDEO_SAA7127=m
> 
> #
> # Camera sensor devices
> #
> 
> #
> # Flash devices
> #
> 
> #
> # Video improvement chips
> #
> CONFIG_VIDEO_UPD64031A=m
> CONFIG_VIDEO_UPD64083=m
> 
> #
> # Audio/Video compression chips
> #
> CONFIG_VIDEO_SAA6752HS=m
> 
> #
> # Miscellaneous helper chips
> #
> CONFIG_VIDEO_M52790=m
> 
> #
> # Sensors used on soc_camera driver
> #
> CONFIG_MEDIA_TUNER=m
> CONFIG_MEDIA_TUNER_SIMPLE=m
> CONFIG_MEDIA_TUNER_TDA8290=m
> CONFIG_MEDIA_TUNER_TDA827X=m
> CONFIG_MEDIA_TUNER_TDA18271=m
> CONFIG_MEDIA_TUNER_TDA9887=m
> CONFIG_MEDIA_TUNER_TEA5761=m
> CONFIG_MEDIA_TUNER_TEA5767=m
> CONFIG_MEDIA_TUNER_MT20XX=m
> CONFIG_MEDIA_TUNER_MT2060=m
> CONFIG_MEDIA_TUNER_MT2063=m
> CONFIG_MEDIA_TUNER_MT2266=m
> CONFIG_MEDIA_TUNER_MT2131=m
> CONFIG_MEDIA_TUNER_QT1010=m
> CONFIG_MEDIA_TUNER_XC2028=m
> CONFIG_MEDIA_TUNER_XC5000=m
> CONFIG_MEDIA_TUNER_XC4000=m
> CONFIG_MEDIA_TUNER_MXL5005S=m
> CONFIG_MEDIA_TUNER_MXL5007T=m
> CONFIG_MEDIA_TUNER_MC44S803=m
> CONFIG_MEDIA_TUNER_MAX2165=m
> CONFIG_MEDIA_TUNER_TDA18218=m
> CONFIG_MEDIA_TUNER_FC0011=m
> CONFIG_MEDIA_TUNER_FC0012=m
> CONFIG_MEDIA_TUNER_FC0013=m
> CONFIG_MEDIA_TUNER_TDA18212=m
> CONFIG_MEDIA_TUNER_E4000=m
> CONFIG_MEDIA_TUNER_FC2580=m
> CONFIG_MEDIA_TUNER_M88RS6000T=m
> CONFIG_MEDIA_TUNER_TUA9001=m
> CONFIG_MEDIA_TUNER_SI2157=m
> CONFIG_MEDIA_TUNER_IT913X=m
> CONFIG_MEDIA_TUNER_R820T=m
> CONFIG_MEDIA_TUNER_QM1D1C0042=m
> 
> #
> # Multistandard (satellite) frontends
> #
> CONFIG_DVB_STB0899=m
> CONFIG_DVB_STB6100=m
> CONFIG_DVB_STV090x=m
> CONFIG_DVB_STV6110x=m
> CONFIG_DVB_M88DS3103=m
> 
> #
> # Multistandard (cable + terrestrial) frontends
> #
> CONFIG_DVB_DRXK=m
> CONFIG_DVB_TDA18271C2DD=m
> CONFIG_DVB_SI2165=m
> CONFIG_DVB_MN88472=m
> CONFIG_DVB_MN88473=m
> 
> #
> # DVB-S (satellite) frontends
> #
> CONFIG_DVB_CX24110=m
> CONFIG_DVB_CX24123=m
> CONFIG_DVB_MT312=m
> CONFIG_DVB_ZL10036=m
> CONFIG_DVB_ZL10039=m
> CONFIG_DVB_S5H1420=m
> CONFIG_DVB_STV0288=m
> CONFIG_DVB_STB6000=m
> CONFIG_DVB_STV0299=m
> CONFIG_DVB_STV6110=m
> CONFIG_DVB_STV0900=m
> CONFIG_DVB_TDA8083=m
> CONFIG_DVB_TDA10086=m
> CONFIG_DVB_TDA8261=m
> CONFIG_DVB_VES1X93=m
> CONFIG_DVB_TUNER_ITD1000=m
> CONFIG_DVB_TUNER_CX24113=m
> CONFIG_DVB_TDA826X=m
> CONFIG_DVB_TUA6100=m
> CONFIG_DVB_CX24116=m
> CONFIG_DVB_CX24117=m
> CONFIG_DVB_CX24120=m
> CONFIG_DVB_SI21XX=m
> CONFIG_DVB_TS2020=m
> CONFIG_DVB_DS3000=m
> CONFIG_DVB_MB86A16=m
> CONFIG_DVB_TDA10071=m
> 
> #
> # DVB-T (terrestrial) frontends
> #
> CONFIG_DVB_SP8870=m
> CONFIG_DVB_SP887X=m
> CONFIG_DVB_CX22700=m
> CONFIG_DVB_CX22702=m
> CONFIG_DVB_DRXD=m
> CONFIG_DVB_L64781=m
> CONFIG_DVB_TDA1004X=m
> CONFIG_DVB_NXT6000=m
> CONFIG_DVB_MT352=m
> CONFIG_DVB_ZL10353=m
> CONFIG_DVB_DIB3000MB=m
> CONFIG_DVB_DIB3000MC=m
> CONFIG_DVB_DIB7000M=m
> CONFIG_DVB_DIB7000P=m
> CONFIG_DVB_TDA10048=m
> CONFIG_DVB_AF9013=m
> CONFIG_DVB_EC100=m
> CONFIG_DVB_STV0367=m
> CONFIG_DVB_CXD2820R=m
> CONFIG_DVB_RTL2830=m
> CONFIG_DVB_RTL2832=m
> CONFIG_DVB_SI2168=m
> # CONFIG_DVB_AS102_FE is not set
> CONFIG_DVB_GP8PSK_FE=m
> 
> #
> # DVB-C (cable) frontends
> #
> CONFIG_DVB_VES1820=m
> CONFIG_DVB_TDA10021=m
> CONFIG_DVB_TDA10023=m
> CONFIG_DVB_STV0297=m
> 
> #
> # ATSC (North American/Korean Terrestrial/Cable DTV) frontends
> #
> CONFIG_DVB_NXT200X=m
> CONFIG_DVB_OR51211=m
> CONFIG_DVB_OR51132=m
> CONFIG_DVB_BCM3510=m
> CONFIG_DVB_LGDT330X=m
> CONFIG_DVB_LGDT3305=m
> CONFIG_DVB_LGDT3306A=m
> CONFIG_DVB_LG2160=m
> CONFIG_DVB_S5H1409=m
> CONFIG_DVB_AU8522=m
> CONFIG_DVB_AU8522_DTV=m
> CONFIG_DVB_AU8522_V4L=m
> CONFIG_DVB_S5H1411=m
> 
> #
> # ISDB-T (terrestrial) frontends
> #
> CONFIG_DVB_S921=m
> CONFIG_DVB_DIB8000=m
> CONFIG_DVB_MB86A20S=m
> 
> #
> # ISDB-S (satellite) & ISDB-T (terrestrial) frontends
> #
> CONFIG_DVB_TC90522=m
> 
> #
> # Digital terrestrial only tuners/PLL
> #
> CONFIG_DVB_PLL=m
> CONFIG_DVB_TUNER_DIB0070=m
> CONFIG_DVB_TUNER_DIB0090=m
> 
> #
> # SEC control devices for DVB-S
> #
> CONFIG_DVB_DRX39XYJ=m
> CONFIG_DVB_LNBP21=m
> CONFIG_DVB_LNBP22=m
> CONFIG_DVB_ISL6405=m
> CONFIG_DVB_ISL6421=m
> CONFIG_DVB_ISL6423=m
> CONFIG_DVB_A8293=m
> CONFIG_DVB_LGS8GXX=m
> CONFIG_DVB_ATBM8830=m
> CONFIG_DVB_TDA665x=m
> CONFIG_DVB_IX2505V=m
> CONFIG_DVB_M88RS2000=m
> CONFIG_DVB_AF9033=m
> 
> #
> # Tools to develop new frontends
> #
> # CONFIG_DVB_DUMMY_FE is not set
> 
> #
> # Graphics support
> #
> CONFIG_AGP=y
> CONFIG_AGP_AMD64=y
> CONFIG_AGP_INTEL=y
> CONFIG_AGP_SIS=y
> CONFIG_AGP_VIA=y
> CONFIG_INTEL_GTT=y
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=64
> CONFIG_VGA_SWITCHEROO=y
> CONFIG_DRM=m
> CONFIG_DRM_MIPI_DSI=y
> # CONFIG_DRM_DP_AUX_CHARDEV is not set
> # CONFIG_DRM_DEBUG_MM_SELFTEST is not set
> CONFIG_DRM_KMS_HELPER=m
> CONFIG_DRM_KMS_FB_HELPER=y
> CONFIG_DRM_FBDEV_EMULATION=y
> CONFIG_DRM_LOAD_EDID_FIRMWARE=y
> CONFIG_DRM_TTM=m
> CONFIG_DRM_VM=y
> 
> #
> # I2C encoder or helper chips
> #
> CONFIG_DRM_I2C_CH7006=m
> CONFIG_DRM_I2C_SIL164=m
> # CONFIG_DRM_I2C_NXP_TDA998X is not set
> CONFIG_DRM_RADEON=m
> # CONFIG_DRM_RADEON_USERPTR is not set
> # CONFIG_DRM_AMDGPU is not set
> 
> #
> # ACP (Audio CoProcessor) Configuration
> #
> CONFIG_DRM_NOUVEAU=m
> CONFIG_NOUVEAU_DEBUG=5
> CONFIG_NOUVEAU_DEBUG_DEFAULT=3
> CONFIG_DRM_NOUVEAU_BACKLIGHT=y
> CONFIG_DRM_I915=m
> # CONFIG_DRM_I915_ALPHA_SUPPORT is not set
> CONFIG_DRM_I915_CAPTURE_ERROR=y
> CONFIG_DRM_I915_COMPRESS_ERROR=y
> CONFIG_DRM_I915_USERPTR=y
> # CONFIG_DRM_I915_GVT is not set
> # CONFIG_DRM_VGEM is not set
> CONFIG_DRM_VMWGFX=m
> CONFIG_DRM_VMWGFX_FBCON=y
> CONFIG_DRM_GMA500=m
> CONFIG_DRM_GMA600=y
> CONFIG_DRM_GMA3600=y
> CONFIG_DRM_UDL=m
> CONFIG_DRM_AST=m
> CONFIG_DRM_MGAG200=m
> CONFIG_DRM_CIRRUS_QEMU=m
> CONFIG_DRM_QXL=m
> CONFIG_DRM_BOCHS=m
> # CONFIG_DRM_VIRTIO_GPU is not set
> CONFIG_DRM_PANEL=y
> 
> #
> # Display Panels
> #
> CONFIG_DRM_BRIDGE=y
> 
> #
> # Display Interface Bridges
> #
> # CONFIG_DRM_ANALOGIX_ANX78XX is not set
> # CONFIG_HSA_AMD is not set
> # CONFIG_DRM_HISI_HIBMC is not set
> # CONFIG_DRM_TINYDRM is not set
> # CONFIG_DRM_LEGACY is not set
> # CONFIG_DRM_LIB_RANDOM is not set
> 
> #
> # Frame buffer Devices
> #
> CONFIG_FB=y
> # CONFIG_FIRMWARE_EDID is not set
> CONFIG_FB_CMDLINE=y
> CONFIG_FB_NOTIFY=y
> # CONFIG_FB_DDC is not set
> CONFIG_FB_BOOT_VESA_SUPPORT=y
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=m
> CONFIG_FB_SYS_COPYAREA=m
> CONFIG_FB_SYS_IMAGEBLIT=m
> # CONFIG_FB_PROVIDE_GET_FB_UNMAPPED_AREA is not set
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=m
> CONFIG_FB_DEFERRED_IO=y
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
> # CONFIG_FB_MODE_HELPERS is not set
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> # CONFIG_FB_ARC is not set
> # CONFIG_FB_ASILIANT is not set
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> # CONFIG_FB_UVESA is not set
> CONFIG_FB_VESA=y
> CONFIG_FB_EFI=y
> # CONFIG_FB_N411 is not set
> # CONFIG_FB_HGA is not set
> # CONFIG_FB_OPENCORES is not set
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
> # CONFIG_FB_I740 is not set
> # CONFIG_FB_LE80578 is not set
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> # CONFIG_FB_PM3 is not set
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_SM501 is not set
> # CONFIG_FB_SMSCUFX is not set
> # CONFIG_FB_UDL is not set
> # CONFIG_FB_IBM_GXT4500 is not set
> # CONFIG_FB_VIRTUAL is not set
> # CONFIG_XEN_FBDEV_FRONTEND is not set
> # CONFIG_FB_METRONOME is not set
> # CONFIG_FB_MB862XX is not set
> # CONFIG_FB_BROADSHEET is not set
> # CONFIG_FB_AUO_K190X is not set
> CONFIG_FB_HYPERV=m
> # CONFIG_FB_SIMPLE is not set
> # CONFIG_FB_SM712 is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=m
> CONFIG_LCD_PLATFORM=m
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> # CONFIG_BACKLIGHT_GENERIC is not set
> CONFIG_BACKLIGHT_APPLE=m
> # CONFIG_BACKLIGHT_PM8941_WLED is not set
> # CONFIG_BACKLIGHT_SAHARA is not set
> # CONFIG_BACKLIGHT_ADP8860 is not set
> # CONFIG_BACKLIGHT_ADP8870 is not set
> # CONFIG_BACKLIGHT_LM3639 is not set
> # CONFIG_BACKLIGHT_LV5207LP is not set
> # CONFIG_BACKLIGHT_BD6107 is not set
> # CONFIG_VGASTATE is not set
> CONFIG_HDMI=y
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> # CONFIG_VGACON_SOFT_SCROLLBACK_PERSISTENT_ENABLE_BY_DEFAULT is not set
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_DUMMY_CONSOLE_COLUMNS=80
> CONFIG_DUMMY_CONSOLE_ROWS=25
> CONFIG_FRAMEBUFFER_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
> CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> CONFIG_LOGO=y
> # CONFIG_LOGO_LINUX_MONO is not set
> # CONFIG_LOGO_LINUX_VGA16 is not set
> CONFIG_LOGO_LINUX_CLUT224=y
> CONFIG_SOUND=m
> CONFIG_SOUND_OSS_CORE=y
> CONFIG_SOUND_OSS_CORE_PRECLAIM=y
> CONFIG_SND=m
> CONFIG_SND_TIMER=m
> CONFIG_SND_PCM=m
> CONFIG_SND_HWDEP=m
> CONFIG_SND_RAWMIDI=m
> CONFIG_SND_JACK=y
> CONFIG_SND_JACK_INPUT_DEV=y
> CONFIG_SND_SEQUENCER=m
> CONFIG_SND_SEQ_DUMMY=m
> CONFIG_SND_OSSEMUL=y
> # CONFIG_SND_MIXER_OSS is not set
> # CONFIG_SND_PCM_OSS is not set
> CONFIG_SND_PCM_TIMER=y
> CONFIG_SND_SEQUENCER_OSS=y
> CONFIG_SND_HRTIMER=m
> CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
> CONFIG_SND_DYNAMIC_MINORS=y
> CONFIG_SND_MAX_CARDS=32
> # CONFIG_SND_SUPPORT_OLD_API is not set
> CONFIG_SND_PROC_FS=y
> CONFIG_SND_VERBOSE_PROCFS=y
> # CONFIG_SND_VERBOSE_PRINTK is not set
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_VMASTER=y
> CONFIG_SND_DMA_SGBUF=y
> CONFIG_SND_RAWMIDI_SEQ=m
> CONFIG_SND_OPL3_LIB_SEQ=m
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> CONFIG_SND_MPU401_UART=m
> CONFIG_SND_OPL3_LIB=m
> CONFIG_SND_VX_LIB=m
> CONFIG_SND_AC97_CODEC=m
> CONFIG_SND_DRIVERS=y
> CONFIG_SND_PCSP=m
> CONFIG_SND_DUMMY=m
> CONFIG_SND_ALOOP=m
> CONFIG_SND_VIRMIDI=m
> CONFIG_SND_MTPAV=m
> # CONFIG_SND_MTS64 is not set
> # CONFIG_SND_SERIAL_U16550 is not set
> CONFIG_SND_MPU401=m
> # CONFIG_SND_PORTMAN2X4 is not set
> CONFIG_SND_AC97_POWER_SAVE=y
> CONFIG_SND_AC97_POWER_SAVE_DEFAULT=5
> CONFIG_SND_PCI=y
> CONFIG_SND_AD1889=m
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALS4000 is not set
> # CONFIG_SND_ALI5451 is not set
> CONFIG_SND_ASIHPI=m
> CONFIG_SND_ATIIXP=m
> CONFIG_SND_ATIIXP_MODEM=m
> CONFIG_SND_AU8810=m
> CONFIG_SND_AU8820=m
> CONFIG_SND_AU8830=m
> # CONFIG_SND_AW2 is not set
> # CONFIG_SND_AZT3328 is not set
> CONFIG_SND_BT87X=m
> # CONFIG_SND_BT87X_OVERCLOCK is not set
> CONFIG_SND_CA0106=m
> CONFIG_SND_CMIPCI=m
> CONFIG_SND_OXYGEN_LIB=m
> CONFIG_SND_OXYGEN=m
> # CONFIG_SND_CS4281 is not set
> CONFIG_SND_CS46XX=m
> CONFIG_SND_CS46XX_NEW_DSP=y
> CONFIG_SND_CTXFI=m
> CONFIG_SND_DARLA20=m
> CONFIG_SND_GINA20=m
> CONFIG_SND_LAYLA20=m
> CONFIG_SND_DARLA24=m
> CONFIG_SND_GINA24=m
> CONFIG_SND_LAYLA24=m
> CONFIG_SND_MONA=m
> CONFIG_SND_MIA=m
> CONFIG_SND_ECHO3G=m
> CONFIG_SND_INDIGO=m
> CONFIG_SND_INDIGOIO=m
> CONFIG_SND_INDIGODJ=m
> CONFIG_SND_INDIGOIOX=m
> CONFIG_SND_INDIGODJX=m
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> CONFIG_SND_ENS1370=m
> CONFIG_SND_ENS1371=m
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> CONFIG_SND_HDSP=m
> CONFIG_SND_HDSPM=m
> # CONFIG_SND_ICE1712 is not set
> CONFIG_SND_ICE1724=m
> CONFIG_SND_INTEL8X0=m
> CONFIG_SND_INTEL8X0M=m
> CONFIG_SND_KORG1212=m
> CONFIG_SND_LOLA=m
> CONFIG_SND_LX6464ES=m
> # CONFIG_SND_MAESTRO3 is not set
> CONFIG_SND_MIXART=m
> # CONFIG_SND_NM256 is not set
> CONFIG_SND_PCXHR=m
> # CONFIG_SND_RIPTIDE is not set
> CONFIG_SND_RME32=m
> CONFIG_SND_RME96=m
> CONFIG_SND_RME9652=m
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> CONFIG_SND_VIA82XX=m
> CONFIG_SND_VIA82XX_MODEM=m
> CONFIG_SND_VIRTUOSO=m
> CONFIG_SND_VX222=m
> # CONFIG_SND_YMFPCI is not set
> 
> #
> # HD-Audio
> #
> CONFIG_SND_HDA=m
> CONFIG_SND_HDA_INTEL=m
> CONFIG_SND_HDA_HWDEP=y
> CONFIG_SND_HDA_RECONFIG=y
> CONFIG_SND_HDA_INPUT_BEEP=y
> CONFIG_SND_HDA_INPUT_BEEP_MODE=0
> CONFIG_SND_HDA_PATCH_LOADER=y
> CONFIG_SND_HDA_CODEC_REALTEK=m
> CONFIG_SND_HDA_CODEC_ANALOG=m
> CONFIG_SND_HDA_CODEC_SIGMATEL=m
> CONFIG_SND_HDA_CODEC_VIA=m
> CONFIG_SND_HDA_CODEC_HDMI=m
> CONFIG_SND_HDA_CODEC_CIRRUS=m
> CONFIG_SND_HDA_CODEC_CONEXANT=m
> CONFIG_SND_HDA_CODEC_CA0110=m
> CONFIG_SND_HDA_CODEC_CA0132=m
> CONFIG_SND_HDA_CODEC_CA0132_DSP=y
> CONFIG_SND_HDA_CODEC_CMEDIA=m
> CONFIG_SND_HDA_CODEC_SI3054=m
> CONFIG_SND_HDA_GENERIC=m
> CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
> CONFIG_SND_HDA_CORE=m
> CONFIG_SND_HDA_DSP_LOADER=y
> CONFIG_SND_HDA_I915=y
> CONFIG_SND_HDA_PREALLOC_SIZE=512
> CONFIG_SND_USB=y
> CONFIG_SND_USB_AUDIO=m
> CONFIG_SND_USB_UA101=m
> CONFIG_SND_USB_USX2Y=m
> CONFIG_SND_USB_CAIAQ=m
> CONFIG_SND_USB_CAIAQ_INPUT=y
> CONFIG_SND_USB_US122L=m
> CONFIG_SND_USB_6FIRE=m
> CONFIG_SND_USB_HIFACE=m
> CONFIG_SND_BCD2000=m
> CONFIG_SND_USB_LINE6=m
> CONFIG_SND_USB_POD=m
> CONFIG_SND_USB_PODHD=m
> CONFIG_SND_USB_TONEPORT=m
> CONFIG_SND_USB_VARIAX=m
> CONFIG_SND_FIREWIRE=y
> CONFIG_SND_FIREWIRE_LIB=m
> # CONFIG_SND_DICE is not set
> # CONFIG_SND_OXFW is not set
> CONFIG_SND_ISIGHT=m
> # CONFIG_SND_FIREWORKS is not set
> # CONFIG_SND_BEBOB is not set
> # CONFIG_SND_FIREWIRE_DIGI00X is not set
> # CONFIG_SND_FIREWIRE_TASCAM is not set
> # CONFIG_SND_SOC is not set
> # CONFIG_SND_X86 is not set
> # CONFIG_SOUND_PRIME is not set
> CONFIG_AC97_BUS=m
> 
> #
> # HID support
> #
> CONFIG_HID=y
> CONFIG_HID_BATTERY_STRENGTH=y
> CONFIG_HIDRAW=y
> CONFIG_UHID=m
> CONFIG_HID_GENERIC=y
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=y
> CONFIG_HID_ACRUX=m
> # CONFIG_HID_ACRUX_FF is not set
> CONFIG_HID_APPLE=y
> CONFIG_HID_APPLEIR=m
> # CONFIG_HID_ASUS is not set
> CONFIG_HID_AUREAL=m
> CONFIG_HID_BELKIN=y
> # CONFIG_HID_BETOP_FF is not set
> CONFIG_HID_CHERRY=y
> CONFIG_HID_CHICONY=y
> # CONFIG_HID_CORSAIR is not set
> CONFIG_HID_PRODIKEYS=m
> # CONFIG_HID_CMEDIA is not set
> CONFIG_HID_CYPRESS=y
> CONFIG_HID_DRAGONRISE=m
> # CONFIG_DRAGONRISE_FF is not set
> # CONFIG_HID_EMS_FF is not set
> CONFIG_HID_ELECOM=m
> # CONFIG_HID_ELO is not set
> CONFIG_HID_EZKEY=y
> # CONFIG_HID_GEMBIRD is not set
> # CONFIG_HID_GFRM is not set
> CONFIG_HID_HOLTEK=m
> # CONFIG_HOLTEK_FF is not set
> # CONFIG_HID_GT683R is not set
> CONFIG_HID_KEYTOUCH=m
> CONFIG_HID_KYE=m
> CONFIG_HID_UCLOGIC=m
> CONFIG_HID_WALTOP=m
> CONFIG_HID_GYRATION=m
> CONFIG_HID_ICADE=m
> CONFIG_HID_TWINHAN=m
> CONFIG_HID_KENSINGTON=y
> CONFIG_HID_LCPOWER=m
> CONFIG_HID_LED=m
> # CONFIG_HID_LENOVO is not set
> CONFIG_HID_LOGITECH=y
> CONFIG_HID_LOGITECH_DJ=m
> CONFIG_HID_LOGITECH_HIDPP=m
> # CONFIG_LOGITECH_FF is not set
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> # CONFIG_LOGIG940_FF is not set
> # CONFIG_LOGIWHEELS_FF is not set
> CONFIG_HID_MAGICMOUSE=y
> # CONFIG_HID_MAYFLASH is not set
> CONFIG_HID_MICROSOFT=y
> CONFIG_HID_MONTEREY=y
> CONFIG_HID_MULTITOUCH=m
> CONFIG_HID_NTRIG=y
> CONFIG_HID_ORTEK=m
> CONFIG_HID_PANTHERLORD=m
> # CONFIG_PANTHERLORD_FF is not set
> # CONFIG_HID_PENMOUNT is not set
> CONFIG_HID_PETALYNX=m
> CONFIG_HID_PICOLCD=m
> CONFIG_HID_PICOLCD_FB=y
> CONFIG_HID_PICOLCD_BACKLIGHT=y
> CONFIG_HID_PICOLCD_LCD=y
> CONFIG_HID_PICOLCD_LEDS=y
> CONFIG_HID_PICOLCD_CIR=y
> # CONFIG_HID_PLANTRONICS is not set
> CONFIG_HID_PRIMAX=m
> CONFIG_HID_ROCCAT=m
> CONFIG_HID_SAITEK=m
> CONFIG_HID_SAMSUNG=m
> CONFIG_HID_SONY=m
> # CONFIG_SONY_FF is not set
> CONFIG_HID_SPEEDLINK=m
> CONFIG_HID_STEELSERIES=m
> CONFIG_HID_SUNPLUS=m
> CONFIG_HID_RMI=m
> CONFIG_HID_GREENASIA=m
> # CONFIG_GREENASIA_FF is not set
> CONFIG_HID_HYPERV_MOUSE=m
> CONFIG_HID_SMARTJOYPLUS=m
> # CONFIG_SMARTJOYPLUS_FF is not set
> CONFIG_HID_TIVO=m
> CONFIG_HID_TOPSEED=m
> CONFIG_HID_THINGM=m
> CONFIG_HID_THRUSTMASTER=m
> # CONFIG_THRUSTMASTER_FF is not set
> # CONFIG_HID_UDRAW_PS3 is not set
> CONFIG_HID_WACOM=m
> CONFIG_HID_WIIMOTE=m
> # CONFIG_HID_XINMO is not set
> CONFIG_HID_ZEROPLUS=m
> # CONFIG_ZEROPLUS_FF is not set
> CONFIG_HID_ZYDACRON=m
> # CONFIG_HID_SENSOR_HUB is not set
> # CONFIG_HID_ALPS is not set
> 
> #
> # USB HID support
> #
> CONFIG_USB_HID=y
> CONFIG_HID_PID=y
> CONFIG_USB_HIDDEV=y
> 
> #
> # I2C HID support
> #
> CONFIG_I2C_HID=m
> 
> #
> # Intel ISH HID support
> #
> # CONFIG_INTEL_ISH_HID is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_COMMON=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB=y
> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEFAULT_PERSIST=y
> # CONFIG_USB_DYNAMIC_MINORS is not set
> # CONFIG_USB_OTG is not set
> # CONFIG_USB_OTG_WHITELIST is not set
> # CONFIG_USB_LEDS_TRIGGER_USBPORT is not set
> CONFIG_USB_MON=y
> CONFIG_USB_WUSB=m
> CONFIG_USB_WUSB_CBAF=m
> # CONFIG_USB_WUSB_CBAF_DEBUG is not set
> 
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> CONFIG_USB_XHCI_HCD=y
> CONFIG_USB_XHCI_PCI=y
> # CONFIG_USB_XHCI_PLATFORM is not set
> CONFIG_USB_EHCI_HCD=y
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> CONFIG_USB_EHCI_PCI=y
> # CONFIG_USB_EHCI_HCD_PLATFORM is not set
> # CONFIG_USB_OXU210HP_HCD is not set
> # CONFIG_USB_ISP116X_HCD is not set
> # CONFIG_USB_ISP1362_HCD is not set
> # CONFIG_USB_FOTG210_HCD is not set
> CONFIG_USB_OHCI_HCD=y
> CONFIG_USB_OHCI_HCD_PCI=y
> # CONFIG_USB_OHCI_HCD_PLATFORM is not set
> CONFIG_USB_UHCI_HCD=y
> # CONFIG_USB_U132_HCD is not set
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> # CONFIG_USB_WHCI_HCD is not set
> CONFIG_USB_HWA_HCD=m
> # CONFIG_USB_HCD_BCMA is not set
> # CONFIG_USB_HCD_SSB is not set
> # CONFIG_USB_HCD_TEST_MODE is not set
> 
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=m
> CONFIG_USB_PRINTER=m
> CONFIG_USB_WDM=m
> CONFIG_USB_TMC=m
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=m
> # CONFIG_USB_STORAGE_DEBUG is not set
> CONFIG_USB_STORAGE_REALTEK=m
> CONFIG_REALTEK_AUTOPM=y
> CONFIG_USB_STORAGE_DATAFAB=m
> CONFIG_USB_STORAGE_FREECOM=m
> CONFIG_USB_STORAGE_ISD200=m
> CONFIG_USB_STORAGE_USBAT=m
> CONFIG_USB_STORAGE_SDDR09=m
> CONFIG_USB_STORAGE_SDDR55=m
> CONFIG_USB_STORAGE_JUMPSHOT=m
> CONFIG_USB_STORAGE_ALAUDA=m
> CONFIG_USB_STORAGE_ONETOUCH=m
> CONFIG_USB_STORAGE_KARMA=m
> CONFIG_USB_STORAGE_CYPRESS_ATACB=m
> CONFIG_USB_STORAGE_ENE_UB6250=m
> # CONFIG_USB_UAS is not set
> 
> #
> # USB Imaging devices
> #
> CONFIG_USB_MDC800=m
> CONFIG_USB_MICROTEK=m
> # CONFIG_USBIP_CORE is not set
> # CONFIG_USB_MUSB_HDRC is not set
> # CONFIG_USB_DWC3 is not set
> # CONFIG_USB_DWC2 is not set
> # CONFIG_USB_CHIPIDEA is not set
> # CONFIG_USB_ISP1760 is not set
> 
> #
> # USB port drivers
> #
> CONFIG_USB_USS720=m
> CONFIG_USB_SERIAL=y
> CONFIG_USB_SERIAL_CONSOLE=y
> CONFIG_USB_SERIAL_GENERIC=y
> # CONFIG_USB_SERIAL_SIMPLE is not set
> CONFIG_USB_SERIAL_AIRCABLE=m
> CONFIG_USB_SERIAL_ARK3116=m
> CONFIG_USB_SERIAL_BELKIN=m
> CONFIG_USB_SERIAL_CH341=m
> CONFIG_USB_SERIAL_WHITEHEAT=m
> CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
> CONFIG_USB_SERIAL_CP210X=m
> CONFIG_USB_SERIAL_CYPRESS_M8=m
> CONFIG_USB_SERIAL_EMPEG=m
> CONFIG_USB_SERIAL_FTDI_SIO=m
> CONFIG_USB_SERIAL_VISOR=m
> CONFIG_USB_SERIAL_IPAQ=m
> CONFIG_USB_SERIAL_IR=m
> CONFIG_USB_SERIAL_EDGEPORT=m
> CONFIG_USB_SERIAL_EDGEPORT_TI=m
> # CONFIG_USB_SERIAL_F81232 is not set
> # CONFIG_USB_SERIAL_F8153X is not set
> CONFIG_USB_SERIAL_GARMIN=m
> CONFIG_USB_SERIAL_IPW=m
> CONFIG_USB_SERIAL_IUU=m
> CONFIG_USB_SERIAL_KEYSPAN_PDA=m
> CONFIG_USB_SERIAL_KEYSPAN=m
> CONFIG_USB_SERIAL_KLSI=m
> CONFIG_USB_SERIAL_KOBIL_SCT=m
> CONFIG_USB_SERIAL_MCT_U232=m
> # CONFIG_USB_SERIAL_METRO is not set
> CONFIG_USB_SERIAL_MOS7720=m
> CONFIG_USB_SERIAL_MOS7715_PARPORT=y
> CONFIG_USB_SERIAL_MOS7840=m
> # CONFIG_USB_SERIAL_MXUPORT is not set
> CONFIG_USB_SERIAL_NAVMAN=m
> CONFIG_USB_SERIAL_PL2303=m
> CONFIG_USB_SERIAL_OTI6858=m
> CONFIG_USB_SERIAL_QCAUX=m
> CONFIG_USB_SERIAL_QUALCOMM=m
> CONFIG_USB_SERIAL_SPCP8X5=m
> CONFIG_USB_SERIAL_SAFE=m
> CONFIG_USB_SERIAL_SAFE_PADDED=y
> CONFIG_USB_SERIAL_SIERRAWIRELESS=m
> CONFIG_USB_SERIAL_SYMBOL=m
> CONFIG_USB_SERIAL_TI=m
> CONFIG_USB_SERIAL_CYBERJACK=m
> CONFIG_USB_SERIAL_XIRCOM=m
> CONFIG_USB_SERIAL_WWAN=m
> CONFIG_USB_SERIAL_OPTION=m
> CONFIG_USB_SERIAL_OMNINET=m
> CONFIG_USB_SERIAL_OPTICON=m
> CONFIG_USB_SERIAL_XSENS_MT=m
> # CONFIG_USB_SERIAL_WISHBONE is not set
> CONFIG_USB_SERIAL_SSU100=m
> CONFIG_USB_SERIAL_QT2=m
> # CONFIG_USB_SERIAL_UPD78F0730 is not set
> CONFIG_USB_SERIAL_DEBUG=m
> 
> #
> # USB Miscellaneous drivers
> #
> CONFIG_USB_EMI62=m
> CONFIG_USB_EMI26=m
> CONFIG_USB_ADUTUX=m
> CONFIG_USB_SEVSEG=m
> # CONFIG_USB_RIO500 is not set
> CONFIG_USB_LEGOTOWER=m
> CONFIG_USB_LCD=m
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> CONFIG_USB_IDMOUSE=m
> CONFIG_USB_FTDI_ELAN=m
> CONFIG_USB_APPLEDISPLAY=m
> CONFIG_USB_SISUSBVGA=m
> CONFIG_USB_SISUSBVGA_CON=y
> CONFIG_USB_LD=m
> # CONFIG_USB_TRANCEVIBRATOR is not set
> CONFIG_USB_IOWARRIOR=m
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_EHSET_TEST_FIXTURE is not set
> CONFIG_USB_ISIGHTFW=m
> # CONFIG_USB_YUREX is not set
> CONFIG_USB_EZUSB_FX2=m
> # CONFIG_USB_HUB_USB251XB is not set
> CONFIG_USB_HSIC_USB3503=m
> # CONFIG_USB_HSIC_USB4604 is not set
> # CONFIG_USB_LINK_LAYER_TEST is not set
> # CONFIG_USB_CHAOSKEY is not set
> # CONFIG_UCSI is not set
> CONFIG_USB_ATM=m
> CONFIG_USB_SPEEDTOUCH=m
> CONFIG_USB_CXACRU=m
> CONFIG_USB_UEAGLEATM=m
> CONFIG_USB_XUSBATM=m
> 
> #
> # USB Physical Layer drivers
> #
> # CONFIG_USB_PHY is not set
> # CONFIG_NOP_USB_XCEIV is not set
> # CONFIG_USB_ISP1301 is not set
> # CONFIG_USB_GADGET is not set
> # CONFIG_USB_LED_TRIG is not set
> # CONFIG_USB_ULPI_BUS is not set
> CONFIG_UWB=m
> CONFIG_UWB_HWA=m
> CONFIG_UWB_WHCI=m
> CONFIG_UWB_I1480U=m
> CONFIG_MMC=m
> # CONFIG_MMC_DEBUG is not set
> CONFIG_MMC_BLOCK=m
> CONFIG_MMC_BLOCK_MINORS=8
> CONFIG_MMC_BLOCK_BOUNCE=y
> CONFIG_SDIO_UART=m
> # CONFIG_MMC_TEST is not set
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> CONFIG_MMC_SDHCI=m
> CONFIG_MMC_SDHCI_PCI=m
> CONFIG_MMC_RICOH_MMC=y
> CONFIG_MMC_SDHCI_ACPI=m
> CONFIG_MMC_SDHCI_PLTFM=m
> # CONFIG_MMC_WBSD is not set
> CONFIG_MMC_TIFM_SD=m
> CONFIG_MMC_CB710=m
> CONFIG_MMC_VIA_SDMMC=m
> CONFIG_MMC_VUB300=m
> CONFIG_MMC_USHC=m
> # CONFIG_MMC_USDHI6ROL0 is not set
> CONFIG_MMC_REALTEK_PCI=m
> CONFIG_MMC_REALTEK_USB=m
> # CONFIG_MMC_TOSHIBA_PCI is not set
> # CONFIG_MMC_MTK is not set
> CONFIG_MEMSTICK=m
> # CONFIG_MEMSTICK_DEBUG is not set
> 
> #
> # MemoryStick drivers
> #
> # CONFIG_MEMSTICK_UNSAFE_RESUME is not set
> CONFIG_MSPRO_BLOCK=m
> # CONFIG_MS_BLOCK is not set
> 
> #
> # MemoryStick Host Controller Drivers
> #
> CONFIG_MEMSTICK_TIFM_MS=m
> CONFIG_MEMSTICK_JMICRON_38X=m
> CONFIG_MEMSTICK_R592=m
> CONFIG_MEMSTICK_REALTEK_PCI=m
> # CONFIG_MEMSTICK_REALTEK_USB is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> # CONFIG_LEDS_CLASS_FLASH is not set
> # CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_LM3530=m
> # CONFIG_LEDS_LM3642 is not set
> # CONFIG_LEDS_PCA9532 is not set
> CONFIG_LEDS_LP3944=m
> CONFIG_LEDS_LP55XX_COMMON=m
> CONFIG_LEDS_LP5521=m
> CONFIG_LEDS_LP5523=m
> CONFIG_LEDS_LP5562=m
> # CONFIG_LEDS_LP8501 is not set
> # CONFIG_LEDS_LP8860 is not set
> CONFIG_LEDS_CLEVO_MAIL=m
> # CONFIG_LEDS_PCA955X is not set
> # CONFIG_LEDS_PCA963X is not set
> # CONFIG_LEDS_BD2802 is not set
> CONFIG_LEDS_INTEL_SS4200=m
> # CONFIG_LEDS_TCA6507 is not set
> # CONFIG_LEDS_TLC591XX is not set
> # CONFIG_LEDS_LM355x is not set
> 
> #
> # LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
> #
> CONFIG_LEDS_BLINKM=m
> # CONFIG_LEDS_MLXCPLD is not set
> # CONFIG_LEDS_USER is not set
> # CONFIG_LEDS_NIC78BX is not set
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> CONFIG_LEDS_TRIGGER_TIMER=m
> CONFIG_LEDS_TRIGGER_ONESHOT=m
> # CONFIG_LEDS_TRIGGER_DISK is not set
> # CONFIG_LEDS_TRIGGER_MTD is not set
> CONFIG_LEDS_TRIGGER_HEARTBEAT=m
> CONFIG_LEDS_TRIGGER_BACKLIGHT=m
> # CONFIG_LEDS_TRIGGER_CPU is not set
> CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> CONFIG_LEDS_TRIGGER_TRANSIENT=m
> CONFIG_LEDS_TRIGGER_CAMERA=m
> # CONFIG_LEDS_TRIGGER_PANIC is not set
> # CONFIG_ACCESSIBILITY is not set
> CONFIG_INFINIBAND=m
> CONFIG_INFINIBAND_USER_MAD=m
> CONFIG_INFINIBAND_USER_ACCESS=m
> CONFIG_INFINIBAND_USER_MEM=y
> CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
> CONFIG_INFINIBAND_ADDR_TRANS=y
> CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
> CONFIG_INFINIBAND_MTHCA=m
> CONFIG_INFINIBAND_MTHCA_DEBUG=y
> CONFIG_INFINIBAND_QIB=m
> CONFIG_INFINIBAND_QIB_DCA=y
> CONFIG_INFINIBAND_CXGB3=m
> # CONFIG_INFINIBAND_CXGB3_DEBUG is not set
> CONFIG_INFINIBAND_CXGB4=m
> # CONFIG_INFINIBAND_I40IW is not set
> CONFIG_MLX4_INFINIBAND=m
> CONFIG_MLX5_INFINIBAND=m
> CONFIG_INFINIBAND_NES=m
> # CONFIG_INFINIBAND_NES_DEBUG is not set
> CONFIG_INFINIBAND_OCRDMA=m
> # CONFIG_INFINIBAND_VMWARE_PVRDMA is not set
> CONFIG_INFINIBAND_USNIC=m
> CONFIG_INFINIBAND_IPOIB=m
> CONFIG_INFINIBAND_IPOIB_CM=y
> CONFIG_INFINIBAND_IPOIB_DEBUG=y
> # CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
> CONFIG_INFINIBAND_SRP=m
> CONFIG_INFINIBAND_SRPT=m
> CONFIG_INFINIBAND_ISER=m
> CONFIG_INFINIBAND_ISERT=m
> CONFIG_INFINIBAND_RDMAVT=m
> # CONFIG_RDMA_RXE is not set
> CONFIG_INFINIBAND_HFI1=m
> # CONFIG_HFI1_DEBUG_SDMA_ORDER is not set
> CONFIG_HFI1_VERBS_31BIT_PSN=y
> # CONFIG_SDMA_VERBOSITY is not set
> # CONFIG_INFINIBAND_BNXT_RE is not set
> CONFIG_EDAC_ATOMIC_SCRUB=y
> CONFIG_EDAC_SUPPORT=y
> CONFIG_EDAC=y
> CONFIG_EDAC_LEGACY_SYSFS=y
> # CONFIG_EDAC_DEBUG is not set
> CONFIG_EDAC_DECODE_MCE=m
> CONFIG_EDAC_MM_EDAC=m
> CONFIG_EDAC_AMD64=m
> # CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
> CONFIG_EDAC_E752X=m
> CONFIG_EDAC_I82975X=m
> CONFIG_EDAC_I3000=m
> CONFIG_EDAC_I3200=m
> CONFIG_EDAC_IE31200=m
> CONFIG_EDAC_X38=m
> CONFIG_EDAC_I5400=m
> CONFIG_EDAC_I7CORE=m
> CONFIG_EDAC_I5000=m
> CONFIG_EDAC_I5100=m
> CONFIG_EDAC_I7300=m
> CONFIG_EDAC_SBRIDGE=m
> # CONFIG_EDAC_SKX is not set
> # CONFIG_EDAC_PND2 is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_MC146818_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_SYSTOHC is not set
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # I2C RTC drivers
> #
> # CONFIG_RTC_DRV_ABB5ZES3 is not set
> # CONFIG_RTC_DRV_ABX80X is not set
> CONFIG_RTC_DRV_DS1307=m
> CONFIG_RTC_DRV_DS1307_HWMON=y
> # CONFIG_RTC_DRV_DS1307_CENTURY is not set
> CONFIG_RTC_DRV_DS1374=m
> # CONFIG_RTC_DRV_DS1374_WDT is not set
> CONFIG_RTC_DRV_DS1672=m
> CONFIG_RTC_DRV_MAX6900=m
> CONFIG_RTC_DRV_RS5C372=m
> CONFIG_RTC_DRV_ISL1208=m
> CONFIG_RTC_DRV_ISL12022=m
> CONFIG_RTC_DRV_X1205=m
> CONFIG_RTC_DRV_PCF8523=m
> # CONFIG_RTC_DRV_PCF85063 is not set
> CONFIG_RTC_DRV_PCF8563=m
> CONFIG_RTC_DRV_PCF8583=m
> CONFIG_RTC_DRV_M41T80=m
> CONFIG_RTC_DRV_M41T80_WDT=y
> CONFIG_RTC_DRV_BQ32K=m
> # CONFIG_RTC_DRV_S35390A is not set
> CONFIG_RTC_DRV_FM3130=m
> # CONFIG_RTC_DRV_RX8010 is not set
> CONFIG_RTC_DRV_RX8581=m
> CONFIG_RTC_DRV_RX8025=m
> CONFIG_RTC_DRV_EM3027=m
> # CONFIG_RTC_DRV_RV8803 is not set
> 
> #
> # SPI RTC drivers
> #
> CONFIG_RTC_I2C_AND_SPI=m
> 
> #
> # SPI and I2C RTC drivers
> #
> CONFIG_RTC_DRV_DS3232=m
> # CONFIG_RTC_DRV_PCF2127 is not set
> CONFIG_RTC_DRV_RV3029C2=m
> CONFIG_RTC_DRV_RV3029_HWMON=y
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> CONFIG_RTC_DRV_DS1286=m
> CONFIG_RTC_DRV_DS1511=m
> CONFIG_RTC_DRV_DS1553=m
> # CONFIG_RTC_DRV_DS1685_FAMILY is not set
> CONFIG_RTC_DRV_DS1742=m
> CONFIG_RTC_DRV_DS2404=m
> CONFIG_RTC_DRV_STK17TA8=m
> # CONFIG_RTC_DRV_M48T86 is not set
> CONFIG_RTC_DRV_M48T35=m
> CONFIG_RTC_DRV_M48T59=m
> CONFIG_RTC_DRV_MSM6242=m
> CONFIG_RTC_DRV_BQ4802=m
> CONFIG_RTC_DRV_RP5C01=m
> CONFIG_RTC_DRV_V3020=m
> 
> #
> # on-CPU RTC drivers
> #
> 
> #
> # HID Sensor RTC drivers
> #
> # CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
> CONFIG_DMADEVICES=y
> # CONFIG_DMADEVICES_DEBUG is not set
> 
> #
> # DMA Devices
> #
> CONFIG_DMA_ENGINE=y
> CONFIG_DMA_VIRTUAL_CHANNELS=y
> CONFIG_DMA_ACPI=y
> # CONFIG_INTEL_IDMA64 is not set
> CONFIG_INTEL_IOATDMA=m
> # CONFIG_QCOM_HIDMA_MGMT is not set
> # CONFIG_QCOM_HIDMA is not set
> CONFIG_DW_DMAC_CORE=y
> CONFIG_DW_DMAC=m
> CONFIG_DW_DMAC_PCI=y
> CONFIG_HSU_DMA=y
> 
> #
> # DMA Clients
> #
> CONFIG_ASYNC_TX_DMA=y
> # CONFIG_DMATEST is not set
> CONFIG_DMA_ENGINE_RAID=y
> 
> #
> # DMABUF options
> #
> CONFIG_SYNC_FILE=y
> # CONFIG_SW_SYNC is not set
> CONFIG_DCA=m
> CONFIG_AUXDISPLAY=y
> CONFIG_KS0108=m
> CONFIG_KS0108_PORT=0x378
> CONFIG_KS0108_DELAY=2
> CONFIG_CFAG12864B=m
> CONFIG_CFAG12864B_RATE=20
> # CONFIG_IMG_ASCII_LCD is not set
> CONFIG_UIO=m
> CONFIG_UIO_CIF=m
> CONFIG_UIO_PDRV_GENIRQ=m
> # CONFIG_UIO_DMEM_GENIRQ is not set
> CONFIG_UIO_AEC=m
> CONFIG_UIO_SERCOS3=m
> CONFIG_UIO_PCI_GENERIC=m
> # CONFIG_UIO_NETX is not set
> # CONFIG_UIO_PRUSS is not set
> # CONFIG_UIO_MF624 is not set
> # CONFIG_UIO_HV_GENERIC is not set
> CONFIG_VFIO_IOMMU_TYPE1=m
> CONFIG_VFIO_VIRQFD=m
> CONFIG_VFIO=m
> # CONFIG_VFIO_NOIOMMU is not set
> CONFIG_VFIO_PCI=m
> # CONFIG_VFIO_PCI_VGA is not set
> CONFIG_VFIO_PCI_MMAP=y
> CONFIG_VFIO_PCI_INTX=y
> CONFIG_VFIO_PCI_IGD=y
> # CONFIG_VFIO_MDEV is not set
> CONFIG_IRQ_BYPASS_MANAGER=m
> # CONFIG_VIRT_DRIVERS is not set
> CONFIG_VIRTIO=m
> 
> #
> # Virtio drivers
> #
> CONFIG_VIRTIO_PCI=m
> CONFIG_VIRTIO_PCI_LEGACY=y
> CONFIG_VIRTIO_BALLOON=m
> CONFIG_VIRTIO_INPUT=m
> # CONFIG_VIRTIO_MMIO is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> CONFIG_HYPERV=m
> CONFIG_HYPERV_UTILS=m
> CONFIG_HYPERV_BALLOON=m
> 
> #
> # Xen driver support
> #
> CONFIG_XEN_BALLOON=y
> # CONFIG_XEN_SELFBALLOONING is not set
> # CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
> CONFIG_XEN_SCRUB_PAGES=y
> CONFIG_XEN_DEV_EVTCHN=m
> CONFIG_XEN_BACKEND=y
> CONFIG_XENFS=m
> CONFIG_XEN_COMPAT_XENFS=y
> CONFIG_XEN_SYS_HYPERVISOR=y
> CONFIG_XEN_XENBUS_FRONTEND=y
> # CONFIG_XEN_GNTDEV is not set
> # CONFIG_XEN_GRANT_DEV_ALLOC is not set
> CONFIG_SWIOTLB_XEN=y
> CONFIG_XEN_TMEM=m
> CONFIG_XEN_PCIDEV_BACKEND=m
> # CONFIG_XEN_SCSI_BACKEND is not set
> CONFIG_XEN_PRIVCMD=m
> CONFIG_XEN_ACPI_PROCESSOR=m
> # CONFIG_XEN_MCE_LOG is not set
> CONFIG_XEN_HAVE_PVMMU=y
> CONFIG_XEN_EFI=y
> CONFIG_XEN_AUTO_XLATE=y
> CONFIG_XEN_ACPI=y
> CONFIG_XEN_SYMS=y
> CONFIG_XEN_HAVE_VPMU=y
> CONFIG_STAGING=y
> # CONFIG_PRISM2_USB is not set
> # CONFIG_COMEDI is not set
> # CONFIG_RTL8192U is not set
> CONFIG_RTLLIB=m
> CONFIG_RTLLIB_CRYPTO_CCMP=m
> CONFIG_RTLLIB_CRYPTO_TKIP=m
> CONFIG_RTLLIB_CRYPTO_WEP=m
> CONFIG_RTL8192E=m
> CONFIG_R8712U=m
> # CONFIG_R8188EU is not set
> # CONFIG_RTS5208 is not set
> # CONFIG_VT6655 is not set
> # CONFIG_VT6656 is not set
> # CONFIG_FB_SM750 is not set
> # CONFIG_FB_XGI is not set
> 
> #
> # Speakup console speech
> #
> # CONFIG_SPEAKUP is not set
> # CONFIG_STAGING_MEDIA is not set
> 
> #
> # Android
> #
> # CONFIG_LTE_GDM724X is not set
> CONFIG_FIREWIRE_SERIAL=m
> CONFIG_FWTTY_MAX_TOTAL_PORTS=64
> CONFIG_FWTTY_MAX_CARD_PORTS=32
> # CONFIG_LNET is not set
> # CONFIG_DGNC is not set
> # CONFIG_GS_FPGABOOT is not set
> # CONFIG_CRYPTO_SKEIN is not set
> CONFIG_UNISYSSPAR=y
> CONFIG_UNISYS_VISORBUS=m
> CONFIG_UNISYS_VISORNIC=m
> # CONFIG_UNISYS_VISORINPUT is not set
> # CONFIG_UNISYS_VISORHBA is not set
> # CONFIG_WILC1000_SDIO is not set
> # CONFIG_MOST is not set
> # CONFIG_KS7010 is not set
> # CONFIG_GREYBUS is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> CONFIG_ACER_WMI=m
> CONFIG_ACERHDF=m
> # CONFIG_ALIENWARE_WMI is not set
> CONFIG_ASUS_LAPTOP=m
> # CONFIG_DELL_LAPTOP is not set
> # CONFIG_DELL_WMI is not set
> CONFIG_DELL_WMI_AIO=m
> # CONFIG_DELL_SMO8800 is not set
> # CONFIG_DELL_RBTN is not set
> CONFIG_FUJITSU_LAPTOP=m
> # CONFIG_FUJITSU_LAPTOP_DEBUG is not set
> CONFIG_FUJITSU_TABLET=m
> CONFIG_AMILO_RFKILL=m
> CONFIG_HP_ACCEL=m
> CONFIG_HP_WIRELESS=m
> CONFIG_HP_WMI=m
> CONFIG_MSI_LAPTOP=m
> CONFIG_PANASONIC_LAPTOP=m
> CONFIG_COMPAL_LAPTOP=m
> CONFIG_SONY_LAPTOP=m
> CONFIG_SONYPI_COMPAT=y
> CONFIG_IDEAPAD_LAPTOP=m
> CONFIG_THINKPAD_ACPI=m
> CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
> # CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
> # CONFIG_THINKPAD_ACPI_DEBUG is not set
> # CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
> CONFIG_THINKPAD_ACPI_VIDEO=y
> CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
> CONFIG_SENSORS_HDAPS=m
> # CONFIG_INTEL_MENLOW is not set
> CONFIG_EEEPC_LAPTOP=m
> CONFIG_ASUS_WMI=m
> CONFIG_ASUS_NB_WMI=m
> CONFIG_EEEPC_WMI=m
> # CONFIG_ASUS_WIRELESS is not set
> CONFIG_ACPI_WMI=m
> CONFIG_MSI_WMI=m
> CONFIG_TOPSTAR_LAPTOP=m
> CONFIG_TOSHIBA_BT_RFKILL=m
> # CONFIG_TOSHIBA_HAPS is not set
> # CONFIG_TOSHIBA_WMI is not set
> CONFIG_ACPI_CMPC=m
> # CONFIG_INTEL_HID_EVENT is not set
> # CONFIG_INTEL_VBTN is not set
> CONFIG_INTEL_IPS=m
> # CONFIG_INTEL_PMC_CORE is not set
> # CONFIG_IBM_RTL is not set
> CONFIG_SAMSUNG_LAPTOP=m
> CONFIG_MXM_WMI=m
> CONFIG_INTEL_OAKTRAIL=m
> CONFIG_SAMSUNG_Q10=m
> CONFIG_APPLE_GMUX=m
> # CONFIG_INTEL_RST is not set
> # CONFIG_INTEL_SMARTCONNECT is not set
> CONFIG_PVPANIC=y
> # CONFIG_INTEL_PMC_IPC is not set
> # CONFIG_SURFACE_PRO3_BUTTON is not set
> # CONFIG_INTEL_PUNIT_IPC is not set
> # CONFIG_MLX_PLATFORM is not set
> # CONFIG_MLX_CPLD_PLATFORM is not set
> # CONFIG_INTEL_TURBO_MAX_3 is not set
> CONFIG_PMC_ATOM=y
> # CONFIG_CHROME_PLATFORMS is not set
> CONFIG_CLKDEV_LOOKUP=y
> CONFIG_HAVE_CLK_PREPARE=y
> CONFIG_COMMON_CLK=y
> 
> #
> # Common Clock Framework
> #
> # CONFIG_COMMON_CLK_SI5351 is not set
> # CONFIG_COMMON_CLK_CDCE706 is not set
> # CONFIG_COMMON_CLK_CS2000_CP is not set
> # CONFIG_COMMON_CLK_NXP is not set
> # CONFIG_COMMON_CLK_PXA is not set
> # CONFIG_COMMON_CLK_PIC32 is not set
> 
> #
> # Hardware Spinlock drivers
> #
> 
> #
> # Clock Source drivers
> #
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_ATMEL_PIT is not set
> # CONFIG_SH_TIMER_CMT is not set
> # CONFIG_SH_TIMER_MTU2 is not set
> # CONFIG_SH_TIMER_TMU is not set
> # CONFIG_EM_TIMER_STI is not set
> CONFIG_MAILBOX=y
> CONFIG_PCC=y
> # CONFIG_ALTERA_MBOX is not set
> CONFIG_IOMMU_API=y
> CONFIG_IOMMU_SUPPORT=y
> 
> #
> # Generic IOMMU Pagetable Support
> #
> CONFIG_IOMMU_IOVA=y
> CONFIG_AMD_IOMMU=y
> CONFIG_AMD_IOMMU_V2=m
> CONFIG_DMAR_TABLE=y
> CONFIG_INTEL_IOMMU=y
> # CONFIG_INTEL_IOMMU_SVM is not set
> # CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
> CONFIG_INTEL_IOMMU_FLOPPY_WA=y
> CONFIG_IRQ_REMAP=y
> 
> #
> # Remoteproc drivers
> #
> # CONFIG_REMOTEPROC is not set
> 
> #
> # Rpmsg drivers
> #
> 
> #
> # SOC (System On Chip) specific Drivers
> #
> 
> #
> # Broadcom SoC drivers
> #
> # CONFIG_SUNXI_SRAM is not set
> # CONFIG_SOC_TI is not set
> # CONFIG_SOC_ZTE is not set
> CONFIG_PM_DEVFREQ=y
> 
> #
> # DEVFREQ Governors
> #
> CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
> # CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
> # CONFIG_DEVFREQ_GOV_POWERSAVE is not set
> # CONFIG_DEVFREQ_GOV_USERSPACE is not set
> # CONFIG_DEVFREQ_GOV_PASSIVE is not set
> 
> #
> # DEVFREQ Drivers
> #
> # CONFIG_PM_DEVFREQ_EVENT is not set
> # CONFIG_EXTCON is not set
> # CONFIG_MEMORY is not set
> # CONFIG_IIO is not set
> CONFIG_NTB=m
> # CONFIG_NTB_AMD is not set
> # CONFIG_NTB_INTEL is not set
> # CONFIG_NTB_PINGPONG is not set
> # CONFIG_NTB_TOOL is not set
> # CONFIG_NTB_PERF is not set
> # CONFIG_NTB_TRANSPORT is not set
> # CONFIG_VME_BUS is not set
> # CONFIG_PWM is not set
> CONFIG_ARM_GIC_MAX_NR=1
> # CONFIG_IPACK_BUS is not set
> # CONFIG_RESET_CONTROLLER is not set
> # CONFIG_FMC is not set
> 
> #
> # PHY Subsystem
> #
> CONFIG_GENERIC_PHY=y
> # CONFIG_PHY_PXA_28NM_HSIC is not set
> # CONFIG_PHY_PXA_28NM_USB2 is not set
> # CONFIG_BCM_KONA_USB2_PHY is not set
> CONFIG_POWERCAP=y
> CONFIG_INTEL_RAPL=m
> # CONFIG_MCB is not set
> 
> #
> # Performance monitor support
> #
> CONFIG_RAS=y
> # CONFIG_MCE_AMD_INJ is not set
> # CONFIG_THUNDERBOLT is not set
> 
> #
> # Android
> #
> # CONFIG_ANDROID is not set
> CONFIG_LIBNVDIMM=y
> CONFIG_BLK_DEV_PMEM=m
> CONFIG_ND_BLK=m
> CONFIG_ND_CLAIM=y
> CONFIG_ND_BTT=m
> CONFIG_BTT=y
> CONFIG_ND_PFN=m
> CONFIG_NVDIMM_PFN=y
> CONFIG_NVDIMM_DAX=y
> CONFIG_DEV_DAX=m
> CONFIG_DEV_DAX_PMEM=m
> CONFIG_NR_DEV_DAX=32768
> CONFIG_NVMEM=m
> # CONFIG_STM is not set
> # CONFIG_INTEL_TH is not set
> 
> #
> # FPGA Configuration Support
> #
> # CONFIG_FPGA is not set
> 
> #
> # FSI support
> #
> # CONFIG_FSI is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=m
> # CONFIG_EDD_OFF is not set
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=m
> CONFIG_DCDBAS=m
> CONFIG_DMIID=y
> CONFIG_DMI_SYSFS=y
> CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
> CONFIG_ISCSI_IBFT_FIND=y
> CONFIG_ISCSI_IBFT=m
> # CONFIG_FW_CFG_SYSFS is not set
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # EFI (Extensible Firmware Interface) Support
> #
> CONFIG_EFI_VARS=y
> CONFIG_EFI_ESRT=y
> CONFIG_EFI_VARS_PSTORE=y
> CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
> CONFIG_EFI_RUNTIME_MAP=y
> # CONFIG_EFI_FAKE_MEMMAP is not set
> CONFIG_EFI_RUNTIME_WRAPPERS=y
> # CONFIG_EFI_BOOTLOADER_CONTROL is not set
> # CONFIG_EFI_CAPSULE_LOADER is not set
> # CONFIG_EFI_TEST is not set
> # CONFIG_APPLE_PROPERTIES is not set
> CONFIG_UEFI_CPER=y
> # CONFIG_EFI_DEV_PATH_PARSER is not set
> 
> #
> # Tegra firmware driver
> #
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_FS_IOMAP=y
> # CONFIG_EXT2_FS is not set
> # CONFIG_EXT3_FS is not set
> CONFIG_EXT4_FS=m
> CONFIG_EXT4_USE_FOR_EXT2=y
> CONFIG_EXT4_FS_POSIX_ACL=y
> CONFIG_EXT4_FS_SECURITY=y
> # CONFIG_EXT4_ENCRYPTION is not set
> # CONFIG_EXT4_DEBUG is not set
> CONFIG_JBD2=m
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=m
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> CONFIG_XFS_FS=m
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> # CONFIG_XFS_RT is not set
> # CONFIG_XFS_WARN is not set
> # CONFIG_XFS_DEBUG is not set
> CONFIG_GFS2_FS=m
> CONFIG_GFS2_FS_LOCKING_DLM=y
> # CONFIG_OCFS2_FS is not set
> CONFIG_BTRFS_FS=m
> CONFIG_BTRFS_FS_POSIX_ACL=y
> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
> # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
> # CONFIG_BTRFS_DEBUG is not set
> # CONFIG_BTRFS_ASSERT is not set
> # CONFIG_NILFS2_FS is not set
> # CONFIG_F2FS_FS is not set
> CONFIG_FS_DAX=y
> CONFIG_FS_DAX_PMD=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> # CONFIG_EXPORTFS_BLOCK_OPS is not set
> CONFIG_FILE_LOCKING=y
> CONFIG_MANDATORY_FILE_LOCKING=y
> # CONFIG_FS_ENCRYPTION is not set
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> CONFIG_FANOTIFY=y
> CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
> CONFIG_QUOTA=y
> CONFIG_QUOTA_NETLINK_INTERFACE=y
> CONFIG_PRINT_QUOTA_WARNING=y
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=y
> # CONFIG_QFMT_V1 is not set
> CONFIG_QFMT_V2=y
> CONFIG_QUOTACTL=y
> CONFIG_QUOTACTL_COMPAT=y
> CONFIG_AUTOFS4_FS=y
> CONFIG_FUSE_FS=m
> CONFIG_CUSE=m
> CONFIG_OVERLAY_FS=m
> # CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=m
> CONFIG_FSCACHE_STATS=y
> # CONFIG_FSCACHE_HISTOGRAM is not set
> # CONFIG_FSCACHE_DEBUG is not set
> # CONFIG_FSCACHE_OBJECT_LIST is not set
> CONFIG_CACHEFILES=m
> # CONFIG_CACHEFILES_DEBUG is not set
> # CONFIG_CACHEFILES_HISTOGRAM is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=m
> CONFIG_JOLIET=y
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=m
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=m
> CONFIG_MSDOS_FS=m
> CONFIG_VFAT_FS=m
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
> # CONFIG_FAT_DEFAULT_UTF8 is not set
> # CONFIG_NTFS_FS is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_VMCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> # CONFIG_PROC_CHILDREN is not set
> CONFIG_KERNFS=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_TMPFS_XATTR=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
> CONFIG_CONFIGFS_FS=y
> CONFIG_EFIVAR_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> # CONFIG_ORANGEFS_FS is not set
> # CONFIG_ADFS_FS is not set
> # CONFIG_AFFS_FS is not set
> # CONFIG_ECRYPT_FS is not set
> # CONFIG_HFS_FS is not set
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> # CONFIG_JFFS2_FS is not set
> # CONFIG_UBIFS_FS is not set
> CONFIG_CRAMFS=m
> CONFIG_SQUASHFS=m
> CONFIG_SQUASHFS_FILE_CACHE=y
> # CONFIG_SQUASHFS_FILE_DIRECT is not set
> CONFIG_SQUASHFS_DECOMP_SINGLE=y
> # CONFIG_SQUASHFS_DECOMP_MULTI is not set
> # CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
> CONFIG_SQUASHFS_XATTR=y
> CONFIG_SQUASHFS_ZLIB=y
> # CONFIG_SQUASHFS_LZ4 is not set
> CONFIG_SQUASHFS_LZO=y
> CONFIG_SQUASHFS_XZ=y
> # CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
> # CONFIG_SQUASHFS_EMBEDDED is not set
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> # CONFIG_VXFS_FS is not set
> # CONFIG_MINIX_FS is not set
> # CONFIG_OMFS_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_QNX6FS_FS is not set
> # CONFIG_ROMFS_FS is not set
> CONFIG_PSTORE=y
> CONFIG_PSTORE_ZLIB_COMPRESS=y
> # CONFIG_PSTORE_LZO_COMPRESS is not set
> # CONFIG_PSTORE_LZ4_COMPRESS is not set
> # CONFIG_PSTORE_CONSOLE is not set
> # CONFIG_PSTORE_PMSG is not set
> # CONFIG_PSTORE_FTRACE is not set
> CONFIG_PSTORE_RAM=m
> # CONFIG_SYSV_FS is not set
> # CONFIG_UFS_FS is not set
> # CONFIG_EXOFS_FS is not set
> CONFIG_ORE=m
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=m
> # CONFIG_NFS_V2 is not set
> CONFIG_NFS_V3=m
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFS_V4=m
> # CONFIG_NFS_SWAP is not set
> CONFIG_NFS_V4_1=y
> CONFIG_NFS_V4_2=y
> CONFIG_PNFS_FILE_LAYOUT=m
> CONFIG_PNFS_BLOCK=m
> CONFIG_PNFS_OBJLAYOUT=m
> CONFIG_PNFS_FLEXFILE_LAYOUT=m
> CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
> # CONFIG_NFS_V4_1_MIGRATION is not set
> CONFIG_NFS_V4_SECURITY_LABEL=y
> CONFIG_NFS_FSCACHE=y
> # CONFIG_NFS_USE_LEGACY_DNS is not set
> CONFIG_NFS_USE_KERNEL_DNS=y
> CONFIG_NFS_DEBUG=y
> CONFIG_NFSD=m
> CONFIG_NFSD_V2_ACL=y
> CONFIG_NFSD_V3=y
> CONFIG_NFSD_V3_ACL=y
> CONFIG_NFSD_V4=y
> # CONFIG_NFSD_BLOCKLAYOUT is not set
> # CONFIG_NFSD_SCSILAYOUT is not set
> # CONFIG_NFSD_FLEXFILELAYOUT is not set
> CONFIG_NFSD_V4_SECURITY_LABEL=y
> # CONFIG_NFSD_FAULT_INJECTION is not set
> CONFIG_GRACE_PERIOD=m
> CONFIG_LOCKD=m
> CONFIG_LOCKD_V4=y
> CONFIG_NFS_ACL_SUPPORT=m
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=m
> CONFIG_SUNRPC_GSS=m
> CONFIG_SUNRPC_BACKCHANNEL=y
> CONFIG_RPCSEC_GSS_KRB5=m
> CONFIG_SUNRPC_DEBUG=y
> CONFIG_SUNRPC_XPRT_RDMA=m
> CONFIG_CEPH_FS=m
> # CONFIG_CEPH_FSCACHE is not set
> # CONFIG_CEPH_FS_POSIX_ACL is not set
> CONFIG_CIFS=m
> CONFIG_CIFS_STATS=y
> # CONFIG_CIFS_STATS2 is not set
> CONFIG_CIFS_WEAK_PW_HASH=y
> CONFIG_CIFS_UPCALL=y
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> CONFIG_CIFS_ACL=y
> CONFIG_CIFS_DEBUG=y
> # CONFIG_CIFS_DEBUG2 is not set
> CONFIG_CIFS_DFS_UPCALL=y
> CONFIG_CIFS_SMB2=y
> # CONFIG_CIFS_SMB311 is not set
> # CONFIG_CIFS_FSCACHE is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="utf8"
> CONFIG_NLS_CODEPAGE_437=y
> CONFIG_NLS_CODEPAGE_737=m
> CONFIG_NLS_CODEPAGE_775=m
> CONFIG_NLS_CODEPAGE_850=m
> CONFIG_NLS_CODEPAGE_852=m
> CONFIG_NLS_CODEPAGE_855=m
> CONFIG_NLS_CODEPAGE_857=m
> CONFIG_NLS_CODEPAGE_860=m
> CONFIG_NLS_CODEPAGE_861=m
> CONFIG_NLS_CODEPAGE_862=m
> CONFIG_NLS_CODEPAGE_863=m
> CONFIG_NLS_CODEPAGE_864=m
> CONFIG_NLS_CODEPAGE_865=m
> CONFIG_NLS_CODEPAGE_866=m
> CONFIG_NLS_CODEPAGE_869=m
> CONFIG_NLS_CODEPAGE_936=m
> CONFIG_NLS_CODEPAGE_950=m
> CONFIG_NLS_CODEPAGE_932=m
> CONFIG_NLS_CODEPAGE_949=m
> CONFIG_NLS_CODEPAGE_874=m
> CONFIG_NLS_ISO8859_8=m
> CONFIG_NLS_CODEPAGE_1250=m
> CONFIG_NLS_CODEPAGE_1251=m
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=m
> CONFIG_NLS_ISO8859_2=m
> CONFIG_NLS_ISO8859_3=m
> CONFIG_NLS_ISO8859_4=m
> CONFIG_NLS_ISO8859_5=m
> CONFIG_NLS_ISO8859_6=m
> CONFIG_NLS_ISO8859_7=m
> CONFIG_NLS_ISO8859_9=m
> CONFIG_NLS_ISO8859_13=m
> CONFIG_NLS_ISO8859_14=m
> CONFIG_NLS_ISO8859_15=m
> CONFIG_NLS_KOI8_R=m
> CONFIG_NLS_KOI8_U=m
> CONFIG_NLS_MAC_ROMAN=m
> CONFIG_NLS_MAC_CELTIC=m
> CONFIG_NLS_MAC_CENTEURO=m
> CONFIG_NLS_MAC_CROATIAN=m
> CONFIG_NLS_MAC_CYRILLIC=m
> CONFIG_NLS_MAC_GAELIC=m
> CONFIG_NLS_MAC_GREEK=m
> CONFIG_NLS_MAC_ICELAND=m
> CONFIG_NLS_MAC_INUIT=m
> CONFIG_NLS_MAC_ROMANIAN=m
> CONFIG_NLS_MAC_TURKISH=m
> CONFIG_NLS_UTF8=m
> CONFIG_DLM=m
> CONFIG_DLM_DEBUG=y
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> 
> #
> # printk and dmesg options
> #
> CONFIG_PRINTK_TIME=y
> CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
> CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
> CONFIG_BOOT_PRINTK_DELAY=y
> CONFIG_DYNAMIC_DEBUG=y
> 
> #
> # Compile-time checks and compiler options
> #
> CONFIG_DEBUG_INFO=y
> # CONFIG_DEBUG_INFO_REDUCED is not set
> # CONFIG_DEBUG_INFO_SPLIT is not set
> # CONFIG_DEBUG_INFO_DWARF4 is not set
> # CONFIG_GDB_SCRIPTS is not set
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=2048
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_READABLE_ASM is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> # CONFIG_PAGE_OWNER is not set
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> CONFIG_DEBUG_SECTION_MISMATCH=y
> CONFIG_SECTION_MISMATCH_WARN_ONLY=y
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_STACK_VALIDATION is not set
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
> CONFIG_MAGIC_SYSRQ_SERIAL=y
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> # CONFIG_PAGE_EXTENSION is not set
> # CONFIG_DEBUG_PAGEALLOC is not set
> # CONFIG_PAGE_POISONING is not set
> # CONFIG_DEBUG_PAGE_REF is not set
> CONFIG_DEBUG_RODATA_TEST=y
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_SLUB_DEBUG_ON is not set
> # CONFIG_SLUB_STATS is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_VM is not set
> CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
> # CONFIG_DEBUG_VIRTUAL is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> # CONFIG_DEBUG_PER_CPU_MAPS is not set
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> CONFIG_DEBUG_STACKOVERFLOW=y
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> CONFIG_HAVE_ARCH_KASAN=y
> # CONFIG_KASAN is not set
> CONFIG_ARCH_HAS_KCOV=y
> # CONFIG_KCOV is not set
> CONFIG_DEBUG_SHIRQ=y
> 
> #
> # Debug Lockups and Hangs
> #
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> # CONFIG_WQ_WATCHDOG is not set
> CONFIG_PANIC_ON_OOPS=y
> CONFIG_PANIC_ON_OOPS_VALUE=1
> CONFIG_PANIC_TIMEOUT=0
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHED_INFO=y
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_SCHED_STACK_END_CHECK is not set
> # CONFIG_DEBUG_TIMEKEEPING is not set
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_ATOMIC_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_LOCK_TORTURE_TEST is not set
> # CONFIG_WW_MUTEX_SELFTEST is not set
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_LIST=y
> # CONFIG_DEBUG_PI_LIST is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> 
> #
> # RCU Debugging
> #
> # CONFIG_PROVE_RCU is not set
> CONFIG_SPARSE_RCU_POINTER=y
> # CONFIG_TORTURE_TEST is not set
> # CONFIG_RCU_PERF_TEST is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> # CONFIG_RCU_TRACE is not set
> # CONFIG_RCU_EQS_DEBUG is not set
> # CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_LATENCYTOP is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_FENTRY=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACER_MAX_TRACE=y
> CONFIG_TRACE_CLOCK=y
> CONFIG_RING_BUFFER=y
> CONFIG_EVENT_TRACING=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_RING_BUFFER_ALLOW_SWAP=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> CONFIG_FUNCTION_TRACER=y
> CONFIG_FUNCTION_GRAPH_TRACER=y
> # CONFIG_IRQSOFF_TRACER is not set
> CONFIG_SCHED_TRACER=y
> # CONFIG_HWLAT_TRACER is not set
> CONFIG_FTRACE_SYSCALLS=y
> CONFIG_TRACER_SNAPSHOT=y
> # CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
> CONFIG_BRANCH_PROFILE_NONE=y
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> CONFIG_STACK_TRACER=y
> CONFIG_BLK_DEV_IO_TRACE=y
> CONFIG_KPROBE_EVENTS=y
> # CONFIG_UPROBE_EVENTS is not set
> CONFIG_PROBE_EVENTS=y
> CONFIG_DYNAMIC_FTRACE=y
> CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_FUNCTION_PROFILER=y
> CONFIG_FTRACE_MCOUNT_RECORD=y
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_MMIOTRACE is not set
> # CONFIG_HIST_TRIGGERS is not set
> # CONFIG_TRACEPOINT_BENCHMARK is not set
> CONFIG_RING_BUFFER_BENCHMARK=m
> # CONFIG_RING_BUFFER_STARTUP_TEST is not set
> # CONFIG_TRACE_ENUM_MAP_FILE is not set
> 
> #
> # Runtime Testing
> #
> # CONFIG_LKDTM is not set
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_TEST_SORT is not set
> # CONFIG_KPROBES_SANITY_TEST is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_RBTREE_TEST is not set
> # CONFIG_INTERVAL_TREE_TEST is not set
> # CONFIG_PERCPU_TEST is not set
> CONFIG_ATOMIC64_SELFTEST=y
> CONFIG_ASYNC_RAID6_TEST=m
> # CONFIG_TEST_HEXDUMP is not set
> # CONFIG_TEST_STRING_HELPERS is not set
> CONFIG_TEST_KSTRTOX=y
> # CONFIG_TEST_PRINTF is not set
> # CONFIG_TEST_BITMAP is not set
> # CONFIG_TEST_UUID is not set
> # CONFIG_TEST_RHASHTABLE is not set
> # CONFIG_TEST_HASH is not set
> CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_TEST_LKM is not set
> # CONFIG_TEST_USER_COPY is not set
> # CONFIG_TEST_BPF is not set
> # CONFIG_TEST_FIRMWARE is not set
> # CONFIG_TEST_UDELAY is not set
> # CONFIG_MEMTEST is not set
> # CONFIG_TEST_STATIC_KEYS is not set
> # CONFIG_BUG_ON_DATA_CORRUPTION is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> CONFIG_KGDB=y
> CONFIG_KGDB_SERIAL_CONSOLE=y
> CONFIG_KGDB_TESTS=y
> # CONFIG_KGDB_TESTS_ON_BOOT is not set
> CONFIG_KGDB_LOW_LEVEL_TRAP=y
> CONFIG_KGDB_KDB=y
> CONFIG_KDB_DEFAULT_ENABLE=0x1
> CONFIG_KDB_KEYBOARD=y
> CONFIG_KDB_CONTINUE_CATASTROPHIC=0
> CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
> # CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
> # CONFIG_UBSAN is not set
> CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
> CONFIG_STRICT_DEVMEM=y
> CONFIG_IO_STRICT_DEVMEM=y
> # CONFIG_X86_VERBOSE_BOOTUP is not set
> CONFIG_EARLY_PRINTK=y
> CONFIG_EARLY_PRINTK_DBGP=y
> CONFIG_EARLY_PRINTK_EFI=y
> # CONFIG_X86_PTDUMP_CORE is not set
> # CONFIG_X86_PTDUMP is not set
> # CONFIG_EFI_PGT_DUMP is not set
> # CONFIG_DEBUG_WX is not set
> CONFIG_DOUBLEFAULT=y
> # CONFIG_DEBUG_TLBFLUSH is not set
> # CONFIG_IOMMU_DEBUG is not set
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_X86_DECODER_SELFTEST=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> CONFIG_IO_DELAY_0X80=y
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=0
> CONFIG_DEBUG_BOOT_PARAMS=y
> # CONFIG_CPA_DEBUG is not set
> CONFIG_OPTIMIZE_INLINING=y
> # CONFIG_DEBUG_ENTRY is not set
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> CONFIG_X86_DEBUG_FPU=y
> # CONFIG_PUNIT_ATOM_DEBUG is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> CONFIG_PERSISTENT_KEYRINGS=y
> CONFIG_BIG_KEYS=y
> CONFIG_TRUSTED_KEYS=y
> CONFIG_ENCRYPTED_KEYS=y
> # CONFIG_KEY_DH_OPERATIONS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> CONFIG_SECURITY=y
> CONFIG_SECURITYFS=y
> CONFIG_SECURITY_NETWORK=y
> CONFIG_SECURITY_NETWORK_XFRM=y
> # CONFIG_SECURITY_PATH is not set
> CONFIG_INTEL_TXT=y
> CONFIG_LSM_MMAP_MIN_ADDR=65535
> CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
> CONFIG_HAVE_ARCH_HARDENED_USERCOPY=y
> # CONFIG_HARDENED_USERCOPY is not set
> # CONFIG_STATIC_USERMODEHELPER is not set
> CONFIG_SECURITY_SELINUX=y
> CONFIG_SECURITY_SELINUX_BOOTPARAM=y
> CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
> CONFIG_SECURITY_SELINUX_DISABLE=y
> CONFIG_SECURITY_SELINUX_DEVELOP=y
> CONFIG_SECURITY_SELINUX_AVC_STATS=y
> CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
> # CONFIG_SECURITY_SMACK is not set
> # CONFIG_SECURITY_TOMOYO is not set
> # CONFIG_SECURITY_APPARMOR is not set
> # CONFIG_SECURITY_LOADPIN is not set
> # CONFIG_SECURITY_YAMA is not set
> CONFIG_INTEGRITY=y
> CONFIG_INTEGRITY_SIGNATURE=y
> CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
> CONFIG_INTEGRITY_TRUSTED_KEYRING=y
> CONFIG_INTEGRITY_AUDIT=y
> CONFIG_IMA=y
> CONFIG_IMA_MEASURE_PCR_IDX=10
> CONFIG_IMA_LSM_RULES=y
> # CONFIG_IMA_TEMPLATE is not set
> CONFIG_IMA_NG_TEMPLATE=y
> # CONFIG_IMA_SIG_TEMPLATE is not set
> CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
> CONFIG_IMA_DEFAULT_HASH_SHA1=y
> # CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
> # CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
> # CONFIG_IMA_DEFAULT_HASH_WP512 is not set
> CONFIG_IMA_DEFAULT_HASH="sha1"
> # CONFIG_IMA_WRITE_POLICY is not set
> # CONFIG_IMA_READ_POLICY is not set
> CONFIG_IMA_APPRAISE=y
> CONFIG_IMA_TRUSTED_KEYRING=y
> # CONFIG_IMA_BLACKLIST_KEYRING is not set
> # CONFIG_IMA_LOAD_X509 is not set
> CONFIG_EVM=y
> CONFIG_EVM_ATTR_FSUUID=y
> # CONFIG_EVM_LOAD_X509 is not set
> CONFIG_DEFAULT_SECURITY_SELINUX=y
> # CONFIG_DEFAULT_SECURITY_DAC is not set
> CONFIG_DEFAULT_SECURITY="selinux"
> CONFIG_XOR_BLOCKS=m
> CONFIG_ASYNC_CORE=m
> CONFIG_ASYNC_MEMCPY=m
> CONFIG_ASYNC_XOR=m
> CONFIG_ASYNC_PQ=m
> CONFIG_ASYNC_RAID6_RECOV=m
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_FIPS=y
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_RNG_DEFAULT=y
> CONFIG_CRYPTO_AKCIPHER2=y
> CONFIG_CRYPTO_AKCIPHER=y
> CONFIG_CRYPTO_KPP2=y
> CONFIG_CRYPTO_KPP=m
> CONFIG_CRYPTO_ACOMP2=y
> CONFIG_CRYPTO_RSA=y
> CONFIG_CRYPTO_DH=m
> # CONFIG_CRYPTO_ECDH is not set
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_USER=m
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_CRYPTO_GF128MUL=m
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_NULL2=y
> CONFIG_CRYPTO_PCRYPT=m
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=m
> CONFIG_CRYPTO_MCRYPTD=m
> CONFIG_CRYPTO_AUTHENC=m
> CONFIG_CRYPTO_TEST=m
> CONFIG_CRYPTO_ABLK_HELPER=m
> CONFIG_CRYPTO_SIMD=m
> CONFIG_CRYPTO_GLUE_HELPER_X86=m
> CONFIG_CRYPTO_ENGINE=m
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=m
> CONFIG_CRYPTO_GCM=m
> # CONFIG_CRYPTO_CHACHA20POLY1305 is not set
> CONFIG_CRYPTO_SEQIV=y
> CONFIG_CRYPTO_ECHAINIV=m
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=m
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_LRW=m
> CONFIG_CRYPTO_PCBC=m
> CONFIG_CRYPTO_XTS=m
> # CONFIG_CRYPTO_KEYWRAP is not set
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_CMAC=m
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=m
> CONFIG_CRYPTO_VMAC=m
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=m
> CONFIG_CRYPTO_CRC32=m
> CONFIG_CRYPTO_CRC32_PCLMUL=m
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
> CONFIG_CRYPTO_GHASH=m
> # CONFIG_CRYPTO_POLY1305 is not set
> # CONFIG_CRYPTO_POLY1305_X86_64 is not set
> CONFIG_CRYPTO_MD4=m
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=m
> CONFIG_CRYPTO_RMD128=m
> CONFIG_CRYPTO_RMD160=m
> CONFIG_CRYPTO_RMD256=m
> CONFIG_CRYPTO_RMD320=m
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA1_SSSE3=y
> CONFIG_CRYPTO_SHA256_SSSE3=y
> CONFIG_CRYPTO_SHA512_SSSE3=m
> CONFIG_CRYPTO_SHA1_MB=m
> # CONFIG_CRYPTO_SHA256_MB is not set
> # CONFIG_CRYPTO_SHA512_MB is not set
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=m
> # CONFIG_CRYPTO_SHA3 is not set
> CONFIG_CRYPTO_TGR192=m
> CONFIG_CRYPTO_WP512=m
> CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> # CONFIG_CRYPTO_AES_TI is not set
> CONFIG_CRYPTO_AES_X86_64=y
> CONFIG_CRYPTO_AES_NI_INTEL=m
> CONFIG_CRYPTO_ANUBIS=m
> CONFIG_CRYPTO_ARC4=m
> CONFIG_CRYPTO_BLOWFISH=m
> CONFIG_CRYPTO_BLOWFISH_COMMON=m
> CONFIG_CRYPTO_BLOWFISH_X86_64=m
> CONFIG_CRYPTO_CAMELLIA=m
> CONFIG_CRYPTO_CAMELLIA_X86_64=m
> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
> CONFIG_CRYPTO_CAST_COMMON=m
> CONFIG_CRYPTO_CAST5=m
> CONFIG_CRYPTO_CAST5_AVX_X86_64=m
> CONFIG_CRYPTO_CAST6=m
> CONFIG_CRYPTO_CAST6_AVX_X86_64=m
> CONFIG_CRYPTO_DES=m
> # CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
> CONFIG_CRYPTO_FCRYPT=m
> CONFIG_CRYPTO_KHAZAD=m
> CONFIG_CRYPTO_SALSA20=m
> CONFIG_CRYPTO_SALSA20_X86_64=m
> # CONFIG_CRYPTO_CHACHA20 is not set
> # CONFIG_CRYPTO_CHACHA20_X86_64 is not set
> CONFIG_CRYPTO_SEED=m
> CONFIG_CRYPTO_SERPENT=m
> CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
> CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
> CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
> CONFIG_CRYPTO_TEA=m
> CONFIG_CRYPTO_TWOFISH=m
> CONFIG_CRYPTO_TWOFISH_COMMON=m
> CONFIG_CRYPTO_TWOFISH_X86_64=m
> CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
> CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=m
> CONFIG_CRYPTO_LZO=y
> # CONFIG_CRYPTO_842 is not set
> # CONFIG_CRYPTO_LZ4 is not set
> # CONFIG_CRYPTO_LZ4HC is not set
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=m
> CONFIG_CRYPTO_DRBG_MENU=y
> CONFIG_CRYPTO_DRBG_HMAC=y
> CONFIG_CRYPTO_DRBG_HASH=y
> CONFIG_CRYPTO_DRBG_CTR=y
> CONFIG_CRYPTO_DRBG=y
> CONFIG_CRYPTO_JITTERENTROPY=y
> CONFIG_CRYPTO_USER_API=y
> CONFIG_CRYPTO_USER_API_HASH=y
> CONFIG_CRYPTO_USER_API_SKCIPHER=y
> # CONFIG_CRYPTO_USER_API_RNG is not set
> # CONFIG_CRYPTO_USER_API_AEAD is not set
> CONFIG_CRYPTO_HASH_INFO=y
> CONFIG_CRYPTO_HW=y
> CONFIG_CRYPTO_DEV_PADLOCK=m
> CONFIG_CRYPTO_DEV_PADLOCK_AES=m
> CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
> # CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC is not set
> # CONFIG_CRYPTO_DEV_CCP is not set
> CONFIG_CRYPTO_DEV_QAT=m
> CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
> # CONFIG_CRYPTO_DEV_QAT_C3XXX is not set
> # CONFIG_CRYPTO_DEV_QAT_C62X is not set
> # CONFIG_CRYPTO_DEV_QAT_DH895xCCVF is not set
> # CONFIG_CRYPTO_DEV_QAT_C3XXXVF is not set
> # CONFIG_CRYPTO_DEV_QAT_C62XVF is not set
> # CONFIG_CRYPTO_DEV_CHELSIO is not set
> CONFIG_CRYPTO_DEV_VIRTIO=m
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> CONFIG_X509_CERTIFICATE_PARSER=y
> CONFIG_PKCS7_MESSAGE_PARSER=y
> # CONFIG_PKCS7_TEST_KEY is not set
> CONFIG_SIGNED_PE_FILE_VERIFICATION=y
> 
> #
> # Certificates for signature checking
> #
> CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
> CONFIG_SYSTEM_TRUSTED_KEYRING=y
> CONFIG_SYSTEM_TRUSTED_KEYS=""
> # CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
> # CONFIG_SECONDARY_TRUSTED_KEYRING is not set
> CONFIG_HAVE_KVM=y
> CONFIG_HAVE_KVM_IRQCHIP=y
> CONFIG_HAVE_KVM_IRQFD=y
> CONFIG_HAVE_KVM_IRQ_ROUTING=y
> CONFIG_HAVE_KVM_EVENTFD=y
> CONFIG_KVM_MMIO=y
> CONFIG_KVM_ASYNC_PF=y
> CONFIG_HAVE_KVM_MSI=y
> CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
> CONFIG_KVM_VFIO=y
> CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
> CONFIG_KVM_COMPAT=y
> CONFIG_HAVE_KVM_IRQ_BYPASS=y
> CONFIG_VIRTUALIZATION=y
> CONFIG_KVM=m
> CONFIG_KVM_INTEL=m
> CONFIG_KVM_AMD=m
> CONFIG_KVM_MMU_AUDIT=y
> # CONFIG_KVM_DEVICE_ASSIGNMENT is not set
> CONFIG_VHOST_NET=m
> # CONFIG_VHOST_SCSI is not set
> # CONFIG_VHOST_VSOCK is not set
> CONFIG_VHOST=m
> # CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=m
> CONFIG_BITREVERSE=y
> # CONFIG_HAVE_ARCH_BITREVERSE is not set
> CONFIG_RATIONAL=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
> CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=m
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> CONFIG_CRC32_SLICEBY8=y
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> # CONFIG_CRC7 is not set
> CONFIG_LIBCRC32C=m
> CONFIG_CRC8=m
> # CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
> # CONFIG_RANDOM32_SELFTEST is not set
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> CONFIG_XZ_DEC_POWERPC=y
> CONFIG_XZ_DEC_IA64=y
> CONFIG_XZ_DEC_ARM=y
> CONFIG_XZ_DEC_ARMTHUMB=y
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> # CONFIG_XZ_DEC_TEST is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_XZ=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_DECOMPRESS_LZ4=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_REED_SOLOMON=m
> CONFIG_REED_SOLOMON_ENC8=y
> CONFIG_REED_SOLOMON_DEC8=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=m
> CONFIG_TEXTSEARCH_BM=m
> CONFIG_TEXTSEARCH_FSM=m
> CONFIG_BTREE=y
> CONFIG_INTERVAL_TREE=y
> CONFIG_RADIX_TREE_MULTIORDER=y
> CONFIG_ASSOCIATIVE_ARRAY=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT_MAP=y
> CONFIG_HAS_DMA=y
> # CONFIG_DMA_NOOP_OPS is not set
> CONFIG_DMA_VIRT_OPS=y
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_CPUMASK_OFFSTACK=y
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_GLOB=y
> # CONFIG_GLOB_SELFTEST is not set
> CONFIG_NLATTR=y
> CONFIG_CLZ_TAB=y
> CONFIG_CORDIC=m
> # CONFIG_DDR is not set
> CONFIG_IRQ_POLL=y
> CONFIG_MPILIB=y
> CONFIG_SIGNATURE=y
> CONFIG_OID_REGISTRY=y
> CONFIG_UCS2_STRING=y
> CONFIG_FONT_SUPPORT=y
> # CONFIG_FONTS is not set
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y
> # CONFIG_SG_SPLIT is not set
> CONFIG_SG_POOL=y
> CONFIG_ARCH_HAS_SG_CHAIN=y
> CONFIG_ARCH_HAS_PMEM_API=y
> CONFIG_ARCH_HAS_MMIO_FLUSH=y
> CONFIG_SBITMAP=y

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
