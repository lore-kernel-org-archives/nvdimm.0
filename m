Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DC771224A9EB2
 for <linux-nvdimm@lists.01.org>; Fri, 30 Mar 2018 03:37:53 -0700 (PDT)
Date: Fri, 30 Mar 2018 12:37:50 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v7 09/14] mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
Message-ID: <20180330103750.b7ped5ob4yc2cwdu@quack2.suse.cz>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167307925.5268.8460609293976880720.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152167307925.5268.8460609293976880720.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Wed 21-03-18 15:57:59, Dan Williams wrote:
> The HMM sub-system extended dev_pagemap to arrange a callback when a
> dev_pagemap managed page is freed. Since a dev_pagemap page is free /
> idle when its reference count is 1 it requires an additional branch to
> check the page-type at put_page() time. Given put_page() is a hot-path
> we do not want to incur that check if HMM is not in use, so a static
> branch is used to avoid that overhead when not necessary.
> =

> Now, the FS_DAX implementation wants to reuse this mechanism for
> receiving dev_pagemap ->page_free() callbacks. Rework the HMM-specific
> static-key into a generic mechanism that either HMM or FS_DAX code paths
> can enable.
> =

> Cc: Michal Hocko <mhocko@suse.com>
> Reviewed-by: "J=E9r=F4me Glisse" <jglisse@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/dax/super.c      |    2 ++
>  fs/Kconfig               |    1 +
>  include/linux/memremap.h |   20 ++-------------
>  include/linux/mm.h       |   61 ++++++++++++++++++++++++++++++++--------=
------
>  kernel/memremap.c        |   30 ++++++++++++++++++++---
>  mm/Kconfig               |    5 ++++
>  mm/hmm.c                 |   13 ++--------
>  mm/swap.c                |    3 ++
>  8 files changed, 84 insertions(+), 51 deletions(-)
> =

> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index ecefe9f7eb60..619b1ed6434c 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -191,6 +191,7 @@ struct dax_device *fs_dax_claim_bdev(struct block_dev=
ice *bdev, void *owner)
>  		return NULL;
>  	}
>  =

> +	dev_pagemap_get_ops();
>  	pgmap->type =3D MEMORY_DEVICE_FS_DAX;
>  	pgmap->page_free =3D generic_dax_pagefree;
>  	pgmap->data =3D owner;
> @@ -215,6 +216,7 @@ void fs_dax_release(struct dax_device *dax_dev, void =
*owner)
>  	pgmap->type =3D MEMORY_DEVICE_HOST;
>  	pgmap->page_free =3D NULL;
>  	pgmap->data =3D NULL;
> +	dev_pagemap_put_ops();
>  	mutex_unlock(&devmap_lock);
>  }
>  EXPORT_SYMBOL_GPL(fs_dax_release);
> diff --git a/fs/Kconfig b/fs/Kconfig
> index bc821a86d965..1f0832bbc32f 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -38,6 +38,7 @@ config FS_DAX
>  	bool "Direct Access (DAX) support"
>  	depends on MMU
>  	depends on !(ARM || MIPS || SPARC)
> +	select DEV_PAGEMAP_OPS
>  	select FS_IOMAP
>  	select DAX
>  	help
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 02d6d042ee7f..9faf25d6abef 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -1,7 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #ifndef _LINUX_MEMREMAP_H_
>  #define _LINUX_MEMREMAP_H_
> -#include <linux/mm.h>
>  #include <linux/ioport.h>
>  #include <linux/percpu-refcount.h>
>  =

> @@ -130,6 +129,9 @@ struct dev_pagemap {
>  	enum memory_type type;
>  };
>  =

> +void dev_pagemap_get_ops(void);
> +void dev_pagemap_put_ops(void);
> +
>  #ifdef CONFIG_ZONE_DEVICE
>  void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
>  struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
> @@ -137,8 +139,6 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
>  =

>  unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
>  void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns);
> -
> -static inline bool is_zone_device_page(const struct page *page);
>  #else
>  static inline void *devm_memremap_pages(struct device *dev,
>  		struct dev_pagemap *pgmap)
> @@ -169,20 +169,6 @@ static inline void vmem_altmap_free(struct vmem_altm=
ap *altmap,
>  }
>  #endif /* CONFIG_ZONE_DEVICE */
>  =

