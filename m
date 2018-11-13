Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 09DAE2118D932
 for <linux-nvdimm@lists.01.org>; Tue, 13 Nov 2018 06:25:20 -0800 (PST)
Date: Tue, 13 Nov 2018 06:25:19 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: fsdax memory error handling regression
Message-ID: <20181113142519.GX21824@bombadil.infradead.org>
References: <118cae852d1dbcc582261ae364e75a7bdf3d43ed.camel@intel.com>
 <20181106144848.GE3074@bombadil.infradead.org>
 <35429d15f7dfd2c551b9d61512abe2e04376d2a0.camel@intel.com>
 <20181110082918.GC21824@bombadil.infradead.org>
 <CAPcyv4hotPj0YKnyo1WpoFGKaq_9L3=h3zxDNMHoSU+qUaoh4g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hotPj0YKnyo1WpoFGKaq_9L3=h3zxDNMHoSU+qUaoh4g@mail.gmail.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Nov 10, 2018 at 09:08:10AM -0800, Dan Williams wrote:
> On Sat, Nov 10, 2018 at 12:29 AM Matthew Wilcox <willy@infradead.org> wrote:
> > On Wed, Nov 07, 2018 at 06:01:19AM +0000, Williams, Dan J wrote:
> > > On Tue, 2018-11-06 at 06:48 -0800, Matthew Wilcox wrote:
> > > > On Tue, Nov 06, 2018 at 03:44:47AM +0000, Williams, Dan J wrote:
> > > > > Hi Willy,
> > > > >
> > > > > I'm seeing the following warning with v4.20-rc1 and the "dax.sh"
> > > > > test
> > > > > from the ndctl repository:
> > > >
> > > > I'll try to run this myself later today.
> > > >
> > > > > I tried to get this test going on -next before the merge window,
> > > > > but
> > > > > -next was not bootable for me. Bisection points to:
> > > > >
> > > > >     9f32d221301c dax: Convert dax_lock_mapping_entry to XArray
> > > > >
> > > > > At first glance I think we need the old "always retry if we slept"
> > > > > behavior. Otherwise this failure seems similar to the issue fixed
> > > > > by
> > > > > Ross' change to always retry on any potential collision:
> > > > >
> > > > >     b1f382178d15 ext4: close race between direct IO and
> > > > > ext4_break_layouts()
> > > > >
> > > > > I'll take a closer look tomorrow to see if that guess is plausible.
> > > >
> > > > I don't quite understand how we'd find a PFN for this page in the
> > > > tree
> > > > after the page has had page->mapping removed.  However, the more I
> > > > look
> > > > at this path, the more I don't like it -- it doesn't handle returning
> > > > NULL explicitly, nor does it handle the situation where a PMD is
> > > > split
> > > > to form multiple PTEs explicitly, it just kind of relies on those bit
> > > > patterns not matching.
> > > >
> > > > So I kind of like the "just retry without doing anything clever"
> > > > situation
> > > > that the above patch takes us to.
> > >
> > > I've been hacking at this today and am starting to lean towards
> > > "revert" over "fix" for the amount of changes needed to get this back
> > > on its feet. I've been able to get the test passing again with the
> > > below changes directly on top of commit 9f32d221301c "dax: Convert
> > > dax_lock_mapping_entry to XArray". That said, I have thus far been
> > > unable to rebase this patch on top of v4.20-rc1 and yield a functional
> > > result.
> >
> > I think it's a little premature to go for "revert".  Sure, if it's
> > not fixed in three-four weeks, but we don't normally jump straight to
> > "revert" at -rc1.
> 
> Thanks for circling back to take a look at this.

Thanks for the reminder email -- I somehow didn't see the email that
you sent on Wednesday.

> > +       BUG_ON(dax_is_locked(entry));
> 
> WARN_ON_ONCE()?

I don't think that's a good idea.  If you try to 'unlock' by storing a
locked entry, it's quite simply a bug.  Everything which tries to access
the entry from here on will sleep.  I think it's actually better to force
a reboot at this point than try to continue.

> > > - The multi-order use case of Xarray is a mystery to me. It seems to
> > > want to know the order of entries a-priori with a choice to use
> > > XA_STATE_ORDER() vs XA_STATE(). This falls over in
> > > dax_unlock_mapping_entry() and other places where the only source of
> > > the order of the entry is determined from dax_is_pmd_entry() i.e. the
> > > Xarray itself. PageHead() does not work for DAX pages because
> > > PageHead() is only established by the page allocator and DAX pages
> > > never participate in the page allocator.
> >
> > I didn't know that you weren't using PageHead.  That wasn't well-documented.
> 
> Where would you have looked for that comment?

Good point.  I don't know.

> > There's xas_set_order() for dynamically setting the order of an entry.
> > However, for this specific instance, we already have an entry in the tree
> > which is of the correct order, so just using XA_STATE is sufficient, as
> > xas_store() does not punch a small entry into a large entry but rather
> > overwrites the canonical entry with the new entry's value, leaving it
> > the same size, unless the new entry is specified to be larger in size.
> >
> > The problem, then, is that the PMD bit isn't being set in the entry.
> > We could simply do a xas_load() and copy the PMD bit over.  Is there
> > really no way to tell from the struct page whether it's in use as a
> > huge page?  That seems like a mistake.
> 
> DAX pages have always been just enough struct page to make the DAX use
> case stop crashing on fork, dma, etc. I think as DAX developers we've
> had more than a few discussions about where i_pages data is in use vs
> struct page. The current breakdown of surprises that I know of are:
> 
> page->lru: unavailable
> 
> compound_page / PageHead: not set, only pte entries can reliably
> identify the mapping size across both filesystem-dax and device-dax
> 
> page dirty tracking: i_pages for filesystem-dax, no such thing for device_dax
> 
> page->index: not set until 4.19
> 
> page->mapping: not set until 4.19, needed custom aops
> 
> ...it's fair to say we need a document. We've always needed one. This
> shifting state of DAX with respect to i_pages tracking has been a saga
> for a few years now.

