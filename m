Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AE9782063D77A
 for <linux-nvdimm@lists.01.org>; Fri,  1 Jun 2018 13:46:23 -0700 (PDT)
Date: Fri, 1 Jun 2018 16:46:04 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 3/7] dm: fix test for DAX device support
Message-ID: <20180601204604.GB1144@redhat.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-4-ross.zwisler@linux.intel.com>
 <20180601201924.GA1144@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180601201924.GA1144@redhat.com>
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
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 01 2018 at  4:19P -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, May 29 2018 at  3:51P -0400,
> Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> 
> > Currently device_supports_dax() just checks to see if the QUEUE_FLAG_DAX
> > flag is set on the device's request queue to decide whether or not the
> > device supports filesystem DAX.  This is insufficient because there are
> > devices like PMEM namespaces in raw mode which have QUEUE_FLAG_DAX set but
> > which don't actually support DAX.
> 
> Isn't that a PMEM bug then?
> 
> What is the point of setting QUEUE_FLAG_DAX if it cannot be trusted?
>  
> > This means that you could create a dm-linear device, for example, where the
> > first part of the dm-linear device was a PMEM namespace in fsdax mode and
> > the second part was a PMEM namespace in raw mode.  Both DM and the
> > filesystem you put on that dm-linear device would think the whole device
> > supports DAX, which would lead to bad behavior once your raw PMEM namespace
> > part using DAX needed struct page for something.
> 
> The PMEM namespace in raw mode shouldn't be setting QUEUE_FLAG_DAX, if
> it didn't then the stacked-up linear DM wouldn't 
> 
> > Fix this by using bdev_dax_supported() like filesystems do at mount time.
> > This checks for raw mode and also performs other tests like checking to
> > make sure the dax_direct_access() path works.
> 
> Sorry "This" does those things where?

I see you meant bdev_dax_supported() does these additional checks.

My previous question stands though.  Why is QUEUE_FLAG_DAX getting set
if the device hasn't already passed these checks?  Shouldn't setting
QUEUE_FLAG_DAX on request_queue depend on bdev_dax_supported() passing?

But looking at the drivers that do set QUEUE_FLAG_DAX: they
don't have the bdev readily available.  Anyway, just strikes me as
bizarre that a driver can set QUEUE_FLAG_DAX without having to have
ensured bdev_dax_supported() passes (even if not programatically, but
that the developer has verified the hooks, et al exist).

But I'll give up on this line of questioning..

My dilemma now is: how do I take these changes without first rebasing
linux-dm.git ontop of Darrick's xfs tree?

I probably should've reviewed faster and been the one to take the entire
set (with appropriate acks obviously).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
