Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 7 Jun 2019 08:28:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190606222853.GD14308@dread.disaster.area>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606104203.GF7433@quack2.suse.cz>
 <20190606220329.GA11698@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606220329.GA11698@iweiny-DESK2.sc.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 06, 2019 at 03:03:30PM -0700, Ira Weiny wrote:
> On Thu, Jun 06, 2019 at 12:42:03PM +0200, Jan Kara wrote:
> > On Wed 05-06-19 18:45:33, ira.weiny@intel.com wrote:
> > So I'd like to actually mandate that you *must* hold the file lease until
> > you unpin all pages in the given range (not just that you have an option to
> > hold a lease). And I believe the kernel should actually enforce this. That
> > way we maintain a sane state that if someone uses a physical location of
> > logical file offset on disk, he has a layout lease. Also once this is done,
> > sysadmin has a reasonably easy way to discover run-away RDMA application
> > and kill it if he wishes so.
> 
> Fair enough.
> 
> I was kind of heading that direction but had not thought this far forward.  I
> was exploring how to have a lease remain on the file even after a "lease
> break".  But that is incompatible with the current semantics of a "layout"
> lease (as currently defined in the kernel).  [In the end I wanted to get an RFC
> out to see what people think of this idea so I did not look at keeping the
> lease.]
> 
> Also hitch is that currently a lease is forcefully broken after
> <sysfs>/lease-break-time.  To do what you suggest I think we would need a new
> lease type with the semantics you describe.

That just requires a flag when gaining the layout lease to say it is
an "unbreakable layout lease". That gives the kernel the information
needed to determine whether it should attempt to break the lease on
truncate or just return ETXTBSY....

i.e. it allows gup-pinning applications that want to behave nicely
with other users to drop their gup pins and release the lease when
something else wants to truncate/hole punch the file rather than
have truncate return an error. e.g. to allow apps to cleanly interop
with other breakable layout leases (e.g. pNFS) on the same
filesystem.

FWIW, I'd also like to see the "truncate fails when unbreakable
layout lease is held" behaviour to be common across all
filesystem/storage types, not be confined to DAX only. i.e. truncate
should return ETXTBSY when an unbreakable layout lease is held
by an application, not just when "DAX+gup-pinned" is triggered....

Whatever we decide, the behaviour of truncate et al needs to be
predictable, consistent and easily discoverable...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
