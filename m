Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x243.google.com (mail-qt0-x243.google.com
 [IPv6:2607:f8b0:400d:c0d::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E5C82228352E
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 16:42:50 -0800 (PST)
Received: by mail-qt0-x243.google.com with SMTP id l25so22696769qtj.1
 for <linux-nvdimm@lists.01.org>; Mon, 05 Mar 2018 16:49:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3f56c76d-6a5c-7c2f-5442-c9209749b598@deltatee.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-8-logang@deltatee.com>
 <CAOSf1CEj1vmLLd27-642=XSnL9ODkpEC0qLHA2_W5_7rV5+4Pg@mail.gmail.com>
 <20180305160004.GA30975@localhost.localdomain>
 <3f56c76d-6a5c-7c2f-5442-c9209749b598@deltatee.com>
From: Oliver <oohall@gmail.com>
Date: Tue, 6 Mar 2018 11:49:02 +1100
Message-ID: <CAOSf1CHvaz0QTCkptQwsdyPp6uvvHqtM51N0MfrO9RqYf9W0tg@mail.gmail.com>
Subject: Re: [PATCH v2 07/10] nvme-pci: Use PCI p2pmem subsystem to manage the
 CMB
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 6, 2018 at 4:10 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
> On 05/03/18 09:00 AM, Keith Busch wrote:
>>
>> On Mon, Mar 05, 2018 at 12:33:29PM +1100, Oliver wrote:
>>>
>>> On Thu, Mar 1, 2018 at 10:40 AM, Logan Gunthorpe <logang@deltatee.com>
>>> wrote:
>>>>
>>>> @@ -429,10 +429,7 @@ static void __nvme_submit_cmd(struct nvme_queue
>>>> *nvmeq,
>>>>   {
>>>>          u16 tail = nvmeq->sq_tail;
>>>
>>>
>>>> -       if (nvmeq->sq_cmds_io)
>>>> -               memcpy_toio(&nvmeq->sq_cmds_io[tail], cmd,
>>>> sizeof(*cmd));
>>>> -       else
>>>> -               memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
>>>> +       memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
>>>
>>>
>>> Hmm, how safe is replacing memcpy_toio() with regular memcpy()? On PPC
>>> the _toio() variant enforces alignment, does the copy with 4 byte
>>> stores, and has a full barrier after the copy. In comparison our
>>> regular memcpy() does none of those things and may use unaligned and
>>> vector load/stores. For normal (cacheable) memory that is perfectly
>>> fine, but they can cause alignment faults when targeted at MMIO
>>> (cache-inhibited) memory.
>>>
>>> I think in this particular case it might be ok since we know SEQs are
>>> aligned to 64 byte boundaries and the copy is too small to use our
>>> vectorised memcpy(). I'll assume we don't need explicit ordering
>>> between writes of SEQs since the existing code doesn't seem to care
>>> unless the doorbell is being rung, so you're probably fine there too.
>>> That said, I still think this is a little bit sketchy and at the very
>>> least you should add a comment explaining what's going on when the CMB
>>> is being used. If someone more familiar with the NVMe driver could
>>> chime in I would appreciate it.
>>
>>
>> I may not be understanding the concern, but I'll give it a shot.
>>
>> You're right, the start of any SQE is always 64-byte aligned, so that
>> should satisfy alignment requirements.
>>
>> The order when writing multiple/successive SQEs in a submission queue
>> does matter, and this is currently serialized through the q_lock.
>>
>> The order in which the bytes of a single SQE is written doesn't really
>> matter as long as the entire SQE is written into the CMB prior to writing
>> that SQ's doorbell register.
>>
>> The doorbell register is written immediately after copying a command
>> entry into the submission queue (ignore "shadow buffer" features),
>> so the doorbells written to commands submitted is 1:1.
>>
>> If a CMB SQE and DB order is not enforced with the memcpy, then we do
>> need a barrier after the SQE's memcpy and before the doorbell's writel.
>
>
>
> Thanks for the information Keith.
>
> Adding to this: regular memcpy generally also enforces alignment as
> unaligned access to regular memory is typically bad in some way on most
> arches. The generic memcpy_toio also does not have any barrier as it is just
> a call to memcpy. Arm64 also does not appear to have a barrier in its
> implementation and in the short survey I did I could not find any
> implementation with a barrier. I also did not find a ppc implementation in
> the tree but it would be weird for it to add a barrier when other arches do
> not appear to need it.

It's in arch/powerpc/kernel/io.c as _memcpy_toio() and it has two full barriers!

Awesome!

Our io.h indicates that our iomem accessors are designed to provide x86ish
strong ordering of accesses to MMIO space. The git log indicates
arch/powerpc/kernel/io.c has barely been touched in the last decade so
odds are most of that code was written in the elder days when people
were less aware of ordering issues. It might just be overly conservative
by today's standards, but maybe not (see below).

> We've been operating on the assumption that memory mapped by
> devm_memremap_pages() can be treated as regular memory. This is emphasized
> by the fact that it does not return an __iomem pointer.

I think the lack of an __iomem annotation is a bit of a red herring. The comment
header for devm_memremap_pages() outlines the conditions for when using
it is valid, the important one being:

> * 4/ res is expected to be a host memory range that could feasibly be
> *    treated as a "System RAM" range, i.e. not a device mmio range, but
> *    this is not enforced.

Granted, the CMB is a MMIO buffer rather than a register range, but from
my perspective it's still a device MMIO range rather than something we
could feasibly treat as system RAM. The two big reasons being:

a) System RAM is cacheable and coherent while the CMB is neither, and
b) On PPC MMIO accesses are in a separate ordering domain to cacheable
   memory accesses.

The latter isn't as terrifying as it sounds since a full barrier will
order everything
with everything, but it still causes problems. For performance reasons
we want to
minimise the number of cases where we need to use a sync instruction
(full barrier)
in favour of a lightweight sync (lwsync) which only orders cacheable
accesses. To
implement that our MMIO accessors set a percpu flag that arch_spin_unlock()
checks to see if any MMIO accesses have occured which would require a full
barrier. If we havn't done any MMIO operations then it'll only do a lwsync. My
concern here is that a driver might do something like this:

void *buffer = devm_memremap_pages(<stuff corresponding to card memory buffer>);

spin_lock();
<do some stuff with system memory>
// buffer is in MMIO space, so the writes are uncached
memcpy(buffer, source_data, <size>);
<do more stuff with system memory>
spin_unlock(); // no MMIO access detected, so it does a lwsync

As far as I know the spinlock API guarantees that accesses that
occurring inside the
critical section will be ordered relative to what happens outside the
critical section.
In this case we would be violating that guarantee and I don't see a
clean way to keep
the fix for it contained to arch/powerpc/. Fundamentally we need to know when
something is accessing MMIO space.

(I'm not going to suggest ditching the lwsync trick. mpe is not going
to take that patch
without a really good reason)

>If this assumption
> does not hold for an arch then we cannot support P2P DMA without an overhaul
> of many kernel interfaces or creating other backend interfaces into the
> drivers which take different data types (ie. we'd have to bypass the entire
> block layer when trying to write data in p2pmem to an nvme device. This is
> very undesirable.

I know. I'm not trying to ruin your day, but the separation between io
and normal memory
is there for a reason. Maybe we can relax that separation, but we need
to be careful about
how we do it.

Oliver
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
