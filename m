Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37F1621159C8D
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 11:22:35 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id p125-v6so3043377oic.3
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 11:22:35 -0700 (PDT)
MIME-Version: 1.0
References: <20180927112332.3649-1-jack@suse.cz>
 <20180927132843.GA19006@bombadil.infradead.org>
 <20180927134129.GB8800@quack2.suse.cz>
In-Reply-To: <20180927134129.GB8800@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Sep 2018 11:22:22 -0700
Message-ID: <CAPcyv4hut3P5fiNHgjpf4Qg_nBo9JKkovCdrUnzXyji=ey8zJw@mail.gmail.com>
Subject: Re: [PATCH] dax: Fix deadlock in dax_lock_mapping_entry()
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, brho@google.com, Matthew Wilcox <willy@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 27, 2018 at 6:41 AM Jan Kara <jack@suse.cz> wrote:
>
> On Thu 27-09-18 06:28:43, Matthew Wilcox wrote:
> > On Thu, Sep 27, 2018 at 01:23:32PM +0200, Jan Kara wrote:
> > > When dax_lock_mapping_entry() has to sleep to obtain entry lock, it will
> > > fail to unlock mapping->i_pages spinlock and thus immediately deadlock
> > > against itself when retrying to grab the entry lock again. Fix the
> > > problem by unlocking mapping->i_pages before retrying.
> >
> > It seems weird that xfstests doesn't provoke this ...
>
> The function currently gets called only from mm/memory-failure.c. And yes,
> we are lacking DAX hwpoison error tests in fstests...

I have an item on my backlog to port the ndctl unit test that does
memory_failure() injection vs ext4 over to fstests. That said I've
been investigating a deadlock on ext4 caused by this test. When I saw
this patch I hoped it was root cause, but the test is still failing
for me. Vishal is able to pass the test on his system, so the failure
mode is timing dependent. I'm running this patch on top of -rc5 and
still seeing the following deadlock.

    EXT4-fs (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
    EXT4-fs (pmem0): mounted filesystem with ordered data mode. Opts: dax
    Injecting memory failure for pfn 0x208900 at process virtual
address 0x7f5872900000
    Memory failure: 0x208900: Killing dax-pmd:7095 due to hardware
memory corruption
    Memory failure: 0x208900: recovery action for dax page: Recovered
    watchdog: BUG: soft lockup - CPU#35 stuck for 22s! [dax-pmd:7095]
    [..]
    irq event stamp: 121911146
    hardirqs last  enabled at (121911145): [<ffffffff81aa1bd9>]
_raw_spin_unlock_irq+0x29/0x40    hardirqs last disabled at
(121911146): [<ffffffff810037a3>] trace_hardirqs_off_thunk+0x1a/0x1c
    softirqs last  enabled at (78238674): [<ffffffff81e0032e>]
__do_softirq+0x32e/0x428
    softirqs last disabled at (78238627): [<ffffffff810bc6f6>]
irq_exit+0xf6/0x100
    CPU: 35 PID: 7095 Comm: dax-pmd Tainted: G           OE
4.19.0-rc5+ #2394
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.11.1-0-g0551a4be2c-prebuilt.qemu-project.org 04/01/2014
    RIP: 0010:lock_release+0x134/0x2a0
    [..]
    Call Trace:
     find_get_entries+0x299/0x3c0
     pagevec_lookup_entries+0x1a/0x30
     dax_layout_busy_page+0x9c/0x280
     ? __lock_acquire+0x12fa/0x1310
     ext4_break_layouts+0x48/0x100
     ? ext4_punch_hole+0x108/0x5a0
     ext4_punch_hole+0x110/0x5a0
     ext4_fallocate+0x189/0xa40
     ? rcu_read_lock_sched_held+0x6b/0x80
     ? rcu_sync_lockdep_assert+0x2e/0x60
     vfs_fallocate+0x13f/0x270

The same test against xfs is not failing for me. I have been seeking
some focus time to dig in on this.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
