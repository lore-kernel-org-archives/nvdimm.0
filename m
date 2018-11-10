Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com
 [IPv6:2607:f8b0:4864:20::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22E5F2117CEB4
 for <linux-nvdimm@lists.01.org>; Sat, 10 Nov 2018 09:08:23 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id v83-v6so4040105oia.5
 for <linux-nvdimm@lists.01.org>; Sat, 10 Nov 2018 09:08:23 -0800 (PST)
MIME-Version: 1.0
References: <118cae852d1dbcc582261ae364e75a7bdf3d43ed.camel@intel.com>
 <20181106144848.GE3074@bombadil.infradead.org>
 <35429d15f7dfd2c551b9d61512abe2e04376d2a0.camel@intel.com>
 <20181110082918.GC21824@bombadil.infradead.org>
In-Reply-To: <20181110082918.GC21824@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Nov 2018 09:08:10 -0800
Message-ID: <CAPcyv4hotPj0YKnyo1WpoFGKaq_9L3=h3zxDNMHoSU+qUaoh4g@mail.gmail.com>
Subject: Re: fsdax memory error handling regression
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Nov 10, 2018 at 12:29 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Nov 07, 2018 at 06:01:19AM +0000, Williams, Dan J wrote:
> > On Tue, 2018-11-06 at 06:48 -0800, Matthew Wilcox wrote:
> > > On Tue, Nov 06, 2018 at 03:44:47AM +0000, Williams, Dan J wrote:
> > > > Hi Willy,
> > > >
> > > > I'm seeing the following warning with v4.20-rc1 and the "dax.sh"
> > > > test
> > > > from the ndctl repository:
> > >
> > > I'll try to run this myself later today.
> > >
> > > > I tried to get this test going on -next before the merge window,
> > > > but
> > > > -next was not bootable for me. Bisection points to:
> > > >
> > > >     9f32d221301c dax: Convert dax_lock_mapping_entry to XArray
> > > >
> > > > At first glance I think we need the old "always retry if we slept"
> > > > behavior. Otherwise this failure seems similar to the issue fixed
> > > > by
> > > > Ross' change to always retry on any potential collision:
> > > >
> > > >     b1f382178d15 ext4: close race between direct IO and
> > > > ext4_break_layouts()
> > > >
> > > > I'll take a closer look tomorrow to see if that guess is plausible.
> > >
> > > I don't quite understand how we'd find a PFN for this page in the
> > > tree
> > > after the page has had page->mapping removed.  However, the more I
> > > look
> > > at this path, the more I don't like it -- it doesn't handle returning
> > > NULL explicitly, nor does it handle the situation where a PMD is
> > > split
> > > to form multiple PTEs explicitly, it just kind of relies on those bit
> > > patterns not matching.
> > >
> > > So I kind of like the "just retry without doing anything clever"
> > > situation
> > > that the above patch takes us to.
> >
> > I've been hacking at this today and am starting to lean towards
> > "revert" over "fix" for the amount of changes needed to get this back
> > on its feet. I've been able to get the test passing again with the
> > below changes directly on top of commit 9f32d221301c "dax: Convert
> > dax_lock_mapping_entry to XArray". That said, I have thus far been
> > unable to rebase this patch on top of v4.20-rc1 and yield a functional
> > result.
>
> I think it's a little premature to go for "revert".  Sure, if it's
> not fixed in three-four weeks, but we don't normally jump straight to
> "revert" at -rc1.

Thanks for circling back to take a look at this.

>
> > My concerns are:
> > - I can't determine if dax_unlock_entry() wants an unlocked entry
> > parameter, or locked. The dax_insert_pfn_mkwrite() and
> > dax_unlock_mapping_entry() usages seem to disagree.
>
> That is fair.  I did document it in the changelog:
>
>     dax: Convert dax_insert_pfn_mkwrite to XArray
>
>     Add some XArray-based helper functions to replace the radix tree based
>     metaphors currently in use.  The biggest change is that converted code
>     doesn't see its own lock bit; get_unlocked_entry() always returns an
>     entry with the lock bit clear.  So we don't have to mess around loading
>     the current entry and clearing the lock bit; we can just store the
>     unlocked entry that we already have.
>
> but I should have written that in code too:

Ok.

>
> @@ -255,6 +255,7 @@ static void dax_unlock_entry(struct xa_state *xas, void *entry)
>  {
>         void *old;
>
> +       BUG_ON(dax_is_locked(entry));
>         xas_reset(xas);
>         xas_lock_irq(xas);
>         old = xas_store(xas, entry);
>
>
> I've added a commit to my tree with that.

WARN_ON_ONCE()?

> > - The multi-order use case of Xarray is a mystery to me. It seems to
> > want to know the order of entries a-priori with a choice to use
> > XA_STATE_ORDER() vs XA_STATE(). This falls over in
> > dax_unlock_mapping_entry() and other places where the only source of
> > the order of the entry is determined from dax_is_pmd_entry() i.e. the
> > Xarray itself. PageHead() does not work for DAX pages because
> > PageHead() is only established by the page allocator and DAX pages
> > never participate in the page allocator.
>
> I didn't know that you weren't using PageHead.  That wasn't well-documented.

Where would you have looked for that comment?

> There's xas_set_order() for dynamically setting the order of an entry.
> However, for this specific instance, we already have an entry in the tree
> which is of the correct order, so just using XA_STATE is sufficient, as
> xas_store() does not punch a small entry into a large entry but rather
> overwrites the canonical entry with the new entry's value, leaving it
> the same size, unless the new entry is specified to be larger in size.
>
> The problem, then, is that the PMD bit isn't being set in the entry.
> We could simply do a xas_load() and copy the PMD bit over.  Is there
> really no way to tell from the struct page whether it's in use as a
> huge page?  That seems like a mistake.

DAX pages have always been just enough struct page to make the DAX use
case stop crashing on fork, dma, etc. I think as DAX developers we've
had more than a few discussions about where i_pages data is in use vs
struct page. The current breakdown of surprises that I know of are:

page->lru: unavailable

compound_page / PageHead: not set, only pte entries can reliably
identify the mapping size across both filesystem-dax and device-dax

page dirty tracking: i_pages for filesystem-dax, no such thing for device_dax

page->index: not set until 4.19

page->mapping: not set until 4.19, needed custom aops

...it's fair to say we need a document. We've always needed one. This
shifting state of DAX with respect to i_pages tracking has been a saga
for a few years now.

> > - The usage of rcu_read_lock() in dax_lock_mapping_entry() is needed
> > for inode lifetime synchronization, not just for walking the radix.
> > That lock needs to be dropped before sleeping, and if we slept the
> > inode may no longer exist.
>
> That _really_ wasn't documented but should be easy to fix.

Fair, I added a comment in my proposed fix patch for this. It came up
in review with Jan, but yes it never made it to a code comment. That
said the conversion patch commit message is silent on why it thinks
it's safe to delete the lock. I can't seem to find any record of "dax:
Convert dax_lock_mapping_entry to XArray" ever being sent to a mailing
list, or cc'd to the usual DAX suspects. Certainly there's no
non-author sign-offs on the commit. I only saw it coming from the
collisions it caused in -next as I tried to get the 4.19 state of the
code stabilized, but obviously never had a chance to review it as we
were bug hunting 4.19 late into the -rcs.

> > - I could not see how the pattern:
> >       entry = xas_load(&xas);
> >       if (dax_is_locked(entry)) {
> >               entry = get_unlocked_entry(&xas);
> > ...was safe given that get_unlock_entry() turns around and does
> > validation that the entry is !xa_internal_entry() and !NULL.
>
> Oh you're saying that entry might be NULL in dax_lock_mapping_entry()?
> It can't be an internal entry there because that won't happen while
> holding the xa_lock and looking for an order-0 entry.  dax_is_locked()
> will return false for a NULL entry, so I don't see a problem here.

This is the problem, we don't know ahead of time that we're looking
for an order-0 entry. For the specific case of a memory failure in the
middle of a huge page the implementation takes
dax_lock_mapping_entry() with the expectation that any lock on a
sub-page locks the entire range in i_pages and *then* walks the ptes
to see the effective mapping size. If Xarray needs to know ahead of
time that the user wants the multi-order entry then we need to defer
this Xarray conversion until we figure out PageHead / compound_pages()
for DAX-pages.

> > - The usage of internal entries in grab_mapping_entry() seems to need
> > auditing. Previously we would compare the entry size against
> > @size_flag, but it now if index hits a multi-order entry in
> > get_unlocked_entry() afaics it could be internal and we need to convert
> > it to the actual entry before aborting... at least to match the v4.19
> > behavior.
>
> If we get an internal entry in this case, we know we were looking up
> a PMD entry and found a PTE entry.

Oh, so I may have my understanding of internal entries backwards? I.e.
I thought they were returned if you have an order-0 xas and passed
xas_load() an unaligned index, but the entry is multi-order. You're
saying they are only returned when we have a multi-order xas and
xas_load() finds an order-0 entry at the unaligned index. So
"internal" isn't Xarray private state it's an order-0 entry when the
user wanted multi-order?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
