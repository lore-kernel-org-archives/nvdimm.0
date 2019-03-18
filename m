Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F0CEE2194EB77
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 15:56:44 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id r19so16010248otn.1
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 15:56:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190318225337.2648-1-vishal.l.verma@intel.com>
In-Reply-To: <20190318225337.2648-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Mar 2019 15:56:32 -0700
Message-ID: <CAPcyv4jGEKm+V-aBJStNbD1kkqPn=gP=8Hskj9kVG6VqN4aFUg@mail.gmail.com>
Subject: Re: [PATCH] dax/pmem: Fix whitespace in dax_pmem
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 18, 2019 at 3:54 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> A few lines were whitespace damaged, with spaces at the start instead of
> tabs. This was noticed while debugging an nfit_test failure, so fix
> them.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/dax/pmem/core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/dax/pmem/core.c b/drivers/dax/pmem/core.c
> index f71019ce0647..f9f51786d556 100644
> --- a/drivers/dax/pmem/core.c
> +++ b/drivers/dax/pmem/core.c
> @@ -37,13 +37,13 @@ struct dev_dax *__dax_pmem_probe(struct device *dev, enum dev_dax_subsys subsys)
>         devm_nsio_disable(dev, nsio);
>
>         /* reserve the metadata area, device-dax will reserve the data */
> -        pfn_sb = nd_pfn->pfn_sb;
> +       pfn_sb = nd_pfn->pfn_sb;
>         offset = le64_to_cpu(pfn_sb->dataoff);
>         if (!devm_request_mem_region(dev, nsio->res.start, offset,
>                                 dev_name(&ndns->dev))) {
> -                dev_warn(dev, "could not reserve metadata\n");
> +               dev_warn(dev, "could not reserve metadata\n");
>                 return ERR_PTR(-EBUSY);
> -        }
> +       }

Looks good to me, literally, no chance of regression :).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
