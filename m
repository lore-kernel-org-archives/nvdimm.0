From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: untangle the direct I/O and DAX path, fix DAX locking
Date: Fri, 24 Jun 2016 17:13:18 +1000
Message-ID: <20160624071318.GE12670@dastard>
References: <1466609236-23801-1-git-send-email-hch@lst.de>
 <20160623232446.GA12670@dastard>
 <CAPcyv4iWVyJ3vb+_dtehGRxT9WXwAxNXoDMNeNtxO+=njHNAhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4iWVyJ3vb+_dtehGRxT9WXwAxNXoDMNeNtxO+=njHNAhg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, XFS Developers <xfs@oss.sgi.com>
List-Id: linux-nvdimm@lists.01.org

On Thu, Jun 23, 2016 at 06:14:47PM -0700, Dan Williams wrote:
> On Thu, Jun 23, 2016 at 4:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Jun 22, 2016 at 05:27:08PM +0200, Christoph Hellwig wrote:
> >> The last patch is what started the series:  XFS currently uses the
> >> direct I/O locking strategy for DAX because DAX was overloaded onto
> >> the direct I/O path.  For XFS this means that we only take a shared
> >> inode lock instead of the normal exclusive one for writes IFF they
> >> are properly aligned.  While this is fine for O_DIRECT which requires
> >> explicit opt-in from the application it's not fine for DAX where we'll
> >> suddenly lose expected and required synchronization of the file system
> >> happens to use DAX undeneath.
> >
> > Except we did that *intentionally* - by definition there is no
> > cache to bypass with DAX and so all IO is "direct". That, combined
> > with the fact that all Linux filesystems except XFS break the POSIX
> > exclusive writer rule you are quoting to begin with, it seemed
> > pointless to enforce it for DAX....
> 
> If we're going to be strict about POSIX fsync() semantics we should be
> strict about this exclusive write semantic.  In other words why is it
> ok to loosen one and not the other, if application compatibility is
> the concern?

This is a POSIX compliant fsync() implementation:

int fsync(int fd)
{
	return 0;
}

That's not what we require from Linux filesystems and storage
subsystems.  Our data integrity requirements are not actually
defined by POSIX - we go way beyond what POSIX actually requires us
to implement. If all we cared about is POSIX, then the above is how
we'd implement fsync() simply because it's fast. Everyone implements
fsync differently, so portable applications can't actually rely on
the POSIX standard fsync() implementation to keep their data safe...

IOWs, we don't give a shit about what POSIX says about fsync
because, in practice, it's useless. Instead, we implement something
that *works* and provides users with real data integrity guarantees.

If you like the POSIX specs for data integrity, go use
sync_file_range() - it doesn't guarantee data integrity, just like
posix compliant fsync(). And yes, applications that use
sync_file_range() are known to lose data when systems crash...

The POSIX exclusive write requirement is a different case. No linux
filesystem except XFS has ever met that requirement (in 20 something
years), yet I don't see applications falling over with corrupt data
from non-exclusive writes all the time, nor do I see application
developers shouting at us to provide it. i.e. reality tells us this
isn't a POSIX behaviour that applications rely on because everyone
implements it differently.

So, like fsync(), if everyone implements it differently,
applications don't rely on posix smeantics to serialise access to
overlapping ranges of a file. And if that's the case, then
why even bother exclusive write locking in the filesystem when there
is no need for serialisation of page cache contents?

We don't do it because POSIX says so, because we already ignore what
POSIX says about this topic for technical reasons. So why should we
make DAX conform to POSIX exclusive writer behaviour when DAX is
being specifically aimed at high performance, highly concurrent
applications where exclusive writer behaviour will cause major
performance issues?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
