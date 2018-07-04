Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 16DAF210E434D
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 07:50:19 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id k81-v6so11194441oib.4
 for <linux-nvdimm@lists.01.org>; Wed, 04 Jul 2018 07:50:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5c7996b8e6d31541f3185f8e4064ff97582c86f8.1530716899.git.yi.z.zhang@linux.intel.com>
References: <cover.1530716899.git.yi.z.zhang@linux.intel.com>
 <5c7996b8e6d31541f3185f8e4064ff97582c86f8.1530716899.git.yi.z.zhang@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 4 Jul 2018 07:50:18 -0700
Message-ID: <CAPcyv4gjFVG7tHv65Z=FsZ9=5wXDxNWawFJqO8MkyMudch4zDw@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm: introduce memory type MEMORY_DEVICE_DEV_DAX
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
To: Zhang Yi <yi.z.zhang@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, "Zhang, Yu C" <yu.c.zhang@intel.com>, KVM list <kvm@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, rkrcmar@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 4, 2018 at 8:30 AM, Zhang Yi <yi.z.zhang@linux.intel.com> wrote:
> Currently, NVDIMM pages will be marked 'PageReserved'. However, unlike
> other reserved PFNs, pages on NVDIMM shall still behave like normal ones
> in many cases, i.e. when used as backend memory of KVM guest. This patch
> introduces a new memory type, MEMORY_DEVICE_DEV_DAX. Together with the
> existing type MEMORY_DEVICE_FS_DAX, we can differentiate the pages on
> NVDIMM with the normal reserved pages.
>
> Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yu <yu.c.zhang@linux.intel.com>
> ---
>  drivers/dax/pmem.c       | 1 +
>  include/linux/memremap.h | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> index fd49b24..fb3f363 100644
> --- a/drivers/dax/pmem.c
> +++ b/drivers/dax/pmem.c
> @@ -111,6 +111,7 @@ static int dax_pmem_probe(struct device *dev)
>                 return rc;
>
>         dax_pmem->pgmap.ref = &dax_pmem->ref;
> +       dax_pmem->pgmap.type = MEMORY_DEVICE_DEV_DAX;
>         addr = devm_memremap_pages(dev, &dax_pmem->pgmap);
>         if (IS_ERR(addr))
>                 return PTR_ERR(addr);
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 5ebfff6..4127bf7 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -58,6 +58,7 @@ enum memory_type {
>         MEMORY_DEVICE_PRIVATE = 1,
>         MEMORY_DEVICE_PUBLIC,
>         MEMORY_DEVICE_FS_DAX,
> +       MEMORY_DEVICE_DEV_DAX,

Please add documentation for this new type to the comment block about
this definition.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
