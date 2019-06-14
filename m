Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 14 Jun 2019 13:42:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190614034230.GP14363@dread.disaster.area>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606104203.GF7433@quack2.suse.cz>
 <20190606220329.GA11698@iweiny-DESK2.sc.intel.com>
 <20190607110426.GB12765@quack2.suse.cz>
 <20190607182534.GC14559@iweiny-DESK2.sc.intel.com>
 <20190608001036.GF14308@dread.disaster.area>
 <20190612123751.GD32656@bombadil.infradead.org>
 <20190612233024.GD14336@iweiny-DESK2.sc.intel.com>
 <20190613005552.GI14363@dread.disaster.area>
 <20190613203406.GB32404@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613203406.GB32404@iweiny-DESK2.sc.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 01:34:06PM -0700, Ira Weiny wrote:
> On Thu, Jun 13, 2019 at 10:55:52AM +1000, Dave Chinner wrote:
> > On Wed, Jun 12, 2019 at 04:30:24PM -0700, Ira Weiny wrote:
> > > On Wed, Jun 12, 2019 at 05:37:53AM -0700, Matthew Wilcox wrote:
> > > > On Sat, Jun 08, 2019 at 10:10:36AM +1000, Dave Chinner wrote:
> > > > > On Fri, Jun 07, 2019 at 11:25:35AM -0700, Ira Weiny wrote:
> > > > > > Are you suggesting that we have something like this from user space?
> > > > > > 
> > > > > > 	fcntl(fd, F_SETLEASE, F_LAYOUT | F_UNBREAKABLE);
> > > > > 
> > > > > Rather than "unbreakable", perhaps a clearer description of the
> > > > > policy it entails is "exclusive"?
> > > > > 
> > > > > i.e. what we are talking about here is an exclusive lease that
> > > > > prevents other processes from changing the layout. i.e. the
> > > > > mechanism used to guarantee a lease is exclusive is that the layout
> > > > > becomes "unbreakable" at the filesystem level, but the policy we are
> > > > > actually presenting to uses is "exclusive access"...
> > > > 
> > > > That's rather different from the normal meaning of 'exclusive' in the
> > > > context of locks, which is "only one user can have access to this at
> > > > a time".  As I understand it, this is rather more like a 'shared' or
> > > > 'read' lock.  The filesystem would be the one which wants an exclusive
> > > > lock, so it can modify the mapping of logical to physical blocks.
> > > > 
> > > > The complication being that by default the filesystem has an exclusive
> > > > lock on the mapping, and what we're trying to add is the ability for
> > > > readers to ask the filesystem to give up its exclusive lock.
> > > 
> > > This is an interesting view...
> > > 
> > > And after some more thought, exclusive does not seem like a good name for this
> > > because technically F_WRLCK _is_ an exclusive lease...
> > > 
> > > In addition, the user does not need to take the "exclusive" write lease to be
> > > notified of (broken by) an unexpected truncate.  A "read" lease is broken by
> > > truncate.  (And "write" leases really don't do anything different WRT the
> > > interaction of the FS and the user app.  Write leases control "exclusive"
> > > access between other file descriptors.)
> > 
> > I've been assuming that there is only one type of layout lease -
> > there is no use case I've heard of for read/write layout leases, and
> > like you say there is zero difference in behaviour at the filesystem
> > level - they all have to be broken to allow a non-lease truncate to
> > proceed.
> > 
> > IMO, taking a "read lease" to be able to modify and write to the
> > underlying mapping of a file makes absolutely no sense at all.
> > IOWs, we're talking exaclty about a revokable layout lease vs an
> > exclusive layout lease here, and so read/write really doesn't match
> > the policy or semantics we are trying to provide.
> 
> I humbly disagree, at least depending on how you look at it...  :-D
> 
> The patches as they stand expect the user to take a "read" layout lease which
> indicates they are currently using "reading" the layout as is.
> They are not
> changing ("writing" to) the layout.

As I said in a another email in the thread, a layout lease does not
make the layout "read only". It just means the lease owner will be
notified when someone else is about to modify it. The lease owner
can modify the mapping themselves, and they will not get notified
about their own modifications.

> They then pin pages which locks parts of
> the layout and therefore they expect no "writers" to change the layout.

Except they can change the layout themselves. It's perfectly valid
to get a layout lease, write() from offset 0 to EOF and fsync() to
intiialise the file and allocate all the space in the file, then
mmap() it and hand to off to RMDA, all while holding the layout
lease.

> The "write" layout lease breaks the "read" layout lease indicating that the
> layout is being written to.

Layout leases do not work this way.

> In fact, this is what NFS does right now.  The lease it puts on the file is of
> "read" type.
> 
> nfs4layouts.c:
> static int
> nfsd4_layout_setlease(struct nfs4_layout_stateid *ls)
> {
> ...
>         fl->fl_flags = FL_LAYOUT;
>         fl->fl_type = F_RDLCK;
> ...
> }

Yes, the existing /implementation/ uses F_RDLCK, but that doesn't
mean the layout is "read only". Look at the pNFS mapping layout code
- the ->map_blocks export operation:

       int (*map_blocks)(struct inode *inode, loff_t offset,
                          u64 len, struct iomap *iomap,
                          bool write, u32 *device_generation);
                          ^^^^^^^^^^

Yup, it has a write variable that, when set, causes the filesystem
to _allocate_ blocks if the range to be written to falls over a hole
in the file.  IOWs, a pNFS layout lease can modify the file layout -
you're conflating use of a "read lock" API to mean that what the
lease _manages_ is "read only". That is not correct.

Layouts are /always writeable/ by the lease owner(s), the question
here is what we do with third parties attempting to modify a layout
covered by an "exclusive" layout lease. Hence, I'll repeat:

> > we're talking exaclty about a revokable layout lease vs an
> > exclusive layout lease here, and so read/write really doesn't match
> > the policy or semantics we are trying to provide.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
