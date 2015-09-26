Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 25 Sep 2015 21:17:45 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] dax: fix deadlock in __dax_fault
Message-ID: <20150926031745.GA560@linux.intel.com>
References: <1443040800-5460-1-git-send-email-ross.zwisler@linux.intel.com>
 <20150924025225.GT3902@dastard>
 <20150924155029.GA6008@linux.intel.com>
 <20150925025357.GU3902@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150925025357.GU3902@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 25, 2015 at 12:53:57PM +1000, Dave Chinner wrote:
> On Thu, Sep 24, 2015 at 09:50:29AM -0600, Ross Zwisler wrote:
> > On Thu, Sep 24, 2015 at 12:52:25PM +1000, Dave Chinner wrote:
> > > On Wed, Sep 23, 2015 at 02:40:00PM -0600, Ross Zwisler wrote:
> > > > Fix the deadlock exposed by xfstests generic/075.  Here is the sequence
> > > > that was causing us to deadlock:
> > > > 
> > > > 1) enter __dax_fault()
> > > > 2) page = find_get_page() gives us a page, so skip
> > > > 	i_mmap_lock_write(mapping)
> > > > 3) if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page)
> > > > 	passes, enter this block
> > > > 4) if (vmf->flags & FAULT_FLAG_WRITE) fails, so do the else case and
> > > > 	i_mmap_unlock_write(mapping);
> > > > 	return dax_load_hole(mapping, page, vmf);
> > > > 
> > > > This causes us to up_write() a semaphore that we weren't holding.
> > > > 
> > > > The up_write() on a semaphore we didn't down_write() happens twice in
> > > > a row, and then the next time we try and i_mmap_lock_write(), we hang.
> > > > 
> > > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > > Reported-by: Dave Chinner <david@fromorbit.com>
> > > > ---
> > > >  fs/dax.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/dax.c b/fs/dax.c
> > > > index 7ae6df7..df1b0ac 100644
> > > > --- a/fs/dax.c
> > > > +++ b/fs/dax.c
> > > > @@ -405,7 +405,8 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> > > >  			if (error)
> > > >  				goto unlock;
> > > >  		} else {
> > > > -			i_mmap_unlock_write(mapping);
> > > > +			if (!page)
> > > > +				i_mmap_unlock_write(mapping);
> > > >  			return dax_load_hole(mapping, page, vmf);
> > > >  		}
> > > >  	}
> > > 
> > > I can't review this properly because I can't work out how this
> > > locking is supposed to work.  Captain, we have a Charlie Foxtrot
> > > situation here:
> > > 
> > > 	page = find_get_page(mapping, vmf->pgoff)
> > > 	if (page) {
> > > 		....
> > > 	} else {
> > > 		i_mmap_lock_write(mapping);
> > > 	}
> > > 
> > > So if there's no page in the page cache, we lock the i_mmap_lock.
> > > The we have the case the above patch fixes. Then later:
> > > 
> > > 	if (vmf->cow_page) {
> > > 		.....
> > > 		if (!page) {
> > > 			/* can fall through */
> > > 		}
> > > 		return VM_FAULT_LOCKED;
> > > 	}
> > > 
> > > Which means __dax_fault() can also return here with the
> > > i_mmap_lock_write() held. There's no documentation to indicate why
> > > this is valid, and only by looking about 4 function calls higher up
> > > the stack can I see that there's some attempt to handle this
> > > *specific return condition* (in do_cow_fault()). That also is
> > > lacking in documentation explaining the circumstances where we might
> > > have the i_mmap_lock_write() held and have to release it. (Not to
> > > mention the beautiful copy-n-waste of the unlock code, either.)
> > > 
> > > The above code in __dax_fault() is then followed by this gem:
> > > 
> > > 	/* Check we didn't race with a read fault installing a new page */
> > >         if (!page && major)
> > >                 page = find_lock_page(mapping, vmf->pgoff);
> > > 
> > > 	if (page) {
> > > 		/* mapping invalidation .... */
> > > 	}
> > > 	.....
> > > 
> > > 	if (!page)
> > > 		i_mmap_unlock_write(mapping);
> > > 
> > > Which means that if we had a race with another read fault, we'll
> > > remove the page from the page cache, insert the new direct mapped
> > > pfn into the mapping, and *then fail to unlock the i_mmap lock*.
> > > 
> > > Is this supposed to work this way? Or is it another bug?
> > > 
> > > Another difficult question this change of locking raised that I
> > > can't answer: is it valid to call into the filesystem via getblock()
> > > or complete_unwritten() while holding the i_mmap_rwsem? This puts
> > > filesystem transactions and locks inside the scope of i_mmap_rwsem,
> > > which may have impact on the fact that we already have an inode lock
> > > order dependency w.r.t. i_mmap_rwsem through truncate (and probably
> > > other paths, too).
> > > 
> > > So, please document the locking model, explain the corner cases and
> > > the intricacies like why *unbalanced, return value conditional
> > > locking* is necessary, and update the charts of lock order
> > > dependencies in places like mm/filemap.c, and then we might have
> > > some idea of how much of a train-wreck this actually is....
> > 
> > Yep, I saw these too, but didn't yet know how to deal with them.  We have at
> > similar issues with __dax_pmd_fault():
> > 
> > 	i_mmap_lock_write(mapping);
> > 	length = get_block(inode, block, &bh, write);
> > 	if (length)
> > 		return VM_FAULT_SIGBUS;
> > 
> > Whoops, we just took the mmap semaphore, and then we have a return that
> > doesn't release it.  A quick test confirms that this will deadlock the next
> > fault that tries to take the mmap semaphore.
> 
> Ugh. So there's more than one broken commit and code path we are
> talking about here.
> 
> Oh, even the "fallback" path is broken there - it converts the
> unwritten extent to written, even in the case where the underlying
> pages weren't zeroed. See this case:
> 
>                 if (unlikely(!zero_page))
>                         goto fallback;
> 
> That's a stale data exposure bug, so has security implications....
> 
> > I agree that we need to give the fault handling code some attention when it
> > comes to locking, and that we need to have better documentation.  I'll work on
> > this when I get some time.
> > 
> > In the meantime I still think it's worthwhile to take the short term fix for
> > the obvious generic/075 deadlock, yea?
> 
> I think a bunch of reverts are in order -the code is broken, has
> stale data exposure problems and we're going to have to rip the code
> out anyway because I don't think this is the right way to fix the
> underlying problem ("If two threads write-fault on the same hole at
> the same time...")
> 
> We've already got block allocation serialisation at the filesystem
> level, and the issue is the unserialised block zeroing being done by
> the dax code. That can be fixed by moving the zeroing into the
> filesystem code when it runs "complete_unwritten" and checks whether
> the mapping has already been marked as written or not...
> 
> I've recently pointed out in a different thread that this is the
> solution to whatever that problem was (can't recall which
> thread/problem is was now :/ ) and it the same solution here. We
> already have the serialisation we need, we just need to move the
> block zeroing operation into the appropriate places to make it work
> correctly.

I think that at the end of the day the locking in the two DAX fault paths is
trying to protect us against two things:

1) Simultaneous write-fault on the same hole at the same time. The winner of
   the race will return to userspace and complete their store, only to have
   the loser overwrite their store with zeroes.

   We are currently using mapping->i_mmap_rwsem to protect ourselves from
   this.  Here is the patch that added this protection:

   https://lkml.org/lkml/2015/8/4/870

