Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 552FE21F2E108
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 10:01:11 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id l190-v6so11842018oig.9
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 10:01:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152337938996.14344.7696749937613340141.stgit@djiang5-desk3.ch.intel.com>
References: <152337938996.14344.7696749937613340141.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Apr 2018 10:01:10 -0700
Message-ID: <CAPcyv4gXOzP-yFeBftc3T02r3hKNNJ0ENbuP0kKmMKOT3+PALw@mail.gmail.com>
Subject: Re: [PATCH] ndctl: fix libdaxctl memory leak
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

On Tue, Apr 10, 2018 at 9:56 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> When daxctl_unref is releasing the context, we should make sure that the
> regions and devices are also being released.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  daxctl/lib/libdaxctl.c |    7 +++++++
>  1 file changed, 7 insertions(+)
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

Sorry, should have mentioned this before. Why not use
list_for_each_entry_safe() to iterate and delete regions like all the
other free routines?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
