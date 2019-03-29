Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 307B8211EC663
 for <linux-nvdimm@lists.01.org>; Fri, 29 Mar 2019 10:47:38 -0700 (PDT)
Date: Fri, 29 Mar 2019 02:46:31 -0700
From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 6/6] mm/devm_memremap_pages: Fix final page put race
Message-ID: <20190329094630.GA6024@iweiny-DESK2.sc.intel.com>
References: <155387324370.2443841.574715745262628837.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155387327591.2443841.1024616899609926902.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <155387327591.2443841.1024616899609926902.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, akpm@linux-foundation.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 29, 2019 at 08:27:55AM -0700, Dan Williams wrote:
> Logan noticed that devm_memremap_pages_release() kills the percpu_ref
> drops all the page references that were acquired at init and then
> immediately proceeds to unplug, arch_remove_memory(), the backing pages
> for the pagemap. If for some reason device shutdown actually collides
> with a busy / elevated-ref-count page then arch_remove_memory() should
> be deferred until after that reference is dropped.
> =

> As it stands the "wait for last page ref drop" happens *after*
> devm_memremap_pages_release() returns, which is obviously too late and
> can lead to crashes.
> =

> Fix this situation by assigning the responsibility to wait for the
> percpu_ref to go idle to devm_memremap_pages() with a new ->cleanup()
> callback. Implement the new cleanup callback for all
> devm_memremap_pages() users: pmem, devdax, hmm, and p2pdma.
> =

> Reported-by: Logan Gunthorpe <logang@deltatee.com>
> Fixes: 41e94a851304 ("add devm_memremap_pages")
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: "J=E9r=F4me Glisse" <jglisse@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

For the series:

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/dax/device.c              |   13 +++----------
>  drivers/nvdimm/pmem.c             |   17 +++++++++++++----
>  drivers/pci/p2pdma.c              |   17 +++--------------
>  include/linux/memremap.h          |    2 ++
>  kernel/memremap.c                 |   17 ++++++++++++-----
>  mm/hmm.c                          |   14 +++-----------
>  tools/testing/nvdimm/test/iomap.c |    2 ++
>  7 files changed, 38 insertions(+), 44 deletions(-)
> =

> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index e428468ab661..e3aa78dd1bb0 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -27,9 +27,8 @@ static void dev_dax_percpu_release(struct percpu_ref *r=
ef)
>  	complete(&dev_dax->cmp);
>  }
>  =

