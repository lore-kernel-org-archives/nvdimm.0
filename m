Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 29 Sep 2015 14:19:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] dax: fix deadlock in __dax_fault
Message-ID: <20150929041904.GD27164@dastard>
References: <20150924025225.GT3902@dastard>
 <20150924155029.GA6008@linux.intel.com>
 <20150925025357.GU3902@dastard>
 <20150926031745.GA560@linux.intel.com>
 <20150928005904.GY19114@dastard>
 <CAPcyv4jfT2fvYPGFBgxynNAvJ4KoKX=_TZbpB4ieTQV25mmFkQ@mail.gmail.com>
 <20150928213548.GX3902@dastard>
 <CAPcyv4i2Bu1EsVrVkJpN8LUgoD+H5f+REBiEk-eoF=8xBJpL_g@mail.gmail.com>
 <20150929021807.GB27164@dastard>
 <CAA9_cmf7e+Ggo1UfrNZ_aFDqpT6zmbgM_qscyDSzFUvhRZGpCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmf7e+Ggo1UfrNZ_aFDqpT6zmbgM_qscyDSzFUvhRZGpCQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 28, 2015 at 08:08:13PM -0700, Dan Williams wrote:
> On Mon, Sep 28, 2015 at 7:18 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Sep 28, 2015 at 03:57:29PM -0700, Dan Williams wrote:
> > I'm concerned with making what we have work before we go and change
> > everything. You might want to move really quickly, but without sane
> > filesystem support you can't ship anything worth a damn. There's all
> > sorts of issues here, and introducing struct pages doesn't solve all
> > of them.
> >
> > Let's concentrate on ensuring the basic operation of DAX is robust
> > first - get the page fault vs extent manipulations serialised, sane
> > and scalable before we start changing anything else. If we don't
> > solve these problems, then nothing else we do will be reliable, and
> > the problems exist regardless of whether we are using struct pages
> > or not. Hence these are the critical problems we need to fix before
> > anything else.
> >
> > Once we have these issues sorted out, switching between struct page
> > and pfn should be much simpler because we don't have to worry about
> > different locking strategies to protect against truncate, racing
> > page faults, etc.
> 
> It sounds like you have a page-independent/scalable method in mind for
> solving the truncate protection problem?

In mind? It was added to XFS back in 4.1 by commit 653c60b ("xfs:
introduce mmap/truncate lock").

> I had always thought that
> must require struct page, but if you're happy to carry that solution
> in the filesystem you're not going to see resistance from me.

The page based "truncate serialisation" solution in Linux has always
been a horrible, nasty hack. It only works because we always modify
the inode size before invalidating pages in the page cache. Hence we
can check once we have the page lock to see if the page is beyond
EOF. This EOF update hack avoids the need for a filesystem level
lock to guarantee multi-page truncate invalidation atomicity.

This, however, does not work for operations which require atomic
multi-page invalidation within EOF over multiple long running
operations. The page is not beyond EOF, so we have no way of
determining from the page taht we are racing with an invalidation of
the page. This affects operations such as hole punching, extent 
shifting up/down, swapping extents between different inodes, etc.

These *require* the filesystem to be able to lock out page faults
for the duration of the manipulation operation, as the extent
manipulations may not be done atomically from the perspective of
userspace driven page faults. They *are atomic* from the perspective
of the read/write syscall interfaces thanks to the XFS_IOLOCK_*
locking (usually the i_mutex provides this in other filesystems).

The XFS_MMAPLOCK_[SHARED|EXCL] locking was added to provide this
multi-page invalidation  vs page fault serialisation to XFS. It
works completely independently of any given struct page in the file,
and so does not rely on DAX to use struct page to serialise
correctly.  I've solved this problem in XFS because a generic
solution was not happening. Any filesystem that supports hole
punching and other fallocate-based manipulations needs similar
locking to be safe against page fault based /data corruption/ races
in these operations.

FWIW, direct IO also needs to exclude page faults for proper mmap
coherency, but that's much harder problem to solve because direct IO
takes the mmap_sem below the filesystem, and hence we can't hold any
locks over DIO submission that might be required in a page fault
within get_user_pages()....

> >> I do not think introducing page-back persistent memory sets us back to
> >> square 1.  Instead, given the functionality that is enabled when pages
> >> are present I think it is safe to assume most platforms will arrange
> >> for page backed persistent memory.
> >
> > Sure, but it will take a little time to get there. Moving fast
> > doesn't help us here - it only results in stuff we have to revert or
> > redo in the near future and that means progress is much slower than
> > it should be. Let's solve the DAX problems in the right order - it
> > will make things simpler and faster down the road.
> 
> Sounds workable, although this thread is missing an ext4
> representative so far.  Hopefully ext4 is equally open to solving
> these problems generically without struct page.

It appears to me that none of the ext4 developers have shown any
interest in fixing the problems reported with DAX. Some of those
problems existed before DAX came along (e.g. unwritten extent
conversion issues that can cause data corruption) but I've seen no
interest in fixing them, either.  Hence I'm quite happy to drop ext4
DAX support until an ext4 dev steps up and fixes the issues that
need fixing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
