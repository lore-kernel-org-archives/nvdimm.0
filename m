Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85D1B2121797E
 for <linux-nvdimm@lists.01.org>; Mon, 13 May 2019 21:29:40 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id y10so11086339oia.8
 for <linux-nvdimm@lists.01.org>; Mon, 13 May 2019 21:29:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190514025512.9670-1-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20190514025512.9670-1-aneesh.kumar@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 May 2019 21:29:28 -0700
Message-ID: <CAPcyv4hgNUDxjgYNkxOXJ9hfLb6z2+E1yasNoZNDKFUxkCzWLA@mail.gmail.com>
Subject: Re: [PATCH] mm/nvdimm: Use correct alignment when looking at first
 pfn from a region
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Linux MM <linux-mm@kvack.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 13, 2019 at 7:55 PM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> We already add the start_pad to the resource->start but fails to section
> align the start. This make sure with altmap we compute the right first
> pfn when start_pad is zero and we are doing an align down of start address.
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  kernel/memremap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index a856cb5ff192..23d77b60e728 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -59,9 +59,9 @@ static unsigned long pfn_first(struct dev_pagemap *pgmap)
>  {
>         const struct resource *res = &pgmap->res;
>         struct vmem_altmap *altmap = &pgmap->altmap;
> -       unsigned long pfn;
> +       unsigned long pfn = PHYS_PFN(res->start);
>
> -       pfn = res->start >> PAGE_SHIFT;
> +       pfn = SECTION_ALIGN_DOWN(pfn);

This does not seem right to me it breaks the assumptions of where the
first expected valid pfn occurs in the passed in range.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
