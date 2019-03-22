Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F51A2194EB7C
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 15:55:22 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id o74so3366737ota.3
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 15:55:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190312081529.4889-1-kjlu@umn.edu>
In-Reply-To: <20190312081529.4889-1-kjlu@umn.edu>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Mar 2019 15:55:10 -0700
Message-ID: <CAPcyv4jfoUCK8dCCgGRG3GPxxk2mgrQd=zpJ9OnwzngXJ+LwpA@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: btt_devs: fix a NULL pointer dereference and a
 memory leak
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
To: Kangjie Lu <kjlu@umn.edu>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, pakki001@umn.edu, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 12, 2019 at 1:16 AM Kangjie Lu <kjlu@umn.edu> wrote:
>
> In case kmemdup fails, the fix releases resources and returns to
> avoid the NULL pointer dereference.
> Also, the error paths in the following code should release
> resources to avoid memory leaks.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/nvdimm/btt_devs.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> index 795ad4ff35ca..565ea0b6f765 100644
> --- a/drivers/nvdimm/btt_devs.c
> +++ b/drivers/nvdimm/btt_devs.c
> @@ -196,8 +196,13 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
>         }
>
>         nd_btt->lbasize = lbasize;
> -       if (uuid)
> +       if (uuid) {
>                 uuid = kmemdup(uuid, 16, GFP_KERNEL);
> +               if (!uuid) {
> +                       kfree(nd_btt);
> +                       return NULL;

What about nd_btt->id? That needs to be released as well.

> +               }
> +       }
>         nd_btt->uuid = uuid;
>         dev = &nd_btt->dev;
>         dev_set_name(dev, "btt%d.%d", nd_region->id, nd_btt->id);
> @@ -209,6 +214,7 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
>                 dev_dbg(&ndns->dev, "failed, already claimed by %s\n",
>                                 dev_name(ndns->claim));
>                 put_device(dev);
> +               kfree(uuid);

This will be a double free because put_device() will arrange for
nd_btt_release() to be called which does kfree(nd_btt->uuid);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
