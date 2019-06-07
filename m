Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 7 Jun 2019 12:10:15 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190607151015.GJ14802@ziepe.ca>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606104203.GF7433@quack2.suse.cz>
 <20190606195114.GA30714@ziepe.ca>
 <20190606222228.GB11698@iweiny-DESK2.sc.intel.com>
 <20190607103636.GA12765@quack2.suse.cz>
 <20190607121729.GA14802@ziepe.ca>
 <20190607145213.GB14559@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607145213.GB14559@iweiny-DESK2.sc.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 07, 2019 at 07:52:13AM -0700, Ira Weiny wrote:
> On Fri, Jun 07, 2019 at 09:17:29AM -0300, Jason Gunthorpe wrote:
> > On Fri, Jun 07, 2019 at 12:36:36PM +0200, Jan Kara wrote:
> > 
> > > Because the pins would be invisible to sysadmin from that point on. 
> > 
> > It is not invisible, it just shows up in a rdma specific kernel
> > interface. You have to use rdma netlink to see the kernel object
> > holding this pin.
> > 
> > If this visibility is the main sticking point I suggest just enhancing
> > the existing MR reporting to include the file info for current GUP
> > pins and teaching lsof to collect information from there as well so it
> > is easy to use.
> > 
> > If the ownership of the lease transfers to the MR, and we report that
> > ownership to userspace in a way lsof can find, then I think all the
> > concerns that have been raised are met, right?
> 
> I was contemplating some new lsof feature yesterday.  But what I don't think we
> want is sysadmins to have multiple tools for multiple subsystems.  Or even have
> to teach lsof something new for every potential new subsystem user of GUP pins.

Well.. it is a bit tricky, but you'd have to arrange for the lease
object to have a list of 'struct files' that are holding the
lease open. 

The first would be the file that did the fcntl, the next would be all
the files that did longterm GUP - which means longterm GUP has to have
a chardev file/etc as well (seems OK)

Then lsof could query the list of lease objects for each file it
encounters and print them out too.

Jason
