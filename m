Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CC66121B02822
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 11:25:37 -0700 (PDT)
Subject: Re: [PATCH v5 4/4] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
References: <20180925200551.3576.18755.stgit@localhost.localdomain>
 <20180925202053.3576.66039.stgit@localhost.localdomain>
 <20180926075540.GD6278@dhcp22.suse.cz>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <6f87a5d7-05e2-00f4-8568-bb3521869cea@linux.intel.com>
Date: Wed, 26 Sep 2018 11:25:37 -0700
MIME-Version: 1.0
In-Reply-To: <20180926075540.GD6278@dhcp22.suse.cz>
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
Cc: pavel.tatashin@microsoft.com, linux-nvdimm@lists.01.org, dave.hansen@intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-mm@kvack.org, jglisse@redhat.com, rppt@linux.vnet.ibm.com, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>



On 9/26/2018 12:55 AM, Michal Hocko wrote:
> On Tue 25-09-18 13:21:24, Alexander Duyck wrote:
>> The ZONE_DEVICE pages were being initialized in two locations. One was with
>> the memory_hotplug lock held and another was outside of that lock. The
>> problem with this is that it was nearly doubling the memory initialization
>> time. Instead of doing this twice, once while holding a global lock and
>> once without, I am opting to defer the initialization to the one outside of
>> the lock. This allows us to avoid serializing the overhead for memory init
>> and we can instead focus on per-node init times.
>>
>> One issue I encountered is that devm_memremap_pages and
>> hmm_devmmem_pages_create were initializing only the pgmap field the same
>> way. One wasn't initializing hmm_data, and the other was initializing it to
>> a poison value. Since this is something that is exposed to the driver in
>> the case of hmm I am opting for a third option and just initializing
>> hmm_data to 0 since this is going to be exposed to unknown third party
>> drivers.
> 
> Why cannot you pull move_pfn_range_to_zone out of the hotplug lock? In
> other words why are you making zone device even more special in the
> generic hotplug code when it already has its own means to initialize the
> pfn range by calling move_pfn_range_to_zone. Not to mention the code
> duplication.

So there were a few things I wasn't sure we could pull outside of the 
hotplug lock. One specific example is the bits related to resizing the 
pgdat and zone. I wanted to avoid pulling those bits outside of the 
hotplug lock.

The other bit that I left inside the hot-plug lock with this approach 
was the initialization of the pages that contain the vmemmap.

> That being said I really dislike this patch.

In my mind this was a patch that "killed two birds with one stone". I 
had two issues to address, the first one being the fact that we were 
performing the memmap_init_zone while holding the hotplug lock, and the 
other being the loop that was going through and initializing pgmap in 
the hmm and memremap calls essentially added another 20 seconds 
(measured for 3TB of memory per node) to the init time. With this patch 
I was able to cut my init time per node by that 20 seconds, and then 
made it so that we could scale as we added nodes as they could run in 
parallel.

With that said I am open to suggestions if you still feel like I need to 
follow this up with some additional work. I just want to avoid 
introducing any regressions in regards to functionality or performance.

Thanks.

- Alex


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
