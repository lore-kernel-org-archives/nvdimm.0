Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2E5DB2194D3AE
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jun 2019 12:02:21 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id i8so10543429oth.10
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jun 2019 12:02:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190617122733.22432-1-hch@lst.de>
 <20190617122733.22432-8-hch@lst.de>
In-Reply-To: <20190617122733.22432-8-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Jun 2019 12:02:09 -0700
Message-ID: <CAPcyv4hbGfOawfafqQ-L1CMr6OMFGmnDtdgLTXrgQuPxYNHA2w@mail.gmail.com>
Subject: Re: [PATCH 07/25] memremap: validate the pagemap type passed to
 devm_memremap_pages
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, nouveau@lists.freedesktop.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, linux-pci@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 17, 2019 at 5:27 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Most pgmap types are only supported when certain config options are
> enabled.  Check for a type that is valid for the current configuration
> before setting up the pagemap.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  kernel/memremap.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index 6e1970719dc2..6a2dd31a6250 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -157,6 +157,33 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
>         pgprot_t pgprot = PAGE_KERNEL;
>         int error, nid, is_ram;
>
> +       switch (pgmap->type) {
> +       case MEMORY_DEVICE_PRIVATE:
> +               if (!IS_ENABLED(CONFIG_DEVICE_PRIVATE)) {
> +                       WARN(1, "Device private memory not supported\n");
> +                       return ERR_PTR(-EINVAL);
> +               }
> +               break;
> +       case MEMORY_DEVICE_PUBLIC:
> +               if (!IS_ENABLED(CONFIG_DEVICE_PUBLIC)) {
> +                       WARN(1, "Device public memory not supported\n");
> +                       return ERR_PTR(-EINVAL);
> +               }
> +               break;
> +       case MEMORY_DEVICE_FS_DAX:
> +               if (!IS_ENABLED(CONFIG_ZONE_DEVICE) ||
> +                   IS_ENABLED(CONFIG_FS_DAX_LIMITED)) {
> +                       WARN(1, "File system DAX not supported\n");
> +                       return ERR_PTR(-EINVAL);
> +               }
> +               break;
> +       case MEMORY_DEVICE_PCI_P2PDMA:

Need a lead in patch that introduces MEMORY_DEVICE_DEVDAX, otherwise:

 Invalid pgmap type 0
 WARNING: CPU: 6 PID: 1316 at kernel/memremap.c:183
devm_memremap_pages+0x1d8/0x700
 [..]
 RIP: 0010:devm_memremap_pages+0x1d8/0x700
 [..]
 Call Trace:
  dev_dax_probe+0xc7/0x1e0 [device_dax]
  really_probe+0xef/0x390
  driver_probe_device+0xb4/0x100
  device_driver_attach+0x4f/0x60
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
