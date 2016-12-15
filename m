From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/8] device-dax: sub-division support
Date: Thu, 15 Dec 2016 15:48:41 -0800
Message-ID: <CAPcyv4gWW0NfiP6iGpaB5hAyiD8SMbeAfAKvezDLH1GzH_HqTA@mail.gmail.com>
References: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x497f75hxwp.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4hq=U8YkYqK4OE__FQyeGq2dKH+=14NttQu0M84yXZ7BQ@mail.gmail.com>
 <x494m278kam.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4hzCHqF9ALYFYCpv=WyHoMOFDoeWOd38b4sKwmkkmSgLQ@mail.gmail.com>
 <x49shpp3zn8.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <x49shpp3zn8.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Thu, Dec 15, 2016 at 8:50 AM, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi, Dan,
>
> Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:
>
>> On Tue, Dec 13, 2016 at 3:46 PM, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> Hi, Dan,
>>>
>>> In general, I have a couple of concerns with this patchset:
>>> 1) You're making a case that subdivision shouldn't be persistent, which
>>>    means that all of the code we already have for subdividing devices
>>>    (partitions, libnvdimm) has to be re-invented in userspace, and
>>>    existing tools can't be used to manage nvdimms.
>>
>> Keep in mind that the device-dax core just operates on address ranges,
>> whether those address ranges are persistent or not is invisible to the
>> core. The core simply can not assume that the address ranges it is
>> managing are persistent or volatile. For environments that want to use
>> traditional partitioning or libnvdimm namespace labels, nothing stops
>> them. The difference is just a mode setting at the namespace level,
>> for example:
>>
>>     ndctl create-namespace --reconfig=namespace0.0 --mode=dax --force
>>     ndctl create-namespace --reconfig=namespace0.0 --mode=memory --force
>>
>> Also recall that we have namespace sub-division support, with
>> persistent labels, that was added in 4.9. So instead of being limited
>> to one namespace per pmem-region we can now support multiple
>> namespaces per region.
>
> Namespace subdivision requires label support in the NVDIMM, and given
> that there are no NVDIMMs out there today that support labels, that's
> not an option.
>
> It makes a heck of a lot more sense to continue to manage storage via a
> block device.  I know that DAX support for block devices ran into
> roadblocks before, but I'm willing to give it another try.  You
> mentioned on irc that we may be able to emulate label support for
> DIMMs that don't have it.  I guess that would be another way forward.
> Did you have any ideas on how that might be implemented?

Yes, place an information block at the start of the region that
reserves space for a label. Extend the new dynamic label support [1]
to switch to label mode upon finding this signature.

Linux could go off and do this privately today, or we can work on
trying to get this scheme into a standard so that other operating
environments honor those boundaries.

[1]: 42237e393f64 libnvdimm: allow a platform to force enable label support
https://git.kernel.org/cgit/linux/kernel/git/nvdimm/nvdimm.git/commit/?h=libnvdimm-for-next&id=42237e393f64

>>> 2) You're pushing file system features into a character device.
>>
>> Yes, just like a block device the device-dax instances support
>> sub-division and a unified inode.
>
> I'm not sure what you mean by a unified inode.

For example if I had a situation like the following:

# ls -l dax1.0
crw------- 1 root root 243, 0 Dec 14 15:08 dax1.0
crw------- 1 root root 243, 0 Dec 14 15:08 another-dax1.0

Without a "unified inode" an mmap on 'dax1.0' is isolated from an mmap
on 'another-dax1.0' . Each of those files is related to their own
inode in the devtmpfs filesystem. For dax we allocate our own inode
and redirect the i_mapping of those per-device-file inodes to the
single inode allocated per dax device. This is identical to what
happens in bd_acquire() for a block device.


>> But, unlike a block device, no entanglements with the page cache or
>> other higher level file api features.
>
>>> OK, so you've now implemented file extending and truncation (and block
>>> mapping, I guess).  Where does this end?  How many more file-system
>>> features will you add to this character device?
>>>
>>
>> It ends here. A device-file per sub-allocation of a memory range is
>> the bare minimum to take device-dax from being a toy to something
>> usable in practice. Device-DAX will never support read(2)/write(2),
>> never support MAP_PRIVATE, and being DAX it will never interact with
>> the page cache which eliminates most of the rest of the file apis. It
>> will also never support higher order mm capabilities like overcommit
>> and migration.
>
> Well, Dave Jiang posted patches to add fallocate support.  So it didn't
> quite end there.

True, sorry, I should have brought that up. I didn't want to invent a
private ioctl path to clear errors. The fallocate support is limited
to triggering to a firmware "clear error" command for the given range.

>>>> * allocation + access mechanism for performance differentiated memory:
>>>> Persistent memory is one example of a reserved memory pool with
>>>> different performance characteristics than typical DRAM in a system,
>>>> and there are examples of other performance differentiated memory
>>>> pools (high bandwidth or low latency) showing up on commonly available
>>>> platforms. This mechanism gives purpose built applications (high
>>>> performance computing, databases, etc...) a way to establish mappings
>>>> with predictable fault-granularities and performance, but also allow
>>>> for different permissions per allocation.
>>>
>>> So, how would an application that wishes to use a device-dax subdivision
>>> of performance differentiated memory get access to it?
>>> 1) administrator subdivides space and assigns it to a user
>>> 2) application gets to use it
>>>
>>> Something like that?  Or do you expect applications to sub-divide the
>>> device-dax instance programmatically?
>>
>> No, not programmatically, I would expect this would be a provisioning
>> time setup operation when the server/service is instantiated.
>
> That's a terrible model for storage.  If you're going to continue on
> this path, then I'd suggest that the moment the namespace is converted
> to be "device dax", the initial device should have a size of 0.  At
> least that way nobody can accidentally open it and scribble all over
> the full device.

