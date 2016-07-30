Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
 [150.101.137.141]) by ml01.01.org (Postfix) with ESMTP id 44AAB1A1E27
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jul 2016 17:13:35 -0700 (PDT)
Date: Sat, 30 Jul 2016 10:12:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160730001249.GE16044@dastard>
References: <20160727120745.GI6860@quack2.suse.cz>
 <20160727211039.GA20278@linux.intel.com>
 <20160727221949.GU16044@dastard>
 <20160728081033.GC4094@quack2.suse.cz>
 <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, XFS Developers <xfs@oss.sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 29, 2016 at 07:44:25AM -0700, Dan Williams wrote:
> On Thu, Jul 28, 2016 at 7:21 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Jul 28, 2016 at 10:10:33AM +0200, Jan Kara wrote:
> >> On Thu 28-07-16 08:19:49, Dave Chinner wrote:
> [..]
> >> So DAX doesn't need flushing to maintain consistent view of the data but it
> >> does need flushing to make sure fsync(2) results in data written via mmap
> >> to reach persistent storage.
> >
> > I thought this all changed with the removal of the pcommit
> > instruction and wmb_pmem() going away.  Isn't it now a platform
> > requirement now that dirty cache lines over persistent memory ranges
> > are either guaranteed to be flushed to persistent storage on power
> > fail or when required by REQ_FLUSH?
> 
> No, nothing automates cache flushing.  The path of a write is:
> 
> cpu-cache -> cpu-write-buffer -> bus -> imc -> imc-write-buffer -> media
> 
> The ADR mechanism and the wpq-flush facility flush data thorough the
> imc (integrated memory controller) to media.  dax_do_io() gets writes
> to the imc, but we still need a posted-write-buffer flush mechanism to
> guarantee data makes it out to media.

So what you are saying is that on and ADR machine, we have these
domains w.r.t. power fail:

cpu-cache -> cpu-write-buffer -> bus -> imc -> imc-write-buffer -> media

|-------------volatile-------------------|-----persistent--------------|

because anything that gets to the IMC is guaranteed to be flushed to
stable media on power fail.

But on a posted-write-buffer system, we have this:

cpu-cache -> cpu-write-buffer -> bus -> imc -> imc-write-buffer -> media

|-------------volatile-------------------------------------------|--persistent--|

IOWs, only things already posted to the media via REQ_FLUSH are
considered stable on persistent media.  What happens in this case
when power fails during a media update? Incomplete writes?

> > Or have we somehow ended up with the fucked up situation where
> > dax_do_io() writes are (effectively) immediately persistent and
> > untracked by internal infrastructure, whilst mmap() writes
> > require internal dirty tracking and fsync() to flush caches via
> > writeback?
> 
> dax_do_io() writes are not immediately persistent.  They bypass the
> cpu-cache and cpu-write-bufffer and are ready to be flushed to media
> by REQ_FLUSH or power-fail on an ADR system.

IOWs, on an ADR system  write is /effectively/ immediately persistent
because if power fails ADR guarantees it will be flushed to stable
media, while on a posted write system it is volatile and will be
lost. Right?

If so, that's even worse than just having mmap/write behave
differently - now writes will behave differently depending on the
specific hardware installed. I think this makes it even more
important for the DAX code to hide this behaviour from the
fielsystems by treating everything as volatile.

If we track the dirty blocks from write in the radix tree like we
for mmap, then we can just use a normal memcpy() in dax_do_io(),
getting rid of the slow cache bypass that is currently run. Radix
tree updates are much less expensive than a slow memcpy of large
amounts of data, ad fsync can then take care of persistence, just
like we do for mmap.

We should just make the design assumption that all persistent memory
is volatile, track where we dirty it in all paths, and use the
fastest volatile memcpy primitives available to us in the IO path.
We'll end up with a faster fastpath that if we use CPU cache bypass
copies, dax_do_io() and mmap will be coherent and synchronised, and
fsync() will have the same requirements and overhead regardless of
the way the application modifies the pmem or the hardware platform
used to implement the pmem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
