Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x232.google.com (mail-it0-x232.google.com
 [IPv6:2607:f8b0:4001:c0b::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D4DF2194235C
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 07:49:45 -0700 (PDT)
Received: by mail-it0-x232.google.com with SMTP id 70so752251ita.0
 for <linux-nvdimm@lists.01.org>; Fri, 07 Apr 2017 07:49:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 7 Apr 2017 07:49:43 -0700
Message-ID: <CAJcbSZGWLC+QCk8GuBneL2ho2eXfyKdVrP4uUgvbSv-GoXissg@mail.gmail.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, linux-nvdimm@lists.01.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

CCing Kees for information.

On Fri, Apr 7, 2017 at 7:41 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
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

Did you try to repro on qemu?

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

Thanks for looking into it. I will look into getting a repro on qemu
or a dedicated machine.

If anyone has a guess on the cause, please let me know.

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



-- 
Thomas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
