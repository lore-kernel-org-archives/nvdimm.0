Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 725C721159902
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 08:41:25 -0700 (PDT)
Subject: Re: [PATCH v5 4/4] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
References: <20180925200551.3576.18755.stgit@localhost.localdomain>
 <20180925202053.3576.66039.stgit@localhost.localdomain>
 <20180926075540.GD6278@dhcp22.suse.cz>
 <6f87a5d7-05e2-00f4-8568-bb3521869cea@linux.intel.com>
 <20180927110926.GE6278@dhcp22.suse.cz>
 <20180927122537.GA20378@techadventures.net>
 <20180927131329.GI6278@dhcp22.suse.cz>
 <20180927145035.GA21373@techadventures.net>
From: David Hildenbrand <david@redhat.com>
Message-ID: <27f1265b-a8b4-b203-077b-468d1e823cc8@redhat.com>
Date: Thu, 27 Sep 2018 17:41:19 +0200
MIME-Version: 1.0
In-Reply-To: <20180927145035.GA21373@techadventures.net>
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
To: Oscar Salvador <osalvador@techadventures.net>, Michal Hocko <mhocko@kernel.org>
Cc: pavel.tatashin@microsoft.com, linux-nvdimm@lists.01.org, dave.hansen@intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-mm@kvack.org, jglisse@redhat.com, rppt@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, Alexander Duyck <alexander.h.duyck@linux.intel.com>, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On 27/09/2018 16:50, Oscar Salvador wrote:
> On Thu, Sep 27, 2018 at 03:13:29PM +0200, Michal Hocko wrote:
>> On Thu 27-09-18 14:25:37, Oscar Salvador wrote:
>>> On Thu, Sep 27, 2018 at 01:09:26PM +0200, Michal Hocko wrote:
>>>>> So there were a few things I wasn't sure we could pull outside of the
>>>>> hotplug lock. One specific example is the bits related to resizing the pgdat
>>>>> and zone. I wanted to avoid pulling those bits outside of the hotplug lock.
>>>>
>>>> Why would that be a problem. There are dedicated locks for resizing.
>>>
>>> True is that move_pfn_range_to_zone() manages the locks for pgdat/zone resizing,
>>> but it also takes care of calling init_currently_empty_zone() in case the zone is empty.
>>> Could not that be a problem if we take move_pfn_range_to_zone() out of the lock?
>>
>> I would have to double check but is the hotplug lock really serializing
>> access to the state initialized by init_currently_empty_zone? E.g.
>> zone_start_pfn is a nice example of a state that is used outside of the
>> lock. zone's free lists are similar. So do we really need the hoptlug
>> lock? And more broadly, what does the hotplug lock is supposed to
>> serialize in general. A proper documentation would surely help to answer
>> these questions. There is way too much of "do not touch this code and
>> just make my particular hack" mindset which made the whole memory
>> hotplug a giant pile of mess. We really should start with some proper
>> engineering here finally.
> 
> CC David
> 
> David has been looking into this lately, he even has updated memory-hotplug.txt
> with some more documentation about the locking aspect [1].
> And with this change [2], the hotplug lock has been moved
> to the online/offline_pages.
> 
> From what I see (I might be wrong), the hotplug lock is there
> to serialize the online/offline operations.

mem_hotplug_lock is especially relevant for users of
get_online_mems/put_online_mems. Whatever affects them, you can't move
out of the lock.

Everything else is theoretically serialized via device_hotplug_lock now.

> 
> In online_pages, we do (among other things):
> 
> a) initialize the zone and its pages, and link them to the zone
> b) re-adjust zone/pgdat nr of pages (present, spanned, managed)
> b) check if the node changes in regard of N_MEMORY, N_HIGH_MEMORY or N_NORMAL_MEMORY.
> c) fire notifiers
> d) rebuild the zonelists in case we got a new zone
> e) online memory sections and free the pages to the buddy allocator
> f) wake up kswapd/kcompactd in case we got a new node
> 
> while in offline_pages we do the opposite.
> 
> Hotplug lock here serializes the operations as a whole, online and offline memory,
> so they do not step on each other's feet.
> 
> Having said that, we might be able to move some of those operations out of the hotplug lock.
> The device_hotplug_lock coming from every memblock (which is taken in device_online/device_offline) should protect
> us against some operations being made on the same memblock (e.g: touching the same pages).

Yes, very right.


-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
