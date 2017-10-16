Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 16 Oct 2017 09:26:44 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v9 0/6] MAP_DIRECT for DAX userspace flush
Message-ID: <20171016072644.GB28270@lst.de>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com> <20171012142319.GA11254@lst.de> <CAPcyv4gTON__Ohop0B5R2gsKXC71bycTBozqGmF3WmwG9C6LVA@mail.gmail.com> <20171013065716.GB26461@lst.de> <CAPcyv4gaLBBefOU+8f7_ypYnCTjSMk+9nq8NfCqBHAE+NbUusw@mail.gmail.com> <20171013163822.GA17411@obsidianresearch.com> <CAPcyv4jDHp8z2VgVfyRK1WwMzixYVQnh54LZoPD57HB3yqSPPQ@mail.gmail.com> <20171013173145.GA18702@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171013173145.GA18702@obsidianresearch.com>
Sender: owner-linux-mm@kvack.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 13, 2017 at 11:31:45AM -0600, Jason Gunthorpe wrote:
> I don't think that really represents how lots of apps actually use
> RDMA.
> 
> RDMA is often buried down in the software stack (eg in a MPI), and by
> the time a mapping gets used for RDMA transfer the link between the
> FD, mmap and the MR is totally opaque.
> 
> Having a MR specific notification means the low level RDMA libraries
> have a chance to deal with everything for the app.
> 
> Eg consider a HPC app using MPI that uses some DAX aware library to
> get DAX backed mmap's. It then passes memory in those mmaps to the
> MPI library to do transfers. The MPI creates the MR on demand.
> 

I suspect one of the more interesting use cases might be a file server,
for which that's not the case.  But otherwise I agree with the above,
and also thing that notifying the MR handle is the only way to go for
another very important reason:  fencing.  What if the application/library
does not react on the notification?  With a per-MR notification we
can unregister the MR in kernel space and have a rock solid fencing
mechanism.  And that is the most important bit here.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
