Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 7 Jun 2019 09:17:29 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190607121729.GA14802@ziepe.ca>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606104203.GF7433@quack2.suse.cz>
 <20190606195114.GA30714@ziepe.ca>
 <20190606222228.GB11698@iweiny-DESK2.sc.intel.com>
 <20190607103636.GA12765@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607103636.GA12765@quack2.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 07, 2019 at 12:36:36PM +0200, Jan Kara wrote:

> Because the pins would be invisible to sysadmin from that point on. 

It is not invisible, it just shows up in a rdma specific kernel
interface. You have to use rdma netlink to see the kernel object
holding this pin.

If this visibility is the main sticking point I suggest just enhancing
the existing MR reporting to include the file info for current GUP
pins and teaching lsof to collect information from there as well so it
is easy to use.

If the ownership of the lease transfers to the MR, and we report that
ownership to userspace in a way lsof can find, then I think all the
concerns that have been raised are met, right?

> ugly to live so we have to come up with something better. The best I can
> currently come up with is to have a method associated with the lease that
> would invalidate the RDMA context that holds the pins in the same way that
> a file close would do it.

This is back to requiring all RDMA HW to have some new behavior they
currently don't have..

The main objection to the current ODP & DAX solution is that very
little HW can actually implement it, having the alternative still
require HW support doesn't seem like progress.

I think we will eventually start seein some HW be able to do this
invalidation, but it won't be universal, and I'd rather leave it
optional, for recovery from truely catastrophic errors (ie my DAX is
on fire, I need to unplug it).

Jason
