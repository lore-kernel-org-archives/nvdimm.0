Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <20171009185840.GB15336@obsidianresearch.com>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171009185840.GB15336@obsidianresearch.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 9 Oct 2017 12:05:30 -0700
Message-ID: <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 9, 2017 at 11:58 AM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Fri, Oct 06, 2017 at 03:35:54PM -0700, Dan Williams wrote:
>> otherwise be quiesced. The need for this knowledge is driven by a need
>> to make RDMA transfers to DAX mappings safe. If the DAX file's block map
>> changes we need to be to reliably stop accesses to blocks that have been
>> freed or re-assigned to a new file.
>
> If RDMA is driving this need, why not invalidate backing RDMA MRs
> instead of requiring a IOMMU to do it? RDMA MR are finer grained and
> do not suffer from the re-use problem David W. brought up with IOVAs..

Sounds promising. All I want in the end is to be sure that the kernel
is enabled to stop any in-flight RDMA at will without asking
userspace. Does this require per-RDMA driver opt-in or is there a
common call that can be made?

Outside of that the re-use problem is already solved by just unmapping
(iommu_unmap()) the IOVA, but keeping it allocated until the eventual
dma_unmap_sg() at memory un-registration time frees it.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
