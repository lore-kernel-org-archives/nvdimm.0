Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C744A2B
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 16:42:11 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id n11-20020a17090a73cb00b001d1d3a7116bso295414pjk.0
        for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 09:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PA+FG4DowT86tBEUQdZQxInwa+G/wK3+5JMw8jztpe0=;
        b=iLcygDQcv6dCXAGjg8o5JOwk4+1eafoTm6hZR7IT+fSHKRwdRFrMWuG6L8jfLXGygT
         Gt9qC0ObTp8dH4d/7KbufLiAd9/TJFKdBANPcP0XT48foYFlB9eH1ztg0ToIvfnuKQhC
         b6ZImG6QXTd7bmUBJinf6qjsahpenBYarvzy9JKFnmKM3bdF1wwMzROVCF6n8HJg5AtN
         0VxTdBwHnHcU0Gi2K+4I0wXjlnLQtWzijvNOhbz82ukyxf22HCUaJ9T1D89d9BvTa1wA
         x87ZYA7gYwc5ErlfwT7mIi1eV1dvYuPoULNNUQK9dQUwA8v3FTR5Lf+ohL6QKiJF7aRf
         TiiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PA+FG4DowT86tBEUQdZQxInwa+G/wK3+5JMw8jztpe0=;
        b=CJMveSor44VumCsS6NmdW7M4YZaJENg64NXwFXwIZn+T1LQ3KJzc9guvXz1ck7sdH3
         gTMoSMzAEvvbecTGrXlKXFIDqYIoR38cKu7pMiQVXuAWzUfCBFXIeFT4YuRzkZRa8Bi2
         PgRgLrU6dssc1WfQClVoLb7wz26cWqUK+Ha/bHEOYc4vZciopyiFdmUMwf+142d4+AXn
         WK9EhsTtMRCwCQtue6u8129k2LJ3vCPZW3L3dFv/av6vCYJOxsr5mDhWlSBJSkpWaUGd
         A6jYUA9aA3mg+9bxTdetncdhZnUHMXBDerwSKrEm4COsq3MgpEUgSSHsEJlyzk6yvzFc
         yXSA==
X-Gm-Message-State: AOAM5300TMfqaQLNCTq56+lxhyiRizI4B+4Kw8tT3/qlWNmSd1Ww0UgZ
	m0r0QonZoPBTIgM+7EZq5mESyKEMrbPktwDzs+nV3Q==
X-Google-Smtp-Source: ABdhPJwpvOzKsRR6iAaCZR9rRdAPrqY+UVLyqBgacn735htTjXt45+Pu4uTkGhLn7gZjsOHVXD2SFa2+Rhlvfezwl/A=
X-Received: by 2002:a17:902:e885:b0:158:e564:8992 with SMTP id
 w5-20020a170902e88500b00158e5648992mr11596738plg.34.1650300131412; Mon, 18
 Apr 2022 09:42:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413183720.2444089-1-ben.widawsky@intel.com> <20220413183720.2444089-6-ben.widawsky@intel.com>
In-Reply-To: <20220413183720.2444089-6-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Apr 2022 09:42:00 -0700
Message-ID: <CAPcyv4iM13nzCpnF5S4oHSWF769t4Av96gQM_3n4E=RAPSnSig@mail.gmail.com>
Subject: Re: [RFC PATCH 05/15] cxl/acpi: Reserve CXL resources from request_free_mem_region
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	patches@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Christoph Hellwig <hch@infradead.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, John Hubbard <jhubbard@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

[ add the usual HMM suspects Christoph, Jason, and John ]

On Wed, Apr 13, 2022 at 11:38 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> Define an API which allows CXL drivers to manage CXL address space.
> CXL is unique in that the address space and various properties are only
> known after CXL drivers come up, and therefore cannot be part of core
> memory enumeration.

I think this buries the lead on the problem introduced by
MEMORY_DEVICE_PRIVATE in the first place. Let's revisit that history
before diving into what CXL needs.

---

