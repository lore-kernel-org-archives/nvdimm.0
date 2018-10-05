Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41A9C2194D3AE
 for <linux-nvdimm@lists.01.org>; Fri,  5 Oct 2018 02:54:17 -0700 (PDT)
Date: Fri, 5 Oct 2018 11:54:15 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] dax: Fix deadlock in dax_lock_mapping_entry()
Message-ID: <20181005095415.GC9686@quack2.suse.cz>
References: <20180927112332.3649-1-jack@suse.cz>
 <20180927132843.GA19006@bombadil.infradead.org>
 <20180927134129.GB8800@quack2.suse.cz>
 <CAPcyv4hut3P5fiNHgjpf4Qg_nBo9JKkovCdrUnzXyji=ey8zJw@mail.gmail.com>
 <20181004162748.GI28384@quack2.suse.cz>
 <CAPcyv4gf5MSaBnzFFrk4XG4OEJFTOqWshk-F==3=4GGMnwNtQw@mail.gmail.com>
 <20181005025212.GA12446@bombadil.infradead.org>
 <CAPcyv4gbi5n+of3w2Ea6iy5kGWMVRXiLOrehvN9GSFoJEqf-Uw@mail.gmail.com>
 <CAPcyv4gyLShMNQk3138DdA+nAApj5zL4s_n=JM1LtD8NvCW7_A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gyLShMNQk3138DdA+nAApj5zL4s_n=JM1LtD8NvCW7_A@mail.gmail.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Barret Rhoden <brho@google.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 04-10-18 21:28:14, Dan Williams wrote:
> On Thu, Oct 4, 2018 at 9:01 PM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > On Thu, Oct 4, 2018 at 7:52 PM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Thu, Oct 04, 2018 at 06:57:52PM -0700, Dan Williams wrote:
> > > > On Thu, Oct 4, 2018 at 9:27 AM Jan Kara <jack@suse.cz> wrote:
> > > > >
> > > > > On Thu 27-09-18 11:22:22, Dan Williams wrote:
> > > > > > On Thu, Sep 27, 2018 at 6:41 AM Jan Kara <jack@suse.cz> wrote:
> > > > > > >
> > > > > > > On Thu 27-09-18 06:28:43, Matthew Wilcox wrote:
> > > > > > > > On Thu, Sep 27, 2018 at 01:23:32PM +0200, Jan Kara wrote:
> > > > > > > > > When dax_lock_mapping_entry() has to sleep to obtain entry lock, it will
> > > > > > > > > fail to unlock mapping->i_pages spinlock and thus immediately deadlock
> > > > > > > > > against itself when retrying to grab the entry lock again. Fix the
> > > > > > > > > problem by unlocking mapping->i_pages before retrying.
> > > > > > > >
> > > > > > > > It seems weird that xfstests doesn't provoke this ...
> > > > > > >
> > > > > > > The function currently gets called only from mm/memory-failure.c. And yes,
> > > > > > > we are lacking DAX hwpoison error tests in fstests...
> > > > > >
> > > > > > I have an item on my backlog to port the ndctl unit test that does
> > > > > > memory_failure() injection vs ext4 over to fstests. That said I've
> > > > > > been investigating a deadlock on ext4 caused by this test. When I saw
> > > > > > this patch I hoped it was root cause, but the test is still failing
> > > > > > for me. Vishal is able to pass the test on his system, so the failure
> > > > > > mode is timing dependent. I'm running this patch on top of -rc5 and
> > > > > > still seeing the following deadlock.
> > > > >
> > > > > I went through the code but I don't see where the problem could be. How can
> > > > > I run that test? Is KVM enough or do I need hardware with AEP dimms?
> > > >
> > > > KVM is enough... however, I have found a hack that makes the test pass:
> > > >
> > > > diff --git a/mm/filemap.c b/mm/filemap.c
> > > > index 52517f28e6f4..d7f035b1846e 100644
> > > > --- a/mm/filemap.c
> > > > +++ b/mm/filemap.c
> > > > @@ -1668,6 +1668,9 @@ unsigned find_get_entries(struct address_space *mapping,
> > > >                         goto repeat;
> > > >                 }
> > > >  export:
> > > > +               if (iter.index < start)
> > > > +                       continue;
> > > > +
> > > >                 indices[ret] = iter.index;
> > > >                 entries[ret] = page;
> > > >                 if (++ret == nr_entries)
> > > >
> > > > Is this a radix bug? I would never expect:
> > > >
> > > >     radix_tree_for_each_slot(slot, &mapping->i_pages, &iter, start)
> > > >
> > > > ...to return entries with an index < start. Without that change above
> > > > we loop forever because dax_layout_busy_page() can't make forward
> > > > progress. I'll dig into the radix code tomorrow, but maybe someone
> > > > else will be me to it overnight.
> > >
> > > If 'start' is within a 2MB entry, iter.index can absolutely be less
> > > than start.  I forget exactly what the radix tree code does, but I think
> > > it returns index set to the canonical/base index of the entry.
> >
> > Ok, that makes sense. Then the bug is in dax_layout_busy_page() which
> > needs to increment 'index' by the entry size. This might also explain
> > why not every run sees it because you may get lucky and have a 4K
> > entry.
> 
> Hmm, no 2MB entry here.
> 
> We go through the first find_get_entries and export:
> 
>     export start: 0x0 index: 0x0 page: 0x822000a
>     export start: 0x0 index: 0x200 page: 0xcc3801a
> 
> Then dax_layout_busy_page sets 'start' to 0x201, and find_get_entries returns:
> 
>     export start: 0x201 index: 0x200 page: 0xcc3801a
> 
> ...forevermore.

Are you sure there's not 2MB entry starting at index 0x200? Because if
there was, we'd get infinite loop exactly as you describe in
dax_layout_busy_page() AFAICT. And it seems to me lot of other places
iterating over entries are borked in a similar way as they all assume that
doing +1 to the current index is guaranteeing them forward progress. Now
actual breakage resulting from this is limited as only DAX uses multiorder
entries and thus not many of these iterators actually ever get called for
radix tree with multiorder entries (e.g. tmpfs still inserts every 4k subpage
of THP into the radix tree and iteration functions usually handles
tail subpages in a special way). But this would really deserve larger
cleanup.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
