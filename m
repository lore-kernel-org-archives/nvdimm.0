Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 144D621295CA6
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jun 2019 12:25:29 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id i8so10667107oth.10
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jun 2019 12:25:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190617122733.22432-1-hch@lst.de>
 <20190617122733.22432-11-hch@lst.de>
In-Reply-To: <20190617122733.22432-11-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Jun 2019 12:25:17 -0700
Message-ID: <CAPcyv4jtZSK7bgQX_Sm1E-Thqmyhs30SrZKoSApjghRLL12Ngg@mail.gmail.com>
Subject: Re: [PATCH 10/25] memremap: lift the devmap_enable manipulation into
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

On Mon, Jun 17, 2019 at 5:28 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Just check if there is a ->page_free operation set and take care of the
> static key enable, as well as the put using device managed resources.
> Also check that a ->page_free is provided for the pgmaps types that
> require it, and check for a valid type as well while we are at it.
>
> Note that this also fixes the fact that hmm never called
> dev_pagemap_put_ops and thus would leave the slow path enabled forever,
> even after a device driver unload or disable.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/nvdimm/pmem.c | 23 +++--------------
>  include/linux/mm.h    | 10 --------
>  kernel/memremap.c     | 57 ++++++++++++++++++++++++++-----------------
>  mm/hmm.c              |  2 --
>  4 files changed, 39 insertions(+), 53 deletions(-)
>
[..]
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index ba7156bd52d1..7272027fbdd7 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
[..]
> @@ -190,6 +219,12 @@ void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
>                 return ERR_PTR(-EINVAL);
>         }
>
> +       if (pgmap->type != MEMORY_DEVICE_PCI_P2PDMA) {

Once we have MEMORY_DEVICE_DEVDAX then this check needs to be fixed up
to skip that case as well, otherwise:

 Missing page_free method
 WARNING: CPU: 19 PID: 1518 at kernel/memremap.c:33
devm_memremap_pages+0x745/0x7d0
 RIP: 0010:devm_memremap_pages+0x745/0x7d0
 Call Trace:
  dev_dax_probe+0xc6/0x1e0 [device_dax]
  really_probe+0xef/0x390
  ? driver_allows_async_probing+0x50/0x50
  driver_probe_device+0xb4/0x100
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