2) Races between page faults and truncate.  If we have a struct page we
   protect ourselves by locking the page via lock_page_or_retry().  If we
   don't have a struct page we use mapping->i_mmap_rwsem.  This is the source
   of all of the mapping->i_mmap_rwsem locking being based on !page.

   The protection provided by mapping->i_mmap_rwsem against truncate has been
   in place in some form since v4.0.

To get them all written down in one place, here are all the issues and
questions that I currently know about regarding the DAX fault paths as of
v4.3-rc2:

1) In __dax_pmd_fault() the block inside the first "if (buffer_unwritten(&bh)
   || buffer_new(&bh))" test doesn't set kaddr before starting to zero.  This
   was fixed by the following patch which has been accepted into the --mm
   tree:

   https://lkml.org/lkml/2015/9/22/989

2) In __dax_pmd_fault() we have this code:

   	i_mmap_lock_write(mapping);
	length = get_block(inode, block, &bh, write);
	if (length)
		return VM_FAULT_SIGBUS;

   We just took the mapping->i_mmap_rwsem semaphore, and then we have a return
   that doesn't release it.  A quick test confirms that this will deadlock the
   next fault that tries to take the mapping->i_mmap_rwsem semaphore.

3) In __dax_pmd_fault() we convert the unwritten extent to written, even in
   the case where the underlying pages weren't zeroed. See this case:

                if (unlikely(!zero_page))
                        goto fallback;

   That's a stale data exposure bug, so has security implications....

   There are other places where we head through this completion path because
   of an error, and those should similarly only convert the extents as written
   if they have been zeroed.

