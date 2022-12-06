Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8808BEB
	for <nvdimm@lists.linux.dev>; Tue,  6 Dec 2022 15:17:53 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DE4023A;
	Tue,  6 Dec 2022 07:17:59 -0800 (PST)
Received: from [10.1.197.38] (eglon.cambridge.arm.com [10.1.197.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C2E63F73B;
	Tue,  6 Dec 2022 07:17:51 -0800 (PST)
Message-ID: <40cd479b-f0f8-5dba-0e41-4cef73693927@arm.com>
Date: Tue, 6 Dec 2022 15:17:43 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 5/5] cxl/region: Manage CPU caches relative to DPA
 invalidation events
Content-Language: en-GB
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
 Dan Williams <dan.j.williams@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, linux-cxl@vger.kernel.org,
 dave.jiang@intel.com, nvdimm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 catalin.marinas@arm.com, Anshuman Khandual <anshuman.khandual@arm.com>,
 anthony.jebson@huawei.com, ardb@kernel.org
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
 <166993222098.1995348.16604163596374520890.stgit@dwillia2-xfh.jf.intel.com>
 <20221205192054.mwhzyjrfwfn3tma5@offworld>
 <638e502e1904a_3cbe0294e2@dwillia2-xfh.jf.intel.com.notmuch>
 <20221206094733.00007ed2@Huawei.com>
From: James Morse <james.morse@arm.com>
In-Reply-To: <20221206094733.00007ed2@Huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi guys,

On 06/12/2022 09:47, Jonathan Cameron wrote:
> On Mon, 5 Dec 2022 12:10:22 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
>> [ add linux-arm-kernel@lists.infradead.org ]
>>
>> Background for ARM folks, CXL can dynamically reconfigure the target
>> devices that back a given physical memory region. When that happens the
>> CPU cache can be holding cache data from a previous configuration. The
>> mitigation for that scenario on x86 is wbinvd, ARM does not have an
>> equivalent. The result, dynamic region creation is disabled on ARM. In
>> the near term, most CXL is configured pre-boot, but going forward this
>> restriction is untenable.
>>
>> Davidlohr Bueso wrote:
>>> On Thu, 01 Dec 2022, Dan Williams wrote:
>>>   
>>>> A "DPA invalidation event" is any scenario where the contents of a DPA
>>>> (Device Physical Address) is modified in a way that is incoherent with
>>>> CPU caches, or if the HPA (Host Physical Address) to DPA association
>>>> changes due to a remapping event.
>>>>
>>>> PMEM security events like Unlock and Passphrase Secure Erase already
>>>> manage caches through LIBNVDIMM,  
>>>
>>> Just to be clear, is this is why you get rid of the explicit flushing
>>> for the respective commands in security.c?  
>>
>> Correct, because those commands can only be executed through libnvdimm.
>>
>>>   
>>>> so that leaves HPA to DPA remap events
>>>> that need cache management by the CXL core. Those only happen when the
>>>> boot time CXL configuration has changed. That event occurs when
>>>> userspace attaches an endpoint decoder to a region configuration, and
>>>> that region is subsequently activated.
>>>>
>>>> The implications of not invalidating caches between remap events is that
>>>> reads from the region at different points in time may return different
>>>> results due to stale cached data from the previous HPA to DPA mapping.
>>>> Without a guarantee that the region contents after cxl_region_probe()
>>>> are written before being read (a layering-violation assumption that
>>>> cxl_region_probe() can not make) the CXL subsystem needs to ensure that
>>>> reads that precede writes see consistent results.  
>>>
>>> Hmm where does this leave us remaping under arm64 which is doesn't have
>>> ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION?

For those reading along at home, ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION is wbinvd.
https://lore.kernel.org/linux-cxl/20220919110605.3696-1-dave@stgolabs.net/

We don't have an instruction for arm64 that 'invalidates all caches'.


>>> Back when we were discussing this it was all related to the security stuff,
>>> which under arm it could just be easily discarded as not available feature.  
>>
>> I can throw out a few strawman options, but really need help from ARM
>> folks to decide where to go next.

> +Cc bunch of relevant people. There are discussions underway but I'm not sure
> anyone will want to give more details here yet.

The best we can do today is to use the by-VA invalidate operations in the kernel.
This isn't guaranteed to invalidate 'invisible' system caches, which means its not enough
for a one-size-fits-all kernel interface.
For the NVDIMM secure-erase users of this thing, if there were a system-cache between the
CPUs and the NVDIMM, there is nothing the kernel can do to invalidate it.

If its CXL specific this would be okay for testing in Qemu, but performance would scale
with the size of the region, which would hurt in real world cases.

The plan is to add a firmware call so firmware can do things that don't scale with the
size of the mapping, and do something platform-specific to the 'invisible' system cache,
if there is one.


Ideally we wait for the PSCI spec update that describes the firmware call, and make
support dependent on that. It looks like the timeline will be March-ish, but there should
be an alpha of the spec available much sooner.


>> 1/ Map and loop cache flushing line by line. It works, but for Terabytes
>>    of CXL the cost is 10s of seconds of latency to reconfigure a region.
>>    That said, region configuration, outside of test scenarios, is typically
>>    a "once per bare metal provisioning" event.

It works for CXL because you'd never have a system-cache in front of the CXL window.
Those things don't necessarily receive cache-maintenance because they are supposed to be
invisible.

D7.4.11 of DDI0487I.a "System level caches" has this horror:
| System caches which lie beyond the point of coherency and so are invisible to the
| software. The management of such caches is outside the scope of the architecture.

(The PoP stuff reaches beyond the PoC, but there isn't a DC CIVAP instruction)

Detecting which regions we can't do this for is problematic.


>> 2/ Set a configuration dependency that mandates that all CXL memory be
>>    routed through the page allocator where it is guaranteed that the memory
>>    will be written (zeroed) before use. This restricts some planned use
>>    cases for the "Dynamic Capacity Device" capability.

> This is the only case that's really a problem (to my mind) I hope we will have
> a more general solution before there is much hardware out there, particularly
> where sharing is involved. 


Thanks,

James


>> 3/ Work with the CXL consortium to extend the back-invalidate concept
>>    for general purpose usage to make devices capable of invalidating caches
>>    for a new memory region they joined, and mandate it for ARM. This one
>>    has a long lead time and a gap for every device in flight currently.
> 
> There are significant disadvantages in doing this that I suspect will mean
> this never happens for some classes of device, or is turned off for performance
> reasons. For anyone curious, go look at the protocol requirements of back
> invalidate in the CXL 3.0 spec.
> 
> Jonathan

