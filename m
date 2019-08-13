Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 13 Aug 2019 08:48:42 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH v2 16/19] RDMA/uverbs: Add back pointer to system
 file object
Message-ID: <20190813114842.GB29508@ziepe.ca>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-17-ira.weiny@intel.com>
 <20190812130039.GD24457@ziepe.ca>
 <20190812172826.GA19746@iweiny-DESK2.sc.intel.com>
 <20190812175615.GI24457@ziepe.ca>
 <20190812211537.GE20634@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812211537.GE20634@iweiny-DESK2.sc.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 12, 2019 at 02:15:37PM -0700, Ira Weiny wrote:
> On Mon, Aug 12, 2019 at 02:56:15PM -0300, Jason Gunthorpe wrote:
> > On Mon, Aug 12, 2019 at 10:28:27AM -0700, Ira Weiny wrote:
> > > On Mon, Aug 12, 2019 at 10:00:40AM -0300, Jason Gunthorpe wrote:
> > > > On Fri, Aug 09, 2019 at 03:58:30PM -0700, ira.weiny@intel.com wrote:
> > > > > From: Ira Weiny <ira.weiny@intel.com>
> > > > > 
> > > > > In order for MRs to be tracked against the open verbs context the ufile
> > > > > needs to have a pointer to hand to the GUP code.
> > > > > 
> > > > > No references need to be taken as this should be valid for the lifetime
> > > > > of the context.
> > > > > 
> > > > > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > > > >  drivers/infiniband/core/uverbs.h      | 1 +
> > > > >  drivers/infiniband/core/uverbs_main.c | 1 +
> > > > >  2 files changed, 2 insertions(+)
> > > > > 
> > > > > diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
> > > > > index 1e5aeb39f774..e802ba8c67d6 100644
> > > > > +++ b/drivers/infiniband/core/uverbs.h
> > > > > @@ -163,6 +163,7 @@ struct ib_uverbs_file {
> > > > >  	struct page *disassociate_page;
> > > > >  
> > > > >  	struct xarray		idr;
> > > > > +	struct file             *sys_file; /* backpointer to system file object */
> > > > >  };
> > > > 
> > > > The 'struct file' has a lifetime strictly shorter than the
> > > > ib_uverbs_file, which is kref'd on its own lifetime. Having a back
> > > > pointer like this is confouding as it will be invalid for some of the
> > > > lifetime of the struct.
> > > 
> > > Ah...  ok.  I really thought it was the other way around.
> > > 
> > > __fput() should not call ib_uverbs_close() until the last reference on struct
> > > file is released...  What holds references to struct ib_uverbs_file past that?
> > 
> > Child fds hold onto the internal ib_uverbs_file until they are closed
> 
> The FDs hold the struct file, don't they?

Only dups, there are other 'child' FDs we can create

> > Now this has unlocked updates to that data.. you'd need some lock and
> > get not zero pattern
> 
> You can't call "get" here because I'm 99% sure we only get here when struct
> file has no references left...

Nope, like I said the other FDs hold the uverbs_file independent of
the struct file it is related too. 

This is why having a back pointer like this is so ugly, it creates a
reference counting cycle

Jason
