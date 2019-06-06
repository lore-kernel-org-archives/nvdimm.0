Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 6 Jun 2019 16:51:15 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190606195114.GA30714@ziepe.ca>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606104203.GF7433@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606104203.GF7433@quack2.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: ira.weiny@intel.com, Dan Williams <dan.j.williams@intel.com>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 06, 2019 at 12:42:03PM +0200, Jan Kara wrote:

> So I'd like to actually mandate that you *must* hold the file lease until
> you unpin all pages in the given range (not just that you have an option to
> hold a lease). And I believe the kernel should actually enforce this. That
> way we maintain a sane state that if someone uses a physical location of
> logical file offset on disk, he has a layout lease. Also once this is done,
> sysadmin has a reasonably easy way to discover run-away RDMA application
> and kill it if he wishes so.
> 
> The question is on how to exactly enforce that lease is taken until all
> pages are unpinned. I belive it could be done by tracking number of
> long-term pinned pages within a lease. Gup_longterm could easily increment
> the count when verifying the lease exists, gup_longterm users will somehow
> need to propagate corresponding 'filp' (struct file pointer) to
> put_user_pages_longterm() callsites so that they can look up appropriate
> lease to drop reference - probably I'd just transition all gup_longterm()
> users to a saner API similar to the one we have in mm/frame_vector.c where
> we don't hand out page pointers but an encapsulating structure that does
> all the necessary tracking. Removing a lease would need to block until all
> pins are released - this is probably the most hairy part since we need to
> handle a case if application just closes the file descriptor which
> would

I think if you are going to do this then the 'struct filp' that
represents the lease should be held in the kernel (ie inside the RDMA
umem) until the kernel is done with it.

Actually does someone have a pointer to this userspace lease API, I'm
not at all familiar with it, thanks

And yes, a better output format from GUP would be great..

> Maybe we could block only on explicit lease unlock and just drop the layout
> lease on file close and if there are still pinned pages, send SIGKILL to an
> application as a reminder it did something stupid...

Which process would you SIGKILL? At least for the rdma case a FD is
holding the GUP, so to do the put_user_pages() the kernel needs to
close the FD. I guess it would have to kill every process that has the
FD open? Seems complicated...

Regards,
Jason
