Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from quartz.orcorp.ca (quartz.orcorp.ca [184.70.90.242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E913121F38822
 for <linux-nvdimm@lists.01.org>; Thu, 12 Oct 2017 11:24:06 -0700 (PDT)
Date: Thu, 12 Oct 2017 12:27:12 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Message-ID: <20171012182712.GA5772@obsidianresearch.com>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732935473.22363.1853399637339625023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171009185840.GB15336@obsidianresearch.com>
 <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com>
 <20171009191820.GD15336@obsidianresearch.com>
 <CAPcyv4h_uQGBAX6-bMkkZLO_YyQ6t4n_b8tH8wU_P0Jh23N5MQ@mail.gmail.com>
 <20171010172516.GA29915@obsidianresearch.com>
 <CAPcyv4jL5fN7jjXkQum8ERQ45eW63dCYp5Pm6aHY4OPudz4Wsw@mail.gmail.com>
 <20171010180512.GA31734@obsidianresearch.com>
 <CAPcyv4gCBu5ptmWyof+Z-p7NbuCygEs2rMe2wdL0n3QQbXhrzA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gCBu5ptmWyof+Z-p7NbuCygEs2rMe2wdL0n3QQbXhrzA@mail.gmail.com>
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

On Tue, Oct 10, 2017 at 01:17:26PM -0700, Dan Williams wrote:

> Also keep in mind that what triggers the lease break is another
> application trying to write or punch holes in a file that is mapped
> for RDMA. So, if the hardware can't handle the iommu mapping getting
> invalidated asynchronously and the application can't react in the
> lease break timeout period then the administrator should arrange for
> the file to not be written or truncated while it is mapped.

That makes sense, but why not return ENOSYS or something to the app
trying to alter the file if the RDMA hardware can't support this
instead of having the RDMA app deal with this lease break weirdness?

> It's already the case that get_user_pages() does not lock down file
> associations, so if your application is contending with these types of
> file changes it likely already has a problem keeping transactions in
> sync with the file state even without DAX.

Yes, things go weird in non-ODP RDMA cases like this..

Also, just to clear, I would expect an app using the SIGIO interface
to basically halt ongoing RDMA, wait for MRs to become unused locally
and remotely, destroy the MRs, then somehow, establish new MRs that
cover the same logical map (eg what ODP would do transparently) after
the lease breaker has made their changes, then restart their IO.

Does your SIGIO approach have a race-free way to do that last steps?

> > So, not being able to support DAX on certain RDMA hardware is not
> > an unreasonable situation in our space.
> 
> That makes sense, but it still seems to me that this proposed solution
> allows more than enough ways to avoid that worst case scenario where
> hardware reacts badly to iommu invalidation.

Yes, although I am concerned that returning PCI-E errors is such an
unusual and untested path for some of our RDMA drivers that they may
malfunction badly...

Again, going back to the question of who would ever use this, I would
be very relucant to deploy a production configuration relying on the iommu
invalidate or SIGIO techniques, when ODP HW is available and works
flawlessly.

> be blacklisted from supporting DAX altogether. In other words this is
> a starting point to incrementally enhance or disable specific drivers,
> but with the assurance that the kernel can always do the safe thing
> when / if the driver is missing a finer grained solution.

Seems reasonable.. I think existing HW will have an easier time adding
invalidate, while new hardware really should implement ODP.

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
