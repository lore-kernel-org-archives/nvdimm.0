Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E6172125ADD6
 for <linux-nvdimm@lists.01.org>; Mon, 13 May 2019 20:58:51 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id 203so11042099oid.13
 for <linux-nvdimm@lists.01.org>; Mon, 13 May 2019 20:58:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190514025604.9997-1-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20190514025604.9997-1-aneesh.kumar@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 May 2019 20:58:38 -0700
Message-ID: <CAPcyv4iNgFbSq0Hqb+CStRhGWMHfXx7tL3vrDaQ95DcBBY8QCQ@mail.gmail.com>
Subject: Re: [PATCH] mm/nvdimm: Use correct #defines instead of opencoding
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

On Mon, May 13, 2019 at 7:56 PM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> The nfpn related change is needed to fix the kernel message
>
> "number of pfns truncated from 2617344 to 163584"
>
> The change makes sure the nfpns stored in the superblock is right value.
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  drivers/nvdimm/pfn_devs.c    | 6 +++---
>  drivers/nvdimm/region_devs.c | 8 ++++----
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 347cab166376..6751ff0296ef 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -777,8 +777,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>                  * when populating the vmemmap. This *should* be equal to
>                  * PMD_SIZE for most architectures.
>                  */
> -               offset = ALIGN(start + reserve + 64 * npfns,
> -                               max(nd_pfn->align, PMD_SIZE)) - start;
> +               offset = ALIGN(start + reserve + sizeof(struct page) * npfns,
> +                              max(nd_pfn->align, PMD_SIZE)) - start;

No, I think we need to record the page-size into the superblock format
otherwise this breaks in debug builds where the struct-page size is
extended.

>         } else if (nd_pfn->mode == PFN_MODE_RAM)
>                 offset = ALIGN(start + reserve, nd_pfn->align) - start;
>         else
> @@ -790,7 +790,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>                 return -ENXIO;
>         }
>
> -       npfns = (size - offset - start_pad - end_trunc) / SZ_4K;
> +       npfns = (size - offset - start_pad - end_trunc) / PAGE_SIZE;

Similar comment, if the page size is variable then the superblock
needs to explicitly account for it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
