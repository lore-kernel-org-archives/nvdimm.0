Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B846C81EBB
 for <linux-nvdimm@lists.01.org>; Wed, 23 Nov 2016 14:31:51 -0800 (PST)
Received: by mail-oi0-x22d.google.com with SMTP id w63so31905556oiw.0
 for <linux-nvdimm@lists.01.org>; Wed, 23 Nov 2016 14:31:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <147735127505.62863.2379314615045728159.stgit@djiang5-desk3.ch.intel.com>
References: <147735127505.62863.2379314615045728159.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Nov 2016 14:31:49 -0800
Message-ID: <CAPcyv4gmiRj7u6SzX+wp-Ue-WbXF0oA1g_9+OW+UHkcmeS4=-Q@mail.gmail.com>
Subject: Re: [PATCH] ndctl: introduce 4k allocation support for creating
 namespace
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Some needed changes I noticed while trying to take this onto the
'pending' branch

On Mon, Oct 24, 2016 at 4:21 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Existing implementation defaults all pages allocated as 2M superpages.
> For nfit_test dax device we need 4k pages allocated to work properly.
> Adding an --align,-a option to provide the alignment. Will accept
> 4k and 2M at the moment as proper parameter. No -a option still defaults
> to 2M.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/builtin-xaction-namespace.c |   22 ++++++++++++++++++++--
>  util/size.h                       |    1 +
>  2 files changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
> index 9b1702d..89ce6ce 100644
> --- a/ndctl/builtin-xaction-namespace.c
> +++ b/ndctl/builtin-xaction-namespace.c
> @@ -49,6 +49,7 @@ static struct parameters {
>         const char *region;
>         const char *reconfig;
>         const char *sector_size;
> +       const char *align;
>  } param;
>
>  void builtin_xaction_namespace_reset(void)
> @@ -71,6 +72,7 @@ struct parsed_parameters {
>         enum ndctl_namespace_mode mode;
>         unsigned long long size;
>         unsigned long sector_size;
> +       unsigned long align;
>  };
>
>  #define debug(fmt, ...) \
> @@ -104,6 +106,8 @@ OPT_STRING('l', "sector-size", &param.sector_size, "lba-size", \
>         "specify the logical sector size in bytes"), \
>  OPT_STRING('t', "type", &param.type, "type", \
>         "specify the type of namespace to create 'pmem' or 'blk'"), \
> +OPT_STRING('a', "align", &param.align, "align", \
> +       "specify the namespace alignment in bytes (default: 0x200000 (2M))"), \
>  OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active")
>
>  static const struct option base_options[] = {
> @@ -319,7 +323,7 @@ static int setup_namespace(struct ndctl_region *region,
>
>                 try(ndctl_pfn, set_uuid, pfn, uuid);
>                 try(ndctl_pfn, set_location, pfn, p->loc);
> -               try(ndctl_pfn, set_align, pfn, SZ_2M);
> +               try(ndctl_pfn, set_align, pfn, p->align);

This will now collide wit the new "ndctl_pfn_has_align()" check that
got added to fix support for pre-4.5 kernels.

>                 try(ndctl_pfn, set_namespace, pfn, ndns);
>                 rc = ndctl_pfn_enable(pfn);
>         } else if (p->mode == NDCTL_NS_MODE_DAX) {
> @@ -327,7 +331,7 @@ static int setup_namespace(struct ndctl_region *region,
>
>                 try(ndctl_dax, set_uuid, dax, uuid);
>                 try(ndctl_dax, set_location, dax, p->loc);
> -               try(ndctl_dax, set_align, dax, SZ_2M);
> +               try(ndctl_dax, set_align, dax, p->align);
>                 try(ndctl_dax, set_namespace, dax, ndns);
>                 rc = ndctl_dax_enable(dax);
>         } else if (p->mode == NDCTL_NS_MODE_SAFE) {
> @@ -383,6 +387,20 @@ static int validate_namespace_options(struct ndctl_region *region,
>
>         memset(p, 0, sizeof(*p));
>
> +       if (param.align) {
> +               p->align = parse_size64(param.align);
> +               switch (p->align) {
> +               case SZ_4K:
> +               case SZ_2M:
> +                       break;
> +               case SZ_1G: /* unsupported yet... */
> +               default:
> +                       debug("%s: invalid align\n", __func__);
> +                       return -EINVAL;
> +               }
> +       } else
> +               p->align = SZ_2M;
> +

I think this check should come after we have determined that the mode
is either "memory" or "dax", and error out otherwise.  Also, when the
alignment is not 2M, we should check that the kernel has alignment
setting support with the new ndctl_pfn_has_align() api.  Note that
kernels that support device-dax implicitly support the alignment
property.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
