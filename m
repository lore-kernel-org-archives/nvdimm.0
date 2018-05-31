Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F92D20957AFF
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 13:52:10 -0700 (PDT)
Date: Thu, 31 May 2018 16:52:06 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 2/7] dax: change bdev_dax_supported() to support
 boolean returns
Message-ID: <20180531205206.GA12681@redhat.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-3-ross.zwisler@linux.intel.com>
 <20180529212510.GJ30110@magnolia>
 <20180529220114.GA13948@linux.intel.com>
 <20180531191332.GB7825@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180531191332.GB7825@magnolia>
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
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 31 2018 at  3:13pm -0400,
Darrick J. Wong <darrick.wong@oracle.com> wrote:

> On Tue, May 29, 2018 at 04:01:14PM -0600, Ross Zwisler wrote:
> > On Tue, May 29, 2018 at 02:25:10PM -0700, Darrick J. Wong wrote:
> > > On Tue, May 29, 2018 at 01:51:01PM -0600, Ross Zwisler wrote:
> > > > From: Dave Jiang <dave.jiang@intel.com>
> > > > 
> > > > The function return values are confusing with the way the function is
> > > > named. We expect a true or false return value but it actually returns
> > > > 0/-errno.  This makes the code very confusing. Changing the return values
> > > > to return a bool where if DAX is supported then return true and no DAX
> > > > support returns false.
> > > > 
> > > > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > 
> > > Looks ok, do you want me to pull the first two patches through the xfs
> > > tree?
> > > 
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Thanks for the review.
> > 
> > I'm not sure what's best.  If you do that then Mike will need to have a DM
> > branch for the rest of the series based on your stable commits, yea?
> > 
> > Mike what would you prefer?
> 
> I /was/ about to say that I would pull in the first two patches, but now
> I can't get xfs to mount with pmem at all, and have no way of testing
> this...?

Once you get this sorted out, please feel free to pull in the first 2.

I'm unlikely to get to reviewing the DM patches in this series until
tomorrow at the earliest.

Mike
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
