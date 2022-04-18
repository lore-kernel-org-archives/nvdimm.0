Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD532567
	for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 22:15:58 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id q19so21353189pgm.6
        for <nvdimm@lists.linux.dev>; Mon, 18 Apr 2022 15:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cXn+XlB+cHweCj8dldoZHVhXGxfPdw05rCWNbSdTdc4=;
        b=a3/CLTjzJmABS8OJFu259ZAUTBgMaKGm4qDzfxoiRymib2vIz041twXe8ofgq4beSM
         eSQL8xTTCC4e0rZY+34Qhb/SgeNRFRHayrKIXcXN0HlKhdLw0WGzrHDgTl+fmi8NEtHv
         os5PoVy+JqKtRigkZSJ54ftSJ2lJkVAjmMUgdpAWnNC0Vj1K/r0tTGTv7knsD4EEq2Kr
         Mi4ySkAyfxS87q5a8/jLaxSWyv+fhnnV+QyCWzhNWQ4gaaIjE2JYJ3aZWmvOaOG8v5Zm
         qSSPB2ZqqAlCJKHPoOdtuy3NU5l0nlThx9ctndSpbQz+609wdbCpDGtAHMYaxo5fQHTp
         Nlcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cXn+XlB+cHweCj8dldoZHVhXGxfPdw05rCWNbSdTdc4=;
        b=GFwzVQC5apC9ER9p31/+EgUECkCKl7n6hw7udsmrzFykqGgfQGcG61Z81TvzjxcXI+
         V9GxjP6sYp6cGFhX4pqH35oL7+MeaJM4QGKWUvwoq+t8+TugN6eXSKd+sTQY2RUlO7N0
         qlNv9jb8OsreJqJXw8srBVFo+cxBVcyVIIzgaVivbIaFneM6XIsz8c7Jxh5OG0WIPZG6
         C0ONAfr2I5nHQszhizOmi+PM0ssBMsG6+6s3uJDZeRv8t1qJXAOX0ufUQ+0FneZ6LUUV
         hxVqxS7CzV+JZKS5RlJUl9+FLDtxxWlEek9Jhyj85s81VyKgWsx+eadEDa6ZZwUnB6sV
         Ki1w==
X-Gm-Message-State: AOAM530vJZvMpQH1UzHNhqlhWY0J81JzvtN6DSHAPMd/GAkkDltPcK0K
	zuQSQcIjBX5qVLNad8t9Ultv2lmpRq6O2w515j2JsA==
X-Google-Smtp-Source: ABdhPJwWpbqzZFn6prFelZgwymqzv8uuDIY8ktJhHn2DeA4Oidn7MdV/6rumg9QinS8Ff9gdYQ4FlLujPhf5fWaz814=
X-Received: by 2002:a05:6a00:e14:b0:4fe:3cdb:23f with SMTP id
 bq20-20020a056a000e1400b004fe3cdb023fmr14519126pfb.86.1650320158259; Mon, 18
 Apr 2022 15:15:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413183720.2444089-1-ben.widawsky@intel.com> <20220413183720.2444089-7-ben.widawsky@intel.com>
In-Reply-To: <20220413183720.2444089-7-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Apr 2022 15:15:47 -0700
Message-ID: <CAPcyv4hD93d20Sq25tPNMQ1T68uQmTTQo7aDXMKN36wrCTa1-Q@mail.gmail.com>
Subject: Re: [RFC PATCH 06/15] cxl/acpi: Manage root decoder's address space
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	patches@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 13, 2022 at 11:38 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> Use a gen_pool to manage the physical address space that is routed by
> the platform decoder (root decoder). As described in 'cxl/acpi: Resereve
> CXL resources from request_free_mem_region' the address space does not
> coexist well if part of all of it is conveyed in the memory map to the
> kernel.
>
> Since the existing resource APIs of interest all rely on the root
> decoder's address space being in iomem_resource,

I do not understand what this is trying to convey. Nothing requires
that a given 'struct resource' be managed under iomem_resource.

> the choices are to roll
> a new allocator because on struct resource, or use gen_pool. gen_pool is
> a good choice because it already has all the capabilities needed to
> satisfy CXL programming.

