Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A599C21144CE3
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 09:39:09 -0700 (PDT)
Subject: Re: [PATCH v5 4/4] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
References: <20180925200551.3576.18755.stgit@localhost.localdomain>
 <20180925202053.3576.66039.stgit@localhost.localdomain>
 <20181009170051.GA40606@tiger-server>
 <CAPcyv4g99_rJJSn0kWv5YO0Mzj90q1LH1wC3XrjCh1=x6mo7BQ@mail.gmail.com>
 <25092df0-b7b4-d456-8409-9c004cb6e422@linux.intel.com>
 <20181010095838.GG5873@dhcp22.suse.cz>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <f97de51c-67dd-99b2-754e-0685cac06699@linux.intel.com>
Date: Wed, 10 Oct 2018 09:39:08 -0700
MIME-Version: 1.0
In-Reply-To: <20181010095838.GG5873@dhcp22.suse.cz>
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

On 10/10/2018 2:58 AM, Michal Hocko wrote:
> On Tue 09-10-18 13:26:41, Alexander Duyck wrote:
> [...]
>> I would think with that being the case we still probably need the call to
>> __SetPageReserved to set the bit with the expectation that it will not be
>> cleared for device-pages since the pages are not onlined. Removing the call
>> to __SetPageReserved would probably introduce a number of regressions as
>> there are multiple spots that use the reserved bit to determine if a page
>> can be swapped out to disk, mapped as system memory, or migrated.
> 
> PageReserved is meant to tell any potential pfn walkers that might get
> to this struct page to back off and not touch it. Even though
> ZONE_DEVICE doesn't online pages in traditional sense it makes those
> pages available for further use so the page reserved bit should be
> cleared.

So from what I can tell that isn't necessarily the case. Specifically if 
the pagemap type is MEMORY_DEVICE_PRIVATE or MEMORY_DEVICE_PUBLIC both 
are special cases where the memory may not be accessible to the CPU or 
cannot be pinned in order to allow for eviction.

The specific case that Dan and Yi are referring to is for the type 
MEMORY_DEVICE_FS_DAX. For that type I could probably look at not setting 
the reserved bit. Part of me wants to say that we should wait and clear 
the bit later, but that would end up just adding time back to 
initialization. At this point I would consider the change more of a 
follow-up optimization rather than a fix though since this is tailoring 
things specifically for DAX versus the other ZONE_DEVICE types.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
