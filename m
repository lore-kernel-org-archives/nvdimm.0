Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 30 Sep 2015 11:57:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] dax: fix deadlock in __dax_fault
Message-ID: <20150930015747.GE27164@dastard>
References: <1443040800-5460-1-git-send-email-ross.zwisler@linux.intel.com>
 <20150924025225.GT3902@dastard>
 <20150924155029.GA6008@linux.intel.com>
 <20150925025357.GU3902@dastard>
 <20150926031745.GA560@linux.intel.com>
 <20150928005904.GY19114@dastard>
 <20150928224001.GA21955@linux.intel.com>
 <20150929024458.GC27164@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150929024458.GC27164@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 29, 2015 at 12:44:58PM +1000, Dave Chinner wrote:
> On Mon, Sep 28, 2015 at 04:40:01PM -0600, Ross Zwisler wrote:
> > > > 4) Test all changes with xfstests using both xfs & ext4, using lockep.
> > > > 
> > > > Did I miss any issues, or does this path not solve one of them somehow?
> > > > 
> > > > Does this sound like a reasonable path forward for v4.3?  Dave, and Jan, can
> > > > you guys can provide guidance and code reviews for the XFS and ext4 bits?
> > > 
> > > IMO, it's way too much to get into 4.3. I'd much prefer we revert
> > > the bad changes in 4.3, and then work towards fixing this for the
> > > 4.4 merge window. If someone needs this for 4.3, then they can
> > > backport the 4.4 code to 4.3-stable.
> > > 
> > > The "fast and loose and fix it later" development model does not
> > > work for persistent storage algorithms; DAX is storage - not memory
> > > management - and so we need to treat it as such.
> > 
> > Okay.  To get our locking back to v4.2 levels here are the two commits I think
> > we need to look at:
> > 
> > commit 843172978bb9 ("dax: fix race between simultaneous faults")
> > commit 46c043ede471 ("mm: take i_mmap_lock in unmap_mapping_range() for DAX")
> 
> Already testing a kernel with those reverted. My current DAX patch
> stack is (bottom is first commit in stack):
> 

And just to indicate why 4.3 is completely unrealistic, let me give
you a summary of this patchset so far:

> f672ae4 xfs: add ->pfn_mkwrite support for DAX

I *think* it works.

> 6855c23 xfs: remove DAX complete_unwritten callback

Gone.

> e074bdf Revert "dax: fix race between simultaneous faults"
> 8ba0157 Revert "mm: take i_mmap_lock in unmap_mapping_range() for DAX"
> a2ce6a5 xfs: DAX does not use IO completion callbacks

DAX still needs to use IO completion callbacks for the DIO path, so
needed rewriting. Made 6855c23 redundant.

> 246c52a xfs: update size during allocation for DAX

Fundamentally broken, so removed. DIO passes the actual size from IO
completion, not into block allocation, hence DIO still needs
completion callbacks. DAX page faults can't change
the file size (should segv before we get here), so need to
specifically handle that to avoid leaking ioend structures due to
incorrect detection of EOF updates due to ovreflows...

> 9d10e7b xfs: Don't use unwritten extents for DAX

Exposed a behaviour in DIO and DAX that results in s64 variable
overflow when writing to the block at file offset (2^63 - 1FSB).
Both the DAX and DIO code ask for a mapping at:

xfs_get_blocks_alloc: [...] offset 0x7ffffffffffff000 count 4096

which gives a size of 0x8000000000000000 (larger than
sb->s_maxbytes!) and results a sign overflow checking if a inode
size update is requireed.  Direct IO avoids this overflow because
the logic checks for unwritten extents first and the IO completion
callback that has the correct size. Removing unwritten extent
allocation from DAX exposed this bug through firing asserts all
through the XFS block mapping and IO completion callbacks....

Fixed the overflow, testing got further and then fsx exposed another
problem similar to the size update issue above. Patch is
fundamentally broken: block zeroing needs to be driven all the way
into the low level allocator implementation to fix the problems fsx
exposed.

> eaef807 xfs: factor out sector mapping.

Probably not going to be used now.

So, basically, I've rewritten most of the patch set once, and I'm
about to fundamentally change it again to address problems the first
two versions have exposed.  Hopefully this will show you the
complexity of what we are dealing with here, and why I said this
needs to go through 4.4?

It should also help explain why I suggested that if ext4 developers
aren't interested in fixing DAX problems then we should just drop
ext4 DAX support? Making this stuff work correctly requires more
than just a cursory knowledge of a filesystem, and nobody actively
working on DAX has the qualifications to make these sorts of changes
to ext4...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