> -static void dev_dax_percpu_exit(void *data)
> +static void dev_dax_percpu_exit(struct percpu_ref *ref)
>  {
> -	struct percpu_ref *ref =3D data;
>  	struct dev_dax *dev_dax =3D ref_to_dev_dax(ref);
>  =

>  	dev_dbg(&dev_dax->dev, "%s\n", __func__);
> @@ -468,18 +467,12 @@ int dev_dax_probe(struct device *dev)
>  	if (rc)
>  		return rc;
>  =

> -	rc =3D devm_add_action_or_reset(dev, dev_dax_percpu_exit, &dev_dax->ref=
);
> -	if (rc)
> -		return rc;
> -
>  	dev_dax->pgmap.ref =3D &dev_dax->ref;
>  	dev_dax->pgmap.kill =3D dev_dax_percpu_kill;
> +	dev_dax->pgmap.cleanup =3D dev_dax_percpu_exit;
>  	addr =3D devm_memremap_pages(dev, &dev_dax->pgmap);
> -	if (IS_ERR(addr)) {
> -		devm_remove_action(dev, dev_dax_percpu_exit, &dev_dax->ref);
> -		percpu_ref_exit(&dev_dax->ref);
> +	if (IS_ERR(addr))
>  		return PTR_ERR(addr);
> -	}
>  =

>  	inode =3D dax_inode(dax_dev);
>  	cdev =3D inode->i_cdev;
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index bc2f700feef8..507b9eda42aa 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -304,11 +304,19 @@ static const struct attribute_group *pmem_attribute=
_groups[] =3D {
>  	NULL,
>  };
>  =

> -static void pmem_release_queue(void *q)
> +static void __pmem_release_queue(struct percpu_ref *ref)
>  {
> +	struct request_queue *q;
> +
> +	q =3D container_of(ref, typeof(*q), q_usage_counter);
>  	blk_cleanup_queue(q);
>  }
>  =

> +static void pmem_release_queue(void *ref)
> +{
> +	__pmem_release_queue(ref);
> +}
> +
>  static void pmem_freeze_queue(struct percpu_ref *ref)
>  {
>  	struct request_queue *q;
> @@ -400,12 +408,10 @@ static int pmem_attach_disk(struct device *dev,
>  	if (!q)
>  		return -ENOMEM;
>  =

> -	if (devm_add_action_or_reset(dev, pmem_release_queue, q))
> -		return -ENOMEM;
> -
>  	pmem->pfn_flags =3D PFN_DEV;
>  	pmem->pgmap.ref =3D &q->q_usage_counter;
>  	pmem->pgmap.kill =3D pmem_freeze_queue;
> +	pmem->pgmap.cleanup =3D __pmem_release_queue;
>  	if (is_nd_pfn(dev)) {
>  		if (setup_pagemap_fsdax(dev, &pmem->pgmap))
>  			return -ENOMEM;
> @@ -426,6 +432,9 @@ static int pmem_attach_disk(struct device *dev,
>  		pmem->pfn_flags |=3D PFN_MAP;
>  		memcpy(&bb_res, &pmem->pgmap.res, sizeof(bb_res));
>  	} else {
> +		if (devm_add_action_or_reset(dev, pmem_release_queue,
> +					&q->q_usage_counter))
> +			return -ENOMEM;
>  		addr =3D devm_memremap(dev, pmem->phys_addr,
>  				pmem->size, ARCH_MEMREMAP_PMEM);
>  		memcpy(&bb_res, &nsio->res, sizeof(bb_res));
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 1b96c1688715..7ff5b8067670 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -95,7 +95,7 @@ static void pci_p2pdma_percpu_kill(struct percpu_ref *r=
ef)
>  	percpu_ref_kill(ref);
>  }
>  =

> -static void pci_p2pdma_percpu_cleanup(void *ref)
> +static void pci_p2pdma_percpu_cleanup(struct percpu_ref *ref)
>  {
>  	struct p2pdma_pagemap *p2p_pgmap =3D to_p2p_pgmap(ref);
>  =

> @@ -197,16 +197,6 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, in=
t bar, size_t size,
>  	if (error)
>  		goto pgmap_free;
>  =

> -	/*
> -	 * FIXME: the percpu_ref_exit needs to be coordinated internal
> -	 * to devm_memremap_pages_release(). Duplicate the same ordering
> -	 * as other devm_memremap_pages() users for now.
> -	 */
> -	error =3D devm_add_action(&pdev->dev, pci_p2pdma_percpu_cleanup,
> -			&p2p_pgmap->ref);
> -	if (error)
> -		goto ref_cleanup;
> -
>  	pgmap =3D &p2p_pgmap->pgmap;
>  =

>  	pgmap->res.start =3D pci_resource_start(pdev, bar) + offset;
> @@ -217,11 +207,12 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, i=
nt bar, size_t size,
>  	pgmap->pci_p2pdma_bus_offset =3D pci_bus_address(pdev, bar) -
>  		pci_resource_start(pdev, bar);
>  	pgmap->kill =3D pci_p2pdma_percpu_kill;
> +	pgmap->cleanup =3D pci_p2pdma_percpu_cleanup;
>  =

>  	addr =3D devm_memremap_pages(&pdev->dev, pgmap);
>  	if (IS_ERR(addr)) {
>  		error =3D PTR_ERR(addr);
> -		goto ref_exit;
> +		goto pgmap_free;
>  	}
>  =

>  	error =3D gen_pool_add_owner(pdev->p2pdma->pool, (unsigned long)addr,
> @@ -238,8 +229,6 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int=
 bar, size_t size,
>  =

>  pages_free:
>  	devm_memunmap_pages(&pdev->dev, pgmap);
> -ref_cleanup:
> -	percpu_ref_exit(&p2p_pgmap->ref);
>  pgmap_free:
>  	devm_kfree(&pdev->dev, p2p_pgmap);
>  	return error;
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index 7601ee314c4a..1732dea030b2 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -81,6 +81,7 @@ typedef void (*dev_page_free_t)(struct page *page, void=
 *data);
>   * @res: physical address range covered by @ref
>   * @ref: reference count that pins the devm_memremap_pages() mapping
>   * @kill: callback to transition @ref to the dead state
> + * @cleanup: callback to wait for @ref to be idle and reap it
>   * @dev: host device of the mapping for debug
>   * @data: private data pointer for page_free()
>   * @type: memory type: see MEMORY_* in memory_hotplug.h
> @@ -92,6 +93,7 @@ struct dev_pagemap {
>  	struct resource res;
>  	struct percpu_ref *ref;
>  	void (*kill)(struct percpu_ref *ref);
> +	void (*cleanup)(struct percpu_ref *ref);
>  	struct device *dev;
>  	void *data;
>  	enum memory_type type;
> diff --git a/kernel/memremap.c b/kernel/memremap.c
> index 65afbacab44e..05d1af5a2f15 100644
> --- a/kernel/memremap.c
> +++ b/kernel/memremap.c
> @@ -96,6 +96,7 @@ static void devm_memremap_pages_release(void *data)
>  	pgmap->kill(pgmap->ref);
>  	for_each_device_pfn(pfn, pgmap)
>  		put_page(pfn_to_page(pfn));
> +	pgmap->cleanup(pgmap->ref);
>  =

>  	/* pages are dead and unused, undo the arch mapping */
>  	align_start =3D res->start & ~(SECTION_SIZE - 1);
> @@ -134,8 +135,8 @@ static void devm_memremap_pages_release(void *data)
>   * 2/ The altmap field may optionally be initialized, in which case altm=
ap_valid
>   *    must be set to true
>   *
> - * 3/ pgmap->ref must be 'live' on entry and will be killed at
> - *    devm_memremap_pages_release() time, or if this routine fails.
> + * 3/ pgmap->ref must be 'live' on entry and will be killed and reaped
> + *    at devm_memremap_pages_release() time, or if this routine fails.
>   *
>   * 4/ res is expected to be a host memory range that could feasibly be
>   *    treated as a "System RAM" range, i.e. not a device mmio range, but
> @@ -151,8 +152,10 @@ void *devm_memremap_pages(struct device *dev, struct=
 dev_pagemap *pgmap)
>  	pgprot_t pgprot =3D PAGE_KERNEL;
>  	int error, nid, is_ram;
>  =

> -	if (!pgmap->ref || !pgmap->kill)
> +	if (!pgmap->ref || !pgmap->kill || !pgmap->cleanup) {
> +		WARN(1, "Missing reference count teardown definition\n");
>  		return ERR_PTR(-EINVAL);
> +	}
>  =

>  	align_start =3D res->start & ~(SECTION_SIZE - 1);
>  	align_size =3D ALIGN(res->start + resource_size(res), SECTION_SIZE)
> @@ -163,14 +166,16 @@ void *devm_memremap_pages(struct device *dev, struc=
t dev_pagemap *pgmap)
>  	if (conflict_pgmap) {
>  		dev_WARN(dev, "Conflicting mapping in same section\n");
>  		put_dev_pagemap(conflict_pgmap);
> -		return ERR_PTR(-ENOMEM);
> +		error =3D -ENOMEM;
> +		goto err_array;
>  	}
>  =

>  	conflict_pgmap =3D get_dev_pagemap(PHYS_PFN(align_end), NULL);
>  	if (conflict_pgmap) {
>  		dev_WARN(dev, "Conflicting mapping in same section\n");
>  		put_dev_pagemap(conflict_pgmap);
> -		return ERR_PTR(-ENOMEM);
> +		error =3D -ENOMEM;
> +		goto err_array;
>  	}
>  =

>  	is_ram =3D region_intersects(align_start, align_size,
> @@ -262,6 +267,8 @@ void *devm_memremap_pages(struct device *dev, struct =
dev_pagemap *pgmap)
>  	pgmap_array_delete(res);
>   err_array:
>  	pgmap->kill(pgmap->ref);
> +	pgmap->cleanup(pgmap->ref);
> +
>  	return ERR_PTR(error);
>  }
>  EXPORT_SYMBOL_GPL(devm_memremap_pages);
> diff --git a/mm/hmm.c b/mm/hmm.c
> index fe1cd87e49ac..225ade644058 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -975,9 +975,8 @@ static void hmm_devmem_ref_release(struct percpu_ref =
*ref)
>  	complete(&devmem->completion);
>  }
>  =

> -static void hmm_devmem_ref_exit(void *data)
> +static void hmm_devmem_ref_exit(struct percpu_ref *ref)
>  {
> -	struct percpu_ref *ref =3D data;
>  	struct hmm_devmem *devmem;
>  =

>  	devmem =3D container_of(ref, struct hmm_devmem, ref);
> @@ -1054,10 +1053,6 @@ struct hmm_devmem *hmm_devmem_add(const struct hmm=
_devmem_ops *ops,
>  	if (ret)
>  		return ERR_PTR(ret);
>  =

> -	ret =3D devm_add_action_or_reset(device, hmm_devmem_ref_exit, &devmem->=
ref);
> -	if (ret)
> -		return ERR_PTR(ret);
> -
>  	size =3D ALIGN(size, PA_SECTION_SIZE);
>  	addr =3D min((unsigned long)iomem_resource.end,
>  		   (1UL << MAX_PHYSMEM_BITS) - 1);
> @@ -1096,6 +1091,7 @@ struct hmm_devmem *hmm_devmem_add(const struct hmm_=
devmem_ops *ops,
>  	devmem->pagemap.ref =3D &devmem->ref;
>  	devmem->pagemap.data =3D devmem;
>  	devmem->pagemap.kill =3D hmm_devmem_ref_kill;
> +	devmem->pagemap.cleanup =3D hmm_devmem_ref_exit;
>  =

>  	result =3D devm_memremap_pages(devmem->device, &devmem->pagemap);
>  	if (IS_ERR(result))
> @@ -1133,11 +1129,6 @@ struct hmm_devmem *hmm_devmem_add_resource(const s=
truct hmm_devmem_ops *ops,
>  	if (ret)
>  		return ERR_PTR(ret);
>  =

> -	ret =3D devm_add_action_or_reset(device, hmm_devmem_ref_exit,
> -			&devmem->ref);
> -	if (ret)
> -		return ERR_PTR(ret);
> -
>  	devmem->pfn_first =3D devmem->resource->start >> PAGE_SHIFT;
>  	devmem->pfn_last =3D devmem->pfn_first +
>  			   (resource_size(devmem->resource) >> PAGE_SHIFT);
> @@ -1150,6 +1141,7 @@ struct hmm_devmem *hmm_devmem_add_resource(const st=
ruct hmm_devmem_ops *ops,
>  	devmem->pagemap.ref =3D &devmem->ref;
>  	devmem->pagemap.data =3D devmem;
>  	devmem->pagemap.kill =3D hmm_devmem_ref_kill;
> +	devmem->pagemap.cleanup =3D hmm_devmem_ref_exit;
>  =

>  	result =3D devm_memremap_pages(devmem->device, &devmem->pagemap);
>  	if (IS_ERR(result))
> diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/tes=
t/iomap.c
> index c6635fee27d8..219dd0a1cb08 100644
> --- a/tools/testing/nvdimm/test/iomap.c
> +++ b/tools/testing/nvdimm/test/iomap.c
> @@ -108,7 +108,9 @@ static void nfit_test_kill(void *_pgmap)
>  {
>  	struct dev_pagemap *pgmap =3D _pgmap;
>  =

> +	WARN_ON(!pgmap || !pgmap->ref || !pgmap->kill || !pgmap->cleanup);
>  	pgmap->kill(pgmap->ref);
> +	pgmap->cleanup(pgmap->ref);
>  }
>  =

>  void *__wrap_devm_memremap_pages(struct device *dev, struct dev_pagemap =
*pgmap)
> =

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
