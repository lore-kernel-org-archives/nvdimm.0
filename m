Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 3 Nov 2015 10:16:05 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/6] xfs: Don't use unwritten extents for DAX
Message-ID: <20151103091605.GA4063@quack.suse.cz>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
 <1445225238-30413-4-git-send-email-david@fromorbit.com>
 <20151029142950.GE11663@bfoster.bfoster>
 <20151029233756.GS19199@dastard>
 <20151030123657.GC54905@bfoster.bfoster>
 <20151102011433.GW19199@dastard>
 <20151102141509.GA29346@bfoster.bfoster>
 <20151102214424.GJ10656@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151102214424.GJ10656@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 03-11-15 08:44:24, Dave Chinner wrote:
> Realistically, dax_clear_blocks() should probably be implemented at
> the pmem driver layer through blkdev_issue_zeroout() because all it
> does is directly map the sector/len to pfn via bdev_direct_access()
> and then zero it - it's a sector based, block device operation. We
> don't actually need a special case path for DAX here. Optimisation
> of this operation has little to do with the filesystem.

Yep. This is actually what I did in ext4 - the block zeroing is using the
ext4 block zeroout path which ends up calling blkdev_issue_zeroout(). I
didn't want to special-case DAX and figured out that if we want
performance, we should implement blkdev_issue_zeroout() efficiently for
pmem. After all ext4 uses blkdev_issue_zeroout() in other extent conversion
cases where zeroing out is needed.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
