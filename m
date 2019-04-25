Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA1CD2122B962
 for <linux-nvdimm@lists.01.org>; Thu, 25 Apr 2019 00:41:27 -0700 (PDT)
Subject: Re: [v2 2/2] device-dax: "Hotremove" persistent memory that is used
 like normal RAM
References: <20190421014429.31206-1-pasha.tatashin@soleen.com>
 <20190421014429.31206-3-pasha.tatashin@soleen.com>
 <4ad3c587-6ab8-1307-5a13-a3e73cf569a5@redhat.com>
 <CAPcyv4h3+hU=MmB=RCc5GZmjLW_ALoVg_C4Z7aw8NQ=1LzPKaw@mail.gmail.com>
 <CA+CK2bDB5o4+NMc7==_ipVAZoEo7fdrkjZ4etU0LUCqxnmN-Rg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <180d6250-8a6a-0b5d-642a-ec6648cb45b1@redhat.com>
Date: Thu, 25 Apr 2019 09:41:20 +0200
MIME-Version: 1.0
In-Reply-To: <CA+CK2bDB5o4+NMc7==_ipVAZoEo7fdrkjZ4etU0LUCqxnmN-Rg@mail.gmail.com>
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
To: Pavel Tatashin <pasha.tatashin@soleen.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Sasha Levin <sashal@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Takashi Iwai <tiwai@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Huang, Ying" <ying.huang@intel.com>, James Morris <jmorris@namei.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Borislav Petkov <bp@suse.de>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Ross Zwisler <zwisler@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 24.04.19 23:34, Pavel Tatashin wrote:
>>>> +static int
>>>> +offline_memblock_cb(struct memory_block *mem, void *arg)
>>>
>>> Function name suggests that you are actually trying to offline memory
>>> here. Maybe check_memblocks_offline_cb(), just like we have in
>>> mm/memory_hotplug.c.
> 
> Makes sense, I will rename to check_memblocks_offline_cb()
> 
>>>> +     lock_device_hotplug();
>>>> +     rc = walk_memory_range(start_pfn, end_pfn, dev, offline_memblock_cb);
>>>> +     unlock_device_hotplug();
>>>> +
>>>> +     /*
>>>> +      * If admin has not offlined memory beforehand, we cannot hotremove dax.
>>>> +      * Unfortunately, because unbind will still succeed there is no way for
>>>> +      * user to hotremove dax after this.
>>>> +      */
>>>> +     if (rc)
>>>> +             return rc;
>>>
>>> Can't it happen that there is a race between you checking if memory is
>>> offline and an admin onlining memory again? maybe pull the
>>> remove_memory() into the locked region, using __remove_memory() instead.
>>
>> I think the race is ok. The admin gets to keep the pieces of allowing
>> racing updates to the state and the kernel will keep the range active
>> until the next reboot.
> 
> Thank you for noticing this. I will pull it into locking region.
> Because, __remove_memory() has this code:
> 
> 1868   ret = walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1), NULL,
> 1869   check_memblock_offlined_cb);
> 1870   if (ret)
> 1871      BUG();
> 

Yes, also I think you can let go of the device_lock in
check_memblocks_offline_cb, lock_device_hotplug() should take care of
this (see Documentation/core-api/memory-hotplug.rst - "locking internals")

Cheers!

-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
