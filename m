Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EC1E9211EABCE
 for <linux-nvdimm@lists.01.org>; Thu, 28 Mar 2019 06:38:20 -0700 (PDT)
Subject: Re: [PATCH v5 00/10] mm: Sub-section memory hotplug support
References: <155327387405.225273.9325594075351253804.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190322180532.GM32418@dhcp22.suse.cz>
 <CAPcyv4gBGNP95APYaBcsocEa50tQj9b5h__83vgngjq3ouGX_Q@mail.gmail.com>
 <20190325101945.GD9924@dhcp22.suse.cz>
 <CAPcyv4iJCgu-akJM_O8ZtscqWQt=CU-fvx-ViGYeau-NJufmSQ@mail.gmail.com>
 <20190326080408.GC28406@dhcp22.suse.cz>
 <CAPcyv4jUeUPwbfToWQtWX1AxfgFLNpBUhm8BvgJ2Hv1RbNPiog@mail.gmail.com>
 <20190327161306.GM11927@dhcp22.suse.cz>
From: David Hildenbrand <david@redhat.com>
Message-ID: <9e769f3d-00f2-a8bb-2d8d-097735cb2a6d@redhat.com>
Date: Thu, 28 Mar 2019 14:38:15 +0100
MIME-Version: 1.0
In-Reply-To: <20190327161306.GM11927@dhcp22.suse.cz>
Content-Language: en-US
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
To: Michal Hocko <mhocko@kernel.org>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, stable <stable@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On 27.03.19 17:13, Michal Hocko wrote:
> On Tue 26-03-19 17:20:41, Dan Williams wrote:
>> On Tue, Mar 26, 2019 at 1:04 AM Michal Hocko <mhocko@kernel.org> wrote:
>>>
>>> On Mon 25-03-19 13:03:47, Dan Williams wrote:
>>>> On Mon, Mar 25, 2019 at 3:20 AM Michal Hocko <mhocko@kernel.org> wrote:
>>> [...]
>>>>>> User-defined memory namespaces have this problem, but 2MB is the
>>>>>> default alignment and is sufficient for most uses.
>>>>>
>>>>> What does prevent users to go and use a larger alignment?
>>>>
>>>> Given that we are living with 64MB granularity on mainstream platforms
>>>> for the foreseeable future, the reason users can't rely on a larger
>>>> alignment to address the issue is that the physical alignment may
>>>> change from one boot to the next.
>>>
>>> I would love to learn more about this inter boot volatility. Could you
>>> expand on that some more? I though that the HW configuration presented
>>> to the OS would be more or less stable unless the underlying HW changes.
>>
>> Even if the configuration is static there can be hardware failures
>> that prevent a DIMM, or a PCI device to be included in the memory map.
>> When that happens the BIOS needs to re-layout the map and the result
>> is not guaranteed to maintain the previous alignment.
>>
>>>> No, you can't just wish hardware / platform firmware won't do this,
>>>> because there are not enough platform resources to give every hardware
>>>> device a guaranteed alignment.
>>>
>>> Guarantee is one part and I can see how nobody wants to give you
>>> something as strong but how often does that happen in the real life?
>>
>> I expect a "rare" event to happen everyday in a data-center fleet.
>> Failure rates tend towards 100% daily occurrence at scale and in this
>> case the kernel has everything it needs to mitigate such an event.
>>
>> Setting aside the success rate of a software-alignment mitigation, the
>> reason I am charging this hill again after a 2 year hiatus is the
>> realization that this problem is wider spread than the original
>> failing scenario. Back in 2017 the problem seemed limited to custom
>> memmap= configurations, and collisions between PMEM and System RAM.
>> Now it is clear that the collisions can happen between PMEM regions
>> and namespaces as well, and the problem spans platforms from multiple
>> vendors. Here is the most recent collision problem:
>> https://github.com/pmem/ndctl/issues/76, from a third-party platform.
>>
>> The fix for that issue uncovered a bug in the padding implementation,
>> and a fix for that bug would result in even more hacks in the nvdimm
>> code for what is a core kernel deficiency. Code review of those
>> changes resulted in changing direction to go after the core
>> deficiency.
> 
> This kind of information along with real world examples is exactly what
> you should have added into the cover letter. A previous very vague
> claims were not really convincing or something that can be considered a
> proper justification. Please do realize that people who are not working
> with the affected HW are unlikely to have an idea how serious/relevant
> those problems really are.
> 
> People are asking for a smaller memory hotplug granularity for other
> usecases (e.g. memory ballooning into VMs) which are quite dubious to
> be honest and not really worth all the code rework. If we are talking
> about something that can be worked around elsewhere then it is preferred
> because the code base is not in an excellent shape and putting more on
> top is just going to cause more headaches.

At least for virtio-mem, it will be handled similar to xen-balloon and
hyper-v balloon, where whole actions are added and some parts are kept
"soft-offline". But there, one device "owns" the complete section, it
does not overlap with other devices. One section only has one owner.

As we discussed a similar approach back then with virtio-mem
(online/offline of smaller blocks), you had a pretty good point that
such complexity is better avoided in core MM. Sections really seem to be
the granularity with which core MM should work. At least speaking about
!pmem memory hotplug.

> 
> I will try to find some time to review this more deeply (no promises
> though because time is hectic and this is not a simple feature). For the
> future, please try harder to write up a proper justification and a
> highlevel design description which tells a bit about all important parts
> of the new scheme.
> 


-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
