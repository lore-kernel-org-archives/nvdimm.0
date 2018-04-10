Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E6DA226516C5
 for <linux-nvdimm@lists.01.org>; Mon,  9 Apr 2018 19:39:44 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id c3-v6so9723595oib.5
 for <linux-nvdimm@lists.01.org>; Mon, 09 Apr 2018 19:39:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152331919110.20574.2359248862392897661.stgit@djiang5-desk3.ch.intel.com>
References: <152331919110.20574.2359248862392897661.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 9 Apr 2018 19:39:43 -0700
Message-ID: <CAPcyv4jPDrVAa=BEHz_OU4xktGtRN36NwTZ48KOgkCMfXMQcYg@mail.gmail.com>
Subject: Re: [PATCH] ndctl: fix daxctl list memory leak
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 9, 2018 at 5:13 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> daxctl list is not calling daxctl_unref() when executed succesfully. At the same
> time, daxctl_region_unref() is not being called when daxctl_unref() executes.
> Valgrind is reporting unfreed memory. Adding the appropriate calls to make sure
> all memory allocated are freed for daxctl list.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  daxctl/lib/libdaxctl.c |    7 +++++++
>  daxctl/list.c          |    1 +
>  2 files changed, 8 insertions(+)
>
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index 9e503201..0552f6d7 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -119,11 +119,18 @@ DAXCTL_EXPORT struct daxctl_ctx *daxctl_ref(struct daxctl_ctx *ctx)
>   */
>  DAXCTL_EXPORT void daxctl_unref(struct daxctl_ctx *ctx)
>  {
> +       struct daxctl_region *region;
> +
>         if (ctx == NULL)
>                 return;
>         ctx->refcount--;
>         if (ctx->refcount > 0)
>                 return;
> +
> +       while ((region = list_top(&ctx->regions, struct daxctl_region, list)) !=
> +                       NULL)
> +               daxctl_region_unref(region);
> +
>         info(ctx, "context %p released\n", ctx);
>         free(ctx);
>  }
> diff --git a/daxctl/list.c b/daxctl/list.c
> index 254f0ac9..9b18ae8d 100644
> --- a/daxctl/list.c
> +++ b/daxctl/list.c
> @@ -134,6 +134,7 @@ int cmd_list(int argc, const char **argv, void *ctx)
>         else if (jdevs)
>                 util_display_json_array(stdout, jdevs, jflag);
>
> +       daxctl_unref(ctx);

This should move to daxctl/daxctl.c similar to the ndctl_unref() in
ndctl/ndctl.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
