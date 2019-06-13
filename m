Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E38B52127341A
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jun 2019 03:47:48 -0700 (PDT)
Date: Thu, 13 Jun 2019 03:47:43 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190613104743.GH32656@bombadil.infradead.org>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606104203.GF7433@quack2.suse.cz>
 <20190606220329.GA11698@iweiny-DESK2.sc.intel.com>
 <20190607110426.GB12765@quack2.suse.cz>
 <20190607182534.GC14559@iweiny-DESK2.sc.intel.com>
 <20190608001036.GF14308@dread.disaster.area>
 <20190612123751.GD32656@bombadil.infradead.org>
 <20190613002555.GH14363@dread.disaster.area>
 <20190613032320.GG32656@bombadil.infradead.org>
 <20190613043649.GJ14363@dread.disaster.area>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190613043649.GJ14363@dread.disaster.area>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 02:36:49PM +1000, Dave Chinner wrote:
> On Wed, Jun 12, 2019 at 08:23:20PM -0700, Matthew Wilcox wrote:
> > On Thu, Jun 13, 2019 at 10:25:55AM +1000, Dave Chinner wrote:
> > > On Wed, Jun 12, 2019 at 05:37:53AM -0700, Matthew Wilcox wrote:
> > > > That's rather different from the normal meaning of 'exclusive' in the
> > > > context of locks, which is "only one user can have access to this at
> > > > a time".
> > > 
> > > Layout leases are not locks, they are a user access policy object.
> > > It is the process/fd which holds the lease and it's the process/fd
> > > that is granted exclusive access.  This is exactly the same semantic
> > > as O_EXCL provides for granting exclusive access to a block device
> > > via open(), yes?
> > 
> > This isn't my understanding of how RDMA wants this to work, so we should
> > probably clear that up before we get too far down deciding what name to
> > give it.
> > 
> > For the RDMA usage case, it is entirely possible that both process A
> > and process B which don't know about each other want to perform RDMA to
> > file F.  So there will be two layout leases active on this file at the
> > same time.  It's fine for IOs to simultaneously be active to both leases.
> 
> Yes, it is.
> 
> > But if the filesystem wants to move blocks around, it has to break
> > both leases.
> 
> No, the _lease layer_ needs to break both leases when the filesystem
> calls break_layout().

That's a distinction without a difference as far as userspace is
concerned.  If process A asks for an exclusive lease (and gets it),
then process B asks for an exclusive lease (and gets it), that lease
isn't exclusive!  It's shared.

I think the example you give of O_EXCL is more of a historical accident.
It's a relatively recent Linuxism that O_EXCL on a block device means
"this block device is not part of a filesystem", and I don't think
most userspace programmers are aware of what it means when not paired
with O_CREAT.

> > If Process C tries to do a write to file F without a lease, there's no
> > problem, unless a side-effect of the write would be to change the block
> > mapping,
> 
> That's a side effect we cannot predict ahead of time. But it's
> also _completely irrelevant_ to the layout lease layer API and
> implementation.(*)

It's irrelevant to the naming, but you brought it up as part of the
semantics.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
