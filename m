Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D0532118EF5D
 for <linux-nvdimm@lists.01.org>; Fri,  9 Nov 2018 11:54:24 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id s5so2709912oth.7
 for <linux-nvdimm@lists.01.org>; Fri, 09 Nov 2018 11:54:24 -0800 (PST)
MIME-Version: 1.0
References: <118cae852d1dbcc582261ae364e75a7bdf3d43ed.camel@intel.com>
 <20181106144848.GE3074@bombadil.infradead.org>
 <35429d15f7dfd2c551b9d61512abe2e04376d2a0.camel@intel.com>
In-Reply-To: <35429d15f7dfd2c551b9d61512abe2e04376d2a0.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Nov 2018 11:54:11 -0800
Message-ID: <CAPcyv4iBq0YidqHH5mSPJPzbEG0_YGG2hYrVB=1cvj8ReXMvkA@mail.gmail.com>
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

On Tue, Nov 6, 2018 at 10:01 PM Williams, Dan J
<dan.j.williams@intel.com> wrote:
>
> On Tue, 2018-11-06 at 06:48 -0800, Matthew Wilcox wrote:
> > On Tue, Nov 06, 2018 at 03:44:47AM +0000, Williams, Dan J wrote:
> > > Hi Willy,
> > >
> > > I'm seeing the following warning with v4.20-rc1 and the "dax.sh"
> > > test
> > > from the ndctl repository:
> >
> > I'll try to run this myself later today.
> >
> > > I tried to get this test going on -next before the merge window,
> > > but
> > > -next was not bootable for me. Bisection points to:
> > >
> > >     9f32d221301c dax: Convert dax_lock_mapping_entry to XArray
> > >
> > > At first glance I think we need the old "always retry if we slept"
> > > behavior. Otherwise this failure seems similar to the issue fixed
> > > by
> > > Ross' change to always retry on any potential collision:
> > >
> > >     b1f382178d15 ext4: close race between direct IO and
> > > ext4_break_layouts()
> > >
> > > I'll take a closer look tomorrow to see if that guess is plausible.
> >
> > If your thought is correct, then this should be all that's needed:
> >
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 616e36ea6aaa..529ac9d7c10a 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -383,11 +383,8 @@ bool dax_lock_mapping_entry(struct page *page)
> >               entry = xas_load(&xas);
> >               if (dax_is_locked(entry)) {
> >                       entry = get_unlocked_entry(&xas);
> > -                     /* Did the page move while we slept? */
> > -                     if (dax_to_pfn(entry) != page_to_pfn(page)) {
> > -                             xas_unlock_irq(&xas);
> > -                             continue;
> > -                     }
> > +                     xas_unlock_irq(&xas);
> > +                     continue;
> >               }
> >               dax_lock_entry(&xas, entry);
> >               xas_unlock_irq(&xas);
>
> No, that doesn't work.
>
> >
> > I don't quite understand how we'd find a PFN for this page in the
> > tree
> > after the page has had page->mapping removed.  However, the more I
> > look
> > at this path, the more I don't like it -- it doesn't handle returning
> > NULL explicitly, nor does it handle the situation where a PMD is
> > split
> > to form multiple PTEs explicitly, it just kind of relies on those bit
> > patterns not matching.
> >
> > So I kind of like the "just retry without doing anything clever"
> > situation
> > that the above patch takes us to.
>
> I've been hacking at this today and am starting to lean towards
> "revert" over "fix" for the amount of changes needed to get this back
> on its feet. I've been able to get the test passing again with the
> below changes directly on top of commit 9f32d221301c "dax: Convert
> dax_lock_mapping_entry to XArray". That said, I have thus far been
> unable to rebase this patch on top of v4.20-rc1 and yield a functional
> result.


Willy? Thoughts? I'm holding off a revert of the fsdax conversion
awaiting whether you see a way to address the concerns incrementally.


> My concerns are:
> - I can't determine if dax_unlock_entry() wants an unlocked entry
> parameter, or locked. The dax_insert_pfn_mkwrite() and
> dax_unlock_mapping_entry() usages seem to disagree.
>
> - The multi-order use case of Xarray is a mystery to me. It seems to
> want to know the order of entries a-priori with a choice to use
> XA_STATE_ORDER() vs XA_STATE(). This falls over in
> dax_unlock_mapping_entry() and other places where the only source of
> the order of the entry is determined from dax_is_pmd_entry() i.e. the
> Xarray itself. PageHead() does not work for DAX pages because
> PageHead() is only established by the page allocator and DAX pages
> never participate in the page allocator.
>
> - The usage of rcu_read_lock() in dax_lock_mapping_entry() is needed
> for inode lifetime synchronization, not just for walking the radix.
> That lock needs to be dropped before sleeping, and if we slept the
> inode may no longer exist.
>
> - I could not see how the pattern:
>         entry = xas_load(&xas);
>         if (dax_is_locked(entry)) {
>                 entry = get_unlocked_entry(&xas);
> ...was safe given that get_unlock_entry() turns around and does
> validation that the entry is !xa_internal_entry() and !NULL.
>
> - The usage of internal entries in grab_mapping_entry() seems to need
> auditing. Previously we would compare the entry size against
> @size_flag, but it now if index hits a multi-order entry in
> get_unlocked_entry() afaics it could be internal and we need to convert
> it to the actual entry before aborting... at least to match the v4.19
> behavior.
>
> This all seems to merit a rethink of the dax integration of Xarray.
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
