From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 06/10] dax: provide an iomap based fault handler
Date: Tue, 13 Sep 2016 09:51:26 -0600
Message-ID: <20160913155126.GA10622@linux.intel.com>
References: <1473438884-674-1-git-send-email-hch@lst.de>
 <1473438884-674-7-git-send-email-hch@lst.de>
 <20160909225557.GF30056@dastard>
 <20160910073646.GA18547@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160910073646.GA18547@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

On Sat, Sep 10, 2016 at 09:36:46AM +0200, Christoph Hellwig wrote:
> On Sat, Sep 10, 2016 at 08:55:57AM +1000, Dave Chinner wrote:
> > THe errors from the above two cases are not acted on. they are
> > immediately overwritten by:
> 
> Yes, Robert also pointed this out.  Fix below.
> 
> > Is there a missing "if (error) goto out;" check somewhere here?
> 
> Just the one above.
> 
> > I'm also wondering if you've looked at supporting the PMD fault case
> > with iomap?
> 
> PMD faults currently don't work at all.  Ross has a series to resurrect
> them, but we'll need to coordinate between the two series somehow.  My
> preference would be to not resurrect them for the bh path and only do
> it for the iomap version.

I'm working on this right now.  I expect that most/all of the infrastructure
between the bh+get_block_t version and the iomap version to be shared, it'll
just be a matter of having a PMD version of the iomap fault handler.  This
should be pretty minor.

Let's see how it goes, but right now my plan is to have both - I'd like to
keep feature parity between ext2/ext4 and XFS, and that means having PMD
faults in ext4 via bh+get_block_t until they move over to iomap.

Regarding coordination, the PMD v2 series hasn't gotten much review so far, so
I'm not sure it'll go in for v4.9.  At this point I'm planning on just
rebasing on top of your iomap series, though if it gets taken sooner I
wouldn't object.

> diff --git a/fs/dax.c b/fs/dax.c
> index a170a94..5534594 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1440,6 +1440,7 @@ int iomap_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	default:
>  		WARN_ON_ONCE(1);
>  		error = -EIO;
> +		goto unlock_entry;
>  	}
>  
>  	/* Filesystem should not return unwritten buffers to us! */
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
