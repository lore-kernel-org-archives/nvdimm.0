Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 2 Oct 2015 08:54:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/7] xfs, dax: fix the page fault/allocation mess
Message-ID: <20151001225448.GJ27164@dastard>
References: <1443685599-4843-1-git-send-email-david@fromorbit.com>
 <20151001203121.GB23495@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151001203121.GB23495@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, willy@linux.intel.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, linux-nvdimm@lists.01.org, jack@suse.cz, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 01, 2015 at 02:31:21PM -0600, Ross Zwisler wrote:
> On Thu, Oct 01, 2015 at 05:46:32PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > As discussed in the recent thread about problems with DAX locking:
> > 
> > http://www.gossamer-threads.com/lists/linux/kernel/2264090?do=post_view_threaded
> > 
> > I said that I'd post the patch set that fixed the problems for XFS
> > as soon as I had something sane and workable. That's what this
> > series is.
> > 
> > To start with, it passes xfstests "auto" group with only the only
> > failures being expected failures or failures due to unexpected
> > allocation patterns or trying to use unsupported block sizes. That
> > makes it better than any previous version of the XFS/DAX code.
.....

> Thank you for working on this, and for documenting your thinking so clearly.

To put this in perspective, "patch 0" descriptions like this is a
requirement for any non-trivial XFS modification. It saves reviewers
so much time and many round trips in email and IRC to understand the
changes being proposed that it's a no-brainer.

Lead by example, and all that...

> One thing I noticed is that in my test setup XFS+DAX is now failing
> generic/274:
> 
> 	# diff -u tests/generic/274.out /root/xfstests/results//generic/274.out.bad
> 	--- tests/generic/274.out	2015-08-24 11:05:41.490926305 -0600
> 	+++ /root/xfstests/results//generic/274.out.bad	2015-10-01 13:53:50.498354091 -0600
> 	@@ -2,4 +2,5 @@
> 	 ------------------------------
> 	 preallocation test
> 	 ------------------------------
> 	-done
> 	+failed to write to test file
> 	+(see /root/xfstests/results//generic/274.full for details)
> 
> I've verified that the test passes 100% of the time with my baseline
> (v4.3-rc3), and with the set applied but without the DAX mount option.  With
> the series and with DAX it fails 100% of the time.  I haven't looked into the
> details of the failure yet, I just wanted to let you know that it was
> happening.

See above - I classified this under the "failures due to unexpected
allocation patterns". This is a ENOSPC test, and we've change the
allocation pattern and the unwritten extent conversion algorithm and
so changed the metadata allocation demand of the test.

I haven't looked any further than this yet, but I suspect the issue
is that the up-front unwritten extent conversion is not being
allowed to dip into the reserve block pool for BMBT allocations when
the extent list grows past a single block. If that's the case, then
it's a couple of lines of code to conditionally at XFS_TRANS_RESERVE
to the transaction handle to allow it access to the reserve pool...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
