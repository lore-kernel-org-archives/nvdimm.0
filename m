Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x229.google.com (mail-yb0-x229.google.com
 [IPv6:2607:f8b0:4002:c09::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4ED9C21A143D6
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 18:31:16 -0700 (PDT)
Received: by mail-yb0-x229.google.com with SMTP id v197so8189394ybv.3
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 18:32:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170629225911.7896-1-vishal.l.verma@intel.com>
References: <20170629225911.7896-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 18:32:48 -0700
Message-ID: <CAPcyv4iyy-Q7UMRoV8KQfLBL1Y2MZjOdNusSijJ7VCxFQmUQfw@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm, btt: fix btt_rw_page not returning errors
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 29, 2017 at 3:59 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> btt_rw_page was not propagating errors frm btt_do_bvec, resulting in any
> IO errors via the rw_page path going unnoticed. the pmem driver recently
> fixed this in e10624f pmem: fail io-requests to known bad blocks
> but same problem in BTT went neglected.
>
> Fixes: 5212e11 nd_btt: atomic sector updates
> Cc: <stable@vger.kernel.org>
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/nvdimm/btt.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 7ca11df..4e56e72 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1248,10 +1248,13 @@ static int btt_rw_page(struct block_device *bdev, sector_t sector,
>                 struct page *page, bool is_write)
>  {
>         struct btt *btt = bdev->bd_disk->private_data;
> +       int rc;
>
> -       btt_do_bvec(btt, NULL, page, PAGE_SIZE, 0, is_write, sector);
> -       page_endio(page, is_write, 0);
> -       return 0;
> +       rc = btt_do_bvec(btt, NULL, page, PAGE_SIZE, 0, is_write, sector);
> +       if (rc == 0)
> +               page_endio(page, is_write, 0);
> +
> +       return rc;
>  }

Looks obviously correct, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
