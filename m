Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from quartz.orcorp.ca (quartz.orcorp.ca [184.70.90.242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E64A21F3C198
 for <linux-nvdimm@lists.01.org>; Mon,  9 Oct 2017 12:14:58 -0700 (PDT)
Date: Mon, 9 Oct 2017 13:18:20 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Message-ID: <20171009191820.GD15336@obsidianresearch.com>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171009185840.GB15336@obsidianresearch.com>
 <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com>
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

On Mon, Oct 09, 2017 at 12:05:30PM -0700, Dan Williams wrote:
> On Mon, Oct 9, 2017 at 11:58 AM, Jason Gunthorpe
> <jgunthorpe@obsidianresearch.com> wrote:
> > On Fri, Oct 06, 2017 at 03:35:54PM -0700, Dan Williams wrote:
> >> otherwise be quiesced. The need for this knowledge is driven by a need
> >> to make RDMA transfers to DAX mappings safe. If the DAX file's block map
> >> changes we need to be to reliably stop accesses to blocks that have been
> >> freed or re-assigned to a new file.
> >
> > If RDMA is driving this need, why not invalidate backing RDMA MRs
> > instead of requiring a IOMMU to do it? RDMA MR are finer grained and
> > do not suffer from the re-use problem David W. brought up with IOVAs..
> 
> Sounds promising. All I want in the end is to be sure that the kernel
> is enabled to stop any in-flight RDMA at will without asking
> userspace. Does this require per-RDMA driver opt-in or is there a
> common call that can be made?

I don't think this has ever come up in the context of an all-device MR
invalidate requirement. Drivers already have code to invalidate
specifc MRs, but to find all MRs that touch certain pages and then
invalidate them would be new code.

We also have ODP aware drivers that can retarget a MR to new
physical pages. If the block map changes DAX should synchronously
retarget the ODP MR, not halt DMA.

Most likely ODP & DAX would need to be used together to get robust
user applications, as having the user QP's go to an error state at
random times (due to DMA failures) during operation is never going to
be acceptable...

Perhaps you might want to initially only support ODP MR mappings with
DAX and then the DMA fencing issue goes away?

Cheers,
Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