Fair enough, I'll make that change... or better yet just turn it off
by default for pmem, see below.

>>> Why wouldn't you want the mapping to live beyond a single boot?
>>
>> This goes back to not being able to assume that the media is
>> persistent. If an application/use case needs the kernel to recall
>> provisioning decisions then that application needs to stick to
>> libnvdimm namespace labels, block device partitions, or a filesystem.
>
> You can't have it both ways.  Either device-dax is meant for persistent
> memory or it isn't.

I'm not trying to have it both ways I'm trying to develop an interface
that is generically useful for reserved memory where the persistence
of provisioning decisions is handled at a higher level in the
device-model hierarchy, or in userspace.

> You're stating that the right way to divide up a
> persistent memory namespace is to use labels, which don't exist.

QEMU ships support for the current label mechanisms in Linux, we
expect future platfoms to be compatible with that enabling, and I gave
you a plan above for existing NVDIMMs without a label area.

> Then you're proposing this method for dividing up device-dax as well, without
> anybody from the non-persistent memory camp even chiming in that this is
> something that they want.  What is the urgency here, and where are the
> users?

The same urgency of merging ACPI NFIT support when we did. We also had
support for custom defining memory ranges (memmap=ss!nn) upstream in
advance of that.

There are platforms with these differentiated (non-persistent) memory
types [2], and device-dax is a mechanism to get guaranteed mappings of
that memory. Guaranteed mappings without playing games with
numa-distance to keep stray kernel allocations from landing in the
"precious" memory pool, a pool that is expected to be 100% available
for a given application.

[2]: https://software.intel.com/en-us/articles/mcdram-high-bandwidth-memory-on-knights-landing-analysis-methods-tools

> I can only conclude that you actually do intend the subdivision to be
> used for persistent memory, and I'm telling you that what you've
> implemented doesn't fit that use case well at all.

I do intend the base device-dax capability to be used with persistent
memory, but you're right this sub-division mechanism is terrible for
storage in the general case. Let's make it default to off for pmem,
with a module parameter override if an application really thinks it
knows what it is dong. Does that address your concern?

>>>> * carving up a PCI-E device memory bar for managing peer-to-peer
>>>> transactions: In the thread about enablling P2P DMA one of the
>>>> concerns that was raised was security separation of different users of
>>>> a device: http://marc.info/?l=linux-kernel&m=148106083913173&w=2
>>>
>>> OK, but I wasn't sure that there was consensus in that thread.  It
>>> seemed more likely that the block device ioctl path would be pursued.
>>> If this is the preferred method, I think you should document their
>>> requirements and show how the implementation meets them, instead of
>>> leaving that up to reviewers.  Or, at the very least, CC the interested
>>> parties?
>>
>> I put those details here [1]. That thread did try to gather
>> requirements, but got muddled between graphics, mm, and RDMA concerns.
>> Device-dax is not attempting to solve problems outside of its core use
>> of allowing an application to statically allocate reserved memory. If
>> it works by accident for a P2P RDMA use case, great, but to your
>> earlier concern we're not going to chase that use case with ever more
>> device-dax features.
>>
>> [1]: http://marc.info/?l=linux-kernel&m=147983832620658&w=2
>
> That's a pretty thin proposal.  I'd much rather see the rest of the
> supporting code implemented as a proof of concept before we start taking
> interfaces into the kernel.  If your only justification is to use this
> with persistent memory, then I'm telling you I think it's a bad
> interface.
>

Noted. I'm not going to merge this as is over your objection.

I still think whole namespace (indivisible) device-dax for pmem is needed.

>>>>>> For persistent allocations, naming, and permissions automatically
>>>>>> recalled by the kernel, use filesystem-DAX. For a userspace helper
>>>>>
>>>>> I'd agree with that guidance if it wasn't for the fact that device dax
>>>>> was born out of the need to be able to flush dirty data in a safe manner
>>>>> from userspace.  At best, we're giving mixed guidance to application
>>>>> developers.
>>>>
>>>> Yes, but at the same time device-DAX is sufficiently painful (no
>>>> read(2)/write(2) support, no builtin metadata support) that it may
>>>> spur application developers to lobby for a filesystem that offers
>>>> userspace dirty-data flushing. Until then we have this vehicle to test
>>>> the difference and dax-support for memory types beyond persistent
>>>> memory.
>>>
>>> Let's just work on the PMEM_IMMUTABLE flag that Dave suggested[1] and
>>> make device dax just for volatile memories.
>>
>> Yes, let's work on PMEM_IMMUTABLE, and in the meantime we have
>> device-dax. It's not a zero sum situation.
>>
>> Device-dax handles physical memory ranges generically, if you want to
>> "make device dax just for volatile memories", that's a user decision
>> to not give persistent memory ranges to device-dax.
>
> Right now, your only use case is persistent memory, and I don't think
> this is the right interface for it.  Clearly someone is asking for this
> support.  Can you convince them to chime in on the mailing list with
> their requirements?  Alternatively, can you state what the requirements
> were that lead to this solution?

The feedback I received from an application developer that convinced
me to push on the device-dax interface (outside of the volatile uses)
was that it allowed applications to implement metadata redundancy. In
the filesystem-DAX case we don't have a way to identify and survive
media errors that land in the metadata that describes a dax file. With
device-dax an application at least has the visibility to manage all
the metadata that describes a dax-file.

As for sub-division it was designed for the volatile case, I've heard
feedback that some want it for the pmem case. You and I agree that
it's *not* a good interface for the pmem case, so I'm fine disabling
sub-division and telling them that they need to override a kernel
default to use this mechanism for pmem, but otherwise say "just use
libnvdimm namespace labels" for storage use cases.
