Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 862B421962301
 for <linux-nvdimm@lists.01.org>; Mon,  1 Oct 2018 09:56:02 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id j68-v6so11792449oib.7
 for <linux-nvdimm@lists.01.org>; Mon, 01 Oct 2018 09:56:02 -0700 (PDT)
MIME-Version: 1.0
References: <153816098159.2233877.8382846671636531035.stgit@dwillia2-desk3.amr.corp.intel.com>
 <3cf89dd3-a024-dbab-36ed-923f9466669c@linux.intel.com>
 <CAPcyv4hi7XLAswcoWEKOcQq_0FCTybxTUd_4H+mJj0S7BkTCjg@mail.gmail.com>
 <9f24ed83-5fea-da70-5470-36992b90c521@linux.intel.com>
In-Reply-To: <9f24ed83-5fea-da70-5470-36992b90c521@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 1 Oct 2018 09:55:50 -0700
Message-ID: <CAPcyv4jh+qERkoAfiJ47HPG7TCHi+ktm3+CrK6rqrfXGVRi47A@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm, dimm: Maximize label transfer size
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
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 1, 2018 at 8:41 AM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> On 9/28/2018 4:03 PM, Dan Williams wrote:
> > On Fri, Sep 28, 2018 at 3:44 PM Alexander Duyck
> > <alexander.h.duyck@linux.intel.com> wrote:
> >>
> >> On 9/28/2018 11:56 AM, Dan Williams wrote:
> >>> Use kvzalloc() to bypass the arbitrary PAGE_SIZE limit of label transfer
> >>> operations. Given the expense of calling into firmware, maximize the
> >>> amount of label data we transfer per call to be up to the total label
> >>> space if allowed by the firmware.
> >>>
> >>> Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >>
> >> This looks mostly fine to me.
> >>
> >> The only thing I am not certain about is if we want to use the raw
> >> max_cmd_size value or not since there is no guarantee it is aligned to
> >> any sort of boundary. It might be beneficial to either cache line align
> >> it or align it to 256B if it is larger than that since that way we at
> >> least would be getting full labels instead of partial ones.
> >
> > If we leave any portion of the max transfer size unused it just means
> > we're that much more likely to need an additional call into the ASL
> > interpreter. That said It might be worthwhile capping the max transfer
> > size in case the BIOS specifies something extreme (> 1MB) in the
> > future.
>
> Actually it all depends on the size of the max transfer versus the size
> of the label area. So for example if the label area is 128K and the max
> transfer size is 64K minus 32 then it doesn't really make much
> difference until we get below 44K for our max read size.
>
> My main concern is that I don't want to waste resources on allocating
> memory that isn't needed. For smaller allocations I agree we need to use
> everything we have to minimize calls to the ASL interpreter, but when
> max transfer sizes start getting large we are just allocating multiple
> pages of memory that do not need to be used.
>
> If nothing else I can look at doing the logic to reduce our memory
> allocations as a set of follow-up patches.

Sounds good, I would like to get smarter about only needing to cache
the portion of the label area that is in active use. However there is
at least one bug around simultaneous label updates that I want to
squash before we make the label handling more clever.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
