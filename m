Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 36BA6212B5EF9
 for <linux-nvdimm@lists.01.org>; Tue, 13 Aug 2019 10:48:48 -0700 (PDT)
Date: Tue, 13 Aug 2019 10:46:35 -0700
From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [RFC PATCH v2 15/19] mm/gup: Introduce vaddr_pin_pages()
Message-ID: <20190813174635.GC11882@iweiny-DESK2.sc.intel.com>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-16-ira.weiny@intel.com>
 <20190812122814.GC24457@ziepe.ca>
 <20190812214854.GF20634@iweiny-DESK2.sc.intel.com>
 <20190813114706.GA29508@ziepe.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190813114706.GA29508@ziepe.ca>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 13, 2019 at 08:47:06AM -0300, Jason Gunthorpe wrote:
> On Mon, Aug 12, 2019 at 02:48:55PM -0700, Ira Weiny wrote:
> > On Mon, Aug 12, 2019 at 09:28:14AM -0300, Jason Gunthorpe wrote:
> > > On Fri, Aug 09, 2019 at 03:58:29PM -0700, ira.weiny@intel.com wrote:
> > > > From: Ira Weiny <ira.weiny@intel.com>
> > > > 
> > > > The addition of FOLL_LONGTERM has taken on additional meaning for CMA
> > > > pages.
> > > > 
> > > > In addition subsystems such as RDMA require new information to be passed
> > > > to the GUP interface to track file owning information.  As such a simple
> > > > FOLL_LONGTERM flag is no longer sufficient for these users to pin pages.
> > > > 
> > > > Introduce a new GUP like call which takes the newly introduced vaddr_pin
> > > > information.  Failure to pass the vaddr_pin object back to a vaddr_put*
> > > > call will result in a failure if pins were created on files during the
> > > > pin operation.
> > > 
> > > Is this a 'vaddr' in the traditional sense, ie does it work with
> > > something returned by valloc?
> > 
> > ...or malloc in user space, yes.  I think the idea is that it is a user virtual
> > address.
> 
> valloc is a kernel call

Oh...  I thought you meant this: https://linux.die.net/man/3/valloc

> 
> > So I'm open to suggestions.  Jan gave me this one, so I figured it was safer to
> > suggest it...
> 
> Should have the word user in it, imho

Fair enough...

user_addr_pin_pages(void __user * addr, ...) ?

uaddr_pin_pages(void __user * addr, ...) ?

I think I like uaddr...

> 
> > > I also wish GUP like functions took in a 'void __user *' instead of
> > > the unsigned long to make this clear :\
> > 
> > Not a bad idea.  But I only see a couple of call sites who actually use a 'void
> > __user *' to pass into GUP...  :-/
> > 
> > For RDMA the address is _never_ a 'void __user *' AFAICS.
> 
> That is actually a bug, converting from u64 to a 'user VA' needs to go
> through u64_to_user_ptr().

Fair enough.

But there are a lot of call sites throughout the kernel who have the same
bug...  I'm ok with forcing u64_to_user_ptr() to use this new call if others
are.

Ira

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
