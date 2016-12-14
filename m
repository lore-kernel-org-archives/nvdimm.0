From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/8] device-dax: sub-division support
Date: Tue, 13 Dec 2016 17:17:39 -0800
Message-ID: <CAPcyv4hzCHqF9ALYFYCpv=WyHoMOFDoeWOd38b4sKwmkkmSgLQ@mail.gmail.com>
References: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x497f75hxwp.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4hq=U8YkYqK4OE__FQyeGq2dKH+=14NttQu0M84yXZ7BQ@mail.gmail.com>
 <x494m278kam.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <x494m278kam.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
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

On Tue, Dec 13, 2016 at 3:46 PM, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi, Dan,
>
> In general, I have a couple of concerns with this patchset:
> 1) You're making a case that subdivision shouldn't be persistent, which
>    means that all of the code we already have for subdividing devices
>    (partitions, libnvdimm) has to be re-invented in userspace, and
>    existing tools can't be used to manage nvdimms.

Keep in mind that the device-dax core just operates on address ranges,
whether those address ranges are persistent or not is invisible to the
core. The core simply can not assume that the address ranges it is
managing are persistent or volatile. For environments that want to use
traditional partitioning or libnvdimm namespace labels, nothing stops
them. The difference is just a mode setting at the namespace level,
for example:

    ndctl create-namespace --reconfig=namespace0.0 --mode=dax --force
    ndctl create-namespace --reconfig=namespace0.0 --mode=memory --force

Also recall that we have namespace sub-division support, with
persistent labels, that was added in 4.9. So instead of being limited
to one namespace per pmem-region we can now support multiple
namespaces per region.

> 2) You're pushing file system features into a character device.

Yes, just like a block device the device-dax instances support
sub-division and a unified inode. But, unlike a block device, no
entanglements with the page cache or other higher level file api
features.

> I think that using device dax for both volatile and non-volatile
> memories is a mistake.  For persistent memory, I think users would want
> any subdivision to be persistent.  I also think that using a familiar
> storage model, like block devices and partitions, would make a heck of a
> lot more sense than this proposal.  For volatile use cases, I don't have
> a problem with what you've proposed.  But then, I don't really think too
> much about those use cases, either, so maybe I'm not the best person to
> ask.
>
> So, in my opinion, you should make device dax all about the volatile use
> case and we can go back to pushing dax for block devices to support use
> cases like big databases and passing NVDIMMs into VMs.  Yes, I'm signing
> up to help.
>
> More detailed responses are inline below.
>
> Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:
>
>> On Mon, Dec 12, 2016 at 9:15 AM, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> Hi, Dan,
>>>
>>> Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:
>>>
>>>>>From [PATCH 6/8] dax: sub-division support:
>>>>
>>>> Device-DAX is a mechanism to establish mappings of performance / feature
>>>> differentiated memory with strict fault behavior guarantees.  With
>>>> sub-division support a platform owner can provision sub-allocations of a
>>>> dax-region into separate devices. The provisioning mechanism follows the
>>>> same scheme as the libnvdimm sub-system in that a 'seed' device is
>>>> created at initialization time that can be resized from zero to become
>>>> enabled.
>>>>
>>>> Unlike the nvdimm sub-system there is no on media labelling scheme
>>>> associated with this partitioning. Provisioning decisions are ephemeral
>>>> / not automatically restored after reboot. While the initial use case of
>>>> device-dax is persistent memory other uses case may be volatile, so the
>>>> device-dax core is unable to assume the underlying memory is pmem.  The
>>>> task of recalling a partitioning scheme or permissions on the device(s)
>>>> is left to userspace.
>>>
>>> Can you explain this reasoning in a bit more detail, please?  If you
>>> have specific use cases in mind, that would be helpful.
>>
>> A few use cases are top of mind:
>>
>> * userspace persistence support: filesystem-DAX as implemented in XFS
>> and EXT4 requires filesystem coordination for persistence, device-dax
>> does not. An application may not need a full namespace worth of
>> persistent memory, or may want to dynamically resize the amount of
>> persistent memory it is consuming. This enabling allows online resize
>> of device-dax file/instance.
>
> OK, so you've now implemented file extending and truncation (and block
> mapping, I guess).  Where does this end?  How many more file-system
> features will you add to this character device?
>

