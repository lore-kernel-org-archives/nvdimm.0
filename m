Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151026062319.GJ19199@dastard>
References: <20151022064142.12700.11849.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151022064211.12700.77105.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151022093549.GE14445@quack.suse.cz>
	<1445529945.17208.4.camel@intel.com>
	<20151022210818.GC8670@quack.suse.cz>
	<20151025212247.GI19199@dastard>
	<CAPcyv4hjGYYPRyPjZc3CymmnSObB7mULRbeMZFjnKdoCD_m7pw@mail.gmail.com>
	<20151026062319.GJ19199@dastard>
Date: Mon, 26 Oct 2015 17:56:30 +0900
Message-ID: <CAPcyv4iaKDYuP6ppAVk5UOhzmOEO4Q=N_+osB2D+aPoAzpeHvw@mail.gmail.com>
Subject: Re: [PATCH 5/5] block: enable dax for raw block devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "willy@linux.intel.com" <willy@linux.intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 26, 2015 at 3:23 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Oct 26, 2015 at 11:48:06AM +0900, Dan Williams wrote:
>> On Mon, Oct 26, 2015 at 6:22 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Thu, Oct 22, 2015 at 11:08:18PM +0200, Jan Kara wrote:
>> >> Ugh2: Now I realized that DAX mmap isn't safe wrt fs freezing even for
>> >> filesystems since there's nothing which writeprotects pages that are
>> >> writeably mapped. In normal path, page writeback does this but that doesn't
>> >> happen for DAX. I remember we once talked about this but it got lost.
>> >> We need something like walk all filesystem inodes during fs freeze and
>> >> writeprotect all pages that are mapped. But that's going to be slow...
>> >
>> > fsync() has the same problem - we have no record of the pages that
>> > need to be committed and then write protected when fsync() is called
>> > after write()...
>>
>> I know Ross is still working on that implementation.  However, I had a
>> thought on the flight to ksummit that maybe we shouldn't worry about
>> tracking dirty state on a per-page basis.  For small / frequent
>> synchronizations an application really should be using the nvml
>> library [1] to issue cache flushes and pcommit from userspace on a
>> per-cacheline basis.  That leaves unmodified apps that want to be
>> correct in the presence of dax mappings.  Two things we can do to
>> mitigate that case:
>>
>> 1/ Make DAX mappings opt-in with a new MMAP_DAX (page-cache bypass)
>> flag.  Applications shouldn't silently become incorrect simply because
>> the fs is mounted with -o dax.  If an app doesn't understand DAX
>> mappings it should get page-cache semantics.  This also protects apps
>> that are not expecting DAX semantics on raw block device mappings.
>
> Which is the complete opposite of what we are trying to acehive with
> DAX. i.e. that existing applications "just work" with DAX without
> modification. So this is a non-starter.

The list of things DAX breaks is getting shorter, but certainly the
page-less paths will not be without surprises for quite a while yet...

> Also, DAX access isn't a property of mmap - it's a property
> of the inode. We cannot do DAX access via mmap while mixing page
> cache based access through file descriptor based interfaces. This
> I why I'm adding an inode attribute (on disk) to enable per-file DAX
> capabilities - either everything is via the DAX paths, or nothing
> is.
>

Per-inode control sounds very useful, I'll look at a similar mechanism
for the raw block case.

However, still not quite convinced page-cache control is an inode-only
property, especially when direct-i/o is not an inode-property.  That
said, I agree the complexity of handling mixed mappings of the same
file is prohibitive.

>> 2/ Even if we get a new flag that lets the kernel know the app
>> understands DAX mappings, we shouldn't leave fsync broken.  Can we
>> instead get by with a simple / big hammer solution?  I.e.
>
> Because we don't physically have to write back data the problem is
> both simpler and more complex. The simplest solution is for the
> underlying block device to implement blkdev_issue_flush() correctly.
>
> i.e. if blkdev_issue_flush() behaves according to it's required
> semantics - that all volatile cached data is flushed to stable
> storage - then fsync-on-DAX will work appropriately. As it is, this is
> needed for journal based filesystems to work correctly, as they are
> assuming that their journal writes are being treated correctly as
> REQ_FLUSH | REQ_FUA to ensure correct data/metadata/journal
> ordering is maintained....
>
> So, to begin with, this problem needs to be solved at the block
> device level. That's the simple, brute-force, big hammer solution to
> the problem, and it requires no changes at the filesystem level at
> all.
>
> However, to avoid having to flush the entire block device range on
> fsync we need a much more complex solution that tracks the dirty
> ranges of the file and hence what needs committing when fsync is
> run....
>
>> Disruptive, yes, but if an app cares about efficient persistent memory
>> synchronization fsync is already the wrong api.
>
> I don't really care about efficiency right now - correctness comes
> first. Fundamentally, the app should not care whether it is writing to
> persistent memory or spinning rust - the filesystem needs to
> provide the application with exactly the same integrity guarantees
> regardless of the underlying storage.
>

Sounds good, get blkdev_issue_flush() functional first and then worry
about building a more efficient solution on top.
