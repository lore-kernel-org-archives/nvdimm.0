Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3813A43C1
	for <nvdimm@lists.linux.dev>; Thu, 23 Jun 2022 01:36:08 +0000 (UTC)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
	by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CB7675ECC0A;
	Thu, 23 Jun 2022 11:17:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1o4BTp-009ufF-Sv; Thu, 23 Jun 2022 11:17:57 +1000
Date: Thu, 23 Jun 2022 11:17:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"jack@suse.cz" <jack@suse.cz>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"Gomatam, Sravani" <sravani.gomatam@intel.com>
Subject: Re: [PATCH 8/8] xfs: drop async cache flushes from CIL commits.
Message-ID: <20220623011757.GT227878@dread.disaster.area>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-9-david@fromorbit.com>
 <2820766805073c176e1a65a61fad2ef8ad0f9766.camel@intel.com>
 <20220619234011.GK227878@dread.disaster.area>
 <62b258b6c3821_89207294c@dwillia2-xfh.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62b258b6c3821_89207294c@dwillia2-xfh.notmuch>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62b3bf49
	a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
	a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
	a=7oVrz-HWECc2WQMnN8YA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22

On Tue, Jun 21, 2022 at 04:48:06PM -0700, Dan Williams wrote:
> Dave Chinner wrote:
> > On Thu, Jun 16, 2022 at 10:23:10PM +0000, Williams, Dan J wrote:
> > > On Wed, 2022-03-30 at 12:10 +1100, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > Perf confirms that all of that CPU time is being spent in
> > > arch_wb_cache_pmem(). It likely means that rather than amortizing that
> > > same latency periodically throughout the workload run, it is all being
> > > delayed until umount.
> > 
> > For completeness, this is what the umount IO looks like:
> > 
> > 259,1    5        1    98.680129260 10166  Q FWFSM 8392256 + 8 [umount]
> > 259,1    5        2    98.680135797 10166  C FWFSM 8392256 + 8 [0]
> > 259,1    3      429    98.680341063  4977  Q  WM 0 + 8 [xfsaild/pmem0]
> > 259,1    3      430    98.680362599  4977  C  WM 0 + 8 [0]
> > 259,1    5        3    98.680616201 10166  Q FWFSM 8392264 + 8 [umount]
> > 259,1    5        4    98.680619218 10166  C FWFSM 8392264 + 8 [0]
> > 259,1    3      431    98.680767121  4977  Q  WM 0 + 8 [xfsaild/pmem0]
> > 259,1    3      432    98.680770938  4977  C  WM 0 + 8 [0]
> > 259,1    5        5    98.680836733 10166  Q FWFSM 8392272 + 8 [umount]
> > 259,1    5        6    98.680839560 10166  C FWFSM 8392272 + 8 [0]
> > 259,1   12        7    98.683546633 10166  Q FWS [umount]
> > 259,1   12        8    98.683551424 10166  C FWS 0 [0]
> > 
> > You can see 3 journal writes there with REQ_PREFLUSH set before XFS
> > calls blkdev_issue_flush() (FWS of zero bytes) in xfs_free_buftarg()
> > just before tearing down DAX state and freeing the buftarg.
> > 
> > Which one of these cache flush operations is taking 10 minutes to
> > complete? That will tell us a lot more about what is going on...
> > 
> > > I assume this latency would also show up without DAX if page-cache is
> > > now allowed to continue growing, or is there some other signal that
> > > triggers async flushes in that case?
> > 
> > I think you've misunderstood what the "async" part of "async cache
> > flushes" actually did. It was an internal journal write optimisation
> > introduced in bad77c375e8d ("xfs: CIL checkpoint flushes caches
> > unconditionally") in 5.14 that didn't work out and was reverted in
> > 5.18. It didn't change the cache flushing semantics of the journal,
> > just reverted to the same REQ_PREFLUSH behaviour we had for a decade
> > leading up the the "async flush" change in the 5.14 kernel.
> 
> Oh, it would be interesting to see if pre-5.14 also has this behavior.
> 
> > To me, this smells of a pmem block device cache flush issue, not a
> > filesystem problem...
> 
> ...or at least an fs/dax.c problem. Sravani grabbed the call stack:
> 
>    100.00%     0.00%             0  [kernel.vmlinux]  [k] ret_from_fork                -      -            
>             |
>             ---ret_from_fork
>                kthread
>                worker_thread
>                process_one_work
>                wb_workfn
>                wb_writeback
>                writeback_sb_inodes
>                __writeback_single_inode
>                do_writepages
>                dax_writeback_mapping_range
>                |          
>                 --99.71%--arch_wb_cache_pmem

So that's iterating every page that has been had a write fault on
it without dirty data page mappings that are being flushed as a
result of userspace page faults:

dax_iomap_fault
  dax_iomap_{pte,pmd}_fault
    dax_fault_iter
	dax_insert_entry(dirty)
	  xas_set_mark(xas, PAGECACHE_TAG_DIRTY);

without MAP_SYNC being set on the user mapping.

If MAP_SYNC was set on the mapping, we'd then end up returning to
the dax_iomap_fault() caller with VMNEEDSYNC and calling
dax_finish_sync_fault() which then runs vfs_fsync_range() and that
will flush the cache for the faulted page, clear the
PAGECACHE_TAG_DIRTY, and then flush the filesystem metadata and
device caches if necessary. Background writeback will never see this
inode as needing writeback....

Hence I can't see how the XFS commit you've pointed at and the
behaviour being reported are in any way connected together - the
user DAX cache flush tracking and execution is completely
independent to the journal/bdev based cache flushing mechanism and
they don't interact at all.

> One experiment I want to see is turn off DAX and see what the unmount
> performance is when this is targeting page cache for mmap I/O. My
> suspicion is that at some point dirty-page pressure triggers writeback
> that just does not happen in the DAX case.

I'd be more interesting in the result of a full bisect to find
the actual commit that caused/fixed the behaviour you are seeing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
