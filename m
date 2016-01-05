Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 6 Jan 2016 09:32:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [resend PATCH 1/3] block, fs: reliably communicate bdev
 end-of-life
Message-ID: <20160105223236.GD21461@dastard>
References: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160104182005.24118.50361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160105035147.GJ19802@dastard>
 <CAPcyv4i=5-e6mobC5yu1SgESBNgCeqU5jwbaxhN8ZmNW+xUnJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4i=5-e6mobC5yu1SgESBNgCeqU5jwbaxhN8ZmNW+xUnJA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: XFS Developers <xfs@oss.sgi.com>, linux-block@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 04, 2016 at 08:25:16PM -0800, Dan Williams wrote:
> On Mon, Jan 4, 2016 at 7:51 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Jan 04, 2016 at 10:20:05AM -0800, Dan Williams wrote:
> >> Historically we have waited for filesystem specific heuristics to
> >> attempt to guess when a block device is gone.  Sometimes this works, but
> >> in other cases the system can hang waiting for the fs to trigger its
> >> shutdown protocol.
....
> True, and following this logic I think the existing
> generic_shutdown_super() should be renamed generic_kill_super() to
> match the fs actions, but see below...
> 
> > Operation methods should be named after what they do, not what their
> > calling context is. i.e. these are "invalidate" and "shutdown"
> > superblock operations, not "quiesce" and "bdi_gone".
> 
> I was running out of colors to paint the bike shed given
> generic_shutdown_super() was already in use.  Also, since

Ah, yeah, i forgot about that function. To many different shades of
purple are already in use. :/

> >> +void shutdown_partition(struct gendisk *disk, int partno)
> >> +{
> >> +     struct block_device *bdev = bdget_disk(disk, partno);
> >> +     struct super_block *sb = get_super(bdev);
> >> +
> >> +     if (!bdev)
> >> +             return;
> >
> > Null pointer deref. Certainly a landmine waiting for someone to
> > tread on.
> >
> 
> Nope, get_super() checks for a NULL argument.

Hence my comment about it being a landmine. If get_super() is ever
changed, this code will explode on us when we least expect it. If I
have to go read other code in a completely different file just to
determine the code is actually safe, then I consider that bad code.
Code that is slightly more verbose but is obviously correct and
balanced is much, much easier to understand and maintain....

> >> +     if (!sb) {
> >> +             bdput(bdev);
> >> +             return;
> >> +     }
> >> +
> >> +     if (sb->s_op->bdi_gone)
> >> +             sb->s_op->bdi_gone(sb);
> >> +     else
> >> +             generic_bdi_gone(sb);
> >
> >         if (sb->s_op->shutdown)
> >                 sb->s_op->shutdown(sb);
> >         else
> >                 unmap_dax_inodes(sb);
> >
> > name things correctly, and the code documents itself.
> 
> How about 'stop' or 'halt' instead of 'shutdown' to preserve the
> historical meaning of generic_shutdown_super?

It's hard chosing a different color that is appropriate. :/

Because it's a brute-force behavioural override, I think that needs
to be obvious from the op name. So something like force_stop or
force_failure seems best to me.

In fact, now that I've thought/repaeated/written force_failure a
couple of times, it seems quite appropriate here, as what we want to
be able to do is force the filesystem into a (permanent) failure
state.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
