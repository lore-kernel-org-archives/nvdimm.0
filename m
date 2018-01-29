Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 29 Jan 2018 18:33:25 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [LSF/MM TOPIC] Filesystem-DAX, page-pinning, and RDMA
Message-ID: <20180129233324.GC4526@redhat.com>
References: <CAPcyv4gQNM9RbTbRWKnG6Vby_CW9CJ9EZTARsVNi=9cas7ZR2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4gQNM9RbTbRWKnG6Vby_CW9CJ9EZTARsVNi=9cas7ZR2A@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: lsf-pc@lists.linux-foundation.org, Christoph Hellwig <hch@infradead.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-nvdimm@lists.01.org, jgg@mellanox.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 24, 2018 at 07:56:02PM -0800, Dan Williams wrote:
> The get_user_pages_longterm() api was recently added as a stop-gap
> measure to prevent applications from growing dependencies on the
> ability to to pin DAX-mapped filesystem blocks for RDMA indefinitely
> with no ongoing coordination with the filesystem. This 'longterm'
> pinning is also problematic for the non-DAX VMA case where the core-mm
> needs a time bounded way to revoke a pin and manipulate the physical
> pages. While existing RDMA applications have already grown the
> assumption that they can pin page-cache pages indefinitely, the fact
> that we are breaking this assumption for filesystem-dax presents an
> opportunity to deprecate the 'indefinite pin' mechanisms and move to a
> general interface that supports pin revocation.
> 
> While RDMA may grow an explicit Infiniband-verb for this 'memory
> registration with lease' semantic, it seems that this problem is
> bigger than just RDMA. At LSF/MM it would be useful to have a
> discussion between fs, mm, dax, and RDMA folks about addressing this
> problem at the core level.
> 
> Particular people that would be useful to have in attendance are
> Michal Hocko, Christoph Hellwig, and Jason Gunthorpe (cc'd).
> 

Between i would also like to participate, in my view the burden should
be on GUP users, so if hardware is not ODP capable then you should at
least be able to kill the mapping/GUP and force the hardware to redo a
GUP if it get any more transaction on affect umem. Can non ODP hardware
do that ? Or is it out of the question ?

Cheers,
J�r�me

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
