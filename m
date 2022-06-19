Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4259E7B
	for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 00:07:15 +0000 (UTC)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
	by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3063210E73F1;
	Mon, 20 Jun 2022 09:40:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1o34WZ-008hWb-8E; Mon, 20 Jun 2022 09:40:11 +1000
Date: Mon, 20 Jun 2022 09:40:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"jack@suse.cz" <jack@suse.cz>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"Gomatam, Sravani" <sravani.gomatam@intel.com>
Subject: Re: [PATCH 8/8] xfs: drop async cache flushes from CIL commits.
Message-ID: <20220619234011.GK227878@dread.disaster.area>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-9-david@fromorbit.com>
 <2820766805073c176e1a65a61fad2ef8ad0f9766.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2820766805073c176e1a65a61fad2ef8ad0f9766.camel@intel.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62afb3de
	a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
	a=8nJEP1OIZ-IA:10 a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
	a=XA7BxA_fJqiVx7Dl2EIA:9 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22

On Thu, Jun 16, 2022 at 10:23:10PM +0000, Williams, Dan J wrote:
> On Wed, 2022-03-30 at 12:10 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Jan Kara reported a performance regression in dbench that he
> > bisected down to commit bad77c375e8d ("xfs: CIL checkpoint
> > flushes caches unconditionally").
> > 
> > Whilst developing the journal flush/fua optimisations this cache was
> > part of, it appeared to made a significant difference to
> > performance. However, now that this patchset has settled and all the
> > correctness issues fixed, there does not appear to be any
> > significant performance benefit to asynchronous cache flushes.
> > 
> > In fact, the opposite is true on some storage types and workloads,
> > where additional cache flushes that can occur from fsync heavy
> > workloads have measurable and significant impact on overall
> > throughput.
> > 
> > Local dbench testing shows little difference on dbench runs with
> > sync vs async cache flushes on either fast or slow SSD storage, and
> > no difference in streaming concurrent async transaction workloads
> > like fs-mark.
> > 
> > Fast NVME storage.
> > 
> > > From `dbench -t 30`, CIL scale:
> > 
> > clients         async                   sync
> >                 BW      Latency         BW      Latency
> > 1                935.18   0.855          915.64   0.903
> > 8               2404.51   6.873         2341.77   6.511
> > 16              3003.42   6.460         2931.57   6.529
> > 32              3697.23   7.939         3596.28   7.894
> > 128             7237.43  15.495         7217.74  11.588
> > 512             5079.24  90.587         5167.08  95.822
> > 
> > fsmark, 32 threads, create w/ 64 byte xattr w/32k logbsize
> > 
> >         create          chown           unlink
> > async   1m41s           1m16s           2m03s
> > sync    1m40s           1m19s           1m54s
> > 
> > Slower SATA SSD storage:
> > 
> > > From `dbench -t 30`, CIL scale:
> > 
> > clients         async                   sync
> >                 BW      Latency         BW      Latency
> > 1                 78.59  15.792           83.78  10.729
> > 8                367.88  92.067          404.63  59.943
> > 16               564.51  72.524          602.71  76.089
> > 32               831.66 105.984          870.26 110.482
> > 128             1659.76 102.969         1624.73  91.356
> > 512             2135.91 223.054         2603.07 161.160
> > 
> > fsmark, 16 threads, create w/32k logbsize
> > 
> >         create          unlink
> > async   5m06s           4m15s
> > sync    5m00s           4m22s
> > 
> > And on Jan's test machine:
> > 
> >                    5.18-rc8-vanilla       5.18-rc8-patched
> > Amean     1        71.22 (   0.00%)       64.94 *   8.81%*
> > Amean     2        93.03 (   0.00%)       84.80 *   8.85%*
> > Amean     4       150.54 (   0.00%)      137.51 *   8.66%*
> > Amean     8       252.53 (   0.00%)      242.24 *   4.08%*
> > Amean     16      454.13 (   0.00%)      439.08 *   3.31%*
> > Amean     32      835.24 (   0.00%)      829.74 *   0.66%*
> > Amean     64     1740.59 (   0.00%)     1686.73 *   3.09%*
> > 
> > Performance and cache flush behaviour is restored to pre-regression
> > levels.
> > 
> > As such, we can now consider the async cache flush mechanism an
> > unnecessary exercise in premature optimisation and hence we can
> > now remove it and the infrastructure it requires completely.
> 
> It turns out this regresses umount latency on DAX filesystems. Sravani
> reached out to me after noticing that v5.18 takes up to 10 minutes to
> complete umount. On a whim I guessed this patch and upon revert of
> commit 919edbadebe1 ("xfs: drop async cache flushes from CIL commits")
> on top of v5.18 umount time goes back down to v5.17 levels.

That doesn't change the fact we are issuing cache flushes from the
log checkpoint code - it just changes how we issue them. We removed
the explicit blkdev_issue_flush_async() call from the cache path and
went back to the old way of doing things (attaching it directly to
the first IO of a journal checkpoint) when it became clear the async
flush was causing performance regressions on storage with really
slow cache flush semantics by causing too many extra cache flushes
to be issued.

As I just captured from /dev/pmem0 on 5.19-rc2 when a fsync was
issued after a 1MB write:

259,1    1      513    41.695930264  4615  Q FWFSM 8388688 + 8 [xfs_io]
259,1    1      514    41.695934668  4615  C FWFSM 8388688 + 8 [0]

You can see that the journal IO was issued as:

	REQ_PREFLUSH | REQ_OP_WRITE | REQ_FUA | REQ_SYNC | REQ_META

As it was a single IO journal checkpoint - that's where the REQ_FUA
came from.

So if we create 5000 zero length files instead to create a large,
multi-IO checkpoint, we get this pattern from the journal:

259,1    2      103    90.614842783   101  Q FWSM 8388720 + 64 [kworker/u33:1]
259,1    2      104    90.614928169   101  C FWSM 8388720 + 64 [0]
259,1    2      105    90.615012360   101  Q WSM 8388784 + 64 [kworker/u33:1]
259,1    2      106    90.615028941   101  C WSM 8388784 + 64 [0]
259,1    2      107    90.615102783   101  Q WSM 8388848 + 64 [kworker/u33:1]
259,1    2      108    90.615118677   101  C WSM 8388848 + 64 [0]
.....
259,1    2      211    90.619375834   101  Q WSM 8392176 + 64 [kworker/u33:1]
259,1    2      212    90.619391042   101  C WSM 8392176 + 64 [0]
259,1    2      213    90.619415946   134  Q FWFSM 8392240 + 16 [kworker/2:1]
259,1    2      214    90.619420274   134  C FWFSM 8392240 + 16 [0]

And you can see that the first IO has REQ_PREFLUSH set, and the last
IO (the commit record) has both REQ_PREFLUSH and REQ_FUA set.

IOWs, the filesystem is issuing IO with exactly the semantics it
requires from the block device, and expecting the block device to b
flushing caches entirely on the first IO of a checkpoint.

> Perf confirms that all of that CPU time is being spent in
> arch_wb_cache_pmem(). It likely means that rather than amortizing that
> same latency periodically throughout the workload run, it is all being
> delayed until umount.

For completeness, this is what the umount IO looks like:

259,1    5        1    98.680129260 10166  Q FWFSM 8392256 + 8 [umount]
259,1    5        2    98.680135797 10166  C FWFSM 8392256 + 8 [0]
259,1    3      429    98.680341063  4977  Q  WM 0 + 8 [xfsaild/pmem0]
259,1    3      430    98.680362599  4977  C  WM 0 + 8 [0]
259,1    5        3    98.680616201 10166  Q FWFSM 8392264 + 8 [umount]
259,1    5        4    98.680619218 10166  C FWFSM 8392264 + 8 [0]
259,1    3      431    98.680767121  4977  Q  WM 0 + 8 [xfsaild/pmem0]
259,1    3      432    98.680770938  4977  C  WM 0 + 8 [0]
259,1    5        5    98.680836733 10166  Q FWFSM 8392272 + 8 [umount]
259,1    5        6    98.680839560 10166  C FWFSM 8392272 + 8 [0]
259,1   12        7    98.683546633 10166  Q FWS [umount]
259,1   12        8    98.683551424 10166  C FWS 0 [0]

You can see 3 journal writes there with REQ_PREFLUSH set before XFS
calls blkdev_issue_flush() (FWS of zero bytes) in xfs_free_buftarg()
just before tearing down DAX state and freeing the buftarg.

Which one of these cache flush operations is taking 10 minutes to
complete? That will tell us a lot more about what is going on...

> I assume this latency would also show up without DAX if page-cache is
> now allowed to continue growing, or is there some other signal that
> triggers async flushes in that case?

I think you've misunderstood what the "async" part of "async cache
flushes" actually did. It was an internal journal write optimisation
introduced in bad77c375e8d ("xfs: CIL checkpoint flushes caches
unconditionally") in 5.14 that didn't work out and was reverted in
5.18. It didn't change the cache flushing semantics of the journal,
just reverted to the same REQ_PREFLUSH behaviour we had for a decade
leading up the the "async flush" change in the 5.14 kernel.

To me, this smells of a pmem block device cache flush issue, not a
filesystem problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
