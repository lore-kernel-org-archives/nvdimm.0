Return-Path: <owner-linux-mm@kvack.org>
Date: Sat, 17 Aug 2019 12:26:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH v2 00/19] RDMA/FS DAX truncate proposal V1,000,002 ;-)
Message-ID: <20190817022603.GW6129@dread.disaster.area>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190814101714.GA26273@quack2.suse.cz>
 <20190814180848.GB31490@iweiny-DESK2.sc.intel.com>
 <20190815130558.GF14313@quack2.suse.cz>
 <20190816190528.GB371@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190816190528.GB371@iweiny-DESK2.sc.intel.com>
Content-Transfer-Encoding: quoted-printable
Sender: owner-linux-mm@kvack.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 16, 2019 at 12:05:28PM -0700, Ira Weiny wrote:
> On Thu, Aug 15, 2019 at 03:05:58PM +0200, Jan Kara wrote:
> > On Wed 14-08-19 11:08:49, Ira Weiny wrote:
> > > On Wed, Aug 14, 2019 at 12:17:14PM +0200, Jan Kara wrote:
> 2) Second reason is that I thought I did not have a good way to tell if=
 the
>    lease was actually in use.  What I mean is that letting the lease go=
 should
>    be ok IFF we don't have any pins...  I was thinking that without Joh=
n's code
>    we don't have a way to know if there are any pins...  But that is wr=
ong...
>    All we have to do is check
>=20
> 	!list_empty(file->file_pins)
>=20
> So now with this detail I think you are right, we should be able to hol=
d the
> lease through the struct file even if the process no longer has any
> "references" to it (ie closes and munmaps the file).

I really, really dislike the idea of zombie layout leases. It's a
nasty hack for poor application behaviour. This is a "we allow use
after layout lease release" API, and I think encoding largely
untraceable zombie objects into an API is very poor design.

>From the fcntl man page:

LEASES
	Leases are associated with an open file description (see
	open(2)).  This means that duplicate file descriptors
	(created by, for example, fork(2) or dup(2))  re=E2=80=90 fer  to
	the  same  lease,  and this lease may be modified or
	released using any of these descriptors.  Furthermore, the
	lease is released by either an explicit F_UNLCK operation on
	any of these duplicate file descriptors, or when all such
	file descriptors have been closed.

Leases are associated with *open* file descriptors, not the
lifetime of the struct file in the kernel. If the application closes
the open fds that refer to the lease, then the kernel does not
guarantee, and the application has no right to expect, that the
lease remains active in any way once the application closes all
direct references to the lease.

IOWs, applications using layout leases need to hold the lease fd
open for as long as the want access to the physical file layout. It
is a also a requirement of the layout lease that the holder releases
the resources it holds on the layout before it releases the layout
lease, exclusive lease or not. Closing the fd indicates they do not
need access to the file any more, and so the lease should be
reclaimed at that point.

I'm of a mind to make the last close() on a file block if there's an
active layout lease to prevent processes from zombie-ing layout
leases like this. i.e. you can't close the fd until resources that
pin the lease have been released.

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
