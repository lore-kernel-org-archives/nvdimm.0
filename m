Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 1 Feb 2018 16:27:20 -0700
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [LSF/MM TOPIC] Filesystem-DAX, page-pinning, and RDMA
Message-ID: <20180201232720.GX23352@mellanox.com>
References: <CAPcyv4gQNM9RbTbRWKnG6Vby_CW9CJ9EZTARsVNi=9cas7ZR2A@mail.gmail.com>
 <20180129233324.GC4526@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180129233324.GC4526@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, lsf-pc@lists.linux-foundation.org, Christoph Hellwig <hch@infradead.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 29, 2018 at 06:33:25PM -0500, Jerome Glisse wrote:

> Between i would also like to participate, in my view the burden should
> be on GUP users, so if hardware is not ODP capable then you should at
> least be able to kill the mapping/GUP and force the hardware to redo a
> GUP if it get any more transaction on affect umem. Can non ODP hardware
> do that ? Or is it out of the question ?

For RDMA we can have the HW forcibly tear down the MR, but it is
incredibly disruptive and nobody running applications would be happy
with this outcome.

Jason

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
