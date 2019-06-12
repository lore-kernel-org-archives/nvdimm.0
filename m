Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 12 Jun 2019 08:47:21 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190612114721.GB3876@ziepe.ca>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606104203.GF7433@quack2.suse.cz>
 <20190606195114.GA30714@ziepe.ca>
 <20190606222228.GB11698@iweiny-DESK2.sc.intel.com>
 <20190607103636.GA12765@quack2.suse.cz>
 <20190607121729.GA14802@ziepe.ca>
 <20190607145213.GB14559@iweiny-DESK2.sc.intel.com>
 <20190612102917.GB14578@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612102917.GB14578@quack2.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 12, 2019 at 12:29:17PM +0200, Jan Kara wrote:

> > > The main objection to the current ODP & DAX solution is that very
> > > little HW can actually implement it, having the alternative still
> > > require HW support doesn't seem like progress.
> > > 
> > > I think we will eventually start seein some HW be able to do this
> > > invalidation, but it won't be universal, and I'd rather leave it
> > > optional, for recovery from truely catastrophic errors (ie my DAX is
> > > on fire, I need to unplug it).
> > 
> > Agreed.  I think software wise there is not much some of the devices can do
> > with such an "invalidate".
> 
> So out of curiosity: What does RDMA driver do when userspace just closes
> the file pointing to RDMA object? It has to handle that somehow by aborting
> everything that's going on... And I wanted similar behavior here.

It aborts *everything* connected to that file descriptor. Destroying
everything avoids creating inconsistencies that destroying a subset
would create.

What has been talked about for lease break is not destroying anything
but very selectively saying that one memory region linked to the GUP
is no longer functional.

Jason
