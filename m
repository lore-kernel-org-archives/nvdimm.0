Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22c.google.com (mail-it0-x22c.google.com
 [IPv6:2607:f8b0:4001:c0b::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9EFE22195406C
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 14:36:16 -0700 (PDT)
Received: by mail-it0-x22c.google.com with SMTP id c123so6348992ith.1
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 14:36:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hthct-P=W9QLbjswvco8Fcewpf13ZX6-h2PXpHwRtAKg@mail.gmail.com>
References: <149307780135.7155.11108531648914675756.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149315140303.23340.14688142799059150805.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49zif23nvl.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jQXRQVHnNMqJDrwSMM=1kJx_7sWifUN-u1yusVCZ0roQ@mail.gmail.com>
 <x49y3umufpm.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jOP6fhk4wXahdEWH2O_93LQe9yzrWYZatSXXDwEk5OBA@mail.gmail.com>
 <x49d1bxsngb.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4g1zbaNDttkzGv4NV9ZQXrObLqpPLMQW2wqoP_iTozrsQ@mail.gmail.com>
 <x497f25prk6.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4hthct-P=W9QLbjswvco8Fcewpf13ZX6-h2PXpHwRtAKg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Apr 2017 14:36:15 -0700
Message-ID: <CAPcyv4hErApEjUWnRz9ywak8RP6BDremBKzG2wDvWO=wHdAwPg@mail.gmail.com>
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

On Thu, Apr 27, 2017 at 1:02 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Apr 27, 2017 at 12:40 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Dan Williams <dan.j.williams@intel.com> writes:
>>
>>> On Thu, Apr 27, 2017 at 11:41 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>>> Dan Williams <dan.j.williams@intel.com> writes:
>>>>
>>>>>> The sentiment is that programs shouldn't have to grovel around in sysfs
>>>>>> to do stuff related to an open file descriptor or mapping.  I don't take
>>>>>> issue with the name.  I do worry that something like 'wpq_drain' may be
>>>>>> too platform specific, though.  The NVM Programming Model specification
>>>>>> is going to call this "deep flush", so maybe that will give you
>>>>>> some inspiration if you do want to change the name.
>>>>>
>>>>> I'll change to "deep_flush", and I quibble that this is related to a
>>>>> single open file descriptor or mapping. It really is a "region flush"
>>>>> for giving extra protection for global metadata, but the persistence
>>>>> of individual fds or mappings is handled by ADR. I think an ioctl
>>>>> might give the false impression that every time you flush a cacheline
>>>>> to persistence you need to call the ioctl.
>>>>
>>>> fsync, for example, may affect more than one fd--all data in the drive
>>>> write cache will be flushed.  I don't see how this is so different.  I
>>>> think a sysfs file is awkward because it requires an application to
>>>> chase down the correct file in the sysfs hierarchy.  If the application
>>>> already has an open fd or a mapping, it should be able to operate on
>>>> that.
>>>
>>> I'm teetering, but still leaning towards sysfs. The use case that
>>> needs this is device-dax because we otherwise silently do this behind
>>> the application's back on filesystem-dax for fsync / msync.
>>
>> We may yet get file system support for flush from userspace (NOVA, for
>> example).  So I don't think we should restrict ourselves to only
>> thinking about the device dax use case.
>>
>>> A device-dax ioctl would be straightforward, but 'deep flush' assumes
>>> that the device-dax instance is fronting persistent memory.  There's
>>> nothing persistent memory specific about device-dax except that today
>>> only the nvdimm sub-system knows how to create them, but there's
>>> nothing that prevents other memory regions from being mapped this way.
>>
>> You're concerned that applications operating on device dax instances
>> that are not backed by pmem will try to issue a deep flush?  Why would
>> they do that, and why can't you just return failure from the ioctl?
>>
>>> So I'd rather this persistent memory specific mechanism stay with the
>>> persistent memory specific portion of the interface rather than plumb
>>> persistent memory details out through the generic device-dax interface
>>> since we have no other intercept point like we do in the
>>> filesystem-dax case to hide this flush.
>>
>> Look at the block layer.  You can issue an ioctl on a block device, and
>> if the generic block layer can handle it, it does.  If not, it gets
>> passed down to lower layers until either it gets handled, or it bubbles
>> back up because nobody knew what to do with it.  I think you can do the
>> same thing here, and that solves your layering violation.
>
> So this is where I started. I was going to follow the block layer.
> Except recently the block layer has been leaning away from ioctls and
> implementing support for syscalls directly. The same approach for
> device-dax fallocate() support got NAKd, so I opted for sysfs out of
> the gate.
>
> However, since there really is no analog for "deep flush" in the
> syscall namespace lets (*gag*) implement an ioctl for this.

So I think about it for 2 seconds and now I'm veering back to sysfs.
We don't want applications calling this ioctl on filesystem-dax fds. I
simply can't bring myself to do the work to pick a unique ioctl number
that is known to be unique for the full filsystem and block-layer
paths when we can put this interface right where it belongs in nvdimm
specific sysfs.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