Not sure what comparison to 'struct resource' is being made here, what
is the tradeoff as you see it? In other words, why mention 'struct
resource' as a consideration?

>
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> ---
>  drivers/cxl/acpi.c | 36 ++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h  |  2 ++
>  2 files changed, 38 insertions(+)
>
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index 0870904fe4b5..a6b0c3181d0e 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /* Copyright(c) 2021 Intel Corporation. All rights reserved. */
>  #include <linux/platform_device.h>
> +#include <linux/genalloc.h>
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/kernel.h>
> @@ -79,6 +80,25 @@ struct cxl_cfmws_context {
>         struct acpi_cedt_cfmws *high_cfmws;
>  };
>
> +static int cfmws_cookie;
> +
> +static int fill_busy_mem(struct resource *res, void *_window)
> +{
> +       struct gen_pool *window = _window;
> +       struct genpool_data_fixed gpdf;
> +       unsigned long addr;
> +       void *type;
> +
> +       gpdf.offset = res->start;
> +       addr = gen_pool_alloc_algo_owner(window, resource_size(res),
> +                                        gen_pool_fixed_alloc, &gpdf, &type);

The "_owner" variant of gen_pool was only added for p2pdma as a way to
coordinate reference counts across p2pdma space allocation and a
'strcuct dev_pagemap' instance. The use here seems completely
vestigial and can just move to gen_pool_alloc_algo.

> +       if (addr != res->start || (res->start == 0 && type != &cfmws_cookie))
> +               return -ENXIO;

How can the second condition ever be true?

> +
> +       pr_devel("%pR removed from CFMWS\n", res);
> +       return 0;
> +}
> +
>  static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
>                            const unsigned long end)
>  {
> @@ -88,6 +108,8 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
>         struct device *dev = ctx->dev;
>         struct acpi_cedt_cfmws *cfmws;
>         struct cxl_decoder *cxld;
> +       struct gen_pool *window;
> +       char name[64];
>         int rc, i;
>
>         cfmws = (struct acpi_cedt_cfmws *) header;
> @@ -116,6 +138,20 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
>         cxld->interleave_ways = CFMWS_INTERLEAVE_WAYS(cfmws);
>         cxld->interleave_granularity = CFMWS_INTERLEAVE_GRANULARITY(cfmws);
>
> +       sprintf(name, "cfmws@%#llx", cfmws->base_hpa);
> +       window = devm_gen_pool_create(dev, ilog2(SZ_256M), NUMA_NO_NODE, name);
> +       if (IS_ERR(window))
> +               return 0;
> +
> +       gen_pool_add_owner(window, cfmws->base_hpa, -1, cfmws->window_size,
> +                          NUMA_NO_NODE, &cfmws_cookie);

Similar comment about the "_owner" variant serving no visible purpose.

These seems to pre-suppose that only the allocator will ever want to
interrogate the state of free space, it might be worth registering
objects for each intersection that are not cxl_regions so that
userspace explicitly sees what the cxl_acpi driver sees in terms of
available resources.

> +
> +       /* Area claimed by other resources, remove those from the gen_pool. */
> +       walk_iomem_res_desc(IORES_DESC_NONE, 0, cfmws->base_hpa,
> +                           cfmws->base_hpa + cfmws->window_size - 1, window,
> +                           fill_busy_mem);
> +       to_cxl_root_decoder(cxld)->window = window;
> +
>         rc = cxl_decoder_add(cxld, target_map);
>         if (rc)
>                 put_device(&cxld->dev);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 85fd5e84f978..0e1c65761ead 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -246,10 +246,12 @@ struct cxl_switch_decoder {
>  /**
>   * struct cxl_root_decoder - A toplevel/platform decoder
>   * @base: Base class decoder
> + * @window: host address space allocator
>   * @targets: Downstream targets (ie. hostbridges).
>   */
>  struct cxl_root_decoder {
>         struct cxl_decoder base;
> +       struct gen_pool *window;
>         struct cxl_decoder_targets *targets;
>  };
>
> --
> 2.35.1
>
