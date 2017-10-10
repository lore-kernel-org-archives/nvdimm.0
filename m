Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from quartz.orcorp.ca (quartz.orcorp.ca [184.70.90.242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A214F21E78205
 for <linux-nvdimm@lists.01.org>; Tue, 10 Oct 2017 11:01:52 -0700 (PDT)
Date: Tue, 10 Oct 2017 12:05:12 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Message-ID: <20171010180512.GA31734@obsidianresearch.com>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171009185840.GB15336@obsidianresearch.com>
 <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com>
 <20171009191820.GD15336@obsidianresearch.com>
 <CAPcyv4h_uQGBAX6-bMkkZLO_YyQ6t4n_b8tH8wU_P0Jh23N5MQ@mail.gmail.com>
 <20171010172516.GA29915@obsidianresearch.com>
 <CAPcyv4jL5fN7jjXkQum8ERQ45eW63dCYp5Pm6aHY4OPudz4Wsw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jL5fN7jjXkQum8ERQ45eW63dCYp5Pm6aHY4OPudz4Wsw@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Robin Murphy <robin.murphy@arm.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 10, 2017 at 10:39:27AM -0700, Dan Williams wrote:
> On Tue, Oct 10, 2017 at 10:25 AM, Jason Gunthorpe

> >> Have a look at the patch [1], I don't touch the ODP path.
> >
> > But, does ODP work OK already? I'm not clear on that..
> 
> It had better. If the mapping is invalidated I would hope that
> generates an io fault that gets handled by the driver to setup the new
> mapping. I don't see how it can work otherwise.

I would assume so too...

> > This is why ODP should be the focus because this cannot work fully
> > reliably otherwise..
> 
> The lease break time is configurable. If that application can't
> respond to a stop request within a timeout of its own choosing then it
> should not be using DAX mappings.

Well, no RDMA application can really do this, unless you set the
timeout to multiple minutes, on par with network timeouts.

Again, these details are why I think this kind of DAX and non ODP-MRs
are probably practically not too useful for a production system. Great
for test of course, but in that case SIGKILL would be fine too...

> > Well, what about using SIGKILL if the lease-break-time hits? The
> > kernel will clean up the MRs when the process exits and this will
> > fence DMA to that memory.
> 
> Can you point me to where the MR cleanup code fences DMA and quiesces
> the device?

Yes. The MR's are associated with an fd. When the fd is closed
ib_uverbs_close triggers ib_uverbs_cleanup_ucontext which runs through
all the objects, including MRs, and deletes them.

The specification for deleting a MR requires a synchronous fence with
the hardware. After MR deletion the hardware will not DMA to any pages
described by the old MR, and those pages will be unpinned.

> > But, still, if you really want to be fined graned, then I think
> > invalidating the impacted MR's is a better solution for RDMA than
> > trying to do it with the IOMMU...
> 
> If there's a better routine for handling ib_umem_lease_break() I'd
> love to use it. Right now I'm reaching for the only tool I know for
> kernel enforced revocation of DMA access.

Well, you'd have to code something in the MR code to keep track of DAX
MRs and issue an out of band invalidate to impacted MRs to create the
fence.

This probably needs some driver work, I'm not sure if all the hardware
can do out of band invalidate to any MR or not..

Generally speaking, in RDMA, when a new feature like this comes along
we have to push a lot of the work down to the driver authors, and the
approach has historically been that new features only work on some
hardware (as much as I dislike this, it is pragmatic)

So, not being able to support DAX on certain RDMA hardware is not
an unreasonable situation in our space.

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
