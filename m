Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB06021194D3F
 for <linux-nvdimm@lists.01.org>; Wed,  5 Dec 2018 01:22:31 -0800 (PST)
Date: Wed, 5 Dec 2018 10:22:29 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] dax: Fix Xarray conversion of dax_unlock_mapping_entry()
Message-ID: <20181205092229.GB22304@quack2.suse.cz>
References: <20181130154902.GL10377@bombadil.infradead.org>
 <CAPcyv4iE375mP7eJP4nb76shWNaATy6FcZYi800wZ3iAJE8G8g@mail.gmail.com>
 <20181130162435.GM10377@bombadil.infradead.org>
 <CAPcyv4gBwtCxN4xTncsyShMwMzNiLG3SxKA-frYh9Fn-f6QV=g@mail.gmail.com>
 <CAPcyv4gDO7sUJgE5kKe=VC5uUG36QaUrkb6tCrtnaFMkgdSYGw@mail.gmail.com>
 <20181130195021.GN10377@bombadil.infradead.org>
 <CAPcyv4iqA84WbE8pE=Yi15Q0T8JUXnPZss27HqhQTP08F9sTrQ@mail.gmail.com>
 <CAPcyv4jFwpsiMTwj3tzbQ4NjV_XnO5-2hTqKYOaWtRCGtT=T+g@mail.gmail.com>
 <20181205013444.GX10377@bombadil.infradead.org>
 <CAPcyv4jqfws-LQOwemQm9Xt0wp7_R6K9KxWvKriDjEeUmRJ9zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jqfws-LQOwemQm9Xt0wp7_R6K9KxWvKriDjEeUmRJ9zQ@mail.gmail.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 04-12-18 22:11:10, Dan Williams wrote:
> On Tue, Dec 4, 2018 at 5:35 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Mon, Dec 03, 2018 at 07:33:43PM -0800, Dan Williams wrote:
> > > On Fri, Nov 30, 2018 at 12:05 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > > > > -void dax_unlock_mapping_entry(struct page *page)
> > > > > +void dax_unlock_mapping_entry(struct page *page, dax_entry_t entry)
> > > >
> > > > Let's not require the page to be passed back, it can be derived:
> > > >
> > > >     page = pfn_to_page(dax_to_pfn((void*) entry));
> > > >
> > > > A bit more symmetric that way and canonical with other locking schemes
> > > > that return a cookie.
> > >
> > > The patch does not apply on top of the pending fixes. could resend on
> > > top of the current libnvdimm-fixes branch [1]?
> > >
> > > I think because we are changing the calling convention to take return
> > > a locked dax_entry_t type, I feel like we should go back to the
> > > originally proposed names of these interfaces. I.e.
> > >
> > >     dax_entry_t dax_lock_page(struct page *page)
> > >
> > >     void dax_unlock_page(dax_entry_t entry)
> > >
> > > Yes, it introduces an entry-to-pfn and pfn-to-page conversion.
> > > However, If I can't convince you to drop the page argument, lets at
> > > least do the name change. I.e. offload the responsibility of conveying
> > > that this is not the traditional page lock to the fact that a
> > > dax_entry is returned and passed back to the unlock routine.
> >
> > From: Matthew Wilcox <willy@infradead.org>
> > Date: Fri, 30 Nov 2018 11:05:06 -0500
> > Subject: [PATCH] dax: Change lock/unlock API
> >
> > Return the unlock cookie from dax_lock_page() and pass it to
> > dax_unlock_page().  This fixes a bug where dax_unlock_page() was
> > assuming that the page was PMD-aligned if the entry was a PMD entry.
> >
> > Debugged-by: Dan Williams <dan.j.williams@intel.com>
> > Fixes: 9f32d221301c ("dax: Convert dax_lock_mapping_entry to XArray")
> > Signed-off-by: Matthew Wilcox <willy@infradead.org>
> 
> Looks good, passes testing. I did fix up the changelog a bit to make
> it clearer that this is a fix, not new development, and included more
> details about the failing signature from my initial fix. No code
> changes. I'll push it out to libnvdimm-fixes for -next to pick up.
> 
> ---
> 
> dax: Fix unlock mismatch with updated API
> 
> Internal to dax_unlock_mapping_entry(), dax_unlock_entry() is used to
> store a replacement entry in the Xarray at the given xas-index with the
> DAX_LOCKED bit clear. When called, dax_unlock_entry() expects the unlocked
> value of the entry relative to the current Xarray state to be specified.
> 
> In most contexts dax_unlock_entry() is operating in the same scope as
> the matched dax_lock_entry(). However, in the dax_unlock_mapping_entry()
> case the implementation needs to recall the original entry. In the case
> where the original entry is a 'pmd' entry it is possible that the pfn
> performed to do the lookup is misaligned to the value retrieved in the
> Xarray.
> 
> Change the api to return return the unlock cookie from dax_lock_page()
> and pass it to dax_unlock_page(). This fixes a bug where
> dax_unlock_page() was assuming that the page was PMD-aligned if the
> entry was a PMD entry with signatures like:
> 
>  WARNING: CPU: 38 PID: 1396 at fs/dax.c:340 dax_insert_entry+0x2b2/0x2d0
>  RIP: 0010:dax_insert_entry+0x2b2/0x2d0
>  [..]
>  Call Trace:
>   dax_iomap_pte_fault.isra.41+0x791/0xde0
>   ext4_dax_huge_fault+0x16f/0x1f0
>   ? up_read+0x1c/0xa0
>   __do_fault+0x1f/0x160
>   __handle_mm_fault+0x1033/0x1490
>   handle_mm_fault+0x18b/0x3d0
> 
> Link: https://lkml.kernel.org/r/20181130154902.GL10377@bombadil.infradead.org
> Fixes: 9f32d221301c ("dax: Convert dax_lock_mapping_entry to XArray")
> Reported-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Matthew Wilcox <willy@infradead.org>
> Tested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

