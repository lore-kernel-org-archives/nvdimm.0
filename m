Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
 [150.101.137.141]) by ml01.01.org (Postfix) with ESMTP id 99AE61A1E0E
 for <linux-nvdimm@lists.01.org>; Sun, 31 Jul 2016 21:07:40 -0700 (PDT)
Date: Mon, 1 Aug 2016 14:07:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160801040737.GJ16044@dastard>
References: <20160727120745.GI6860@quack2.suse.cz>
 <20160727211039.GA20278@linux.intel.com>
 <20160727221949.GU16044@dastard>
 <20160728081033.GC4094@quack2.suse.cz>
 <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard>
 <CAPcyv4gLTkx4ne7pWuMSqfFpLoOBx=TowvcWXw9UGUxn=jd-Tg@mail.gmail.com>
 <20160801014645.GI16044@dastard> <86k2g15gh8.fsf@hiro.keithp.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86k2g15gh8.fsf@hiro.keithp.com>
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
To: Keith Packard <keithp@keithp.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, XFS Developers <xfs@oss.sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jul 31, 2016 at 08:13:23PM -0700, Keith Packard wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > So we'd see that from the point of view of a torn single sector
> > write. Ok, so we better limit DAX to CRC enabled filesystems to
> > ensure these sorts of events are always caught by the filesystem.
> 
> Which is the same lack of guarantee that we already get on rotating
> media. Flash media seems to work harder to provide sector atomicity; I
> guess that's a feature?

No, that's not the case. Existing sector based storage guarantees
atomic sector writes - rotating or solid state. I haven't seen one a
corruption caused by a torn sector write in 15 years.  BTT layer was
written for pmem to provide this guarantee, but you can't use DAX
through that layer.

In XFS, the only place we really care about torn sector writes in
the journal - we have CRCs there to detect such problems and CRC
enabled filesystems will prevent recovery of checkpoints containing
torn writes. Non-CRC enable filesystems just warn and continue on
their merry way (compatibility reasons - older kernels don't emit
CRCs in log writes), so we really do need to restrict DAX to CRC
enabled filesystems.

> The alternative is to hide metadata behind a translation layer, and
> while that can be done for lame file systems,

No. These "lame" filesystems just need to use their existing
metadata buffering layer to hide this and the journalling subsystem
should protects against torn metadata writes.

> I'd like to see the raw
> hardware capabilities exposed and then make free software that
> constructs a reliable system on top of that.

Not as easy as it sounds.  A couple of weeks ago I tried converting
the XFS journal to use DAX to avoid the IO layer and resultant
memcpy(), and I found out that there's a major problem with using
DAX for metadata access on existing filesystems: pmem is not
physically contiguous. I found that out the hard way - the ramdisk
is DAX capable, but each 4k page ithat is allocated to it has a
different memory address.

Filesystems are designed around the fact that the block address
space they are working with is contiguous - that sector N and sector
N+1 can be accessed in the same IO. This is not true for
direct access of pmem - while the sectors might be logically
contiguous, the physical memory that is directly accessed is not.
i.e. when we cross a page boundary, the next page could be on a
different node, on a different device (e.g.  RAID0), etc.
Traditional remapping devices (i.e. DM, md, etc) hide the physical
discontiguities from the filesystem - the present a contiguous LBA
and remap/split/combine under the covers where the filesystem is not
aware of it at all.

The reason this is important is that if the filesystem has metadata
constructs larger than a single page it can't use DAX to access them
as a single object because they may lay across a physical
discontiguity in the memory map.  Filesystems aren't usually exposed
to this - sectors of a block device are indexed by "Logical Block
Address" for good reason - the LBA address space is supposed to hide
the physical layout of the storage from the layer above the block
device.

OTOH, DAX directly exposes the physical layout to the filesytem.
And because it's DAX-based pmem and not cached struct pages, we
can't run vm_map_ram() to virtually map the range we need to see as
a contiguous range, as we do in XFS for large objects such as directory
blocks and log buffers. For other large objects such as inode
clusters, we can directly map each page as the objects within the
clusters are page aligned and never overlap page boundaries, but
that only works for inode and dquot buffers. Hence DAX as it stands
makes it extremely difficult to "retrofit" DAX into all aspects of
existing fileystems because exposing physical discontiguities breaks
code that assumes they don't exist.

I've been saying this from the start: we can't make use of all the
capabilities of pmem with existing filesystems and DAX.  DAX is
supposed to be a *stopgap measure* until pmem native solutions are
built and mature. Finding limitations like the above only serve to
highlight the fact DAX on ext4/XFS is only a partial solution.

The real problem is, as always, a lack of resources to implement
everything we want to be able to do. Building a new filesystem is
hard, takes a long time, and all the people we have that might be
able to do it are fully occupied by maintaining and enhancing the
existing Linux filesystems to support things like DAX or other
functionality that users want (e.g. rmap, reflink, copy offload,
etc).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
