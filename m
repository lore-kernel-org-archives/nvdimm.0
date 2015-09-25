Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 25 Sep 2015 12:53:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] dax: fix deadlock in __dax_fault
Message-ID: <20150925025357.GU3902@dastard>
References: <1443040800-5460-1-git-send-email-ross.zwisler@linux.intel.com>
 <20150924025225.GT3902@dastard>
 <20150924155029.GA6008@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150924155029.GA6008@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 24, 2015 at 09:50:29AM -0600, Ross Zwisler wrote:
> On Thu, Sep 24, 2015 at 12:52:25PM +1000, Dave Chinner wrote:
> > On Wed, Sep 23, 2015 at 02:40:00PM -0600, Ross Zwisler wrote:
> > > Fix the deadlock exposed by xfstests generic/075.  Here is the sequence
> > > that was causing us to deadlock:
> > > 
> > > 1) enter __dax_fault()
> > > 2) page = find_get_page() gives us a page, so skip
> > > 	i_mmap_lock_write(mapping)
> > > 3) if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page)
> > > 	passes, enter this block
> > > 4) if (vmf->flags & FAULT_FLAG_WRITE) fails, so do the else case and
> > > 	i_mmap_unlock_write(mapping);
> > > 	return dax_load_hole(mapping, page, vmf);
> > > 
> > > This causes us to up_write() a semaphore that we weren't holding.
> > > 
> > > The up_write() on a semaphore we didn't down_write() happens twice in
> > > a row, and then the next time we try and i_mmap_lock_write(), we hang.
> > > 
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > Reported-by: Dave Chinner <david@fromorbit.com>
> > > ---
> > >  fs/dax.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/dax.c b/fs/dax.c
> > > index 7ae6df7..df1b0ac 100644
> > > --- a/fs/dax.c
> > > +++ b/fs/dax.c
> > > @@ -405,7 +405,8 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> > >  			if (error)
> > >  				goto unlock;
> > >  		} else {
> > > -			i_mmap_unlock_write(mapping);
> > > +			if (!page)
> > > +				i_mmap_unlock_write(mapping);
> > >  			return dax_load_hole(mapping, page, vmf);
> > >  		}
> > >  	}
> > 
> > I can't review this properly because I can't work out how this
> > locking is supposed to work.  Captain, we have a Charlie Foxtrot
> > situation here:
> > 
> > 	page = find_get_page(mapping, vmf->pgoff)
> > 	if (page) {
> > 		....
> > 	} else {
> > 		i_mmap_lock_write(mapping);
> > 	}
> > 
> > So if there's no page in the page cache, we lock the i_mmap_lock.
> > The we have the case the above patch fixes. Then later:
> > 
> > 	if (vmf->cow_page) {
> > 		.....
> > 		if (!page) {
> > 			/* can fall through */
> > 		}
> > 		return VM_FAULT_LOCKED;
> > 	}
> > 
> > Which means __dax_fault() can also return here with the
> > i_mmap_lock_write() held. There's no documentation to indicate why
> > this is valid, and only by looking about 4 function calls higher up
> > the stack can I see that there's some attempt to handle this
> > *specific return condition* (in do_cow_fault()). That also is
> > lacking in documentation explaining the circumstances where we might
> > have the i_mmap_lock_write() held and have to release it. (Not to
> > mention the beautiful copy-n-waste of the unlock code, either.)
> > 
> > The above code in __dax_fault() is then followed by this gem:
> > 
> > 	/* Check we didn't race with a read fault installing a new page */
> >         if (!page && major)
> >                 page = find_lock_page(mapping, vmf->pgoff);
> > 
> > 	if (page) {
> > 		/* mapping invalidation .... */
> > 	}
> > 	.....
> > 
> > 	if (!page)
> > 		i_mmap_unlock_write(mapping);
> > 
> > Which means that if we had a race with another read fault, we'll
> > remove the page from the page cache, insert the new direct mapped
> > pfn into the mapping, and *then fail to unlock the i_mmap lock*.
> > 
> > Is this supposed to work this way? Or is it another bug?
> > 
> > Another difficult question this change of locking raised that I
> > can't answer: is it valid to call into the filesystem via getblock()
> > or complete_unwritten() while holding the i_mmap_rwsem? This puts
> > filesystem transactions and locks inside the scope of i_mmap_rwsem,
> > which may have impact on the fact that we already have an inode lock
> > order dependency w.r.t. i_mmap_rwsem through truncate (and probably
> > other paths, too).
> > 
> > So, please document the locking model, explain the corner cases and
> > the intricacies like why *unbalanced, return value conditional
> > locking* is necessary, and update the charts of lock order
> > dependencies in places like mm/filemap.c, and then we might have
> > some idea of how much of a train-wreck this actually is....
> 
> Yep, I saw these too, but didn't yet know how to deal with them.  We have at
> similar issues with __dax_pmd_fault():
> 
> 	i_mmap_lock_write(mapping);
> 	length = get_block(inode, block, &bh, write);
> 	if (length)
> 		return VM_FAULT_SIGBUS;
> 
> Whoops, we just took the mmap semaphore, and then we have a return that
> doesn't release it.  A quick test confirms that this will deadlock the next
> fault that tries to take the mmap semaphore.

Ugh. So there's more than one broken commit and code path we are
talking about here.

Oh, even the "fallback" path is broken there - it converts the
unwritten extent to written, even in the case where the underlying
pages weren't zeroed. See this case:

                if (unlikely(!zero_page))
                        goto fallback;

That's a stale data exposure bug, so has security implications....

> I agree that we need to give the fault handling code some attention when it
> comes to locking, and that we need to have better documentation.  I'll work on
> this when I get some time.
> 
> In the meantime I still think it's worthwhile to take the short term fix for
> the obvious generic/075 deadlock, yea?

I think a bunch of reverts are in order -the code is broken, has
stale data exposure problems and we're going to have to rip the code
out anyway because I don't think this is the right way to fix the
underlying problem ("If two threads write-fault on the same hole at
the same time...")

We've already got block allocation serialisation at the filesystem
level, and the issue is the unserialised block zeroing being done by
the dax code. That can be fixed by moving the zeroing into the
filesystem code when it runs "complete_unwritten" and checks whether
the mapping has already been marked as written or not...

I've recently pointed out in a different thread that this is the
solution to whatever that problem was (can't recall which
thread/problem is was now :/ ) and it the same solution here. We
already have the serialisation we need, we just need to move the
block zeroing operation into the appropriate places to make it work
correctly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
