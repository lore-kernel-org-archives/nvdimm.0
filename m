Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 13 Jun 2019 20:45:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190613234530.GK22901@ziepe.ca>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606104203.GF7433@quack2.suse.cz>
 <20190606220329.GA11698@iweiny-DESK2.sc.intel.com>
 <20190607110426.GB12765@quack2.suse.cz>
 <20190607182534.GC14559@iweiny-DESK2.sc.intel.com>
 <20190608001036.GF14308@dread.disaster.area>
 <20190612123751.GD32656@bombadil.infradead.org>
 <20190613002555.GH14363@dread.disaster.area>
 <20190613152755.GI32656@bombadil.infradead.org>
 <20190613211321.GC32404@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613211321.GC32404@iweiny-DESK2.sc.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-rdma@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 02:13:21PM -0700, Ira Weiny wrote:
> On Thu, Jun 13, 2019 at 08:27:55AM -0700, Matthew Wilcox wrote:
> > On Thu, Jun 13, 2019 at 10:25:55AM +1000, Dave Chinner wrote:
> > > e.g. Process A has an exclusive layout lease on file F. It does an
> > > IO to file F. The filesystem IO path checks that Process A owns the
> > > lease on the file and so skips straight through layout breaking
> > > because it owns the lease and is allowed to modify the layout. It
> > > then takes the inode metadata locks to allocate new space and write
> > > new data.
> > > 
> > > Process B now tries to write to file F. The FS checks whether
> > > Process B owns a layout lease on file F. It doesn't, so then it
> > > tries to break the layout lease so the IO can proceed. The layout
> > > breaking code sees that process A has an exclusive layout lease
> > > granted, and so returns -ETXTBSY to process B - it is not allowed to
> > > break the lease and so the IO fails with -ETXTBSY.
> > 
> > This description doesn't match the behaviour that RDMA wants either.
> > Even if Process A has a lease on the file, an IO from Process A which
> > results in blocks being freed from the file is going to result in the
> > RDMA device being able to write to blocks which are now freed (and
> > potentially reallocated to another file).
> 
> I don't understand why this would not work for RDMA?  As long as the layout
> does not change the page pins can remain in place.

Because process A had a layout lease (and presumably a MR) and the
layout was still modified in way that invalidates the RDMA MR.

Jason
