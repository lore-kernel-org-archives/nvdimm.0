Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4294212AF0BE
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jul 2019 20:27:32 -0700 (PDT)
Date: Wed, 3 Jul 2019 20:27:28 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190704032728.GK1729@bombadil.infradead.org>
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190703121743.GH1729@bombadil.infradead.org>
 <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Seema Pandit <seema.pandit@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Boaz Harrosh <openosd@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Robert Barror <robert.barror@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 03, 2019 at 02:28:41PM -0700, Dan Williams wrote:
> On Wed, Jul 3, 2019 at 12:53 PM Matthew Wilcox <willy@infradead.org> wrote:
> > @@ -211,7 +215,8 @@ static void *get_unlocked_entry(struct xa_state *xas)
> >         for (;;) {
> >                 entry = xas_find_conflict(xas);
> >                 if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
> > -                               !dax_is_locked(entry))
> > +                               !dax_is_locked(entry) ||
> > +                               dax_entry_order(entry) < xas_get_order(xas))
> 
> Doesn't this potentially allow a locked entry to be returned for a
> caller that expects all value entries are unlocked?

It only allows locked entries to be returned for callers which pass in
an xas which refers to a PMD entry.  This is fine for grab_mapping_entry()
because it checks size_flag & is_pte_entry.

dax_layout_busy_page() only uses 0-order.
__dax_invalidate_entry() only uses 0-order.
dax_writeback_one() needs an extra fix:

                /* Did a PMD entry get split? */
                if (dax_is_locked(entry))
                        goto put_unlocked;

dax_insert_pfn_mkwrite() checks for a mismatch of pte vs pmd.

So I think we're good for all current users.

> > +#ifdef CONFIG_XARRAY_MULTI
> > +       unsigned int sibs = xas->xa_sibs;
> > +
> > +       while (sibs) {
> > +               order++;
> > +               sibs /= 2;
> > +       }
> 
> Use ilog2() here?

Thought about it.  sibs is never going to be more than 31, so I don't
know that it's worth eliminating 5 add/shift pairs in favour of whatever
the ilog2 instruction is on a given CPU.  In practice, on x86, sibs is
going to be either 0 (PTEs) or 7 (PMDs).  We could also avoid even having
this function by passing PMD_ORDER or PTE_ORDER into get_unlocked_entry().

It's probably never going to be noticable in this scenario because it's
the very last thing checked before we put ourselves on a waitqueue and
go to sleep.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
