Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x242.google.com (mail-ua0-x242.google.com
 [IPv6:2607:f8b0:400c:c08::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D8B681859
 for <linux-nvdimm@lists.01.org>; Wed, 28 Dec 2016 23:43:18 -0800 (PST)
Received: by mail-ua0-x242.google.com with SMTP id 96so15276807uaq.2
 for <linux-nvdimm@lists.01.org>; Wed, 28 Dec 2016 23:43:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <147976134582.93357.14661800715988484489.stgit@djiang5-desk3.ch.intel.com>
References: <147976134582.93357.14661800715988484489.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Dec 2016 23:43:16 -0800
Message-ID: <CAA9_cmdv1G5zKiOU4o=m_g63b_N4xLDupC6mVspYzm9NZk3Edw@mail.gmail.com>
Subject: Re: [PATCH v3] libnvdimm: clear poison in mem map metadata
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

On Mon, Nov 21, 2016 at 12:49 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Clearing out the poison in the metadata block of the namespace before
> we use it. Range from start + 8k to pfn_sb->dataoff.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/pfn_devs.c |   28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index cea8350..7fa428e 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -527,11 +527,39 @@ static struct vmem_altmap *__nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
>                 .base_pfn = init_altmap_base(base),
>                 .reserve = init_altmap_reserve(base),
>         };
> +       sector_t sector;
> +       resource_size_t meta_start, meta_size;
> +       long cleared;
> +       unsigned int sz_align;
>
>         memcpy(res, &nsio->res, sizeof(*res));
>         res->start += start_pad;
>         res->end -= end_trunc;
>
> +       meta_start = res->start + SZ_8K;
> +       meta_size = offset - meta_start + 1;
> +
> +       if (meta_start + meta_size > offset)
> +               return ERR_PTR(-EINVAL);

I missed this patch in the libnvdimm pull request for 4.10-rc1. I
grabbed it for -rc2, but the lines above trigger a regression in the
unit tests. So I dropped it and we should try again with an updated
patch for 4.11 at this point.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
