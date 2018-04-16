Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 66D812263DD78
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 10:29:35 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id u84-v6so15304273oie.10
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 10:29:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180416165816.15470-1-robh@kernel.org>
References: <20180416165816.15470-1-robh@kernel.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 Apr 2018 10:29:34 -0700
Message-ID: <CAPcyv4gixx0vH1Q87KLzYj6ajmxKSSP9Lf_mNHH3+zHtOUkTnQ@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm,
 of_pmem: use dev_to_node() instead of of_node_to_nid()
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
To: Rob Herring <robh@kernel.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 16, 2018 at 9:58 AM, Rob Herring <robh@kernel.org> wrote:
> Remove the direct dependency on of_node_to_nid() by using dev_to_node()
> instead. Any DT platform device will have its NUMA node id set when the
> device is created.
>
> With this, commit 291717b6fbdb ("libnvdimm, of_pmem: workaround OF_NUMA=n
> build error") can be reverted.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Oliver O'Halloran <oohall@gmail.com>
> Cc: linux-nvdimm@lists.01.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  drivers/nvdimm/of_pmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
> index 85013bad35de..0a701837dfc0 100644
> --- a/drivers/nvdimm/of_pmem.c
> +++ b/drivers/nvdimm/of_pmem.c
> @@ -67,7 +67,7 @@ static int of_pmem_region_probe(struct platform_device *pdev)
>                  */
>                 memset(&ndr_desc, 0, sizeof(ndr_desc));
>                 ndr_desc.attr_groups = region_attr_groups;
> -               ndr_desc.numa_node = of_node_to_nid(np);
> +               ndr_desc.numa_node = dev_to_node(&pdev->dev);
>                 ndr_desc.res = &pdev->resource[i];
>                 ndr_desc.of_node = np;
>                 set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);

Thanks Rob, we'll get this queued up for 4.17-rc2.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
