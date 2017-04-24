Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CDD1E21A0480F
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 10:58:14 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] libnvdimm, region: sysfs trigger for nvdimm_flush()
References: <149281853758.22910.2919981036906495309.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49d1c1g4ba.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jYAM73HUOU15ok1F91y+A6OEbSXrwBVStz7ewhmsnJsA@mail.gmail.com>
 <x4960htg3hv.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jiPfUNR9jFtjGgmfaMWLboVzW9gHmFBtykR+C4pDae2g@mail.gmail.com>
Date: Mon, 24 Apr 2017 13:58:12 -0400
In-Reply-To: <CAPcyv4jiPfUNR9jFtjGgmfaMWLboVzW9gHmFBtykR+C4pDae2g@mail.gmail.com>
 (Dan Williams's message of "Mon, 24 Apr 2017 10:43:41 -0700")
Message-ID: <x49efwhd6x7.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> [ adding Christoph ]
>
> On Mon, Apr 24, 2017 at 9:43 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Dan Williams <dan.j.williams@intel.com> writes:
>>
>>> On Mon, Apr 24, 2017 at 9:26 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>>> Dan Williams <dan.j.williams@intel.com> writes:
>>>>
>>>>> The nvdimm_flush() mechanism helps to reduce the impact of an ADR
>>>>> (asynchronous-dimm-refresh) failure. The ADR mechanism handles flushing
>>>>> platform WPQ (write-pending-queue) buffers when power is removed. The
>>>>> nvdimm_flush() mechanism performs that same function on-demand.
>>>>>
>>>>> When a pmem namespace is associated with a block device, an
>>>>> nvdimm_flush() is triggered with every block-layer REQ_FUA, or REQ_FLUSH
>>>>> request. However, when a namespace is in device-dax mode, or namespaces
>>>>> are disabled, userspace needs another path.
>>>>>
>>>>> The new 'flush' attribute is visible when it can be determined that the
>>>>> interleave-set either does, or does not have DIMMs that expose WPQ-flush
>>>>> addresses, "flush-hints" in ACPI NFIT terminology. It returns "1" and
>>>>> flushes DIMMs, or returns "0" the flush operation is a platform nop.
>>>>>
>>>>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>>>>
>>>> NACK.  This should function the same way it does for a pmem device.
>>>> Wire up sync.
>>>
>>> We don't have dirty page tracking for device-dax, without that I don't
>>> think we should wire up the current sync calls.
>>
>> Why not?  Device dax is meant for the "flush from userspace" paradigm.
>> There's enough special casing around device dax that I think you can get
>> away with implementing *sync as call to nvdimm_flush.
>
> I think its an abuse of fsync() and gets in the way of where we might
> take userspace-pmem-flushing with new sync primitives as proposed here
> [1].

I agree that it's an abuse, and I'm happy to not go that route.  I am
still against using a sysfs file to do this WPQ flush, however.

> I'm also conscious of the shade that hch threw the last time I tried
> to abuse an existing syscall for device-dax [2].
>
>>> I do think we need a more sophisticated sync syscall interface
>>> eventually that can select which level of flushing is being performed
>>> (page cache vs cpu cache vs platform-write-buffers).
>>
>> I don't.  I think this whole notion of flush, and flush harder is
>> brain-dead.  How do you explain to applications when they should use
>> each one?
>
> You never need to use this mechanism to guarantee persistence, which
> is counter to what fsync() is defined to provide. This mechanism is
> only there to backstop against potential ADR failures.

You haven't answered my question.  Why should applications even need to
consider this?  Do you expect ADR to have a high failure rate?  If so,
shouldn't an application call this deep flush any time they would want
to make their state persistent?

>>> Until then I think this sideband interface makes sense and sysfs is
>>> more usable than an ioctl.
>>
>> Well, if you're totally against wiring up sync, then I say we forget
>> about the deep flush completely.  What's your use case?
>
> The use case is device-dax users that want to reduce the impact of an
> ADR failure. Which also assumes that the platform has mechanisms to
> communicate ADR failure. This is not an interface I expect to be used
> for general purpose applications. All of those should be depending
> solely on ADR semantics.

What applications?

I remain unconvinced of the utility of the WPQ flush separate from
msync/fsync.  Either you always do the WPQ flush, or you never do it.  I
don't see the use case for doing it sometimes, and no one I've asked has
managed to come up with a concrete use case.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
