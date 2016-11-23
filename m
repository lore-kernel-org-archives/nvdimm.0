Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-BL2-obe.outbound.protection.outlook.com
 (mail-bl2nam02on0622.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe46::622])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C2ED281E1F
 for <linux-nvdimm@lists.01.org>; Wed, 23 Nov 2016 11:27:13 -0800 (PST)
Subject: Re: Enabling peer to peer device transactions for PCIe devices
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <CAPcyv4htu4gayz_Dpe0pnfLN4v_Kcy-fTx3B-HEfadCHvzJnhA@mail.gmail.com>
 <CAKMK7uGoXAYoazyGLbGU7svVD10WmaBtpko8BpHeNpRhST8F7g@mail.gmail.com>
 <a99fd9ea-64d8-c5d3-0b96-f96c92369601@amd.com>
 <CAKMK7uF+k5LvcPEHvtdcXQFrpKVbFxwZ32EexoU3rZ9LFhVSow@mail.gmail.com>
 <CAPcyv4ind0fxek7g25MX=49rDfT5X151tb4=TYudMBmUJFZZNQ@mail.gmail.com>
 <20161123074902.ph7a5cmlw3pclugx@phenom.ffwll.local>
 <2a8a6582-f3de-5cda-0c6e-1c93774147e0@amd.com>
From: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Message-ID: <6ed2c861-7493-902b-bfbd-9c937a3efba3@amd.com>
Date: Wed, 23 Nov 2016 14:27:06 -0500
MIME-Version: 1.0
In-Reply-To: <2a8a6582-f3de-5cda-0c6e-1c93774147e0@amd.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Kuehling, Felix" <Felix.Kuehling@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "Sander, Ben" <ben.sander@amd.com>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, Deucher,, Paul  <Paul.Blinzer@amd.com>, "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>


On 2016-11-23 03:51 AM, Christian K=F6nig wrote:
> Am 23.11.2016 um 08:49 schrieb Daniel Vetter:
>> On Tue, Nov 22, 2016 at 01:21:03PM -0800, Dan Williams wrote:
>>> On Tue, Nov 22, 2016 at 1:03 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
>>>> On Tue, Nov 22, 2016 at 9:35 PM, Serguei Sagalovitch
>>>> <serguei.sagalovitch@amd.com> wrote:
>>>>> On 2016-11-22 03:10 PM, Daniel Vetter wrote:
>>>>>> On Tue, Nov 22, 2016 at 9:01 PM, Dan Williams =

>>>>>> <dan.j.williams@intel.com>
>>>>>> wrote:
>>>>>>> On Tue, Nov 22, 2016 at 10:59 AM, Serguei Sagalovitch
>>>>>>> <serguei.sagalovitch@amd.com> wrote:
>>>>>>>> I personally like "device-DAX" idea but my concerns are:
>>>>>>>>
>>>>>>>> -  How well it will co-exists with the  DRM infrastructure /
>>>>>>>> implementations
>>>>>>>>      in part dealing with CPU pointers?
>>>>>>> Inside the kernel a device-DAX range is "just memory" in the sense
>>>>>>> that you can perform pfn_to_page() on it and issue I/O, but the =

>>>>>>> vma is
>>>>>>> not migratable. To be honest I do not know how well that co-exists
>>>>>>> with drm infrastructure.
>>>>>>>
>>>>>>>> -  How well we will be able to handle case when we need to
>>>>>>>> "move"/"evict"
>>>>>>>>      memory/data to the new location so CPU pointer should =

>>>>>>>> point to the
>>>>>>>> new
>>>>>>>> physical location/address
>>>>>>>>       (and may be not in PCI device memory at all)?
>>>>>>> So, device-DAX deliberately avoids support for in-kernel =

>>>>>>> migration or
>>>>>>> overcommit. Those cases are left to the core mm or drm. The =

>>>>>>> device-dax
>>>>>>> interface is for cases where all that is needed is a =

>>>>>>> direct-mapping to
>>>>>>> a statically-allocated physical-address range be it persistent =

>>>>>>> memory
>>>>>>> or some other special reserved memory range.
>>>>>> For some of the fancy use-cases (e.g. to be comparable to what =

>>>>>> HMM can
>>>>>> pull off) I think we want all the magic in core mm, i.e. =

>>>>>> migration and
>>>>>> overcommit. At least that seems to be the very strong drive in all
>>>>>> general-purpose gpu abstractions and implementations, where =

>>>>>> memory is
>>>>>> allocated with malloc, and then mapped/moved into vram/gpu address
>>>>>> space through some magic,
>>>>> It is possible that there is other way around: memory is requested =

>>>>> to be
>>>>> allocated and should be kept in vram for  performance reason but due
>>>>> to possible overcommit case we need at least temporally to "move" =

>>>>> such
>>>>> allocation to system memory.
>>>> With migration I meant migrating both ways of course. And with stuff
>>>> like numactl we can also influence where exactly the malloc'ed memory
>>>> is allocated originally, at least if we'd expose the vram range as a
>>>> very special numa node that happens to be far away and not hold any
>>>> cpu cores.
>>> I don't think we should be using numa distance to reverse engineer a
>>> certain allocation behavior.  The latency data should be truthful, but
>>> you're right we'll need a mechanism to keep general purpose
>>> allocations out of that range by default. Btw, strict isolation is
>>> another design point of device-dax, but I think in this case we're
>>> describing something between the two extremes of full isolation and
>>> full compatibility with existing numactl apis.
>> Yes, agreed. My idea with exposing vram sections using numa nodes wasn't
>> to reuse all the existing allocation policies directly, those won't =

>> work.
>> So at boot-up your default numa policy would exclude any vram nodes.
>>
>> But I think (as an -mm layman) that numa gives us a lot of the tools and
>> policy interface that we need to implement what we want for gpus.
>
> Agree completely. From a ten mile high view our GPUs are just command =

> processors with local memory as well .
>
> Basically this is also the whole idea of what AMD is pushing with HSA =

> for a while.
>
> It's just that a lot of problems start to pop up when you look at all =

> the nasty details. For example only part of the GPU memory is usually =

> accessible by the CPU.
>
> So even when numa nodes expose a good foundation for this I think =

> there is still a lot of code to write.
>
> BTW: I should probably start to read into the numa code of the kernel. =

> Any good pointers for that?
I would assume that "page" allocation logic itself should be inside of =

graphics driver due to possible different requirements especially from =

graphics: alignment, etc.

>
> Regards,
> Christian.
>
>> Wrt isolation: There's a sliding scale of what different users expect,
>> from full auto everything, including migrating pages around if needed to
>> full isolation all seems to be on the table. As long as we keep vram =

>> nodes
>> out of any default allocation numasets, full isolation should be =

>> possible.
>> -Daniel
>
>

Sincerely yours,
Serguei Sagalovitch

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
