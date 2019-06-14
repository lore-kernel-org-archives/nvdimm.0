Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from hqemgate14.nvidia.com (hqemgate14.nvidia.com [216.228.121.143])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CC2C621296B26
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jun 2019 18:53:18 -0700 (PDT)
Subject: Re: [Nouveau] [PATCH 22/22] mm: don't select MIGRATE_VMA_HELPER from
 HMM_MIRROR
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-23-hch@lst.de>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <7f6c6837-93cd-3b89-63fb-7a60d906c70c@nvidia.com>
Date: Thu, 13 Jun 2019 18:53:15 -0700
MIME-Version: 1.0
In-Reply-To: <20190613094326.24093-23-hch@lst.de>
Content-Language: en-US
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
To: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, nouveau@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

On 6/13/19 2:43 AM, Christoph Hellwig wrote:
> The migrate_vma helper is only used by noveau to migrate device private
> pages around.  Other HMM_MIRROR users like amdgpu or infiniband don't
> need it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/gpu/drm/nouveau/Kconfig | 1 +
>  mm/Kconfig                      | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
> index 66c839d8e9d1..96b9814e6d06 100644
> --- a/drivers/gpu/drm/nouveau/Kconfig
> +++ b/drivers/gpu/drm/nouveau/Kconfig
> @@ -88,6 +88,7 @@ config DRM_NOUVEAU_SVM
>  	depends on DRM_NOUVEAU
>  	depends on HMM_MIRROR
>  	depends on STAGING
> +	select MIGRATE_VMA_HELPER
>  	default n
>  	help
>  	  Say Y here if you want to enable experimental support for
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 73676cb4693f..eca88679b624 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -679,7 +679,6 @@ config HMM_MIRROR
>  	bool "HMM mirror CPU page table into a device page table"
>  	depends on MMU
>  	select MMU_NOTIFIER
> -	select MIGRATE_VMA_HELPER
>  	help
>  	  Select HMM_MIRROR if you want to mirror range of the CPU page table of a
>  	  process into a device page table. Here, mirror means "keep synchronized".
> 

For those who have out of tree drivers that need migrate_vma(), but are not
Nouveau, could we pretty please allow a way to select that independently?

It's not a big deal, as I expect the Nouveau option will normally be selected, 
but it would be nice. Because there is a valid configuration that involves 
Nouveau not being selected, but our driver still wanting to run.

Maybe we can add something like this on top of what you have?

diff --git a/mm/Kconfig b/mm/Kconfig
index eca88679b624..330996632513 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -670,7 +670,10 @@ config ZONE_DEVICE
          If FS_DAX is enabled, then say Y.
 
 config MIGRATE_VMA_HELPER
-       bool
+       bool "migrate_vma() helper routine"
+       help
+         Provides a migrate_vma() routine that GPUs and other
+         device drivers may need.
 
 config DEV_PAGEMAP_OPS
        bool



thanks,
-- 
John Hubbard
NVIDIA
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
