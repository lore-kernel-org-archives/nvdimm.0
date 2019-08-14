Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au
 [211.29.132.249])
 by ml01.01.org (Postfix) with ESMTP id 5D39320311205
 for <linux-nvdimm@lists.01.org>; Wed, 14 Aug 2019 01:09:02 -0700 (PDT)
Date: Wed, 14 Aug 2019 18:05:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v2 01/19] fs/locks: Export F_LAYOUT lease to user space
Message-ID: <20190814080547.GJ6129@dread.disaster.area>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-2-ira.weiny@intel.com>
 <20190809235231.GC7777@dread.disaster.area>
 <20190812173626.GB19746@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190812173626.GB19746@iweiny-DESK2.sc.intel.com>
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
To: Ira Weiny <ira.weiny@intel.com>
Cc: Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 12, 2019 at 10:36:26AM -0700, Ira Weiny wrote:
> On Sat, Aug 10, 2019 at 09:52:31AM +1000, Dave Chinner wrote:
> > On Fri, Aug 09, 2019 at 03:58:15PM -0700, ira.weiny@intel.com wrote:
> > > +	/*
> > > +	 * NOTE on F_LAYOUT lease
> > > +	 *
> > > +	 * LAYOUT lease types are taken on files which the user knows that
> > > +	 * they will be pinning in memory for some indeterminate amount of
> > > +	 * time.
> > 
> > Indeed, layout leases have nothing to do with pinning of memory.
> 
> Yep, Fair enough.  I'll rework the comment.
> 
> > That's something an application taht uses layout leases might do,
> > but it largely irrelevant to the functionality layout leases
> > provide. What needs to be done here is explain what the layout lease
> > API actually guarantees w.r.t. the physical file layout, not what
> > some application is going to do with a lease. e.g.
> > 
> > 	The layout lease F_RDLCK guarantees that the holder will be
> > 	notified that the physical file layout is about to be
> > 	changed, and that it needs to release any resources it has
> > 	over the range of this lease, drop the lease and then
> > 	request it again to wait for the kernel to finish whatever
> > 	it is doing on that range.
> > 
> > 	The layout lease F_RDLCK also allows the holder to modify
> > 	the physical layout of the file. If an operation from the
> > 	lease holder occurs that would modify the layout, that lease
> > 	holder does not get notification that a change will occur,
> > 	but it will block until all other F_RDLCK leases have been
> > 	released by their holders before going ahead.
> > 
> > 	If there is a F_WRLCK lease held on the file, then a F_RDLCK
> > 	holder will fail any operation that may modify the physical
> > 	layout of the file. F_WRLCK provides exclusive physical
> > 	modification access to the holder, guaranteeing nothing else
> > 	will change the layout of the file while it holds the lease.
> > 
> > 	The F_WRLCK holder can change the physical layout of the
> > 	file if it so desires, this will block while F_RDLCK holders
> > 	are notified and release their leases before the
> > 	modification will take place.
> > 
> > We need to define the semantics we expose to userspace first.....
> 
> Agreed.  I believe I have implemented the semantics you describe above.  Do I
> have your permission to use your verbiage as part of reworking the comment and
> commit message?

Of course. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
