Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 766B781DF4
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jan 2017 07:59:14 -0800 (PST)
Date: Tue, 17 Jan 2017 16:59:10 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Future direction of DAX
Message-ID: <20170117155910.GU2517@quack2.suse.cz>
References: <20170114002008.GA25379@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170114002008.GA25379@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri 13-01-17 17:20:08, Ross Zwisler wrote:
> - The DAX fsync/msync model was built for platforms that need to flush dirty
>   processor cache lines in order to make data durable on NVDIMMs.  There exist
>   platforms, however, that are set up so that the processor caches are
>   effectively part of the ADR safe zone.  This means that dirty data can be
>   assumed to be durable even in the processor cache, obviating the need to
>   manually flush the cache during fsync/msync.  These platforms still need to
>   call fsync/msync to ensure that filesystem metadata updates are properly
>   written to media.  Our first idea on how to properly support these platforms
>   would be for DAX to be made aware that in some cases doesn't need to keep
>   metadata about dirty cache lines.  A similar issue exists for volatile uses
>   of DAX such as with BRD or with PMEM and the memmap command line parameter,
>   and we'd like a solution that covers them all.

Well, we still need the radix tree entries for locking. And you still need
to keep track of which file offsets are writeably mapped (which we
currently implicitely keep via dirty radix tree entries) so that you can
writeprotect them if needed (during filesystem freezing, for reflink, ...).
So I think what is going to gain the most by far is simply to avoid doing
the writeback at all in such situations.

> - If I recall correctly, at one point Dave Chinner suggested that we change
>   DAX so that I/O would use cached stores instead of the non-temporal stores
>   that it currently uses.  We would then track pages that were written to by
>   DAX in the radix tree so that they would be flushed later during
>   fsync/msync.  Does this sound like a win?  Also, assuming that we can find a
>   solution for platforms where the processor cache is part of the ADR safe
>   zone (above topic) this would be a clear improvement, moving us from using
>   non-temporal stores to faster cached stores with no downside.

I guess this needs measurements. But it is worth a try.

> - Jan suggested [2] that we could use the radix tree as a cache to service DAX
>   faults without needing to call into the filesystem.  Are there any issues
>   with this approach, and should we move forward with it as an optimization?

Yup, I'm still for it.

> - Whenever you mount a filesystem with DAX, it spits out a message that says
>   "DAX enabled. Warning: EXPERIMENTAL, use at your own risk".  What criteria
>   needs to be met for DAX to no longer be considered experimental?

So from my POV I'd be OK with removing the warning but still the code is
new so there are clearly bugs lurking ;).

> - When we msync() a huge page, if the range is less than the entire huge page,
>   should we flush the entire huge page and mark it clean in the radix tree, or
>   should we only flush the requested range and leave the radix tree entry
>   dirty?

If you do partial msync(), then you have the problem that msync(0, x),
msync(x, EOF) will not yield a clean file which may surprise somebody. So
I'm slightly skeptical.
 
> - Should we enable 1 GiB huge pages in filesystem DAX?  Does anyone have any
>   specific customer requests for this or performance data suggesting it would
>   be a win?  If so, what work needs to be done to get 1 GiB sized and aligned
>   filesystem block allocations, to get the required enabling in the MM layer,
>   etc?

I'm not convinced it is worth it now. Maybe later...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
