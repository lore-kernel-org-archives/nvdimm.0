Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 28 Sep 2015 10:59:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] dax: fix deadlock in __dax_fault
Message-ID: <20150928005904.GY19114@dastard>
References: <1443040800-5460-1-git-send-email-ross.zwisler@linux.intel.com>
 <20150924025225.GT3902@dastard>
 <20150924155029.GA6008@linux.intel.com>
 <20150925025357.GU3902@dastard>
 <20150926031745.GA560@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150926031745.GA560@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 25, 2015 at 09:17:45PM -0600, Ross Zwisler wrote:
> On Fri, Sep 25, 2015 at 12:53:57PM +1000, Dave Chinner wrote:
> > I think a bunch of reverts are in order -the code is broken, has
> > stale data exposure problems and we're going to have to rip the code
> > out anyway because I don't think this is the right way to fix the
> > underlying problem ("If two threads write-fault on the same hole at
> > the same time...")

[...]

> I think that at the end of the day the locking in the two DAX fault paths is
> trying to protect us against two things:
> 
> 1) Simultaneous write-fault on the same hole at the same time.
> 2) Races between page faults and truncate.

1) is fixed by pushing block zeroing into get_blocks()

2) is fixed by the filesystem locking out page faults during
truncate. XFS already does this with it's XFS_MMAPLOCK_[SHARED|EXCL]
locking on page faults and truncate...

> To get them all written down in one place, here are all the issues and
> questions that I currently know about regarding the DAX fault paths as of
> v4.3-rc2:
> 
> 1) In __dax_pmd_fault() the block inside the first "if (buffer_unwritten(&bh)

	[fail to set kaddr, patch in -mm]

> 2) In __dax_pmd_fault() we have this code:

	[fail to release i_mmap_lock_write()]

> 3) In __dax_pmd_fault() we convert the unwritten extent to written
....
> 4) In __dax_fault() we can return through this path:

	[incorrect release of i_mmap_lock_write()]

> 5) In __dax_fault() we rely on the presence of a page pointer to know whether

	[fail to release i_mmap_lock_write() on racing read faults]

> 6) In __dax_fault() in the vmf->cow_page case we can end up exiting with
>    status VM_FAULT_LOCKED but with mapping->i_mmap_rwsem held.  This is

	[undocumented, unbalanced, but handled]

> 7) In both __dax_fault() and __dax_pmd_fault() we call the filesystem's
>    get_block() and complete_unwritten() functions while holding
>    mapping->i_mmap_rwsem.  There is a concern that this could potentially lead
>    to a lock inversion, leading to a deadlock.

	[more investigation needed]

> Here's how I think we can address the above issues (basically "do what Dave
> said"):
> 
> 1) For the simultaneous write-fault issue, move the responsibility for zeroing
>    the extents and converting them to written to the filesystem as Dave

*nod*

> 2) For the remaining uses of mapping->i_mmap_rwsem in the fault paths that
>    protect us against truncate, address any remaining code issues listed
>    above, clearly document in the fault handlers the locking rules and the
>    exceptions to those rules (cow_page + VM_FAULT_LOCKED).  Update any locking
>    order changes like in mm/filemap.c as necessary.

Incorrect. Truncate is a special case of hole punching, and the mm
subsystem has long relied on a nasty hack to serialise page faults
against truncate. That is:

	lock_page(page);
	if (page beyond EOF or mapping is different) {
		/* OMG FAIL FAIL FAIL */
	}

This "page beyond EOF" does not work for operations like hole
punching or other direct filesystem extent manipulation operations
that occur within the current EOF and require mapping invalidation
and serialisation until after the extent manipulation is done.

IOWs, all of these operations require the filesystem to prevent new
page faults from occurring after the initial invalidation and until
the extent manipulation is completed.  This includes truncate - the
"page beyond EOF" hack is not necessary anymore, because truncate
has the same invalidation behaviour w.r.t. punching out mappings
within EOF...

And with DAX, we have no struct page to lock, so there really isn't
anything in the mm subsystem that can be used to ensure that a given
range of a file is not being otherwise manipulated in a manner that
races with a page fault. The i_mmap_rwsem is not a replacement for
the page lock....

In reality, the require DAX page fault vs truncate serialisation is
provided for XFS by the XFS_MMAPLOCK_* inode locking that is done in
the fault, mkwrite and filesystem extent manipulation paths. There
is no way this sort of exclusion can be done in the mm/ subsystem as
it simply does not have the context to be able to provide the
necessary serialisation.  Every filesystem that wants to use DAX
needs to provide this external page fault serialisation, and in
doing so will also protect it's hole punch/extent swap/shift
operations under normal operation against racing mmap access....

IOWs, for DAX this needs to be fixed in ext4, not the mm/ subsystem.

> 3) For issue #7 above (lock inversion concerns between i_mmap_rwsem and the
>    filesystem locking needed for get_block() and complete_unwritten()), I
>    think that the complete_unwritten() calls in DAX will go away since we will
>    be allocating, zeroing and converting extents to written all in the
>    filesystem.  Similarly, I think that the calls to get_block() will no
>    longer happen while the mapping->i_mmap_rwsem is held - this was the case
>    as of v4.2, and I think we can probably get bet there with finger grained
>    FS locking.

ext2 already does this zeroing. See the call to dax_clear_blocks()
in ext2_get_blocks. I should be able to do something similar in XFS
easily enough.

> 4) Test all changes with xfstests using both xfs & ext4, using lockep.
> 
> Did I miss any issues, or does this path not solve one of them somehow?
> 
> Does this sound like a reasonable path forward for v4.3?  Dave, and Jan, can
> you guys can provide guidance and code reviews for the XFS and ext4 bits?

IMO, it's way too much to get into 4.3. I'd much prefer we revert
the bad changes in 4.3, and then work towards fixing this for the
4.4 merge window. If someone needs this for 4.3, then they can
backport the 4.4 code to 4.3-stable.

The "fast and loose and fix it later" development model does not
work for persistent storage algorithms; DAX is storage - not memory
management - and so we need to treat it as such.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