Commit 4ef589dc9b10 ("mm/hmm/devmem: device memory hotplug using
ZONE_DEVICE") introduced the concept of MEMORY_DEVICE_PRIVATE. At its
core MEMORY_DEVICE_PRIVATE uses the ZONE_DEVICE capability to annotate
an "unused" physical address range with 'struct page' for the purpose
of coordinating migration of buffers onto and off of a GPU /
accelerator. The determination of "unused" was based on a heuristic,
not a guarantee, that any address range not expressly conveyed in the
platform firmware map of the system can be repurposed for software
use. The CXL Fixed Memory Windows Structure  (CFMWS) definition
explicitly breaks the assumptions of that heuristic.

---

...and then jump into what CFMWS is and the proposal to coordinate
with request_free_mem_region().


>
> Compute Express Link 2.0 [ECN] defines a concept called CXL Fixed Memory
> Window Structures (CFMWS). Each CFMWS conveys a region of host physical
> address (HPA) space which has certain properties that are familiar to
> CXL, mainly interleave properties, and restrictions, such as
> persistence. The HPA ranges therefore should be owned, or at least
> guided by the relevant CXL driver, cxl_acpi [1].
>
> It would be desirable to simply insert this address space into
> iomem_resource with a new flag to denote this is CXL memory. This would
> permit request_free_mem_region() to be reused for CXL memory provided it
> learned some new tricks. For that, it is tempting to simply use
> insert_resource(). The API was designed specifically for cases where new
> devices may offer new address space. This cannot work in the general
> case. Boot firmware can pass, some, none, or all of the CFMWS range as
> various types of memory to the kernel, and this may be left alone,
> merged, or even expanded.

s/expanded/expanded as the memory map is parsed and reconciled/

> As a result iomem_resource may intersect CFMWS
> regions in ways insert_resource cannot handle [2]. Similar reasoning
> applies to allocate_resource().
>
> With the insert_resource option out, the only reasonable approach left
> is to let the CXL driver manage the address space independently of
> iomem_resource and attempt to prevent users of device private memory

s/device private memory/MEMORY_DEVICE_PRIVATE/

> APIs from using CXL memory. In the case where cxl_acpi comes up first,
> the new API allows cxl to block use of any CFMWS defined address space
> by assuming everything above the highest CFMWS entry is fair game. It is
> expected that this effectively will prevent usage of device private
> memory,

No, only if CFMWS consumes the full 64-bit address space which is
unlikely. It's also unlikely going forward to need
MEMORY_DEVICE_PRIVATE when hardware supports CXL for fully coherent
migration of buffers onto and off of an accelearator.

> but if such behavior is undesired, cxl_acpi can be blocked from
> loading, or unloaded.

I would just say if MEMORY_DEVICE_PRIVATE needs exceed the memory
space left over by CXL then the loading of the dynamic CXL address
space allocation infrastructure can be deferred until after
MEMORY_DEVICE_PRIVATE consumers have

> When device private memory is used before CXL
> comes up, or, there are intersections as described above, the CXL driver
> will have to make sure to not reuse sysram that is BUSY.
>
> [1]: The specification defines enumeration via ACPI, however, one could
> envision devicetree, or some other hardcoded mechanisms for doing the
> same thing.
>
> [2]: A common way to hit this case is when BIOS creates a volatile
> region with extra space for hotplug. In this case, you're likely to have
>
> |<--------------HPA space---------------------->|
> |<---iomem_resource -->|
> | DDR  | CXL Volatile  |
> |      | CFMWS for volatile w/ hotplug |
>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> ---
>  drivers/cxl/acpi.c     | 26 ++++++++++++++++++++++++++
>  include/linux/ioport.h |  1 +
>  kernel/resource.c      | 11 ++++++++++-
>  3 files changed, 37 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index 9b69955b90cb..0870904fe4b5 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -76,6 +76,7 @@ static int cxl_acpi_cfmws_verify(struct device *dev,
>  struct cxl_cfmws_context {
>         struct device *dev;
>         struct cxl_port *root_port;
> +       struct acpi_cedt_cfmws *high_cfmws;

Seems more straightforward to track the max 'end' address seen so far
rather than the "highest" cfmws entry.

>  };
>
>  static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
> @@ -126,6 +127,14 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
>                         cfmws->base_hpa + cfmws->window_size - 1);
>                 return 0;
>         }
> +
> +       if (ctx->high_cfmws) {
> +               if (cfmws->base_hpa > ctx->high_cfmws->base_hpa)
> +                       ctx->high_cfmws = cfmws;

I'd expect:

end = cfmws->base_hpa + window_size;
if (ctx->cfmws_max < end)
   ctx->cfmws_max = end;

> +       } else {
> +               ctx->high_cfmws = cfmws;
> +       }
> +
>         dev_dbg(dev, "add: %s node: %d range %#llx-%#llx\n",
>                 dev_name(&cxld->dev), phys_to_target_node(cxld->range.start),
>                 cfmws->base_hpa, cfmws->base_hpa + cfmws->window_size - 1);
> @@ -299,6 +308,7 @@ static int cxl_acpi_probe(struct platform_device *pdev)
>         ctx = (struct cxl_cfmws_context) {
>                 .dev = host,
>                 .root_port = root_port,
> +               .high_cfmws = NULL,
>         };
>         acpi_table_parse_cedt(ACPI_CEDT_TYPE_CFMWS, cxl_parse_cfmws, &ctx);
>
> @@ -317,10 +327,25 @@ static int cxl_acpi_probe(struct platform_device *pdev)
>         if (rc < 0)
>                 return rc;
>
> +       if (ctx.high_cfmws) {

Even if there are zero CFMWS entries there will always be a max end
address to call set_request_free_min_base().

> +               resource_size_t end =
> +                       ctx.high_cfmws->base_hpa + ctx.high_cfmws->window_size;
> +               dev_dbg(host,
> +                       "Disabling free device private regions below %#llx\n",
> +                       end);
> +               set_request_free_min_base(end);
> +       }
> +
>         /* In case PCI is scanned before ACPI re-trigger memdev attach */
>         return cxl_bus_rescan();
>  }
>
> +static int cxl_acpi_remove(struct platform_device *pdev)

