Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190809074520.27115-1-aneesh.kumar@linux.ibm.com> <20190809074520.27115-4-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20190809074520.27115-4-aneesh.kumar@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Aug 2019 14:05:29 -0700
Message-ID: <CAPcyv4hc_-oGMp6jGVknnYs+rmj4W1A_gFCbmAX2LFw0hsfL5g@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] mm/nvdimm: Use correct #defines instead of open coding
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 9, 2019 at 12:45 AM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> Use PAGE_SIZE instead of SZ_4K and sizeof(struct page) instead of 64.
> If we have a kernel built with different struct page size the previous
> patch should handle marking the namespace disabled.

Each of these changes carry independent non-overlapping regression
risk, so lets split them into separate patches. Others might

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  drivers/nvdimm/label.c          | 2 +-
>  drivers/nvdimm/namespace_devs.c | 6 +++---
>  drivers/nvdimm/pfn_devs.c       | 3 ++-
>  drivers/nvdimm/region_devs.c    | 8 ++++----
>  4 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 73e197babc2f..7ee037063be7 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -355,7 +355,7 @@ static bool slot_valid(struct nvdimm_drvdata *ndd,
>
>         /* check that DPA allocations are page aligned */
>         if ((__le64_to_cpu(nd_label->dpa)
> -                               | __le64_to_cpu(nd_label->rawsize)) % SZ_4K)
> +                               | __le64_to_cpu(nd_label->rawsize)) % PAGE_SIZE)

The UEFI label specification has no concept of PAGE_SIZE, so this
check is a pure Linux-ism. There's no strict requirement why
slot_valid() needs to check for page alignment and it would seem to
actively hurt cross-page-size compatibility, so let's delete the check
and rely on checksum validation.

>                 return false;
>
>         /* check checksum */
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index a16e52251a30..a9c76df12cb9 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1006,10 +1006,10 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
>                 return -ENXIO;
>         }
>
> -       div_u64_rem(val, SZ_4K * nd_region->ndr_mappings, &remainder);
> +       div_u64_rem(val, PAGE_SIZE * nd_region->ndr_mappings, &remainder);
>         if (remainder) {
> -               dev_dbg(dev, "%llu is not %dK aligned\n", val,
> -                               (SZ_4K * nd_region->ndr_mappings) / SZ_1K);
> +               dev_dbg(dev, "%llu is not %ldK aligned\n", val,
> +                               (PAGE_SIZE * nd_region->ndr_mappings) / SZ_1K);
>                 return -EINVAL;

Yes, looks good, but this deserves its own independent patch.

>         }
>
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 37e96811c2fc..c1d9be609322 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -725,7 +725,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>                  * when populating the vmemmap. This *should* be equal to
>                  * PMD_SIZE for most architectures.
>                  */
> -               offset = ALIGN(start + SZ_8K + 64 * npfns, align) - start;
> +               offset = ALIGN(start + SZ_8K + sizeof(struct page) * npfns,

I'd prefer if this was not dynamic and was instead set to the maximum
size of 'struct page' across all archs just to enhance cross-arch
compatibility. I think that answer is '64'.
> +                              align) - start;
>         } else if (nd_pfn->mode == PFN_MODE_RAM)
>                 offset = ALIGN(start + SZ_8K, align) - start;
>         else
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index af30cbe7a8ea..20e265a534f8 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -992,10 +992,10 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
>                 struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];
>                 struct nvdimm *nvdimm = mapping->nvdimm;
>
> -               if ((mapping->start | mapping->size) % SZ_4K) {
> -                       dev_err(&nvdimm_bus->dev, "%s: %s mapping%d is not 4K aligned\n",
> -                                       caller, dev_name(&nvdimm->dev), i);
> -
> +               if ((mapping->start | mapping->size) % PAGE_SIZE) {
> +                       dev_err(&nvdimm_bus->dev,
> +                               "%s: %s mapping%d is not %ld aligned\n",
> +                               caller, dev_name(&nvdimm->dev), i, PAGE_SIZE);
>                         return NULL;
>                 }
>
> --
> 2.21.0
>
