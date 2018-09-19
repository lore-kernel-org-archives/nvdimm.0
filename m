Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 91E382114300B
 for <linux-nvdimm@lists.01.org>; Tue, 18 Sep 2018 19:43:32 -0700 (PDT)
Date: Tue, 18 Sep 2018 22:43:31 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1394508970.13987303.1537325011734.JavaMail.zimbra@redhat.com>
In-Reply-To: <c0b53c74379e6d654bbe42471fcef8aa5fd22efd.1534934405.git.yi.z.zhang@linux.intel.com>
References: <cover.1534934405.git.yi.z.zhang@linux.intel.com>
 <c0b53c74379e6d654bbe42471fcef8aa5fd22efd.1534934405.git.yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH V4 2/4] mm: introduce memory type MEMORY_DEVICE_DEV_DAX
MIME-Version: 1.0
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
Cc: jglisse@redhat.com, yu c zhang <yu.c.zhang@intel.com>, kvm@vger.kernel.org, linux-nvdimm@lists.01.org, jack@suse.cz, david@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, rkrcmar@redhat.com, pbonzini@redhat.com, hch@lst.de, yi z zhang <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>


> 
> Currently, NVDIMM pages will be marked 'PageReserved'. However, unlike
> other reserved PFNs, pages on NVDIMM shall still behave like normal ones
> in many cases, i.e. when used as backend memory of KVM guest. This patch
> introduces a new memory type, MEMORY_DEVICE_DEV_DAX. And set this flag
> while dax driver hotplug the device memory.
> 
> Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yu <yu.c.zhang@linux.intel.com>
> Reviewed-by: Jan Kara suse.cz>
> ---
>  drivers/dax/pmem.c       | 1 +
>  include/linux/memremap.h | 8 ++++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> index fd49b24..fb3f363 100644
> --- a/drivers/dax/pmem.c
> +++ b/drivers/dax/pmem.c
> @@ -111,6 +111,7 @@ static int dax_pmem_probe(struct device *dev)
>                  return rc;
>  
>          dax_pmem->pgmap.ref = &dax_pmem->ref;
> +        dax_pmem->pgmap.type = MEMORY_DEVICE_DEV_DAX;
>          addr = devm_memremap_pages(dev, &dax_pmem->pgmap);
>          if (IS_ERR(addr))
>                  return PTR_ERR(addr);
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index f91f9e7..cd07ca8 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -53,11 +53,19 @@ struct vmem_altmap {
>   * wakeup event whenever a page is unpinned and becomes idle. This
>   * wakeup is used to coordinate physical address space management (ex:
>   * fs truncate/hole punch) vs pinned pages (ex: device dma).
> + *
> + * MEMORY_DEVICE_DEV_DAX:
> + * Device memory that support raw access to persistent memory. Without need
> + * of an intervening filesystem, it could be directed mapped via an mmap
> + * capable character device. Together with the type MEMORY_DEVICE_FS_DAX,
> + * we could distinguish the persistent memory pages from normal ZONE_DEVICE
> + * pages.
>   */
>  enum memory_type {
>          MEMORY_DEVICE_PRIVATE = 1,
>          MEMORY_DEVICE_PUBLIC,
>          MEMORY_DEVICE_FS_DAX,
> +        MEMORY_DEVICE_DEV_DAX,
>  };
>  
>  /*
> --

Reviewed-by: Pankaj Gupta <pagupta@redhat.com>

> 2.7.4
> 
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