No need for a .remove() method, just use devm_add_action_or_reset() to
unreserve CXL address space as cxl_acpi unloads.

> +{
> +       set_request_free_min_base(0);
> +       return 0;
> +}
> +
>  static const struct acpi_device_id cxl_acpi_ids[] = {
>         { "ACPI0017" },
>         { },
> @@ -329,6 +354,7 @@ MODULE_DEVICE_TABLE(acpi, cxl_acpi_ids);
>
>  static struct platform_driver cxl_acpi_driver = {
>         .probe = cxl_acpi_probe,
> +       .remove = cxl_acpi_remove,
>         .driver = {
>                 .name = KBUILD_MODNAME,
>                 .acpi_match_table = cxl_acpi_ids,
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index ec5f71f7135b..dc41e4be5635 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -325,6 +325,7 @@ extern int
>  walk_iomem_res_desc(unsigned long desc, unsigned long flags, u64 start, u64 end,
>                     void *arg, int (*func)(struct resource *, void *));
>
> +void set_request_free_min_base(resource_size_t val);

Shouldn't there also be a static inline empty routine in the
CONFIG_DEVICE_PRIVATE=n case?

>  struct resource *devm_request_free_mem_region(struct device *dev,
>                 struct resource *base, unsigned long size);
>  struct resource *request_free_mem_region(struct resource *base,
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 34eaee179689..a4750689e529 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1774,6 +1774,14 @@ void resource_list_free(struct list_head *head)
>  EXPORT_SYMBOL(resource_list_free);
>
>  #ifdef CONFIG_DEVICE_PRIVATE
> +static resource_size_t request_free_min_base;
> +
> +void set_request_free_min_base(resource_size_t val)
> +{
> +       request_free_min_base = val;
> +}
> +EXPORT_SYMBOL_GPL(set_request_free_min_base);
> +
>  static struct resource *__request_free_mem_region(struct device *dev,
>                 struct resource *base, unsigned long size, const char *name)
>  {
> @@ -1799,7 +1807,8 @@ static struct resource *__request_free_mem_region(struct device *dev,
>         }
>
>         write_lock(&resource_lock);
> -       for (; addr > size && addr >= base->start; addr -= size) {
> +       for (; addr > size && addr >= max(base->start, request_free_min_base);
> +            addr -= size) {
>                 if (__region_intersects(addr, size, 0, IORES_DESC_NONE) !=
>                                 REGION_DISJOINT)
>                         continue;
> --
> 2.35.1
>