It ends here. A device-file per sub-allocation of a memory range is
the bare minimum to take device-dax from being a toy to something
usable in practice. Device-DAX will never support read(2)/write(2),
never support MAP_PRIVATE, and being DAX it will never interact with
the page cache which eliminates most of the rest of the file apis. It
will also never support higher order mm capabilities like overcommit
and migration.

>> * allocation + access mechanism for performance differentiated memory:
>> Persistent memory is one example of a reserved memory pool with
>> different performance characteristics than typical DRAM in a system,
>> and there are examples of other performance differentiated memory
>> pools (high bandwidth or low latency) showing up on commonly available
>> platforms. This mechanism gives purpose built applications (high
>> performance computing, databases, etc...) a way to establish mappings
>> with predictable fault-granularities and performance, but also allow
>> for different permissions per allocation.
>
> So, how would an application that wishes to use a device-dax subdivision
> of performance differentiated memory get access to it?
> 1) administrator subdivides space and assigns it to a user
> 2) application gets to use it
>
> Something like that?  Or do you expect applications to sub-divide the
> device-dax instance programmatically?

No, not programmatically, I would expect this would be a provisioning
time setup operation when the server/service is instantiated.

> Why wouldn't you want the mapping
> to live beyond a single boot?

This goes back to not being able to assume that the media is
persistent. If an application/use case needs the kernel to recall
provisioning decisions then that application needs to stick to
libnvdimm namespace labels, block device partitions, or a filesystem.

>> * carving up a PCI-E device memory bar for managing peer-to-peer
>> transactions: In the thread about enablling P2P DMA one of the
>> concerns that was raised was security separation of different users of
>> a device: http://marc.info/?l=linux-kernel&m=148106083913173&w=2
>
> OK, but I wasn't sure that there was consensus in that thread.  It
> seemed more likely that the block device ioctl path would be pursued.
> If this is the preferred method, I think you should document their
> requirements and show how the implementation meets them, instead of
> leaving that up to reviewers.  Or, at the very least, CC the interested
> parties?

I put those details here [1]. That thread did try to gather
requirements, but got muddled between graphics, mm, and RDMA concerns.
Device-dax is not attempting to solve problems outside of its core use
of allowing an application to statically allocate reserved memory. If
it works by accident for a P2P RDMA use case, great, but to your
earlier concern we're not going to chase that use case with ever more
device-dax features.

[1]: http://marc.info/?l=linux-kernel&m=147983832620658&w=2

>>>> For persistent allocations, naming, and permissions automatically
>>>> recalled by the kernel, use filesystem-DAX. For a userspace helper
>>>
>>> I'd agree with that guidance if it wasn't for the fact that device dax
>>> was born out of the need to be able to flush dirty data in a safe manner
>>> from userspace.  At best, we're giving mixed guidance to application
>>> developers.
>>
>> Yes, but at the same time device-DAX is sufficiently painful (no
>> read(2)/write(2) support, no builtin metadata support) that it may
>> spur application developers to lobby for a filesystem that offers
>> userspace dirty-data flushing. Until then we have this vehicle to test
>> the difference and dax-support for memory types beyond persistent
>> memory.
>
> Let's just work on the PMEM_IMMUTABLE flag that Dave suggested[1] and
> make device dax just for volatile memories.

Yes, let's work on PMEM_IMMUTABLE, and in the meantime we have
device-dax. It's not a zero sum situation.

Device-dax handles physical memory ranges generically, if you want to
"make device dax just for volatile memories", that's a user decision
to not give persistent memory ranges to device-dax.
