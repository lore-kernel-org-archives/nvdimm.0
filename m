Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A67D4211EABDF
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 14:43:10 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id j10so3067260otq.0
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 14:43:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190325213618.12139-1-pakki001@umn.edu>
In-Reply-To: <20190325213618.12139-1-pakki001@umn.edu>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Mar 2019 14:42:58 -0700
Message-ID: <CAPcyv4jEgTsG5eR0siz71qytcEa7crhm4TpfFzUASoJM3bupiA@mail.gmail.com>
Subject: Re: [PATCH v3] nvdimm: btt_devs: fix a NULL pointer dereference
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
To: Aditya Pakki <pakki001@umn.edu>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Kangjie Lu <kjlu@umn.edu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 25, 2019 at 2:36 PM Aditya Pakki <pakki001@umn.edu> wrote:
>
> In case kmemdup fails, the fix releases resources and returns to
> avoid the NULL pointer dereference.
>
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
>
> ---
> v2: Replace incorrect kfree with ida_simple_remove, suggested by
> Johannes Thumshirn
> v1: Free nd_btt->id in case of failure and avoid double free, suggested
> by Dan Williams
> ---
>  drivers/nvdimm/btt_devs.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> index b72a303176c7..f73fb5fdc93f 100644
> --- a/drivers/nvdimm/btt_devs.c
> +++ b/drivers/nvdimm/btt_devs.c
> @@ -204,8 +204,11 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
>         }
>
>         nd_btt->lbasize = lbasize;
> -       if (uuid)
> +       if (uuid) {
>                 uuid = kmemdup(uuid, 16, GFP_KERNEL);
> +               if (!uuid)
> +                       goto out_put_id;
> +       }
>         nd_btt->uuid = uuid;
>         dev = &nd_btt->dev;
>         dev_set_name(dev, "btt%d.%d", nd_region->id, nd_btt->id);
> @@ -220,6 +223,11 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
>                 return NULL;
>         }
>         return dev;
> +
> +out_put_id:
> +       ida_simple_remove(&nd_region->btt_ida, nd_btt->id);
> +       kfree(nd_btt);

There's still 2 calls to "kfree(nd_btt)" when only one is needed.
Please route them both to the same call.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
