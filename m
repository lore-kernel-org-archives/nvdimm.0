Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9321E2116746B
 for <linux-nvdimm@lists.01.org>; Wed, 17 Oct 2018 08:02:21 -0700 (PDT)
Subject: Re: [PATCH v5 4/4] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
References: <20181009170051.GA40606@tiger-server>
 <CAPcyv4g99_rJJSn0kWv5YO0Mzj90q1LH1wC3XrjCh1=x6mo7BQ@mail.gmail.com>
 <25092df0-b7b4-d456-8409-9c004cb6e422@linux.intel.com>
 <20181010095838.GG5873@dhcp22.suse.cz>
 <f97de51c-67dd-99b2-754e-0685cac06699@linux.intel.com>
 <20181010172451.GK5873@dhcp22.suse.cz>
 <98c35e19-13b9-0913-87d9-b3f1ab738b61@linux.intel.com>
 <20181010185242.GP5873@dhcp22.suse.cz> <20181011085509.GS5873@dhcp22.suse.cz>
 <6f32f23c-c21c-9d42-7dda-a1d18613cd3c@linux.intel.com>
 <20181017075257.GF18839@dhcp22.suse.cz>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <971729e6-bcfe-a386-361b-d662951e69a7@linux.intel.com>
Date: Wed, 17 Oct 2018 08:02:20 -0700
MIME-Version: 1.0
In-Reply-To: <20181017075257.GF18839@dhcp22.suse.cz>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: Pasha Tatashin <pavel.tatashin@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, rppt@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 10/17/2018 12:52 AM, Michal Hocko wrote:
> On Thu 11-10-18 10:38:39, Alexander Duyck wrote:
>> On 10/11/2018 1:55 AM, Michal Hocko wrote:
>>> On Wed 10-10-18 20:52:42, Michal Hocko wrote:
>>> [...]
>>>> My recollection was that we do clear the reserved bit in
>>>> move_pfn_range_to_zone and we indeed do in __init_single_page. But then
>>>> we set the bit back right afterwards. This seems to be the case since
>>>> d0dc12e86b319 which reorganized the code. I have to study this some more
>>>> obviously.
>>>
>>> so my recollection was wrong and d0dc12e86b319 hasn't really changed
>>> much because __init_single_page wouldn't zero out the struct page for
>>> the hotplug contex. A comment in move_pfn_range_to_zone explains that we
>>> want the reserved bit because pfn walkers already do see the pfn range
>>> and the page is not fully associated with the zone until it is onlined.
>>>
>>> I am thinking that we might be overzealous here. With the full state
>>> initialized we shouldn't actually care. pfn_to_online_page should return
>>> NULL regardless of the reserved bit and normal pfn walkers shouldn't
>>> touch pages they do not recognize and a plain page with ref. count 1
>>> doesn't tell much to anybody. So I _suspect_ that we can simply drop the
>>> reserved bit setting here.
>>
>> So this has me a bit hesitant to want to just drop the bit entirely. If
>> nothing else I think I may wan to make that a patch onto itself so that if
>> we aren't going to set it we just drop it there. That way if it does cause
>> issues we can bisect it to that patch and pinpoint the cause.
> 
> Yes a patch on its own make sense for bisectability.

For now I think I am going to back off of this. There is a bunch of 
other changes that need to happen in order for us to make this work. As 
far as I can tell there are several places that are relying on this 
reserved bit.

>>> Regarding the post initialization required by devm_memremap_pages and
>>> potentially others. Can we update the altmap which is already a way how
>>> to get alternative struct pages by a constructor which we could call
>>> from memmap_init_zone and do the post initialization? This would reduce
>>> the additional loop in the caller while it would still fit the overall
>>> design of the altmap and the core hotplug doesn't have to know anything
>>> about DAX or whatever needs a special treatment.
>>>
>>> Does that make any sense?
>>
>> I think the only thing that is currently using the altmap is the ZONE_DEVICE
>> memory init. Specifically I think it is only really used by the
>> devm_memremap_pages version of things, and then only under certain
>> circumstances. Also the HMM driver doesn't pass an altmap. What we would
>> really need is a non-ZONE_DEVICE users of the altmap to really justify
>> sticking with that as the preferred argument to pass.
> 
> I am not aware of any upstream HMM user so I am not sure what are the
> expectations there. But I thought that ZONE_DEVICE users use altmap. If
> that is not generally true then we certainly have to think about a
> better interface.

I'm just basing my statement on the use of the move_pfn_range_to_zone 
call. The only caller that is actually passing the altmap is 
devm_memremap_pages and if I understand things correctly that is only 
used when we want to stare the vmmemmap on the same memory that we just 
hotplugged.

That is why it made more sense to me to just create a ZONE_DEVICE 
specific function for handling the page initialization because the one 
value I do have to pass is the dev_pagemap in both HMM and memremap 
case, and that has the altmap already embedded inside of it.

>> For those two functions it currently makes much more sense to pass the
>> dev_pagemap pointer and then reference the altmap from there. Otherwise we
>> are likely starting to look at something that would be more of a dirty hack
>> where we are passing a unused altmap in order to get to the dev_pagemap so
>> that we could populate the page.
> 
> If dev_pagemap is a general abstraction then I agree.

Well so far HMM and the memremap code have both agreed to use that 
structure to store the metadata for ZONE_DEVICE mappings, and at this 
point we are already looking at 3 different memory types being stored 
within that zone as we already have the private, public, and DAX memory 
types all using this structure.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
