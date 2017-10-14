Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from quartz.orcorp.ca (quartz.orcorp.ca [184.70.90.242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D349202E5CE2
 for <linux-nvdimm@lists.01.org>; Fri, 13 Oct 2017 18:54:42 -0700 (PDT)
Date: Fri, 13 Oct 2017 19:57:52 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v9 0/6] MAP_DIRECT for DAX userspace flush
Message-ID: <20171014015752.GA25172@obsidianresearch.com>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171012142319.GA11254@lst.de>
 <CAPcyv4gTON__Ohop0B5R2gsKXC71bycTBozqGmF3WmwG9C6LVA@mail.gmail.com>
 <20171013065716.GB26461@lst.de>
 <CAPcyv4gaLBBefOU+8f7_ypYnCTjSMk+9nq8NfCqBHAE+NbUusw@mail.gmail.com>
 <20171013163822.GA17411@obsidianresearch.com>
 <CAPcyv4jDHp8z2VgVfyRK1WwMzixYVQnh54LZoPD57HB3yqSPPQ@mail.gmail.com>
 <20171013173145.GA18702@obsidianresearch.com>
 <CAPcyv4jZJRto1jwmNU--pqH_6dOVMyj=68ZwEjAmmkgX=mRk7w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jZJRto1jwmNU--pqH_6dOVMyj=68ZwEjAmmkgX=mRk7w@mail.gmail.com>
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 13, 2017 at 11:22:21AM -0700, Dan Williams wrote:
> > So, who should be responsible for MR coherency? Today we say the MPI
> > is responsible. But we can't really expect the MPI
> > to hook SIGIO and somehow try to reverse engineer what MRs are
> > impacted from a FD that may not even still be open.
> 
> Ok, that's good insight that I didn't have. Userspace needs more help
> than just an fd notification.

Glad to help!

> > I think, if you want to build a uAPI for notification of MR lease
> > break, then you need show how it fits into the above software model:
> >  - How it can be hidden in a RDMA specific library
> 
> So, here's a strawman can ibv_poll_cq() start returning ibv_wc_status
> == IBV_WC_LOC_PROT_ERR when file coherency is lost. This would make
> the solution generic across DAX and non-DAX. What's you're feeling for
> how well applications are prepared to deal with that status return?

Stuffing an entry into the CQ is difficult. The CQ is in user memory
and it is DMA'd from the HCA for several pieces of hardware, so the
kernel can't just stuff something in there. It can be done
with HW support by having the HCA DMA it via an exception path or
something, but even then, you run into questions like CQ overflow and
accounting issues since it is not ment for this.

So, you need a side channel of some kind, either in certain drivers or
generically..

> >  - How lease break can be done hitlessly, so the library user never
> >    needs to know it is happening or see failed/missed transfers
> 
> iommu redirect should be hit less and behave like the page cache case
> where RDMA targets pages that are no longer part of the file.

Yes, if the iommu can be fenced properly it sounds doable.

> >  - Whatever fast path checking is needed does not kill performance
> 
> What do you consider a fast path? I was assuming that memory
> registration is a slow path, and iommu operations are asynchronous so
> should not impact performance of ongoing operations beyond typical
> iommu overhead.

ibv_poll_cq() and ibv_post_send() would be a fast path.

Where this struggled before is in creating a side channel you also now
have to check that side channel, and checking it at high performance
is quite hard.. Even quiecing things to be able to tear down the MR
has performance implications on post send...

Now that I see this whole thing in this light it seem so very similar
to the MPI driven user space mmu notifications ideas and has similar
challenges. FWIW, RDMA banged its head on this issue for 10 years and
it was ODP that emerged as the solution.

One option might be to use an async event notification 'MR
de-coherence' and rely on a main polling loop to catch it.

This is good enough for dax becaue the lease-requestor would wait
until the async event was processed. It would also be acceptable for
the general MPI case too, but only if this lease concept was wider
than just DAX, eg a MR leases a peice of VMA, and if anything anyhow
changes that VMA (eg munamp, mmap, mremap, etc) then it has to wait
from the MR to release the lease. ie munmap would block until the
async event is processed. ODP-light in userspace, essentially.

IIRC this sort of suggestion was never explored, something like:

poll(fd)
ibv_read_async_event(fd)
if (event == MR_DECOHERENCE) {
    queice_network();
    ibv_restore_mr(mr);
    restore_network();
}

The implemention of ibv_restore_mr would have to make a new MR that
pointed to the same virtual memory addresses, but was backed by the
*new* physical pages. This means it has to unblock the lease, and wait
for the lease requestor to complete executing.

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
