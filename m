Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 8 Jan 2016 11:15:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/4] block: introduce del_gendisk_queue()
Message-ID: <20160108001544.GQ21461@dastard>
References: <20160106045616.38788.61076.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160106045627.38788.90127.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160106045627.38788.90127.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 05, 2016 at 08:56:27PM -0800, Dan Williams wrote:
> Historically we have waited for filesystem specific heuristics to
> attempt to guess when a block device is gone.  Sometimes this works, but
> in other cases the system can hang waiting for the fs to trigger its
> shutdown protocol.
> 
> The initial motivation for this investigation was to prevent DAX
> mappings (direct mmap access to persistent memory) from leaking past the
> lifetime of the hosting block device.  However, Dave points out that
> these shutdown operations are needed in other scenarios.  Quoting Dave:
> 
>     For example, if we detect a free space corruption during allocation,
>     it is not safe to trust *any active mapping* because we can't trust
>     that we having handed out the same block to multiple owners. Hence
>     on such a filesystem shutdown, we have to prevent any new DAX
>     mapping from occurring and invalidate all existing mappings as we
>     cannot allow userspace to modify any data or metadata until we've
>     resolved the corruption situation.
> 
> The current block device shutdown sequence of del_gendisk +
> blk_cleanup_queue is problematic.  We want to tell the fs after
> blk_cleanup_queue that there is no possibility of recovery, but by that
> time we have deleted partitions and lost the ability to find all the
> super-blocks on a block device.
> 
> del_gendisk_queue() combines block device shutdown, blk_cleanup_queue(),
> with block device end of life notification, del_gendisk().  A later
> patch builds on this sequence to additionally communicate to the fs that
> it should force-fail all future i/o since the queue is permanently dead.

This still is two changes in one. Adding the force failure feature
is a separate change to creating del_gendisk_queue().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
