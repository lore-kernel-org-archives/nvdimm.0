Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C3058211EB82D
 for <linux-nvdimm@lists.01.org>; Thu, 28 Mar 2019 14:54:38 -0700 (PDT)
Subject: Re: [PATCH v5 00/10] mm: Sub-section memory hotplug support
References: <155327387405.225273.9325594075351253804.stgit@dwillia2-desk3.amr.corp.intel.com>
 <cf304a31-70a6-e701-ec3e-c47dc84b81d2@redhat.com>
 <CAPcyv4hgAM=ex0B4EBZ40RNf=bXk2WkEzySTUV4ZzOWd_HZwSQ@mail.gmail.com>
 <24c163f2-3b78-827f-257e-70e5a9655806@redhat.com>
 <CAPcyv4ivBagzsZ1fCDb2Cr3scz+R8ZVgyie5c=LWNd6QZuw36g@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <b76b3a91-a0b5-460d-df5c-9358e6219915@redhat.com>
Date: Thu, 28 Mar 2019 22:54:34 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ivBagzsZ1fCDb2Cr3scz+R8ZVgyie5c=LWNd6QZuw36g@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, stable <stable@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

>>>> Reason I am asking is because I wonder how that would interact with the
>>>> memory block device infrastructure and hotplugging of system ram -
>>>> add_memory()/add_memory_resource(). I *assume* you are not changing the
>>>> add_memory() interface, so that one still only works with whole sections
>>>> (or well, memory_block_size_bytes()) - check_hotplug_memory_range().
>>>
>>> Like you found below, the implementation enforces that add_memory_*()
>>> interfaces maintain section alignment for @start and @size.
>>>
>>>> In general, mix and matching system RAM and persistent memory per
>>>> section, I am not a friend of that.
>>>
>>> You have no choice. The platform may decide to map PMEM and System RAM
>>> in the same section because the Linux section is too large compared to
>>> typical memory controller mapping granularity capability.
>>
>> I might be very wrong here, but do we actually care about something like
>> 64MB getting lost in the cracks? I mean if it simplifies core MM, let go
>> of the couple of MB of system ram and handle the PMEM part only. Treat
>> the system ram parts like memory holes we already have in ordinary
>> sections (well, there we simply set the relevant struct pages to
>> PG_reserved). Of course, if we have hundreds of unaligned devices and
>> stuff will start to add up ... but I assume this is not the case?
> 
> That's precisely what we do today and it has become untenable as the
> collision scenarios pile up. This thread [1] is worth a read if you
> care about  some of the gory details why I'm back to pushing for
> sub-section support, but most if it has already been summarized in the
> current discussion on this thread.

Thanks, exactly what I am interested in, will have a look!

>>>
>>> I don't see a strong reason why not, as long as it does not regress
>>> existing use cases. It might need to be an opt-in for new tooling that
>>> is aware of finer granularity hotplug. That said, I have no pressing
>>> need to go there and just care about the arch_add_memory() capability
>>> for now.
>>
>> Especially onlining/offlining of memory might end up very ugly. And that
>> goes hand in hand with memory block devices. They are either online or
>> offline, not something in between. (I went that path and Michal
>> correctly told me why it is not a good idea)
> 
> Thread reference?

Sure:

https://marc.info/?l=linux-mm&m=152362539714432&w=2

Onlining/offlining subsections was what I tried. (adding/removing whole
sections). But with the memory block device model (online/offline memory
blocks), this really was in some sense dirty, although it worked.

> 
>> I was recently trying to teach memory block devices who their owner is /
>> of which type they are. Right now I am looking into the option of using
>> drivers. Memory block devices that could belong to different drivers at
>> a time are well ... totally broken.
> 
> Sub-section support is aimed at a similar case where different
> portions of an 128MB span need to handed out to devices / drivers with
> independent lifetimes.

Right, but we are stuck here with memory block devices having certain
bigger granularity. We already went from 128MB to 2048MB because "there
were too many". Modeling this on 2MB level (e.g. subsections), no way.
And as I said, multiple users for one memory block device, very ugly.

What would be interesting is having memory block devices of variable
size. (64MB, 1024GB, 6GB ..), maybe even representing the unit in which
e.g. add_memory() was performed. But it would also have downsides when
it comes to changing the zone of memory blocks. Memory would be
onlined/offlined in way bigger chunks.

E.g. one DIMM = one memory block device.

> 
>> I assume it would still be a special
>> case, though, but conceptually speaking about the interface it would be
>> allowed.
>>
>> Memory block devices (and therefore 1..X sections) should have one owner
>> only. Anything else just does not fit.
> 
> Yes, but I would say the problem there is that the
> memory-block-devices interface design is showing its age and is being
> pressured with how systems want to deploy and use memory today.

Maybe, I guess the main "issue" started to pop up when different things
(RAM vs. PMEM) were started to be mapped into memory side by side. But
it is ABI, and basic kdump would completely break if removed. And of
course memory unplug and much more. It is a crucial part of how system
ram is handled today and might not at all be easy to replace.

-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
