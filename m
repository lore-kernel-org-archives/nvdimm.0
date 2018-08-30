Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmailnode02.adl6.internode.on.net
 (ipmailnode02.adl6.internode.on.net [150.101.137.148])
 by ml01.01.org (Postfix) with ESMTP id 4524821109385
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 15:55:58 -0700 (PDT)
Date: Fri, 31 Aug 2018 08:55:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Snapshot target and DAX-capable devices
Message-ID: <20180830225555.GG1572@dastard>
References: <20180827160744.GE4002@quack2.suse.cz>
 <e38303902267d2d8bae8b0c88da84a4ed668e9fb.camel@hpe.com>
 <20180828075025.GA17756@quack2.suse.cz>
 <20180828175630.GA1197@redhat.com>
 <20180830093028.GC1767@quack2.suse.cz>
 <20180830184907.GA14867@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180830184907.GA14867@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 30, 2018 at 02:49:07PM -0400, Mike Snitzer wrote:
> On Thu, Aug 30 2018 at  5:30am -0400,  Jan Kara <jack@suse.cz> wrote:
> > Well, changing device from DAX-capable to DAX-incapable is problematic for
> > filesystem on top of it as well. Filesystems simply don't expect this
> > feature of a device can change so they would fail in unexpected ways. Also
> > PFNs from the pmem (DAX-capable) device that are already mapped to user page
> > tables won't magically become unmapped so those processes will still have
> > DAX access to those areas of the device.
....
> As you point out, how are the upper layers (e.g. filesystems) supposed
> to reliably cope with this runtime switch to from DAX to non-DAX access?

They can't right now. There's unsolved races between page faults,
invalidations and changing the file operations to/from DAX
dynamically. This is the entire problem facing the dynamic per-inode
DAX on/off flag - if it happens globally to the filesystem without
warning, then the filesystem is screwed. 

To support the block device changing between DAX and non-DAX
dynamically, then the filesystem needs to first invalidate the entire
filesystem cache, eject all cached inodes from memory, any cached
metadata that is using DAX, etc to clear out all the DAX mappings
it have. And it has to do it without racing with new page faults or
IO that might map new DAX pages. And I'm ignoring the fact that we
can't eject referenced inodes (i.e. open files) from the inode cache
and so we currently cannot safely change the DAX on such files.
That's a blocker right now.

Once we can safely change the DAX state of open files, we've got to
co=ordinate the block device state change with the filesystem - the
filesystem wide invalidation has to be done before the block device can
start the change of state, and the filesystem must remain completely
stopped until the block device has completed it's change of state.

So AFAICT this ends up being "stop the world instantly, eject the
world from memory, rebuild the world from scratch, start the world
again".  Freezing the filesystem doesn't stop the world - we can
still do read IO and page faults, so that doesn't prevent pagefault
races with the invalidation leaving DAX references in the page
cache. Hence we currently have no valid "stop the world" mechanism
in the kernel other than unmount, which we can't do while there are
open files.

What about MAP_SYNC applications? If we turn off DAX with those
applications still running, we silently break them and users won't
know until the system loses power and they see data corruption after
the system comes back. However, applications SEGVing unpredictably
becuse of "transparent" storage state changes is almost as
unfriendly.

Dynamically changing block device DAX support seems like a
non-starter to me. At least, it's a non starter until we add a lot
more infrastructure, solve a bunch of really hard problems and
define how active userspace controlled DAX-only features behave when
DAX is no longer available...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
