From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/8] device-dax: sub-division support
Date: Mon, 12 Dec 2016 10:46:45 -0800
Message-ID: <CAPcyv4hq=U8YkYqK4OE__FQyeGq2dKH+=14NttQu0M84yXZ7BQ@mail.gmail.com>
References: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x497f75hxwp.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <x497f75hxwp.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
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
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Mon, Dec 12, 2016 at 9:15 AM, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi, Dan,
>
> Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:
>
>>>From [PATCH 6/8] dax: sub-division support:
>>
>> Device-DAX is a mechanism to establish mappings of performance / feature
>> differentiated memory with strict fault behavior guarantees.  With
>> sub-division support a platform owner can provision sub-allocations of a
>> dax-region into separate devices. The provisioning mechanism follows the
>> same scheme as the libnvdimm sub-system in that a 'seed' device is
>> created at initialization time that can be resized from zero to become
>> enabled.
>>
>> Unlike the nvdimm sub-system there is no on media labelling scheme
>> associated with this partitioning. Provisioning decisions are ephemeral
>> / not automatically restored after reboot. While the initial use case of
>> device-dax is persistent memory other uses case may be volatile, so the
>> device-dax core is unable to assume the underlying memory is pmem.  The
>> task of recalling a partitioning scheme or permissions on the device(s)
>> is left to userspace.
>
> Can you explain this reasoning in a bit more detail, please?  If you
> have specific use cases in mind, that would be helpful.

A few use cases are top of mind:

* userspace persistence support: filesystem-DAX as implemented in XFS
and EXT4 requires filesystem coordination for persistence, device-dax
does not. An application may not need a full namespace worth of
persistent memory, or may want to dynamically resize the amount of
persistent memory it is consuming. This enabling allows online resize
of device-dax file/instance.

* allocation + access mechanism for performance differentiated memory:
Persistent memory is one example of a reserved memory pool with
different performance characteristics than typical DRAM in a system,
and there are examples of other performance differentiated memory
pools (high bandwidth or low latency) showing up on commonly available
platforms. This mechanism gives purpose built applications (high
performance computing, databases, etc...) a way to establish mappings
with predictable fault-granularities and performance, but also allow
for different permissions per allocation.

* carving up a PCI-E device memory bar for managing peer-to-peer
transactions: In the thread about enablling P2P DMA one of the
concerns that was raised was security separation of different users of
a device: http://marc.info/?l=linux-kernel&m=148106083913173&w=2

>> For persistent allocations, naming, and permissions automatically
>> recalled by the kernel, use filesystem-DAX. For a userspace helper
>
> I'd agree with that guidance if it wasn't for the fact that device dax
> was born out of the need to be able to flush dirty data in a safe manner
> from userspace.  At best, we're giving mixed guidance to application
> developers.

Yes, but at the same time device-DAX is sufficiently painful (no
read(2)/write(2) support, no builtin metadata support) that it may
spur application developers to lobby for a filesystem that offers
userspace dirty-data flushing. Until then we have this vehicle to test
the difference and dax-support for memory types beyond persistent
memory.
