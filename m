Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 27 Oct 2015 09:19:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] block: enable dax for raw block devices
Message-ID: <20151026221930.GL19199@dastard>
References: <20151022064142.12700.11849.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151022064211.12700.77105.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20151022093549.GE14445@quack.suse.cz>
 <1445529945.17208.4.camel@intel.com>
 <20151022210818.GC8670@quack.suse.cz>
 <20151025212247.GI19199@dastard>
 <CAPcyv4hjGYYPRyPjZc3CymmnSObB7mULRbeMZFjnKdoCD_m7pw@mail.gmail.com>
 <20151026062319.GJ19199@dastard>
 <CAPcyv4iaKDYuP6ppAVk5UOhzmOEO4Q=N_+osB2D+aPoAzpeHvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iaKDYuP6ppAVk5UOhzmOEO4Q=N_+osB2D+aPoAzpeHvw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "willy@linux.intel.com" <willy@linux.intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 26, 2015 at 05:56:30PM +0900, Dan Williams wrote:
> On Mon, Oct 26, 2015 at 3:23 PM, Dave Chinner <david@fromorbit.com> wrote:
> > Also, DAX access isn't a property of mmap - it's a property
> > of the inode. We cannot do DAX access via mmap while mixing page
> > cache based access through file descriptor based interfaces. This
> > I why I'm adding an inode attribute (on disk) to enable per-file DAX
> > capabilities - either everything is via the DAX paths, or nothing
> > is.
> >
> 
> Per-inode control sounds very useful, I'll look at a similar mechanism
> for the raw block case.
> 
> However, still not quite convinced page-cache control is an inode-only
> property, especially when direct-i/o is not an inode-property.  That
> said, I agree the complexity of handling mixed mappings of the same
> file is prohibitive.

We didn't get that choice with direct IO - support via O_DIRECT was
kinda inherited from other OS's(*). We still have all sorts of
coherency problems between buffered/mmap/direct IO on the same file,
and I'd really, really like to avoid making that same mistake again
with DAX.

i.e. We have a choice with DAX right now that will allow us to avoid
coherency problems that we know existi and can't solve right now.
Making DAX and inode property rather than a application context
property avoids those coherence problems as all access will play by
the same rules....

(*)That said, some other OS's did O_DIRECT as an inode property (e.g.
solaris) where O_DIRECT was only done if no other cached operations
were required (e.g. mmap), and so the fd would transparently shift
between buffered and O_DIRECT depending on external accesses to the
inode. This was not liked because of it's unpredictable effect on
CPU usage and IO latency....

> Sounds good, get blkdev_issue_flush() functional first and then worry
> about building a more efficient solution on top.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
