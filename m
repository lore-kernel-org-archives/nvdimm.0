Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 13 Aug 2019 08:47:06 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC PATCH v2 15/19] mm/gup: Introduce vaddr_pin_pages()
Message-ID: <20190813114706.GA29508@ziepe.ca>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-16-ira.weiny@intel.com>
 <20190812122814.GC24457@ziepe.ca>
 <20190812214854.GF20634@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812214854.GF20634@iweiny-DESK2.sc.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 12, 2019 at 02:48:55PM -0700, Ira Weiny wrote:
> On Mon, Aug 12, 2019 at 09:28:14AM -0300, Jason Gunthorpe wrote:
> > On Fri, Aug 09, 2019 at 03:58:29PM -0700, ira.weiny@intel.com wrote:
> > > From: Ira Weiny <ira.weiny@intel.com>
> > > 
> > > The addition of FOLL_LONGTERM has taken on additional meaning for CMA
> > > pages.
> > > 
> > > In addition subsystems such as RDMA require new information to be passed
> > > to the GUP interface to track file owning information.  As such a simple
> > > FOLL_LONGTERM flag is no longer sufficient for these users to pin pages.
> > > 
> > > Introduce a new GUP like call which takes the newly introduced vaddr_pin
> > > information.  Failure to pass the vaddr_pin object back to a vaddr_put*
> > > call will result in a failure if pins were created on files during the
> > > pin operation.
> > 
> > Is this a 'vaddr' in the traditional sense, ie does it work with
> > something returned by valloc?
> 
> ...or malloc in user space, yes.  I think the idea is that it is a user virtual
> address.

valloc is a kernel call

> So I'm open to suggestions.  Jan gave me this one, so I figured it was safer to
> suggest it...

Should have the word user in it, imho

> > I also wish GUP like functions took in a 'void __user *' instead of
> > the unsigned long to make this clear :\
> 
> Not a bad idea.  But I only see a couple of call sites who actually use a 'void
> __user *' to pass into GUP...  :-/
> 
> For RDMA the address is _never_ a 'void __user *' AFAICS.

That is actually a bug, converting from u64 to a 'user VA' needs to go
through u64_to_user_ptr().

Jason