4) In __dax_fault() we can return through this path:

		} else {
			i_mmap_unlock_write(mapping);
			return dax_load_hole(mapping, page, vmf);
		}

   without having ever taken the mapping->i_mmap_rwsem semaphore.  This means
   we end up releasing a semaphore that we never took, which can lead to
   a deadlock.  This was the original bug report for xfstest generic/075, and
   is currently addressed by the following patch in the -mm tree:

   https://lkml.org/lkml/2015/9/23/607

5) In __dax_fault() we rely on the presence of a page pointer to know whether
   or not we should release mapping->i_mmap_rwsem at the end of the function.
   Unfortunately, we can set the page pointer in the middle of the function
   while the semaphore is held:

	/* Check we didn't race with a read fault installing a new page */
	if (!page && major)
		page = find_lock_page(mapping, vmf->pgoff);

   This will cause us to fail the "if (!page)" test at the end of the
   function, making us fail to release the semaphore on exit.

6) In __dax_fault() in the vmf->cow_page case we can end up exiting with
   status VM_FAULT_LOCKED but with mapping->i_mmap_rwsem held.  This is
   actually correct behavior and is documented in the commit message of the
   patch that added this code:

   commit 2e4cdab0584fa884e0a81c4f45b93ce875c9fcaa
   https://lkml.org/lkml/2015/1/13/635

   This breaks the locking rules used by the rest of the function, though, and
   needs comments.

7) In both __dax_fault() and __dax_pmd_fault() we call the filesystem's
   get_block() and complete_unwritten() functions while holding
   mapping->i_mmap_rwsem.  There is a concern that this could potentially lead
   to a lock inversion, leading to a deadlock.

Here's how I think we can address the above issues (basically "do what Dave
said"):

1) For the simultaneous write-fault issue, move the responsibility for zeroing
   the extents and converting them to written to the filesystem as Dave
   suggests.  This will require us to get the coordination between DAX and
   the filesystem write in each filesystem we support (currentely xfs and
   ext4), but it will take advantage of fine-grained locking already present
   in the filesystem and will let us remove much of our reliance on
   mapping->i_mmap_rwsem.

   This will also address the scalability issues mentioned as future work in
   Matthew's patch that introduced the heavy reliance on
   mapping->i_mmap_rwsem:

   https://lkml.org/lkml/2015/8/4/870

   This will allow us to scale back our usage of mapping->i_mmap_rwsem,
   helping us deal with many of the above issues.

   This will also take care of issue #3 (information leak of non-zeroed blocks
   marked as written) as DAX will no longer be responsible for converting
   newly zeroed blocks to written.

2) For the remaining uses of mapping->i_mmap_rwsem in the fault paths that
   protect us against truncate, address any remaining code issues listed
   above, clearly document in the fault handlers the locking rules and the
   exceptions to those rules (cow_page + VM_FAULT_LOCKED).  Update any locking
   order changes like in mm/filemap.c as necessary.

3) For issue #7 above (lock inversion concerns between i_mmap_rwsem and the
   filesystem locking needed for get_block() and complete_unwritten()), I
   think that the complete_unwritten() calls in DAX will go away since we will
   be allocating, zeroing and converting extents to written all in the
   filesystem.  Similarly, I think that the calls to get_block() will no
   longer happen while the mapping->i_mmap_rwsem is held - this was the case
   as of v4.2, and I think we can probably get bet there with finger grained
   FS locking.

4) Test all changes with xfstests using both xfs & ext4, using lockep.

Did I miss any issues, or does this path not solve one of them somehow?

Does this sound like a reasonable path forward for v4.3?  Dave, and Jan, can
you guys can provide guidance and code reviews for the XFS and ext4 bits?

Thanks,
- Ross
