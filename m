Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x244.google.com (mail-io0-x244.google.com
 [IPv6:2607:f8b0:4001:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 30B1E81E56
 for <linux-nvdimm@lists.01.org>; Tue, 22 Nov 2016 13:03:11 -0800 (PST)
Received: by mail-io0-x244.google.com with SMTP id k19so12860894iod.3
 for <linux-nvdimm@lists.01.org>; Tue, 22 Nov 2016 13:03:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a99fd9ea-64d8-c5d3-0b96-f96c92369601@amd.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <CAPcyv4htu4gayz_Dpe0pnfLN4v_Kcy-fTx3B-HEfadCHvzJnhA@mail.gmail.com>
 <CAKMK7uGoXAYoazyGLbGU7svVD10WmaBtpko8BpHeNpRhST8F7g@mail.gmail.com>
 <a99fd9ea-64d8-c5d3-0b96-f96c92369601@amd.com>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Tue, 22 Nov 2016 22:03:09 +0100
Message-ID: <CAKMK7uF+k5LvcPEHvtdcXQFrpKVbFxwZ32EexoU3rZ9LFhVSow@mail.gmail.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
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
To: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, Dave Hansen <dave.hansen@linux.intel.com>, Blinzer, Paul" <Paul.Blinzer@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sander,, Suravee, Alexander, "Christian  <Christian.Koenig@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 22, 2016 at 9:35 PM, Serguei Sagalovitch
<serguei.sagalovitch@amd.com> wrote:
>
> On 2016-11-22 03:10 PM, Daniel Vetter wrote:
>>
>> On Tue, Nov 22, 2016 at 9:01 PM, Dan Williams <dan.j.williams@intel.com>
>> wrote:
>>>
>>> On Tue, Nov 22, 2016 at 10:59 AM, Serguei Sagalovitch
>>> <serguei.sagalovitch@amd.com> wrote:
>>>>
>>>> I personally like "device-DAX" idea but my concerns are:
>>>>
>>>> -  How well it will co-exists with the  DRM infrastructure /
>>>> implementations
>>>>     in part dealing with CPU pointers?
>>>
>>> Inside the kernel a device-DAX range is "just memory" in the sense
>>> that you can perform pfn_to_page() on it and issue I/O, but the vma is
>>> not migratable. To be honest I do not know how well that co-exists
>>> with drm infrastructure.
>>>
>>>> -  How well we will be able to handle case when we need to
>>>> "move"/"evict"
>>>>     memory/data to the new location so CPU pointer should point to the
>>>> new
>>>> physical location/address
>>>>      (and may be not in PCI device memory at all)?
>>>
>>> So, device-DAX deliberately avoids support for in-kernel migration or
>>> overcommit. Those cases are left to the core mm or drm. The device-dax
>>> interface is for cases where all that is needed is a direct-mapping to
>>> a statically-allocated physical-address range be it persistent memory
>>> or some other special reserved memory range.
>>
>> For some of the fancy use-cases (e.g. to be comparable to what HMM can
>> pull off) I think we want all the magic in core mm, i.e. migration and
>> overcommit. At least that seems to be the very strong drive in all
>> general-purpose gpu abstractions and implementations, where memory is
>> allocated with malloc, and then mapped/moved into vram/gpu address
>> space through some magic,
>
> It is possible that there is other way around: memory is requested to be
> allocated and should be kept in vram for  performance reason but due
> to possible overcommit case we need at least temporally to "move" such
> allocation to system memory.

With migration I meant migrating both ways of course. And with stuff
like numactl we can also influence where exactly the malloc'ed memory
is allocated originally, at least if we'd expose the vram range as a
very special numa node that happens to be far away and not hold any
cpu cores.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
