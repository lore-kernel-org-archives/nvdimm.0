Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail03.adl2.internode.on.net (ipmail03.adl2.internode.on.net
 [150.101.137.141])
 by ml01.01.org (Postfix) with ESMTP id 2701821109388
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 16:38:34 -0700 (PDT)
Date: Fri, 31 Aug 2018 09:38:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Snapshot target and DAX-capable devices
Message-ID: <20180830233809.GH1572@dastard>
References: <20180827160744.GE4002@quack2.suse.cz>
 <e38303902267d2d8bae8b0c88da84a4ed668e9fb.camel@hpe.com>
 <20180828075025.GA17756@quack2.suse.cz>
 <20180828175630.GA1197@redhat.com>
 <20180830093028.GC1767@quack2.suse.cz>
 <20180830184907.GA14867@redhat.com>
 <x494lfbabwi.fsf@segfault.boston.devel.redhat.com>
 <alpine.LRH.2.02.1808301545200.30950@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1808301545200.30950@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 30, 2018 at 03:47:32PM -0400, Mikulas Patocka wrote:
> 
> 
> On Thu, 30 Aug 2018, Jeff Moyer wrote:
> 
> > Mike Snitzer <snitzer@redhat.com> writes:
> > 
> > > Until we properly add DAX support to dm-snapshot I'm afraid we really do
> > > need to tolerate this "regression".  Since reality is the original
> > > support for snapshot of a DAX DM device never worked in a robust way.
> > 
> > Agreed.
> > 
> > -Jeff
> 
> You can't support dax on snapshot - if someone maps a block and the block 
> needs to be moved, then what?

This is only a problem for access via mmap and page faults.

At the filesystem level, it's no different to the existing direct IO
algorithm for read/write IO - we simply allocate new space, copy the
data we need to copy into the new space (may be no copy needed), and
then write the new data into the new space. I'm pretty sure that for
bio-based IO to dm-snapshot devices the algorithm will be exactly
the same.

However, for direct access via mmap, we have to modify how the
userspace virtual address is mapped to the physical location. IOWs,
during the COW operation, we have to invalidate all existing user
mappings we have for that physical address. This means we have to do
an invalidation after the allocate/copy part of the COW operation.

If we are doing this during a page fault, it means we'll probably
have to restart the page fault so it can look up the new physical
address associated with the faulting user address. After we've done
the invalidation, any new (or restarted) page fault finds the
location of new copy we just made, maps it into the user address
space, updates the ptes and we're all good.

Well, that's the theory. We haven't implemented this for XFS yet, so
it might end up a little different, and we might yet hit unexpected
problems (it's DAX, that's what happens :/).

It's a whole different ballgame for a dm-snapshot device - block
devices are completely unaware of page faults to DAX file mappings.
We'll need the filesystem to be aware it's on a remappable block
device, and when we take a DAX write fault we'll need to ask the
underlying device to remap the block and treat it like the
filesystem COW case above. We'll need to do this remap/invalidate
dance in the write IO path, too, because a COW by the block device
is no different to filesystem COW in that path.

Basically, it's the same algorithm as the filesystem COW case, we
just get the physical location of the data and the notification of
block changing physical location from a different interface.

Hmmmm. ISTR that someone has been making a few noises recently about
virtual block address space mapping interfaces that could help solve
this problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