> -#if defined(CONFIG_DEVICE_PRIVATE) || defined(CONFIG_DEVICE_PUBLIC)
> -static inline bool is_device_private_page(const struct page *page)
> -{
> -	return is_zone_device_page(page) &&
> -		page->pgmap->type =3D=3D MEMORY_DEVICE_PRIVATE;
> -}
> -
> -static inline bool is_device_public_page(const struct page *page)
> -{
> -	return is_zone_device_page(page) &&
> -		page->pgmap->type =3D=3D MEMORY_DEVICE_PUBLIC;
> -}
> -#endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
> -
>  static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
>  {
>  	if (pgmap)
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ad06d42adb1a..088c76bce360 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -812,27 +812,55 @@ static inline bool is_zone_device_page(const struct=
 page *page)
>  }
>  #endif
>  =

> -#if defined(CONFIG_DEVICE_PRIVATE) || defined(CONFIG_DEVICE_PUBLIC)
> -void put_zone_device_private_or_public_page(struct page *page);
> -DECLARE_STATIC_KEY_FALSE(device_private_key);
> -#define IS_HMM_ENABLED static_branch_unlikely(&device_private_key)
> -static inline bool is_device_private_page(const struct page *page);
> -static inline bool is_device_public_page(const struct page *page);
> -#else /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
> -static inline void put_zone_device_private_or_public_page(struct page *p=
age)
> +#ifdef CONFIG_DEV_PAGEMAP_OPS
> +void __put_devmap_managed_page(struct page *page);
> +DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
> +static inline bool put_devmap_managed_page(struct page *page)
>  {
> +	if (!static_branch_unlikely(&devmap_managed_key))
> +		return false;
> +	if (!is_zone_device_page(page))
> +		return false;
> +	switch (page->pgmap->type) {
> +	case MEMORY_DEVICE_PRIVATE:
> +	case MEMORY_DEVICE_PUBLIC:
> +	case MEMORY_DEVICE_FS_DAX:
> +		__put_devmap_managed_page(page);
> +		return true;
> +	default:
> +		break;
> +	}
> +	return false;
>  }
> -#define IS_HMM_ENABLED 0
> +
>  static inline bool is_device_private_page(const struct page *page)
>  {
> -	return false;
> +	return is_zone_device_page(page) &&
> +		page->pgmap->type =3D=3D MEMORY_DEVICE_PRIVATE;
>  }
> +
>  static inline bool is_device_public_page(const struct page *page)
>  {
> +	return is_zone_device_page(page) &&
> +		page->pgmap->type =3D=3D MEMORY_DEVICE_PUBLIC;
> +}
> +
> +#else /* CONFIG_DEV_PAGEMAP_OPS */
> +static inline bool put_devmap_managed_page(struct page *page)
> +{
>  	return false;
>  }
> -#endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
>  =

> +static inline bool is_device_private_page(const struct page *page)
> +{
> +	return false;
> +}
> +
> +static inline bool is_device_public_page(const struct page *page)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_DEV_PAGEMAP_OPS */
>  =

>  static inline void get_page(struct page *page)
>  {
> @@ -850,16 +878,13 @@ static inline void put_page(struct page *page)
>  	page =3D compound_head(page);
>  =

>  	/*
> -	 * For private device pages we need to catch refcount transition from
> -	 * 2 to 1, when refcount reach one it means the private device page is
> -	 * free and we need to inform the device driver through callback. See
> +	 * For devmap managed pages we need to catch refcount transition from
> +	 * 2 to 1, when refcount reach one it means the page is free and we
> +	 * need to inform the device driver through callback. See
>  	 * include/linux/memremap.h and HMM for details.
>  	 */
> -	if (IS_HMM_ENABLED && unlikely(is_device_private_page(page) ||
> -	    unlikely(is_device_public_page(page)))) {
> -		put_zone_device_private_or_public_page(page);
> +	if (put_devmap_managed_page(page))
>  		return;
> -	}
>  =

>  	if (put_page_testzero(page))
>  		__put_page(page);
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index 4dd4274cabe2..72d0bb6fc47d 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -476,8 +476,30 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pf=
n,
>  }
>  #endif /* CONFIG_ZONE_DEVICE */
>  =

