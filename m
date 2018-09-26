Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9319321143590
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 11:53:09 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id c12-v6so17463otl.6
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 11:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <20180925200551.3576.18755.stgit@localhost.localdomain>
 <20180925202053.3576.66039.stgit@localhost.localdomain>
 <20180926075540.GD6278@dhcp22.suse.cz>
 <6f87a5d7-05e2-00f4-8568-bb3521869cea@linux.intel.com>
In-Reply-To: <6f87a5d7-05e2-00f4-8568-bb3521869cea@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Sep 2018 11:52:56 -0700
Message-ID: <CAPcyv4iVnodai0bB74yeSCD2H+hoLsZYUk4sR9jV0pPAE+Zorw@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] mm: Defer ZONE_DEVICE page initialization to the
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
To: alexander.h.duyck@linux.intel.com
Cc: Pasha Tatashin <pavel.tatashin@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, rppt@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 26, 2018 at 11:25 AM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
>
>
> On 9/26/2018 12:55 AM, Michal Hocko wrote:
> > On Tue 25-09-18 13:21:24, Alexander Duyck wrote:
> >> The ZONE_DEVICE pages were being initialized in two locations. One was with
> >> the memory_hotplug lock held and another was outside of that lock. The
> >> problem with this is that it was nearly doubling the memory initialization
> >> time. Instead of doing this twice, once while holding a global lock and
> >> once without, I am opting to defer the initialization to the one outside of
> >> the lock. This allows us to avoid serializing the overhead for memory init
> >> and we can instead focus on per-node init times.
> >>
> >> One issue I encountered is that devm_memremap_pages and
> >> hmm_devmmem_pages_create were initializing only the pgmap field the same
> >> way. One wasn't initializing hmm_data, and the other was initializing it to
> >> a poison value. Since this is something that is exposed to the driver in
> >> the case of hmm I am opting for a third option and just initializing
> >> hmm_data to 0 since this is going to be exposed to unknown third party
> >> drivers.
> >
> > Why cannot you pull move_pfn_range_to_zone out of the hotplug lock? In
> > other words why are you making zone device even more special in the
> > generic hotplug code when it already has its own means to initialize the
> > pfn range by calling move_pfn_range_to_zone. Not to mention the code
> > duplication.
>
> So there were a few things I wasn't sure we could pull outside of the
> hotplug lock. One specific example is the bits related to resizing the
> pgdat and zone. I wanted to avoid pulling those bits outside of the
> hotplug lock.
>
> The other bit that I left inside the hot-plug lock with this approach
> was the initialization of the pages that contain the vmemmap.
>
> > That being said I really dislike this patch.
>
> In my mind this was a patch that "killed two birds with one stone". I
> had two issues to address, the first one being the fact that we were
> performing the memmap_init_zone while holding the hotplug lock, and the
> other being the loop that was going through and initializing pgmap in
> the hmm and memremap calls essentially added another 20 seconds
> (measured for 3TB of memory per node) to the init time. With this patch
> I was able to cut my init time per node by that 20 seconds, and then
> made it so that we could scale as we added nodes as they could run in
> parallel.

Yeah, at the very least there is no reason for devm_memremap_pages()
to do another loop through all pages, the core should handle this, but
cleaning up the scope of the hotplug lock is needed.

> With that said I am open to suggestions if you still feel like I need to
> follow this up with some additional work. I just want to avoid
> introducing any regressions in regards to functionality or performance.

Could we push the hotplug lock deeper to the places that actually need
it? What I found with my initial investigation is that we don't even
need the hotplug lock for the vmemmap initialization with this patch
[1].

Alternatively it seems the hotplug lock wants to synchronize changes
to the zone and the page init work. If the hotplug lock was an rwsem
the zone changes would be a write lock, but the init work could be
done as a read lock to allow parallelism. I.e. still provide a sync
point to be able to assert that no hotplug work is in-flight will
holding the write lock, but otherwise allow threads that are touching
independent parts of the memmap to run at the same time.

[1]: https://patchwork.kernel.org/patch/10527229/ just focus on the
mm/sparse-vmemmap.c changes at the end.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
