Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EC38422283527
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 16:00:27 -0800 (PST)
Date: Mon, 5 Mar 2018 17:06:39 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2 2/2] xfs: fix rt_dev usage for DAX
Message-ID: <20180306000639.GA15227@linux.intel.com>
References: <151751717968.69886.6978962571680635420.stgit@djiang5-desk3.ch.intel.com>
 <151751718516.69886.135497175511444689.stgit@djiang5-desk3.ch.intel.com>
 <20180201234413.idd27uqzqbg54ddk@destitution>
 <20180202004332.GZ4849@magnolia>
 <d267ed33-950e-a5c5-73ce-36da6c940513@intel.com>
 <20180206231915.GA26233@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180206231915.GA26233@magnolia>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 06, 2018 at 03:19:15PM -0800, Darrick J. Wong wrote:
<>
> The last time I paid much attention to DAX was the thread "re-enable XFS
> per-inode DAX"[1] last September.  Motivating me to merge anything else
> into DAX involves convincing me that we (mm, fs, dax developers) have
> some kind of agreement about what we want the user-visible interfaces to
> DAX to look like.  

Yep, I agree that is the next step.

> Namely:
> 
> 0. On what level do we allow users / administrators to control usage of
> the dax paths?  Can the hardware convey enough detail to the kernel that
> the kernel can make a reasonable decision on its own whether buffered or
> dax io make more sense?  If so, can we please just have that?  If not,
> why?

Maybe eventually via the HMAT, but I don't think we have any systems today
that do a good job of this.

> 1. If we want to let users override whatever decision the kernel makes,
> how should we do this?  One mount option that applies to everything,
> like ext4?  Inheritable inode flags, like xfs?  Do we have one to force
> it on even if the kernel doesn't want to?  Do we have another to force
> it off even if the kernel wants to?  Do we even want to go down this
> path?  Can we get away with making the answer to Q0 "yes" and then see
> if anyone actually complains about not having fine-grained control?

I agree with Dan's assessment that even if we can make the kernel smart enough
to know when it's not a performance loss to use DAX (i.e. the persistent
memory you're using DAX on is just as fast as the page cache), users will
probably still want to retain the ability to force it on for use cases like
MAP_SYNC, and force it off for things like RDMA or VFIO, at least until the
page pinning work is complete.

Personally I'm still hopeful that we can have both the mount option and the
inheritable inode flags, and that we can figure out what we need to to get
S_DAX transitions happening again.

> 2. Under what conditions can we support dynamic changing of S_DAX on
> inodes at runtime?  Will this switching work at any time?  Only for
> files that are open but not mmap'd?  Only for files that are empty?
>
> 3. The MAP_SYNC support that was merged into 4.15 -- is this sufficient
> to allow this fsyncless clflush business that everyone seems to want?

Yep, I think so.  The next big battles are S_DAX transitions, per-inode DAX
support, and of course the page pinning / leases code that Dan & Christoph
have been talking about.

> 4. Can someone please fix the XFS iomap_begin function to handle CoW
> properly?  I think it's a simple matter of allocate blocks, memcpy, and
> remap, though I don't know how to do that. ;)
> 
> 5. Do we test any of this stuff?

Yes, I think in general we do a pretty good job of DAX test case coverage
between a combination of xfstests (which I have added to as I've fixed DAX
related bugs), nfit_test and the ndctl unit tests.  hch has recently suggested
we start using blktests as well, though I don't think we've actually made any
new tests there yet.  Suggestions on how we can get better test coverage are
welcome.

> The thread from last September left off with promises to go define what
> interface and behaviors we are providing to userspace, but afaict none
> of that ever happened?  If we don't resolve these questions before LSF
> then I think what's needed is to lock everyone in a room to hash all
> this out. :P

Yep, that's accurate.  I got pulled off onto other work and am just now
finding my way back.  I think talking about it at LSF sounds great, but it's a
shame that hch won't be available.  It'll be nice to finally meet dchinner,
though. :)

> --D
> 
> PS: My personal inclination is {yes, get rid of all that until someone
> complains, i think so but haven't tested it, ???, i sure hope so}.
> 
> [1] https://marc.info/?l=linux-xfs&m=150638135225793&w=2
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
