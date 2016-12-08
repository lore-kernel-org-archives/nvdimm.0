Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2AB0181F6B
 for <linux-nvdimm@lists.01.org>; Wed,  7 Dec 2016 18:49:19 -0800 (PST)
Received: by mail-oi0-x229.google.com with SMTP id w63so439919569oiw.0
 for <linux-nvdimm@lists.01.org>; Wed, 07 Dec 2016 18:49:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <148063139194.37496.13883044011361266303.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148063138593.37496.4684424640746238765.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148063139194.37496.13883044011361266303.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 7 Dec 2016 18:49:17 -0800
Message-ID: <CAPcyv4iEr5sc7Ua0C+cKHhVDgso7cSnseSz-m7jPmh+DB5+K5A@mail.gmail.com>
Subject: Re: [PATCH 01/11] mm, devm_memremap_pages: use multi-order radix for
 ZONE_DEVICE lookups
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux MM <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 1, 2016 at 2:29 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> devm_memremap_pages() records mapped ranges in pgmap_radix with a entry
> per section's worth of memory (128MB).  The key for each of those entries is
> a section number.
>
> This leads to false positives when devm_memremap_pages() is passed a
> section-unaligned range as lookups in the misalignment fail to return
> NULL. We can close this hole by using the unmodified physical address as
> the key for entries in the tree.  The number of entries required to
> describe a remapped range is reduced by leveraging multi-order entries.
>
> In practice this approach usually yields just one entry in the tree if
> the size and starting address is power-of-2 aligned.  Previously we
> needed mapping_size / 128MB entries.
>
> Link: https://lists.01.org/pipermail/linux-nvdimm/2016-August/006666.html
> Reported-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  kernel/memremap.c |   53 +++++++++++++++++++++++++++++++++++++++--------------
>  mm/Kconfig        |    1 +
>  2 files changed, 40 insertions(+), 14 deletions(-)
>
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index b501e390bb34..10becd7855ca 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -194,18 +194,39 @@ void put_zone_device_page(struct page *page)
>  }
>  EXPORT_SYMBOL(put_zone_device_page);
>
> -static void pgmap_radix_release(struct resource *res)
> +static unsigned order_at(struct resource *res, unsigned long offset)
>  {
> -       resource_size_t key, align_start, align_size, align_end;
> +       unsigned long phys_offset = res->start + offset;
> +       resource_size_t size = resource_size(res);
> +       unsigned order_max, order_offset;
>
> -       align_start = res->start & ~(SECTION_SIZE - 1);
> -       align_size = ALIGN(resource_size(res), SECTION_SIZE);
> -       align_end = align_start + align_size - 1;
> +       if (size == offset)
> +               return UINT_MAX;
> +
> +       /*
> +        * What is the largest power-of-2 range available from this
> +        * resource offset to the end of the resource range, considering
> +        * the alignment of the current offset?
> +        */
> +       order_offset = ilog2(size | phys_offset);
> +       order_max = ilog2(size - offset);
> +       return min(order_max, order_offset);
> +}
> +
> +#define foreach_order_offset(res, order, offset) \
> +       for (offset = 0, order = order_at((res), offset); order < UINT_MAX; \
> +               offset += 1UL << order, order = order_at((res), offset))

The radix tree expects 'order' to be in PAGE_SIZE units, so I need to
respin this patch to account for PAGE_SHIFT.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
