Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4269B1A1DF9
 for <linux-nvdimm@lists.01.org>; Wed, 31 Aug 2016 09:19:20 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id f189so77522364oig.3
 for <linux-nvdimm@lists.01.org>; Wed, 31 Aug 2016 09:19:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1472636725-27686-1-git-send-email-geert+renesas@glider.be>
References: <1472636725-27686-1-git-send-email-geert+renesas@glider.be>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 31 Aug 2016 09:19:18 -0700
Message-ID: <CAPcyv4hhH1h+i=MVT90a6-a6Nv4mi3FCDCyAhAaQQHV9Fv5t0A@mail.gmail.com>
Subject: Re: [PATCH] [trivial] nvdimm: Spelling
 s/unacknoweldged/unacknowledged/
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
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jiri Kosina <trivial@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 31, 2016 at 2:45 AM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/nvdimm/namespace_devs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index c5e3196c45b02cc5..6b0449bd7720b7c0 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -294,7 +294,7 @@ static bool __nd_namespace_blk_validate(struct nd_namespace_blk *nsblk)
>                 if (strcmp(res->name, label_id.id) != 0)
>                         continue;
>                 /*
> -                * Resources with unacknoweldged adjustments indicate a
> +                * Resources with unacknowledged adjustments indicate a
>                  * failure to update labels
>                  */
>                 if (res->flags & DPA_RESOURCE_ADJUSTED)

Thanks, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
