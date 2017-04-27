Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22b.google.com (mail-it0-x22b.google.com
 [IPv6:2607:f8b0:4001:c0b::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B62321951C90
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 09:56:47 -0700 (PDT)
Received: by mail-it0-x22b.google.com with SMTP id 70so16872184ita.0
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 09:56:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49y3umufpm.fsf@segfault.boston.devel.redhat.com>
References: <149307780135.7155.11108531648914675756.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149315140303.23340.14688142799059150805.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49zif23nvl.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jQXRQVHnNMqJDrwSMM=1kJx_7sWifUN-u1yusVCZ0roQ@mail.gmail.com>
 <x49y3umufpm.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Apr 2017 09:56:44 -0700
Message-ID: <CAPcyv4jOP6fhk4wXahdEWH2O_93LQe9yzrWYZatSXXDwEk5OBA@mail.gmail.com>
Subject: Re: [PATCH v3] libnvdimm, region: sysfs trigger for nvdimm_flush()
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 27, 2017 at 6:45 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> On Wed, Apr 26, 2017 at 1:38 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Dan Williams <dan.j.williams@intel.com> writes:
>>>
>>>> The nvdimm_flush() mechanism helps to reduce the impact of an ADR
>>>> (asynchronous-dimm-refresh) failure. The ADR mechanism handles flushing
>>>> platform WPQ (write-pending-queue) buffers when power is removed. The
>>>> nvdimm_flush() mechanism performs that same function on-demand.
>>>>
>>>> When a pmem namespace is associated with a block device, an
>>>> nvdimm_flush() is triggered with every block-layer REQ_FUA, or REQ_FLUSH
>>>> request. These requests are typically associated with filesystem
>>>> metadata updates. However, when a namespace is in device-dax mode,
>>>> userspace (think database metadata) needs another path to perform the
>>>> same flushing. In other words this is not required to make data
>>>> persistent, but in the case of metadata it allows for a smaller failure
>>>> domain in the unlikely event of an ADR failure.
>>>>
>>>> The new 'flush' attribute is visible when the individual DIMMs backing a
>>>> given interleave-set are described by platform firmware. In ACPI terms
>>>> this is "NVDIMM Region Mapping Structures" and associated "Flush Hint
>>>> Address Structures". Reads return "1" if the region supports triggering
>>>> WPQ flushes on all DIMMs. Reads return "0" the flush operation is a
>>>> platform nop, and in that case the attribute is read-only.
>>>
>>> I can make peace with exposing this to userspace, though I am mostly
>>> against its use.  However, sysfs feels like the wrong interface.
>>> Believe it or not, I'd rather see this implemented as an ioctl.
>>>
>>> This isn't a NACK, it's me giving my opinion.  Do with it what you will.
>>
>> I hate ioctls with a burning passion so I can't get on board with that
>> change, but perhaps the sentiment behind it is that this is too
>> visible and too attractive being called "flush" in sysfs? Would a name
>> more specific to the mechanism make it more palatable? Like
>> "flush_hint_trigger" or "wpq_drain"?
>
> The sentiment is that programs shouldn't have to grovel around in sysfs
> to do stuff related to an open file descriptor or mapping.  I don't take
> issue with the name.  I do worry that something like 'wpq_drain' may be
> too platform specific, though.  The NVM Programming Model specification
> is going to call this "deep flush", so maybe that will give you
> some inspiration if you do want to change the name.

I'll change to "deep_flush", and I quibble that this is related to a
single open file descriptor or mapping. It really is a "region flush"
for giving extra protection for global metadata, but the persistence
of individual fds or mappings is handled by ADR. I think an ioctl
might give the false impression that every time you flush a cacheline
to persistence you need to call the ioctl.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