The patch looks good to me. Thanks for nailing this down! You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> ---
> 
> > ---
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 3f592dc18d67..48132eca3761 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -379,20 +379,20 @@ static struct page *dax_busy_page(void *entry)
> >   * @page: The page whose entry we want to lock
> >   *
> >   * Context: Process context.
> > - * Return: %true if the entry was locked or does not need to be locked.
> > + * Return: A cookie to pass to dax_unlock_page() or 0 if the entry could
> > + * not be locked.
> >   */
> > -bool dax_lock_mapping_entry(struct page *page)
> > +dax_entry_t dax_lock_page(struct page *page)
> >  {
> >         XA_STATE(xas, NULL, 0);
> >         void *entry;
> > -       bool locked;
> >
> >         /* Ensure page->mapping isn't freed while we look at it */
> >         rcu_read_lock();
> >         for (;;) {
> >                 struct address_space *mapping = READ_ONCE(page->mapping);
> >
> > -               locked = false;
> > +               entry = NULL;
> >                 if (!mapping || !dax_mapping(mapping))
> >                         break;
> >
> > @@ -403,7 +403,7 @@ bool dax_lock_mapping_entry(struct page *page)
> >                  * otherwise we would not have a valid pfn_to_page()
> >                  * translation.
> >                  */
> > -               locked = true;
> > +               entry = (void *)~0UL;
> >                 if (S_ISCHR(mapping->host->i_mode))
> >                         break;
> >
> > @@ -426,23 +426,18 @@ bool dax_lock_mapping_entry(struct page *page)
> >                 break;
> >         }
> >         rcu_read_unlock();
> > -       return locked;
> > +       return (dax_entry_t)entry;
> >  }
> >
> > -void dax_unlock_mapping_entry(struct page *page)
> > +void dax_unlock_page(struct page *page, dax_entry_t cookie)
> >  {
> >         struct address_space *mapping = page->mapping;
> >         XA_STATE(xas, &mapping->i_pages, page->index);
> > -       void *entry;
> >
> >         if (S_ISCHR(mapping->host->i_mode))
> >                 return;
> >
> > -       rcu_read_lock();
> > -       entry = xas_load(&xas);
> > -       rcu_read_unlock();
> > -       entry = dax_make_entry(page_to_pfn_t(page), dax_is_pmd_entry(entry));
> > -       dax_unlock_entry(&xas, entry);
> > +       dax_unlock_entry(&xas, (void *)cookie);
> >  }
> >
> >  /*
> > diff --git a/include/linux/dax.h b/include/linux/dax.h
> > index 450b28db9533..0dd316a74a29 100644
> > --- a/include/linux/dax.h
> > +++ b/include/linux/dax.h
> > @@ -7,6 +7,8 @@
> >  #include <linux/radix-tree.h>
> >  #include <asm/pgtable.h>
> >
> > +typedef unsigned long dax_entry_t;
> > +
> >  struct iomap_ops;
> >  struct dax_device;
> >  struct dax_operations {
> > @@ -88,8 +90,8 @@ int dax_writeback_mapping_range(struct address_space *mapping,
> >                 struct block_device *bdev, struct writeback_control *wbc);
> >
> >  struct page *dax_layout_busy_page(struct address_space *mapping);
> > -bool dax_lock_mapping_entry(struct page *page);
> > -void dax_unlock_mapping_entry(struct page *page);
> > +dax_entry_t dax_lock_page(struct page *page);
> > +void dax_unlock_page(struct page *page, dax_entry_t cookie);
> >  #else
> >  static inline bool bdev_dax_supported(struct block_device *bdev,
> >                 int blocksize)
> > @@ -122,14 +124,14 @@ static inline int dax_writeback_mapping_range(struct address_space *mapping,
> >         return -EOPNOTSUPP;
> >  }
> >
> > -static inline bool dax_lock_mapping_entry(struct page *page)
> > +static inline dax_entry_t dax_lock_page(struct page *page)
> >  {
> >         if (IS_DAX(page->mapping->host))
> > -               return true;
> > -       return false;
> > +               return ~0UL;
> > +       return 0;
> >  }
> >
> > -static inline void dax_unlock_mapping_entry(struct page *page)
> > +static inline void dax_unlock_page(struct page *page, dax_entry_t cookie)
> >  {
> >  }
> >  #endif
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 0cd3de3550f0..7c72f2a95785 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -1161,6 +1161,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
> >         LIST_HEAD(tokill);
> >         int rc = -EBUSY;
> >         loff_t start;
> > +       dax_entry_t cookie;
> >
> >         /*
> >          * Prevent the inode from being freed while we are interrogating
> > @@ -1169,7 +1170,8 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
> >          * also prevents changes to the mapping of this pfn until
> >          * poison signaling is complete.
> >          */
> > -       if (!dax_lock_mapping_entry(page))
> > +       cookie = dax_lock_page(page);
> > +       if (!cookie)
> >                 goto out;
> >
> >         if (hwpoison_filter(page)) {
> > @@ -1220,7 +1222,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
> >         kill_procs(&tokill, flags & MF_MUST_KILL, !unmap_success, pfn, flags);
> >         rc = 0;
> >  unlock:
> > -       dax_unlock_mapping_entry(page);
> > +       dax_unlock_page(page, cookie);
> >  out:
> >         /* drop pgmap ref acquired in caller */
> >         put_dev_pagemap(pgmap);
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
