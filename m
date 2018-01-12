Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 513B22035D305
 for <linux-nvdimm@lists.01.org>; Fri, 12 Jan 2018 15:09:48 -0800 (PST)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: DAX 2MB mappings for XFS
Date: Fri, 12 Jan 2018 23:15:00 +0000
Message-ID: <1515801655.16384.57.camel@hpe.com>
References: <1515788779.16384.29.camel@hpe.com>
 <20180112211915.GF27323@dastard> <1515795857.16384.34.camel@hpe.com>
 <20180112222750.GG27323@dastard>
In-Reply-To: <20180112222750.GG27323@dastard>
Content-Language: en-US
Content-ID: <031583E0F3E3064392BA05DE9C21BA3A@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
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
To: "david@fromorbit.com" <david@fromorbit.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, 2018-01-13 at 09:27 +1100, Dave Chinner wrote:
> On Fri, Jan 12, 2018 at 09:38:22PM +0000, Kani, Toshi wrote:
> > On Sat, 2018-01-13 at 08:19 +1100, Dave Chinner wrote:
> >  :
> > > IOWs, what you are seeing is trying to do a very large allocation on
> > > a very small (8GB) XFS filesystem.  It's rare someone asks to
> > > allocate >25% of the filesystem space in one allocation, so it's not
> > > surprising it triggers ENOSPC-like algorithms because it doesn't fit
> > > into a single AG....
> > > 
> > > We can probably look to optimise this, but I'm not sure if we can
> > > easily differentiate this case (i.e. allocation request larger than
> > > continguous free space) from the same situation near ENOSPC when we
> > > really do have to trim to fit...
> > > 
> > > Remember: stripe unit allocation alignment is a hint in XFS that we
> > > can and do ignore when necessary - it's not a binding rule.
> > 
> > Thanks for the clarification!  Can XFS allocate smaller extents so that
> > each extent will fit to an AG?
> 
> I've already answered that question:
> 
> 	I'm not sure if we can easily differentiate this case (i.e.
> 	allocation request larger than continguous free space) from
> 	the same situation near ENOSPC when we really do have to
> 	trim to fit...

Right.  I was thinking to limit the extent size (i.e. a half or quarter
of AG size) regardless of the ENOSPC condition, but it may be the same
thing.

> > ext4 creates multiple smaller extents for the same request.
> 
> Yes, because it has much, much smaller block groups so "allocation >
> max extent size (128MB)" is a common path.
> 
> It's not a common path on XFS - filesystems (and hence AGs) are
> typically orders of magnitude larger than the maximum extent size
> (8GB) so the problem only shows up when we're near ENOSPC. XFS is
> really not optimised for tiny filesystems, and when it comes to pmem
> we were lead to beleive we'd have mutliple terabytes of pmem in
> systems by now, not still be stuck with 8GB NVDIMMS. Hence we've
> spent very little time worrying about such issues because we
> weren't aiming to support such small capcities for very long...

I see.  Yes, there will be multiple terabytes capacity, but it will also
allow to divide it into multiple smaller namespaces.  So, user may
continue to have relatively smaller namespaces for their use cases.  If
user allocates a namespace that is just big enough to host several
active files, it may hit this issue regardless of their size.

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
