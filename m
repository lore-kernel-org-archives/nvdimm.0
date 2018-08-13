Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E7E4210EE4CB
 for <linux-nvdimm@lists.01.org>; Mon, 13 Aug 2018 03:12:54 -0700 (PDT)
Date: Mon, 13 Aug 2018 12:12:52 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 1/2] dax: dax_layout_busy_page() warn on !exceptional
Message-ID: <20180813101252.GC8927@quack2.suse.cz>
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180710191031.17919-2-ross.zwisler@linux.intel.com>
 <6ca60cf6-f1dc-27d5-fb79-7547aea39dfa@redhat.com>
 <20180810203349.GH627@thunk.org> <20180811021053.GB14368@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180811021053.GB14368@thunk.org>
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
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: sandeen@redhat.com, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri 10-08-18 22:10:53, Theodore Y. Ts'o wrote:
> On Fri, Aug 10, 2018 at 04:33:49PM -0400, Theodore Y. Ts'o wrote:
> > I just kicked off a DAX test ("gce-xfstests -c dax -g auto") with
> > CONFIG_KASAN disabled, and I expect it shouldn't show up anything
> > concerning.  So assuming nothing surprising pops up, yes it should be
> > merged at the next merge window.
> 
> ... and here are the results.  The first is 4.17, and the second is
> the ext4 git tree:
> 
> ext4/dax: 488 tests, 4 failures, 97 skipped, 2647 seconds
>   Failures: ext4/033 generic/344 generic/491 generic/503
> 
> ext4/dax: 488 tests, 3 failures, 97 skipped, 2637 seconds
>   Failures: generic/081 generic/344 generic/388
> 
> The generic/388 failure is a known flake (shutdown stress test).
> 
> The generic/081 regression appears to be a device-mapper issue:
> 
> generic/081		[22:06:33][   15.079661] run fstests generic/081 at 2018-08-10 22:06:33
> [   15.795745] device-mapper: ioctl: can't change device type (old=4 vs new=1) after initial table load.
> [failed, exit status 1] [22:06:36]- output mismatch (see /results/ext4/results-dax/generic/081.out.bad)
>     --- tests/generic/081.out	2018-08-09 18:00:42.000000000 -0400
>     +++ /results/ext4/results-dax/generic/081.out.bad	2018-08-10 22:06:36.440005460 -0400
>     @@ -1,2 +1,4 @@
>      QA output created by 081
>      Silence is golden
>     +Failed to create snapshot
>     +(see /results/ext4/results-dax/generic/081.full for details)
>     ...
>     (Run 'diff -u tests/generic/081.out /results/ext4/results-dax/generic/081.out.bad'  to see the entire diff)

I'll see if this reproduces for me. Doesn't seem to be related to the DAX
patches you caary though.

> The generic/344 failure seems to be caused by a WARNING triggered in
> the nvdimm code:

OK, apparently this is nothing new for you as generic/344 fails for you
even with 3.17. But it should not :). I'll try to see if I can reproduce
this in my test setup during more test runs (I don't remember seeing it
during occasional runs I do) and debug it further.

								Honza

