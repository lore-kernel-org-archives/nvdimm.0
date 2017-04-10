Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E777621A04802
 for <linux-nvdimm@lists.01.org>; Mon, 10 Apr 2017 13:34:30 -0700 (PDT)
Date: Mon, 10 Apr 2017 14:34:29 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] dax: fix radix tree insertion race
Message-ID: <20170410203429.GA17140@linux.intel.com>
References: <20170406212944.2866-1-ross.zwisler@linux.intel.com>
 <20170410134111.GF3224@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170410134111.GF3224@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 10, 2017 at 03:41:11PM +0200, Jan Kara wrote:
> On Thu 06-04-17 15:29:44, Ross Zwisler wrote:
> > While running generic/340 in my test setup I hit the following race. It can
> > happen with kernels that support FS DAX PMDs, so v4.10 thru v4.11-rc5.
> > 
> > Thread 1				Thread 2
> > --------				--------
> > dax_iomap_pmd_fault()
> >   grab_mapping_entry()
> >     spin_lock_irq()
> >     get_unlocked_mapping_entry()
> >     'entry' is NULL, can't call lock_slot()
> >     spin_unlock_irq()
> >     radix_tree_preload()
> > 					dax_iomap_pmd_fault()
> > 					  grab_mapping_entry()
> > 					    spin_lock_irq()
> > 					    get_unlocked_mapping_entry()
> > 					    ...
> > 					    lock_slot()
> > 					    spin_unlock_irq()
> > 					  dax_pmd_insert_mapping()
> > 					    <inserts a PMD mapping>
> >     spin_lock_irq()
> >     __radix_tree_insert() fails with -EEXIST
> >     <fall back to 4k fault, and die horribly
> >      when inserting a 4k entry where a PMD exists>
> > 
> > The issue is that we have to drop mapping->tree_lock while calling
> > radix_tree_preload(), but since we didn't have a radix tree entry to lock
> > (unlike in the pmd_downgrade case) we have no protection against Thread 2
> > coming along and inserting a PMD at the same index.  For 4k entries we
> > handled this with a special-case response to -EEXIST coming from the
> > __radix_tree_insert(), but this doesn't save us for PMDs because the
> > -EEXIST case can also mean that we collided with a 4k entry in the radix
> > tree at a different index, but one that is covered by our PMD range.
> > 
> > So, correctly handle both the 4k and 2M collision cases by explicitly
> > re-checking the radix tree for an entry at our index once we reacquire
> > mapping->tree_lock.
> > 
> > This patch has made it through a clean xfstests run with the current
> > v4.11-rc5 based linux/master, and it also ran generic/340 500 times in a
> > loop.  It used to fail within the first 10 iterations.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Cc: <stable@vger.kernel.org>    [4.10+]
> 
> The patch looks good to me (and I can see Andrew already sent it to Linus),
> I'm just worndering where did things actually go wrong? I'd expect we would
> return VM_FAULT_FALLBACK from dax_iomap_pmd_fault() and then do PTE fault
> for the address which should just work out fine...

Yep, that's what I thought as well, and I think it does work for processes
which have separate page tables.  The second process will do a 4k fault (just
as it would have if it had a VMA that was smaller than 2MiB, for example), map
the 4k page into its page table and just dirty the 2MiB DAX entry in the radix
tree.  I've tested this case manually in the past.

I think the error case that I was seeing was for threads that share page
tables.  In that case the 2nd thread falls back to PTEs, but there is already
a PMD in the page table from the first fault.  When we try and insert a PTE
over the PMD we get the following BUG:

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: do_raw_spin_trylock+0x5/0x40
PGD 8d6ee0067
PUD 8db6e8067
PMD 0

Oops: 0000 [#1] PREEMPT SMP
Modules linked in: dax_pmem nd_pmem dax nd_btt nd_e820 libnvdimm [last unloaded: scsi_debug]
CPU: 2 PID: 25323 Comm: holetest Not tainted 4.11.0-rc4 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.fc25 04/01/2014
task: ffff880095492a00 task.stack: ffffc90014048000
RIP: 0010:do_raw_spin_trylock+0x5/0x40
RSP: 0000:ffffc9001404bb60 EFLAGS: 00010296
RAX: ffff880095492a00 RBX: 0000000000000018 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9001404bb80 R08: 0000000000000001 R09: 0000000000000000
R10: ffff880095492a00 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8808d5fe4220 R14: ffff88004c3e3c80 R15: 8000000000000025
FS:  00007f7ed7dff700(0000) GS:ffff8808de400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000008d86f6000 CR4: 00000000001406e0
Call Trace:
 ? _raw_spin_lock+0x49/0x80
 ? __get_locked_pte+0x16b/0x1d0
 __get_locked_pte+0x16b/0x1d0
 insert_pfn.isra.68+0x3a/0x100
 vm_insert_mixed+0x64/0x90
 dax_iomap_fault+0xa41/0x1680
 ext4_dax_huge_fault+0xa9/0xd0
 ext4_dax_fault+0x10/0x20
 __do_fault+0x20/0x130
 __handle_mm_fault+0x9b3/0x1190
 handle_mm_fault+0x169/0x370
 ? handle_mm_fault+0x47/0x370
 __do_page_fault+0x28f/0x590
 trace_do_page_fault+0x58/0x2c0
 do_async_page_fault+0x2c/0x90
 async_page_fault+0x28/0x30
RIP: 0033:0x4014b2
RSP: 002b:00007f7ed7dfef20 EFLAGS: 00010216
RAX: 00007f7ec6c00400 RBX: 0000000000010000 RCX: 0000000001c00000
RDX: 0000000000001c01 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00007f7ed7dff700 R08: 00007f7ed7dff700 R09: 00007f7ed7dff700
R10: 00007f7ed7dff9d0 R11: 0000000000000202 R12: 00007f7ec6c00000
R13: 00007ffe3ffb5b60 R14: 0000000000000400 R15: 00007f7ed7dff700
Code: 30 84 ee 81 48 89 df e8 4a fe ff ff eb 89 89 c6 48 89 df e8 7e e7 ff ff eb 8c 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 <8b> 07 55 48 89 e5 85 c0 75 2b ba 01 00 00 00 f0 0f b1 17 85 c0
RIP: do_raw_spin_trylock+0x5/0x40 RSP: ffffc9001404bb60
CR2: 0000000000000000
---[ end trace 75d38250d89b67cd ]---
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
