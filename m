Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F59A21184E6F
 for <linux-nvdimm@lists.01.org>; Mon, 29 Oct 2018 08:49:59 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id e9so6509251oti.1
 for <linux-nvdimm@lists.01.org>; Mon, 29 Oct 2018 08:49:59 -0700 (PDT)
MIME-Version: 1.0
References: <20181009170051.GA40606@tiger-server>
 <CAPcyv4g99_rJJSn0kWv5YO0Mzj90q1LH1wC3XrjCh1=x6mo7BQ@mail.gmail.com>
 <25092df0-b7b4-d456-8409-9c004cb6e422@linux.intel.com>
 <20181010095838.GG5873@dhcp22.suse.cz>
 <f97de51c-67dd-99b2-754e-0685cac06699@linux.intel.com>
 <20181010172451.GK5873@dhcp22.suse.cz>
 <98c35e19-13b9-0913-87d9-b3f1ab738b61@linux.intel.com>
 <20181010185242.GP5873@dhcp22.suse.cz>
 <20181011085509.GS5873@dhcp22.suse.cz>
 <6f32f23c-c21c-9d42-7dda-a1d18613cd3c@linux.intel.com>
 <20181017075257.GF18839@dhcp22.suse.cz>
 <971729e6-bcfe-a386-361b-d662951e69a7@linux.intel.com>
In-Reply-To: <971729e6-bcfe-a386-361b-d662951e69a7@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Oct 2018 08:49:46 -0700
Message-ID: <CAPcyv4gZZcuWFLzRpyJcAxtGEPTDkpwkG3J0Z4Q1u790+7W2Ag@mail.gmail.com>
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

On Wed, Oct 17, 2018 at 8:02 AM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> On 10/17/2018 12:52 AM, Michal Hocko wrote:
> > On Thu 11-10-18 10:38:39, Alexander Duyck wrote:
> >> On 10/11/2018 1:55 AM, Michal Hocko wrote:
> >>> On Wed 10-10-18 20:52:42, Michal Hocko wrote:
> >>> [...]
> >>>> My recollection was that we do clear the reserved bit in
> >>>> move_pfn_range_to_zone and we indeed do in __init_single_page. But then
> >>>> we set the bit back right afterwards. This seems to be the case since
> >>>> d0dc12e86b319 which reorganized the code. I have to study this some more
> >>>> obviously.
> >>>
> >>> so my recollection was wrong and d0dc12e86b319 hasn't really changed
> >>> much because __init_single_page wouldn't zero out the struct page for
> >>> the hotplug contex. A comment in move_pfn_range_to_zone explains that we
> >>> want the reserved bit because pfn walkers already do see the pfn range
> >>> and the page is not fully associated with the zone until it is onlined.
> >>>
> >>> I am thinking that we might be overzealous here. With the full state
> >>> initialized we shouldn't actually care. pfn_to_online_page should return
> >>> NULL regardless of the reserved bit and normal pfn walkers shouldn't
> >>> touch pages they do not recognize and a plain page with ref. count 1
> >>> doesn't tell much to anybody. So I _suspect_ that we can simply drop the
> >>> reserved bit setting here.
> >>
> >> So this has me a bit hesitant to want to just drop the bit entirely. If
> >> nothing else I think I may wan to make that a patch onto itself so that if
> >> we aren't going to set it we just drop it there. That way if it does cause
> >> issues we can bisect it to that patch and pinpoint the cause.
> >
> > Yes a patch on its own make sense for bisectability.
>
> For now I think I am going to back off of this. There is a bunch of
> other changes that need to happen in order for us to make this work. As
> far as I can tell there are several places that are relying on this
> reserved bit.

When David Hildebrand and I looked it was only the hibernation code
that we thought needed changing. We either need to audit the removal
or go back to adding a special case hack for kvm because this is a
blocking issue for them.

What do you see beyond the hibernation change?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
