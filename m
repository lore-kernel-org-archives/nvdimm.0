Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 13 Jun 2019 12:12:18 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190613151218.GB22901@ziepe.ca>
References: <20190606222228.GB11698@iweiny-DESK2.sc.intel.com>
 <20190607103636.GA12765@quack2.suse.cz>
 <20190607121729.GA14802@ziepe.ca>
 <20190607145213.GB14559@iweiny-DESK2.sc.intel.com>
 <20190612102917.GB14578@quack2.suse.cz>
 <20190612114721.GB3876@ziepe.ca>
 <20190612120907.GC14578@quack2.suse.cz>
 <20190612191421.GM3876@ziepe.ca>
 <20190612221336.GA27080@iweiny-DESK2.sc.intel.com>
 <CAPcyv4gkksnceCV-p70hkxAyEPJWFvpMezJA1rEj6TEhKAJ7qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gkksnceCV-p70hkxAyEPJWFvpMezJA1rEj6TEhKAJ7qQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 12, 2019 at 03:54:19PM -0700, Dan Williams wrote:
> > > My preference would be to avoid this scenario, but if it is really
> > > necessary, we could probably build it with some work.
> > >
> > > The only case we use it today is forced HW hot unplug, so it is rarely
> > > used and only for an 'emergency' like use case.
> >
> > I'd really like to avoid this as well.  I think it will be very confusing for
> > RDMA apps to have their context suddenly be invalid.  I think if we have a way
> > for admins to ID who is pinning a file the admin can take more appropriate
> > action on those processes.   Up to and including killing the process.
> 
> Can RDMA context invalidation, "device disassociate", be inflicted on
> a process from the outside? 

Yes, but it is currently only applied to the entire device - ie you do
'rmmod mlx5_ib' and all the running user space process see that their
FD has moved to some error and the device is broken.

Targetting the disassociate of only a single FD would be a new thing.

Jason
