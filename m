Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 14 Aug 2019 15:15:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH v2 16/19] RDMA/uverbs: Add back pointer to system
 file object
Message-ID: <20190814181529.GD13770@ziepe.ca>
References: <20190812130039.GD24457@ziepe.ca>
 <20190812172826.GA19746@iweiny-DESK2.sc.intel.com>
 <20190812175615.GI24457@ziepe.ca>
 <20190812211537.GE20634@iweiny-DESK2.sc.intel.com>
 <20190813114842.GB29508@ziepe.ca>
 <20190813174142.GB11882@iweiny-DESK2.sc.intel.com>
 <20190813180022.GF29508@ziepe.ca>
 <20190813203858.GA12695@iweiny-DESK2.sc.intel.com>
 <20190814122308.GB13770@ziepe.ca>
 <20190814175045.GA31490@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814175045.GA31490@iweiny-DESK2.sc.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 14, 2019 at 10:50:45AM -0700, Ira Weiny wrote:
> On Wed, Aug 14, 2019 at 09:23:08AM -0300, Jason Gunthorpe wrote:
> > On Tue, Aug 13, 2019 at 01:38:59PM -0700, Ira Weiny wrote:
> > > On Tue, Aug 13, 2019 at 03:00:22PM -0300, Jason Gunthorpe wrote:
> > > > On Tue, Aug 13, 2019 at 10:41:42AM -0700, Ira Weiny wrote:
> > > > 
> > > > > And I was pretty sure uverbs_destroy_ufile_hw() would take care of (or ensure
> > > > > that some other thread is) destroying all the MR's we have associated with this
> > > > > FD.
> > > > 
> > > > fd's can't be revoked, so destroy_ufile_hw() can't touch them. It
> > > > deletes any underlying HW resources, but the FD persists.
> > > 
> > > I misspoke.  I should have said associated with this "context".  And of course
> > > uverbs_destroy_ufile_hw() does not touch the FD.  What I mean is that the
> > > struct file which had file_pins hanging off of it would be getting its file
> > > pins destroyed by uverbs_destroy_ufile_hw().  Therefore we don't need the FD
> > > after uverbs_destroy_ufile_hw() is done.
> > > 
> > > But since it does not block it may be that the struct file is gone before the
> > > MR is actually destroyed.  Which means I think the GUP code would blow up in
> > > that case...  :-(
> > 
> > Oh, yes, that is true, you also can't rely on the struct file living
> > longer than the HW objects either, that isn't how the lifetime model
> > works.
> > 
> > If GUP consumes the struct file it must allow the struct file to be
> > deleted before the GUP pin is released.
> 
> I may have to think about this a bit.  But I'm starting to lean toward my
> callback method as a solution...
> 
> > 
> > > The drivers could provide some generic object (in RDMA this could be the
> > > uverbs_attr_bundle) which represents their "context".
> > 
> > For RDMA the obvious context is the struct ib_mr *
> 
> Not really, but maybe.  See below regarding tracking this across processes.
> 
> > 
> > > But for the procfs interface, that context then needs to be associated with any
> > > file which points to it...  For RDMA, or any other "FD based pin mechanism", it
> > > would be up to the driver to "install" a procfs handler into any struct file
> > > which _may_ point to this context.  (before _or_ after memory pins).
> > 
> > Is this all just for debugging? Seems like a lot of complication just
> > to print a string
> 
> No, this is a requirement to allow an admin to determine why their truncates
> may be failing.  As per our discussion here:
> 
> https://lkml.org/lkml/2019/6/7/982

visibility/debugging..

I don't see any solution here with the struct file - we apparently
have a problem with deadlock if the uverbs close() waits as mmput()
can trigger a call close() - see the comment on top of
uverbs_destroy_ufile_hw()

However, I wonder if that is now old information since commit
4a9d4b024a31 ("switch fput to task_work_add") makes fput deferred, so
mmdrop() should not drop waiting on fput??

If you could unwrap this mystery, probably with some testing proof,
then we could make uverbs_destroy_ufile_hw() a fence even for close
and your task is much simpler.

The general flow to trigger is to have a process that has mmap'd
something from the uverbs fd, then trigger both device disassociate
and process exit with just the right race so that the process has
exited enough that the mmdrop on the disassociate threda does the
final cleanup triggering the VMAs inside the mm to do the final fput
on their FDs, triggering final fput() for uverbs inside the thread of
disassociate.

Jason
