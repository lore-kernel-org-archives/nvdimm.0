Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F6502128D882
 for <linux-nvdimm@lists.01.org>; Tue, 28 May 2019 17:27:17 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id n18so312025otq.0
 for <linux-nvdimm@lists.01.org>; Tue, 28 May 2019 17:27:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190528222440.30392-1-vishal.l.verma@intel.com>
 <20190528222440.30392-3-vishal.l.verma@intel.com>
In-Reply-To: <20190528222440.30392-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 May 2019 17:27:05 -0700
Message-ID: <CAPcyv4heAvTzOePSe=uJ_+p4gOqG9d9Eqec_nA21P8KzzXS+kw@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 02/10] libdaxctl: cache 'subsystem' in daxctl_ctx
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 28, 2019 at 3:24 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The 'DAX subsystem' in effect is determined at region or device init
> time, and dictates the sysfs base paths for all device/region
> operations. In preparation for adding bind/unbind functionality, cache
> the subsystem as determined at init time in the library context.

I'm missing how this patch determines the subsystem at init time? ...more below.

>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  daxctl/lib/libdaxctl.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index 70f896b..f8f5b8c 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -46,6 +46,7 @@ struct daxctl_ctx {
>         void *userdata;
>         int regions_init;
>         struct list_head regions;
> +       enum dax_subsystem subsys;
>  };
>
>  /**
> @@ -96,6 +97,7 @@ DAXCTL_EXPORT int daxctl_new(struct daxctl_ctx **ctx)
>         dbg(c, "log_priority=%d\n", c->ctx.log_priority);
>         *ctx = c;
>         list_head_init(&c->regions);
> +       c->subsys = DAX_UNKNOWN;
>
>         return 0;
>  }
> @@ -454,14 +456,18 @@ static void dax_devices_init(struct daxctl_region *region)
>         for (i = 0; i < ARRAY_SIZE(dax_subsystems); i++) {
>                 char *region_path;
>
> -               if (i == DAX_BUS)
> +               if (i == DAX_BUS) {
>                         region_path = region->region_path;
> -               else if (i == DAX_CLASS) {
> +                       if (ctx->subsys == DAX_UNKNOWN)
> +                               ctx->subsys = DAX_BUS;
> +               } else if (i == DAX_CLASS) {
>                         if (asprintf(&region_path, "%s/dax",
>                                                 region->region_path) < 0) {
>                                 dbg(ctx, "region path alloc fail\n");
>                                 continue;
>                         }
> +                       if (ctx->subsys == DAX_UNKNOWN)
> +                               ctx->subsys = DAX_CLASS;
>                 } else
>                         continue;
>                 sysfs_device_parse(ctx, region_path, daxdev_fmt, region,

dax_devices_init() is just blindly looping through both device models
attempting to add devices. If this patch was detecting device-models I
would expect it would be looking for the first successful
sysfs_device_parse() to judge which of those blind shots actually
worked.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
