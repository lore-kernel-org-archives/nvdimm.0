Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E956E81EAB
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 11:54:23 -0800 (PST)
Received: by mail-oi0-x233.google.com with SMTP id y198so278443903oia.1
 for <linux-nvdimm@lists.01.org>; Fri, 02 Dec 2016 11:54:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480706540-21323-1-git-send-email-fabf@skynet.be>
References: <1480706540-21323-1-git-send-email-fabf@skynet.be>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Dec 2016 11:54:22 -0800
Message-ID: <CAPcyv4g81fyw5GZuuARRB70upYy7Q1GPM+P9cKd6kfH12fKUbA@mail.gmail.com>
Subject: Re: [PATCH 8/8 linux-next] mm: use SECTION_MASK where possible
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
To: Fabian Frederick <fabf@skynet.be>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 2, 2016 at 11:22 AM, Fabian Frederick <fabf@skynet.be> wrote:
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  kernel/memremap.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index 1bb5eec..8ebf9dd 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -198,7 +198,7 @@ static void pgmap_radix_release(struct resource *res)
>  {
>         resource_size_t key, align_start, align_size, align_end;
>
> -       align_start = res->start & ~(SECTION_SIZE - 1);
> +       align_start = res->start & SECTION_MASK;
>         align_size = ALIGN(resource_size(res), SECTION_SIZE);
>         align_end = align_start + align_size - 1;
>
> @@ -244,7 +244,7 @@ static void devm_memremap_pages_release(struct device *dev, void *data)
>         }
>
>         /* pages are dead and unused, undo the arch mapping */
> -       align_start = res->start & ~(SECTION_SIZE - 1);
> +       align_start = res->start & SECTION_MASK;
>         align_size = ALIGN(resource_size(res), SECTION_SIZE);
>         arch_remove_memory(align_start, align_size);
>         untrack_pfn(NULL, PHYS_PFN(align_start), align_size);
> @@ -289,7 +289,7 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
>         int error, nid, is_ram;
>         unsigned long pfn;
>
> -       align_start = res->start & ~(SECTION_SIZE - 1);
> +       align_start = res->start & SECTION_MASK;
>         align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
>                 - align_start;
>         is_ram = region_intersects(align_start, align_size,

This is addressed in the sub-section hotplug series:

"[PATCH 03/11] mm: introduce common definitions for the size and mask
of a section"
https://lkml.org/lkml/2016/12/1/746
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
