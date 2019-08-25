Return-Path: <owner-linux-mm@kvack.org>
Date: Sun, 25 Aug 2019 16:39:00 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH v2 00/19] RDMA/FS DAX truncate proposal V1,000,002 ;-)
Message-ID: <20190825193900.GA21239@ziepe.ca>
References: <20190820011210.GP7777@dread.disaster.area>
 <20190820115515.GA29246@ziepe.ca>
 <20190821180200.GA5965@iweiny-DESK2.sc.intel.com>
 <20190821181343.GH8653@ziepe.ca>
 <20190821185703.GB5965@iweiny-DESK2.sc.intel.com>
 <20190821194810.GI8653@ziepe.ca>
 <20190821204421.GE5965@iweiny-DESK2.sc.intel.com>
 <20190823032345.GG1119@dread.disaster.area>
 <20190823120428.GA12968@ziepe.ca>
 <20190824001124.GI1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190824001124.GI1119@dread.disaster.area>
Sender: owner-linux-mm@kvack.org
To: Dave Chinner <david@fromorbit.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Aug 24, 2019 at 10:11:24AM +1000, Dave Chinner wrote:
> On Fri, Aug 23, 2019 at 09:04:29AM -0300, Jason Gunthorpe wrote:
> > On Fri, Aug 23, 2019 at 01:23:45PM +1000, Dave Chinner wrote:
> > 
> > > > But the fact that RDMA, and potentially others, can "pass the
> > > > pins" to other processes is something I spent a lot of time trying to work out.
> > > 
> > > There's nothing in file layout lease architecture that says you
> > > can't "pass the pins" to another process.  All the file layout lease
> > > requirements say is that if you are going to pass a resource for
> > > which the layout lease guarantees access for to another process,
> > > then the destination process already have a valid, active layout
> > > lease that covers the range of the pins being passed to it via the
> > > RDMA handle.
> > 
> > How would the kernel detect and enforce this? There are many ways to
> > pass a FD.
> 
> AFAIC, that's not really a kernel problem. It's more of an
> application design constraint than anything else. i.e. if the app
> passes the IB context to another process without a lease, then the
> original process is still responsible for recalling the lease and
> has to tell that other process to release the IB handle and it's
> resources.

It is a kernel problem, the MR exists and is doing DMA. That relies on
the lease to prevent data corruption.

The sanest outcome I could suggest is that when the kernel detects the
MR has outlived the lease it needs then we forcibly abort the entire
RDMA state. Ie the application has malfunctioned and gets wacked with
a very big hammer.

> That still doesn't work. Leases are not individually trackable or
> reference counted objects objects - they are attached to a struct
> file bUt, in reality, they are far more restricted than a struct
> file.

This is the problem. How to link something that is not refcounted to
the refcounted world of file descriptors does not seem very obvious.

There are too many places where struct file relies on its refcounting
to try to and plug them.

Jason
