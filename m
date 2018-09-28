Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 26AF82112944B
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 16:03:45 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id m23-v6so7630254otf.0
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 16:03:45 -0700 (PDT)
MIME-Version: 1.0
References: <153816098159.2233877.8382846671636531035.stgit@dwillia2-desk3.amr.corp.intel.com>
 <3cf89dd3-a024-dbab-36ed-923f9466669c@linux.intel.com>
In-Reply-To: <3cf89dd3-a024-dbab-36ed-923f9466669c@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Sep 2018 16:03:33 -0700
Message-ID: <CAPcyv4hi7XLAswcoWEKOcQq_0FCTybxTUd_4H+mJj0S7BkTCjg@mail.gmail.com>
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

On Fri, Sep 28, 2018 at 3:44 PM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> On 9/28/2018 11:56 AM, Dan Williams wrote:
> > Use kvzalloc() to bypass the arbitrary PAGE_SIZE limit of label transfer
> > operations. Given the expense of calling into firmware, maximize the
> > amount of label data we transfer per call to be up to the total label
> > space if allowed by the firmware.
> >
> > Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> This looks mostly fine to me.
>
> The only thing I am not certain about is if we want to use the raw
> max_cmd_size value or not since there is no guarantee it is aligned to
> any sort of boundary. It might be beneficial to either cache line align
> it or align it to 256B if it is larger than that since that way we at
> least would be getting full labels instead of partial ones.

If we leave any portion of the max transfer size unused it just means
we're that much more likely to need an additional call into the ASL
interpreter. That said It might be worthwhile capping the max transfer
size in case the BIOS specifies something extreme (> 1MB) in the
future.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
