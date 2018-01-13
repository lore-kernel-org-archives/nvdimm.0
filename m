Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 26E062220D20E
 for <linux-nvdimm@lists.01.org>; Fri, 12 Jan 2018 16:00:11 -0800 (PST)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: DAX 2MB mappings for XFS
Date: Sat, 13 Jan 2018 00:05:22 +0000
Message-ID: <1515804676.16384.64.camel@hpe.com>
References: <1515788779.16384.29.camel@hpe.com>
 <20180112211915.GF27323@dastard> <1515795857.16384.34.camel@hpe.com>
 <20180112222750.GG27323@dastard> <1515801655.16384.57.camel@hpe.com>
 <20180112235255.GB5597@magnolia>
In-Reply-To: <20180112235255.GB5597@magnolia>
Content-Language: en-US
Content-ID: <0F79B67E0882E541BF05DE6AA84071B5@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "david@fromorbit.com" <david@fromorbit.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2018-01-12 at 15:52 -0800, Darrick J. Wong wrote:
> On Fri, Jan 12, 2018 at 11:15:00PM +0000, Kani, Toshi wrote:
 :
> > > > ext4 creates multiple smaller extents for the same request.
> > > 
> > > Yes, because it has much, much smaller block groups so "allocation >
> > > max extent size (128MB)" is a common path.
> > > 
> > > It's not a common path on XFS - filesystems (and hence AGs) are
> > > typically orders of magnitude larger than the maximum extent size
> > > (8GB) so the problem only shows up when we're near ENOSPC. XFS is
> > > really not optimised for tiny filesystems, and when it comes to pmem
> > > we were lead to beleive we'd have mutliple terabytes of pmem in
> > > systems by now, not still be stuck with 8GB NVDIMMS. Hence we've
> > > spent very little time worrying about such issues because we
> > > weren't aiming to support such small capcities for very long...
> > 
> > I see.  Yes, there will be multiple terabytes capacity, but it will also
> > allow to divide it into multiple smaller namespaces.  So, user may
> > continue to have relatively smaller namespaces for their use cases.  If
> > user allocates a namespace that is just big enough to host several
> > active files, it may hit this issue regardless of their size.
> 
> I am curious, why not just give XFS all the space and let it manage the space?

Well, I am not sure if having multiple namespaces would be popular use
cases.  But it could be useful when a system hosts multiple guests or
containers that require isolation in storage space.

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
