Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 15 Sep 2016 16:25:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: DAX mapping detection (was: Re: [PATCH] Fix region lost in
 /proc/self/smaps)
Message-ID: <20160915062527.GR30497@dastard>
References: <CAPcyv4iDra+mRqEejfGqapKEAFZmUtUcg0dsJ8nt7mOhcT-Qpw@mail.gmail.com>
 <20160908225636.GB15167@linux.intel.com>
 <20160912014035.GB30497@dastard>
 <20160915055503.GC9309@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160915055503.GC9309@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Yumei Huang <yuhuang@redhat.com>, Michal Hocko <mhocko@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Gleb Natapov <gleb@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, mtosatti@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 14, 2016 at 10:55:03PM -0700, Darrick J. Wong wrote:
> On Mon, Sep 12, 2016 at 11:40:35AM +1000, Dave Chinner wrote:
> > On Thu, Sep 08, 2016 at 04:56:36PM -0600, Ross Zwisler wrote:
> > > On Wed, Sep 07, 2016 at 09:32:36PM -0700, Dan Williams wrote:
> > > > My understanding is that it is looking for the VM_MIXEDMAP flag which
> > > > is already ambiguous for determining if DAX is enabled even if this
> > > > dynamic listing issue is fixed.  XFS has arranged for DAX to be a
> > > > per-inode capability and has an XFS-specific inode flag.  We can make
> > > > that a common inode flag, but it seems we should have a way to
> > > > interrogate the mapping itself in the case where the inode is unknown
> > > > or unavailable.  I'm thinking extensions to mincore to have flags for
> > > > DAX and possibly whether the page is part of a pte, pmd, or pud
> > > > mapping.  Just floating that idea before starting to look into the
> > > > implementation, comments or other ideas welcome...
> > > 
> > > I think this goes back to our previous discussion about support for the PMEM
> > > programming model.  Really I think what NVML needs isn't a way to tell if it
> > > is getting a DAX mapping, but whether it is getting a DAX mapping on a
> > > filesystem that fully supports the PMEM programming model.  This of course is
> > > defined to be a filesystem where it can do all of its flushes from userspace
> > > safely and never call fsync/msync, and that allocations that happen in page
> > > faults will be synchronized to media before the page fault completes.
> > > 
> > > IIUC this is what NVML needs - a way to decide "do I use fsync/msync for
> > > everything or can I rely fully on flushes from userspace?" 
> > 
> > "need fsync/msync" is a dynamic state of an inode, not a static
> > property. i.e. users can do things that change an inode behind the
> > back of a mapping, even if they are not aware that this might
> > happen. As such, a filesystem can invalidate an existing mapping
> > at any time and userspace won't notice because it will simply fault
> > in a new mapping on the next access...
> > 
> > > For all existing implementations, I think the answer is "you need to use
> > > fsync/msync" because we don't yet have proper support for the PMEM programming
> > > model.
> > 
> > Yes, that is correct.
> > 
> > FWIW, I don't think it will ever be possible to support this ....
> > wonderful "PMEM programming model" from any current or future kernel
> > filesystem without a very specific set of restrictions on what can
> > be done to a file.  e.g.
> > 
> > 	1. the file has to be fully allocated and zeroed before
> > 	   use. Preallocation/zeroing via unwritten extents is not
> > 	   allowed. Sparse files are not allowed. Shared extents are
> > 	   not allowed.
> > 	2. set the "PMEM_IMMUTABLE" inode flag - filesystem must
> > 	   check the file is fully allocated before allowing it to
> > 	   be set, and caller must have CAP_LINUX_IMMUTABLE.
> > 	3. Inode metadata is now immutable, and file data can only
> > 	   be accessed and/or modified via mmap().
> > 	4. All non-mmap methods of inode data modification
> > 	   will now fail with EPERM.
> > 	5. all methods of inode metadata modification will now fail
> > 	   with EPERM, timestamp udpdates will be ignored.
> > 	6. PMEM_IMMUTABLE flag can only be removed if the file is
> > 	   not currently mapped and caller has CAP_LINUX_IMMUTABLE.
> > 
> > A flag like this /should/ make it possible to avoid fsync/msync() on
> > a file for existing filesystems, but it also means that such files
> > have significant management issues (hence the need for
> > CAP_LINUX_IMMUTABLE to cover it's use).
> 
> Hmmm... I started to ponder such a flag, but ran into some questions.
> If it's PMEM_IMMUTABLE, does this mean that none of 1-6 apply if the
> filesystem discovers it isn't on pmem?

Would only be meaningful if the FS_XFLAG_DAX/S_DAX flag is also set
on the inode and the backing store is dax capable. Hence the 'PMEM'
part of the name.

> I thought about just having a 'immutable metadata' flag where any
> timestamp, xattr, or block mapping update just returns EPERM.

And all the rest - no hard links, no perm/owner changes, no security
context changes(!), and so on. ANd it's even more complex with
filesystems that have COW metadata and pack multiple unrelated
metadata objects into single blocks - they can do all sorts of
interesting things on unrealted metadata updates... :P

You'd also have to turn off background internal filesystem mod
vectors, too, like EOF scanning, or defrag, balance, dedupe,
auto-repair, etc.  And, now that I think about it, snapshots are out
of the question too.

This gets more hairy the more I think about what our filesystems can
do these days....

> There
> wouldn't be any checks as in (1); if you left a hole in the file prior
> to setting the flag then you won't be filling it unless you clear the
> flag.

Which means writing into a hole would need to return an error, and a
write page fault into a hole would need a segv. Seems like a great
way to cause random application failures to me...

> OTOH if it merely made the metadata unchangeable then it's a
> stretch to get to non-mmap data accesses also being disallowed.

*nod*

> Maybe the immutable metadata and mmap-only properties would only be
> implied if both DAX and IMMUTABLE_META are set on a file?

I'd suggest that PMEM_IMMUTABLE could only be set on an inode that
already has the FS_XFLAG_DAX set on it (or it is being set at the
same time). And clearing the DAX flag would also remove the
PMEM_IMMUTABLE flag. Perhaps it would be better to call it
FS_XFLAG_DAX_IMMUTABLE rather than anything pmem related.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