> generic/344		[22:06:36][   18.126280] run fstests generic/344 at 2018-08-10 22:06:36
> [   18.303113] EXT4-fs (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> [   18.456988] EXT4-fs (pmem1): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> [   97.375912] WARNING: CPU: 2 PID: 1712 at /usr/projects/linux/ext4/mm/memory.c:1801 insert_pfn+0x15a/0x170
> [   97.377261] CPU: 2 PID: 1712 Comm: holetest Not tainted 4.18.0-rc4-xfstests-00039-g863c37fcb14f #497
> [   97.378486] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.1-1 04/01/2014
> [   97.379516] RIP: 0010:insert_pfn+0x15a/0x170
> [   97.380064] Code: 19 1b 01 eb dd 48 85 d2 74 07 48 23 1d 3f 19 1b 01 48 09 df 48 89 f8 0f 1f 40 00 48 b9 00 02 00 00 00 00 00 04 48 09 c1 eb c8 <0f> 0b e9 5e ff ff ff bb f4 ff ff ff e9 5e ff ff ff e8 80 7b ec ff 
> [   97.382469] RSP: 0000:ffffacfd0457fc60 EFLAGS: 00010206
> [   97.383123] RAX: 0000000000179e3b RBX: 00000000fffffff0 RCX: 0000000000000002
> [   97.384062] RDX: 000fffffffffffff RSI: 8f5c28f5c28f5c29 RDI: 8000000179e3b225
> [   97.385134] RBP: ffff923761654558 R08: 0000000000000001 R09: 0000000000000001
> [   97.386213] R10: ffff92376f415cc0 R11: 0000000000000001 R12: ffff92377e880cc0
> [   97.387264] R13: 00007fab98aab000 R14: 00000000003e860d R15: ffff923761560000
> [   97.388327] FS:  00007fab9049c700(0000) GS:ffff92377f200000(0000) knlGS:0000000000000000
> [   97.389514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   97.390367] CR2: 00007fab98aabc00 CR3: 00000006a165a004 CR4: 0000000000360ee0
> [   97.391432] Call Trace:
> [   97.391798]  __vm_insert_mixed+0x7e/0xc0
> [   97.392376]  vmf_insert_mixed_mkwrite+0xf/0x30
> [   97.393048]  dax_iomap_pte_fault+0xb8b/0xe40
> [   97.393691]  ext4_dax_huge_fault+0x145/0x200
> [   97.394268]  do_wp_page+0x175/0x5b0
> [   97.394710]  __handle_mm_fault+0x587/0xbb0
> [   97.395228]  __do_page_fault+0x20c/0x490
> [   97.395729]  ? async_page_fault+0x8/0x30
> [   97.396251]  async_page_fault+0x1e/0x30
> [   97.396719] RIP: 0033:0x5598144275ea
> [   97.397187] Code: 0f 85 8a 00 00 00 31 d2 48 85 db 4b 8d 04 34 7e 1f 0f 1f 80 00 00 00 00 48 89 d1 48 83 c2 01 48 0f af 0d 71 1b 20 00 48 39 d3 <48> 89 2c 08 75 e8 8b 0d 36 1b 20 00 31 c0 85 c9 74 0a 8b 15 2e 1b 
> [   97.399752] RSP: 002b:00007fab9049bf20 EFLAGS: 00010212
> [   97.400541] RAX: 00007fab90c9ec00 RBX: 0000000000010000 RCX: 0000000007e0d000
> [   97.401603] RDX: 0000000000007e0e RSI: 0000000000000000 RDI: 0000000000000001
> [   97.402673] RBP: 00007fab9049c700 R08: 00007fab9049c700 R09: 00007fab9049c700
> [   97.403755] R10: 00007fab9049c9d0 R11: 0000000000000202 R12: 00007fab90c9e000
> [   97.404851] R13: 00007ffc4608c9e0 R14: 0000000000000c00 R15: 000055981608e250
> [   97.405892] irq event stamp: 1111968
> [   97.406460] hardirqs last  enabled at (1111967): [<ffffffffa36c4409>] _raw_spin_unlock_irq+0x29/0x40
> [   97.407826] hardirqs last disabled at (1111968): [<ffffffffa380118f>] error_entry+0x7f/0x100
> [   97.409080] softirqs last  enabled at (1111390): [<ffffffffa3a00319>] __do_softirq+0x319/0x4d9
> [   97.410363] softirqs last disabled at (1111383): [<ffffffffa2e8c9e1>] irq_exit+0xc1/0xd0
> [   97.411400] ---[ end trace 69669a34a73c1a49 ]---
> [  117.726077] EXT4-fs (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> [  117.727671] EXT4-fs (pmem0): mounted filesystem with ordered data mode. Opts: acl,user_xattr,block_validity,dax
> [  117.796623] EXT4-fs (pmem1): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> [  117.798546] EXT4-fs (pmem1): mounted filesystem with ordered data mode. Opts: acl,user_xattr,block_validity,dax
> _check_dmesg: something found in dmesg (see /results/ext4/results-dax/generic/344.dmesg)
> 
> 		      		      	       - Ted
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
