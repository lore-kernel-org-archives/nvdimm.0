Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 123FC211E094A
 for <linux-nvdimm@lists.01.org>; Mon, 15 Apr 2019 09:29:02 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id n187so14316480oih.6
 for <linux-nvdimm@lists.01.org>; Mon, 15 Apr 2019 09:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190415082357.31127-1-yi.zhang@redhat.com>
In-Reply-To: <20190415082357.31127-1-yi.zhang@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Apr 2019 09:28:49 -0700
Message-ID: <CAPcyv4g5cp=5QZsTi02ouwqLPcoTFmos+146p9_jkgUofEhnzQ@mail.gmail.com>
Subject: Re: [PATCH ndctl] ndctl, region: return the rc value in region_action
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
To: Yi Zhang <yi.zhang@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 15, 2019 at 1:24 AM Yi Zhang <yi.zhang@redhat.com> wrote:
>
> if region_action failed, return the rc valude instead of 0
>
> Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
> ---
>  ndctl/region.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/ndctl/region.c b/ndctl/region.c
> index 993b3f8..7945007 100644
> --- a/ndctl/region.c
> +++ b/ndctl/region.c
> @@ -89,7 +89,7 @@ static int region_action(struct ndctl_region *region, enum device_action mode)
>                 break;
>         }
>
> -       return 0;
> +       return rc;
>  }

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
