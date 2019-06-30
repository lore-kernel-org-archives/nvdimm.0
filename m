Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com
 [IPv6:2607:f8b0:4864:20::d41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 765A3212966E0
 for <linux-nvdimm@lists.01.org>; Sun, 30 Jun 2019 01:01:16 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id i10so7932602iol.13
 for <linux-nvdimm@lists.01.org>; Sun, 30 Jun 2019 01:01:16 -0700 (PDT)
MIME-Version: 1.0
References: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190627123415.GA4286@bombadil.infradead.org>
 <CAPcyv4jQP-SFJGor-Q3VCRQ0xwt3MuVpH2qHx2wzyRA88DGQww@mail.gmail.com>
 <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
 <CAPcyv4h6HgNE38RF5TxO3C268ZvrxgcPNrPWOt94MnO5gP_pjw@mail.gmail.com>
 <CAPcyv4gwd1_VHk_MfHeNSxyH+N1=aatj9WkKXqYNPkSXe4bFDg@mail.gmail.com>
 <20190627195948.GB4286@bombadil.infradead.org>
 <CAPcyv4iB3f1hDdCsw=Cy234dP-RXpxGyXDoTwEU8nt5qUDEVQg@mail.gmail.com>
 <20190629160336.GB1180@bombadil.infradead.org>
 <CAPcyv4ge3Ht1k_v=tSoVA6hCzKg1N3imhs_rTL3oTB+5_KC8_Q@mail.gmail.com>
In-Reply-To: <CAPcyv4ge3Ht1k_v=tSoVA6hCzKg1N3imhs_rTL3oTB+5_KC8_Q@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 30 Jun 2019 01:01:04 -0700
Message-ID: <CAA9_cmcb-Prn6CnOx-mJfb9CRdf0uG9u4M1Vq1B1rKVemCD-Vw@mail.gmail.com>
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Seema Pandit <seema.pandit@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Robert Barror <robert.barror@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 30, 2019 at 12:27 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Sat, Jun 29, 2019 at 9:03 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, Jun 27, 2019 at 07:39:37PM -0700, Dan Williams wrote:
> > > On Thu, Jun 27, 2019 at 12:59 PM Matthew Wilcox <willy@infradead.org> wrote:
> > > >
> > > > On Thu, Jun 27, 2019 at 12:09:29PM -0700, Dan Williams wrote:
> > > > > > This bug feels like we failed to unlock, or unlocked the wrong entry
> > > > > > and this hunk in the bisected commit looks suspect to me. Why do we
> > > > > > still need to drop the lock now that the radix_tree_preload() calls
> > > > > > are gone?
> > > > >
> > > > > Nevermind, unmapp_mapping_pages() takes a sleeping lock, but then I
> > > > > wonder why we don't restart the lookup like the old implementation.
> > > >
> > > > We have the entry locked:
> > > >
> > > >                 /*
> > > >                  * Make sure 'entry' remains valid while we drop
> > > >                  * the i_pages lock.
> > > >                  */
> > > >                 dax_lock_entry(xas, entry);
> > > >
> > > >                 /*
> > > >                  * Besides huge zero pages the only other thing that gets
> > > >                  * downgraded are empty entries which don't need to be
> > > >                  * unmapped.
> > > >                  */
> > > >                 if (dax_is_zero_entry(entry)) {
> > > >                         xas_unlock_irq(xas);
> > > >                         unmap_mapping_pages(mapping,
> > > >                                         xas->xa_index & ~PG_PMD_COLOUR,
> > > >                                         PG_PMD_NR, false);
> > > >                         xas_reset(xas);
> > > >                         xas_lock_irq(xas);
> > > >                 }
> > > >
> > > > If something can remove a locked entry, then that would seem like the
> > > > real bug.  Might be worth inserting a lookup there to make sure that it
> > > > hasn't happened, I suppose?
> > >
> > > Nope, added a check, we do in fact get the same locked entry back
> > > after dropping the lock.
> > >
> > > The deadlock revolves around the mmap_sem. One thread holds it for
> > > read and then gets stuck indefinitely in get_unlocked_entry(). Once
> > > that happens another rocksdb thread tries to mmap and gets stuck
> > > trying to take the mmap_sem for write. Then all new readers, including
> > > ps and top that try to access a remote vma, then get queued behind
> > > that write.
> > >
> > > It could also be the case that we're missing a wake up.
> >
> > OK, I have a Theory.
> >
> > get_unlocked_entry() doesn't check the size of the entry being waited for.
> > So dax_iomap_pmd_fault() can end up sleeping waiting for a PTE entry,
> > which is (a) foolish, because we know it's going to fall back, and (b)
> > can lead to a missed wakeup because it's going to sleep waiting for
> > the PMD entry to come unlocked.  Which it won't, unless there's a happy
> > accident that happens to map to the same hash bucket.
> >
> > Let's see if I can steal some time this weekend to whip up a patch.
>
> Theory seems to have some evidence... I instrumented fs/dax.c to track
> outstanding 'lock' entries and 'wait' events. At the time of the hang
> we see no locks held and the waiter is waiting on a pmd entry:
>
> [ 4001.354334] fs/dax locked entries: 0
> [ 4001.358425] fs/dax wait entries: 1
> [ 4001.362227] db_bench/2445 index: 0x0 shift: 6
> [ 4001.367099]  grab_mapping_entry+0x17a/0x260
> [ 4001.371773]  dax_iomap_pmd_fault.isra.43+0x168/0x7a0
> [ 4001.377316]  ext4_dax_huge_fault+0x16f/0x1f0
> [ 4001.382086]  __handle_mm_fault+0x411/0x1390
> [ 4001.386756]  handle_mm_fault+0x172/0x360

In fact, this naive fix is holding up so far:

@@ -215,7 +216,7 @@ static wait_queue_head_t
*dax_entry_waitqueue(struct xa_state *xas,
         * queue to the start of that PMD.  This ensures that all offsets in
         * the range covered by the PMD map to the same bit lock.
         */
-       if (dax_is_pmd_entry(entry))
+       //if (dax_is_pmd_entry(entry))
                index &= ~PG_PMD_COLOUR;
        key->xa = xas->xa;
        key->entry_start = index;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
