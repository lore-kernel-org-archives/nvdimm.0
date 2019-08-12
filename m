Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 12 Aug 2019 10:28:27 -0700
From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [RFC PATCH v2 16/19] RDMA/uverbs: Add back pointer to system
 file object
Message-ID: <20190812172826.GA19746@iweiny-DESK2.sc.intel.com>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-17-ira.weiny@intel.com>
 <20190812130039.GD24457@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812130039.GD24457@ziepe.ca>
Sender: owner-linux-mm@kvack.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 12, 2019 at 10:00:40AM -0300, Jason Gunthorpe wrote:
> On Fri, Aug 09, 2019 at 03:58:30PM -0700, ira.weiny@intel.com wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > In order for MRs to be tracked against the open verbs context the ufile
> > needs to have a pointer to hand to the GUP code.
> > 
> > No references need to be taken as this should be valid for the lifetime
> > of the context.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> >  drivers/infiniband/core/uverbs.h      | 1 +
> >  drivers/infiniband/core/uverbs_main.c | 1 +
> >  2 files changed, 2 insertions(+)
> > 
> > diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
> > index 1e5aeb39f774..e802ba8c67d6 100644
> > +++ b/drivers/infiniband/core/uverbs.h
> > @@ -163,6 +163,7 @@ struct ib_uverbs_file {
> >  	struct page *disassociate_page;
> >  
> >  	struct xarray		idr;
> > +	struct file             *sys_file; /* backpointer to system file object */
> >  };
> 
> The 'struct file' has a lifetime strictly shorter than the
> ib_uverbs_file, which is kref'd on its own lifetime. Having a back
> pointer like this is confouding as it will be invalid for some of the
> lifetime of the struct.

Ah...  ok.  I really thought it was the other way around.

__fput() should not call ib_uverbs_close() until the last reference on struct
file is released...  What holds references to struct ib_uverbs_file past that?

Perhaps I need to add this (untested)?

diff --git a/drivers/infiniband/core/uverbs_main.c
b/drivers/infiniband/core/uverbs_main.c
index f628f9e4c09f..654e774d9cf2 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -1125,6 +1125,8 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
        list_del_init(&file->list);
        mutex_unlock(&file->device->lists_mutex);
 
+       file->sys_file = NULL;
+
        kref_put(&file->ref, ib_uverbs_release_file);
 
        return 0;