> -#if IS_ENABLED(CONFIG_DEVICE_PRIVATE) ||  IS_ENABLED(CONFIG_DEVICE_PUBLI=
C)
> -void put_zone_device_private_or_public_page(struct page *page)
> +#ifdef CONFIG_DEV_PAGEMAP_OPS
> +DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
> +EXPORT_SYMBOL_GPL(devmap_managed_key);
> +static atomic_t devmap_enable;
> +
> +/*
> + * Toggle the static key for ->page_free() callbacks when dev_pagemap
> + * pages go idle.
> + */
> +void dev_pagemap_get_ops(void)
> +{
> +	if (atomic_inc_return(&devmap_enable) =3D=3D 1)
> +		static_branch_enable(&devmap_managed_key);
> +}
> +EXPORT_SYMBOL_GPL(dev_pagemap_get_ops);
> +
> +void dev_pagemap_put_ops(void)
> +{
> +	if (atomic_dec_and_test(&devmap_enable))
> +		static_branch_disable(&devmap_managed_key);
> +}
> +EXPORT_SYMBOL_GPL(dev_pagemap_put_ops);
> +
> +void __put_devmap_managed_page(struct page *page)
>  {
>  	int count =3D page_ref_dec_return(page);
>  =

> @@ -497,5 +519,5 @@ void put_zone_device_private_or_public_page(struct pa=
ge *page)
>  	} else if (!count)
>  		__put_page(page);
>  }
> -EXPORT_SYMBOL(put_zone_device_private_or_public_page);
> -#endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
> +EXPORT_SYMBOL_GPL(__put_devmap_managed_page);
> +#endif /* CONFIG_DEV_PAGEMAP_OPS */
> diff --git a/mm/Kconfig b/mm/Kconfig
> index c782e8fb7235..dc32828984a3 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -700,6 +700,9 @@ config ARCH_HAS_HMM
>  config MIGRATE_VMA_HELPER
>  	bool
>  =

> +config DEV_PAGEMAP_OPS
> +	bool
> +
>  config HMM
>  	bool
>  	select MIGRATE_VMA_HELPER
> @@ -720,6 +723,7 @@ config DEVICE_PRIVATE
>  	bool "Unaddressable device memory (GPU memory, ...)"
>  	depends on ARCH_HAS_HMM
>  	select HMM
> +	select DEV_PAGEMAP_OPS
>  =

>  	help
>  	  Allows creation of struct pages to represent unaddressable device
> @@ -730,6 +734,7 @@ config DEVICE_PUBLIC
>  	bool "Addressable device memory (like GPU memory)"
>  	depends on ARCH_HAS_HMM
>  	select HMM
> +	select DEV_PAGEMAP_OPS
>  =

>  	help
>  	  Allows creation of struct pages to represent addressable device
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 320545b98ff5..4aa554e76d06 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -35,15 +35,6 @@
>  =

>  #define PA_SECTION_SIZE (1UL << PA_SECTION_SHIFT)
>  =

> -#if defined(CONFIG_DEVICE_PRIVATE) || defined(CONFIG_DEVICE_PUBLIC)
> -/*
> - * Device private memory see HMM (Documentation/vm/hmm.txt) or hmm.h
> - */
> -DEFINE_STATIC_KEY_FALSE(device_private_key);
> -EXPORT_SYMBOL(device_private_key);
> -#endif /* CONFIG_DEVICE_PRIVATE || CONFIG_DEVICE_PUBLIC */
> -
> -
>  #if IS_ENABLED(CONFIG_HMM_MIRROR)
>  static const struct mmu_notifier_ops hmm_mmu_notifier_ops;
>  =

> @@ -996,7 +987,7 @@ struct hmm_devmem *hmm_devmem_add(const struct hmm_de=
vmem_ops *ops,
>  	resource_size_t addr;
>  	int ret;
>  =

> -	static_branch_enable(&device_private_key);
> +	dev_pagemap_get_ops();
>  =

>  	devmem =3D devres_alloc_node(&hmm_devmem_release, sizeof(*devmem),
>  				   GFP_KERNEL, dev_to_node(device));
> @@ -1090,7 +1081,7 @@ struct hmm_devmem *hmm_devmem_add_resource(const st=
ruct hmm_devmem_ops *ops,
>  	if (res->desc !=3D IORES_DESC_DEVICE_PUBLIC_MEMORY)
>  		return ERR_PTR(-EINVAL);
>  =

> -	static_branch_enable(&device_private_key);
> +	dev_pagemap_get_ops();
>  =

>  	devmem =3D devres_alloc_node(&hmm_devmem_release, sizeof(*devmem),
>  				   GFP_KERNEL, dev_to_node(device));
> diff --git a/mm/swap.c b/mm/swap.c
> index 0f17330dd0e5..eed846cfc8b8 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -29,6 +29,7 @@
>  #include <linux/cpu.h>
>  #include <linux/notifier.h>
>  #include <linux/backing-dev.h>
> +#include <linux/memremap.h>
>  #include <linux/memcontrol.h>
>  #include <linux/gfp.h>
>  #include <linux/uio.h>
> @@ -744,7 +745,7 @@ void release_pages(struct page **pages, int nr)
>  						       flags);
>  				locked_pgdat =3D NULL;
>  			}
> -			put_zone_device_private_or_public_page(page);
> +			put_devmap_managed_page(page);
>  			continue;
>  		}
>  =

> =

-- =

Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
