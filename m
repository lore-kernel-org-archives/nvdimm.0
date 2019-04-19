Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com
 [IPv6:2607:f8b0:4864:20::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D3FF02120ADC1
 for <linux-nvdimm@lists.01.org>; Thu, 18 Apr 2019 20:25:35 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id t81so3168377oig.10
 for <linux-nvdimm@lists.01.org>; Thu, 18 Apr 2019 20:25:35 -0700 (PDT)
MIME-Version: 1.0
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190417150331.90219ca42a1c0db8632d0fd5@linux-foundation.org>
 <CAPcyv4hB47NJrVi1sm+7msL+6dJNhBD10BJbtLPZRcK2JK6+pg@mail.gmail.com>
 <CAPcyv4iW=xhhUQbg0bt=xCgVaR_jUvATeLxSoCfvzG5gTEAX6A@mail.gmail.com>
 <x49lg07eb3d.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49lg07eb3d.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 18 Apr 2019 20:25:22 -0700
Message-ID: <CAPcyv4jZwRfL5st3_MKwtTyuX8Rb+dYq6vpqwaEpp+BmZTgrYQ@mail.gmail.com>
Subject: Re: [PATCH v6 00/12] mm: Sub-section memory hotplug support
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, osalvador@suse.de
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 18, 2019 at 5:45 AM Jeff Moyer <jmoyer@redhat.com> wrote:
[..]
> >> > v6 and we're not showing any review activity.  Who would be suitable
> >> > people to help out here?
> >>
> >> There was quite a bit of review of the cover letter from Michal and
> >> David, but you're right the details not so much as of yet. I'd like to
> >> call out other people where I can reciprocate with some review of my
> >> own. Oscar's altmap work looks like a good candidate for that.
> >
> > I'm also hoping Jeff can give a tested-by for the customer scenarios
> > that fall over with the current implementation.
>
> Sure.  I'll also have a look over the patches.

Andrew, heads up it looks like there is a memory corruption bug in
these patches as I've gotten a few reported of "bad page state" at
boot. Please drop until I can track down the failure.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