I can't allow you to take too much blame here; struct page itself has been
woefully undocumented for too long.  I hope I improved the situation with
97b4a67198 and the other patches in that series.

> > > - The usage of rcu_read_lock() in dax_lock_mapping_entry() is needed
> > > for inode lifetime synchronization, not just for walking the radix.
> > > That lock needs to be dropped before sleeping, and if we slept the
> > > inode may no longer exist.
> >
> > That _really_ wasn't documented but should be easy to fix.
> 
> Fair, I added a comment in my proposed fix patch for this. It came up
> in review with Jan, but yes it never made it to a code comment. That
> said the conversion patch commit message is silent on why it thinks
> it's safe to delete the lock.

I thought it was safe to delete the lock because the rcu_read_lock()
was protecting the radix tree.  It's a pretty unusual locking pattern
to have inodes going away while there are still pages in the page cache.
I probably need to dig out the conversation between you & Jan on this
topic.

> I can't seem to find any record of "dax:
> Convert dax_lock_mapping_entry to XArray" ever being sent to a mailing
> list, or cc'd to the usual DAX suspects. Certainly there's no
> non-author sign-offs on the commit. I only saw it coming from the
> collisions it caused in -next as I tried to get the 4.19 state of the
> code stabilized, but obviously never had a chance to review it as we
> were bug hunting 4.19 late into the -rcs.

I thought I sent it out; possibly I messed that up.  I found it very
hard to get any Reviewed-by/Acked-by lines on any of the XArray work.
I sent out 14 revisions and only got nine review/ack tags on the
seventy-odd patches.

It's rather unfortunate; I know Ross spent a lot of time and effort
testing the DAX conversion, but he never sent me a Tested-by or
Reviewed-by for it.

> > > - I could not see how the pattern:
> > >       entry = xas_load(&xas);
> > >       if (dax_is_locked(entry)) {
> > >               entry = get_unlocked_entry(&xas);
> > > ...was safe given that get_unlock_entry() turns around and does
> > > validation that the entry is !xa_internal_entry() and !NULL.
> >
> > Oh you're saying that entry might be NULL in dax_lock_mapping_entry()?
> > It can't be an internal entry there because that won't happen while
> > holding the xa_lock and looking for an order-0 entry.  dax_is_locked()
> > will return false for a NULL entry, so I don't see a problem here.
> 
> This is the problem, we don't know ahead of time that we're looking
> for an order-0 entry. For the specific case of a memory failure in the
> middle of a huge page the implementation takes
> dax_lock_mapping_entry() with the expectation that any lock on a
> sub-page locks the entire range in i_pages and *then* walks the ptes
> to see the effective mapping size. If Xarray needs to know ahead of
> time that the user wants the multi-order entry then we need to defer
> this Xarray conversion until we figure out PageHead / compound_pages()
> for DAX-pages.

I haven't done a good job of explaining; let me try again.

When we call xas_load() with an order-0 xa_state, we always get an entry
that's actually in the array.  It might be a PMD entry or a PTE entry,
but it's always something in the array.  When we use a PMD-order xa_state
and there's a PTE entry, we don't bother walking down to the PTE level
of the tree, we just return a node pointer to indicate there's something
here, and it's not what you're looking for.

These semantics are what I thought DAX wanted, since DAX is basically
the only user of multiorder entries today.

> > > - The usage of internal entries in grab_mapping_entry() seems to need
> > > auditing. Previously we would compare the entry size against
> > > @size_flag, but it now if index hits a multi-order entry in
> > > get_unlocked_entry() afaics it could be internal and we need to convert
> > > it to the actual entry before aborting... at least to match the v4.19
> > > behavior.
> >
> > If we get an internal entry in this case, we know we were looking up
> > a PMD entry and found a PTE entry.
> 
> Oh, so I may have my understanding of internal entries backwards? I.e.
> I thought they were returned if you have an order-0 xas and passed
> xas_load() an unaligned index, but the entry is multi-order. You're
> saying they are only returned when we have a multi-order xas and
> xas_load() finds an order-0 entry at the unaligned index. So
> "internal" isn't Xarray private state it's an order-0 entry when the
> user wanted multi-order?

This sounds much more like what I just re-described above.  When you say
an unaligned index, I suspect you mean something like having a PMD entry
and specifying an index which is not PMD-aligned?  That always returns
the PMD entry, just like the radix tree used to.

The internal entry _is_ XArray private state, it's just being returned
as an indicator that "the entry you asked for isn't here".

But now that I read the code over, I realise that using xas_load() in
get_unlocked_entry() is wrong.  Consider an XArray with a PTE entry at
index 1023 and a huge page fault attempts to load a PMD entry at index
512.  That's going to return NULL, which will cause grab_mapping_entry()
to put a locked empty entry into the tree, erasing the PTE entry from
the tree.  Even if it's locked.

get_unlocked_entry() should be using xas_find_conflict() instead of
xas_load().  That will never return an internal entry, and will just be
generally easier to deal with.

I'm going to suggest at the unconference kickoff this morning that we do
a session on the XArray.  You & I certainly need to talk in person about
what I've done, and I think it could be useful for others to be present.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
