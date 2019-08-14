Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au
 [211.29.132.246])
 by ml01.01.org (Postfix) with ESMTP id 55FC720311204
 for <linux-nvdimm@lists.01.org>; Wed, 14 Aug 2019 04:41:27 -0700 (PDT)
Date: Wed, 14 Aug 2019 21:38:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v2 01/19] fs/locks: Export F_LAYOUT lease to user space
Message-ID: <20190814113810.GJ7777@dread.disaster.area>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-2-ira.weiny@intel.com>
 <20190809235231.GC7777@dread.disaster.area>
 <20190812173626.GB19746@iweiny-DESK2.sc.intel.com>
 <20190814080547.GJ6129@dread.disaster.area>
 <1ba29bfa22f82e6d880ab31c3835047f3353f05a.camel@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1ba29bfa22f82e6d880ab31c3835047f3353f05a.camel@kernel.org>
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
To: Jeff Layton <jlayton@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 14, 2019 at 07:21:34AM -0400, Jeff Layton wrote:
> On Wed, 2019-08-14 at 18:05 +1000, Dave Chinner wrote:
> > On Mon, Aug 12, 2019 at 10:36:26AM -0700, Ira Weiny wrote:
> > > On Sat, Aug 10, 2019 at 09:52:31AM +1000, Dave Chinner wrote:
> > > > On Fri, Aug 09, 2019 at 03:58:15PM -0700, ira.weiny@intel.com wrote:
> > > > > +	/*
> > > > > +	 * NOTE on F_LAYOUT lease
> > > > > +	 *
> > > > > +	 * LAYOUT lease types are taken on files which the user knows that
> > > > > +	 * they will be pinning in memory for some indeterminate amount of
> > > > > +	 * time.
> > > > 
> > > > Indeed, layout leases have nothing to do with pinning of memory.
> > > 
> > > Yep, Fair enough.  I'll rework the comment.
> > > 
> > > > That's something an application taht uses layout leases might do,
> > > > but it largely irrelevant to the functionality layout leases
> > > > provide. What needs to be done here is explain what the layout lease
> > > > API actually guarantees w.r.t. the physical file layout, not what
> > > > some application is going to do with a lease. e.g.
> > > > 
> > > > 	The layout lease F_RDLCK guarantees that the holder will be
> > > > 	notified that the physical file layout is about to be
> > > > 	changed, and that it needs to release any resources it has
> > > > 	over the range of this lease, drop the lease and then
> > > > 	request it again to wait for the kernel to finish whatever
> > > > 	it is doing on that range.
> > > > 
> > > > 	The layout lease F_RDLCK also allows the holder to modify
> > > > 	the physical layout of the file. If an operation from the
> > > > 	lease holder occurs that would modify the layout, that lease
> > > > 	holder does not get notification that a change will occur,
> > > > 	but it will block until all other F_RDLCK leases have been
> > > > 	released by their holders before going ahead.
> > > > 
> > > > 	If there is a F_WRLCK lease held on the file, then a F_RDLCK
> > > > 	holder will fail any operation that may modify the physical
> > > > 	layout of the file. F_WRLCK provides exclusive physical
> > > > 	modification access to the holder, guaranteeing nothing else
> > > > 	will change the layout of the file while it holds the lease.
> > > > 
> > > > 	The F_WRLCK holder can change the physical layout of the
> > > > 	file if it so desires, this will block while F_RDLCK holders
> > > > 	are notified and release their leases before the
> > > > 	modification will take place.
> > > > 
> > > > We need to define the semantics we expose to userspace first.....
> 
> Absolutely.
> 
> > > 
> > > Agreed.  I believe I have implemented the semantics you describe above.  Do I
> > > have your permission to use your verbiage as part of reworking the comment and
> > > commit message?
> > 
> > Of course. :)
> > 
> > Cheers,
> > 
> 
> I'll review this in more detail soon, but subsequent postings of the set
> should probably also go to linux-api mailing list. This is a significant
> API change. It might not also hurt to get the glibc folks involved here
> too since you'll probably want to add the constants to the headers there
> as well.

Sure, but lets first get it to the point where we have something
that is actually workable, much more complete and somewhat validated
with unit tests before we start involving too many people. Wide
review of prototype code isn't really a good use of resources given
how much it's probably going to change from here...

> Finally, consider going ahead and drafting a patch to the fcntl(2)
> manpage if you think you have the API mostly nailed down. This API is a
> little counterintuitive (i.e. you can change the layout with an F_RDLCK
> lease), so it will need to be very clearly documented. I've also found
> that when creating a new API, documenting it tends to help highlight its
> warts and areas where the behavior is not clearly defined.

I find writing unit tests for xfstests to validate the new APIs work
as intended finds far more problems with the API than writing the
documentation. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
