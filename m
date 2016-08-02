Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
 [150.101.137.141]) by ml01.01.org (Postfix) with ESMTP id 143C01A1E58
 for <linux-nvdimm@lists.01.org>; Mon,  1 Aug 2016 17:29:44 -0700 (PDT)
Date: Tue, 2 Aug 2016 10:21:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160802002144.GL16044@dastard>
References: <20160727120745.GI6860@quack2.suse.cz>
 <20160727211039.GA20278@linux.intel.com>
 <20160727221949.GU16044@dastard>
 <20160728081033.GC4094@quack2.suse.cz>
 <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard> <579F20D9.80107@plexistor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <579F20D9.80107@plexistor.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, XFS Developers <xfs@oss.sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 01, 2016 at 01:13:45PM +0300, Boaz Harrosh wrote:
> On 07/30/2016 03:12 AM, Dave Chinner wrote:
> <>
> > 
> > If we track the dirty blocks from write in the radix tree like we
> > for mmap, then we can just use a normal memcpy() in dax_do_io(),
> > getting rid of the slow cache bypass that is currently run. Radix
> > tree updates are much less expensive than a slow memcpy of large
> > amounts of data, ad fsync can then take care of persistence, just
> > like we do for mmap.
> > 
> 
> No! 
> 
> mov_nt instructions, That "slow cache bypass that is currently run" above
> is actually faster then cached writes by 20%, and if you add the dirty
> tracking and cl_flush instructions it becomes x2 slower in the most
> optimal case and 3 times slower in the DAX case.

IOWs, we'd expect writing to a file with DAX to be faster than when
buffered through the page cache and fsync()d, right?

The numbers I get say otherwise. Filesystem on 8GB pmem block device:

$ sudo mkfs.xfs -f /dev/pmem1
meta-data=/dev/pmem1             isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0, rmapbt=0, reflink=0
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Test command that writes 1GB to the filesystem:

$ sudo time xfs_io -f -c "pwrite 0 1g" -c "sync" /mnt/scratch/foo
wrote 1073741824/1073741824 bytes at offset 0
1 GiB, 262144 ops; 0:00:01.00 (880.040 MiB/sec and 225290.3317 ops/sec)
0.02user 1.13system 0:02.27elapsed 51%CPU (0avgtext+0avgdata 2344maxresident)k
0inputs+0outputs (0major+109minor)pagefaults 0swaps

Results:

	    pwrite B/W (MiB/s)			runtime
run	no DAX		DAX		no DAX		DAX
 1	880.040		236.352		2.27s		4.34s
 2	857.094		257.297		2.18s		3.99s
 3	865.820		236.087		2.13s		4.34s

It is quite clear that *DAX is much slower* than normal buffered
IO through the page cache followed by a fsync().

Stop and think why that might be. We're only doing one copy with
DAX, so why is the pwrite() speed 4x lower than for a copy into the
page cache? We're not copying 4x the data here. We're copying it
once. But there's another uncached write to each page during
allocation to zero each block first, so we're actually doing two
uncached writes to the page. And we're doing an allocation per page
with DAX, whereas we're using delayed allocation in the buffered IO
case which has much less overhead.

The only thing we can do here to speed the DAX case up is do cached
memcpy so that the data copy after zeroing runs at L1 cache speed
(i.e. 50x faster than it currently does).

Let's take the allocation out of it, eh? Let's do overwrite instead,
fsync in the buffered Io case, no fsync for DAX:

	    pwrite B/W (MiB/s)			runtime
run	no DAX		DAX		no DAX		DAX
 1	1119		1125		1.85s		0.93s
 2	1113		1121		1.83s		0.91s
 3	1128		1078		1.80s		0.94s

So, pwrite speeds are no different for DAX vs page cache IO. Also,
now we can see the overhead of writeback - a second data copy to
the pmem for the IO during fsync. If I take the fsync() away from
the buffered IO, the runtime drops to 0.89-0.91s, which is identical
to the DAX code. Given the DAX code has a short IO path than
buffered IO, it's not showing any advantage speed for using uncached
IO....

Let's go back to the allocation case, but this time take advantage
of the new iomap based Io path in XFS to amortise the DAX allocation
overhead by using a 16MB IO size instead of 4k:

$ sudo time xfs_io -f -c "pwrite 0 1g -b 16m" -c sync /mnt/scratch/foo


	    pwrite B/W (MiB/s)			runtime
run	no DAX		DAX		no DAX		DAX
 1	1344		1028		1.63s		1.03s
 2	1410		 980		1.62s		1.06s
 3	1399		1032		1.72s		0.99s

So, pwrite bandwidth of the copy into the page cache is still much
higher than that of the DAX path, but now the allocation overhead
is minimised and hence the double copy in the buffered IO writeback
path shows up. For completeness, lets just run the overwrite case
here which is effectively just competing  memcpy implementations,
fsync for buffered, no fsync for DAX:

	    pwrite B/W (MiB/s)			runtime
run	no DAX		DAX		no DAX		DAX
 1	1791		1727		1.53s		0.59s
 2	1768		1726		1.57s		0.59s
 3	1799		1729		1.55s		0.59s

Again, runtime shows the overhead of the double copy in the buffered
IO/writeback path. It also shows the overhead in the DAX path of the
allocation zeroing vs overwrite. If I drop the fsync from the
buffered IO path, bandwidth remains the same but runtime drops to
0.55-0.57s, so again the buffered IO write path is faster than DAX
while doing more work.

IOws, the overhead of dirty page tracking in the page cache mapping
tree is not significant in terms of write() performance. Hence
I fail to see why it should be significant in the DAX path - it will
probably have less overhead because we have less to account for in
the DAX write path. The only performance penalty for dirty tracking
is in the fsync writeback path itself, and that a separate issue
for optimisation.

Quite frankly, what I see here is that whatever optimisations that
have been made to make DAX fast don't show any real world benefit.
Further, the claims that dirty tracking has too much overhead are
*completely shot down* by the fact that buffered write IO through
the page cache is *faster* than the current DAX write IO path.

> The network guys have noticed the mov_nt instructions superior
> performance for years before we pushed DAX into the tree. look for
> users of copy_from_iter_nocache and the comments when they where
> introduced, those where used before DAX, and nothing at all to do
> with persistence.
> 
> So what you are suggesting is fine only 3 times slower in the current
> implementation.

What is optimal for one use case does not mean it is optimal for
all.

High level operation performance measurement disagrees with the
assertion that we're using the *best* method of copying data in the
DAX path available right now. Understand how data moves through the
system, then optimise the data flow. What we are seeing here is that
optimising for the fastest single data movement can result in lower
overall performance where the code path requires multiple data
movements to the same location....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
