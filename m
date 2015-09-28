Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 28 Sep 2015 16:40:01 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] dax: fix deadlock in __dax_fault
Message-ID: <20150928224001.GA21955@linux.intel.com>
References: <1443040800-5460-1-git-send-email-ross.zwisler@linux.intel.com>
 <20150924025225.GT3902@dastard>
 <20150924155029.GA6008@linux.intel.com>
 <20150925025357.GU3902@dastard>
 <20150926031745.GA560@linux.intel.com>
 <20150928005904.GY19114@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150928005904.GY19114@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 28, 2015 at 10:59:04AM +1000, Dave Chinner wrote:
> On Fri, Sep 25, 2015 at 09:17:45PM -0600, Ross Zwisler wrote:
<>
> In reality, the require DAX page fault vs truncate serialisation is
> provided for XFS by the XFS_MMAPLOCK_* inode locking that is done in
> the fault, mkwrite and filesystem extent manipulation paths. There
> is no way this sort of exclusion can be done in the mm/ subsystem as
> it simply does not have the context to be able to provide the
> necessary serialisation.  Every filesystem that wants to use DAX
> needs to provide this external page fault serialisation, and in
> doing so will also protect it's hole punch/extent swap/shift
> operations under normal operation against racing mmap access....
> 
> IOWs, for DAX this needs to be fixed in ext4, not the mm/ subsystem.

So is it your belief that XFS already has correct locking in place to ensure
that we don't hit these races?  I see XFS taking XFS_MMAPLOCK_SHARED before it
calls __dax_fault() in both xfs_filemap_page_mkwrite() (via __dax_mkwrite) and
in xfs_filemap_fault().

XFS takes XFS_MMAPLOCK_EXCL before a truncate in xfs_vn_setattr() - I haven't
found the generic hole punching code yet, but I assume it takes
XFS_MMAPLOCK_EXCL as well.

Meaning, is the work that we need to do around extent vs page fault locking
basically adding equivalent locking to ext4 and ext2 and removing the attempts
at locking from dax.c?

> > 4) Test all changes with xfstests using both xfs & ext4, using lockep.
> > 
> > Did I miss any issues, or does this path not solve one of them somehow?
> > 
> > Does this sound like a reasonable path forward for v4.3?  Dave, and Jan, can
> > you guys can provide guidance and code reviews for the XFS and ext4 bits?
> 
> IMO, it's way too much to get into 4.3. I'd much prefer we revert
> the bad changes in 4.3, and then work towards fixing this for the
> 4.4 merge window. If someone needs this for 4.3, then they can
> backport the 4.4 code to 4.3-stable.
> 
> The "fast and loose and fix it later" development model does not
> work for persistent storage algorithms; DAX is storage - not memory
> management - and so we need to treat it as such.

Okay.  To get our locking back to v4.2 levels here are the two commits I think
we need to look at:

commit 843172978bb9 ("dax: fix race between simultaneous faults")
commit 46c043ede471 ("mm: take i_mmap_lock in unmap_mapping_range() for DAX")

The former is the one that introduced the heavy reliance on write locks of the
mmap semaphore and introduced the various deadlocks that we've found.  The
latter moved some of that locking around so we didn't hold a write lock on the
mmap semaphore during unmap_mapping_range().

Does this sound correct to you?

On an unrelated note, while wandering through the XFS code I found the
following lock ordering documented above xfs_ilock():

 * Basic locking order:
 *
 * i_iolock -> i_mmap_lock -> page_lock -> i_ilock
 *
 * mmap_sem locking order:
 *
 * i_iolock -> page lock -> mmap_sem
 * mmap_sem -> i_mmap_lock -> page_lock

I noticed that page_lock and i_mmap_lock are in different places in the
ordering depending on the presence or absence of mmap_sem.  Does this not open
us up to a lock ordering inversion?

Thread 1 (mmap_sem)			Thread 2 (no mmap_sem)
-------------------			----------------------
page_lock
mmap_sem
					i_mmap_lock
					<waiting for page_lock>
<waiting for i_mmap_lock>

Thanks,
- Ross
