Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Fri, 2 Oct 2015 08:32:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] Revert "mm: take i_mmap_lock in
 unmap_mapping_range() for DAX"
Message-ID: <20151001223240.GI27164@dastard>
References: <1443685599-4843-1-git-send-email-david@fromorbit.com>
 <1443685599-4843-2-git-send-email-david@fromorbit.com>
 <20151001202729.GA23495@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151001202729.GA23495@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, willy@linux.intel.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, linux-nvdimm@lists.01.org, jack@suse.cz, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 01, 2015 at 02:27:29PM -0600, Ross Zwisler wrote:
> On Thu, Oct 01, 2015 at 05:46:33PM +1000, Dave Chinner wrote:
> > This reverts commit 46c043ede4711e8d598b9d63c5616c1fedb0605e.
> > ---
> >  fs/dax.c    | 36 ++++++++++++++++--------------------
> >  mm/memory.c | 11 +++++++++--
> >  2 files changed, 25 insertions(+), 22 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 7ae6df7..400fe95 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -569,26 +569,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> >  	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE)
> >  		goto fallback;
> >  
> > -	if (buffer_unwritten(&bh) || buffer_new(&bh)) {
> > -		int i;
> > -		for (i = 0; i < PTRS_PER_PMD; i++)
> > -			clear_pmem(kaddr + i * PAGE_SIZE, PAGE_SIZE);
> > -		wmb_pmem();
> 
> The above two lines were updated to use the PMEM API with this commit:
> 
> commit d77e92e270ed ("dax: update PMD fault handler with PMEM API")
> 
> but they aren't updated in the reverted version here: 
> 
> > @@ -633,6 +620,15 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> >  		if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
> >  			goto fallback;
> >  
> > +		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
> > +			int i;
> > +			for (i = 0; i < PTRS_PER_PMD; i++)
> > +				clear_page(kaddr + i * PAGE_SIZE);
> > +			count_vm_event(PGMAJFAULT);
> > +			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
> > +			result |= VM_FAULT_MAJOR;
> > +		}
> > +
> >  		result |= vmf_insert_pfn_pmd(vma, address, pmd, pfn, write);
> >  	}
> 
> This is the source of the follow-up sparse warning from the kbuild robot.

I couldn't work out what set of commits I needed to revert to get a
clean revert, so I just reverted the commits and hacked out the
revert failures to what looked ok. Feel free to send me a clean set
of reverts, and I'll replace these patches with them... :)

> Also, if I understood your previous mails correctly you were targeting the
> first two revert patches for v4.3 so we get back to v4.2 level locking, and
> the rest of the series will target v4.4, correct?  How does this work?  Do the
> patches need to be split into two series and tested separately?

Test it and push the reverts however you like. I don't care how the
reverts get to 4.3 - I'll be carrying them locally in my trees from
now and so my development and testing is now unaffected by the bugs
that are in the 4.3 code. If you aren't going to push them for 4.3
then I'd suggest that they go to linus along with the rest of the
XFS changes in this series.

FWIW, I'm quite happy to host all the pending DAX changes in a
public git tree and ask for it to be included in linux-next. It's
probably a good idea to do this because it makes it much easier to
co-ordinate merges when we are touching multiple subsystems (ext4,
xfs, dax, mm, etc). And it will help prevent the "patches molder on
the list until Andrew hoovers them up" problem and so prevent this
situation from happening in the future...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
