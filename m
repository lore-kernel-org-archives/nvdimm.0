Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 1 Oct 2015 14:31:21 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/7] xfs, dax: fix the page fault/allocation mess
Message-ID: <20151001203121.GB23495@linux.intel.com>
References: <1443685599-4843-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1443685599-4843-1-git-send-email-david@fromorbit.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, willy@linux.intel.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, linux-nvdimm@lists.01.org, jack@suse.cz, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 01, 2015 at 05:46:32PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> As discussed in the recent thread about problems with DAX locking:
> 
> http://www.gossamer-threads.com/lists/linux/kernel/2264090?do=post_view_threaded
> 
> I said that I'd post the patch set that fixed the problems for XFS
> as soon as I had something sane and workable. That's what this
> series is.
> 
> To start with, it passes xfstests "auto" group with only the only
> failures being expected failures or failures due to unexpected
> allocation patterns or trying to use unsupported block sizes. That
> makes it better than any previous version of the XFS/DAX code.
> 
> The patchset starts by reverting the two patches that were
> introduced in 4.3-rc1 to try to fix the fault vs fault and fault vs
> truncate races that caused deadlocks. This fixes the hangs in
> generic/075 that these patches introduced.
> 
> Patch 3 enables XFS to handle the behaviour of DAX and DIO when
> asking to allocate the block at (2^63 - 1FSB), where the offset +
> count s technically illegal (larger than sb->s_maxbytes) and
> overflows a s64 variable. This is currently hidden by the fact that
> all DAX and DIO allocation is currently unwritten, but patch 5
> exposes it for DAX.
> 
> Patch 4 introduces the ability for XFS to allocate physically zeroed
> data blocks. This is done for each physical extent that is
> allocated, deep inside the allocator itself and guaranteed to be
> atomic with the allocation transaction and hence has no
> crash+recovery exposure issues.
> 
> This is necessary because the BMAPI layer merges allocated extents
> in the BMBT before it returns the mapped extent back to the high
> level get_blocks() code. Hence the high level code can have a single
> extent presented that is made of merged new and existing extents,
> and so zeroing can't be done at this layer.
> 
> The advantage of driving the zeroing deep into the allocator is the
> functionality is now available to all XFS code. Hence we can
> allocate pre-zeroed blocks on any type of storage, and we can
> utilise storage-based hardware acceleration (e.g. discard to zero,
> WRITE_SAME, etc) to do the zeroing. From this POV, DAX is just
> another hardware accelerated physical zeroing mechanism for XFS. :)
> 
> [ This is an example of the mantra I repeat a lot: solve the problem
>   properly the first time and it will make everything simpler! Sure,
>   it took me three attempts to work out how to solve it in a sane
>   manner, but that's pretty much par for the course with anything
>   non-trivial. ]
> 
> Patch 5 makes __xfs_get_blocks() aware that it is being called from
> the DAX fault path and makes sure it returns zeroed blocks rather
> than unwritten extents via XFS_BMAPI_ZERO. It also now sets
> XFS_BMAPI_CONVERT, which tells it to convert unwritten extents to
> written, zeroed blocks. This is the major change of behaviour.
> 
> Patch 6 removes the IO completion callbacks from the XFS DAX code as
> they are not longer necessary after patch 5.
> 
> Patch 7 adds pfn_mkwrite support to XFS. This is needed to fix
> generic/080, which detects a failure to update the inode timestamp
> on a pfn fault. It also adds the same locking as the XFS
> implementation of ->fault and ->page_mkwrite and hence provide
> correct serialisation against truncate, hole punching, etc that
> doesn't currently exist.
> 
> The next steps that are needed are to do the same "block zeroing
> during allocation" to ext4, and then the block zeroing and
> complete_unwritten callbacks can be removed from the DAX API and
> code. I've had a breif look at the ext4 code - the block zeroing
> should be able to be done by overloading the existing zeroout code
> that ext4 has in the unwritten extent allocation code. I'd much
> prefer that an ext4 expert does this work, and then we can clean up
> the DAX code...

Thank you for working on this, and for documenting your thinking so clearly.

One thing I noticed is that in my test setup XFS+DAX is now failing
generic/274:

	# diff -u tests/generic/274.out /root/xfstests/results//generic/274.out.bad
	--- tests/generic/274.out	2015-08-24 11:05:41.490926305 -0600
	+++ /root/xfstests/results//generic/274.out.bad	2015-10-01 13:53:50.498354091 -0600
	@@ -2,4 +2,5 @@
	 ------------------------------
	 preallocation test
	 ------------------------------
	-done
	+failed to write to test file
	+(see /root/xfstests/results//generic/274.full for details)

I've verified that the test passes 100% of the time with my baseline
(v4.3-rc3), and with the set applied but without the DAX mount option.  With
the series and with DAX it fails 100% of the time.  I haven't looked into the
details of the failure yet, I just wanted to let you know that it was
happening.
