Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0252121F3882E
 for <linux-nvdimm@lists.01.org>; Thu, 12 Oct 2017 23:47:17 -0700 (PDT)
Date: Fri, 13 Oct 2017 08:50:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Message-ID: <20171013065047.GA26461@lst.de>
References: <20171009185840.GB15336@obsidianresearch.com>
 <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com>
 <20171009191820.GD15336@obsidianresearch.com>
 <CAPcyv4h_uQGBAX6-bMkkZLO_YyQ6t4n_b8tH8wU_P0Jh23N5MQ@mail.gmail.com>
 <20171010172516.GA29915@obsidianresearch.com>
 <CAPcyv4jL5fN7jjXkQum8ERQ45eW63dCYp5Pm6aHY4OPudz4Wsw@mail.gmail.com>
 <20171010180512.GA31734@obsidianresearch.com>
 <CAPcyv4gCBu5ptmWyof+Z-p7NbuCygEs2rMe2wdL0n3QQbXhrzA@mail.gmail.com>
 <20171012182712.GA5772@obsidianresearch.com>
 <CAPcyv4g1zXq7MbtivoviHEME6Oi8YJOnVG3jBah3YpHXPAhg6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g1zXq7MbtivoviHEME6Oi8YJOnVG3jBah3YpHXPAhg6Q@mail.gmail.com>
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
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Linux MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 12, 2017 at 01:10:33PM -0700, Dan Williams wrote:
> On Thu, Oct 12, 2017 at 11:27 AM, Jason Gunthorpe
> <jgunthorpe@obsidianresearch.com> wrote:
> > On Tue, Oct 10, 2017 at 01:17:26PM -0700, Dan Williams wrote:
> >
> >> Also keep in mind that what triggers the lease break is another
> >> application trying to write or punch holes in a file that is mapped
> >> for RDMA. So, if the hardware can't handle the iommu mapping getting
> >> invalidated asynchronously and the application can't react in the
> >> lease break timeout period then the administrator should arrange for
> >> the file to not be written or truncated while it is mapped.
> >
> > That makes sense, but why not return ENOSYS or something to the app
> > trying to alter the file if the RDMA hardware can't support this
> > instead of having the RDMA app deal with this lease break weirdness?
> 
> That's where I started, an inode flag that said "hands off, this file
> is busy", but Christoph pointed out that we should reuse the same
> mechanisms that pnfs is using. The pnfs protection scheme uses file
> leases, and once the kernel decides that a lease needs to be broken /
> layout needs to be recalled there is no stopping it, only delaying.

That was just a suggestion - the important statement is that a hands
off flag is just a no-go.

> However, chatting this over with a few more people I have an alternate
> solution that effectively behaves the same as how non-ODP hardware
> handles this case of hole punch / truncation today. So, today if this
> scenario happens on a page-cache backed mapping, the file blocks are
> unmapped and the RDMA continues into pinned pages that are no longer
> part of the file. We can achieve the same thing with the iommu, just
> re-target the I/O into memory that isn't part of the file. That way
> hardware does not see I/O errors and the DAX data consistency model is
> no worse than the page-cache case.

Yikes.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
