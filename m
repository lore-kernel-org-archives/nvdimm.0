Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D448E2215BD9D
 for <linux-nvdimm@lists.01.org>; Mon, 29 Jan 2018 12:41:14 -0800 (PST)
Received: by mail-ot0-x241.google.com with SMTP id r23so6362329ote.8
 for <linux-nvdimm@lists.01.org>; Mon, 29 Jan 2018 12:46:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180129202236.9744-1-vishal.l.verma@intel.com>
References: <20180129202236.9744-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Jan 2018 12:46:47 -0800
Message-ID: <CAPcyv4jkMNkem4MRRUQRkBGuLgtVekhs0xti3fbCGAe72-uC3Q@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: fix the default BTT sector size for reconfig
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 29, 2018 at 12:22 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> reconfig attempted to reuse the 'previous' value for sector-size when
> reconfiguring to a BTT mode or blk type namespace, but this may not
> always be valid (for example when coming from a memory mode namespace).
> Instead, when reconfiguring to BTT or blk, always default to 4096
> unless a sector size is explicitly provided.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Tested-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/namespace.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index c793ba3..ceb9e7a 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -244,12 +244,10 @@ static int set_defaults(enum device_action mode)
>                         error("invalid sector size: %s\n", param.sector_size);
>                         rc = -EINVAL;
>                 }
> -       } else if (!param.reconfig
> -                       && ((param.type && strcmp(param.type, "blk") == 0)
> -                               || (param.mode
> -                                       && strcmp(param.mode, "safe") == 0))) {
> -                       /* default sector size for blk-type or safe-mode */
> -                       param.sector_size = "4096";
> +       } else if (((param.type && strcmp(param.type, "blk") == 0)
> +                       || (param.mode && strcmp(param.mode, "safe") == 0))) {
> +               /* default sector size for blk-type or safe-mode */
> +               param.sector_size = "4096";

Looks good to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
