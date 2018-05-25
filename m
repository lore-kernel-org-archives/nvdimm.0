Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AD4C72063D74E
 for <linux-nvdimm@lists.01.org>; Fri, 25 May 2018 12:23:35 -0700 (PDT)
Date: Fri, 25 May 2018 12:23:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/7] fs: allow per-device dax status checking for
 filesystems
Message-ID: <20180525192327.GR12940@magnolia>
References: <20180525025518.11405-1-ross.zwisler@linux.intel.com>
 <20180525025518.11405-2-ross.zwisler@linux.intel.com>
 <20180525050218.GF4507@magnolia>
 <20180525154229.GA11044@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180525154229.GA11044@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 25, 2018 at 09:42:29AM -0600, Ross Zwisler wrote:
> On Thu, May 24, 2018 at 10:02:18PM -0700, Darrick J. Wong wrote:
> > On Thu, May 24, 2018 at 08:55:12PM -0600, Ross Zwisler wrote:
> > > From: "Darrick J. Wong" <darrick.wong@oracle.com>
> > > 
> > > Remove __bdev_dax_supported and change to bdev_dax_supported that takes a
> > > bdev parameter.  This enables multi-device filesystems like xfs to check
> > > that a dax device can work for the particular filesystem.  Once that's
> > > in place, actually fix all the parts of XFS where we need to be able to
> > > distinguish between datadev and rtdev.
> > > 
> > > This patch fixes the problem where we screw up the dax support checking
> > > in xfs if the datadev and rtdev have different dax capabilities.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > 
> > Reviewed-by: Darr...oh, I'm not allowed to do that, am I?
> > 
> > Would you mind (re)sending this to the xfs list so that someone else can
> > review it?
> > 
> > --D
> 
> Thanks for the review, Darrick.
> 
> I think at one point Dave said that if you touch more than 1 filesystem with a
> series you should just CC linux-fsdevel and omit the individual filesystems?
> I realize that this series only touches ext2 and ext4 a little, but that's
> what I opted for.
> 
> Is that sufficient to get to the rest of the XFS developers, or would you like
> a resend adding linux-xfs?

For a patch by any other author I'd be fine with -fsdevel, but for this
specific one (because it's written by me and I'm not yet so bofh that I
review my own patches ;)) someone else from the xfs community has to
review it, so yes I'd like it to be sent to linux-xfs, please.

(And it's ok to note in the resend that this is the same as the -fsdevel
series, but posted here to attract the attention of the other xfs
developers.)

--D
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
