Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A7B4921A09130
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 11:19:03 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id c23so4528433otl.9
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 11:19:03 -0700 (PDT)
MIME-Version: 1.0
References: <20180925200551.3576.18755.stgit@localhost.localdomain>
 <20180925202053.3576.66039.stgit@localhost.localdomain>
 <20181009170051.GA40606@tiger-server>
 <CAPcyv4g99_rJJSn0kWv5YO0Mzj90q1LH1wC3XrjCh1=x6mo7BQ@mail.gmail.com>
 <25092df0-b7b4-d456-8409-9c004cb6e422@linux.intel.com>
 <20181010095838.GG5873@dhcp22.suse.cz>
 <f97de51c-67dd-99b2-754e-0685cac06699@linux.intel.com>
 <20181010172451.GK5873@dhcp22.suse.cz>
In-Reply-To: <20181010172451.GK5873@dhcp22.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 10 Oct 2018 11:18:49 -0700
Message-ID: <CAPcyv4inUwyYEEQ_qh5GTRxUo+JLt+caz_3mtg79DpfQSUdG5Q@mail.gmail.com>
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
To: Michal Hocko <mhocko@kernel.org>
Cc: Pasha Tatashin <pavel.tatashin@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, rppt@linux.vnet.ibm.com, alexander.h.duyck@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 10, 2018 at 10:30 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Wed 10-10-18 09:39:08, Alexander Duyck wrote:
> > On 10/10/2018 2:58 AM, Michal Hocko wrote:
> > > On Tue 09-10-18 13:26:41, Alexander Duyck wrote:
> > > [...]
> > > > I would think with that being the case we still probably need the call to
> > > > __SetPageReserved to set the bit with the expectation that it will not be
> > > > cleared for device-pages since the pages are not onlined. Removing the call
> > > > to __SetPageReserved would probably introduce a number of regressions as
> > > > there are multiple spots that use the reserved bit to determine if a page
> > > > can be swapped out to disk, mapped as system memory, or migrated.
> > >
> > > PageReserved is meant to tell any potential pfn walkers that might get
> > > to this struct page to back off and not touch it. Even though
> > > ZONE_DEVICE doesn't online pages in traditional sense it makes those
> > > pages available for further use so the page reserved bit should be
> > > cleared.
> >
> > So from what I can tell that isn't necessarily the case. Specifically if the
> > pagemap type is MEMORY_DEVICE_PRIVATE or MEMORY_DEVICE_PUBLIC both are
> > special cases where the memory may not be accessible to the CPU or cannot be
> > pinned in order to allow for eviction.
>
> Could you give me an example please?
>
> > The specific case that Dan and Yi are referring to is for the type
> > MEMORY_DEVICE_FS_DAX. For that type I could probably look at not setting the
> > reserved bit. Part of me wants to say that we should wait and clear the bit
> > later, but that would end up just adding time back to initialization. At
> > this point I would consider the change more of a follow-up optimization
> > rather than a fix though since this is tailoring things specifically for DAX
> > versus the other ZONE_DEVICE types.
>
> I thought I have already made it clear that these zone device hacks are
> not acceptable to the generic hotplug code. If the current reserve bit
> handling is not correct then give us a specific reason for that and we
> can start thinking about the proper fix.
>

Right, so we're in a situation where a hack is needed for KVM's
current interpretation of the Reserved flag relative to dax mapped
pages. I'm arguing to push that knowledge / handling as deep as
possible into the core rather than hack the leaf implementations like
KVM, i.e. disable the Reserved flag for all non-MEMORY_DEVICE_*
ZONE_DEVICE types.

Here is the KVM thread about why they need a change:

    https://lkml.org/lkml/2018/9/7/552

...and where I pushed back on a KVM-local hack:

    https://lkml.org/lkml/2018/9/19/154
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
