Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 228C521129459
 for <linux-nvdimm@lists.01.org>; Tue, 11 Sep 2018 17:59:27 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id l82-v6so353790oih.11
 for <linux-nvdimm@lists.01.org>; Tue, 11 Sep 2018 17:59:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKgT0UdmkAXLdR6cfgmu-LcJUOO8a4qAS8zO3Bn+LwjJ9rT3pg@mail.gmail.com>
References: <20180910232615.4068.29155.stgit@localhost.localdomain>
 <20180910234354.4068.65260.stgit@localhost.localdomain>
 <CAPcyv4ja7=eUbwwJZhreexa9_7JyJotQwObrQm=nCEcgcfbWyw@mail.gmail.com>
 <CAKgT0UdmkAXLdR6cfgmu-LcJUOO8a4qAS8zO3Bn+LwjJ9rT3pg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 11 Sep 2018 17:59:25 -0700
Message-ID: <CAPcyv4iiR3JgHg+Xyw-zON4+66stf917kUqNBxMFFLwT=H14qg@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
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
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: pavel.tatashin@microsoft.com, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 11, 2018 at 5:51 PM, Alexander Duyck
<alexander.duyck@gmail.com> wrote:
> On Tue, Sep 11, 2018 at 3:35 PM Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> On Mon, Sep 10, 2018 at 4:43 PM, Alexander Duyck
>> <alexander.duyck@gmail.com> wrote:
>> >
>> > From: Alexander Duyck <alexander.h.duyck@intel.com>
>> >
>> > The ZONE_DEVICE pages were being initialized in two locations. One was with
>> > the memory_hotplug lock held and another was outside of that lock. The
>> > problem with this is that it was nearly doubling the memory initialization
>> > time. Instead of doing this twice, once while holding a global lock and
>> > once without, I am opting to defer the initialization to the one outside of
>> > the lock. This allows us to avoid serializing the overhead for memory init
>> > and we can instead focus on per-node init times.
>> >
>> > One issue I encountered is that devm_memremap_pages and
>> > hmm_devmmem_pages_create were initializing only the pgmap field the same
>> > way. One wasn't initializing hmm_data, and the other was initializing it to
>> > a poison value. Since this is something that is exposed to the driver in
>> > the case of hmm I am opting for a third option and just initializing
>> > hmm_data to 0 since this is going to be exposed to unknown third party
>> > drivers.
>> >
>> > Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
>> > ---
>> >  include/linux/mm.h |    2 +
>> >  kernel/memremap.c  |   24 +++++---------
>> >  mm/hmm.c           |   12 ++++---
>> >  mm/page_alloc.c    |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>>
>> Hmm, why mm/page_alloc.c and not kernel/memremap.c for this new
>> helper? I think that would address the kbuild reports and keeps all
>> the devm_memremap_pages / ZONE_DEVICE special casing centralized. I
>> also think it makes sense to move memremap.c to mm/ rather than
>> kernel/ especially since commit 5981690ddb8f "memremap: split
>> devm_memremap_pages() and memremap() infrastructure". Arguably, that
>> commit should have went ahead with the directory move.
>
> The issue ends up being the fact that I would then have to start
> exporting infrastructure such as __init_single_page from page_alloc. I
> have some follow-up patches I am working on that will generate some
> other shared functions that can be used by both memmap_init_zone and
> memmap_init_zone_device, as well as pulling in some of the code from
> the deferred memory init.

You wouldn't need to export it, just make it public to mm/ in
mm/internal.h, or a similar local header. With kernel/memremap.c moved
to mm/memremap.c this becomes even easier and better scoped for the
shared symbols.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
