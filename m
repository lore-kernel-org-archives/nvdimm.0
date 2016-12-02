Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D92B81F47
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 12:51:57 -0800 (PST)
Received: by mail-oi0-x230.google.com with SMTP id b126so279427740oia.2
 for <linux-nvdimm@lists.01.org>; Fri, 02 Dec 2016 12:51:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480706436-21058-1-git-send-email-fabf@skynet.be>
References: <1480706436-21058-1-git-send-email-fabf@skynet.be>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Dec 2016 12:51:55 -0800
Message-ID: <CAPcyv4gU7=gBUfOe3c_EUGKX3xc8bnbBXTSVJ9-MTqbbJ9MksA@mail.gmail.com>
Subject: Re: [PATCH 3/8 linux-next] libnvdimm,
 namespace: move persistence warning
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
To: Fabian Frederick <fabf@skynet.be>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 2, 2016 at 11:20 AM, Fabian Frederick <fabf@skynet.be> wrote:
> There's no need to warn on persistence yet as some validity tests
> are on the way.
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/nvdimm/pmem.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 822a712..204912c 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -266,9 +266,6 @@ static int pmem_attach_disk(struct device *dev,
>         dev_set_drvdata(dev, pmem);
>         pmem->phys_addr = res->start;
>         pmem->size = resource_size(res);
> -       if (nvdimm_has_flush(nd_region) < 0)
> -               dev_warn(dev, "unable to guarantee persistence of writes due to unknown flushing capability of the memory region\n");
> -
>         if (!devm_request_mem_region(dev, res->start, resource_size(res),
>                                 dev_name(dev))) {
>                 dev_warn(dev, "could not reserve region %pR\n", res);
> @@ -279,6 +276,9 @@ static int pmem_attach_disk(struct device *dev,
>         if (!q)
>                 return -ENOMEM;
>
> +       if (nvdimm_has_flush(nd_region) < 0)
> +               dev_warn(dev, "unable to guarantee persistence of writes due to unknown flushing capability of the memory region\n");
> +
>         pmem->pfn_flags = PFN_DEV;
>         if (is_nd_pfn(dev)) {
>                 addr = devm_memremap_pages(dev, &pfn_res, &q->q_usage_counter,

With the new sub-section hotplug support I don't think we need this.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
